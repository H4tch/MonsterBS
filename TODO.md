
# Todo

For each source file: make source -> SOURCE_PROFILE { defines, flags, etc }
For each dependency, add lib directory, include directory, ...

### Misc
* Hooks for running custom scripts during project generation and build time
* More Release build options
	* `-fconserve-space` (saves space in the exe)
	* `-fvisibility=hidden -fvisibility-inlines-hidden` (hide everything that isn't exposed)
* More Build Targets and Multiple Compiler Suites Support
	* Emscriptem, Android, IOS
* DEFINES, LIBNAMES, LIBDIRS, etc
	* Don't append compiler specific command arguments on definition


### Framework Support
* Combined Documentation Generation (Integration with Hugo Plus?)
	* Build list of directories to include for all modules
	* Or link to external docs:
		* http://www.stack.nl/~dimitri/doxygen/manual/external.html
* Ability to create a Module project within a Framework (clone MBS/Module.mk?)
* Allow every Project to be a Framework?
* NAMESPACE = com.$(FRAMEWORK).$(NAME)


### Module Support
* MK File for Modules generated from Framework.mk settings
* Module compilation infrastructure - `Api`, `Test`, and `module_init`

BIN_EXT, SHARED_EXT, STATIC_EXT

### Makefile
* Move PROFILE_BASE settings into the Makefile?
* COMPILER profiles - GCC, MINGW, CLANG, EMSCRIPTEN
* Improve 'make project' to regenerate a Project's Makefile
* Improve Release build settings
* Doxygen - LAYOUT_FILE?
* [Installation Variables](http://www.gnu.org/software/make/manual/make.html#Directory-Variables)
	* DESTDIR
	* MAKE: test, dist, install, uninstall, prefix, exec-prefix, /usr/local
	* `datarootdir` - /usr/local/share, storeage of architecture independent data
	* `datadir` - typically same as datarootdir
	* `includedir` - /usr/local/include/ where to install header files 
	* `Ability for user to override variables.
* Simpler `SYSTERM` names? - Linux.64, Windows.32, Mac.32
* Make the Zip file(s) a target
	* Each platform has a unique Zip target
	* Target needs `build/$(SYSTEM).release` as a dependency 


### MonsterBS Script
* SDL Installer Script
	* Install from a list of options (apt, source, system)

### Android
* Manually compile programs, don't use the `Ant` build system


### OSX
* Change the install name of compiled third_party library
	* `install_name_tool -id lib/Mac_x86_64/$(FILENAME) $(FILENAME)`
* DYLD_LIBRARY_PATH
* install_name_tool
	* -install_name=@rpath/
	* -id "@loader_path/.."
	* --library-path
* OSX `pkg` or `app` generation
* Mac i386 support with `-m i368`?
* OSX Relative Library Path
	* https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/dyld.1.html
	* `RPATH` environment variable
	* @loader_path/../Library/OpenSource # Relative to ~/Applications folder
	* > gcc -dynamiclib blah.o -install_name @rpath/t/libblah.dylib -o libblah.dylib
		> mkdir t ; mv libblah.dylib t/
		> $ gcc main.c -lblah -L`pwd`/t -Xlinker -rpath -Xlinker `pwd`


### Windows/MingW
* Automatic visiblity: -no-undefined and --enable-runtime-pseudo-reloc
* Need x64, ia32?
* [Windows NSIS](http://nsis.sourceforge.net/) installer setup
* Windows SetDLLDirectory (Desktop Only Function)
	* Only works when using `LoadLibrary`


### Install Setup
* Customized per Build Profile?
* `SHELL = /bin/sh`
* `INSTALL = install`
* `INSTALL_PROGRAM = INSTALL`
* `INSTALL_DATA = $(INSTALL) -m 644`
* `DESTDIR = /usr/share/`

