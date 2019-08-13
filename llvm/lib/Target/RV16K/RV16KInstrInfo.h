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
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "RV16KGenInstrInfo.inc"

namespace llvm {

class RV16KInstrInfo : public RV16KGenInstrInfo {

public:
  RV16KInstrInfo();

  void copyPhysReg(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
                   const DebugLoc &DL, unsigned DstReg, unsigned SrcReg,
                   bool KillSrc) const override;
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
