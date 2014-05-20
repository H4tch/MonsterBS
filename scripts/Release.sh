#!/bin/sh

export Cores=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
export OS=Linux
export ARCH=x86_64

make cleanAll

make -j$Cores release

export ARCH=x86
make -j$Cores release

export OS=Windows_NT
make -j$Cores release

export ARCH=x86_64
make -j$Cores release

make package

export OS=Linux

