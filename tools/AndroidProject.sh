#!/bin/sh

# Provide common actions with for android development.

Help ()
{	
	echo "Currently using '"$PROJECT"' as the project directory." \
		 "Change this by modifying the PROJECT environment variable."
	echo
	echo "Usage: $0 [Options]"
	echo "The Options are:"
	echo "  launch		--Launch Android device emulation."
	echo "  build		--Builds the native project using the NDK."
	echo "  install		--Generate a '.apk' from your build directory and installs it through ADB."
	echo "  uninstall	--Uinstalls project from the connected device."
	echo "	help 		--Show this help message"
	exit 1
}

Launch()
{
	#avd
}

Build()
{
	#ant debug
}

Install()
{
	#adb install build/$$NAME.apk
}

Uinstall()
{
	#adb uninstall $$NAMESPACE
}



# Go through the command line arguments.
ARGS=$#
SHIFT_COUNT=0
if [ $ARGS -gt 0 ]; then
	while [ $SHIFT_COUNT -le $ARGS ]; do
		case  $1  in
			"launch")		Launch;;
			"build")		Build;;
			"install")		Install;;
			"uninstall")	Uinstall;;
			*)			Help;;
		esac
		shift ${SHIFT_COUNT}
		SHIFT_COUNT=`expr $SHIFT_COUNT + 1`
	done
else Help
fi
# End argument processing.



