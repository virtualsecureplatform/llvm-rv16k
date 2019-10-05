// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

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
