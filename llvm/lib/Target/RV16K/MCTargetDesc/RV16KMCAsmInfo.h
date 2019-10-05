// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#ifndef LLVM_LIB_TARGET_RV16K_MCTARGETDESC_RV16KMCASMINFO_H
#define LLVM_LIB_TARGET_RV16K_MCTARGETDESC_RV16KMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class RV16KMCAsmInfo : public MCAsmInfoELF {
  // This function MUST BE placed here to reduce the size of object files.
  // See also:
  // https://stackoverflow.com/questions/16801222/out-of-line-virtual-method
  void anchor() override;

public:
  explicit RV16KMCAsmInfo(const Triple &TargetTriple);
};

} // namespace llvm

#endif
