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
