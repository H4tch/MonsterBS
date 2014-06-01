#!/bin/sh

# What does this actually do??
# It generates header dependencies for objects, and stores them in a ".d' file.
# make dependencies
# 	for each source file
#	run g++ command and store result in depend file
# make each object dependent on the depend file, so if it changes, it will be
# recompiled. Can it work like this? If a header changes, the depency thing
# will be updated, which in turn will recompile the object file.
# What is suppose to happen is that the g++ command will generate makefile
# dependency rules for each source. This will then be tacked onto the end of
# the Makefile.


DIR="$1"
shift 1
case "$DIR" in
"" | ".")
	g++ -std=c++11 -MM -MG "$@" | sed -e "s@ˆ\(.*\)\.o:@\1.d \1.o:@"
	;;
*)
	g++ -std=c++11 -MM -MG "$@" | sed -e "s@ˆ\(.*\)\.o:@$DIR/\1.d $DIR/\1.o:@"
	;;
esac

