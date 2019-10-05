// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

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
  }
  llvm_unreachable("unimplemented relocation type");
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
