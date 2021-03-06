// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16KTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"
using namespace llvm;

extern "C" void LLVMInitializeRV16KTarget() {
  RegisterTargetMachine<RV16KTargetMachine> X(getTheRV16KTarget());
}

static std::string computeDataLayout(const Triple &TT) {
  return "e"        // Little endian
         "-m:e"     // ELF name manging
         "-p:16:16" // 16-bit pointers, 16 bit aligned
         "-i16:16"  // 16 bit integers, 16 bit aligned
         "-n16"     // 16 bit native integer width
         "-S16";    // 16 bit natural stack alignment
}

static Reloc::Model getEffectiveRelocModel(const Triple &TT,
                                           Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    return Reloc::Static;
  return *RM;
}

RV16KTargetMachine::RV16KTargetMachine(const Target &T, const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       Optional<Reloc::Model> RM,
                                       Optional<CodeModel::Model> CM,
                                       CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(TT), TT, CPU, FS, Options,
                        getEffectiveRelocModel(TT, RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, CPU, FS, *this) {
  initAsmInfo();
}

namespace {
class RV16KPassConfig : public TargetPassConfig {
public:
  RV16KPassConfig(RV16KTargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  RV16KTargetMachine &getRV16KTargetMachine() const {
    return getTM<RV16KTargetMachine>();
  }

  bool addInstSelector() override;

  void addPreEmitPass() override;
  void addPreEmitPass2() override;
};
} // namespace

TargetPassConfig *RV16KTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new RV16KPassConfig(*this, PM);
}

bool RV16KPassConfig::addInstSelector() {
  addPass(createRV16KISelDag(getRV16KTargetMachine()));

  return false;
}

void RV16KPassConfig::addPreEmitPass() {
  addPass(createRV16KUseLWSPSWSPPass());
  addPass(&BranchRelaxationPassID);
}

void RV16KPassConfig::addPreEmitPass2() {
  addPass(createRV16KExpandPseudoPass(), false, true);
}
