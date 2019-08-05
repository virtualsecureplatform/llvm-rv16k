# RUN: not llvm-mc -triple rv16k < %s 2>&1 | FileCheck %s

# Out of range immediates
li t0, -0x8001 # CHECK: :[[@LINE]]:8: error: immediate must be an integer in the range [-32768, 32767]
li s0, 0x8000 # CHECK: :[[@LINE]]:8: error: immediate must be an integer in the range [-32768, 32767]

# Invalid mnemonics
subs x1, x2 # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
nandi x14, x13 # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic

# Invalid register names
add foo, x1 # CHECK: :[[@LINE]]:5: error: unknown operand
sub x0, x16 # CHECK: :[[@LINE]]:9: error: unknown operand
mov t2, x8 # CHECK: :[[@LINE]]:5: error: unknown operand

# Invalid operand types
add x15, 1 # CHECK: :[[@LINE]]:10: error: invalid operand for instruction

# Too many operands
add x8, x9, x10 # CHECK: :[[@LINE]]:13: error: invalid operand for instruction
li x11, x12, x13 # CHECK: :[[@LINE]]:14: error: invalid operand for instruction

# Too few operands
li x8 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
mov x13 # CHECK: :[[@LINE]]:1: error: too few operands for instruction
