; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV16K %s

declare i16 @external_function(i16)

define i16 @test_call_external(i16 %a) nounwind {
; RV16K-LABEL: test_call_external:
; RV16K:       # %bb.0:
; RV16K-NEXT:	sw	ra, 0(fp)
; RV16K-NEXT:	li	a1, external_function
; RV16K-NEXT:	jalr	a1
; RV16K-NEXT:	lw	ra, 0(fp)
; RV16K-NEXT:	jr	ra

  %1 = call i16 @external_function(i16 %a)
  ret i16 %1
}

define i16 @defined_function(i16 %a) nounwind {
; RV16K-LABEL: defined_function:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	a0, 1
; RV16K-NEXT:	jr	ra
  %1 = add i16 %a, 1
  ret i16 %1
}

define i16 @test_call_defined(i16 %a) nounwind {
; RV16K-LABEL: test_call_defined:
; RV16K:       # %bb.0:
; RV16K-NEXT	sw	ra, 0(fp)
; RV16K-NEXT	li	a1, defined_function
; RV16K-NEXT	jalr	a1
; RV16K-NEXT	lw	ra, 0(fp)
; RV16K-NEXT	jr	ra
  %1 = call i16 @defined_function(i16 %a) nounwind
  ret i16 %1
}

define i16 @test_call_indirect(i16 (i16)* %a, i16 %b) nounwind {
; RV16K-LABEL: test_call_indirect:
; RV16K:       # %bb.0:
; RV16K-NEXT:	sw	ra, 0(fp)
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	ra, 0(fp)
; RV16K-NEXT:	jr	ra

  %1 = call i16 %a(i16 %b)
  ret i16 %1
}
