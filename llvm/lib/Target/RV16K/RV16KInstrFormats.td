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

// 16-bit instruction format.
class RV16KInst<dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern = []>
: Instruction {
  let Namespace = "RV16K";

  let Size = 2;
  bits<16> Inst;

  dag OutOperandList = outs;
  dag InOperandList = ins;

  let AsmString = opcodestr # "\t" # argstr;

  // Matching patterns used when converting SelectionDAG into MachineDAG.
  let Pattern = pattern;
}

// 32-bit instruction format for NIAI (decode Next Instruction As Immediate operand)
class RV16KInstNIAI<dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern = []>
: Instruction {
  let Namespace = "RV16K";

  let Size = 4;
  bits<32> Inst;

  bits<16> imm;
  let Inst{31-16} = imm;  // NIAI

  dag OutOperandList = outs;
  dag InOperandList = ins;

  let AsmString = opcodestr # "\t" # argstr;

  let Pattern = pattern;
}

 // Pseudo instructions
class Pseudo<dag outs, dag ins, list<dag> pattern>
: RV16KInst<outs, ins, "", "", pattern> {
  let isPseudo = 1;
  let isCodeGenOnly = 1;
}

class RV16KInstRR16<bits<8> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rs;
  bits<4> rd;

  let Inst{15-8} = opcode;
  let Inst{7-4} = rs;
  let Inst{3-0} = rd;
}

class RV16KInstRR32<bits<8> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInstNIAI<outs, ins, opcodestr, argstr> {
  bits<4> rs;
  bits<4> rd;

  let Inst{15-8} = opcode;
  let Inst{7-4} = rs;
  let Inst{3-0} = rd;
}

class RV16KInstRI<bits<8> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rd;
  bits<4> imm;

  let Inst{15-8} = opcode;
  let Inst{7-4} = imm;
  let Inst{3-0} = rd;
}

class RV16KInstB<bits<8> opcode, bits<1> funct, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<8> imm;

  let Inst{15-8} = opcode;
  let Inst{7} = funct;
  let Inst{6-0} = imm{7-1};
}

class RV16KInstSL<bits<4> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rd;
  bits<9> imm;

  let Inst{15-12} = opcode;
  let Inst{11-4} = imm{8-1};
  let Inst{3-0} = rd;
}

class RV16KInstSS<bits<4> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rs;
  bits<9> imm;

  let Inst{15-12} = opcode;
  let Inst{11-8} = imm{8-5};
  let Inst{7-4} = rs;
  let Inst{3-0} = imm{4-1};
}
