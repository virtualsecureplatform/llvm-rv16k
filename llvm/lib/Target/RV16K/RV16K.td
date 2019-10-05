// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Registers, calling conventions, instruction descriptions.
//===----------------------------------------------------------------------===//

include "RV16KRegisterInfo.td"
include "RV16KCallingConv.td"
include "RV16KInstrInfo.td"

//===----------------------------------------------------------------------===//
// RV16K processors supported.
//===----------------------------------------------------------------------===//

def : ProcessorModel<"generic-rv16k", NoSchedModel, []>;

//===----------------------------------------------------------------------===//
// Define the RV16K target.
//===----------------------------------------------------------------------===//

def RV16KInstrInfo : InstrInfo {
  let guessInstructionProperties = 0;
}

def RV16KAsmParser : AsmParser {
  // Use alternative names of registers when emitting.
  let ShouldEmitMatchRegisterAltName = 1;
}

def RV16K : Target {
  let InstructionSet = RV16KInstrInfo;
  let AssemblyParsers = [RV16KAsmParser];
  let AllowRegisterRenaming = 1;
}
