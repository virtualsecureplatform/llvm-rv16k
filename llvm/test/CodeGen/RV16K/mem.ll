; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

; Check indexed and unindexed, sext, zext and anyext loads

define i16 @lb(i8 *%a) nounwind {
; RV16K-LABEL: lb:
; RV16K:       # %bb.0:
; RV16K-NEXT:	lb	a1, 0(a0)
; RV16K-NEXT:	lb	a0, 1(a0)
; RV16K-NEXT:	jr	ra

  %1 = getelementptr i8, i8* %a, i16 1
  %2 = load i8, i8* %1
  %3 = sext i8 %2 to i16
  ; the unused load will produce an anyext for selection
  %4 = load volatile i8, i8* %a
  ret i16 %3
}

define i16 @lbu(i8 *%a) nounwind {
; RV16K-LABEL: lbu:
; RV16K:       # %bb.0:
; RV16K-NEXT:	lbu	a1, 0(a0)
; RV16K-NEXT:	lbu	a0, 4(a0)
; RV16K-NEXT:	add	a0, a1
; RV16K-NEXT:	jr	ra

  %1 = getelementptr i8, i8* %a, i16 4
  %2 = load i8, i8* %1
  %3 = zext i8 %2 to i16
  %4 = load volatile i8, i8* %a
  %5 = zext i8 %4 to i16
  %6 = add i16 %3, %5
  ret i16 %6
}

define i16 @lw(i16 *%a) nounwind {
; RV16K-LABEL: lw:
; RV16K:       # %bb.0:
; RV16K-NEXT:	lw	a1, 0(a0)
; RV16K-NEXT:	lw	a0, 6(a0)
; RV16K-NEXT:	jr	ra

  %1 = getelementptr i16, i16* %a, i16 3
  %2 = load i16, i16* %1
  %3 = load volatile i16, i16* %a
  ret i16 %2
}

; Check indexed and unindexed stores

define void @sb(i8 *%a, i8 %b) nounwind {
; RV16K-LABEL: sb:
; RV16K:       # %bb.0:
; RV16K-NEXT:	sb	a1, 6(a0)
; RV16K-NEXT:	sb	a1, 0(a0)
; RV16K-NEXT:	jr	ra

  store i8 %b, i8* %a
  %1 = getelementptr i8, i8* %a, i16 6
  store i8 %b, i8* %1
  ret void
}

define void @sw(i16 *%a, i16 %b) nounwind {
; RV16K-LABEL: sw:
; RV16K:       # %bb.0:
; RV16K-NEXT:	sw	a1, 16(a0)
; RV16K-NEXT:	sw	a1, 0(a0)
; RV16K-NEXT:	jr	ra

  store i16 %b, i16* %a
  %1 = getelementptr i16, i16* %a, i16 8
  store i16 %b, i16* %1
  ret void
}

define i16 @load_sext_zext_anyext_i1(i1 *%a) nounwind {
; RV16K-LABEL: load_sext_zext_anyext_i1:
; RV16K:       # %bb.0:
; RV16K-NEXT:	lb	a1, 0(a0)
; RV16K-NEXT:	lbu	a1, 1(a0)
; RV16K-NEXT:	lbu	a0, 2(a0)
; RV16K-NEXT:	sub	a0, a1
; RV16K-NEXT:	jr	ra

  ; sextload i1
  %1 = getelementptr i1, i1* %a, i16 1
  %2 = load i1, i1* %1
  %3 = sext i1 %2 to i16
  ; zextload i1
  %4 = getelementptr i1, i1* %a, i16 2
  %5 = load i1, i1* %4
  %6 = zext i1 %5 to i16
  %7 = add i16 %3, %6
  ; extload i1 (anyext). Produced as the load is unused.
  %8 = load volatile i1, i1* %a
  ret i16 %7
}

; Check load and store to a global
@G = global i16 0

define i16 @lw_sw_global(i16 %a) nounwind {
; RV16K-LABEL: lw_sw_global:
; RV16K:       # %bb.0:
; RV16K-NEXT:	li	a2, G
; RV16K-NEXT:	lw	a1, 0(a2)
; RV16K-NEXT:	sw	a0, 0(a2)
; RV16K-NEXT:	li	a2, G+18
; RV16K-NEXT:	lw	a3, 0(a2)
; RV16K-NEXT:	sw	a0, 0(a2)
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	jr	ra

  %1 = load volatile i16, i16* @G
  store i16 %a, i16* @G
  %2 = getelementptr i16, i16* @G, i16 9
  %3 = load volatile i16, i16* %2
  store i16 %a, i16* %2
  ret i16 %1
}
