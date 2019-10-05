// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#ifndef LLVM_LIB_TARGET_RV16K_MCTARGETDESC_RV16KMCTARGETDESC_H
#define LLVM_LIB_TARGET_RV16K_MCTARGETDESC_RV16KMCTARGETDESC_H

#include "llvm/Config/config.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/DataTypes.h"
#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class StringRef;
class Target;
class Triple;
class raw_ostream;
class raw_pwrite_stream;

Target &getTheRV16KTarget();

MCCodeEmitter *createRV16KMCCodeEmitter(const MCInstrInfo &MCII,
                                        const MCRegisterInfo &MRI,
                                        MCContext &Ctx);

MCAsmBackend *createRV16KAsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                    const MCRegisterInfo &MRI,
                                    const MCTargetOptions &Options);

std::unique_ptr<MCObjectTargetWriter> createRV16KELFObjectWriter(uint8_t OSABI);
} // namespace llvm

// Defines symbolic names for RV16K registers.
#define GET_REGINFO_ENUM
#include "RV16KGenRegisterInfo.inc"

// Defines symbolic names for RV16K instructions.
#define GET_INSTRINFO_ENUM
#include "RV16KGenInstrInfo.inc"

#endif
