; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

define i16 @foo(i16 %a) {
; RV16K-LABEL: foo
; RV16K:       # %bb.0:
; RV16K-NEXT:	li	a1, 6000
; RV16K-NEXT:	sub	sp, a1
; RV16K-NEXT:	lwsp	a1, 510(sp)
; RV16K-NEXT:	add	a0, a1
; RV16K-NEXT:	swsp	a0, 510(sp)
; RV16K-NEXT:	li	a1, 6000
; RV16K-NEXT:	add	sp, a1
; RV16K-NEXT:	jr	ra

  %1 = alloca [3000 x i16]
  %2 = getelementptr [3000 x i16], [3000 x i16]* %1, i16 0, i16 255
  %3 = load i16, i16* %2
  %4 = add i16 %3, %a
  store i16 %4, i16* %2
  ret i16 %4
}

define i16 @bar(i16 %a) {
; RV16K-LABEL: bar
; RV16K:       # %bb.0:
; RV16K-NEXT:	li	a1, 6000
; RV16K-NEXT:	sub	sp, a1
; RV16K-NEXT:	lw	a1, 512(sp)
; RV16K-NEXT:	add	a0, a1
; RV16K-NEXT:	sw	a0, 512(sp)
; RV16K-NEXT:	li	a1, 6000
; RV16K-NEXT:	add	sp, a1
; RV16K-NEXT:	jr	ra

  %1 = alloca [3000 x i16]
  %2 = getelementptr [3000 x i16], [3000 x i16]* %1, i16 0, i16 256
  %3 = load i16, i16* %2
  %4 = add i16 %3, %a
  store i16 %4, i16* %2
  ret i16 %4
}
