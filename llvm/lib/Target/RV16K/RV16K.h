// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

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
