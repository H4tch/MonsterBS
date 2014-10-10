#!/bin/sh

PREFIX=$PWD
# Get path to where the script is.
CPPBUILDERPATH=$PWD/`find $0 -printf '%h\n'`
# Not sure what this does exactly.
CPPBUILDERPATH=`echo $CPPBUILDERPATH | sed -e s@\\\./@@g`

USAGE="USAGE: $0 [<target-directory>]"

INSTALLDIR=$NAME
if [ $# -ge 1 ]; then
	echo "Installing to" $1
	INSTALLDIR=$1
fi


# NOTE, this prevents you from embedding CppProjectBuilder into your project's
# root unless you specifically set the target-directory.
# If I'm running the script from the current directory, the project directory
# will be created. Otherwise, if the INSTALLDIR is not specified and the
# SRCDIR shared the same name as the Project's name, then the current
# directory will be treated as the project directory.
if [ $# -eq 0 ] && [ "$SRCDIR" = "$INSTALLDIR" ] &&
 [ -d $INSTALLDIR ] && [ "$CPPBUILDERPATH" != "$PWD/." ]; then
	echo "--> Treating current directory as the Project's root directory."
	INSTALLDIR="."
fi

SCRIPTS="$CPPBUILDERPATH/tools"
FILES=`find $SCRIPTS/ -maxdepth 1 -type f -printf '%f '`

NEW_PROJECT=0
if [ ! -d "$INSTALLDIR" ]; then
	echo "--> Creating New Project" "'$NAME'"
	NEW_PROJECT=1
	mkdir -p $INSTALLDIR
else
	echo "--> Creating Project" "'$NAME'"
fi

cd $INSTALLDIR
mkdir -p $SRCDIR
mkdir -p $LIBDIR
mkdir -p $SCRIPTDIR

if [ $INSTALL_CPPPROJECTBUILDER -eq 1 ]; then
	echo "--> Installing CppProjectBuilder to Project's Script directory."
	mkdir -p $SCRIPTDIR/CppProjectBuilder/tools
	cp -a $CPPBUILDERPATH/tools/* $SCRIPTDIR/CppProjectBuilder/tools/
	cp $CPPBUILDERPATH/Makefile $SCRIPTDIR/CppProjectBuilder/
	cp $CPPBUILDERPATH/Project.mk $SCRIPTDIR/CppProjectBuilder/
	cp $CPPBUILDERPATH/CppProjectBuilder.sh $SCRIPTDIR/CppProjectBuilder/
	cp $CPPBUILDERPATH/README.md $SCRIPTDIR/CppProjectBuilder/
	echo "installed.."
fi

if [ -f "$CPPBUILDERPATH/$ICON" ]; then
	echo "--> Copying Icon: '$ICON'."
	cp $CPPBUILDERPATH/$ICON .
fi

echo "--> Copying scripts to" $INSTALLDIR/$SCRIPTDIR

cp $PREFIX/$NAME.mk .

for FILE in $FILES; do
	cp -a $SCRIPTS/$FILE $SCRIPTDIR/
done


if [ $NEW_PROJECT -eq 1 ]; then
	# Initial Project Files.
	if [ -d "$PREFIX/Project/" ] && [ "Project" != "$NAME" ]; then
		echo "--> Copying Project files to new project."
		# TODO Why is this failing?!?! It works without the asterisk, but
		# doesn't copy the contents of the directory.
		cp -a "$PREFIX/Project/*" .
	fi
	if [ -d "$PREFIX/$SRCDIR/" ] && [ "$SRCDIR" != "$NAME" ] \
	&& [ "$SRCDIR" != "." ]; then
		echo "--> Copying SRC files to new project."
		cp -a "$PREFIX/$SRCDIR/" .
	fi
	if [ -d "$PREFIX/$DATADIR/" ] && [ "$DATADIR" != "$NAME" ] \
	&& [ "$DATADIR" != "." ]; then
		echo "--> Copying DATA files to new project."
		cp -a "$PREFIX/$DATADIR/" .
	fi
fi


RemoveFile()
{
	if [ $# -lt 1 ]; then exit 1; fi
	if [ "$KEEP_UNNEEDED_SCRIPTS" -eq 1 ]; then exit 0; fi
	rm $SCRIPTDIR/$1 > /dev/null 2>&1
	# TODO Match _$1_
	FILES=`echo $FILES | sed -e "s/$1/ /g"`
}


# . getBuildSettings.sh

BUILD_FOR_UNIX=0; BUILD_FOR_LINUX=0; BUILD_FOR_MAC=0;  BUILD_FOR_WINDOWS=0;  BUILD_FOR_ANDROID=0

if [ $BUILD_FOR_LINUX_32 -eq 1 ]; then
	BUILD_FOR_UNIX=1; BUILD_FOR_LINUX=1; mkdir -p $LIBDIR/Linux_x86/
fi
if [ $BUILD_FOR_LINUX_64 -eq 1 ]; then
	BUILD_FOR_UNIX=1; BUILD_FOR_LINUX=1; mkdir -p $LIBDIR/Linux_x86_64/
fi

if [ $BUILD_FOR_MAC_32 -eq 1 ]; then
	BUILD_FOR_UNIX=1; BUILD_FOR_MAC=1; mkdir -p $LIBDIR/Mac_x86/
fi
if [ $BUILD_FOR_MAC_64 -eq 1 ]; then
	BUILD_FOR_UNIX=1; BUILD_FOR_MAC=1; mkdir -p $LIBDIR/Mac_x86_64/
fi

if [ $BUILD_FOR_WINDOWS_32 -eq 1 ]; then
	BUILD_FOR_WINDOWS=1; mkdir -p $LIBDIR/Windows_x86/
fi
if [ $BUILD_FOR_WINDOWS_64 -eq 1 ]; then
	BUILD_FOR_WINDOWS=1; mkdir -p $LIBDIR/Windows_x86_64/
fi

if [ $BUILD_FOR_ANDROID_ARM -eq 1 ]; then BUILD_FOR_ANDROID=1; fi
if [ $BUILD_FOR_ANDROID_X86 -eq 1 ]; then BUILD_FOR_ANDROID=1; fi




echo "--> Removing Unneeded Files."

# Never going to be building the project from a unix os, so remove the scripts
# that run on these platforms.
if [ $BUILD_ON_LINUX -eq 0 ] && [ $BUILD_ON_MAC -eq 0 ]; then
	true
	#for FILE in $FILES; do RemoveFile $FILE; done
	#cp -a $SCRIPTS/Makefile $SCRIPTDIR/
	#cp -a $SCRIPTS/Android.mk $SCRIPTDIR/
	#cp -a $SCRIPTS/custom-android.mk $SCRIPTDIR/
	#cp -a $SCRIPTS/Doxyfile $SCRIPTDIR/
	#cp -a $SCRIPTS/LaunchOnWindows.bat $SCRIPTDIR/
	#cp -a $SCRIPTS/Installer.nsh $SCRIPTDIR/
fi


if [ $BUILD_FOR_UNIX -eq 0 ]; then
	RemoveFile LaunchOnLinux.sh
	RemoveFile Get_SDL2_LinuxLibs.sh
	RemoveFile GenerateLinuxLauncher.sh
	RemoveFile CompileGlewForMingW.sh
fi

if [ $BUILD_FOR_LINUX -eq 0 ]; then
	RemoveFile Fix_Ubuntu_SDL2_32-bit_Libs.sh
fi

if [ $BUILD_FOR_MAC -eq 0 ]; then true; fi

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

if [ "$PROJECT_TYPE" != "Application" ]; then
	RemoveFile LaunchOnLinux.sh
	RemoveFile LaunchOnWindows.bat
	RemoveFile Installer.nsh
	RemoveFile GenerateLinuxLauncher.sh
fi

if [ "$PROJECT_TYPE" != "Framework" ]; then true; fi


DEPENDS_SDL2=0
echo "$LIBS $STATICLIBS $LINUXLIBS $LINUXSTATICLIBS $WINLIBS $WINSTATICLIBS" | grep "\-lSDL2 "
if [ $? -eq 0 ]; then
	DEPENDS_SDL2=1
else
	RemoveFile SDL2Libs.mk
	RemoveFile Fix_Ubuntu_SDL2_32-bit_Libs.sh
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



echo "--> Inserting Project variables into project files."

# Note, the order for some of these matter.
# Example, replacing NAME before NAMESPACE invalidate all NAMESPACE instances.
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
Replace "INCLUDEDIR" "$INCLUDEDIR"
Replace "BUILDDIR" "$BUILDDIR"
Replace "DOCDIR" "$DOCDIR"
Replace "DATADIR" "$DATADIR"
Replace "THIRDPARTYDIR" "$THIRDPARTYDIR"
Replace "SCRIPTDIR" "$SCRIPTDIR"
#Replace "PLATFORM_LIBDIR" "$PLATFORM_LIBDIR"
#Replace "PROJ_INCLUDEDIR" "$PROJ_INCLUDEDIR"

Replace "SOURCES" "$SOURCES"

Replace "INCLUDES" "$INCLUDES"
Replace "LIBS" "$LIBS"
Replace "STATICLIBS" "$STATICLIBS"
Replace "WINLIBS" "$WINLIBS"
Replace "STATICWINLIBS" "$STATICWINLIBS"

Replace "CCFLAGS" "$CCFLAGS"
Replace "LDFLAGS" "$LDFLAGS"
Replace "LIBFLAGS" "$LIBFLAGS" # Don't move this up.
Replace "BINFLAGS" "$BINFLAGS"

Replace "BUILD_ON_LINUX" "$BUILD_ON_LINUX"
Replace "BUILD_ON_MAC" "$BUILD_ON_MAC"
Replace "BUILD_ON_WINDOWS" "$BUILD_ON_WINDOWS"
Replace "BUILD_FOR_LINUX_32" "$BUILD_FOR_LINUX_32"
Replace "BUILD_FOR_LINUX_64" "$BUILD_FOR_LINUX_64"
Replace "BUILD_FOR_WINDOWS_32" "$BUILD_FOR_WINDOWS_32"
Replace "BUILD_FOR_WINDOWS_64" "$BUILD_FOR_WINDOWS_64"
Replace "BUILD_FOR_ANDROID_ARM" "$BUILD_FOR_ANDROID_ARM"
Replace "BUILD_FOR_ANDROID_X86" "$BUILD_FOR_ANDROID_X86"

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



mv $SCRIPTDIR/Makefile .
mv $SCRIPTDIR/Doxyfile .
RemoveFile Makefile # Remove from $FILES variable.
RemoveFile Doxyfile # Remove from $FILES variable.


cd $PREFIX
echo "--> Installing libraries."


OS=`uname -s`
ARCH=`uname -m`

InstallSDLLibraries()
{
INSTALL_PACKAGE="n"
if [ "$OS" = "Linux" ]; then
	cat "/etc/lsb-release" | grep "Debian" > /dev/null
	if [ $? -eq 0 ]; then DEBIAN=1; fi
	cat "/etc/lsb-release" | grep "Ubuntu" > /dev/null
	if [ $? -eq 0 ]; then DEBIAN=1; fi
	if [ $DEBIAN -eq 1 ]; then
		echo "--> Would you like to install using the package manager? y/n "
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


BuildAndInstallSDLLibraries()
{
	CORES=`grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu`
	#if [ $BUILD_FOR_LINUX_32 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Linux32; fi
	if [ $BUILD_FOR_LINUX_64 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Linux64; fi
	#if [ $BUILD_FOR_MAC_32 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Mac32; fi
	#if [ $BUILD_FOR_MAC_64 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Mac64; fi
}


GetInstalledSDLLibrariesFromSystem()
{
	cd $INSTALLDIR/$LIBDIR
	if [ $BUILD_FOR_LINUX_32 -eq 1 ]; then cp -a /usr/lib/i386-linux-gnu/libSDL2* Linux_x86/; fi
	if [ $BUILD_FOR_LINUX_64 -eq 1 ]; then cp -a /usr/lib/x86_64-linux-gnu/libSDL2* Linux_x86_64/; fi
	#if [ $BUILD_FOR_MAC_32 -eq 1 ]; then cp -a /Library/; fi
	#if [ $BUILD_FOR_MAC_64 -eq 1 ]; then cp -a /Library/; fi
	cd $PREFIX
}


DownloadWindowsMinGWSDLLibraries()
{
	if [ $BUILD_FOR_WINDOWS -eq 1 ]; then
		echo "Should I download and install MinGW SDL2 libraries? y/n"
		read DOWNLOAD_MINGW_LIBS
	fi
	
	if [ "$DOWNLOAD_MINGW_LIBS" != "y" ]; then return 1; fi
	if [ $BUILD_FOR_WINDOWS_32 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Windows32; fi
	if [ $BUILD_FOR_WINDOWS_64 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Windows64; fi
}


if [ $DEPENDS_SDL2 -eq 1 ]; then
	echo "--> Your project is using the SDL2 library."
	InstallSDLLibraries
	if [ $? -ne 0 ]; then
		echo "--> Failed to install SDL libs through package manager."
		echo "--> Would you like to download and compile the SDL libs? y/n"
		read COMPILE_LIBS
		if [ "$COMPILE_LIBS" = "y" ]; then
			BuildAndInstallSDLLibraries
		else
			echo "--> Should I grab SDL2 libraries from the System? y/n"
			read GRAB_SYS_LIBS
			if [ "$GRAB_SYS_LIBS" = "y" ]; then
				GetInstalledSDLLibrariesFromSystem
			fi
		fi
	fi
	cd $INSTALLDIR/$LIBDIR/
	cp -a /usr/lib/i386-linux-gnu/libwebp.so.5* Linux_x86/
	cp -a /usr/lib/x86_64-linux-gnu/libwebp.so.5* Linux_x86_64/
	cd $PREFIX
	DownloadWindowsMinGWSDLLibraries
fi



if [ $BUILD_FOR_WINDOWS -eq 1 ]; then
	cd $INSTALLDIR/$LIBDIR/
	if [ $BUILD_FOR_WINDOWS_32 -eq 1 ]; then
		echo "--> Getting libwinpthread.dll for MinGW applications."
		cp -a /usr/i686-w64-mingw32/lib/libwinpthread-1.dll Windows_x86/
	fi
	if [ $BUILD_FOR_WINDOWS_64 -eq 1 ]; then
		echo "--> Getting libwinpthread.dll for MinGW_64 applications."
		cp -a /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll Windows_x86_64/
	fi
	cd $PREFIX
fi


if [ -d "$LIBDIR/" ] && [ "$INSTALLDIR" != "." ]; then
	echo "--> Copying LIB files to project."
	cp -a "$LIBDIR/" "$INSTALLDIR/"
fi


if [ "$PROJECT_TYPE" = "Framework" ]; then
	echo "--> Done installing base project."
	echo "--> Setting up sub-projects."
	echo "--> TODO: Generate Project.mk files for each project."
	for MODULE in $MODULES; do
		cd $PREFIX/$INSTALLDIR/$SRCDIR
		if [ -f $PREFIX/$MODULE.mk ]; then
			make -f $CPPBUILDER_PATH/Makefile $MODULE
		else
			echo "--> Failed to find $MODULE.mk"
		fi
	done
fi




