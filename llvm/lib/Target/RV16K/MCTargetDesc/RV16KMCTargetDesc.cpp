// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16KMCTargetDesc.h"
#include "InstPrinter/RV16KInstPrinter.h"
#include "RV16KMCAsmInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_MC_DESC
#include "RV16KGenInstrInfo.inc"

#define GET_REGINFO_MC_DESC
#include "RV16KGenRegisterInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "RV16KGenSubtargetInfo.inc"

using namespace llvm;

static MCAsmInfo *createRV16KMCAsmInfo(const MCRegisterInfo &MRI,
                                       const Triple &TT) {
  return new RV16KMCAsmInfo(TT);
}

static MCInstrInfo *createRV16KMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitRV16KMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createRV16KMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();

  // X0 is the return address register.
  InitRV16KMCRegisterInfo(X, RV16K::X0);

  return X;
}

static MCSubtargetInfo *
createRV16KMCSubtargetInfo(const Triple &TT, StringRef CPU, StringRef FS) {
  std::string CPUName = CPU;
  if (CPUName.empty())
    CPUName = "generic-rv16k";
  return createRV16KMCSubtargetInfoImpl(TT, CPUName, FS);
}

static MCInstPrinter *createRV16KMCInstPrinter(const Triple &T,
                                               unsigned SyntaxVariant,
                                               const MCAsmInfo &MAI,
                                               const MCInstrInfo &MII,
                                               const MCRegisterInfo &MRI) {
  return new RV16KInstPrinter(MAI, MII, MRI);
}

extern "C" void LLVMInitializeRV16KTargetMC() {
  Target &T = getTheRV16KTarget();

  TargetRegistry::RegisterMCAsmInfo(T, createRV16KMCAsmInfo);
  TargetRegistry::RegisterMCInstrInfo(T, createRV16KMCInstrInfo);
  TargetRegistry::RegisterMCRegInfo(T, createRV16KMCRegisterInfo);
  TargetRegistry::RegisterMCSubtargetInfo(T, createRV16KMCSubtargetInfo);
  TargetRegistry::RegisterMCInstPrinter(T, createRV16KMCInstPrinter);

  TargetRegistry::RegisterMCAsmBackend(T, createRV16KAsmBackend);
  TargetRegistry::RegisterMCCodeEmitter(T, createRV16KMCCodeEmitter);
}
