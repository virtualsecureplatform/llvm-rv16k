; RUN: llc -mtriple rv16k -o - %s | FileCheck %s

; Perform tail call optimization for global address.
declare i16 @callee_tail(i16 %i)
define i16 @caller_tail(i16 %i) {
; CHECK-LABEL: caller_tail
; CHECK: j callee_tail
entry:
  %r = tail call i16 @callee_tail(i16 %i)
  ret i16 %r
}

; Perform tail call optimization for external symbol.
@dest = global [2 x i8] zeroinitializer
declare void @llvm.memcpy.p0i8.p0i8.i16(i8*, i8*, i16, i1)
define void @caller_extern(i8* %src) optsize {
entry:
; CHECK: caller_extern
; CHECK-NOT: jal memcpy
; CHECK: j memcpy
  tail call void @llvm.memcpy.p0i8.p0i8.i16(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @dest, i16 0, i16 0), i8* %src, i16 7, i1 false)
  ret void
}

; Perform indirect tail call optimization (for function pointer call).
declare void @callee_indirect1()
declare void @callee_indirect2()
define void @caller_indirect_tail(i16 %a) {
; CHECK-LABEL: caller_indirect_tail
; CHECK-NOT: call callee_indirect1
; CHECK-NOT: call callee_indirect2
; CHECK-NOT: j callee_indirect1
; CHECK-NOT: j callee_indirect2

; CHECK: li a0, callee_indirect2
; CHECK-NEXT: jr a0

; CHECK: li a0, callee_indirect1
; CHECK-NEXT: jr a0
entry:
  %tobool = icmp eq i16 %a, 0
  %callee = select i1 %tobool, void ()* @callee_indirect1, void ()* @callee_indirect2
  tail call void %callee()
  ret void
}

; Do not tail call optimize if stack is used to pass parameters.
declare i16 @callee_args(i16 %a, i16 %b, i16 %c, i16 %dd, i16 %e, i16 %ff, i16 %g)
define i16 @caller_args(i16 %a, i16 %b, i16 %c, i16 %dd, i16 %e, i16 %ff, i16 %g) {
; CHECK-LABEL: caller_args
; CHECK-NOT: j callee_args
; CHECK: jal callee_args
entry:
  %r = tail call i16 @callee_args(i16 %a, i16 %b, i16 %c, i16 %dd, i16 %e, i16 %ff, i16 %g)
  ret i16 %r
}

; Externally-defined functions with weak linkage should not be tail-called.
; The behaviour of branch instructions in this situation (as used for tail
; calls) is implementation-defined, so we cannot rely on the linker replacing
; the tail call with a return.
declare extern_weak void @callee_weak()
define void @caller_weak() {
; CHECK-LABEL: caller_weak
; CHECK-NOT: j callee_weak
; CHECK: jal callee_weak
entry:
  tail call void @callee_weak()
  ret void
}

; Byval parameters hand the function a pointer directly into the stack area
; we want to reuse during a tail call. Do not tail call optimize functions with
; byval parameters.
declare i16 @callee_byval(i16** byval %a)
define i16 @caller_byval() {
; CHECK-LABEL: caller_byval
; CHECK-NOT: j callee_byval
; CHECK: jal callee_byval
entry:
  %a = alloca i16*
  %r = tail call i16 @callee_byval(i16** byval %a)
  ret i16 %r
}

; Do not tail call optimize if callee uses structret semantics.
%struct.A = type { i32 }
@a = global %struct.A zeroinitializer

declare void @callee_struct(%struct.A* sret %a)
define void @caller_nostruct() {
; CHECK-LABEL: caller_nostruct
; CHECK-NOT: j callee_struct
; CHECK: jal callee_struct
entry:
  tail call void @callee_struct(%struct.A* sret @a)
  ret void
}

; Do not tail call optimize if caller uses structret semantics.
declare void @callee_nostruct()
define void @caller_struct(%struct.A* sret %a) {
; CHECK-LABEL: caller_struct
; CHECK-NOT: j callee_nostruct
; CHECK: jal callee_nostruct
entry:
  tail call void @callee_nostruct()
  ret void
}
