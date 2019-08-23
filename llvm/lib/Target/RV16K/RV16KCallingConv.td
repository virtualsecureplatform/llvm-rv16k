// Copyright 2019 Ryotaro Banno, Kotaro Matsuoka, Naoki Matsumoto
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
