; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

declare i16 @llvm.bswap.i16(i16)
declare i32 @llvm.bswap.i32(i32)
declare i8 @llvm.cttz.i8(i8, i1)
declare i16 @llvm.cttz.i16(i16, i1)
declare i32 @llvm.cttz.i32(i32, i1)
declare i16 @llvm.ctlz.i16(i16, i1)
declare i16 @llvm.ctpop.i16(i16)

define i16 @test_bswap_i16(i16 %a) nounwind {
; RV16K-LABEL: test_bswap_i16:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 2
; RV16K-NEXT:	li	a1, 8
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsl	a2, a1
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	or	a0, a2
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %tmp = call i16 @llvm.bswap.i16(i16 %a)
  ret i16 %tmp
}

define i32 @test_bswap_i32(i32 %a) nounwind {
; RV16K-LABEL: test_bswap_i32:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 2
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	li	a0, 8
; RV16K-NEXT:	mov	a3, a1
; RV16K-NEXT:	lsl	a3, a0
; RV16K-NEXT:	lsr	a1, a0
; RV16K-NEXT:	or	a1, a3
; RV16K-NEXT:	mov	a3, a2
; RV16K-NEXT:	lsl	a3, a0
; RV16K-NEXT:	lsr	a2, a0
; RV16K-NEXT:	or	a2, a3
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	mov	a1, a2
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  %tmp = call i32 @llvm.bswap.i32(i32 %a)
  ret i32 %tmp
}

define i8 @test_cttz_i8(i8 %a) nounwind {
; RV16K-LABEL: test_cttz_i8:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -4
; RV16K-NEXT:	sw	ra, 2(sp)
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 4
; RV16K-NEXT:	li	a1, 8
; RV16K-NEXT:	li	a2, 255
; RV16K-NEXT:	and	a2, a0
; RV16K-NEXT:	cmpi	a2, 0
; RV16K-NEXT:	je	.LBB2_2
; RV16K-NEXT:	j	.LBB2_1
; RV16K-NEXT:.LBB2_1:                                # %cond.false
; RV16K-NEXT:	li	a1, -1
; RV16K-NEXT:	xor	a1, a0
; RV16K-NEXT:	addi	a0, -1
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 21845
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	sub	a0, a1
; RV16K-NEXT:	li	a1, 2
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 13107
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	and	a2, a1
; RV16K-NEXT:	add	a2, a0
; RV16K-NEXT:	li	a0, 4
; RV16K-NEXT:	mov	a1, a2
; RV16K-NEXT:	lsr	a1, a0
; RV16K-NEXT:	add	a1, a2
; RV16K-NEXT:	li	a0, 3855
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	li	a2, __mulhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	li	a0, 8
; RV16K-NEXT:	lsr	a1, a0
; RV16K-NEXT:.LBB2_2:                                # %cond.end
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	lw	ra, 2(sp)
; RV16K-NEXT:	addi	sp, 4
; RV16K-NEXT:	jr	ra

  %tmp = call i8 @llvm.cttz.i8(i8 %a, i1 false)
  ret i8 %tmp
}

define i16 @test_cttz_i16(i16 %a) nounwind {
; RV16K-LABEL: test_cttz_i16:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -4
; RV16K-NEXT:	sw	ra, 2(sp)
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 4
; RV16K-NEXT:	li	a1, 16
; RV16K-NEXT:	cmpi	a0, 0
; RV16K-NEXT:	je	.LBB3_2
; RV16K-NEXT:	j	.LBB3_1
; RV16K-NEXT:.LBB3_1:                                # %cond.false
; RV16K-NEXT:	li	a1, -1
; RV16K-NEXT:	xor	a1, a0
; RV16K-NEXT:	addi	a0, -1
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 21845
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	sub	a0, a1
; RV16K-NEXT:	li	a1, 2
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 13107
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	and	a2, a1
; RV16K-NEXT:	add	a2, a0
; RV16K-NEXT:	li	a0, 4
; RV16K-NEXT:	mov	a1, a2
; RV16K-NEXT:	lsr	a1, a0
; RV16K-NEXT:	add	a1, a2
; RV16K-NEXT:	li	a0, 3855
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	li	a2, __mulhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	li	a0, 8
; RV16K-NEXT:	lsr	a1, a0
; RV16K-NEXT:.LBB3_2:                                # %cond.end
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	lw	ra, 2(sp)
; RV16K-NEXT:	addi	sp, 4
; RV16K-NEXT:	jr	ra

  %tmp = call i16 @llvm.cttz.i16(i16 %a, i1 false)
  ret i16 %tmp
}

define i32 @test_cttz_i32(i32 %a) nounwind {
; RV16K-LABEL: test_cttz_i32:
; RV16K:       # %bb.0:

; RV16K-NEXT:	li	a2, 26
; RV16K-NEXT:	sub	sp, a2
; RV16K-NEXT:	sw	ra, 24(sp)
; RV16K-NEXT:	sw	fp, 22(sp)
; RV16K-NEXT:	sw	s0, 20(sp)
; RV16K-NEXT:	sw	s1, 18(sp)
; RV16K-NEXT:	sw	s2, 16(sp)
; RV16K-NEXT:	sw	s3, 14(sp)
; RV16K-NEXT:	sw	s4, 12(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	li	a2, 26
; RV16K-NEXT:	add	fp, a2
; RV16K-NEXT:	mov	s1, a1
; RV16K-NEXT:	sw	a0, -16(fp)
; RV16K-NEXT:	li	s0, -1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	xor	a2, s0
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	addi	a1, -1
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	li	a2, 1
; RV16K-NEXT:	sw	a2, -18(fp)
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lsr	a0, a2
; RV16K-NEXT:	li	a2, 21845
; RV16K-NEXT:	sw	a2, -20(fp)
; RV16K-NEXT:	and	a0, a2
; RV16K-NEXT:	sub	a1, a0
; RV16K-NEXT:	li	s4, 13107
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	and	a0, s4
; RV16K-NEXT:	li	a2, 2
; RV16K-NEXT:	sw	a2, -26(fp)
; RV16K-NEXT:	lsr	a1, a2
; RV16K-NEXT:	and	a1, s4
; RV16K-NEXT:	add	a1, a0
; RV16K-NEXT:	li	a2, 4
; RV16K-NEXT:	sw	a2, -24(fp)
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lsr	a0, a2
; RV16K-NEXT:	add	a0, a1
; RV16K-NEXT:	li	s3, 3855
; RV16K-NEXT:	and	a0, s3
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	sw	a1, -22(fp)
; RV16K-NEXT:	li	s2, __mulhi3
; RV16K-NEXT:	jalr	s2
; RV16K-NEXT:	mov	a2, s2
; RV16K-NEXT:	mov	s2, a0
; RV16K-NEXT:	xor	s0, s1
; RV16K-NEXT:	addi	s1, -1
; RV16K-NEXT:	and	s1, s0
; RV16K-NEXT:	mov	a0, s1
; RV16K-NEXT:	lw	a1, -18(fp)
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	lw	a1, -20(fp)
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	sub	s1, a0
; RV16K-NEXT:	mov	a0, s1
; RV16K-NEXT:	lw	a1, -26(fp)
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	and	s1, s4
; RV16K-NEXT:	and	a0, s4
; RV16K-NEXT:	add	a0, s1
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	lw	a3, -24(fp)
; RV16K-NEXT:	lsr	a1, a3
; RV16K-NEXT:	add	a1, a0
; RV16K-NEXT:	and	s3, a1
; RV16K-NEXT:	li	s0, 8
; RV16K-NEXT:	lsr	s2, s0
; RV16K-NEXT:	mov	a0, s3
; RV16K-NEXT:	lw	a1, -22(fp)
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	a1, -16(fp)
; RV16K-NEXT:	cmpi	a1, 0
; RV16K-NEXT:	jne	.LBB4_2
; RV16K-NEXT:# %bb.1:
; RV16K-NEXT:	lsr	a0, s0
; RV16K-NEXT:	li	s2, 16
; RV16K-NEXT:	add	s2, a0
; RV16K-NEXT:.LBB4_2:
; RV16K-NEXT:	li	a1, 0
; RV16K-NEXT:	mov	a0, s2
; RV16K-NEXT:	lw	s4, 12(sp)
; RV16K-NEXT:	lw	s3, 14(sp)
; RV16K-NEXT:	lw	s2, 16(sp)
; RV16K-NEXT:	lw	s1, 18(sp)
; RV16K-NEXT:	lw	s0, 20(sp)
; RV16K-NEXT:	lw	fp, 22(sp)
; RV16K-NEXT:	lw	ra, 24(sp)
; RV16K-NEXT:	li	a2, 26
; RV16K-NEXT:	add	sp, a2
; RV16K-NEXT:	jr	ra

  %tmp = call i32 @llvm.cttz.i32(i32 %a, i1 false)
  ret i32 %tmp
}

define i8 @test_cttz_i8_zero_undef(i8 %a) nounwind {
; RV16K-LABEL: test_cttz_i8_zero_undef:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -4
; RV16K-NEXT:	sw	ra, 2(sp)
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 4
; RV16K-NEXT:	li	a1, -1
; RV16K-NEXT:	xor	a1, a0
; RV16K-NEXT:	addi	a0, -1
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 21845
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	sub	a0, a1
; RV16K-NEXT:	li	a1, 2
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 13107
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	and	a2, a1
; RV16K-NEXT:	add	a2, a0
; RV16K-NEXT:	li	a1, 4
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	add	a0, a2
; RV16K-NEXT:	li	a1, 3855
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	li	a2, __mulhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	li	a1, 8
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	lw	ra, 2(sp)
; RV16K-NEXT:	addi	sp, 4
; RV16K-NEXT:	jr	ra

  %tmp = call i8 @llvm.cttz.i8(i8 %a, i1 true)
  ret i8 %tmp
}

define i16 @test_cttz_i16_zero_undef(i16 %a) nounwind {
; RV16K-LABEL: test_cttz_i16_zero_undef:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -4
; RV16K-NEXT:	sw	ra, 2(sp)
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 4
; RV16K-NEXT:	li	a1, -1
; RV16K-NEXT:	xor	a1, a0
; RV16K-NEXT:	addi	a0, -1
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 21845
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	sub	a0, a1
; RV16K-NEXT:	li	a1, 2
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 13107
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	and	a2, a1
; RV16K-NEXT:	add	a2, a0
; RV16K-NEXT:	li	a1, 4
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	add	a0, a2
; RV16K-NEXT:	li	a1, 3855
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	li	a2, __mulhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	li	a1, 8
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	lw	ra, 2(sp)
; RV16K-NEXT:	addi	sp, 4
; RV16K-NEXT:	jr	ra

  %tmp = call i16 @llvm.cttz.i16(i16 %a, i1 true)
  ret i16 %tmp
}

define i32 @test_cttz_i32_zero_undef(i32 %a) nounwind {
; RV16K-LABEL: test_cttz_i32_zero_undef:
; RV16K:       # %bb.0:

; RV16K-NEXT:	li	a2, 26
; RV16K-NEXT:	sub	sp, a2
; RV16K-NEXT:	sw	ra, 24(sp)
; RV16K-NEXT:	sw	fp, 22(sp)
; RV16K-NEXT:	sw	s0, 20(sp)
; RV16K-NEXT:	sw	s1, 18(sp)
; RV16K-NEXT:	sw	s2, 16(sp)
; RV16K-NEXT:	sw	s3, 14(sp)
; RV16K-NEXT:	sw	s4, 12(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	li	a2, 26
; RV16K-NEXT:	add	fp, a2
; RV16K-NEXT:	mov	s1, a1
; RV16K-NEXT:	sw	a0, -16(fp)
; RV16K-NEXT:	li	s0, -1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	xor	a2, s0
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	addi	a1, -1
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	li	a2, 1
; RV16K-NEXT:	sw	a2, -18(fp)
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lsr	a0, a2
; RV16K-NEXT:	li	a2, 21845
; RV16K-NEXT:	sw	a2, -20(fp)
; RV16K-NEXT:	and	a0, a2
; RV16K-NEXT:	sub	a1, a0
; RV16K-NEXT:	li	s4, 13107
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	and	a0, s4
; RV16K-NEXT:	li	a2, 2
; RV16K-NEXT:	sw	a2, -26(fp)
; RV16K-NEXT:	lsr	a1, a2
; RV16K-NEXT:	and	a1, s4
; RV16K-NEXT:	add	a1, a0
; RV16K-NEXT:	li	a2, 4
; RV16K-NEXT:	sw	a2, -24(fp)
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lsr	a0, a2
; RV16K-NEXT:	add	a0, a1
; RV16K-NEXT:	li	s3, 3855
; RV16K-NEXT:	and	a0, s3
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	sw	a1, -22(fp)
; RV16K-NEXT:	li	s2, __mulhi3
; RV16K-NEXT:	jalr	s2
; RV16K-NEXT:	mov	a2, s2
; RV16K-NEXT:	mov	s2, a0
; RV16K-NEXT:	xor	s0, s1
; RV16K-NEXT:	addi	s1, -1
; RV16K-NEXT:	and	s1, s0
; RV16K-NEXT:	mov	a0, s1
; RV16K-NEXT:	lw	a1, -18(fp)
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	lw	a1, -20(fp)
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	sub	s1, a0
; RV16K-NEXT:	mov	a0, s1
; RV16K-NEXT:	lw	a1, -26(fp)
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	and	s1, s4
; RV16K-NEXT:	and	a0, s4
; RV16K-NEXT:	add	a0, s1
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	lw	a3, -24(fp)
; RV16K-NEXT:	lsr	a1, a3
; RV16K-NEXT:	add	a1, a0
; RV16K-NEXT:	and	s3, a1
; RV16K-NEXT:	li	s0, 8
; RV16K-NEXT:	lsr	s2, s0
; RV16K-NEXT:	mov	a0, s3
; RV16K-NEXT:	lw	a1, -22(fp)
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	lw	a1, -16(fp)
; RV16K-NEXT:	cmpi	a1, 0
; RV16K-NEXT:	jne	.LBB7_2
; RV16K-NEXT:# %bb.1:
; RV16K-NEXT:	lsr	a0, s0
; RV16K-NEXT:	li	s2, 16
; RV16K-NEXT:	add	s2, a0
; RV16K-NEXT:.LBB7_2:
; RV16K-NEXT:	li	a1, 0
; RV16K-NEXT:	mov	a0, s2
; RV16K-NEXT:	lw	s4, 12(sp)
; RV16K-NEXT:	lw	s3, 14(sp)
; RV16K-NEXT:	lw	s2, 16(sp)
; RV16K-NEXT:	lw	s1, 18(sp)
; RV16K-NEXT:	lw	s0, 20(sp)
; RV16K-NEXT:	lw	fp, 22(sp)
; RV16K-NEXT:	lw	ra, 24(sp)
; RV16K-NEXT:	li	a2, 26
; RV16K-NEXT:	add	sp, a2
; RV16K-NEXT:	jr	ra

  %tmp = call i32 @llvm.cttz.i32(i32 %a, i1 true)
  ret i32 %tmp
}

define i16 @test_ctlz_i16(i16 %a) nounwind {
; RV16K-LABEL: test_ctlz_i16:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -6
; RV16K-NEXT:	sw	ra, 4(sp)
; RV16K-NEXT:	sw	fp, 2(sp)
; RV16K-NEXT:	sw	s0, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 6
; RV16K-NEXT:	li	a1, 16
; RV16K-NEXT:	cmpi	a0, 0
; RV16K-NEXT:	je	.LBB8_2
; RV16K-NEXT:	j	.LBB8_1
; RV16K-NEXT:.LBB8_1:                                # %cond.false
; RV16K-NEXT:	li	a1, 1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	or	a2, a0
; RV16K-NEXT:	li	a0, 2
; RV16K-NEXT:	mov	a3, a2
; RV16K-NEXT:	lsr	a3, a0
; RV16K-NEXT:	or	a3, a2
; RV16K-NEXT:	li	a2, 4
; RV16K-NEXT:	mov	a4, a3
; RV16K-NEXT:	lsr	a4, a2
; RV16K-NEXT:	or	a4, a3
; RV16K-NEXT:	li	s0, 8
; RV16K-NEXT:	mov	a3, a4
; RV16K-NEXT:	lsr	a3, s0
; RV16K-NEXT:	or	a3, a4
; RV16K-NEXT:	li	a4, -1
; RV16K-NEXT:	xor	a4, a3
; RV16K-NEXT:	mov	a3, a4
; RV16K-NEXT:	lsr	a3, a1
; RV16K-NEXT:	li	a1, 21845
; RV16K-NEXT:	and	a1, a3
; RV16K-NEXT:	sub	a4, a1
; RV16K-NEXT:	mov	a1, a4
; RV16K-NEXT:	lsr	a1, a0
; RV16K-NEXT:	li	a0, 13107
; RV16K-NEXT:	and	a4, a0
; RV16K-NEXT:	and	a1, a0
; RV16K-NEXT:	add	a1, a4
; RV16K-NEXT:	mov	a3, a1
; RV16K-NEXT:	lsr	a3, a2
; RV16K-NEXT:	add	a3, a1
; RV16K-NEXT:	li	a0, 3855
; RV16K-NEXT:	and	a0, a3
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	li	a2, __mulhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	mov	a1, a0
; RV16K-NEXT:	lsr	a1, s0
; RV16K-NEXT:.LBB8_2:                                # %cond.end
; RV16K-NEXT:	mov	a0, a1
; RV16K-NEXT:	lw	s0, 0(sp)
; RV16K-NEXT:	lw	fp, 2(sp)
; RV16K-NEXT:	lw	ra, 4(sp)
; RV16K-NEXT:	addi	sp, 6
; RV16K-NEXT:	jr	ra

  %tmp = call i16 @llvm.ctlz.i16(i16 %a, i1 false)
  ret i16 %tmp
}

define i16 @test_ctpop_i16(i16 %a) nounwind {
; RV16K-LABEL: test_ctpop_i16:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -4
; RV16K-NEXT:	sw	ra, 2(sp)
; RV16K-NEXT:	sw	fp, 0(sp)
; RV16K-NEXT:	mov	fp, sp
; RV16K-NEXT:	addi	fp, 4
; RV16K-NEXT:	li	a1, 1
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 21845
; RV16K-NEXT:	and	a1, a2
; RV16K-NEXT:	sub	a0, a1
; RV16K-NEXT:	li	a1, 2
; RV16K-NEXT:	mov	a2, a0
; RV16K-NEXT:	lsr	a2, a1
; RV16K-NEXT:	li	a1, 13107
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	and	a2, a1
; RV16K-NEXT:	add	a2, a0
; RV16K-NEXT:	li	a1, 4
; RV16K-NEXT:	mov	a0, a2
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	add	a0, a2
; RV16K-NEXT:	li	a1, 3855
; RV16K-NEXT:	and	a0, a1
; RV16K-NEXT:	li	a1, 257
; RV16K-NEXT:	li	a2, __mulhi3
; RV16K-NEXT:	jalr	a2
; RV16K-NEXT:	li	a1, 8
; RV16K-NEXT:	lsr	a0, a1
; RV16K-NEXT:	lw	fp, 0(sp)
; RV16K-NEXT:	lw	ra, 2(sp)
; RV16K-NEXT:	addi	sp, 4
; RV16K-NEXT:	jr	ra

  %1 = call i16 @llvm.ctpop.i16(i16 %a)
  ret i16 %1
}
