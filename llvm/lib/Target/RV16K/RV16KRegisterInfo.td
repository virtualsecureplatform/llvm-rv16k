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

let Namespace = "RV16K" in {
  def ABIRegAltName : RegAltNameIndex;

  class RV16KReg<bits<4> Enc, string n, list<string> alt = []> : Register<n> {
    let HWEncoding{3-0} = Enc;
    let AltNames = alt;
    let RegAltNameIndices = [ABIRegAltName];
  }
} // Namespace = "RV16K"

// Integer registers
def X0  : RV16KReg<0, "x0", ["ra"]>, DwarfRegNum<[0]>;
def X1  : RV16KReg<1, "x1", ["sp"]>, DwarfRegNum<[1]>;
def X2  : RV16KReg<2, "x2", ["fp"]>, DwarfRegNum<[2]>;
def X3  : RV16KReg<3, "x3", ["s0"]>, DwarfRegNum<[3]>;
def X4  : RV16KReg<4, "x4", ["s1"]>, DwarfRegNum<[4]>;
def X5  : RV16KReg<5, "x5", ["s2"]>, DwarfRegNum<[5]>;
def X6  : RV16KReg<6, "x6", ["s3"]>, DwarfRegNum<[6]>;
def X7  : RV16KReg<7, "x7", ["s4"]>, DwarfRegNum<[7]>;
def X8  : RV16KReg<8, "x8", ["a0"]>, DwarfRegNum<[8]>;
def X9  : RV16KReg<9, "x9", ["a1"]>, DwarfRegNum<[9]>;
def X10 : RV16KReg<10,"x10", ["a2"]>, DwarfRegNum<[10]>;
def X11 : RV16KReg<11,"x11", ["a3"]>, DwarfRegNum<[11]>;
def X12 : RV16KReg<12,"x12", ["a4"]>, DwarfRegNum<[12]>;
def X13 : RV16KReg<13,"x13", ["a5"]>, DwarfRegNum<[13]>;
def X14 : RV16KReg<14,"x14", ["t0"]>, DwarfRegNum<[14]>;
def X15 : RV16KReg<15,"x15", ["t1"]>, DwarfRegNum<[15]>;

// Flag registers
def FLAGS : RV16KReg<0, "flags">;

// General Purpose Registers.
// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPR : RegisterClass<"RV16K", [i16], 16, (add
  X8, X9, X10, X11, X12, X13, X14, X15, X3, X4, X5, X6, X7, X0, X1, X2
  )>;

// For instructions like lwsp and swsp, which accept only the stack pointer as operand.
def SP : RegisterClass<"RV16K", [i16], 16, (add X1)>;

// Status flag registers
def FLAGS_REG : RegisterClass<"RV16K", [i16], 16, (add FLAGS)> {
  let CopyCost = -1;  // Don't allow copying of status registers.
  let isAllocatable = 0;
}
