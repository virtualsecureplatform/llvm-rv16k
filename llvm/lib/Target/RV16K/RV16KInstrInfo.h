// Copyright 2019 Ryotaro Banno, Kotaro Matsuoka, Naoki Matsumoto
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
