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
  // TODO: this implementation is a temporary placeholder which does just
  // enough to allow other aspects of code generation to be tested

  assert(SPAdj == 0 && "Unexpected non-zero SPAdj value");

  MachineInstr &MI = *II;
  MachineFunction &MF = *MI.getParent()->getParent();
  DebugLoc DL = MI.getDebugLoc();

  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
  unsigned FrameReg;
  int Offset =
      getFrameLowering(MF)->getFrameIndexReference(MF, FrameIndex, FrameReg) +
      MI.getOperand(FIOperandNum + 1).getImm();
  assert(MF.getSubtarget().getFrameLowering()->hasFP(MF) &&
         "eliminateFrameIndex currently requires hasFP");

  // Offsets must be directly encoded in a 16-bit immediate field
  if (!isInt<16>(Offset)) {
    report_fatal_error(
        "Frame offsets outside of the signed 16-bit range not supported");
  }

  MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false);
  MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
}

unsigned RV16KRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return RV16K::X2;
}

const uint32_t *
RV16KRegisterInfo::getCallPreservedMask(const MachineFunction & /*MF*/,
                                        CallingConv::ID /*CC*/) const {
  return CSR_RegMask;
}
