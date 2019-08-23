# REQUIRES: rv16k
# RUN: llvm-mc -filetype=obj -triple=rv16k-- %s -o %t
# RUN: ld.lld %t -o %t2
# RUN: llvm-readobj -file-headers -sections -program-headers -symbols %t2 \
# RUN:   | FileCheck %s

# exits with return code 42
.global _start
_start:
  li a0, 42
  hlt

# CHECK: Format: ELF32-rv16k
# CHECK-INST: Arch: rv16k
# CHECK-INST: AddressSize: 32bit
# CHECK-INST: LoadName:
# CHECK-INST: ElfHeader {
# CHECK-INST:   Ident {
# CHECK-INST:     Magic: (7F 45 4C 46)
# CHECK-INST:     Class: 32-bit (0x1)
# CHECK-INST:     DataEncoding: LittleEndian (0x1)
# CHECK-INST:     FileVersion: 1
# CHECK-INST:     OS/ABI: SystemV (0x0)
# CHECK-INST:     ABIVersion: 0
# CHECK-INST:     Unused: (00 00 00 00 00 00 00)
# CHECK-INST:   }
# CHECK-INST:   Type: Executable (0x2)
# CHECK-INST:   Machine: EM_RV16K (0xF6)
# CHECK-INST:   Version: 1
# CHECK-INST:   Entry: 0x11000
# CHECK-INST:   ProgramHeaderOffset: 0x34
# CHECK-INST:   SectionHeaderOffset: 0x205C
# CHECK-INST:   Flags [ (0x0)
# CHECK-INST:   ]
# CHECK-INST:   HeaderSize: 52
# CHECK-INST:   ProgramHeaderEntrySize: 32
# CHECK-INST:   ProgramHeaderCount: 4
# CHECK-INST:   SectionHeaderEntrySize: 40
# CHECK-INST:   SectionHeaderCount: 6
# CHECK-INST:   StringTableSectionIndex: 4
# CHECK-INST: }
# CHECK-INST: Sections [
# CHECK-INST:   Section {
# CHECK-INST:     Index: 0
# CHECK-INST:     Name:  (0)
# CHECK-INST:     Type: SHT_NULL (0x0)
# CHECK-INST:     Flags [ (0x0)
# CHECK-INST:     ]
# CHECK-INST:     Address: 0x0
# CHECK-INST:     Offset: 0x0
# CHECK-INST:     Size: 0
# CHECK-INST:     Link: 0
# CHECK-INST:     Info: 0
# CHECK-INST:     AddressAlignment: 0
# CHECK-INST:     EntrySize: 0
# CHECK-INST:   }
# CHECK-INST:   Section {
# CHECK-INST:     Index: 1
# CHECK-INST:     Name: .text (1)
# CHECK-INST:     Type: SHT_PROGBITS (0x1)
# CHECK-INST:     Flags [ (0x6)
# CHECK-INST:       SHF_ALLOC (0x2)
# CHECK-INST:       SHF_EXECINSTR (0x4)
# CHECK-INST:     ]
# CHECK-INST:     Address: 0x11000
# CHECK-INST:     Offset: 0x1000
# CHECK-INST:     Size: 8
# CHECK-INST:     Link: 0
# CHECK-INST:     Info: 0
# CHECK-INST:     AddressAlignment: 4
# CHECK-INST:     EntrySize: 0
# CHECK-INST:   }
# CHECK-INST:   Section {
# CHECK-INST:     Index: 2
# CHECK-INST:     Name: .comment (7)
# CHECK-INST:     Type: SHT_PROGBITS (0x1)
# CHECK-INST:     Flags [ (0x30)
# CHECK-INST:       SHF_MERGE (0x10)
# CHECK-INST:       SHF_STRINGS (0x20)
# CHECK-INST:     ]
# CHECK-INST:     Address: 0x0
# CHECK-INST:     Offset: 0x2000
# CHECK-INST:     Size: 8
# CHECK-INST:     Link: 0
# CHECK-INST:     Info: 0
# CHECK-INST:     AddressAlignment: 1
# CHECK-INST:     EntrySize: 1
# CHECK-INST:   }
# CHECK-INST:   Section {
# CHECK-INST:     Index: 3
# CHECK-INST:     Name: .symtab (16)
# CHECK-INST:     Type: SHT_SYMTAB (0x2)
# CHECK-INST:     Flags [ (0x0)
# CHECK-INST:     ]
# CHECK-INST:     Address: 0x0
# CHECK-INST:     Offset: 0x2008
# CHECK-INST:     Size: 32
# CHECK-INST:     Link: 5
# CHECK-INST:     Info: 1
# CHECK-INST:     AddressAlignment: 4
# CHECK-INST:     EntrySize: 16
# CHECK-INST:   }
# CHECK-INST:   Section {
# CHECK-INST:     Index: 4
# CHECK-INST:     Name: .shstrtab (24)
# CHECK-INST:     Type: SHT_STRTAB (0x3)
# CHECK-INST:     Flags [ (0x0)
# CHECK-INST:     ]
# CHECK-INST:     Address: 0x0
# CHECK-INST:     Offset: 0x2028
# CHECK-INST:     Size: 42
# CHECK-INST:     Link: 0
# CHECK-INST:     Info: 0
# CHECK-INST:     AddressAlignment: 1
# CHECK-INST:     EntrySize: 0
# CHECK-INST:   }
# CHECK-INST:   Section {
# CHECK-INST:     Index: 5
# CHECK-INST:     Name: .strtab (34)
# CHECK-INST:     Type: SHT_STRTAB (0x3)
# CHECK-INST:     Flags [ (0x0)
# CHECK-INST:     ]
# CHECK-INST:     Address: 0x0
# CHECK-INST:     Offset: 0x2052
# CHECK-INST:     Size: 8
# CHECK-INST:     Link: 0
# CHECK-INST:     Info: 0
# CHECK-INST:     AddressAlignment: 1
# CHECK-INST:     EntrySize: 0
# CHECK-INST:   }
# CHECK-INST: ]
# CHECK-INST: Symbols [
# CHECK-INST:   Symbol {
# CHECK-INST:     Name:  (0)
# CHECK-INST:     Value: 0x0
# CHECK-INST:     Size: 0
# CHECK-INST:     Binding: Local (0x0)
# CHECK-INST:     Type: None (0x0)
# CHECK-INST:     Other: 0
# CHECK-INST:     Section: Undefined (0x0)
# CHECK-INST:   }
# CHECK-INST:   Symbol {
# CHECK-INST:     Name: _start (1)
# CHECK-INST:     Value: 0x11000
# CHECK-INST:     Size: 0
# CHECK-INST:     Binding: Global (0x1)
# CHECK-INST:     Type: None (0x0)
# CHECK-INST:     Other: 0
# CHECK-INST:     Section: .text (0x1)
# CHECK-INST:   }
# CHECK-INST: ]
# CHECK-INST: ProgramHeaders [
# CHECK-INST:   ProgramHeader {
# CHECK-INST:     Type: PT_PHDR (0x6)
# CHECK-INST:     Offset: 0x34
# CHECK-INST:     VirtualAddress: 0x10034
# CHECK-INST:     PhysicalAddress: 0x10034
# CHECK-INST:     FileSize: 128
# CHECK-INST:     MemSize: 128
# CHECK-INST:     Flags [ (0x4)
# CHECK-INST:       PF_R (0x4)
# CHECK-INST:     ]
# CHECK-INST:     Alignment: 4
# CHECK-INST:   }
# CHECK-INST:   ProgramHeader {
# CHECK-INST:     Type: PT_LOAD (0x1)
# CHECK-INST:     Offset: 0x0
# CHECK-INST:     VirtualAddress: 0x10000
# CHECK-INST:     PhysicalAddress: 0x10000
# CHECK-INST:     FileSize: 180
# CHECK-INST:     MemSize: 180
# CHECK-INST:     Flags [ (0x4)
# CHECK-INST:       PF_R (0x4)
# CHECK-INST:     ]
# CHECK-INST:     Alignment: 4096
# CHECK-INST:   }
# CHECK-INST:   ProgramHeader {
# CHECK-INST:     Type: PT_LOAD (0x1)
# CHECK-INST:     Offset: 0x1000
# CHECK-INST:     VirtualAddress: 0x11000
# CHECK-INST:     PhysicalAddress: 0x11000
# CHECK-INST:     FileSize: 4096
# CHECK-INST:     MemSize: 4096
# CHECK-INST:     Flags [ (0x5)
# CHECK-INST:       PF_R (0x4)
# CHECK-INST:       PF_X (0x1)
# CHECK-INST:     ]
# CHECK-INST:     Alignment: 4096
# CHECK-INST:   }
# CHECK-INST:   ProgramHeader {
# CHECK-INST:     Type: PT_GNU_STACK (0x6474E551)
# CHECK-INST:     Offset: 0x0
# CHECK-INST:     VirtualAddress: 0x0
# CHECK-INST:     PhysicalAddress: 0x0
# CHECK-INST:     FileSize: 0
# CHECK-INST:     MemSize: 0
# CHECK-INST:     Flags [ (0x6)
# CHECK-INST:       PF_R (0x4)
# CHECK-INST:       PF_W (0x2)
# CHECK-INST:     ]
# CHECK-INST:     Alignment: 0
# CHECK-INST:   }
# CHECK-INST: ]
