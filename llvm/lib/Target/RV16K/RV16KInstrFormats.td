// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

// 16-bit instruction format.
class RV16KInst<dag outs, dag ins, string opcodestr, string argstr, list<dag> pattern = []>
: Instruction {
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  bits<32> SoftFail = 0;

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
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  bits<32> SoftFail = 0;

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

// RR16 instruction format
// Used by mov, add, sub, and, or, xor, lsl, lsr, asr, cmp, jalr, jr, nop
class RV16KInstRR16<bits<8> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rs;
  bits<4> rd;

  let Inst{15-8} = opcode;
  let Inst{7-4} = rs;
  let Inst{3-0} = rd;
}

// RR32 instruction format
// Used by lw, lbu, lb, sw, sb, li, j, jal
class RV16KInstRR32<bits<8> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInstNIAI<outs, ins, opcodestr, argstr> {
  bits<4> rs;
  bits<4> rd;

  let Inst{15-8} = opcode;
  let Inst{7-4} = rs;
  let Inst{3-0} = rd;
}

// RI instruction format
// Used by addi, cmpi
class RV16KInstRI<bits<8> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rd;
  bits<4> imm;

  let Inst{15-8} = opcode;
  let Inst{7-4} = imm;
  let Inst{3-0} = rd;
}

// B instruction format
// Used by jl, jle, je, jne, jb, jbe
class RV16KInstB<bits<8> opcode, bits<1> funct, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<8> imm;

  let Inst{15-8} = opcode;
  let Inst{7} = funct;
  let Inst{6-0} = imm{7-1};
}

// SL instruction format
// Used by lwsp
class RV16KInstSL<bits<4> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rd;
  bits<9> imm;

  let Inst{15-12} = opcode;
  let Inst{11-4} = imm{8-1};
  let Inst{3-0} = rd;
}

// SS instruction format
// Used by swsp
class RV16KInstSS<bits<4> opcode, dag outs, dag ins, string opcodestr, string argstr>
: RV16KInst<outs, ins, opcodestr, argstr> {
  bits<4> rs;
  bits<9> imm;

  let Inst{15-12} = opcode;
  let Inst{11-8} = imm{8-5};
  let Inst{7-4} = rs;
  let Inst{3-0} = imm{4-1};
}
