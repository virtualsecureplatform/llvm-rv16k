// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16KInstrInfo.h"
#include "RV16K.h"
#include "RV16KSubtarget.h"
#include "RV16KTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_CTOR_DTOR
#include "RV16KGenInstrInfo.inc"

#define DEBUG_TYPE "rv16k-instr-info"

using namespace llvm;

RV16KInstrInfo::RV16KInstrInfo()
    : RV16KGenInstrInfo(RV16K::ADJCALLSTACKDOWN, RV16K::ADJCALLSTACKUP),
      RS(new RegScavenger()) {}

void RV16KInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                 MachineBasicBlock::iterator MBBI,
                                 const DebugLoc &DL, unsigned DstReg,
                                 unsigned SrcReg, bool KillSrc) const {
  assert(RV16K::GPRRegClass.contains(DstReg, SrcReg) &&
         "Impossible reg-to-reg copy");

  BuildMI(MBB, MBBI, DL, get(RV16K::MOV), DstReg)
      .addReg(SrcReg, getKillRegState(KillSrc));
}

void RV16KInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                         MachineBasicBlock::iterator I,
                                         unsigned SrcReg, bool IsKill, int FI,
                                         const TargetRegisterClass *RC,
                                         const TargetRegisterInfo *TRI) const {
  DebugLoc DL;
  if (I != MBB.end())
    DL = I->getDebugLoc();

  if (!RV16K::GPRRegClass.hasSubClassEq(RC))
    llvm_unreachable("Can't store this register to stack slot");

  BuildMI(MBB, I, DL, get(RV16K::SW))
      .addReg(SrcReg, getKillRegState(IsKill))
      .addFrameIndex(FI)
      .addImm(0);
}

void RV16KInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                          MachineBasicBlock::iterator I,
                                          unsigned DstReg, int FI,
                                          const TargetRegisterClass *RC,
                                          const TargetRegisterInfo *TRI) const {
  DebugLoc DL;
  if (I != MBB.end())
    DL = I->getDebugLoc();

  if (!RV16K::GPRRegClass.hasSubClassEq(RC))
    llvm_unreachable("Can't load this register from stack slot");

  BuildMI(MBB, I, DL, get(RV16K::LW), DstReg).addFrameIndex(FI).addImm(0);
}

// The contents of values added to Cond are not examined outside of
// RV16KInstrInfo, giving us flexibility in what to push to it.
static void parseCondBranch(MachineInstr &LastInst, MachineBasicBlock *&Target,
                            SmallVectorImpl<MachineOperand> &Cond) {
  // Block ends with fall-through condbranch.
  assert(LastInst.getDesc().isConditionalBranch() &&
         "Unknown conditional branch");

  // Bcc/BccI lhs, rhs, dst, condcode, implicit-def dead flags
  assert(LastInst.getOpcode() == RV16K::Bcc ||
         LastInst.getOpcode() == RV16K::BccI);
  assert(LastInst.getNumOperands() == 5);

  Target = LastInst.getOperand(2).getMBB();
  Cond.push_back(LastInst.getOperand(0));
  Cond.push_back(LastInst.getOperand(1));
  Cond.push_back(LastInst.getOperand(3));
}

// The analyzeBranch function is used to examine conditional instructions and
// remove unnecessary instructions. This method is used by BranchFolder and
// IfConverter machine function passes to improve the CFG.
// - TrueBlock is set to the destination if condition evaluates true (it is the
//   nullptr if the destination is the fall-through branch);
// - FalseBlock is set to the destination if condition evaluates to false (it
//   is the nullptr if the branch is unconditional);
// - condition is populated with machine operands needed to generate the branch
//   to insert in insertBranch;
// Returns: false if branch could successfully be analyzed.
bool RV16KInstrInfo::analyzeBranch(MachineBasicBlock &MBB,
                                   MachineBasicBlock *&TBB,
                                   MachineBasicBlock *&FBB,
                                   SmallVectorImpl<MachineOperand> &Cond,
                                   bool AllowModify) const {
  TBB = FBB = nullptr;
  assert(Cond.size() == 0);

  // If the block has no terminators, it just falls into the block after it.
  MachineBasicBlock::iterator I = MBB.getLastNonDebugInstr();
  if (I == MBB.end() || !isUnpredicatedTerminator(*I))
    return false;

  // Count the number of terminators and find the first unconditional or
  // indirect branch.
  MachineBasicBlock::iterator FirstUncondOrIndirectBr = MBB.end();
  int NumTerminators = 0;
  for (auto J = I.getReverse(); J != MBB.rend() && isUnpredicatedTerminator(*J);
       J++) {
    NumTerminators++;
    if (J->getDesc().isUnconditionalBranch() ||
        J->getDesc().isIndirectBranch()) {
      FirstUncondOrIndirectBr = J.getReverse();
    }
  }

  // If AllowModify is true, we can erase any terminators after
  // FirstUncondOrIndirectBR.
  if (AllowModify && FirstUncondOrIndirectBr != MBB.end()) {
    while (std::next(FirstUncondOrIndirectBr) != MBB.end()) {
      std::next(FirstUncondOrIndirectBr)->eraseFromParent();
      NumTerminators--;
    }
    I = FirstUncondOrIndirectBr;
  }

  // We can't handle blocks that end in an indirect branch.
  if (I->getDesc().isIndirectBranch())
    return true;

  // We can't handle blocks with more than 2 terminators.
  if (NumTerminators > 2)
    return true;

  // Handle a single unconditional branch.
  if (NumTerminators == 1 && I->getDesc().isUnconditionalBranch()) {
    TBB = I->getOperand(0).getMBB();
    return false;
  }

  // Handle a single conditional branch.
  if (NumTerminators == 1 && I->getDesc().isConditionalBranch()) {
    parseCondBranch(*I, TBB, Cond);
    return false;
  }

  // Handle a conditional branch followed by an unconditional branch.
  if (NumTerminators == 2 && std::prev(I)->getDesc().isConditionalBranch() &&
      I->getDesc().isUnconditionalBranch()) {
    parseCondBranch(*std::prev(I), TBB, Cond);
    FBB = I->getOperand(0).getMBB();
    return false;
  }

  // Otherwise, we can't handle this.
  return true;
}

// Inserts a branch into the end of the specific MachineBasicBlock, returning
// the number of instructions inserted.
unsigned RV16KInstrInfo::insertBranch(
    MachineBasicBlock &MBB, MachineBasicBlock *TBB, MachineBasicBlock *FBB,
    ArrayRef<MachineOperand> Cond, const DebugLoc &DL, int *BytesAdded) const {
  if (BytesAdded)
    *BytesAdded = 0;
  unsigned NumInserted = 0;

  // Helper function; Increment BytesAdded and NumInserted.
  auto countMI = [&](const MachineInstrBuilder &builder) -> MachineInstr & {
    MachineInstr &MI = *builder;
    if (BytesAdded)
      *BytesAdded += getInstSizeInBytes(MI);
    NumInserted++;
    return MI;
  };

  // Shouldn't be a fall through.
  assert(TBB && "InsertBranch must not be told to insert a fallthrough");
  assert((Cond.size() == 3 || Cond.size() == 0) &&
         "RV16K branch conditions have zero/three components!");

  // Unconditional branch.
  if (Cond.empty()) {
    countMI(BuildMI(&MBB, DL, get(RV16K::J)).addMBB(TBB));
    return NumInserted;
  }

  // Either a one or two-way conditional branch.
  if (Cond[0].isReg()) {
    if (Cond[1].isReg()) { // Bcc reg, reg
      countMI(BuildMI(&MBB, DL, get(RV16K::Bcc))
                  .addReg(Cond[0].getReg())
                  .addReg(Cond[1].getReg())
                  .addMBB(TBB)
                  .addImm(Cond[2].getImm()));
    } else { // BccI reg, imm
      countMI(BuildMI(&MBB, DL, get(RV16K::BccI))
                  .addReg(Cond[0].getReg())
                  .addImm(Cond[1].getImm())
                  .addMBB(TBB)
                  .addImm(Cond[2].getImm()));
    }
  } else { // BccI imm, reg (invalid form)
    assert(Cond[1].isReg());

    // This invalid use of BccI may occur when BranchRelaxation calls
    // reverseBranchCondition with BccI as argument, so we have to expand
    // it into LI and Bcc here.
    // FIXME: Tests for here.

    // From: BccI imm, reg
    // To:   LI   ScratchReg, imm
    //       Bcc  ScratchReg, reg

    MachineRegisterInfo &MRI = MBB.getParent()->getRegInfo();
    unsigned ScratchReg = MRI.createVirtualRegister(&RV16K::GPRRegClass);

    MachineInstr &MI = countMI(
        BuildMI(&MBB, DL, get(RV16K::LI), ScratchReg).addImm(Cond[0].getImm()));
    countMI(BuildMI(&MBB, DL, get(RV16K::Bcc))
                .addReg(ScratchReg, RegState::Kill)
                .addReg(Cond[1].getReg())
                .addMBB(TBB)
                .addImm(Cond[2].getImm()));

    RS->enterBasicBlockEnd(MBB);
    unsigned Scav = RS->scavengeRegisterBackwards(
        RV16K::GPRRegClass, MachineBasicBlock::iterator(MI),
        /* RestoreAfter */ false, /* SPAd */ 0);
    MRI.replaceRegWith(ScratchReg, Scav);
  }

  // One-way conditional branch.
  if (!FBB)
    return NumInserted;

  // Two-way conditional branch.
  countMI(BuildMI(&MBB, DL, get(RV16K::J)).addMBB(FBB));
  return NumInserted;
}

// Insert the branch with condition specified in condition and given targets
// (TrueBlock and FalseBlock). This function returns the number of machine
// instructions inserted.
unsigned RV16KInstrInfo::removeBranch(MachineBasicBlock &MBB,
                                      int *BytesRemoved) const {
  if (BytesRemoved)
    *BytesRemoved = 0;

  MachineBasicBlock::iterator I = MBB.getLastNonDebugInstr();
  if (I == MBB.end())
    return 0;

  if (!I->getDesc().isUnconditionalBranch() &&
      !I->getDesc().isConditionalBranch())
    return 0;

  // Remove the branch.
  I->eraseFromParent();
  if (BytesRemoved)
    *BytesRemoved += getInstSizeInBytes(*I);

  I = MBB.end();

  if (I == MBB.begin())
    return 1;
  --I;
  if (!I->getDesc().isConditionalBranch())
    return 1;

  // Remove the branch.
  I->eraseFromParent();
  if (BytesRemoved)
    *BytesRemoved += getInstSizeInBytes(*I);

  return 2;
}

bool RV16KInstrInfo::reverseBranchCondition(
    SmallVectorImpl<MachineOperand> &Cond) const {
  using std::swap;

  assert((Cond.size() == 3) && "Invalid branch condition!");

  bool Swap = false;
  RV16K::CondCode CC;

  switch (Cond[2].getImm()) {
  default:
    llvm_unreachable("Invalid cond code");
  case RV16K::COND_E:
    CC = RV16K::COND_NE;
    break;
  case RV16K::COND_NE:
    CC = RV16K::COND_E;
    break;
  case RV16K::COND_L:
    Swap = true;
    CC = RV16K::COND_LE;
    break;
  case RV16K::COND_LE:
    Swap = true;
    CC = RV16K::COND_L;
    break;
  case RV16K::COND_B:
    Swap = true;
    CC = RV16K::COND_BE;
    break;
  case RV16K::COND_BE:
    Swap = true;
    CC = RV16K::COND_B;
    break;
  }

  Cond[2].setImm(CC);
  if (Swap)
    swap(Cond[0], Cond[1]);

  return false;
}

unsigned RV16KInstrInfo::getInstSizeInBytes(const MachineInstr &MI) const {
  unsigned Opcode = MI.getOpcode();
  switch (Opcode) {
  default:
    return get(Opcode).getSize();

  case TargetOpcode::EH_LABEL:
  case TargetOpcode::IMPLICIT_DEF:
  case TargetOpcode::KILL:
  case TargetOpcode::DBG_VALUE:
    return 0;

  case TargetOpcode::INLINEASM: {
    const MachineFunction &MF = *MI.getParent()->getParent();
    const auto &TM = static_cast<const RV16KTargetMachine &>(MF.getTarget());
    return getInlineAsmLength(MI.getOperand(0).getSymbolName(),
                              *TM.getMCAsmInfo());
  }
  }
}

bool RV16KInstrInfo::isBranchOffsetInRange(unsigned BranchOp,
                                           int64_t BrOffset) const {
  // We don't have to handle Jcc instructions here; branch analysis (and other
  // relevant operations) will be processed only on Bcc/BccI pseudo
  // instructions.

  switch (BranchOp) {
  default:
    llvm_unreachable("Unexpected opcode!");

  case RV16K::Bcc:
  case RV16K::BccI:
    return isInt<8>(BrOffset - 2);

  case RV16K::J:
  case RV16K::JAL:
    return isInt<16>(BrOffset);
  }
}

MachineBasicBlock *
RV16KInstrInfo::getBranchDestBlock(const MachineInstr &MI) const {
  assert(MI.getDesc().isBranch() && "unexpected opcode!");

  switch (MI.getOpcode()) {
  case RV16K::Bcc:
  case RV16K::BccI:
    return MI.getOperand(2).getMBB();

  default:
    return MI.getOperand(MI.getNumExplicitOperands() - 1).getMBB();
  }
}
