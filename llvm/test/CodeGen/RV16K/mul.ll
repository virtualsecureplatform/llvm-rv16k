; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

define i16 @square(i16 %a) nounwind {
; RV16K-LABEL: square:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	swsp	ra, 0(sp)
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	jal	__mulhi3
; RV16K-NEXT:	lwsp	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = mul i16 %a, %a
  ret i16 %1
}

define i16 @mul(i16 %a, i16 %b) nounwind {
; RV16K-LABEL: mul:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	swsp	ra, 0(sp)
; RV16K-NEXT:	jal	__mulhi3
; RV16K-NEXT:	lwsp	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = mul i16 %a, %b
  ret i16 %1
}

define i16 @mul_constant(i16 %a) nounwind {
; RV16K-LABEL: mul_constant:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	swsp	ra, 0(sp)
; RV16K-NEXT:	li	a1, 5
; RV16K-NEXT:	jal	__mulhi3
; RV16K-NEXT:	lwsp	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = mul i16 %a, 5
  ret i16 %1
}

define i16 @mul_pow2(i16 %a) nounwind {
; RV16K-LABEL: mul_pow2:
; RV16K:       # %bb.0:
; RV16K-NEXT:	li	a1, 3
; RV16K-NEXT:	lsl	a0, a1
; RV16K-NEXT:	jr	ra

  %1 = mul i16 %a, 8
  ret i16 %1
}

define i32 @mul32(i32 %a, i32 %b) nounwind {
; RV16K-LABEL: mul32:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	swsp	ra, 0(sp)
; RV16K-NEXT:	jal	__mulsi3
; RV16K-NEXT:	lwsp	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = mul i32 %a, %b
  ret i32 %1
}

define i32 @mul32_constant(i32 %a) nounwind {
; RV16K-LABEL: mul32_constant:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	swsp	ra, 0(sp)
; RV16K-NEXT:	li	a2, 5
; RV16K-NEXT:	li	a3, 0
; RV16K-NEXT:	jal	__mulsi3
; RV16K-NEXT:	lwsp	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %1 = mul i32 %a, 5
  ret i32 %1
}
