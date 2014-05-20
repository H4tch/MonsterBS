#!/bin/sh

# TODO
# Allow script to run from anwhere? You would have to mess around with $0 arg.
# Look for ICON and SOURCES within the directory running the script.
# Fix LaunchOnWindows.bat and LaunchOnLinux.sh to point to correct lib dir.
# Copy over Scripts.
# Setup Makefile with correct values.
# Setup Doxygen with corrent values.
# Generate NSIS file.


if [ $# -lt 1 ]; then
	echo "USAGE: $0 <YourProject.sh>"
	exit 1
fi


# Run the Project script to initialize variables.
. ./$1



FILES=`find scripts/ -maxdepth 1 -type f -printf '%f '`

echo "--> Creating Project" $NAME

NEW_PROJECT=0

if [ ! -d "$NAME" ]; then
	NEW_PROJECT=1
	mkdir -p $NAME
fi

cd $NAME
mkdir -p $SRCDIR
mkdir -p $LIBDIR
mkdir -p $SCRIPTDIR

echo "--> Copying scripts to" $NAME/$SCRIPTDIR

for FILE in $FILES; do
	cp -a ../scripts/$FILE $SCRIPTDIR/
done


if [ $NEW_PROJECT -eq 1 ]; then
	if [ -d "../$SRCDIR/" ]; then
		echo "Copying over SRC files to new project."
		cp -a "../$SRCDIR/" .
	fi
fi


RemoveFile()
{
	if [ $# -lt 1 ]; then
		exit 1
	fi
	rm $SCRIPTDIR/$1
	FILES=`echo $FILES | sed -e s/$1//g`
}



BUILD_FOR_UNIX=0
BUILD_FOR_LINUX=0
BUILD_FOR_MAC=0
BUILD_FOR_WINDOWS=0
BUILD_FOR_ANDROID=0


if [ $BUILD_FOR_LINUX_32 -eq 1 ]; then
	BUILD_FOR_UNIX=1
	BUILD_FOR_LINUX=1
	mkdir -p $LIBDIR/Linux_x86/
fi
if [ $BUILD_FOR_LINUX_64 -eq 1 ]; then
	BUILD_FOR_UNIX=1
	BUILD_FOR_LINUX=1
	mkdir -p $LIBDIR/Linux_x86_64/
fi

if [ $BUILD_FOR_MAC_32 -eq 1 ]; then
	BUILD_FOR_UNIX=1
	BUILD_FOR_MAC=1
	mkdir -p $LIBDIR/Mac_x86/
fi
if [ $BUILD_FOR_MAC_64 -eq 1 ]; then
	BUILD_FOR_UNIX=1
	BUILD_FOR_MAC=1
	mkdir -p $LIBDIR/Mac_x86_64/
fi


if [ $BUILD_FOR_WINDOWS_32 -eq 1 ]; then
	BUILD_FOR_WINDOWS=1
	mkdir -p $LIBDIR/Windows_x86/
fi
if [ $BUILD_FOR_WINDOWS_64 -eq 1 ]; then
	BUILD_FOR_WINDOWS=1
	mkdir -p $LIBDIR/Windows_x86_64/
fi


if [ $BUILD_FOR_ANDROID_ARM -eq 1 ]; then
	BUILD_FOR_ANDROID=1
fi
if [ $BUILD_FOR_ANDROID_X86 -eq 1 ]; then
	BUILD_FOR_ANDROID=1
fi



echo "--> Removing Unneeded Files."

# Should I copy what I need, or copy and remove what I don't

if [ $BUILD_FOR_UNIX -eq 0 ]; then
	RemoveFile LaunchOnLinux.sh
	RemoveFile Get_SDL2_LinuxLibs.sh
	RemoveFile GenerateLinuxLauncher.sh
fi

if [ $BUILD_FOR_LINUX -eq 0 ]; then
	RemoveFile Fix_Ubuntu_SDL2_32-bit_Libs.sh
fi

if [ $BUILD_FOR_MAC -eq 0 ]; then
	true
fi

if [ $BUILD_FOR_WINDOWS -eq 0 ]; then
	RemoveFile LaunchOnWindows.bat
	RemoveFile Installer.nsh
	RemoveFile Get_SDL2_WinLibs.sh
fi

if [ $BUILD_FOR_ANDROID -eq 0 ]; then
	RemoveFile Android.mk
	RemoveFile Application.mk
	RemoveFile Makefile.Android
	RemoveFile SetupAndroidProject.sh
fi




Replace()
{
	if [ $# -lt 1 ]; then exit 1; fi
	if [ $# -lt 2 ];
		then REPLACEWITH=""
	fi
	
	SEARCHFOR="\$\$$1"
	#SEARCHFOR=`echo $1 | sed -e 's/\\$/\\\\$/g'`
	REPLACEWITH=`echo $2 | sed -e 's/\\\/\\\\\\\\\\\\/g' -e 's/&/\\\&/g' \
								-e 's/\\//\\\\\//g'`
	#echo $SEARCHFOR \""$REPLACEWITH"\"
	
	for FILE in $FILES; do
		cat $SCRIPTDIR/$FILE  | sed s/$SEARCHFOR/"$REPLACEWITH"/g > \
			$SCRIPTDIR/$FILE".new"
		mv $SCRIPTDIR/$FILE".new" $SCRIPTDIR/$FILE
	done
}



echo "--> Inserting Project variables into initial files."

# Note, the order for some of these matter. For example, if $$NAME goes before
# $$NAMESPACE, then it will mess $$NAMESPACE up.

Replace "NAMESPACE" "$NAMESPACE"
Replace "NAME" "$NAME"
Replace "FILENAME" "$FILENAME"
Replace "VERSION" "$VERSION"
Replace "ICON" "$ICON"
Replace "DESCRIPTION" "$DESCRIPTION"
Replace "CATEGORIES" "$CATEGORIES"
Replace "RUN_IN_TERMINAL" "$RUN_IN_TERMINAL"

Replace "SRCDIR" "$SRCDIR"
Replace "LIBDIR" "$LIBDIR"
#Replace "PLATFORM_LIBDIR" "$PLATFORM_LIBDIR"
#Replace "PROJ_INCLUDEDIR" "$PROJ_INCLUDEDIR"
Replace "INCLUDEDIR" "$INCLUDEDIR"
Replace "BUILDDIR" "$BUILDDIR"
Replace "DOCDIR" "$DOCDIR"
Replace "DATADIR" "$DATADIR"
Replace "SCRIPTDIR" "$SCRIPTDIR"

Replace "SOURCES" "$SOURCES"

Replace "INCLUDES" "$INCLUDES"
Replace "LIBS" "$LIBS"
Replace "STATICLIBS" "$STATICLIBS"
Replace "WINLIBS" "$WINLIBS"
Replace "STATICWINLIBS" "$STATICWINLIBS"

Replace "DEFINES_DEBUG" "$DEFINES_DEBUG"
Replace "DEFINES_RELEASE" "$DEFINES_RELEASE"
Replace "DEFINES_32" "$DEFINES_32"
Replace "DEFINES_64" "$DEFINES_64"
Replace "DEFINES_ARM" "$DEFINES_ARM"
Replace "DEFINES" "$DEFINES"
Replace "LINUXDEFINES" "$LINUXDEFINES"
Replace "MACDEFINES" "$MACDEFINES"
Replace "WINDEFINES" "$WINDEFINES"

Replace "CCFLAGS" "$CCFLAGS"
Replace "LDFLAGS" "$LDFLAGS"
Replace "FLAGS_DEBUG" "$FLAGS_DEBUG"
Replace "FLAGS_RELEASE" "$FLAGS_RELEASE"


Replace "BUILD_FOR_LINUX_32" "$BUILD_FOR_LINUX_32"
Replace "BUILD_FOR_LINUX_64" "$BUILD_FOR_LINUX_64"
Replace "BUILD_FOR_WINDOWS_32" "$BUILD_FOR_WINDOWS_32"
Replace "BUILD_FOR_WINDOWS_64" "$BUILD_FOR_WINDOWS_64"
Replace "BUILD_FOR_ANDROID_ARM" "$BUILD_FOR_ANDROID_ARM"
Replace "BUILD_FOR_ANDROID_X86" "$BUILD_FOR_ANDROID_X86"


Replace "LINUX_CC_32" "$LINUX_CC_32"
Replace "LINUX_CC_64" "$LINUX_CC_64"
Replace "MAC_CC_32" "$MAC_CC_32"
Replace "MAC_CC_64" "$MAC_CC_64"
Replace "WINDOWS_CC_32" "$WINDOWS_CC_32"
Replace "WINDOWS_CC_64" "$WINDOWS_CC_64"


#Replace "PACKAGE_ALL_IN_ONE" $PACKAGE_ALL_IN_ONE"
Replace "PACKAGE_ARCHIVE_TYPE_LINUX" "$PACKAGE_ARCHIVE_TYPE_LINUX"
Replace "PACKAGE_ARCHIVE_TYPE_WINDOWS" "$PACKAGE_ARCHIVE_TYPE_WINDOWS"


Replace "DOCSET_NAME" "$DOCSET_NAME"
Replace "PUBLISHERNAME" "$PUBLISHERNAME"
Replace "PUBLISHER_NAMESPACE" "$PUBLISHER_NAMESPACE"
Replace "HIDE_DOC_WITHIN_PATHS" "$HIDE_DOC_WITHIN_PATHS"
Replace "HIDE_DOC_WITH_PATTERNS" "$HIDE_DOC_WITH_PATTERNS"
Replace "HIDE_INC_PATH_PREFIX" "$HIDE_INC_PATH_PREFIX"
Replace "HIDE_DOC_WITH_SYMBOLS" "$HIDE_DOC_WITH_SYMBOLS"
Replace "DOC_IMAGE_DIR" "$DOC_IMAGE_DIR"



cd ../


echo "--> Installing libraries."


# TODO
# check for local libs...
# 	Download, compile, install libs. Auto detect SDL. 
# 
#

OS=`uname -s`
ARCH=`uname -m`


InstallSDLPackages()
{
INSTALL_PACKAGE="n"
if [ "$OS" = "Linux" ]; then
	cat "/etc/lsb-release" | grep "Debian" > /dev/null
	if [ $? -eq 0 ]; then DEBIAN=1; fi
	cat "/etc/lsb-release" | grep "Ubuntu" > /dev/null
	if [ $? -eq 0 ]; then DEBIAN=1; fi
	if [ $DEBIAN -eq 1 ]; then
		echo "Would you like to install using the package manager? y/n "
		read INSTALL_PACKAGE
		if [ "$INSTALL_PACKAGE" = "y" ]; then
			for LIB in $LIBS; do
				echo $LIB | grep "\-L" > /dev/null
				if [ $? -eq 0 ]; then continue; fi
				LIB=`echo $LIB | sed -e 's/-l/lib/g' -e 's/_/\-/g'`
				sudo apt-get install $LIB-*
				if [ $ARCH = "x86_64" ]; then
					if [ $BUILD_FOR_LINUX_32 ]; then
						# Need better regex matching here...
						sudo apt-get install $LIB-*:i386
					fi
				fi
			done
		else return 1; fi
	fi
fi
return 0
}


CORES=`grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu`

## Detect SDL2 Libraries.
echo $LIBS | grep "\-lSDL2 " > /dev/null
if [ $? -eq 0 ]; then
	echo "Your project is using SDL2 libs."
	InstallSDLPackages
	if [ $? -ne 0 ]; then
		echo "Failed to install SDL libs through package manager."
		echo "Would you like to download and compile the SDL libs? y/n"
		read COMPILE_LIBS
	fi


	if [ "$COMPILE_LIBS" = "y" ]; then
		#if [ $BUILD_FOR_LINUX_32 -eq 1 ]; then make -j$CORES -f scripts/SDL2Libs.mk Linux32; fi
		if [ $BUILD_FOR_LINUX_64 -eq 1 ]; then make -j$CORES -f scripts/SDL2Libs.mk Linux64; fi
		#if [ $BUILD_FOR_MAC_32 -eq 1 ]; then make -j$CORES -f scripts/SDL2Libs.mk Mac32; fi
		#if [ $BUILD_FOR_MAC_64 -eq 1 ]; then make -j$CORES -f scripts/SDL2Libs.mk Mac64; fi
		if [ $BUILD_FOR_WINDOWS_32 -eq 1 ]; then make -j$CORES -f scripts/SDL2Libs.mk Windows32; fi
		if [ $BUILD_FOR_WINDOWS_64 -eq 1 ]; then make -j$CORES -f scripts/SDL2Libs.mk Windows64; fi
	fi
fi


if [ -d "../$LIBDIR/" ]; then
	echo "Copying LIB files to project."
	cp -a "../$LIBDIR/" .
fi




