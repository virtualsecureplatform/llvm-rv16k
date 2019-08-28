; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV16K %s

define i16 @foo(i16 %a, i16 *%b) {
; RV16K-LABEL: foo:
; RV16K:# %bb.0:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jne	.LBB0_11
; RV16K-NEXT:# %bb.1:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	je	.LBB0_12
; RV16K-NEXT:.LBB0_2:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jbe	.LBB0_13
; RV16K-NEXT:.LBB0_3:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jb	.LBB0_14
; RV16K-NEXT:.LBB0_4:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jbe	.LBB0_15
; RV16K-NEXT:.LBB0_5:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jb	.LBB0_16
; RV16K-NEXT:.LBB0_6:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jle	.LBB0_17
; RV16K-NEXT:.LBB0_7:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jl	.LBB0_18
; RV16K-NEXT:.LBB0_8:
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jle	.LBB0_19
; RV16K-NEXT:.LBB0_9:
; RV16K-NEXT:	lw	a1, 0(a1)
; RV16K-NEXT:	cmp	a1, a0
; RV16K-NEXT:	jl	.LBB0_20
; RV16K-NEXT:.LBB0_10:
; RV16K-NEXT:	jr	ra
; RV16K-NEXT:.LBB0_11:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jne	.LBB0_2
; RV16K-NEXT:.LBB0_12:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jb	.LBB0_3
; RV16K-NEXT:.LBB0_13:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jbe	.LBB0_4
; RV16K-NEXT:.LBB0_14:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jb	.LBB0_5
; RV16K-NEXT:.LBB0_15:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jbe	.LBB0_6
; RV16K-NEXT:.LBB0_16:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jl	.LBB0_7
; RV16K-NEXT:.LBB0_17:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a2, a0
; RV16K-NEXT:	jle	.LBB0_8
; RV16K-NEXT:.LBB0_18:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a2, 0(a1)
; RV16K-NEXT:	cmp	a0, a2
; RV16K-NEXT:	jl	.LBB0_9
; RV16K-NEXT:.LBB0_19:
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lw	a1, 0(a1)
; RV16K-NEXT:	cmp	a0, a1
; RV16K-NEXT:	jle	.LBB0_10
; RV16K-NEXT:.LBB0_20:
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	jr	ra

  %val1 = load volatile i16, i16* %b
  %tst1 = icmp eq i16 %a, %val1
  %val2 = select i1 %tst1, i16 %a, i16 %val1

  %val3 = load volatile i16, i16* %b
  %tst2 = icmp ne i16 %val2, %val3
  %val4 = select i1 %tst2, i16 %val2, i16 %val3

  %val5 = load volatile i16, i16* %b
  %tst3 = icmp ugt i16 %val4, %val5
  %val6 = select i1 %tst3, i16 %val4, i16 %val5

  %val7 = load volatile i16, i16* %b
  %tst4 = icmp uge i16 %val6, %val7
  %val8 = select i1 %tst4, i16 %val6, i16 %val7

  %val9 = load volatile i16, i16* %b
  %tst5 = icmp ult i16 %val8, %val9
  %val10 = select i1 %tst5, i16 %val8, i16 %val9

  %val11 = load volatile i16, i16* %b
  %tst6 = icmp ule i16 %val10, %val11
  %val12 = select i1 %tst6, i16 %val10, i16 %val11

  %val13 = load volatile i16, i16* %b
  %tst7 = icmp sgt i16 %val12, %val13
  %val14 = select i1 %tst7, i16 %val12, i16 %val13

  %val15 = load volatile i16, i16* %b
  %tst8 = icmp sge i16 %val14, %val15
  %val16 = select i1 %tst8, i16 %val14, i16 %val15

  %val17 = load volatile i16, i16* %b
  %tst9 = icmp slt i16 %val16, %val17
  %val18 = select i1 %tst9, i16 %val16, i16 %val17

  %val19 = load volatile i16, i16* %b
  %tst10 = icmp sle i16 %val18, %val19
  %val20 = select i1 %tst10, i16 %val18, i16 %val19

  ret i16 %val20
}
