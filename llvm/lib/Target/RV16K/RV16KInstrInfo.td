// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

include "RV16KInstrFormats.td"

def RV16K_COND_L   : PatLeaf<(i16 0)>;
def RV16K_COND_LE  : PatLeaf<(i16 1)>;
def RV16K_COND_E   : PatLeaf<(i16 2)>;
def RV16K_COND_NE  : PatLeaf<(i16 3)>;
def RV16K_COND_B   : PatLeaf<(i16 4)>;
def RV16K_COND_BE  : PatLeaf<(i16 5)>;

def SDT_RV16KBrCC     : SDTypeProfile<0, 4, [SDTCisVT<0, i16>,
                                             SDTCisVT<1, i16>,
                                             SDTCisVT<2, OtherVT>]>;

def SDT_RV16KCall         : SDTypeProfile<0, -1, [SDTCisVT<0, i16>]>;
def SDT_RV16KCallSeqStart : SDCallSeqStart<[SDTCisVT<0, i16>, SDTCisVT<1, i16>]>;
def SDT_RV16KCallSeqEnd   : SDCallSeqEnd<[SDTCisVT<0, i16>, SDTCisVT<1, i16>]>;

// resv = SELECT_CC lhs rhs condcode truev falsev
def SDT_RV16KSelectCC     : SDTypeProfile<1, 5, [SDTCisSameAs<1, 2>,
                                                 SDTCisSameAs<0, 4>,
                                                 SDTCisSameAs<4, 5>]>;

def RV16KBrCC : SDNode<"RV16KISD::BR_CC", SDT_RV16KBrCC, [SDNPHasChain]>;

def Call         : SDNode<"RV16KISD::CALL", SDT_RV16KCall,
                          [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue,
                           SDNPVariadic]>;
def CallSeqStart : SDNode<"ISD::CALLSEQ_START", SDT_RV16KCallSeqStart,
                          [SDNPHasChain, SDNPOutGlue]>;
def CallSeqEnd   : SDNode<"ISD::CALLSEQ_END", SDT_RV16KCallSeqEnd,
                          [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def SelectCC     : SDNode<"RV16KISD::SELECT_CC", SDT_RV16KSelectCC,
                          [SDNPInGlue]>;

def RetFlag : SDNode<"RV16KISD::RET_FLAG", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

def Tail : SDNode<"RV16KISD::TAIL", SDT_RV16KCall,
                  [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue,
                   SDNPVariadic]>;

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

def simm4 : Operand<i16>, ImmLeaf<i16, [{return isInt<4>(Imm);}]> {
  let ParserMatchClass = SImmAsmOperand<4>;
  let DecoderMethod = "decodeSImmOperand<4>";
  let EncoderMethod = "getImmOpValue";
}

def simm8_lsb0 : Operand<OtherVT> {
  let ParserMatchClass = SImmAsmOperand<8, "Lsb0">;
  let DecoderMethod = "decodeSImmOperand<8>";
  let EncoderMethod = "getImmOpValue";
}

def uimm9_lsb0 : Operand<i16> {
  let ParserMatchClass = UImmAsmOperand<9, "Lsb0">;
  let DecoderMethod = "decodeUImmOperand<9>";
  let EncoderMethod = "getImmOpValue";
}

def simm16 : Operand<i16>, ImmLeaf<i16, [{return isInt<16>(Imm);}]> {
  let ParserMatchClass = SImmAsmOperand<16>;
  let DecoderMethod = "decodeSImmOperand<16>";
  let EncoderMethod = "getImmOpValue";
}

def simm16_lsb0 : Operand<i16>, ImmLeaf<i16, [{return isShiftedInt<15, 1>(Imm);}]> {
  let ParserMatchClass = SImmAsmOperand<16, "Lsb0">;
  let DecoderMethod = "decodeSImmOperand<16>";
  let EncoderMethod = "getImmOpValue";
}

def simm16_lsb0_j : Operand<OtherVT> {
  let ParserMatchClass = SImmAsmOperand<16, "Lsb0">;
  let DecoderMethod = "decodeSImmOperand<16>";
  let EncoderMethod = "getImmOpValue";
}

// Addressing modes.
// Necessary because a frameindex can't be matched directly in a pattern.
def AddrFI : ComplexPattern<iPTR, 1, "SelectAddrFI", [frameindex], []>;

/// Predicates

def IsOrAdd: PatFrag<(ops node:$A, node:$B), (or node:$A, node:$B), [{
  return isOrEquivalentToAdd(N);
}]>;

// M: Instructions for memory

let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Defs = [FLAGS] in {
  def LW : RV16KInstRR32<0b10110010, (outs GPR:$rd), (ins GPR:$rs, simm16_lsb0:$imm),
                        "lw", "$rd, ${imm}(${rs})">;
  def LWSP : RV16KInstSL<0b1010, (outs GPR:$rd), (ins SP:$rs, uimm9_lsb0:$imm),
                       "lwsp", "$rd, ${imm}(${rs})">;
  def LBU : RV16KInstRR32<0b10111010, (outs GPR:$rd), (ins GPR:$rs, simm16:$imm),
                         "lbu", "$rd, ${imm}(${rs})">;
  def LB : RV16KInstRR32<0b10111110, (outs GPR:$rd), (ins GPR:$rs, simm16:$imm),
                        "lb", "$rd, ${imm}(${rs})">;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 1, Defs = [FLAGS] in {
  def SW : RV16KInstRR32<0b10010010, (outs), (ins GPR:$rs, GPR:$rd, simm16_lsb0:$imm),
                        "sw", "$rs, ${imm}(${rd})">;
  def SWSP : RV16KInstSS<0b1000, (outs), (ins GPR:$rs, SP:$rd, uimm9_lsb0:$imm),
                       "swsp", "$rs, ${imm}(${rd})">;
  def SB : RV16KInstRR32<0b10011010, (outs), (ins GPR:$rs, GPR:$rd, simm16:$imm),
                        "sb", "$rs, ${imm}(${rd})">;
}

// R: Instructions for arithmetic

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [FLAGS] in {
  let isMoveReg = 1 in
  def MOV : RV16KInstRR16<0b11100000, (outs GPR:$rd), (ins GPR:$rs),
                         "mov", "$rd, $rs">;

  let isCompare = 1 in
  def CMP : RV16KInstRR16<0b11000011, (outs), (ins GPR:$rd, GPR:$rs),
                         "cmp", "$rd, $rs">;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0,
    Defs = [FLAGS], Constraints = "$rd = $rd_w" in {
  let isCommutable = 1 in {
    let isAdd = 1 in
    def ADD : RV16KInstRR16<0b11100010, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                           "add", "$rd, $rs">;
    def AND : RV16KInstRR16<0b11100100, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                           "and", "$rd, $rs">;
    def OR  : RV16KInstRR16<0b11100101, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                           "or",  "$rd, $rs">;
    def XOR : RV16KInstRR16<0b11100110, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                           "xor", "$rd, $rs">;
  }

  def SUB : RV16KInstRR16<0b11100011, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                         "sub", "$rd, $rs">;
  def LSL : RV16KInstRR16<0b11101001, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                         "lsl", "$rd, $rs">;
  def LSR : RV16KInstRR16<0b11101010, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                         "lsr", "$rd, $rs">;
  def ASR : RV16KInstRR16<0b11101101, (outs GPR:$rd_w), (ins GPR:$rd, GPR:$rs),
                         "asr", "$rd, $rs">;
}


// I: Instructions for immediates

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [FLAGS] in {
  let isMoveImm = 1 in
  def LI : RV16KInstRR32<0b01111000, (outs GPR:$rd), (ins simm16:$imm),
                        "li", "$rd, $imm"> {
    let rs = 0;
  }

  let Constraints = "$rd = $rd_w" in
  def ADDI : RV16KInstRI<0b11110010, (outs GPR:$rd_w), (ins GPR:$rd, simm4:$imm),
                        "addi", "$rd, $imm">;

  let isCompare = 1 in
  def CMPI : RV16KInstRI<0b11010011, (outs), (ins GPR:$rd, simm4:$imm),
                        "cmpi", "$rd, $imm">;
}

// J: Instructions for branches/jumps

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  let isBranch = 1, isTerminator = 1, isBarrier = 1 in
  def J : RV16KInstRR32<0b01010010, (outs), (ins simm16_lsb0_j:$imm),
                       "j", "$imm"> {
    let rs = 0;
    let rd = 0;
  }

  let isCall = 1, Defs = [X0] in
  def JAL : RV16KInstRR32<0b01110011, (outs), (ins simm16_lsb0:$imm),
                         "jal", "$imm"> {
    let rs = 0;
    let rd = 0;
  }

  let isCall = 1, Defs = [X0] in
  def JALR : RV16KInstRR16<0b01100001, (outs), (ins GPR:$rs),
                          "jalr", "$rs"> {
    let rd = 0;
  }

  let isBranch = 1, isBarrier = 1, isTerminator = 1, isIndirectBranch = 1 in
  def JR : RV16KInstRR16<0b01000000, (outs), (ins GPR:$rs),
                        "jr", "$rs"> {
    let rd = 0;
  }

  let isBranch = 1, isTerminator = 1, Uses = [FLAGS] in {
    def JL  : RV16KInstB<0b01000100, 0, (outs), (ins simm8_lsb0:$imm),
                        "jl", "$imm">;
    def JLE : RV16KInstB<0b01000100, 1, (outs), (ins simm8_lsb0:$imm),
                        "jle", "$imm">;
    def JE  : RV16KInstB<0b01000101, 0, (outs), (ins simm8_lsb0:$imm),
                        "je", "$imm">;
    def JNE : RV16KInstB<0b01000101, 1, (outs), (ins simm8_lsb0:$imm),
                        "jne", "$imm">;
    def JB  : RV16KInstB<0b01000110, 0, (outs), (ins simm8_lsb0:$imm),
                        "jb", "$imm">;
    def JBE : RV16KInstB<0b01000110, 1, (outs), (ins simm8_lsb0:$imm),
                        "jbe", "$imm">;
  }
}

// misc

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def NOP : RV16KInstRR16<0b00000000, (outs), (ins), "nop", ""> {
  let rs = 0;
  let rd = 0;
}

// Pseudo-instructions and codegen patterns

def : Pat<(load GPR:$rs1), (LW GPR:$rs1, 0)>;
def : Pat<(load AddrFI:$rs1), (LW AddrFI:$rs1, 0)>;
def : Pat<(load (add GPR:$rs1, simm16_lsb0:$imm16)),
          (LW GPR:$rs1, simm16_lsb0:$imm16)>;
def : Pat<(load (add AddrFI:$rs1, simm16_lsb0:$imm16)),
          (LW AddrFI:$rs1, simm16_lsb0:$imm16)>;
def : Pat<(load (IsOrAdd AddrFI:$rs1, simm16_lsb0:$imm16)),
          (LW AddrFI:$rs1, simm16_lsb0:$imm16)>;

def : Pat<(extloadi8 GPR:$rs1), (LB GPR:$rs1, 0)>;
def : Pat<(extloadi8 AddrFI:$rs1), (LB AddrFI:$rs1, 0)>;
def : Pat<(extloadi8 (add GPR:$rs1, simm16:$imm16)),
          (LB GPR:$rs1, simm16:$imm16)>;
def : Pat<(extloadi8 (add AddrFI:$rs1, simm16:$imm16)),
          (LB AddrFI:$rs1, simm16:$imm16)>;
def : Pat<(extloadi8 (IsOrAdd AddrFI:$rs1, simm16_lsb0:$imm16)),
          (LB AddrFI:$rs1, simm16_lsb0:$imm16)>;

def : Pat<(sextloadi8 GPR:$rs1), (LB GPR:$rs1, 0)>;
def : Pat<(sextloadi8 AddrFI:$rs1), (LB AddrFI:$rs1, 0)>;
def : Pat<(sextloadi8 (add GPR:$rs1, simm16:$imm16)),
          (LB GPR:$rs1, simm16:$imm16)>;
def : Pat<(sextloadi8 (add AddrFI:$rs1, simm16:$imm16)),
          (LB AddrFI:$rs1, simm16:$imm16)>;
def : Pat<(sextloadi8 (IsOrAdd AddrFI:$rs1, simm16_lsb0:$imm16)),
          (LB AddrFI:$rs1, simm16_lsb0:$imm16)>;

def : Pat<(zextloadi8 GPR:$rs1), (LBU GPR:$rs1, 0)>;
def : Pat<(zextloadi8 AddrFI:$rs1), (LBU AddrFI:$rs1, 0)>;
def : Pat<(zextloadi8 (add GPR:$rs1, simm16:$imm16)),
          (LBU GPR:$rs1, simm16:$imm16)>;
def : Pat<(zextloadi8 (add AddrFI:$rs1, simm16:$imm16)),
          (LBU AddrFI:$rs1, simm16:$imm16)>;
def : Pat<(zextloadi8 (IsOrAdd AddrFI:$rs1, simm16_lsb0:$imm16)),
          (LBU AddrFI:$rs1, simm16_lsb0:$imm16)>;

def : Pat<(store GPR:$rs2, GPR:$rs1), (SW GPR:$rs2, GPR:$rs1, 0)>;
def : Pat<(store GPR:$rs2, AddrFI:$rs1), (SW GPR:$rs2, AddrFI:$rs1, 0)>;
def : Pat<(store GPR:$rs2, (add GPR:$rs1, simm16_lsb0:$imm16)),
          (SW GPR:$rs2, GPR:$rs1, simm16_lsb0:$imm16)>;
def : Pat<(store GPR:$rs2, (add AddrFI:$rs1, simm16_lsb0:$imm16)),
          (SW GPR:$rs2, AddrFI:$rs1, simm16_lsb0:$imm16)>;
def : Pat<(store GPR:$rs2, (IsOrAdd AddrFI:$rs1, simm16_lsb0:$imm16)),
          (SW GPR:$rs2, AddrFI:$rs1, simm16_lsb0:$imm16)>;

def : Pat<(truncstorei8 GPR:$rs2, GPR:$rs1), (SB GPR:$rs2, GPR:$rs1, 0)>;
def : Pat<(truncstorei8 GPR:$rs2, AddrFI:$rs1), (SB GPR:$rs2, AddrFI:$rs1, 0)>;
def : Pat<(truncstorei8 GPR:$rs2, (add GPR:$rs1, simm16:$imm16)),
          (SB GPR:$rs2, GPR:$rs1, simm16:$imm16)>;
def : Pat<(truncstorei8 GPR:$rs2, (add AddrFI:$rs1, simm16:$imm16)),
          (SB GPR:$rs2, AddrFI:$rs1, simm16:$imm16)>;

def : Pat<(add GPR:$rs1, GPR:$rs2), (ADD GPR:$rs1, GPR:$rs2)>;
def : Pat<(sub GPR:$rs1, GPR:$rs2), (SUB GPR:$rs1, GPR:$rs2)>;
def : Pat<(and GPR:$rs1, GPR:$rs2), (AND GPR:$rs1, GPR:$rs2)>;
def : Pat<(or  GPR:$rs1, GPR:$rs2), (OR  GPR:$rs1, GPR:$rs2)>;
def : Pat<(xor GPR:$rs1, GPR:$rs2), (XOR GPR:$rs1, GPR:$rs2)>;
def : Pat<(shl GPR:$rs1, GPR:$rs2), (LSL GPR:$rs1, GPR:$rs2)>;
def : Pat<(srl GPR:$rs1, GPR:$rs2), (LSR GPR:$rs1, GPR:$rs2)>;
def : Pat<(sra GPR:$rs1, GPR:$rs2), (ASR GPR:$rs1, GPR:$rs2)>;

def : Pat<(simm16:$imm16), (LI simm16:$imm16)>;
def : Pat<(add GPR:$rs1, simm4:$imm4), (ADDI GPR:$rs1, simm4:$imm4)>;

def : Pat<(br bb:$imm), (J simm16_lsb0_j:$imm)>;
def : Pat<(brind GPR:$rs), (JR GPR:$rs)>;

def : Pat<(Call GPR:$rs), (JALR GPR:$rs)>;
def : Pat<(Call tglobaladdr:$dst), (JAL tglobaladdr:$dst)>;
def : Pat<(Call texternalsym:$dst), (JAL texternalsym:$dst)>;

let hasSideEffects = 0, mayStore = 0, mayLoad = 0,
    isBarrier = 1, isReturn = 1, isTerminator = 1 in
def PseudoRET : Pseudo<(outs), (ins), [(RetFlag)]>,
                PseudoInstExpansion<(JR X0)>;

let hasSideEffects = 0, mayStore = 0, mayLoad = 0,
    isCall = 1, isTerminator = 1, isReturn = 1, isBarrier = 1 in {
  def PseudoTAIL : Pseudo<(outs), (ins simm16_lsb0:$imm), []>,
                   PseudoInstExpansion<(J simm16_lsb0_j:$imm)>;
  def PseudoTAILIndirect
      : Pseudo<(outs), (ins GPRTC:$rs), []>,
        PseudoInstExpansion<(JR GPR:$rs)>;
}

def : Pat<(Tail tglobaladdr:$dst),
          (PseudoTAIL tglobaladdr:$dst)>;
def : Pat<(Tail texternalsym:$dst),
          (PseudoTAIL texternalsym:$dst)>;
def : Pat<(Tail GPRTC:$rs), (PseudoTAILIndirect GPRTC:$rs)>;

// Pessimistically assume the stack pointer will be clobbered
let Defs = [X1], Uses = [X1] in {
  def ADJCALLSTACKDOWN : Pseudo<(outs), (ins i16imm:$amt1, i16imm:$amt2),
                                [(CallSeqStart timm:$amt1, timm:$amt2)]>;
  def ADJCALLSTACKUP   : Pseudo<(outs), (ins i16imm:$amt1, i16imm:$amt2),
                                [(CallSeqEnd timm:$amt1, timm:$amt2)]>;
}

let usesCustomInserter = 1 in
def SelectCCrr
    : Pseudo<(outs GPR:$dst),
             (ins GPR:$lhs, GPR:$rhs, i16imm:$imm, GPR:$src, GPR:$src2),
             [(set i16:$dst, (SelectCC GPR:$lhs, GPR:$rhs,
              (i16 imm:$imm), GPR:$src, GPR:$src2))]>;

let usesCustomInserter = 1 in
def SelectCCri
    : Pseudo<(outs GPR:$dst),
             (ins GPR:$lhs, simm4:$rhs, i16imm:$imm, GPR:$src, GPR:$src2),
             [(set i16:$dst, (SelectCC GPR:$lhs, simm4:$rhs,
              (i16 imm:$imm), GPR:$src, GPR:$src2))]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isCodeGenOnly = 0,
    Size = 4 /* Expand into 32-bit instruction J */ in
def PseudoHLT : Pseudo<(outs), (ins), []> {
  let AsmString = "hlt";
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [FLAGS] in
def FRMIDX : Pseudo<(outs GPR:$rd), (ins GPR:$rs, simm16:$imm), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0,
    isBranch = 1, isTerminator = 1, Defs = [FLAGS],
    Size = 4 /* equals to CMP/CMPI + Jcc */ in {
  def Bcc  : Pseudo<(outs), (ins GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, i16imm:$cc), []>;
  def BccI : Pseudo<(outs), (ins GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, i16imm:$cc), []>;
}

// ==
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETEQ ),
          (Bcc       GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, RV16K_COND_E )>;
def : Pat<(RV16KBrCC GPR:$lhs, simm4:$rhs, bb:$dst,         SETEQ ),
          (BccI      GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, RV16K_COND_E )>;
// !=
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETNE ),
          (Bcc       GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, RV16K_COND_NE)>;
def : Pat<(RV16KBrCC GPR:$lhs, simm4:$rhs, bb:$dst,         SETNE ),
          (BccI      GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, RV16K_COND_NE)>;
// signed <
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETLT ),
          (Bcc       GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, RV16K_COND_L )>;
def : Pat<(RV16KBrCC GPR:$lhs, simm4:$rhs, bb:$dst,         SETLT ),
          (BccI      GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, RV16K_COND_L )>;
// signed <=
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETLE ),
          (Bcc       GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, RV16K_COND_LE)>;
def : Pat<(RV16KBrCC GPR:$lhs, simm4:$rhs, bb:$dst,         SETLE ),
          (BccI      GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, RV16K_COND_LE)>;
// signed >
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETGT ),
          (Bcc       GPR:$rhs, GPR:$lhs,   simm8_lsb0:$dst, RV16K_COND_L )>;
// signed >=
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETGE ),
          (Bcc       GPR:$rhs, GPR:$lhs,   simm8_lsb0:$dst, RV16K_COND_LE)>;
// unsigned <
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETULT),
          (Bcc       GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, RV16K_COND_B )>;
def : Pat<(RV16KBrCC GPR:$lhs, simm4:$rhs, bb:$dst,         SETULT),
          (BccI      GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, RV16K_COND_B )>;
// unsigned <=
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETULE),
          (Bcc       GPR:$lhs, GPR:$rhs,   simm8_lsb0:$dst, RV16K_COND_BE)>;
def : Pat<(RV16KBrCC GPR:$lhs, simm4:$rhs, bb:$dst,         SETULE),
          (BccI      GPR:$lhs, simm4:$rhs, simm8_lsb0:$dst, RV16K_COND_BE)>;
// unsigned >
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETUGT),
          (Bcc       GPR:$rhs, GPR:$lhs,   simm8_lsb0:$dst, RV16K_COND_B )>;
// unsigned >=
def : Pat<(RV16KBrCC GPR:$lhs, GPR:$rhs,   bb:$dst,         SETUGE),
          (Bcc       GPR:$rhs, GPR:$lhs,   simm8_lsb0:$dst, RV16K_COND_BE)>;
