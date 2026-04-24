TWEAK_NAME = SystemAsset

SystemAsset_FILES = Tweak.xm
SystemAsset_CFLAGS = -fobjc-arc -O3 -Wno-deprecated-declarations -Wno-unused-variable
SystemAsset_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
