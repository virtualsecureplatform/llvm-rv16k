; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=rv16k -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV16K

@addr = global i8* null

define void @test_blockaddress() nounwind {
; RV16K-LABEL: test_blockaddress:
; RV16K:       # %bb.0:
; RV16K-NEXT:	addi	sp, -2
; RV16K-NEXT:	sw	ra, 0(sp)
; RV16K-NEXT:	li	a0, addr
; RV16K-NEXT:	li	a1, .Ltmp0
; RV16K-NEXT:	sw	a1, 0(a0)
; RV16K-NEXT:	lw	a0, 0(a0)
; RV16K-NEXT:	jalr	a0
; RV16K-NEXT:.Ltmp0:                                 # Block address taken
; RV16K-NEXT:# %bb.1:                                # %block
; RV16K-NEXT:	lw	ra, 0(sp)
; RV16K-NEXT:	addi	sp, 2
; RV16K-NEXT:	jr	ra

  store volatile i8* blockaddress(@test_blockaddress, %block), i8** @addr
  %val = load volatile i8*, i8** @addr
  indirectbr i8* %val, [label %block]

block:
  ret void
}
