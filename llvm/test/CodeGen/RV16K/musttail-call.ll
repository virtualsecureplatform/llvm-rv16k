; Check that we error out if tail is not possible but call is marked as mustail.

; RUN: not llc -mtriple rv16k -o - %s \
; RUN: 2>&1 | FileCheck %s

%struct.A = type { i32 }

declare void @callee_musttail(%struct.A* sret %a)
define void @caller_musttail(%struct.A* sret %a) {
; CHECK: LLVM ERROR: failed to perform tail call elimination on a call site marked musttail
entry:
  musttail call void @callee_musttail(%struct.A* sret %a)
  ret void
}
