; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV16K %s

define void @foo(i16 %a, i16 *%b, i1 %c) {
; RV16K-LABEL: foo:
; RV16K:       # %bb.0:
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a3, a0
; RV16K:	je	.LBB0_12
; RV16K:	j	.LBB0_1
; RV16K:.LBB0_1:                                # %test2
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a3, a0
; RV16K:	jne	.LBB0_12
; RV16K:	j	.LBB0_2
; RV16K:.LBB0_2:                                # %test3
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a3, a0
; RV16K:	jl	.LBB0_12
; RV16K:	j	.LBB0_3
; RV16K:.LBB0_3:                                # %test4
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a0, a3
; RV16K:	jle	.LBB0_12
; RV16K:	j	.LBB0_4
; RV16K:.LBB0_4:                                # %test5
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a3, a0
; RV16K:	jb	.LBB0_12
; RV16K:	j	.LBB0_5
; RV16K:.LBB0_5:                                # %test6
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a0, a3
; RV16K:	jbe	.LBB0_12
; RV16K:	j	.LBB0_6
; RV16K:.LBB0_6:                                # %test7
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a0, a3
; RV16K:	jl	.LBB0_12
; RV16K:	j	.LBB0_7
; RV16K:.LBB0_7:                                # %test8
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a3, a0
; RV16K:	jle	.LBB0_12
; RV16K:	j	.LBB0_8
; RV16K:.LBB0_8:                                # %test9
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a0, a3
; RV16K:	jb	.LBB0_12
; RV16K:	j	.LBB0_9
; RV16K:.LBB0_9:                                # %test10
; RV16K:	lw	a3, 0(a1)
; RV16K:	cmp	a3, a0
; RV16K:	jbe	.LBB0_12
; RV16K:	j	.LBB0_10
; RV16K:.LBB0_10:                               # %test11
; RV16K:	lw	a0, 0(a1)
; RV16K:	li	a0, 1
; RV16K:	and	a2, a0
; RV16K:	li	a0, 0
; RV16K:	cmp	a2, a0
; RV16K:	jne	.LBB0_12
; RV16K:	j	.LBB0_11
; RV16K:.LBB0_11:                               # %test12
; RV16K:	lw	a0, 0(a1)
; RV16K:.LBB0_12:                               # %end
; RV16K:	jr	ra

  %val1 = load volatile i16, i16* %b
  %tst1 = icmp eq i16 %val1, %a
  br i1 %tst1, label %end, label %test2

test2:
  %val2 = load volatile i16, i16* %b
  %tst2 = icmp ne i16 %val2, %a
  br i1 %tst2, label %end, label %test3

test3:
  %val3 = load volatile i16, i16* %b
  %tst3 = icmp slt i16 %val3, %a
  br i1 %tst3, label %end, label %test4

test4:
  %val4 = load volatile i16, i16* %b
  %tst4 = icmp sge i16 %val4, %a
  br i1 %tst4, label %end, label %test5

test5:
  %val5 = load volatile i16, i16* %b
  %tst5 = icmp ult i16 %val5, %a
  br i1 %tst5, label %end, label %test6

test6:
  %val6 = load volatile i16, i16* %b
  %tst6 = icmp uge i16 %val6, %a
  br i1 %tst6, label %end, label %test7

; Check for condition codes that don't have a matching instruction

test7:
  %val7 = load volatile i16, i16* %b
  %tst7 = icmp sgt i16 %val7, %a
  br i1 %tst7, label %end, label %test8

test8:
  %val8 = load volatile i16, i16* %b
  %tst8 = icmp sle i16 %val8, %a
  br i1 %tst8, label %end, label %test9

test9:
  %val9 = load volatile i16, i16* %b
  %tst9 = icmp ugt i16 %val9, %a
  br i1 %tst9, label %end, label %test10

test10:
  %val10 = load volatile i16, i16* %b
  %tst10 = icmp ule i16 %val10, %a
  br i1 %tst10, label %end, label %test11

; Check the case of a branch where the condition was generated in another
; function

test11:
  %val11 = load volatile i16, i16* %b
  br i1 %c, label %end, label %test12

test12:
  %val12 = load volatile i16, i16* %b
  br label %end

end:
  ret void
}
