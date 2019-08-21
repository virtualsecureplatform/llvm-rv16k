; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

define i16 @udiv(i16 %a, i16 %b) nounwind {
; RV16K-LABEL: udiv:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a2, __udivhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = udiv i16 %a, %b
  ret i16 %1
}

define i16 @udiv_constant(i16 %a) nounwind {
; RV16K-LABEL: udiv_constant:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a1, 5
; RV16K-NEXT:	li	a2, __udivhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = udiv i16 %a, 5
  ret i16 %1
}

define i16 @udiv_pow2(i16 %a) nounwind {
; RV16K-LABEL: udiv_pow2:
; RV16K:       # %bb.0:
; RV16K-NEXT:	li	a1, 3
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	jr	ra

  %1 = udiv i16 %a, 8
  ret i16 %1
}

define i32 @udiv32(i32 %a, i32 %b) nounwind {
; RV16K-LABEL: udiv32:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a4, __udivsi3
; RV16K-NEXT:	jalr	a4
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @udiv32_constant(i32 %a) nounwind {
; RV16K-LABEL: udiv32_constant:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a2, 5
; RV16K-NEXT:	li	a3, 0
; RV16K-NEXT:	li	a4, __udivsi3
; RV16K-NEXT:	jalr	a4
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = udiv i32 %a, 5
  ret i32 %1
}

define i16 @sdiv(i16 %a, i16 %b) nounwind {
; RV16K-LABEL: sdiv:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a2, __divhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = sdiv i16 %a, %b
  ret i16 %1
}

define i16 @sdiv_constant(i16 %a) nounwind {
; RV16K-LABEL: sdiv_constant:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a1, 5
; RV16K-NEXT:	li	a2, __divhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = sdiv i16 %a, 5
  ret i16 %1
}

define i16 @sdiv_pow2(i16 %a) nounwind {
; RV16K-LABEL: sdiv_pow2:
; RV16K:       # %bb.0:
; RV16K-NEXT:	li	a2, 15
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	asr	a1, a2
; RV16K-NEXT:	li	a2, 13
; RV16K-NEXT:	lsr	a1, a2
; RV16K-NEXT:	add	a1, a0
; RV16K-NEXT:	li	a0, 3
; RV16K-NEXT:	asr	a1, a0
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	jr	ra

  %1 = sdiv i16 %a, 8
  ret i16 %1
}

define i32 @sdiv32(i32 %a, i32 %b) nounwind {
; RV16K-LABEL: sdiv32:
; RV16K:       # %bb.0:
; RV16K:	addi	sp, -2
; RV16K:	sw	ra, 0(sp)
; RV16K:	li	a4, __divsi3
; RV16K:	jalr	a4
; RV16K:	lw	ra, 0(sp)
; RV16K:	addi	sp, 2
; RV16K:	jr	ra

  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @sdiv32_constant(i32 %a) nounwind {
; RV16K-LABEL: sdiv32_constant:
; RV16K:       # %bb.0:
; RV16K:	addi	sp, -2
; RV16K:	sw	ra, 0(sp)
; RV16K:	li	a2, 5
; RV16K:	li	a3, 0
; RV16K:	li	a4, __divsi3
; RV16K:	jalr	a4
; RV16K:	lw	ra, 0(sp)
; RV16K:	addi	sp, 2
; RV16K:	jr	ra

  %1 = sdiv i32 %a, 5
  ret i32 %1
}
