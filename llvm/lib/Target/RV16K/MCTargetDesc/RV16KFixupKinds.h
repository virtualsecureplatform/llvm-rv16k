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

#ifndef LLVM_LIB_TARGET_RV16K_MCTARGETDESC_RV16KFIXUPKINDS_H
#define LLVM_LIB_TARGET_RV16K_MCTARGETDESC_RV16KFIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

#undef RV16K

namespace llvm {
namespace RV16K {
enum Fixups {
  // 16-bit pc relative. e.g. j, jal
  fixup_rv16k_pcrel_16bit = FirstTargetFixupKind,
  // 8-bit pc relative. e.g. jl, jle
  fixup_rv16k_pcrel_8bit,

  // fixup_rv16k_invalid - used as a sentinel and a marker, must be last fixup
  fixup_rv16k_invalid,
  NumTargetFixupKinds = fixup_rv16k_invalid - FirstTargetFixupKind
};
} // end namespace RV16K
} // end namespace llvm

#endif
