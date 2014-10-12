# Download, build, and install SDL libraries.
# Make targets:
# 	Linux, Linux32, Linux64
# 	Mac, Mac32, Mac64
# 	MinGW, MinGW32, MinGW64


SDL_LIBS=SDL2 SDL2_image SDL2_ttf SDL2_mixer
SDL_VERSION=2.0

DOWNLOAD_DIR=temp
INSTALL_DIR_32=$(PWD)/temp/SDL2_32
INSTALL_DIR_64=$(PWD)/temp/SDL2_64

SRC_PACKAGES=$(patsubst %, $(DOWNLOAD_DIR)/%-$(SDL_VERSION)-src.tar.gz, $(SDL_LIBS))
WIN_PACKAGES=$(patsubst %, $(DOWNLOAD_DIR)/%-$(SDL_VERSION)-win.tar.gz, $(SDL_LIBS))

SRC_FOLDERS=$(patsubst %.tar.gz, %, $(SRC_PACKAGES))
WIN_FOLDERS=$(patsubst %.tar.gz, %, $(WIN_PACKAGES))

SRC_LIBRARIES_32=$(patsubst %, $(INSTALL_DIR_32)/lib/lib%*.so*, $(SDL_LIBS))
SRC_LIBRARIES_64=$(patsubst %, $(INSTALL_DIR_64)/lib/lib%*.so*, $(SDL_LIBS))

ifeq ($(LIBDIR),)
	LIBDIR=lib
endif

ifeq ($(CORES),)
	CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
endif


all: Linux Mac MinGW

Linux: Linux32 Linux64

Mac: Mac32 Mac64

MinGW: MinGW32 MinGW64


Linux32: run_on_linux #$(SRC_LIBRARIES_32)
	mkdir -p lib/Linux_x86/
	cp -a $(SRC_LIBRARIES_32) $(LIBDIR)/Linux_x86/

Linux64: run_on_linux $(SRC_LIBRARIES_64)
	mkdir -p lib/Linux_x86_64/
	cp -a $(SRC_LIBRARIES_64) $(LIBDIR)/Linux_x86_64/


Mac32: run_on_mac $(SDL_LIBRARIES_32)
	mkdir -p lib/Mac_x86/
	cp -a $(SRC_LIBRARIES_32) $(LIBDIR)/Mac_x86/

Mac64: run_on_mac $(SRC_LIBRARIES_64)
	mkdir -p lib/Mac_x86_64/
	cp -a $(SRC_LIBRARIES_64) $(LIBDIR)/Mac_x86_64/


MinGW32: $(WIN_FOLDERS)
	mkdir -p $(LIBDIR)/Windows_x86/
	-@cp -a -u $(DOWNLOAD_DIR)/*-win/i686-w64-mingw32/bin/*.dll $(LIBDIR)/Windows_x86/ 2> /dev/null
	-@cp -a -u $(DOWNLOAD_DIR)/*-win/i686-w64-mingw32/bin/LICENSE* $(LIBDIR)/Windows_x86/ 2> /dev/null

MinGW64: $(WIN_FOLDERS)
	mkdir -p $(LIBDIR)/Windows_x86_64/
	-@cp -a -u $(DOWNLOAD_DIR)/*-win/x86_64-w64-mingw32/bin/*.dll $(LIBDIR)/Windows_x86_64/ 2> /dev/null
	-@cp -a -u $(DOWNLOAD_DIR)/*-win/x86_64-w64-mingw32/bin/LICENSE* $(LIBDIR)/Windows_x86_64/ 2> /dev/null

init:
	mkdir -p $(DOWNLOAD_DIR)


$(SRC_LIBRARIES_32): $(SRC_FOLDERS)
	mkdir -p $(INSTALL_DIR_32)
	mkdir -p $(INSTALL_DIR_32)/lib/
	REMOVE_PATH=`echo "$(INSTALL_DIR_32)/lib/lib"`; \
	SDL_LIB=`echo $@ | sed -e s^$$REMOVE_PATH^^g -e 's/.so//g'`; \
	SDL_LIB=$$SDL_LIB"-$(SDL_VERSION)-src"; \
	cd $(DOWNLOAD_DIR)/$$SDL_LIB/; \
	export PATH=$(INSTALL_DIR_32)/bin:$(PATH); \
	export PKG_CONFIG_PATH=$(INSTALL_DIR_32)/pkgconfig; \
	export LD_LIBRARY_PATH=$(INSTALL_DIR_32)/lib; \
	./autogen.sh; \
	./configure --prefix=$(INSTALL_DIR_32); \
	make -j$(CORES); \
	make install;


$(SRC_LIBRARIES_64): $(SRC_FOLDERS)
	mkdir -p $(INSTALL_DIR_64)
	mkdir -p $(INSTALL_DIR_64)/lib/
	REMOVE_PATH=`echo "$(INSTALL_DIR_64)/lib/lib"`; \
	SDL_LIB=`echo $@ | sed -e s^$$REMOVE_PATH^^g -e 's/.so//g'`; \
	SDL_LIB=$$SDL_LIB"-$(SDL_VERSION)-src"; \
	echo $$SDL_LIB; \
	cd $(DOWNLOAD_DIR)/$$SDL_LIB/; \
	export PATH=$(INSTALL_DIR_64)/bin:$(PATH); \
	export PKG_CONFIG_PATH=$(INSTALL_DIR_64)/pkgconfig; \
	export LD_LIBRARY_PATH=$(INSTALL_DIR_64)/lib; \
	./autogen.sh; \
	./configure --prefix=$(INSTALL_DIR_64); \
	make -j$(CORES); \
	make install;


$(SRC_FOLDERS): $(SRC_PACKAGES)
	echo $@
	mkdir -p $@
	rm -rf $@/*
	tar -xzf $@.tar.gz -C $@
	mv $@/*/* $@/


$(WIN_FOLDERS): $(WIN_PACKAGES)
	echo $@
	mkdir -p $@
	rm -rf $@/*
	tar -xzf $@.tar.gz -C $@
	mv $@/*/* $@/


$(DOWNLOAD_DIR)/SDL2-$(SDL_VERSION)-src.tar.gz: init
	wget -c http://www.libsdl.org/release/SDL2-2.0.3.tar.gz -O $@

$(DOWNLOAD_DIR)/SDL2_image-$(SDL_VERSION)-src.tar.gz:
	wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz -O $@
	
$(DOWNLOAD_DIR)/SDL2_ttf-$(SDL_VERSION)-src.tar.gz:
	wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz -O $@
	
$(DOWNLOAD_DIR)/SDL2_mixer-$(SDL_VERSION)-src.tar.gz:
	wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz -O $@


$(DOWNLOAD_DIR)/SDL2-$(SDL_VERSION)-win.tar.gz: init
	wget -c http://www.libsdl.org/release/SDL2-devel-2.0.3-mingw.tar.gz -O $@

$(DOWNLOAD_DIR)/SDL2_image-$(SDL_VERSION)-win.tar.gz:
	wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.0-mingw.tar.gz -O $@
	
$(DOWNLOAD_DIR)/SDL2_ttf-$(SDL_VERSION)-win.tar.gz:
	wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.12-mingw.tar.gz -O $@
	
$(DOWNLOAD_DIR)/SDL2_mixer-$(SDL_VERSION)-win.tar.gz:
	wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.0-mingw.tar.gz -O $@

# What is for??
run_on_linux:
	OS=`uname -s` && if [ "$$OS" != "Linux" ]; then false; fi 


run_on_mac:
	OS=`uname -s` && if [ "$$OS" != "Darwin" ]; then false; fi 


.PHONY: all
.PHONY: Linux Linux32 Linux64
.PHONY: Mac Mac32 Mac64
.PHONY: Windows Windows32 Windows64 
.PHONY: init
#.PHONY: setup_build


