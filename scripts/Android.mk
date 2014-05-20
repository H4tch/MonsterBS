LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
include $(call all-subdir-makefiles)

# Need to fix LOCAL_PATH here? Can't $(call my-dir)

LOCAL_MODULE := 
LOCAL_MODULE_FILENAME := lib
LOCAL_ARM_MODE := arm

LOCAL_CPP_FEATURES := rtti exceptions
LOCAL_CPPFLAGS := -fPIC -g -c -std=c++11 -Wall -pedantic -pthread -frtti -fexceptions
LOCAL_C_INCLUDES := 

# This matches typically compiler lib flags...
LOCAL_LDLIBS += -L$(LIBDIR) -L$(SRC)/lib -L$(SRC)/Scrutiny/lua/ -llua52 -lGLESv1_CM -llog #-lSDL2_image #-lSDL2_ttf #-lSDL2_mixer
LOCAL_SHARED_LIBRARIES := lua physfs SDL2 SDL2_ttf SDL2_image gnustl_static #SDL2_mixer 
#LOCAL_STATIC_LIBRARIES := lua
LOCAL_EXPORT_CPPFLAGS := -DDATE=123456
# What's the difference with LOCAL...
#LOCAL_EXPORT_LDLIBS

LOCAL_SRC_FILES :=				\
	$(SDL_PATH)/src/main/android/SDL_android_main.c	\
	PRJ_SOURCES


include $(BUILD_SHARED_LIBRARY)


