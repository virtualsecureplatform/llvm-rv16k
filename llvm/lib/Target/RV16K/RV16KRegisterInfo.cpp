// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16KRegisterInfo.h"
#include "RV16K.h"
#include "RV16KSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/ErrorHandling.h"

#define GET_REGINFO_TARGET_DESC
#include "RV16KGenRegisterInfo.inc"

#define DEBUG_TYPE "rv16k-registerinfo"

using namespace llvm;

RV16KRegisterInfo::RV16KRegisterInfo(unsigned HwMode)
    : RV16KGenRegisterInfo(/* RA */ RV16K::X0, /*DwarfFlavour*/ 0,
                           /*EHFlavor*/ 0,
                           /*PC*/ 0, HwMode) {}

const MCPhysReg *
RV16KRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return CSR_SaveList;
}

BitVector RV16KRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  // Use markSuperRegs to ensure any register aliases are also reserved
  markSuperRegs(Reserved, RV16K::X0); // ra
  markSuperRegs(Reserved, RV16K::X1); // sp
  markSuperRegs(Reserved, RV16K::X2); // fp
  assert(checkAllSuperRegsMarked(Reserved));
  return Reserved;
}

void RV16KRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                            int SPAdj, unsigned FIOperandNum,
                                            RegScavenger *RS) const {
  assert(SPAdj == 0 && "Unexpected non-zero SPAdj value");

  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  DebugLoc DL = MI.getDebugLoc();

  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
  unsigned FrameReg;
  int Offset =
      getFrameLowering(MF)->getFrameIndexReference(MF, FrameIndex, FrameReg) +
      MI.getOperand(FIOperandNum + 1).getImm();

  // Offsets must be directly encoded in a 16-bit immediate field
  if (!isInt<16>(Offset)) {
    report_fatal_error(
        "Frame offsets outside of the signed 16-bit range not supported");
  }

  // This is actually "load effective address" of the stack slot
  // instruction. We have only two-address instructions, thus we need to
  // expand it into move + add.
  if (MI.getOpcode() == RV16K::FRMIDX) {
    // From: FRMIDX rd, FrameIndex, imm
    // To  : LI     rd, imm
    //       ADD    rd, FrameReg

    const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
    MachineBasicBlock &MBB = *MI.getParent();
    unsigned DstReg = MI.getOperand(0).getReg();

    // Santiy checks.
    assert(DstReg != FrameReg);
    assert(FIOperandNum == 1);

    if (Offset == 0) {
      // MOV rd, FrameReg
      MI.setDesc(TII.get(RV16K::MOV));
      MI.getOperand(1).ChangeToRegister(FrameReg, false);
      MI.RemoveOperand(2);
      return;
    }

    // LI rd, imm
    MI.setDesc(TII.get(RV16K::LI));
    MI.getOperand(1).ChangeToImmediate(Offset);
    MI.RemoveOperand(2);

    II++; // Skip over the FRMIDX (and now LI) instruction.

    // ADD rd, FrameReg
    MachineInstr *New = BuildMI(MBB, II, DL, TII.get(RV16K::ADD), DstReg)
                            .addReg(DstReg, RegState::Kill)
                            .addReg(FrameReg);
    New->getOperand(3).setIsDead();

    return;
  }

  MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false);
  MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
}

unsigned RV16KRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  const TargetFrameLowering *TFI = getFrameLowering(MF);
  // Return FP if any, SP otherwise.
  return TFI->hasFP(MF) ? RV16K::X2 : RV16K::X1;
}

const uint32_t *
RV16KRegisterInfo::getCallPreservedMask(const MachineFunction & /*MF*/,
                                        CallingConv::ID /*CC*/) const {
  return CSR_RegMask;
}
