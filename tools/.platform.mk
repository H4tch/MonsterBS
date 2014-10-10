

SYSTEM = $(OS)_$(ARCH)

ifeq ($(PROCESSOR_ARCHITECTURE),)
	HOST_OS = $(shell uname -s)
	HOST_ARCH = $(shell uname -m)
else
	# NOTE: WINDOWS ARCH VALUES CAN BE: AMD64 IA64 x86
	ifneq ($(PROCESSOR_ARCHITEW6432),)
		PROCESSOR_ARCHITECTURE = $(PROCESSOR_ARCHITEW6432)
	endif
	HOST_OS = Windows
	HOST_ARCH := PROCESSOR_ARCHITECTURE
	ifeq ($(HOST_ARCH),IA64)
		HOST_ARCH := x86_64
	else ifeq ($(HOST_ARCH),AMD64)
		HOST_ARCH := x86_64
	endif
endif


ifeq ($(OS),)
	OS := $(HOST_OS)
endif

ifeq ($(OS),Windows_NT)
	OS := Windows
endif

ifeq ($(OS), Linux)
else ifeq ($(OS), Darwin)
	OS = Mac
else # Unix
	OS = Linux
endif


ifeq ($(ARCH),)
	ARCH := $(HOST_ARCH)
endif


# If not on Windows. Use more advanced methods to fixup ARCH using `filter`.
ifneq ($(HOST_OS),Windows)
#ifeq ($(PROCESSOR_ARCHITECTURE),)
	ifneq ($(filter x86_64%,$(ARCH)),)
		ARCH := x86_64
	else ifneq ($(filter %86,$(ARCH)),)
		ARCH := x86
	else ifneq ($(filter %arm,$(ARCH)),)
		ARCH := arm
	else ifneq ($(filter arm%,$(ARCH)),)
		ARCH := arm
	else ifneq ($(filter %ARM,$(ARCH)),)
		ARCH := arm
	else ifneq ($(filter ARM%,$(ARCH)),)
		ARCH := arm
	endif
endif

# Catch other possible ARCH values and correct it. 
#sed 's/x86_//;s/i[3-6]86/x86/'
ifeq ($(ARCH),ia32)
	ARCH := x86
else ifeq ($(ARCH),IA32)
	ARCH := x86
else ifeq ($(ARCH),ia64)
	ARCH := x86_64
else ifeq ($(ARCH),IA64)
	ARCH := x86_64
else ifeq ($(ARCH),amd64)
	ARCH := x86_64
else ifeq ($(ARCH),AMD64)
	ARCH := x86_64
else ifeq ($(ARCH),x64)
	ARCH := x86_64
else ifeq ($(ARCH),ARM)
	ARCH := arm
endif


ifeq ($(ARCH),x86_64)
	BITS = 64
else ifeq ($(ARCH),x86)
	BITS = 32
else ifeq ($(ARCH),arm)
	BITS = 32
endif
#### DONE SETTING UP ARCH ####


