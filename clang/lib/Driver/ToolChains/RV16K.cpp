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

Tool *RV16KToolChain::buildLinker() const {
  return new tools::RV16K::Linker(*this);
}

void RV16K::Linker::ConstructJob(Compilation &C, const JobAction &JA,
                                 const InputInfo &Output,
                                 const InputInfoList &Inputs,
                                 const ArgList &Args,
                                 const char *LinkingOutput) const {
  const ToolChain &ToolChain = getToolChain();
  ArgStringList CmdArgs;

  std::string Linker = getToolChain().GetProgramPath(getShortName());

  AddLinkerInputs(ToolChain, Inputs, Args, CmdArgs, JA);

  // Place .text section to address 0.
  CmdArgs.push_back("-Ttext=0");
  // Place .data section to address 0x10000.
  CmdArgs.push_back("-Tdata=0x10000");

  // TODO: The latest lld has --nmagic option, which is more suitable here?
  CmdArgs.push_back("--omagic");

  CmdArgs.push_back("-o");
  CmdArgs.push_back(Output.getFilename());
  C.addCommand(llvm::make_unique<Command>(JA, *this, Args.MakeArgString(Linker),
                                          CmdArgs, Inputs));
}
