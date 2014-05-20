
OS="Windows"
SDLLIBS="SDL2 SDL2_image SDL2_ttf SDL2_mixer"
if [ "$LIBDIR" = "" ]; then
	FULLLIBDIR=$PWD/lib;
else FULLLIBDIR=$PWD/$LIBDIR;
fi

DIR=third_party
SDLVERSION=2.0
ARCHIVE=tar.gz


mkdir -p $DIR
cd $DIR

wget -c http://www.libsdl.org/release/SDL2-devel-2.0.3-mingw.tar.gz -O SDL2-$SDLVERSION.$ARCHIVE
wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.0-mingw.tar.gz -O SDL2_image-$SDLVERSION.$ARCHIVE
wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.12-mingw.tar.gz -O SDL2_ttf-$SDLVERSION.$ARCHIVE
wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.0-mingw.tar.gz -O SDL2_mixer-$SDLVERSION.$ARCHIVE


echo "Installing SDL2 Libs to the system."

for LIB in $SDLLIBS; do
	ls /usr/i686-w64-mingw32/lib/lib$LIB.a > /dev/null 1&>2
	if [ $? -eq 0 ]; then
		echo "$LIB is already installed. Reinstall? y/n"
		read REINSTALL
		if [ "$REINSTALL" -ne "y" ]; then
			continue;
		fi
	fi
	#ls /usr/x86_64-w64-mingw32/lib/lib$LIB.a > /dev/null 1&>2
	#if [ $? -eq 0 ]; then continue; fi
	tar -xzf $LIB-$SDLVERSION.$ARCHIVE
	mv $LIB-$SDLVERSION.* $LIB-$SDLVERSION
	cp $LIB-$SDLVERSION/Makefile $LIB-$SDLVERSION/Makefile.bak
	cat $LIB-$SDLVERSION/Makefile.bak | sed s/"\$(CROSS_PATH)"/"\/"usr/g > $LIB-$SDLVERSION/Makefile
done


ARCHS=""
if [ $BUILD_FOR_WINDOWS_32 -eq 1 ]; then
	ARCHS=$ARCHS" x86"
	cp /usr/i686-w64-mingw32/lib/libwinpthread-1.dll $FULLLIBDIR/$OS"_x86/"
fi
if [ $BUILD_FOR_WINDOWS_64 -eq 1 ]; then
	ARCHS=$ARCHS" x86_64"
	cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $FULLLIBDIR/$OS"_x86_64/"
fi

for ARCH in $ARCHS; do
	mkdir -p $FULLLIBDIR/$OS"_"$ARCH/
	for LIB in $SDLLIBS; do
		cd $LIB-$SDLVERSION && sudo make cross && cd ../
		if [ $ARCH = "x86" ]; then
			cp $LIB-$SDLVERSION/i686-w64-mingw32/bin/* $FULLLIBDIR/$OS"_"$ARCH/
		else if [ $ARCH = "x86_64" ]; then
			cp $LIB-$SDLVERSION/x86_64-w64-mingw32/bin/* $FULLLIBDIR/$OS"_"$ARCH/
		fi
	done
done



