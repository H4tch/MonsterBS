# MonsterBS
--------------------

The Monster Build System collection of scripts that make it painless to create, support, and 
customize a C++ project from a single control file.


#### Features
* Cross-platform/compiler support.
* Easily customizable build profiles for:
	* Debug and Release builds.
	* OS: Windows, Linux, and Mac.
	* Arch: x86 and x86_64.
* Out of source tree compile output.
* Reverse header dependency generation.
* Static/Shared Library creation.
* Documentation generation.
* Re-generation of Project's settings from Makefile.
* Packaging of release builds.
* Bat script to launch compiled Windows Application.
* Shell script to launch Linux/Mac Application.
* FreeDesktop.org's ".desktop" file generation/installation for Unix platforms.
* LinesOfCode calculation script with cloc-1.60.pl.


## Getting Started
Make a copy of the 'Project.mk' file and re-name it.
Open it up to begin customizing it for your project.
Set the Project's metadata: name, version, type, description, icon, etc.
Customize the directories used within the project.
Set the C++ source files that are to be compiled.
Tweak the includes, libraries, compiler commands, linker commands, etc for
	your target platforms and build types.
Generate your project using Make:
	make project_name
This will output your project into a folder with the same name as your project.


#### Created by Dan H4tch

