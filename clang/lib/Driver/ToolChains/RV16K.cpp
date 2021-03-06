// This file is copied and modified from The LLVM Compiler Infrastructure, which
// is distributed under the University of Illinois Open Source License (see
// LICENSE.TXT for details). This file is licensed under the same license.

#include "RV16K.h"
#include "CommonArgs.h"
#include "InputInfo.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Options.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"

using namespace clang::driver;
using namespace clang::driver::toolchains;
using namespace clang::driver::tools;
using namespace clang;
using namespace llvm::opt;

RV16KToolChain::RV16KToolChain(const Driver &D, const llvm::Triple &Triple,
                               const llvm::opt::ArgList &Args)
    : Generic_ELF(D, Triple, Args) {
  if (!D.SysRoot.empty())
    getFilePaths().push_back(D.SysRoot);
}

Tool *RV16KToolChain::buildLinker() const {
  return new tools::RV16K::Linker(*this);
}

void RV16K::Linker::ConstructJob(Compilation &C, const JobAction &JA,
                                 const InputInfo &Output,
                                 const InputInfoList &Inputs,
                                 const ArgList &Args,
                                 const char *LinkingOutput) const {
  const ToolChain &ToolChain = getToolChain();
  const Driver &D = ToolChain.getDriver();
  ArgStringList CmdArgs;

  if (!D.SysRoot.empty())
    CmdArgs.push_back(Args.MakeArgString("--sysroot=" + D.SysRoot));

  std::string Linker = getToolChain().GetProgramPath(getShortName());

  bool WantCRTs =
      !Args.hasArg(options::OPT_nostdlib, options::OPT_nostartfiles);

  if (WantCRTs) {
    // A runtime script to call function main and halt, something like this:
    //
    // .global _start
    // _start:
    // 	jal main
    // 	hlt
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("crt0.o")));
  }

  Args.AddAllArgs(CmdArgs, options::OPT_L);
  ToolChain.AddFilePathLibArgs(Args, CmdArgs);

  AddLinkerInputs(ToolChain, Inputs, Args, CmdArgs, JA);

  if (!Args.hasArg(options::OPT_nostdlib) &&
      !Args.hasArg(options::OPT_nodefaultlibs)) {
    CmdArgs.push_back("-lc");
  }

  // A linker script to get a correct ELF executable file for RAM and ROM,
  // something like this:
  //
  // SECTIONS
  // {
  //     . = 0x00000000;
  //     .text : { *(.text) }
  //     . = 0x00010000;
  //     .data : { *(.data) }
  //     .rodata : { *(.rodata) }
  //     .bss : { *(.bss) }
  // }
  CmdArgs.push_back(
      Args.MakeArgString("--script=" + ToolChain.GetFilePath("rv16k.lds")));

  // To make the output as small as possible.
  // TODO: The latest lld has --nmagic option, which is more suitable here?
  CmdArgs.push_back("--omagic");

  CmdArgs.push_back("-o");
  CmdArgs.push_back(Output.getFilename());
  C.addCommand(llvm::make_unique<Command>(JA, *this, Args.MakeArgString(Linker),
                                          CmdArgs, Inputs));
}
