#!/bin/sh
##
## Monster Build System  -  https://www.github.com/h4tch/MonsterBS
## MIT Licensed 2014-2015
## Created by: Daniel Hatch <h4tch.github.com>
##
## Project Generation Script.
## Creates Project directories and generates files from `PROJECT.mk` settings.
## Cannot be called directory, use `make PROJECT` instead.
##

PREFIX=$PWD
MONSTERBS_PATH=`dirname $0`
FILES=""
SCRIPTDIR=tools
INSTALLDIR=$NAME

## Detect if the Project already exists or the current directory is the Project.
NEW_PROJECT=0
if [ "`basename $PWD`" = "$NAME" ] && [ "$MONSTERBS_PATH" != "$PWD" ]; then
	echo "--> Treating current directory as the Project's root directory."
	INSTALLDIR="."
	echo "--> Building Project" "'$NAME'"
else
	if [ ! -d "$INSTALLDIR" ]; then
		echo "--> Building New Project" "'$NAME'"
		NEW_PROJECT=1
		mkdir -p $INSTALLDIR
	fi
fi

STANDALONE=0
if [ -z "$FRAMEWORK" ]; then STANDALONE=1; fi
if [ $STANDALONE -eq 1 ]; then echo "Treating Project as Standalone"; fi

### Begine installation
cd $INSTALLDIR
mkdir -p $SRCDIR $INCLUDEDIR $LIBDIR $TESTDIR $SCRIPTDIR

# Detect OS and ARCH Build Targets.
for Platform in $TARGET_PLATFORMS; do
	PLATFORM=`echo $Platform | tr a-z A-Z`
	PLATFORM_ARCHS=$PLATFORM"_ARCHS"
	for Arch in ${!PLATFORM_ARCHS}; do
		mkdir -p $LIBDIR/$Platform"_"$Arch
		ARCH=`echo $Arch | tr a-z A-Z`
		TARGET_OS_ARCH="TARGET_"$PLATFORM"_"$ARCH
		export ${TARGET_OS_ARCH}=1
	done
done


#if [ $INSTALL_MONSTERBS -eq 1 ]; then
#	echo "--> Installing MonsterBS to Project's Script directory."
#	cp -a $MONSTERBS_PATH $SCRIPTDIR/
#	echo "installed.."
#	MONSTERBS_PATH=$SCRIPTDIR/MonsterBS/
#fi

InstallFile() {
	if [ $# -lt 1 ]; then
		echo "Invalid arguments to InstallFile() function";
		exit 1;
	fi
	FILES="$FILES $1"
	cp -a "$MONSTERBS_PATH/tools"/$1 $SCRIPTDIR/
}

echo "--> Copying scripts to" $INSTALLDIR/$SCRIPTDIR
cp $PREFIX/$NAME.mk .

InstallFile Makefile
InstallFile ProjectMakefile
InstallFile Doxyfile


if [ $STANDALONE -eq 1 ]; then
	echo $TARGET_PLATFORMS | grep "Linux"  > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		InstallFile LaunchOnLinux.sh
		InstallFile GenerateLinuxLauncher.sh
		InstallFile CompileGlewForMingW.sh
		TARGET_LINUX=1
	fi

	echo $TARGET_PLATFORMS | grep "Mac"  > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		#InstallFile LaunchOnMac.sh
		#InstallFile GenerateMacLauncher.sh
		TARGET_MAC=1
	fi


	echo $TARGET_PLATFORMS | grep "Windows"  > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		InstallFile LaunchOnWindows.bat
		InstallFile Installer.nsh
		TARGET_WINDOWS=1
	fi

	echo $TARGET_PLATFORMS | grep "Android"  > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		InstallFile Android.mk
		InstallFile AndroidBuildAPK.sh
		InstallFile AndroidProject.sh
		InstallFile AndroidStandalone.mk
		InstallFile Application.mk
		InstallFile SetupAndroidProject.sh
		TARGET_ANDROID=1
	fi

	echo "$LIBS $STATICLIBS" | grep "\-lSDL2 "  > /dev/null 2>&1
	if [ $? -eq 0 ]; then DEPENDS_SDL2=1; InstallFile SDL2Libs.mk; fi
fi



echo "--> Inserting Project variables into project files."

Replace() {
	if [ $# -lt 1 ]; then exit 1; fi
	if [ $# -lt 2 ];
		then REPLACEWITH=""
	fi
	SEARCHFOR="\$\$$1"
	#SEARCHFOR=`echo $1 | sed -e 's/\\$/\\\\$/g'`
	REPLACEWITH=`echo $2 | sed -e 's/\\\/\\\\\\\\\\\\/g' -e 's/&/\\\&/g' \
								-e 's/\\//\\\\\//g'`
	#echo $SEARCHFOR \""$REPLACEWITH"\"
	#echo "SCRIPTDIR: " $SCRIPTDIR/

	for FILE in $FILES; do
		cat $SCRIPTDIR/$FILE | sed s/$SEARCHFOR/"$REPLACEWITH"/g > \
			$SCRIPTDIR/$FILE".new"
		mv $SCRIPTDIR/$FILE".new" $SCRIPTDIR/$FILE
	done
}


# Note, the order for some of these matter.
# Example, replacing NAME before NAMESPACE invalidate all NAMESPACE instances.
Replace "MONSTERBS_PATH" "$MONSTERBS_PATH"
Replace "NAMESPACE" "$NAMESPACE"
Replace "NAME" "$NAME"
Replace "FILENAME" "$FILENAME"
Replace "VERSION" "$VERSION"
Replace "ICON" "$ICON"
Replace "DESCRIPTION" "$DESCRIPTION"
Replace "CATEGORIES" "$CATEGORIES"
Replace "RUN_IN_TERMINAL" "$RUN_IN_TERMINAL"
Replace "PROJECT_TYPE" "$PROJECT_TYPE"
Replace "MODULES" "$MODULES"

Replace "SRCDIR" "$SRCDIR"
Replace "LIBDIR" "$LIBDIR"
Replace "INCLUDEDIR" "$INCLUDEDIR"
Replace "TESTDIR" "$TESTDIR"
Replace "BUILDDIR" "$BUILDDIR"
Replace "DOCDIR" "$DOCDIR"
Replace "DATADIR" "$DATADIR"
Replace "THIRDPARTYDIR" "$THIRDPARTYDIR"
#Replace "SCRIPTDIR" "$SCRIPTDIR"
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

Replace "" "$"
Replace "TARGET_LINUX_X86" "$TARGET_LINUX_X86"
Replace "TARGET_LINUX_X86_64" "$TARGET_LINUX_X86_64"
Replace "TARGET_WINDOWS_X86" "$TARGET_WINDOWS_X86"
Replace "TARGET_WINDOWS_X86_64" "$TARGET_WINDOWS_X86_64"
Replace "TARGET_ANDROID_ARM" "$TARGET_ANDROID_ARM"
Replace "TARGET_ANDROID_X86" "$TARGET_ANDROID_X86"

Replace "DOCSET_NAME" "$DOCSET_NAME"
Replace "PUBLISHERNAME" "$PUBLISHERNAME"
Replace "PUBLISHER_NAMESPACE" "$PUBLISHER_NAMESPACE"
Replace "HIDE_DOC_WITHIN_PATHS" "$HIDE_DOC_WITHIN_PATHS"
Replace "HIDE_DOC_WITH_PATTERNS" "$HIDE_DOC_WITH_PATTERNS"
Replace "HIDE_INC_PATH_PREFIX" "$HIDE_INC_PATH_PREFIX"
Replace "HIDE_DOC_WITH_SYMBOLS" "$HIDE_DOC_WITH_SYMBOLS"
Replace "DOC_IMAGE_DIR" "$DOC_IMAGE_DIR"


if [ "$PROJECT_TYPE" = "Library" ]; then
	Replace "DEFAULT_BUILD_RULE" "shared"
	mv $SCRIPTDIR/Makefile .
	rm $SCRIPTDIR/ProjectMakefile
elif [ "$PROJECT_TYPE" = "Application" ]; then
	Replace "DEFAULT_BUILD_RULE" "\$(OUTPUT)"
	mv $SCRIPTDIR/Makefile .
	rm $SCRIPTDIR/ProjectMakefile
elif [ "$PROJECT_TYPE" = "Framework" ]; then
	mv $SCRIPTDIR/ProjectMakefile MakeFile
	rm $SCRIPTDIR/Makefile
fi

mv $SCRIPTDIR/Doxyfile .
#RemoveFile Doxyfile
#RemoveFile Makefile
#RemoveFile ProjectMakefile
if [ $STANDALONE -eq 0 ]; then rmdir $SCRIPTDIR; fi

echo "--> Removing Unneeded Files."

RemoveFile()
{
	if [ $# -lt 1 ]; then
		echo "Invalid arguments to RemoveFile() function";
		exit 1;
	fi
	FILES=`echo $FILES | sed -e "s@$1@ @g"`
	rm $SCRIPTDIR/$1 > /dev/null 2>&1
}

if [ "$PROJECT_TYPE" != "Application" ]; then
	RemoveFile LaunchOnLinux.sh
	RemoveFile GenerateLinuxLauncher.sh
	RemoveFile LaunchOnWindows.bat
	RemoveFile Installer.nsh
	RemoveFile Release.sh
fi


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
		echo "--> Would you like to install SDL2 using the 'apt' package manager? y/n "
		read INSTALL_PACKAGE
		if [ "$INSTALL_PACKAGE" = "y" ]; then
			for LIB in $LIBS; do
				echo $LIB | grep "\-L" > /dev/null
				if [ $? -eq 0 ]; then continue; fi
				LIB=`echo $LIB | sed -e 's/-l/lib/g' -e 's/_/\-/g'`
				sudo apt-get install $LIB-*
				if [ $ARCH = "x86_X86_64" ]; then
					if [ $TARGET_LINUX_X86 ]; then
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
	if [ $TARGET_WINDOWS_X86 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk MinGW32; fi
	if [ $TARGET_WINDOWS_X86_64 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk MinGW64; fi
	if [ $TARGET_LINUX_X86 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Linux32; fi
	if [ $TARGET_LINUX_X86_64 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Linux64; fi
	if [ $TARGET_MAC_X86 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Mac32; fi
	if [ $TARGET_MAC_X86_64 -eq 1 ]; then make -j$CORES -f $INSTALLDIR/$SCRIPTDIR/SDL2Libs.mk Mac64; fi
}


GetInstalledSDLLibrariesFromSystem()
{
	cd $INSTALLDIR/$LIBDIR
	if [ $TARGET_LINUX_X86 -eq 1 ]; then cp -a /usr/lib/i386-linux-gnu/libSDL2* Linux_x86/; fi
	if [ $TARGET_LINUX_X86_64 -eq 1 ]; then cp -a /usr/lib/x86_X86_64-linux-gnu/libSDL2* Linux_x86_X86_64/; fi
	if [ $TARGET_MAC -eq 1 ]; then cp -a ls /usr/local/lib/libSDL2* Mac_x86_X86_64/; fi
	cd $PREFIX
}


if [ $DEPENDS_SDL2 -eq 1 ]; then
	echo "--> Your project is using the SDL2 library."
	InstallSDLLibraries
	if [ $? -ne 0 ]; then
		echo "--> Couldn't install SDL2 through package manager."
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
	cp -a /usr/lib/x86_X86_64-linux-gnu/libwebp.so.5* Linux_x86_X86_64/
	cd $PREFIX
fi



if [ $TARGET_WINDOWS -eq 1 ] && [ "$OS" = "Linux" ]; then
	cd $INSTALLDIR/$LIBDIR/
	if [ $TARGET_WINDOWS -eq 1 ]; then
		echo "--> Getting libwinpthread.dll for MinGW applications."
	fi
	if [ $TARGET_WINDOWS_X86 -eq 1 ]; then
		cp -a /usr/i686-w64-mingw32/lib/libwinpthread-1.dll Windows_x86/
	fi
	if [ $TARGET_WINDOWS_X86_64 -eq 1 ]; then
		cp -a /usr/x86_X86_64-w64-mingw32/lib/libwinpthread-1.dll Windows_x86_X86_64/
	fi
	cd $PREFIX
fi


if [ -d "$LIBDIR/" ] && [ "$LIBDIR" != "." ] && [ "$INSTALLDIR" != "." ]; then
	echo "--> Copying LIB files to project."
	cp -a "$LIBDIR/" "$INSTALLDIR/"
fi




if [ "$PROJECT_TYPE" != "Framework" ]; then exit 0; fi
if [ "$MODULES" = "" ]; then exit 0; fi

echo "Setting up $NAME Framework"

cd $PREFIX/$INSTALLDIR/

# TODO
# Combined Documentation Generation
# Module Namespaces.
# Should the sub-project generation be put into a separate script?
# Framework-wide include, library, script, and third-party directories.
# Sub-project's should "install" their output or headers into framework
#	directories.
# Setup Framwork-wide tests.


echo "$MODULES" | grep "$NAME" > /dev/null
if [ $? -eq 0 ]; then
	echo "A Framework's sub-project cannot have the same as the framework."
fi

#rm Makefile
#rm Doxyfile

# Setup Framework's Makefile and SubProject include hierarchy.
# Include
#   Project
#     SubProject
#       SubProject.h
#     Project.h
if [ $NEW_PROJECT -eq 1 ]; then
	cd $INCLUDEDIR/
	# Framework's main include file.
	touch $NAME.h
	UPPERNAME=$(echo $NAME | tr '[:lower:]' '[:upper:]')
	echo "#ifndef _"$UPPERNAME"_"$UPPERNAME"_H" >> $NAME.h
	echo "#define _"$UPPERNAME"_"$UPPERNAME"_H\n" >> $NAME.h
	for MODULE in $MODULES; do
		#mkdir -p $NAME/$MODULE
		#touch $NAME/$MODULE/$MODULE.h
		echo "#include \"$NAME/$MODULE/$MODULE.h\"" >> $NAME.h
	done
	echo "\n#endif //_"$UPPERNAME"_"$UPPERNAME"_H" >> $NAME.h
	cd $PREFIX/$INSTALLDIR
fi
exit


# Back track from Module's root to the Framework's root directory to determine
# relative path.
cd $PREFIX/$INSTALLDIR/$SRCDIR/
ROOT="../"
while [ "`ls .`" != "`ls ../`" ]; do
	cd ../;
	ROOT=$ROOT"../";
	if [ "`basename $PWD`" = "$NAME" ]; then
		break;
	fi
done
if [ "`basename $PWD`" != "$NAME" ]; then ROOT=""; fi



echo "--> Setting up Framework's sub-projects."
for MODULE in $MODULES; do
	echo "--> Creating sub-project:" $MODULE
	
	mkdir -p $SRCDIR/$MODULE
	cd $SRCDIR/$MODULE
	mkdir -p $SRCDIR $INCLUDEDIR $LIBDIR $TESTDIR
	touch $INCLUDEDIR/$MODULE.h
	if [ -f $MODULE.mk ]; then # Sub-project already exists.
		true
	elif [ -f $PREFIX/$INSTALLDIR/$MODULE.mk ]; then # Sub-project.mk is in root.
		cp $PREFIX/$INSTALLDIR/$MODULE.mk .
	elif [ -f $MONSTERBS_PATH/$MODULE.mk ]; then # Sub-project.mk is in the BS dir.
		cp $MONSTERBS_PATH/$MODULE.mk .
	else # Generate the Sub-project.mk file from the Framework's makefile.
		echo "--> Generating $MODULE.mk"
		cp $PREFIX/$INSTALLDIR/$NAME.mk $MODULE.mk
		cat $MODULE.mk | sed "s@NAME = $NAME@Name = $MODULE@g" \
			> $MODULE.mk".new"; mv $MODULE.mk".new" $MODULE.mk
		cat $MODULE.mk | sed "s@PROJECT_TYPE = Framework@PROJECT_TYPE = Library@g" \
			> $MODULE.mk".new"; mv $MODULE.mk".new" $MODULE.mk
	fi
	# Don't recursively make the sub-projects automatically.
	#make -f $MONSTERBS_PATH/Makefile $MODULE
	cd $PREFIX/$INSTALLDIR/
done



