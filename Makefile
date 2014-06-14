## Makefile to build the project using the ProjectName.mk file.

CPPBUILDER_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CPPBUILDER_PATH := $(patsubst $(PWD)/%/,%,$(dir $(CPPBUILDER_PATH)))
ifeq ($(CPPBUILDER_PATH), $(PWD)/)
	CPPBUILDER_PATH = .
endif

PROJECT := $(MAKECMDGOALS)
-include $(PROJECT).mk
export


all:
	@echo "Please specify the name of the Project you would like to generate."

$(PROJECT): %: %.mk
	$(CPPBUILDER_PATH)/CppProjectBuilder.sh
	-@ #if [ "$(PROJECT_TYPE)" = "Framework" ]; then \
	#	$(foreach MODULE, $(MODULES), $(MAKE) $(MODULE); ); \
	#fi

$(FILES):
	echo "File: $@"


.PHONY: all

