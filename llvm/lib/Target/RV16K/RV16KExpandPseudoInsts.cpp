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

#include "RV16K.h"
#include "RV16KInstrInfo.h"
#include "RV16KTargetMachine.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

namespace {

class RV16KExpandPseudo : public MachineFunctionPass {
private:
  const RV16KInstrInfo *TII;

public:
  static char ID;

  RV16KExpandPseudo() : MachineFunctionPass(ID) {}

  bool runOnMachineFunction(MachineFunction &MF) override;

private:
  // Expand Bcc/BccI pseudo instructions.
  // FIXME: This might be too late for, say, peephole optimizations.
  bool expandBccPseudo(MachineBasicBlock &MBB,
                       MachineBasicBlock::iterator &MBBI) const;
};
} // end of anonymous namespace

char RV16KExpandPseudo::ID = 0;

INITIALIZE_PASS(RV16KExpandPseudo, "rv16k-expand-pseudo",
                "RV16K pseudo instruction expansion pass", false, false)

bool RV16KExpandPseudo::runOnMachineFunction(MachineFunction &MF) {
  TII = static_cast<const RV16KInstrInfo *>(MF.getSubtarget().getInstrInfo());

  bool Modified = false;
  for (MachineBasicBlock &MBB : MF) {
    for (auto MBBI = MBB.begin(); MBBI != MBB.end(); ++MBBI) {
      Modified |= expandBccPseudo(MBB, MBBI);
    }
  }
  return Modified;
}

bool RV16KExpandPseudo::expandBccPseudo(
    MachineBasicBlock &MBB, MachineBasicBlock::iterator &MBBI) const {
  MachineInstr &MI = *MBBI;

  unsigned Opc = MI.getOpcode();
  if (Opc != RV16K::Bcc && Opc != RV16K::BccI)
    return false;

  DebugLoc DL = MI.getDebugLoc();

  if (Opc == RV16K::Bcc) {
    BuildMI(MBB, MBBI, DL, TII->get(RV16K::CMP))
        .addReg(MI.getOperand(0).getReg())
        .addReg(MI.getOperand(1).getReg());
  } else {
    assert(Opc == RV16K::BccI);

    BuildMI(MBB, MBBI, DL, TII->get(RV16K::CMPI))
        .addReg(MI.getOperand(0).getReg())
        .addImm(MI.getOperand(1).getImm());
  }

  unsigned JccOpc;
  switch (MI.getOperand(3).getImm()) {
  default:
    llvm_unreachable("Invalid cond code");
  case RV16K::COND_L:
    JccOpc = RV16K::JL;
    break;
  case RV16K::COND_LE:
    JccOpc = RV16K::JLE;
    break;
  case RV16K::COND_E:
    JccOpc = RV16K::JE;
    break;
  case RV16K::COND_NE:
    JccOpc = RV16K::JNE;
    break;
  case RV16K::COND_B:
    JccOpc = RV16K::JB;
    break;
  case RV16K::COND_BE:
    JccOpc = RV16K::JBE;
    break;
  }

  BuildMI(MBB, MBBI, DL, TII->get(JccOpc)).addMBB(MI.getOperand(2).getMBB());

  MBBI = MBB.erase(MI);

  return true;
}

FunctionPass *llvm::createRV16KExpandPseudoPass() {
  return new RV16KExpandPseudo();
}
