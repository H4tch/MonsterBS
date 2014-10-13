##
## This Makefile contains variables used by the other scripts.
## Note: All paths must be relative.
##

#### Metadata ####
NAME = Project
NAMESPACE := com.$(NAME).app
FILENAME := $(echo $(NAME) | tr A-Z a-z)
VERSION = 1.0
ICON = icon.png
DESCRIPTION =
# Unix Desktop Launcher file settings for Application.
# http://standards.freedesktop.org/menu-spec/latest/apa.html
CATEGORIES = Game;ActionGame;RolePlaying
RUN_IN_TERMINAL = false
# http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#extra-actions

# PROJECT_TYPE can be Application, Library, or Framework.
# 	Application: Include files are not installed. Symbols are hidden by default.
# 	Library: Include files are installed. Symbols are visible by default.
# 	Framework: Contains a collection of sub-projects defined in MODULES.
PROJECT_TYPE = Framework
# Specify the Framework's sub-projects. The order will determine compilation.
MODULES = 

# If true, copies MONSTERBS into your project hierarchy.
INSTALL_MONSTERBS = 0
# If true, scripts meant for platforms that aren't targetted won't be removed.
KEEP_UNNEEDED_SCRIPTS = 0


#### Directories ####
SRCDIR = src
LIBDIR = lib
INCLUDEDIR = include
TESTDIR = test
BUILDDIR = build
DOCDIR = doc
DATADIR = data
THIRDPARTYDIR = third_party
SCRIPTDIR = tools
# Framework wide installation directories of libs and includes.
#PLATFORM_LIBDIR = $(LIBDIR)/$(OS)"_"$(ARCH)
#PROJ_INCLUDEDIR =  $(INCLUDEDIR)


#### Source files are retrieved from SRCDIR automatically.
SOURCES := $(shell find $(SRCDIR) -type f -name "*.cpp")

# MingW32, automatic visiblity: -no-undefined and --enable-runtime-pseudo-reloc
INCLUDES = -I$(INCLUDEDIR) -I$(SRCDIR) -I$(THIRDPARTYDIR) -I../../$(INCLUDEDIR)/
LIBS = -L$(LIBDIR)/$(SYSTEM) -L$(THIRDPARTYDIR) -L../../$(LIBDIR)/$(SYSTEM) -L.
#LIBNAMES = SDL2 SDL2_image
#LIBDIRS = -L$(LIBDIR)/$(SYSTEM) -L$(THIRDPARTYDIR) -L.
#LIBS := $(patsubst %, -l%, $(LIBNAMES))
#LIBS := $(LIBNAMES) $(LIBS)
STATICLIBS = -static-libstdc++ -static-libgcc
DEFINES =
CXXFLAGS = -c -fPIC -std=c++11 -Wall -pedantic -pthread -frtti -fexceptions \
			-fvisibility=hidden -fvisibility-inlines-hidden \
			-ffunction-sections -fdata-sections
LDFLAGS = -fuse-ld=gold -Wl,--gc-sections,-Bdynamic,-rpath=$$ORIGIN/$(LIBDIR)/$(SYSTEM)/
LIBFLAGS = -export-dynamic -shared

# VPATHS are searched when a file can't be found by MAKE. This is needed when
#	src/dir/source.cpp includes src/dir/source.h with "#include "source.h"".
# The dependency will be added as "source.h" instead of "dir/source.h".
VPATH += $(SRCDIR) $(INCLUDEDIR)


define RELEASE_PROFILE
	# Todo Optimizations
	CXXFLAGS := $(CXXFLAGS)
	LDFLAGS := $(LDFLAGS)
	DEFINES := $(DEFINES) -DNDEBUG 
endef
define DEBUG_PROFILE
	CXXFLAGS := -g -fno-pie $(CXXFLAGS)
	LDFLAGS := -g -fno-pie $(LDFLAGS)
	DEFINES := $(DEFINES) -DDEBUG 
endef


define WINDOWS_PROFILE
	EXT := .exe
	LIBEXT := .dll
	LIBEXTSTATIC := .lib
	LIBS := -lmingw32 $(LIBS)
	DEFINES := $(DEFINES) -DWINDOWS -DWIN32
	LIBFLAGS := $(LIBFLAGS) -Wl,-out-implib,lib$(NAME)$(LIBEXT).a
	# The CXX_PREFIX should probably be different depending on HOST_OS too.
	ifeq ($(HOST_ARCH),x86)
		CXX_PREFIX = i686-w64-mingw32-
	else ifeq ($(HOST_ARCH),x86_64)
		CXX_PREFIX = x86_64-w64-mingw32-
	endif
	CXX = $(CXX_PREFIX)g++
	AR = $(CXX_PREFIX)ar
endef

define LINUX_PROFILE
	ifeq ($(OS), x86)
	endif
	EXT := 
	LIBEXT := .so
	LIBEXTSTATIC := .a
	LIBS := $(LIBS) -ldl
	DEFINES := $(DEFINES) -DLINUX
	LIBFLAGS := $(LIBFLAGS) -Wl,-soname,lib$(NAME)$(LIBEXT)
	CXX = g++
	AR = ar
endef

define MAC_PROFILE
	EXT := 
	LIBEXT := .dylib
	LIBEXTSTATIC := .a
	LIBS := $(LIBS) -ldl
	DEFINES := $(DEFINES) -DOSX
	LIBFLAGS := $(LIBFLAGS) -dynamiclib -Wl,-dylib-install_name,lib$(NAME)$(LIBEXT)
	CXX = g++
	AR = ar
endef


define X86_PROFILE
	DEFINES := $(DEFINES) -DX86
	CXX = $(CXX) -m32
endef

define X86_64_PROFILE
	DEFINES := $(DEFINES) -DX86_64
	CXX = $(CXX) -m64
endef

define ARM_PROFILE
	DEFINES := $(DEFINES) -DARM
endef


# Determines the platforms you will be building on.
BUILD_ON_LINUX = 1
BUILD_ON_MAC = 0
BUILD_ON_WINDOWS = 1

# Determines what scripts and libraries are copied into your project.
BUILD_FOR_LINUX_32 = 1
BUILD_FOR_LINUX_64 = 1
BUILD_FOR_MAC_32 = 0
BUILD_FOR_MAC_64 = 0
BUILD_FOR_WINDOWS_32 = 1
BUILD_FOR_WINDOWS_64 = 1
# Not supported.
BUILD_FOR_ANDROID_ARM = 0
BUILD_FOR_ANDROID_X86 = 0


#### PACKAGING ####
# Create a Package containing all platforms be created?
#PACKAGE_ALL_IN_ONE=0

# Currently only "zip" and "tar.gz" archives are supported. 
# Shouldn't i just use commands?
PACKAGE_ARCHIVE_TYPE_LINUX = tar.gz
PACKAGE_ARCHIVE_TYPE_WINDOWS = zip


#### Documentation Settings ####
# Customize the Doxyfile for greater control.
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


