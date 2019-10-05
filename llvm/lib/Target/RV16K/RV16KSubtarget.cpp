// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16KSubtarget.h"
#include "RV16K.h"
#include "RV16KFrameLowering.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "rv16k-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "RV16KGenSubtargetInfo.inc"

void RV16KSubtarget::anchor() {}

RV16KSubtarget &RV16KSubtarget::initializeSubtargetDependencies(StringRef CPU,
                                                                StringRef FS) {
  // Determine default and user-specified characteristics
  std::string CPUName = CPU;
  if (CPUName.empty())
    CPUName = "generic-rv16k";
  ParseSubtargetFeatures(CPUName, FS);
  return *this;
}

RV16KSubtarget::RV16KSubtarget(const Triple &TT, const std::string &CPU,
                               const std::string &FS, const TargetMachine &TM)
    : RV16KGenSubtargetInfo(TT, CPU, FS),
      FrameLowering(initializeSubtargetDependencies(CPU, FS)), InstrInfo(),
      RegInfo(getHwMode()), TLInfo(TM, *this) {}
