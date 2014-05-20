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
