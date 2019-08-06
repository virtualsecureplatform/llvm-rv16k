# RUN: llvm-mc -triple rv16k < %s -show-encoding \
# RUN:     | FileCheck -check-prefix=CHECK-FIXUP %s
# RUN: llvm-mc -filetype=obj -triple rv16k < %s \
# RUN:     | llvm-objdump -d - | FileCheck -check-prefix=CHECK-INSTR %s

# Checks that fixups that can be resolved within the same object file are
# applied correctly

.LBB0:
.space 128
jl .LBB0
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB0, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jl -128

.LBB1:
.space 128
jle .LBB1
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB1, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jle -128

.LBB2:
.space 128
je .LBB2
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB2, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: je -128

.LBB3:
.space 128
jne .LBB3
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB3, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jne -128

.LBB4:
.space 128
jb .LBB4
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB4, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jb -128

.LBB5:
.space 128
jbe .LBB5
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB5, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jbe -128

.LBB6:
.space 32766
j .LBB6
# CHECK-FIXUP: fixup A - offset: 2, value: .LBB6, kind: fixup_rv16k_pcrel_16bit
# CHECK-INSTR: j -32768

.LBB7:
.space 32766
jal .LBB7
# CHECK-FIXUP: fixup A - offset: 2, value: .LBB7, kind: fixup_rv16k_pcrel_16bit
# CHECK-INSTR: jal -32768

j .LBB8
# CHECK-FIXUP: fixup A - offset: 2, value: .LBB8, kind: fixup_rv16k_pcrel_16bit
# CHECK-INSTR: j 32766
.space 32764
.LBB8:

jal .LBB9
# CHECK-FIXUP: fixup A - offset: 2, value: .LBB9, kind: fixup_rv16k_pcrel_16bit
# CHECK-INSTR: jal 32766
.space 32764
.LBB9:

jl .LBB10
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB10, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jl 126
.space 124
.LBB10:

jle .LBB11
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB11, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jle 126
.space 124
.LBB11:

je .LBB12
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB12, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: je 126
.space 124
.LBB12:

jne .LBB13
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB13, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jne 126
.space 124
.LBB13:

jb .LBB14
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB14, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jb 126
.space 124
.LBB14:

jbe .LBB15
# CHECK-FIXUP: fixup A - offset: 0, value: .LBB15, kind: fixup_rv16k_pcrel_8bit
# CHECK-INSTR: jbe 126
.space 124
.LBB15:
