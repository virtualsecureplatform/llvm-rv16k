# RUN: not llvm-mc -triple rv16k < %s 2>&1 | FileCheck %s

# Out of range immediates
li t0, -0x8001 # CHECK: :[[@LINE]]:8: error: immediate must be an integer in the range [-32768, 32767]
li s0, 0x8000 # CHECK: :[[@LINE]]:8: error: immediate must be an integer in the range [-32768, 32767]
addi a0, -9 # CHECK: :[[@LINE]]:10: error: immediate must be an integer in the range [-8, 7]
addi a0, 8 # CHECK: :[[@LINE]]:10: error: immediate must be an integer in the range [-8, 7]
cmpi a0, -9 # CHECK: :[[@LINE]]:10: error: immediate must be an integer in the range [-8, 7]
cmpi a0, 8 # CHECK: :[[@LINE]]:10: error: immediate must be an integer in the range [-8, 7]
lw t0, 32767(a3) # CHECK: :[[@LINE]]:8: error: immediate must be a multiple of 2 bytes in the range [-32768, 32766]
sw t0, 32767(a3) # CHECK: :[[@LINE]]:8: error: immediate must be a multiple of 2 bytes in the range [-32768, 32766]
lwsp t0, -2(sp) # CHECK: :[[@LINE]]:10: error: immediate must be a multiple of 2 bytes in the range [0, 510]
lwsp t0, 1(sp) # CHECK: :[[@LINE]]:10: error: immediate must be a multiple of 2 bytes in the range [0, 510]
swsp t0, -2(sp) # CHECK: :[[@LINE]]:10: error: immediate must be a multiple of 2 bytes in the range [0, 510]
swsp t0, 1(sp) # CHECK: :[[@LINE]]:10: error: immediate must be a multiple of 2 bytes in the range [0, 510]
j 37267 # CHECK: :[[@LINE]]:3: error: immediate must be a multiple of 2 bytes in the range [-32768, 32766]
jl 128 # CHECK: :[[@LINE]]:4: error: immediate must be a multiple of 2 bytes in the range [-128, 126]

# Invalid mnemonics
subs x1, x2 # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
nandi x14, x13 # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic

# Invalid register names
add foo, x1 # CHECK: :[[@LINE]]:5: error: unknown operand
sub x0, x16 # CHECK: :[[@LINE]]:9: error: unknown operand
mov t2, x8 # CHECK: :[[@LINE]]:5: error: unknown operand

# Invalid operand types
add x15, 1 # CHECK: :[[@LINE]]:10: error: invalid operand for instruction
li x11, x12 # CHECK: :[[@LINE]]:9: error: invalid operand for instruction

# Too many operands
add x8, x9, x10 # CHECK: :[[@LINE]]:13: error: invalid operand for instruction
li x11, x12, x13 # CHECK: :[[@LINE]]:9: error: invalid operand for instruction

# Too few operands
li x8 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
mov x13 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
