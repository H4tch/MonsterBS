OUTPUT=hello-ndk

#Change your NDK root path
NDK=/home/dan/Downloads/Apps/Google/android-ndk-r7

SYSROOT=$(NDK)/platforms/android-8/arch-arm
NDKINCLUDE=$(SYSROOT)/usr/include
NDKLIB=$(SYSROOT)/usr/lib
GCCLIB=$(NDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/lib/gcc
GCCLIB443=$(NDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/lib/gcc/arm-linux-androideabi/4.4.3
CC=$(NDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-gcc
LD=$(NDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/arm-linux-androideabi/bin/ld

OBJECT=obj/local/armeabi/objs/$(OUTPUT)/$(OUTPUT).o
BINARY=bin/armeabi/$(OUTPUT)

CFLAGS=-MMD -MP -MF ./obj/local/armeabi/objs/$(OUTPUT)/$(OUTPUT).o.d -fpic -ffunction-sections -funwind-tables -fstack-protector -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ -Wno-psabi -march=armv5te -mtune=xscale -msoft-float -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -Ijni -DANDROID -fno-stack-protector -g -O0 -DNDEBUG -g -I$(NDKINCLUDE) -c jni/$(OUTPUT).c 

LFLAGS=--sysroot=$(SYSROOT) --eh-frame-hdr -dynamic-linker /system/bin/linker -X -m armelf_linux_eabi -o $(BINARY) $(NDKLIB)/crtbegin_dynamic.o -L$(GCCLIB443) -L$(GCCLIB) -L$(NDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/arm-linux-androideabi/lib -L$(NDKLIB) -z nocopyreloc ./obj/local/armeabi/objs/$(OUTPUT)/$(OUTPUT).o $(GCCLIB443)/libgcc.a --no-undefined -lstdc++ -llog -lm -lc -lgcc -lc -ldl -lgcc $(NDKLIB)/crtend_android.o

all: createdir $(OUTPUT)

createdir:
	mkdir -p ./obj/local/armeabi/objs/$(OUTPUT)
	mkdir -p ./bin/armeabi

$(OUTPUT): jni/$(OUTPUT).c
	$(CC) $(CFLAGS) -o $(OBJECT)
	$(LD) $(LFLAGS)

clean:
	rm $(OBJECT) $(BINARY)



