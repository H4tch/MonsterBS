#!/bin/sh

## This file gets SDL2's source and compiles it. A few things need to be tweak
## for it to be cross-platform.

OS=`uname -s`
if [ "$OS" = "Darwin" ]; then
	OS="Mac";
else OS="Linux";
fi

if [ "$LIBDIR" = "" ]; then
	FULLLIBDIR=$PWD/lib;
else FULLLIBDIR=$PWD/$LIBDIR
fi

SDLLIBS="SDL2 SDL2_image SDL2_ttf SDL2_mixer"
VMAJOR=2
VMINOR=0
EXT=tar.gz
INSTALLDIR=$PWD/tools/third_party/SDL2/

mkdir -p tools/third_party/
cd tools/third_party/


# Download the source.
wget -c http://www.libsdl.org/release/SDL2-2.0.3.tar.gz -O SDL2-$VMAJOR.$VMINOR-src.$EXT
wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz -O SDL2_image-$VMAJOR.$VMINOR-src.$EXT
wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz -O SDL2_ttf-$VMAJOR.$VMINOR-src.$EXT
wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz -O SDL2_mixer-$VMAJOR.$VMINOR-src.$EXT



mkdir -p SDL2
export PATH=$INSTALLDIR/bin:$PATH
export PKG_CONFIG_PATH=$INSTALLDIR/pkgconfig
export LD_LIBRARY_PATH=$INSTALLDIR/lib

for LIB in $SDLLIBS; do
	ls /usr/lib/i386-linux-gnu/lib$LIB-$VMAJOR-$VMINOR* > /dev/null
	if [ $? -eq 0 ]; then
		echo "$LIB is already installed. Rebuild? y/n"
		read REINSTALL
		if [ "$REINSTALL" -ne "y" ]; then continue; fi
	fi
	echo $PWD
	tar -xzf $LIB-$VMAJOR.$VMINOR-src.$EXT
	mv $LIB-$VMAJOR.$VMINOR.[0-9]* $LIB-$VMAJOR.$VMINOR-src/
	cd $LIB-$VMAJOR.$VMINOR-src
	
	./autogen.sh
	./configure --prefix=$INSTALLDIR
	make -j2
	make install
	cd $INSTALLDIR/../
done


OS=`uname -s`
if [ "$OS" = "Darwin" ]; then
	OS="Mac"
fi

ARCH=`uname -m`
echo "Architecture: " $ARCH


cp $INSTALLDIR/lib/lib*so $FULLLIBDIR/$OS"_"$ARCH/
cp $INSTALLDIR/lib/lib*so* $FULLLIBDIR/$OS"_"$ARCH/


exit 0


echo "Getting installed system SDL2 libs and installing them locally in lib/"

if [ $BUILD_FOR_LINUX_32 -eq 1 ]; then
	for LIB in $SDLLIBS; do
		cp -a /usr/lib/i386-linux-gnu/lib$LIB-$VMAJOR.$VMINOR.so.$VMINOR \
			$FULLLIBDIR/$OS"_x86"/
	done
fi
if [ $BUILD_FOR_LINUX_64 -eq 1 ]; then
	for LIB in $SDLLIBS; do
		cp -a /usr/lib/x86_64-linux-gnu/lib$LIB-$VMAJOR.$VMINOR.so.$VMINOR \
			$FULLLIBDIR/$OS"_x86_64"/
	done
fi


# Experimental Mac support (shot in the dark)
if [ $BUILD_FOR_MAC_32 -eq 1 ]; then
	for LIB in $SDLLIBS; do
		cp -a /usr/lib/lib$LIB-$VMAJOR.$VMINOR.so.$VMINOR \
			$FULLLIBDIR/$OS"_x86"/
	done
fi
if [ $BUILD_FOR_MAC_64 -eq 1 ]; then
	for LIB in $SDLLIBS; do
		cp -a /usr/lib64/lib$LIB-$VMAJOR.$VMINOR.so.$VMINOR \
			$FULLLIBDIR/$OS"_x86_64"/
	done
fi





