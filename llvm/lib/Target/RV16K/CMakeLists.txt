set(LLVM_TARGET_DEFINITIONS RV16K.td)

tablegen(LLVM RV16KGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM RV16KGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM RV16KGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM RV16KGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM RV16KGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM RV16KGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM RV16KGenDisassemblerTables.inc -gen-disassembler)

add_public_tablegen_target(RV16KCommonTableGen)

add_llvm_target(RV16KCodeGen
  RV16KTargetMachine.cpp
  )
add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(InstPrinter)
add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
