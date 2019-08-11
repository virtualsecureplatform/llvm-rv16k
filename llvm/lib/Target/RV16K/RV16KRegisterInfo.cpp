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
  report_fatal_error("Subroutines not supported yet");
}

unsigned RV16KRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return RV16K::X2;
}
