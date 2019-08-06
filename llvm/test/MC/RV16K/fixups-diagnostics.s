# RUN: not llvm-mc -triple rv16k -filetype obj < %s -o /dev/null 2>&1 | FileCheck %s

  j   unaligned # CHECK: :[[@LINE]]:3: error: fixup value must be 2-byte aligned
  jal unaligned # CHECK: :[[@LINE]]:3: error: fixup value must be 2-byte aligned

  jl distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jle distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  je distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jne distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jb distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jbe distant # CHECK: :[[@LINE]]:3: error: fixup value out of range

  .byte 0
unaligned:
  .byte 0
  .byte 0
  .byte 0

  .space 1<<8
distant:
  .space 1<<8

  jl distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jle distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  je distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jne distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jb distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
  jbe distant # CHECK: :[[@LINE]]:3: error: fixup value out of range
