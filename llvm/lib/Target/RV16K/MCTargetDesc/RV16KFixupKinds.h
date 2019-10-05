// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

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
