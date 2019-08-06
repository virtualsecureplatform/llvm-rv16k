# RUN: llvm-mc -triple rv16k < %s -show-encoding \
# RUN:     | FileCheck -check-prefix=INSTR -check-prefix=FIXUP %s
# RUN: llvm-mc -filetype=obj -triple rv16k < %s \
# RUN:     | llvm-readobj -r | FileCheck -check-prefix=RELOC %s

# Check prefixes:
# RELOC - Check the relocation in the object.
# FIXUP - Check the fixup on the instruction.
# INSTR - Check the instruction is handled properly by the ASMPrinter

.2byte foo
# RELOC: R_RV16K_16 foo

li t1, foo
# RELOC: R_RV16K_16
# INSTR: li t1, foo
# FIXUP: fixup A - offset: 2, value: foo, kind: FK_Data_2

j foo
# RELOC: R_RV16K_PC16
# INSTR: j foo
# FIXUP: fixup A - offset: 2, value: foo, kind: fixup_rv16k_pcrel_16bit

jl foo
# RELOC: R_RV16K_PC8
# INSTR: jl foo
# FIXUP: fixup A - offset: 0, value: foo, kind: fixup_rv16k_pcrel_8bit
