// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

// RV16K 16-bit C return-value convention.
def RetCC_RV16K : CallingConv<[
  CCIfType<[i16], CCAssignToReg<[X8, X9]>>
]>;

// RV16K 16-bit C Calling convention.
def CC_RV16K : CallingConv<[
  // Promote i8 args to i16
  CCIfType<[i8], CCPromoteToType<i16>>,

  // All arguments get passed in integer registers if there is space.
  CCIfType<[i16], CCAssignToReg<[ X8, X9, X10, X11, X12, X13 ]>>,

  // Could be assigned to the stack in 8-byte aligned units, but unsupported
  CCAssignToStack<2, 2> // The slot's size, the stack alignment
]>;

def CSR : CalleeSavedRegs<(add X0, X2, X3, X4, X5, X6, X7)>;
