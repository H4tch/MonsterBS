#!/bin/sh

echo "This will add symbolic links to your /lib/i386-linux-gnu/ directory" \
	"so the linker will correctly detect them."

cd /usr/lib/i386-linux-gnu/

if test $? -ne 0
	then echo "Couldn't find '/usr/lib/i386-linux-gnu/' directory."
	exit 1
fi

sudo ln -s libSDL2-2.0.so.0 libSDL2.so
sudo ln -s libSDL2_image-2.0.so.0 libSDL2_image.so
sudo ln -s libSDL2_ttf-2.0.so.0 libSDL2_ttf.so
sudo ln -s libSDL2_mixer-2.0.so.0 libSDL2_mixer.so


cd mesa
if test $? -eq 0
	cd ../
	sudo ln -s mesa/libGL.so.1 mesa/libGL.so
	sudo ln -s mesa/libGL.so.1 libGL.so
	exit 0
fi

cd nvidia*
if test $? -eq 0
	sudo ln -s nvidia*/libGL.so libGL.so
	exit 0
fi

cd fglr*
if test $? -eq 0
	sudo ln -s fglr*/libGL.so libGL.so
	exit 0
fi

echo "Couldn't find OpenGL library(Mesa, Nvidia, or Fglrx) to fix."
exit 1


