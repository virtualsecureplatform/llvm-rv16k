// Copyright 2019 Ryotaro Banno, Kotaro Matsuoka, Naoki Matsumoto
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "RV16K.h"
#include "clang/Basic/MacroBuilder.h"
#include "llvm/ADT/StringSwitch.h"

using namespace clang;
using namespace clang::targets;

ArrayRef<const char *> RV16KTargetInfo::getGCCRegNames() const {
  static const char *const GCCRegNames[] = {
      "x0", "x1", "x2",  "x3",  "x4",  "x5",  "x6",  "x7",
      "x8", "x9", "x10", "x11", "x12", "x13", "x14", "x15"};
  return llvm::makeArrayRef(GCCRegNames);
}

ArrayRef<TargetInfo::GCCRegAlias> RV16KTargetInfo::getGCCRegAliases() const {
  static const TargetInfo::GCCRegAlias GCCRegAliases[] = {
      {{"ra"}, "x0"},  {{"sp"}, "x1"},  {{"fp"}, "x2"},  {{"s0"}, "x3"},
      {{"s1"}, "x4"},  {{"s2"}, "x5"},  {{"s3"}, "x6"},  {{"s4"}, "x7"},
      {{"a0"}, "x8"},  {{"a1"}, "x9"},  {{"a2"}, "x10"}, {{"a3"}, "x11"},
      {{"a4"}, "x12"}, {{"a5"}, "x13"}, {{"t0"}, "x15"}, {{"t1"}, "x15"}};
  return llvm::makeArrayRef(GCCRegAliases);
}

void RV16KTargetInfo::getTargetDefines(const LangOptions &Opts,
                                       MacroBuilder &Builder) const {

  Builder.defineMacro("__rv16k__");
  Builder.defineMacro("__rv16kv2__");
}
