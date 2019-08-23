# RUN: llvm-mc %s -triple=rv16k -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK,CHECK-INST %s
# RUN: llvm-mc -filetype=obj -triple=rv16k < %s \
# RUN:     | llvm-objdump -d - | FileCheck -check-prefix=CHECK-INSTDUMP %s

# CHECK-INST: hlt
# CHECK-INSTDUMP: j -2
# CHECK: encoding: [0x00,0x52,0xfe,0xff]
hlt
