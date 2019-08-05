# RUN: llvm-mc %s -triple=rv16k -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK,CHECK-INST %s

# CHECK-INST: mov t1, a0
# CHECK: encoding: [0x8f,0xc0]
mov t1, a0
# CHECK-INST: add t1, a0
# CHECK: encoding: [0x8f,0xe2]
add t1, a0
# CHECK-INST: sub t1, a0
# CHECK: encoding: [0x8f,0xe3]
sub t1, a0
# CHECK-INST: and t1, a0
# CHECK: encoding: [0x8f,0xe4]
and t1, a0
# CHECK-INST: or t1, a0
# CHECK: encoding: [0x8f,0xe5]
or  t1, a0
# CHECK-INST: xor t1, a0
# CHECK: encoding: [0x8f,0xe6]
xor t1, a0
# CHECK-INST: lsl t1, a0
# CHECK: encoding: [0x8f,0xe9]
lsl t1, a0
# CHECK-INST: lsr t1, a0
# CHECK: encoding: [0x8f,0xea]
lsr t1, a0
# CHECK-INST: asr t1, a0
# CHECK: encoding: [0x8f,0xed]
asr t1, a0
# CHECK-INST: cmp t1, a0
# CHECK: encoding: [0x8f,0xc3]
cmp t1, a0
# CHECK-INST: li a0, 32767
# CHECK: encoding: [0x08,0x78,0xff,0x7f]
li a0, 0x7fff
# CHECK-INST: li a0, -32768
# CHECK: encoding: [0x08,0x78,0x00,0x80]
li a0, -0x8000
# CHECK-INST: addi a0, 7
# CHECK: encoding: [0x78,0xf2]
addi a0, 7
# CHECK-INST: addi a0, -8
# CHECK: encoding: [0x88,0xf2]
addi a0, -8
# CHECK-INST: cmpi a0, 7
# CHECK: encoding: [0x78,0xd3]
cmpi a0, 7
# CHECK-INST: cmpi a0, -8
# CHECK: encoding: [0x88,0xd3]
cmpi a0, -8
# CHECK-INST: nop
# CHECK: encoding: [0x00,0x00]
nop
# CHECK-INST: lw t0, 32766(a3)
# CHECK: encoding: [0xbe,0xb2,0xfe,0x7f]
lw t0, 32766(a3)
# CHECK-INST: lw t0, -32768(a3)
# CHECK: encoding: [0xbe,0xb2,0x00,0x80]
lw t0, -32768(a3)
# CHECK-INST: lbu t0, 32767(a3)
# CHECK: encoding: [0xbe,0xba,0xff,0x7f]
lbu t0, 32767(a3)
# CHECK-INST: lbu t0, -32768(a3)
# CHECK: encoding: [0xbe,0xba,0x00,0x80]
lbu t0, -32768(a3)
# CHECK-INST: lb t0, 32767(a3)
# CHECK: encoding: [0xbe,0xbe,0xff,0x7f]
lb t0, 32767(a3)
# CHECK-INST: lb t0, -32768(a3)
# CHECK: encoding: [0xbe,0xbe,0x00,0x80]
lb t0, -32768(a3)
# CHECK-INST: sw t0, 32766(a3)
# CHECK: encoding: [0xeb,0x92,0xfe,0x7f]
sw t0, 32766(a3)
# CHECK-INST: sw t0, -32768(a3)
# CHECK: encoding: [0xeb,0x92,0x00,0x80]
sw t0, -32768(a3)
# CHECK-INST: sb t0, 32767(a3)
# CHECK: encoding: [0xeb,0x9a,0xff,0x7f]
sb t0, 32767(a3)
# CHECK-INST: sb t0, -32768(a3)
# CHECK: encoding: [0xeb,0x9a,0x00,0x80]
sb t0, -32768(a3)
# CHECK-INST: lwsp t0, 510(sp)
# CHECK: encoding: [0xfe,0xaf]
lwsp t0, 510(sp)
# CHECK-INST: swsp t0, 510(sp)
# CHECK: encoding: [0xef,0x8f]
swsp t0, 510(sp)
# CHECK-INST: j 32766
# CHECK: encoding: [0x00,0x52,0xfe,0x7f]
j 32766
# CHECK-INST: j -32768
# CHECK: encoding: [0x00,0x52,0x00,0x80]
j -32768
# CHECK-INST: jal 32766
# CHECK: encoding: [0x00,0x73,0xfe,0x7f]
jal 32766
# CHECK-INST: jal -32768
# CHECK: encoding: [0x00,0x73,0x00,0x80]
jal -32768
# CHECK-INST: jalr t0
# CHECK: encoding: [0xe0,0x61]
jalr t0
# CHECK-INST: jr ra
# CHECK: encoding: [0x00,0x40]
jr ra
# CHECK-INST: jl 126
# CHECK: encoding: [0x3f,0x44]
jl 126
# CHECK-INST: jl -128
# CHECK: encoding: [0x40,0x44]
jl -128
# CHECK-INST: jle 126
# CHECK: encoding: [0xbf,0x44]
jle 126
# CHECK-INST: jle -128
# CHECK: encoding: [0xc0,0x44]
jle -128
# CHECK-INST: je 126
# CHECK: encoding: [0x3f,0x45]
je 126
# CHECK-INST: je -128
# CHECK: encoding: [0x40,0x45]
je -128
# CHECK-INST: jne 126
# CHECK: encoding: [0xbf,0x45]
jne 126
# CHECK-INST: jne -128
# CHECK: encoding: [0xc0,0x45]
jne -128
# CHECK-INST: jb 126
# CHECK: encoding: [0x3f,0x46]
jb 126
# CHECK-INST: jb -128
# CHECK: encoding: [0x40,0x46]
jb -128
# CHECK-INST: jbe 126
# CHECK: encoding: [0xbf,0x46]
jbe 126
# CHECK-INST: jbe -128
# CHECK: encoding: [0xc0,0x46]
jbe -128
