// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#ifndef LLVM_LIB_TARGET_RV16K_RV16KINSTRINFO_H
#define LLVM_LIB_TARGET_RV16K_RV16KINSTRINFO_H

#include "RV16KRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "RV16KGenInstrInfo.inc"

namespace llvm {

class RV16KInstrInfo : public RV16KGenInstrInfo {
private:
  std::unique_ptr<RegScavenger> RS;

public:
  RV16KInstrInfo();

  void copyPhysReg(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
                   const DebugLoc &DL, unsigned DstReg, unsigned SrcReg,
                   bool KillSrc) const override;
  void storeRegToStackSlot(MachineBasicBlock &MBB,
                           MachineBasicBlock::iterator I, unsigned SrcReg,
                           bool IsKill, int FI, const TargetRegisterClass *RC,
                           const TargetRegisterInfo *TRI) const override;
  void loadRegFromStackSlot(MachineBasicBlock &MBB,
                            MachineBasicBlock::iterator I, unsigned DstReg,
                            int FI, const TargetRegisterClass *RC,
                            const TargetRegisterInfo *TRI) const override;

  bool analyzeBranch(MachineBasicBlock &MBB, MachineBasicBlock *&TBB,
                     MachineBasicBlock *&FBB,
                     SmallVectorImpl<MachineOperand> &Cond,
                     bool AllowModify) const override;
  unsigned insertBranch(MachineBasicBlock &MBB, MachineBasicBlock *TBB,
                        MachineBasicBlock *FBB, ArrayRef<MachineOperand> Cond,
                        const DebugLoc &dl,
                        int *BytesAdded = nullptr) const override;
  unsigned removeBranch(MachineBasicBlock &MBB,
                        int *BytesRemoved = nullptr) const override;
  bool
  reverseBranchCondition(SmallVectorImpl<MachineOperand> &Cond) const override;

  unsigned getInstSizeInBytes(const MachineInstr &MI) const override;
  bool isBranchOffsetInRange(unsigned BranchOpc,
                             int64_t BrOffset) const override;
  MachineBasicBlock *getBranchDestBlock(const MachineInstr &MI) const override;
};

namespace RV16K {

enum CondCode {
  COND_L = 0,
  COND_LE = 1,
  COND_E = 2,
  COND_NE = 3,
  COND_B = 4,
  COND_BE = 5,

  LAST_VALID_COND = COND_BE,

  COND_INVALID
};

} // namespace RV16K

} // namespace llvm

#endif
