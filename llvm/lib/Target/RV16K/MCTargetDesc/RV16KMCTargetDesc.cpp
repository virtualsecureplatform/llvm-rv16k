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

#include "RV16KMCTargetDesc.h"
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

static MCAsmInfo *createRV16KMCAsmInfo(const MCRegisterInfo &MRI,
                                       const Triple &TT) {
  return new RV16KMCAsmInfo(TT);
}

static MCSubtargetInfo *
createRV16KMCSubtargetInfo(const Triple &TT, StringRef CPU, StringRef FS) {
  std::string CPUName = CPU;
  if (CPUName.empty())
    CPUName = "generic-rv16k";
  return createRV16KMCSubtargetInfoImpl(TT, CPUName, FS);
}

extern "C" void LLVMInitializeRV16KTargetMC() {
  Target &T = getTheRV16KTarget();
  TargetRegistry::RegisterMCAsmInfo(T, createRV16KMCAsmInfo);
  TargetRegistry::RegisterMCInstrInfo(T, createRV16KMCInstrInfo);
  TargetRegistry::RegisterMCRegInfo(T, createRV16KMCRegisterInfo);
  TargetRegistry::RegisterMCAsmBackend(T, createRV16KAsmBackend);
  TargetRegistry::RegisterMCSubtargetInfo(T, createRV16KMCSubtargetInfo);
  TargetRegistry::RegisterMCCodeEmitter(T, createRV16KMCCodeEmitter);
}
