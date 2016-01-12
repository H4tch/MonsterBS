## Monster Build System  -  https://www.github.com/h4tch/MonsterBS
## MIT Licensed 2014-2016
## Created by: Daniel Hatch <h4tch.github.com>
##
## Project Description File.
## Defines Project generation and Build settings.
##
## Note: All paths must be relative.
##

#include $(MONSTERBS_PATH)/Project.mk

NAME = Project
# Framework that the Module belongs to.
FRAMEWORK = Project
FRAMEWORK_PATH = $($(shell echo $(FRAMEWORK)_PATH | tr a-z A-Z))
# Application: Include files are not installed. Symbols are hidden by default.
# Library: Include files are installed. Symbols are visible by default.
# Framework: Contains a collection of sub-projects defined in MODULES.
PROJECT_TYPE = Application
# Names of the Framework's sub-project Modules. Order determines compilation.
#MODULES =
# Dependencies between this Module and others within this Framework.
DEPENDENCIES = 
FILENAME = $(shell echo $(NAME) | tr A-Z a-z)
NAMESPACE := com.$(FRAMEWORK).$(NAME)
VERSION = 1.0
ICON = icon.png
DESCRIPTION = 
# Unix Desktop Launcher file settings for Application.
# http://standards.freedesktop.org/menu-spec/latest/apa.html
# http://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#extra-actions
CATEGORIES = 
RUN_IN_TERMINAL = false


#$(BUILT_UNIT)_SRC = server.o server_priv.o server_access.o
#$(BUILD_UNIT)_LIBS = priv protocol
#all: $(PROGRAMS)
#define PROGRAM_BUILDER =
#	$(call $(1)_PROFILE)
#	$(1): $$($(1)_OBJS) $$($(1)_LIBS:%=-l%)
#endef
#$(foreach PROGRAM,$(PROGRAMS),$(eval $(call PROGRAM_BUILDER,$(PROGRAM))))


#BUILD_UNITS 		= src test modules
PROFILES 			= test debug release
TARGET_PLATFORMS 	= Linux Mac Windows Android
LINUX_ARCHS 		= x86 x86_64
WINDOWS_ARCHS 		= x86 x86_64
MAC_ARCHS 			= x86 x86_64
ANDROID_ARCHS 		= armv7 x86


#### Directories ####
SRCDIR 			= src
LIBDIR 			= lib
INCLUDEDIR 		= include
TESTDIR 		= test
BUILDDIR 		= build
DOCDIR 			= docs
DATADIR 		= data
THIRDPARTYDIR 	= extern

SOURCES = $(shell find $(SRCDIR) -type f -name "*.cpp")
HEADERS = $(shell find $(INCLUDEDIR) -type f)

INCLUDES = -I$(INCLUDEDIR) -I$(SRCDIR) -I$(THIRDPARTYDIR) -I$(FRAMEWORK_PATH)/$(INCLUDEDIR) -I$(FRAMEWORK)/$(THIRDPARTYDIR)
LIBS =  -L. -L$(LIBDIR)/$(SYSTEM) -L$(THIRDPARTYDIR) -L$(FRAMEWORK_PATH)/$(LIBDIR)/$(SYSTEM) -L$(FRAMEWORK_PATH)/$(THIRDPARTYDIR)
#LIBS = SDL2 SDL_image Reflect
#LIBDIRS = $(LIBDIR)/$(SYSTEM) $(THIRDPARTYDIR)
STATICLIBS = -static-libstdc++ -static-libgcc
DEFINES =
CXXFLAGS = -c -fPIC -std=c++11 -Wall -pedantic -pthread -frtti -fexceptions \
			-fvisibility=hidden -fvisibility-inlines-hidden \
			-ffunction-sections -fdata-sections -Wno-format-extra-args
LDFLAGS = -fuse-ld=gold -Wl,--gc-sections,-Bdynamic,-rpath="\$$ORIGIN/$(LIBDIR)/$(SYSTEM)/"
LIBFLAGS = -shared
#-export-dynamic

# VPATHS are searched when a file can't be found by MAKE.
# Example:
#	`src/dir/source.cpp` -> includes -> `src/dir/source.h`
#		`#include "source.h"`
# Generated dependency will be "source.h".
# This file can be found by Make if its directory is within `VPATH`.
VPATH += $(SRCDIR) $(INCLUDEDIR) $(TESTDIR) $(FRAMEWORK_PATH)/$(INCLUDEDIR) $(FRAMEWORK_PATH)/$(THIRDPARTYDIR)



## NOTE These Functions cannot reference variables declared in their scope

## Build Mode Profiles
define TEST_PROFILE_BASE
	SOURCES = $(shell find $(TESTDIR) -type f -name "*.cpp") $(SOURCES)
endef
define RELEASE_PROFILE_BASE
	CXXFLAGS +=
	LDFLAGS +=
	DEFINES += -DNDEBUG 
endef	
define DEBUG_PROFILE_BASE
	APPEND += .debug
	CXXFLAGS += -g
	LDFLAGS += -g
	#-fno-pie
	DEFINES += -DDEBUG
endef

## Target Operating System Profiles
define WINDOWS_PROFILE_BASE
	EXT = .exe
	LIBEXT = .dll
	LIBEXTSTATIC = .lib
	LIBS := -lmingw32 $(LIBS)
	DEFINES += -DWINDOWS -DWIN32
	LIBFLAGS += -Wl,-out-implib,lib$(NAME).dll.a
	ifeq ($(HOST_ARCH),x86)
		CXX = i686-w64-mingw32-g++
		AR = i686-w64-mingw32-ar
	else ifeq ($(HOST_ARCH),x86_64)
		CXX = x86_64-w64-mingw32-g++
		AR = x86_64-w64-mingw32-ar
	endif
endef
define LINUX_PROFILE_BASE
	EXT = 
	LIBEXT = .so
	LIBEXTSTATIC = .a
	LIBS += -ldl
	DEFINES += -DLINUX
	LIBFLAGS += -Wl,-soname,lib$(NAME).so
	CXX = g++
	AR = ar
endef
define MAC_PROFILE_BASE
	EXT = 
	LIBEXT = .dylib
	LIBEXTSTATIC = .a
	LIBS += -ldl
	STATICLIBS = 
	#override CXXFLAGS = -stdlib=libc++
	DEFINES += -DOSX
	override LDFLAGS =
	#override LDFLAGS = -Wl,-L-rpath="\$$ORIGIN/$(LIBDIR)/$(SYSTEM)/"
	#@loader_path
	LIBFLAGS += -dynamiclib -Wl,-install_name,$(FRAMEWORK_PATH)/$(LIBDIR)/$(SYSTEM)/lib$(NAME).dylib
	CXX = g++-5
	AR = ar
endef
define EMSCRIPTEN_PROFILE_BASE
	EXT = 
	LIBS += -ldl
	DEFINES += -DWEB
	LIBFLAGS += -Wl,-soname,lib$(NAME).so
	CXX = em++
endef

## Target Platform Profiles
define X86_PROFILE_BASE
	DEFINES += -DX86
	CXX += -m32
endef
define X86_64_PROFILE_BASE
	DEFINES += -DX86_64
	CXX += -m64
endef
define ARM_PROFILE_BASE
	DEFINES += -DARM
endef

## Compiler Suite Profiles (todo)
## OS, ARCH, COMPILER
define GCC_PROFILE_BASE
	#$(patsubstr -l%,% $(LIBS))
	#$(patsubstr -L%,% $(LIBDIRS))
	#LIBS = LIBDIRS
	#$(patsubstr -D%,% $(DEFINES))
endef

# Override these for Modules within you Project and $(call PROFILE_BASE) to extend sane defaults
TEST_PROFILE 		= $(TEST_PROFILE_BASE)
RELEASE_PROFILE 	= $(RELEASE_PROFILE_BASE)
DEBUG_PROFILE 		= $(DEBUG_PROFILE_BASE)
WINDOWS_PROFILE 	= $(WINDOWS_PROFILE_BASE)
MAC_PROFILE 		= $(MAC_PROFILE_BASE)
LINUX_PROFILE 		= $(LINUX_PROFILE_BASE)
EMSCRIPTEN_PROFILE = $(EMSCRIPTEN_PROFILE_BASE)
X86_PROFILE 		= $(X86_PROFILE_BASE)
X86_64_PROFILE 		= $(X86_64_PROFILE_BASE)
ARM_PROFILE 		= $(ARM_PROFILE_BASE)
GCC_PROFILE 		= $(GCC_PROFILE_BASE)


#### PACKAGING (todo) ####
define LINUX_PACKAGE
endef
define WINDOWS_PACKAGE
endef
define MAC_PACKAGE
endef



#### Documentation ####
# Customize the Doxyfile for greater control.
DOCSET_NAME = $(NAME) Documentation
PUBLISHERNAME := $(NAME)
PUBLISHER_NAMESPACE := $(NAMESPACE)
# Don't document source files with these paths.
HIDE_DOC_WITHIN_PATHS =
# Don't document source files that match these patterns.
# Ex: Pattern: "*/test/*"
HIDE_DOC_WITH_PATTERNS =
# Hide part of the user's include path from the docs.
# Ex: Turn "src/Lib/lib.h" into "/Lib/lib.h"
HIDE_INC_PATH_PREFIX =
# Hide namespace, classes, functions, etc from the docs.
# Ex: "Lib::*Test Lib::Test*"
HIDE_DOC_WITH_SYMBOLS =
# Directory containing images for documentation. Used with image tag.
DOC_IMAGE_DIR =

