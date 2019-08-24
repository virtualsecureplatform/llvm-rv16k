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

#include "InputFiles.h"
#include "Target.h"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;
using namespace llvm::ELF;
using namespace lld;
using namespace lld::elf;

namespace {

class RV16K final : public TargetInfo {
public:
  RV16K();
  RelExpr getRelExpr(RelType Type, const Symbol &S,
                     const uint8_t *Loc) const override;
  void relocateOne(uint8_t *Loc, RelType Type, uint64_t Val) const override;
};

} // end anonymous namespace

RV16K::RV16K() { NoneRel = R_RV16K_NONE; }

RelExpr RV16K::getRelExpr(const RelType Type, const Symbol &S,
                          const uint8_t *Loc) const {
  switch (Type) {
  case R_RV16K_16:
    return R_ABS;

  case R_RV16K_PC8:
  case R_RV16K_PC16:
    return R_PC;

  default:
    error("unimplemented relocation type");
  }

  assert(false);
}

void RV16K::relocateOne(uint8_t *Loc, const RelType Type,
                        const uint64_t Val) const {
  switch (Type) {
  case R_RV16K_16:
    // ELF files for RV16K have to have two address spaces for ROM and RAM,
    // which is not supported by ELF naively. Instead, in ELF's virtual
    // address space we place .text section (ROM) to 0x00000000 and .data
    // section (RAM) to 0x00010000. Since RV16K uses pc-relative relocations
    // (R_PC) only in .text, this ad-hoc approach works. But for absolute
    // relocations (R_ABS) in .data section some tricks should be made; only the
    // bottom 16 bits of the Val does matter in ROM.
    write16le(Loc, Val & 0xffff);
    break;

  case R_RV16K_PC8:
    checkAlignment(Loc, Val, 2, Type);
    write<uint8_t>(Loc, Val, llvm::support::little);
    break;

  case R_RV16K_PC16:
    checkAlignment(Loc, Val, 2, Type);
    write16le(Loc, Val);
    break;

  default:
    error(getErrorLocation(Loc) +
          "unimplemented relocation: " + toString(Type));
    return;
  }
}

TargetInfo *elf::getRV16KTargetInfo() {
  static RV16K Target;
  return &Target;
}
