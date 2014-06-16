## This Makefile contains variables used by the other scripts.
## Note: All paths must be relative.
## 
## TODO
## FRAMEWORK SUPPORT
## Need to modify sub project makefile's directories so they are shared.
## 	All Makefiles, Doxyfiles, tools/scripts should be outside of sub-project 
##	dirs?
##	Build target should be same except embedded within sub-project dir.
## 	Libs should be installed top level.
## 	
## When generating/modifying MODULE's make files, if the framework is installing
## 	CPPPROJECTBUILDER, then modify the Makefile to be able to find it.
## Need to generate sub-project makefiles. How to handle library support?
##	Need mechanism for overriding variables.
## Add an extra DEFINE when installing MODULES within a Framework to notify that
##	it is being compiled STANDALONE.
## Need a place for common code that all projects share. Maybe a better 
##	mechanism for "installing" headers.
##
## Generate Windows NSIS installer file.
## Project Type. If Library, change the Makefile OUTPUT, ext, and default make target correct. (so, dylib, dll) (what about static?)
## RELASE Options: -fconserve-space (saves space in the exe)
## Makefile support for compiling a Library, both static and shared.
## 	-fvisibility=hidden -fvisibility-inlines-hidden. Probably don't need to hide
## 	inline functions by default!!!
## Autoinclude directories for includes and libs that are within a "third_party"
## 	directory...
## Create templates, or add to the generation script to be more interactive.
## Ability to create a suite of projects that share common values. This would be
##	useful for companies, libraries that are under an unmbrella project, or
##	projects you want to be built to the same location or built together. 
##	This would also be good to tie into the Application/Library thing???
## 	The Project files are contained in the root directory of the project. 
## Automatic prefixing for source files, libs, etc.

#### Metadata ####

NAME = Project
# Used for Android project, Doxygen, etc. Should be a reverse domain name.
NAMESPACE = com.$(NAME).app
# Don't include extension.
FILENAME = $(NAME)
VERSION = 1.0
ICON = icon.png
DESCRIPTION =
# TODO: Imrpove support for project's type.
PROJECT_TYPE = Application # Application | Library | Framework
MODULES = # Specify sub-projects if PROJECT_TYPE = Framework
# Unix Desktop Launcher file settings.
# http://standards.freedesktop.org/menu-spec/latest/apa.html
CATEGORIES = Game;ActionGame;RolePlaying
RUN_IN_TERMINAL = false
#TODO: Support Actions.
# http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#extra-actions


# Install this Cpp Project Generator into the source tree of your project to
# tweak the install later?
INSTALL_CPPPROJECTBUILDER = 0


#### Directories ####
# TODO: Change to project's name??
SRCDIR = src
LIBDIR = lib
# Where to look for installed platform specific libraries. Possible to use BITS.(only in Makefile) 
#PLATFORM_LIBDIR=$(LIBDIR)/$(OS)"_"$(ARCH)
# Place where the main '.h' source files are.
#PROJ_INCLUDEDIR=$(SRCDIR)/include
# TODO What is this good for?? Compiliation vs Installation...What if PROJECT_TYPE == Library?
INCLUDEDIR = include
BUILDDIR = build
# Docdir Who?
DOCDIR = doc
DATADIR = data 
THIRDPARTYDIR = third_party
SCRIPTDIR = tools



#### Source files ####

# TODO: Should the umbrella project have source files??
SOURCES = $(SRCDIR)/main.cpp
#SOURCES = $(patsubstr %, $(SRCDIR)/%, $(SOURCES) )


#### Build Settings ####

# MingW32, automatic visiblity: -no-undefined and --enable-runtime-pseudo-reloc

INCLUDES = -I$(INCLUDEDIR) -I$(SRCDIR) -I$(THIRDPARTYDIR) -I.
## Note, in some cases, the order of libs do matter.
LIBS = -L$(LIBDIR)/$(SYSTEM) -L$(THIRDPARTYDIR) -lSDL2 -lSDL2_image -lSDL2_ttf  #-lGL -lbox2d
STATICLIBS = -static-libstdc++ -static-libgcc

DEFINES =
CCFLAGS = -c -fPIC -std=c++11 -Wall -pedantic -pthread -frtti -fexceptions \
			-fvisibility=hidden -fvisibility-inlines-hidden \
			-ffunction-sections -fdata-sections
LDFLAGS = -fuse-ld=gold -Wl,--gc-sections,-Bdynamic,-rpath,$$ORIGIN/$(LIBDIR)/$(SYSTEM)/
LIBFLAGS = -export-dynamic -shared


# These modify Release.sh, Packaging, and scripts...
BUILD_FOR_LINUX_32=1
BUILD_FOR_LINUX_64=1
BUILD_FOR_MAC_32=0
BUILD_FOR_MAC_64=0
BUILD_FOR_WINDOWS_32=1
BUILD_FOR_WINDOWS_64=1
BUILD_FOR_ANDROID_ARM=0 # Not supported yet.
BUILD_FOR_ANDROID_X86=0 # Not supported yet.


#### PACKAGING ####
# TODO This is not yet supported.
# Should a Package containing all platforms be created?
#PACKAGE_ALL_IN_ONE=0

# Currently only "zip" and "tar.gz" archives are supported. 
PACKAGE_ARCHIVE_TYPE_LINUX = tar.gz
PACKAGE_ARCHIVE_TYPE_WINDOWS = zip



#### Documentation Settings ####

DOCSET_NAME = $(NAME) Documentation
PUBLISHERNAME = $(NAME)
PUBLISHER_NAMESPACE = $(NAMESPACE)
# Don't document source from these paths.
HIDE_DOC_WITHIN_PATHS =
# Don't document source files that match the patterns.
# Ex Pattern: "*/test/*"
HIDE_DOC_WITH_PATTERNS =
# Hide part of the user's include path from the docs.
# Ex: Turn "src/Lib/lib.h" into "/Lib/lib.h"
HIDE_INC_PATH_PREFIX =
# Hide namespace, classes, functions, etc from the docs.
# Ex: "Lib::*Test Lib::Test*"
HIDE_DOC_WITH_SYMBOLS =
# Directory containing images for documentation. Used with image tag.
DOC_IMAGE_DIR =



