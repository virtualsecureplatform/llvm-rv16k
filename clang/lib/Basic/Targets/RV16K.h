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

#ifndef LLVM_CLANG_LIB_BASIC_TARGETS_RV16K_H
#define LLVM_CLANG_LIB_BASIC_TARGETS_RV16K_H

#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/TargetOptions.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Support/Compiler.h"

namespace clang {
namespace targets {

// RV16K Target
class LLVM_LIBRARY_VISIBILITY RV16KTargetInfo : public TargetInfo {
protected:
  std::string ABI;

public:
  RV16KTargetInfo(const llvm::Triple &Triple, const TargetOptions &)
      : TargetInfo(Triple) {
    TLSSupported = false;
    PointerWidth = 16;
    PointerAlign = 16;
    IntWidth = 16;
    IntAlign = 16;
    LongWidth = 32;
    LongAlign = 16;
    LongLongWidth = 32;
    LongLongAlign = 16;
    SuitableAlign = 16;
    DefaultAlignForAttributeAligned = 16;
    HalfWidth = 8;
    HalfAlign = 8;
    FloatWidth = 32;
    FloatAlign = 16;
    DoubleWidth = 32;
    DoubleAlign = 16;
    DoubleFormat = &llvm::APFloat::IEEEsingle();
    LongDoubleWidth = 32;
    LongDoubleAlign = 16;
    LongDoubleFormat = &llvm::APFloat::IEEEsingle();
    SizeType = UnsignedInt;
    PtrDiffType = SignedInt;
    IntPtrType = SignedInt;
    Char16Type = UnsignedInt;
    WIntType = SignedInt;
    Char32Type = UnsignedLong;
    SigAtomicType = SignedChar;

    resetDataLayout("e"        // Little endian
                    "-m:e"     // ELF name manging
                    "-p:16:16" // 16-bit pointers, 16 bit aligned
                    "-i16:16"  // 16 bit integers, 16 bit aligned
                    "-n16"     // 16 bit native integer width
                    "-S16"     // 16 bit natural stack alignment
    );
  }

  void getTargetDefines(const LangOptions &Opts,
                        MacroBuilder &Builder) const override;

  ArrayRef<Builtin::Info> getTargetBuiltins() const override { return None; }

  BuiltinVaListKind getBuiltinVaListKind() const override {
    return TargetInfo::VoidPtrBuiltinVaList;
  }

  const char *getClobbers() const override { return ""; }

  ArrayRef<const char *> getGCCRegNames() const override;

  ArrayRef<TargetInfo::GCCRegAlias> getGCCRegAliases() const override;

  bool validateAsmConstraint(const char *&Name,
                             TargetInfo::ConstraintInfo &Info) const override {
    return false;
  }
};
} // namespace targets
} // namespace clang

#endif // LLVM_CLANG_LIB_BASIC_TARGETS_RV16K_H
