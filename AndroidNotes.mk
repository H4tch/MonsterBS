

## Prepends a delimeter to the include directories.
INCLUDES=$(foreach d, $(INCLUDE_DIRS), -I$d)



#### Android ####


## TODO: Prevent libs from being recompiled. Should I use the PREBUILT* variables?
## Application.mk can specify the optimization levels.

## What is the difference between APP_CPPFLAGS, LOCAL_CPP_FLAGS, LOCAL_CPP_FEATURES


# Determine what Android's makefile build commands are.
strace -f -s 9999 -o android_mk.log ndk-build

include $(LOCAL_PATH)/path/to/dependent/android/makefile
VPATH = search:here:and:here:if:all:else:fails

# Copy Data dir to build target.
$(call copy-one-file, )

# Make LOCAL_SRC_FILES point to the prebuilt library.
PREBUILT_SHARED_LIBRARY
$(call add-prebuilt-files, EXECUTABLES, $(prebuilt_files))


TARGET_ARCH #arm, x86?
# Better to use APP_ABI instead
TARGET_ARCH_ABI #armeabi, armeabi-v7a, x86, mips
TARGET_PLATFORM #android-14 for example


# Use this with include command? It returns the module's Android.mk.
$(call import-module,<name>)



