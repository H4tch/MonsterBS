#/bin/sh
## This script contains variables used by the other scripts.
## Note: All paths must be relative.
## 
## Some variables reference variables defined within a script that these will
## be injected into. For example, the SYSTEM variable is determined when the
## Makefile is invoked, or the output application is run from script. In these
## cases, the variable is derefernced with the literal "$". 

## TODO
## Project Type. If Library, change the Makefile OUTPUT, ext, and default make target correct. (so, dylib, dll) (what about static?)
## RELASE Options: -fconserve-space (saves space in the exe)
## DEBUG Options: 
## Makefile support for compiling a Library, both static and shared.
## 	-fvisibility=hidden -fvisibility-inlines-hidden. Probably don't need to hide
## 	inline functions by default!!!
## MacOSX should use -dynamiclib instead of -shared for including libraries.
## Autoinclude directories for includes and libs that are within a "third_party"
## directory.
## Create templates, or add to the generation script to be more interactive.
## Ability to create a suite of projects that share common values. This would be
##	useful for companies, libraries that are under an unmbrella project, or
##	projects you want to be built to the same location or built together. 
##	This would also be good to tie into the Application/Library thing???
## 	The Project files are contained in the root directory of the project.  
## Ability to inject additional rules into the Makefile.
## Automatic prefixing for source files, libs, etc.

#### Metadata ####

NAME=""
# Used for Android project, Doxygen, etc. Should be a reverse domain name.
NAMESPACE="com.$NAME.app"
# Don't include extension.
FILENAME=$NAME
VERSION="1.0"
ICON="icon.png"
DESCRIPTION=""
# TODO: Need ability to specify Application, Library. (Framework (umbrella project))
PROJECT_TYPE="Application"
# Unix Desktop Launcher file settings.
# http://standards.freedesktop.org/menu-spec/latest/apa.html
CATEGORIES="Game;ActionGame;RolePlaying"
RUN_IN_TERMINAL=false
#TODO: Support Actions.
# http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#extra-actions


#### Directories ####

SRCDIR="src" # TODO: Change to project's name??
LIBDIR="lib"
# Where to look for installed platform specific libraries. Possible to use BITS.(only in Makefile) 
#PLATFORM_LIBDIR=$LIBDIR"/\$OS\"_\"\$ARCH"
# Place where the main '.h' source files are.
#PROJ_INCLUDEDIR=$SRCDIR"/include"
INCLUDEDIR="include" # TODO What is this good for?? Compiliation vs Installation...
BUILDDIR="build"
# Docdir Who?
DOCDIR="doc"
DATADIR="data"
THIRDPARTYDIR="third_party"
SCRIPTDIR="tools"


#### Source files ####

SOURCES="$SRCDIR/main.cpp"



#### Build Settings ####

# MingW32, automatic visiblity: -no-undefined and --enable-runtime-pseudo-reloc

INCLUDES="-I$INCLUDEDIR -I$SRCDIR"
## Note, in some cases, the order of libs do matter.
# TODO: Need to fix all the escapings.
LIBS="-L$(LIBDIR)/\$(SYSTEM) -lSDL2 -lSDL2_image -lSDL2_ttf"  #-lGL -lbox2d
STATICLIBS="-static-libstdc++ -static-libgcc -Wl,-Bstatic"
WINLIBS="-lmingw32 -lSDL2main" #-lwinpthread -mwindows -lwinmm
STATICWINLIBS=""

DEFINES=""
DEFINES_DEBUG="-DDEBUG"
DEFINES_RELEASE="-DNDEBUG"
DEFINES_32="-DX86"
DEFINES_64="-DX86_64"
DEFINES_ARM="-DARM"
LINUXDEFINES="-DLINUX"
MACDEFINES="-DOSX"
WINDEFINES="-DWINDOWS"

#CCFLAGS="-c -fPIC -std=c++0x -Wall -pedantic `sdl2-config --cflags`"
CCFLAGS="-c -fPIC -std=c++11 -Wall -pedantic -pthread -frtti -fexceptions \
			-fvisibility=hidden -fvisibility-inlines-hidden \
			-ffunction-sections -fdata-sections"
LDFLAGS="-fuse-ld=gold -Wl,--gc-sections,-Bdynamic,-rpath,\$\$ORIGIN/\$(LIBDIR)/\$(SYSTEM)"
LIBFLAGS="-export-dynamic -shared"
LIBFLAGS_LINUX="-Wl,-soname,lib\$(NAME)\$(LIBEXT)"
LIBFLAGS_MAC="-dynamiclib -Wl,-dylib-install_name,lib\$(NAME)\$(LIBEXT)"
LIBFLAGS_WINDOWS="--Wl,-out-implib,lib\$(NAME)\$(LIBEXT).a"
BINFLAGS=""
FLAGS_DEBUG="-g"
FLAGS_RELEASE="" # TODO: Optimizations.


# These modify Release.sh, Packaging, and scripts...
BUILD_FOR_LINUX_32=1
BUILD_FOR_LINUX_64=1
BUILD_FOR_MAC_32=0
BUILD_FOR_MAC_64=0
BUILD_FOR_WINDOWS_32=1
BUILD_FOR_WINDOWS_64=1
BUILD_FOR_ANDROID_ARM=0 # Not supported yet.
BUILD_FOR_ANDROID_X86=0 # Not supported yet.


LINUX_CC_PREFIX_32=""
LINUX_CC_PREFIX_64=""
MAC_CC_PREFIX_32=""
MAC_CC_PREFIX_64=""
WINDOWS_CC_PREFIX_32="i686-w64-mingw32"
WINDOWS_CC_PREFIX_64="x86_64-w64-mingw32"

LINUX_CC_32="g++ -m32"
LINUX_CC_64="g++ -m64"
MAC_CC_32="g++ -m32"
MAC_CC_64="g++ -m64"
WINDOWS_CC_32="$WINDOWS_CC_PREFIX_32-g++"
WINDOWS_CC_64="$WINDOWS_CC_PREFIX_64-g++"
LINUX_CC_ARM=""
MAC_CC_ARM=""
WINDOWS_CC_ARM=""

LINUX_AR_32="ar"
LINUX_AR_64="ar"
MAC_AR_32="ar"
MAC_AR_64="ar"
WINDOWS_AR_32="$WINDOWS_CC_PREFIX_32-ar"
WINDOWS_AR_64="$WINDOWS_CC_PREFIX_64-ar"
LINUX_AR_ARM=""
MAC_AR_ARM=""
WINDOWS_AR_ARM=""


#### PACKAGING ####
# TODO This is not yet supported.
# Should a Package containing all platforms be created?
#PACKAGE_ALL_IN_ONE=0

# Currently only "zip" and "tar.gz" archives are supported. 
PACKAGE_ARCHIVE_TYPE_LINUX="tar.gz"
PACKAGE_ARCHIVE_TYPE_WINDOWS="zip"




#### Documentation Settings ####

DOCSET_NAME="$NAME Documentation"
PUBLISHERNAME=$NAME
PUBLISHER_NAMESPACE=$NAMESPACE
# Don't document source from these paths.
HIDE_DOC_WITHIN_PATHS=""
# Don't document source files that match the patterns.
# Ex Pattern: "*/test/*"
HIDE_DOC_WITH_PATTERNS=""
# Hide part of the user's include path from the docs.
# Ex: Turn "src/Lib/lib.h" into "/Lib/lib.h"
HIDE_INC_PATH_PREFIX=""
# Hide namespace, classes, functions, etc from the docs.
# Ex: "Lib::*Test Lib::Test*"
HIDE_DOC_WITH_SYMBOLS=""
# Directory containing images for documentation. Used with image tag.
DOC_IMAGE_DIR=""




