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

#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

namespace llvm {
Target &getTheRV16KTarget() {
  static Target TheRV16KTarget;
  return TheRV16KTarget;
}
} // namespace llvm

extern "C" void LLVMInitializeRV16KTargetInfo() {
  RegisterTarget<Triple::rv16k> X(getTheRV16KTarget(), "rv16k", "RV16K",
                                  "RV16K");
}

// FIXME: Temporary stub - this function must be defined for linking
// to succeed and will be called unconditionally by llc, so must be a no-op.
// Remove once this function is properly implemented.
extern "C" void LLVMInitializeRV16KTargetMC() {}
