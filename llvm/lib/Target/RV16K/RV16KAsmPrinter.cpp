// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "InstPrinter/RV16KInstPrinter.h"
#include "RV16K.h"
#include "RV16KTargetMachine.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "asm-printer"

namespace {
class RV16KAsmPrinter : public AsmPrinter {
public:
  explicit RV16KAsmPrinter(TargetMachine &TM,
                           std::unique_ptr<MCStreamer> Streamer)
      : AsmPrinter(TM, std::move(Streamer)) {}

  StringRef getPassName() const override { return "RV16K Assembly Printer"; }

  void EmitInstruction(const MachineInstr *MI) override;

  bool PrintAsmOperand(const MachineInstr *MI, unsigned OpNo,
                       unsigned AsmVariant, const char *ExtraCode,
                       raw_ostream &OS) override;
  bool PrintAsmMemoryOperand(const MachineInstr *MI, unsigned OpNo,
                             unsigned AsmVariant, const char *ExtraCode,
                             raw_ostream &OS) override;

  // TableGen'erated function.
  bool emitPseudoExpansionLowering(MCStreamer &OutStreamer,
                                   const MachineInstr *MI);

  // Wrapper needed for tblgenned pseudo lowering.
  bool lowerOperand(const MachineOperand &MO, MCOperand &MCOp) const {
    return LowerRV16KMachineOperandToMCOperand(MO, MCOp, *this);
  }
};
} // namespace

// Simple pseudo-instructions have their lowering (with expansion to real
// instructions) auto-generated.
#include "RV16KGenMCPseudoLowering.inc"

void RV16KAsmPrinter::EmitInstruction(const MachineInstr *MI) {
  // Do any auto-generated pseudo lowerings.
  if (emitPseudoExpansionLowering(*OutStreamer, MI))
    return;

  MCInst TmpInst;
  LowerRV16KMachineInstrToMCInst(MI, TmpInst, *this);
  EmitToStreamer(*OutStreamer, TmpInst);
}

bool RV16KAsmPrinter::PrintAsmOperand(const MachineInstr *MI, unsigned OpNo,
                                      unsigned AsmVariant,
                                      const char *ExtraCode, raw_ostream &OS) {
  if (AsmVariant != 0)
    report_fatal_error("There are no defined alternate asm variants");

  // First try the generic code, which knows about modifiers like 'c' and 'n'.
  if (!AsmPrinter::PrintAsmOperand(MI, OpNo, AsmVariant, ExtraCode, OS))
    return false;

  if (!ExtraCode) {
    const MachineOperand &MO = MI->getOperand(OpNo);
    switch (MO.getType()) {
    case MachineOperand::MO_Immediate:
      OS << MO.getImm();
      return false;
    case MachineOperand::MO_Register:
      OS << RV16KInstPrinter::getRegisterName(MO.getReg());
      return false;
    default:
      break;
    }
  }

  return true;
}

bool RV16KAsmPrinter::PrintAsmMemoryOperand(const MachineInstr *MI,
                                            unsigned OpNo, unsigned AsmVariant,
                                            const char *ExtraCode,
                                            raw_ostream &OS) {
  if (AsmVariant != 0)
    report_fatal_error("There are no defined alternate asm variants");

  if (!ExtraCode) {
    const MachineOperand &MO = MI->getOperand(OpNo);
    // For now, we only support register memory operands in registers and
    // assume there is no addend
    if (!MO.isReg())
      return true;

    OS << "0(" << RV16KInstPrinter::getRegisterName(MO.getReg()) << ")";
    return false;
  }

  return AsmPrinter::PrintAsmMemoryOperand(MI, OpNo, AsmVariant, ExtraCode, OS);
}

// Force static initialization.
extern "C" void LLVMInitializeRV16KAsmPrinter() {
  RegisterAsmPrinter<RV16KAsmPrinter> X(getTheRV16KTarget());
}
