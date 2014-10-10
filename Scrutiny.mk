#### Metadata ####

NAME = Scrutiny
# Used for Android project, Doxygen, etc. Should be a reverse domain name.
NAMESPACE = com.$(NAME).app
# Don't include extension.
FILENAME = $(NAME)
VERSION = 1.0
ICON = icon.png
DESCRIPTION = Reflection and generic layer on top of C++ for creating more dynamic applications.
PROJECT_TYPE = Library
MODULES =
CATEGORIES = Game;ActionGame;RolePlaying
RUN_IN_TERMINAL = false

# Install this Cpp Project Generator into the source tree of your project to
# tweak the install later?
INSTALL_CPPPROJECTBUILDER = 1


#### Directories ####
# TODO: Change to project's name??
SRCDIR = Scrutiny
LIBDIR = lib
# Where to look for installed platform specific libraries. Possible to use BITS.(only in Makefile) 
#PLATFORM_LIBDIR=$(LIBDIR)/$(OS)"_"$(ARCH)
# Place where the main '.h' source files are.
#PROJ_INCLUDEDIR=$(SRCDIR)/include
# TODO What is this good for?? Compiliation vs Installation...What if PROJECT_TYPE == Library?
INCLUDEDIR = include
BUILDDIR = build
DOCDIR = doc
DATADIR = data 
THIRDPARTYDIR = third_party
SCRIPTDIR = tools



#### Source files ####

# TODO: Should the umbrella project have source files??
SOURCES = $(SRCDIR)/Reflect.cpp \
		$(SRCDIR)/test/Test.cpp $(SRCDIR)/test/CoroutineTest.cpp \
		$(SRCDIR)/test/LuaBindingTest.cpp $(SRCDIR)/test/ReflectionTest.cpp \
		$(SRCDIR)/test/EnumTest.cpp $(SRCDIR)/test/AllocatorTest.cpp \
		$(SRCDIR)/test/ValueTest.cpp $(SRCDIR)/test/SumTypeTest.cpp \
		$(SRCDIR)/test/RuleTest.cpp

#### Build Settings ####

# MingW32, automatic visiblity: -no-undefined and --enable-runtime-pseudo-reloc

INCLUDES = -I$(INCLUDEDIR) -I$(SRCDIR) -I$(THIRDPARTYDIR)
## Note, in some cases, the order of libs do matter.
LIBS = -L$(LIBDIR)/$(SYSTEM) -L$(THIRDPARTYDIR) -L$(LIBDIR)/$(lua) -llua52
STATICLIBS = -static-libstdc++ -static-libgcc

DEFINES = -DLUA_VM -DSCRUTINY_TEST -DSCRUTINY_STANDALONE
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
# Not supported yet.
BUILD_FOR_ANDROID_ARM=0
BUILD_FOR_ANDROID_X86=0


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



