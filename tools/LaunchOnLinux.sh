#!/bin/sh

if [ "$OS" = "" ]; then OS=`uname -s`; fi
if [ "$ARCH" = "" ]; then ARCH=`uname -m`; fi
if [ "$OS" = "Darwin" ]; then OS="Mac"; fi

case $ARCH in
x86_64)
	ARCH=x86_64
	;;
i386|i486|i586|i686|ia32|x86)
	ARCH=x86
	;;
arm*|*arm|*arm*)
	echo "The ARM platform is not currently supported."
	exit 1
	;;
*)
	echo "Unknown Platform: " $ARCH
	exit 1
	;;
esac


export LD_LIBRARY_PATH="$PWD/$$LIBDIR/$OS"_"$ARCH/":$LD_LIBRARY_PATH && \
	./$$FILENAME"_"$OS"_"$ARCH

# Switch to a Bin directory for each Platform?
#export LD_LIBRARY_PATH="$PWD/$$BINDIR/$OS"_"$ARCH/":$LD_LIBRARY_PATH && \
#	./$$BINDIR/$OS"_"$ARCH/$$FILENAME

