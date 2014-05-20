#/bin/sh
## This script contains variables used by the other scripts.
## Note: All paths must be relative.
## 
## Some variables reference variables defined within a script that these will
## be injected into. For example, the SYSTEM variable is determined when the
## Makefile is invoked, or the output application is run from script. In these
## cases, the variable is derefernced with the literal "$". 
## TODO: Note, Makefiles use a different syntax for dereferencing variables.
## 

## TODO: Need escaping syntax. Probably use \$\$.

#### Metadata ####

NAME=""
# Used for Android project, Doxygen, etc. Should be a reverse domain name.
NAMESPACE="com.$NAME.app"
# Don't include extension.
FILENAME=$NAME
VERSION="1.0"
ICON="icon.png"
DESCRIPTION=""
# Unix Desktop Launcher file settings.
# http://standards.freedesktop.org/menu-spec/latest/apa.html
CATEGORIES="Game;ActionGame;RolePlaying"
RUN_IN_TERMINAL=false
#TODO: Support Actions. http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#extra-actions


#### Directories ####

SRCDIR="src" # TODO: Change to project's name??
LIBDIR="lib"
# Where to look for installed platform specific libraries. Possible to use BITS.(only in Makefile) 
#PLATFORM_LIBDIR=$LIBDIR"/\$OS\"_\"\$ARCH"
# Place where the main '.h' source files are.
#PROJ_INCLUDEDIR=$SRCDIR"/include"
INCLUDEDIR="include" # TODO What is this good for??
# TODO: This can be overriden before compilation by exporting it to a different value.
BUILDDIR="build"
DOCDIR="doc"
DATADIR="data"



#### Source files ####

SOURCES=$SRCDIR/main.cpp



#### Build Settings ####

INCLUDES="-I$INCLUDEDIR -I$SRCDIR"
## Note, in some cases, the order of libs do matter.
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

CCFLAGS="-c -std=c++0x -Wall -pedantic `sdl2-config --cflags`"
LDFLAGS="-fuse-ld=gold -Wl,-Bdynamic,-rpath,\$\$ORIGIN/\$(LIBDIR)/\$(SYSTEM)"
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


LINUX_CC_32="g++ -m32"
LINUX_CC_64="g++ -m64"
MAC_CC_32="g++ -m32"
MAC_CC_64="g++ -m64"
WINDOWS_CC_32="i686-w64-mingw32-g++"
WINDOWS_CC_64="x86_64-w64-mingw32-g++"



#### PACKAGING ####

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




