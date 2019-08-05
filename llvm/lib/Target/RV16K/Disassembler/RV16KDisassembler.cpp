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

#include "MCTargetDesc/RV16KMCTargetDesc.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCFixedLenDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "rv32k-disassembler"

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {
class RV16KDisassembler : public MCDisassembler {

public:
  RV16KDisassembler(const MCSubtargetInfo &STI, MCContext &Ctx)
      : MCDisassembler(STI, Ctx) {}

  DecodeStatus getInstruction(MCInst &Instr, uint64_t &Size,
                              ArrayRef<uint8_t> Bytes, uint64_t Address,
                              raw_ostream &VStream,
                              raw_ostream &CStream) const override;
};
} // end anonymous namespace

static MCDisassembler *createRV16KDisassembler(const Target &T,
                                               const MCSubtargetInfo &STI,
                                               MCContext &Ctx) {
  return new RV16KDisassembler(STI, Ctx);
}

extern "C" void LLVMInitializeRV16KDisassembler() {
  TargetRegistry::RegisterMCDisassembler(getTheRV16KTarget(),
                                         createRV16KDisassembler);
}

static const unsigned GPRDecoderTable[] = {
    RV16K::X0,  RV16K::X1,  RV16K::X2,  RV16K::X3, RV16K::X4,  RV16K::X5,
    RV16K::X6,  RV16K::X7,  RV16K::X8,  RV16K::X9, RV16K::X10, RV16K::X11,
    RV16K::X12, RV16K::X13, RV16K::X14, RV16K::X15};

static DecodeStatus DecodeGPRRegisterClass(MCInst &Inst, uint64_t RegNo,
                                           uint64_t Address,
                                           const void *Decoder) {
  if (RegNo > sizeof(GPRDecoderTable))
    return MCDisassembler::Fail;

  unsigned Reg = GPRDecoderTable[RegNo];
  Inst.addOperand(MCOperand::createReg(Reg));
  return MCDisassembler::Success;
}

// Add implied SP operand for instructions lwsp/swsp. The SP operand isn't
// explicitly encoded in the instruction.
static void addImplySP(MCInst &Inst, int64_t Address, const void *Decoder) {
  if (Inst.getOpcode() == RV16K::LWSP || Inst.getOpcode() == RV16K::SWSP)
    DecodeGPRRegisterClass(Inst, 1, Address, Decoder);
}

template <unsigned N>
static DecodeStatus decodeUImmOperand(MCInst &Inst, uint64_t Imm,
                                      int64_t Address, const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid immediate");
  addImplySP(Inst, Address, Decoder);
  Inst.addOperand(MCOperand::createImm(Imm));
  return MCDisassembler::Success;
}

template <unsigned N>
static DecodeStatus decodeSImmOperand(MCInst &Inst, uint64_t Imm,
                                      int64_t Address, const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid immediate");
  // Sign-extend the number in the bottom N bits of Imm
  Inst.addOperand(MCOperand::createImm(SignExtend64<N>(Imm)));
  return MCDisassembler::Success;
}

#include "RV16KGenDisassemblerTables.inc"

DecodeStatus RV16KDisassembler::getInstruction(MCInst &MI, uint64_t &Size,
                                               ArrayRef<uint8_t> Bytes,
                                               uint64_t Address,
                                               raw_ostream &OS,
                                               raw_ostream &CS) const {
  if (Bytes.size() < 2) {
    Size = 0;
    return MCDisassembler::Fail;
  }

  uint32_t Inst;
  DecodeStatus Result;

  uint8_t bit15 = Bytes[1] >> 7, bit14 = (Bytes[1] >> 6) & 1,
          bit12 = (Bytes[1] >> 4) & 1;
  uint8_t isNIAI = (bit15 ^ bit14) & bit12;

  if (isNIAI) { // If a 32-bit instruction (NIAI)
    if (Bytes.size() < 4) {
      Size = 0;
      return MCDisassembler::Fail;
    }
    Inst = support::endian::read32le(Bytes.data());
    LLVM_DEBUG(dbgs() << "Trying RV16K 32bit table :\n");
    Result = decodeInstruction(DecoderTable32, MI, Inst, Address, this, STI);
    Size = 4;
  } else { // Otherwise i.e. if a 16-bit instruction (not NIAI)
    if (Bytes.size() < 2) {
      Size = 0;
      return MCDisassembler::Fail;
    }
    Inst = support::endian::read16le(Bytes.data());
    LLVM_DEBUG(dbgs() << "Trying RV16K 16bit table :\n");
    Result = decodeInstruction(DecoderTable16, MI, Inst, Address, this, STI);
    Size = 2;
  }

  return Result;
}
