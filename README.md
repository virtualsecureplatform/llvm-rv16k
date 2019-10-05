# A LLVM backend for RV16K

RV16K is our original architecture for VSP.

## How to Build

```
$ cd /path/to/llvm-rv16k
$ mkdir build
$ cd build
$ cmake -G Ninja \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_USE_LINKER=lld \
    -DLLVM_TARGETS_TO_BUILD="" \
    -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RV16K" \
    ../llvm
$ cmake --build .
```

All executables we need will be placed in `/path/to/llvm-rv16k/build/bin`.

## How to assemble RV16K script

```
$ /path/to/llvm-rv16k/build/bin/clang -target rv16k -c foo.s -o foo.o
```
