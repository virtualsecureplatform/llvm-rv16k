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

#include "MCTargetDesc/RV16KFixupKinds.h"
#include "MCTargetDesc/RV16KMCTargetDesc.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

#define DEBUG_TYPE "elfobjectwriter"

using namespace llvm;

namespace {
class RV16KELFObjectWriter : public MCELFObjectTargetWriter {
public:
  RV16KELFObjectWriter(uint8_t OSABI);

  ~RV16KELFObjectWriter() override;

protected:
  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;
};
} // namespace

RV16KELFObjectWriter::RV16KELFObjectWriter(uint8_t OSABI)
    : MCELFObjectTargetWriter(false, OSABI, ELF::EM_RV16K,
                              /*HasRelocationAddend*/ true) {}

RV16KELFObjectWriter::~RV16KELFObjectWriter() {}

unsigned RV16KELFObjectWriter::getRelocType(MCContext &Ctx,
                                            const MCValue &Target,
                                            const MCFixup &Fixup,
                                            bool IsPCRel) const {
  // Determine the type of the relocation
  switch ((unsigned)Fixup.getKind()) {
  default:
    llvm_unreachable("invalid fixup kind!");
  case FK_Data_2:
    return ELF::R_RV16K_16;
  case RV16K::fixup_rv16k_pcrel_8bit:
    return ELF::R_RV16K_PC8;
  case RV16K::fixup_rv16k_pcrel_16bit:
    return ELF::R_RV16K_PC16;
  }
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createRV16KELFObjectWriter(uint8_t OSABI) {
  return llvm::make_unique<RV16KELFObjectWriter>(OSABI);
}
