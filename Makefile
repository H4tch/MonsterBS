## Makefile to build the project using the ProjectName.mk file.

MONSTERBS_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MONSTERBS_PATH := $(patsubst $(PWD)/%/,%,$(dir $(MONSTERBS_PATH)))
ifeq ($(MONSTERBS_PATH), $(PWD)/)
	MONSTERBS_PATH = .
endif

PROJECT := $(MAKECMDGOALS)
-include $(PROJECT).mk
export


all:
	@echo "Please specify the name of the Project you would like to generate."

$(PROJECT): %: %.mk MonsterBS.sh
	$(MONSTERBS_PATH)/MonsterBS.sh
	-@ #if [ "$(PROJECT_TYPE)" = "Framework" ]; then \
	#	$(foreach MODULE, $(MODULES), $(MAKE) $(MODULE); ); \
	#fi

$(FILES):
	echo "File: $@"

.PHONY: all

