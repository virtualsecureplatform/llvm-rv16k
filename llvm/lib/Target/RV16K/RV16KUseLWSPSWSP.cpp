// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16K.h"
#include "RV16KTargetMachine.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

namespace {

struct RV16KUseLWSPSWSP : public MachineFunctionPass {
  static char ID;

  RV16KUseLWSPSWSP() : MachineFunctionPass(ID) {}

  bool runOnMachineFunction(MachineFunction &Fn) override;
};
} // end anonymous namespace

char RV16KUseLWSPSWSP::ID = 0;

INITIALIZE_PASS(RV16KUseLWSPSWSP, "rv16k-use-lwsp-swsp", "RV16K Use LWSP/SWSP",
                false, false)

bool RV16KUseLWSPSWSP::runOnMachineFunction(MachineFunction &MF) {
  for (MachineBasicBlock &MBB : MF) {
    for (MachineInstr &MI : MBB) {
      unsigned Opc = MI.getOpcode();

      // Use lwsp whenever possible.
      if (Opc == RV16K::LW && MI.getOperand(1).getReg() == RV16K::X1 &&
          isShiftedUInt<8, 1>(MI.getOperand(2).getImm())) {
        const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
        MI.setDesc(TII.get(RV16K::LWSP));
      }

      // Use swsp whenever possible.
      if (Opc == RV16K::SW && MI.getOperand(1).getReg() == RV16K::X1 &&
          isShiftedUInt<8, 1>(MI.getOperand(2).getImm())) {
        const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
        MI.setDesc(TII.get(RV16K::SWSP));
      }
    }
  }

  return true;
}

FunctionPass *llvm::createRV16KUseLWSPSWSPPass() {
  return new RV16KUseLWSPSWSP();
}
