## Monster Build System  -  https://www.github.com/h4tch/MonsterBS
## MIT Licensed 2014-2015
## Created by: Daniel Hatch <h4tch.github.com>
##
## MonsterBS Project Generation Makefile.
## Executes `MonsterBS.sh` and builds your project from your 'PROJECT.mk' file.
## Copy `Project.mk` and name it to your PROJECT_NAME.
## Customize its settings to configure your project.
## Type `make PROJECT_NAME` to generate your project.
##

MONSTERBS_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

PROJECT := $(MAKECMDGOALS)
ifeq ($(PROJECT),Project)
	-include Project.mk
	export
endif

-include $(PROJECT).mk
export


all:
	@echo $(MONSTERBS_PATH)
	@echo "Please specify the name of the Project you would like to generate."

$(PROJECT): %: %.mk $(MONSTERBS_PATH)/MonsterBS.sh
	$(MONSTERBS_PATH)/MonsterBS.sh

$(MONSTERBS_PATH)/MonsterBS.sh:
	

.PHONY: all
# Allows you to `make print-VARIABLE`
print-%: ; @echo $*=$($*)
