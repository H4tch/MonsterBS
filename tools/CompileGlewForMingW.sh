#!/bin/sh

#http://stackoverflow.com/questions/6005076/building-glew-on-windows-with-mingw

# TODO: Add Download script to get the src, extract, etc.
# Maybe create a tool, to create download+compile profiles for libraries.


LIB="lib"

OS="Windows_x86/"
CC_PREFIX="/usr/bin/i686-w64-mingw32-"

$CC_PREFIX"gcc" -DGLEW_NO_GLU -O2 -Wall -W -Iinclude -DGLEW_BUILD -o src/glew.o -c src/glew.c
mkdir -p $LIB/$OS
$CC_PREFIX"gcc" -shared -Wl,-soname,libglew32.dll -Wl,--out-implib,$LIB/$OS/libglew32.dll.a -o $LIB/$OS/glew32.dll src/glew.o -L/mingw/lib -lglu32 -lopengl32 -lgdi32 -luser32 -lkernel32
$CC_PREFIX"ar" cr $LIB/$OS/libglew32.a src/glew.o


OS="Windows_x86_64/"
CC_PREFIX="/usr/bin/x86_64-w64-mingw32-"

$CC_PREFIX"gcc" -DGLEW_NO_GLU -O2 -Wall -W -Iinclude -DGLEW_BUILD -o src/glew.o -c src/glew.c
mkdir -p $LIB/$OS
$CC_PREFIX"gcc" -shared -Wl,-soname,libglew32.dll -Wl,--out-implib,$LIB/$OS/libglew32.dll.a -o $LIB/$OS/glew32.dll src/glew.o -L/mingw/lib -lglu32 -lopengl32 -lgdi32 -luser32 -lkernel32
$CC_PREFIX"ar" cr $LIB/$OS/libglew32.a src/glew.o
