// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16KMCAsmInfo.h"
#include "llvm/ADT/Triple.h"
using namespace llvm;

void RV16KMCAsmInfo::anchor() {}

RV16KMCAsmInfo::RV16KMCAsmInfo(const Triple &TT) {
  CodePointerSize = 2;
  CalleeSaveStackSlotSize = 2;
  CommentString = "#";
  SupportsDebugInformation = true;
}
