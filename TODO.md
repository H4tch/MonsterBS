
# Todo

### Project.mk
* Improved `Framework` support
	* Mechanism to allow a Framework to override Variables
	* Support for `Standalone` `Modules`
	* Ability for Framework's `Makefile` to generate `Module` projects
	* Support for shared Makefiles, Scripts, Lib installation, etc across Modules
* Improved `Module` support
	* Automated `Api`, `Test`, and Dynamic Module compilation
	* Automated testing
	* Inter-Module dependency Support (Only for Modules within Frameworks?)
* More `RELEASE` build options
	* `-fconserve-space` (saves space in the exe)
	* `-fvisibility=hidden -fvisibility-inlines-hidden`
* More Built Targets
	* Clang compiler (compatible with GCC cli options?)
	* Emscriptem
* [Windows NSIS](http://nsis.sourceforge.net/) installer setup


### Makefile
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


### Install Scripts
* `SHELL = /bin/sh`
* `INSTALL = install`
* `INSTALL_PROGRAM = INSTALL`
* `INSTALL_DATA = $(INSTALL) -m 644`
* `DESTDIR = /usr/share/`



