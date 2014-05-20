#!/bin/sh

# Needs to be run within the Project's root directory.

Path=$PWD

exec echo -e -n "[Desktop Entry]\\nName=$$NAME\\nVersion=$$VERSION\\nType=Application\\nPath=$Path\\nExec=./"'$$FILENAME.sh'"\\nIcon=$$ICON\\nCategories=$$CATEGORIES\\nComment=$$DESCRIPTION\\nKeywords=$$KEYWORDS\\nStartupNotify=false\\nTerminal=$$RUN_IN_TERMINAL\\nEncoding=UTF-8\\nDBusActivatable=false" > $$FILENAME.desktop



