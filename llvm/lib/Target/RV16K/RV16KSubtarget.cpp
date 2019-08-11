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
