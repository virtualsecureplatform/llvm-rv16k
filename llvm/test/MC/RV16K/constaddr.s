# RUN: llvm-mc -filetype=obj -triple=rv16k %s \
# RUN:  | llvm-objdump -d - | FileCheck %s -check-prefix=CHECK-INSTR

# RUN: llvm-mc -filetype=obj -triple=rv16k %s \
# RUN:  | llvm-readobj -r | FileCheck %s -check-prefix=CHECK-REL

tmp1:
	.space 50
tmp2:
	li t0, tmp2-tmp1
# CHECK-INSTR: li t0, 50

li t0, 1+5*(1<<3)+1
# CHECK-INSTR: li t0, 42

# CHECK-REL-NOT: R_RV16K
