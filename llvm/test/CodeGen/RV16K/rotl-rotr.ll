; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

; These IR sequences will generate ISD::ROTL and ISD::ROTR nodes, that the
; RISC-V backend must be able to select

define i16 @rotl(i16 %x, i16 %y) {
; RV16K-LABEL: rotl:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 2
; RV16K-NEXT:	li	a2, 16
; RV16K-NEXT:	sub	a2, a1
; RV16K-NEXT:	mov	a3, a0
; RV16K-NEXT:	lsl	a3, a1
; RV16K-NEXT:	lsr	a0, a2
; RV16K-NEXT:	or	a0, a3
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %z = sub i16 16, %y
  %b = shl i16 %x, %y
  %c = lshr i16 %x, %z
  %d = or i16 %b, %c
  ret i16 %d
}

define i16 @rotr(i16 %x, i16 %y) {
; RV16K-LABEL: rotr:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 2
; RV16K-NEXT:	li	a2, 16
; RV16K-NEXT:	sub	a2, a1
; RV16K-NEXT:	mov	a3, a0
; RV16K-NEXT:	lsr	a3, a1
; RV16K-NEXT:	lsl	a0, a2
; RV16K-NEXT:	or	a0, a3
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra
  %z = sub i16 16, %y
  %b = lshr i16 %x, %y
  %c = shl i16 %x, %z
  %d = or i16 %b, %c
  ret i16 %d
}
