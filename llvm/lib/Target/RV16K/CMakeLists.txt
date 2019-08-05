set(LLVM_TARGET_DEFINITIONS RV16K.td)

tablegen(LLVM RV16KGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM RV16KGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM RV16KGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM RV16KGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM RV16KGenAsmMatcher.inc -gen-asm-matcher)

add_public_tablegen_target(RV16KCommonTableGen)

add_llvm_target(RV16KCodeGen
  RV16KTargetMachine.cpp
  )
add_subdirectory(AsmParser)
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
