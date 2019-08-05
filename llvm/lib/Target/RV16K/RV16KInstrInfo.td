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

include "RV16KInstrFormats.td"

class ImmAsmOperand<string prefix, int width, string suffix> : AsmOperandClass {
  let Name = prefix # "Imm" # width # suffix;
  let RenderMethod = "addImmOperands";
  let DiagnosticType = "Invalid" # Name;
}

class SImmAsmOperand<int width, string suffix = "">
    : ImmAsmOperand<"S", width, suffix> {
}

class UImmAsmOperand<int width, string suffix = "">
    : ImmAsmOperand<"U", width, suffix> {
}

def simm4 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<4>;
}

def simm8_lsb0 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<8, "Lsb0">;
}

def uimm9_lsb0 : Operand<i16> {
  let ParserMatchClass = UImmAsmOperand<9, "Lsb0">;
}

def simm16 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<16>;
}

def simm16_lsb0 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<16, "Lsb0">;
}

// M: Instructions for memory

def LW : RV16KInstRR32<0b10110010, (outs GPR:$rd), (ins GPR:$rs, simm16_lsb0:$imm),
                      "lw", "$rd, ${imm}(${rs})">;
def LWSP : RV16KInstSL<0b1010, (outs GPR:$rd), (ins SP:$rs, uimm9_lsb0:$imm),
                     "lwsp", "$rd, ${imm}(${rs})">;
def LBU : RV16KInstRR32<0b10111010, (outs GPR:$rd), (ins GPR:$rs, simm16:$imm),
                       "lbu", "$rd, ${imm}(${rs})">;
def LB : RV16KInstRR32<0b10111110, (outs GPR:$rd), (ins GPR:$rs, simm16:$imm),
                      "lb", "$rd, ${imm}(${rs})">;
def SW : RV16KInstRR32<0b10010010, (outs), (ins GPR:$rs, GPR:$rd, simm16_lsb0:$imm),
                      "sw", "$rs, ${imm}(${rd})">;
def SWSP : RV16KInstSS<0b1000, (outs), (ins GPR:$rs, SP:$rd, uimm9_lsb0:$imm),
                     "swsp", "$rs, ${imm}(${rd})">;
def SB : RV16KInstRR32<0b10011010, (outs), (ins GPR:$rs, GPR:$rd, simm16:$imm),
                      "sb", "$rs, ${imm}(${rd})">;

// R: Instructions for arithmetic

def MOV : RV16KInstRR16<0b11000000, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "mov", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def ADD : RV16KInstRR16<0b11100010, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "add", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def SUB : RV16KInstRR16<0b11100011, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "sub", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def AND : RV16KInstRR16<0b11100100, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "and", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def OR  : RV16KInstRR16<0b11100101, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "or",  "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def XOR : RV16KInstRR16<0b11100110, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "xor", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def LSL : RV16KInstRR16<0b11101001, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "lsl", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def LSR : RV16KInstRR16<0b11101010, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "lsr", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def ASR : RV16KInstRR16<0b11101101, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "asr", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}
def CMP : RV16KInstRR16<0b11000011, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                       "cmp", "$rd, $rs"> {
  let Constraints = "$rd = $rd_w";
}

// I: Instructions for immediates

def LI : RV16KInstRR32<0b01111000, (outs GPR:$rd), (ins simm16:$imm),
                      "li", "$rd, $imm"> {
  let rs = 0;
}
def ADDI : RV16KInstRI<0b11110010, (outs GPR:$rd_w), (ins GPR:$rd, simm4:$imm),
                      "addi", "$rd, $imm"> {
  let Constraints = "$rd = $rd_w";
}
def CMPI : RV16KInstRI<0b11010011, (outs GPR:$rd_w), (ins GPR:$rd, simm4:$imm),
                      "cmpi", "$rd, $imm"> {
  let Constraints = "$rd = $rd_w";
}

// J: Instructions for branches/jumps

def J : RV16KInstRR32<0b01010010, (outs), (ins simm16_lsb0:$imm),
                     "j", "$imm"> {
  let rs = 0;
  let rd = 0;
}
def JAL : RV16KInstRR32<0b01110011, (outs), (ins simm16_lsb0:$imm),
                       "jal", "$imm"> {
  let rs = 0;
  let rd = 0;
}
def JALR : RV16KInstRR16<0b01100001, (outs), (ins GPR:$rs),
                        "jalr", "$rs"> {
  let rd = 0;
}
def JR : RV16KInstRR16<0b01000000, (outs), (ins GPR:$rs),
                      "jr", "$rs"> {
  let rd = 0;
}
def JL  : RV16KInstB<0b01010100, 0, (outs), (ins simm8_lsb0:$imm),
                    "jl", "$imm">;
def JLE : RV16KInstB<0b01010100, 1, (outs), (ins simm8_lsb0:$imm),
                    "jle", "$imm">;
def JE  : RV16KInstB<0b01010101, 0, (outs), (ins simm8_lsb0:$imm),
                    "je", "$imm">;
def JNE : RV16KInstB<0b01010101, 1, (outs), (ins simm8_lsb0:$imm),
                    "jne", "$imm">;
def JB  : RV16KInstB<0b01010110, 0, (outs), (ins simm8_lsb0:$imm),
                    "jb", "$imm">;
def JBE : RV16KInstB<0b01010110, 1, (outs), (ins simm8_lsb0:$imm),
                    "jbe", "$imm">;

// misc

def NOP : RV16KInstRR16<0b00000000, (outs), (ins), "nop", ""> {
  let rs = 0;
  let rd = 0;
}
