set(LLVM_TARGET_DEFINITIONS RV16K.td)

tablegen(LLVM RV16KGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM RV16KGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM RV16KGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM RV16KGenMCPseudoLowering.inc -gen-pseudo-lowering)
tablegen(LLVM RV16KGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM RV16KGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM RV16KGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM RV16KGenCallingConv.inc -gen-callingconv)
tablegen(LLVM RV16KGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM RV16KGenDisassemblerTables.inc -gen-disassembler)

add_public_tablegen_target(RV16KCommonTableGen)

add_llvm_target(RV16KCodeGen
  RV16KAsmPrinter.cpp
  RV16KFrameLowering.cpp
  RV16KInstrInfo.cpp
  RV16KISelDAGToDAG.cpp
  RV16KISelLowering.cpp
  RV16KMCInstLower.cpp
  RV16KRegisterInfo.cpp
  RV16KSubtarget.cpp
  RV16KTargetMachine.cpp
  )
add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(InstPrinter)
add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
