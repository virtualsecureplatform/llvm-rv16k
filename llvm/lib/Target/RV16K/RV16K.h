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

#ifndef LLVM_LIB_TARGET_RV16K_RV16K_H
#define LLVM_LIB_TARGET_RV16K_RV16K_H

#include "MCTargetDesc/RV16KMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class RV16KTargetMachine;
class AsmPrinter;
class FunctionPass;
class MCInst;
class MCOperand;
class MachineInstr;
class MachineOperand;

void LowerRV16KMachineInstrToMCInst(const MachineInstr *MI, MCInst &OutMI,
                                    const AsmPrinter &AP);
bool LowerRV16KMachineOperandToMCOperand(const MachineOperand &MO,
                                         MCOperand &MCOp, const AsmPrinter &AP);

FunctionPass *createRV16KISelDag(RV16KTargetMachine &TM);

FunctionPass *createRV16KUseLWSPSWSPPass();
void initializeRV16KUseLWSPSWSPPass(PassRegistry &);

FunctionPass *createRV16KExpandPseudoPass();
void initializeRV16KExpandPseudoPass(PassRegistry &);
} // namespace llvm

#endif
