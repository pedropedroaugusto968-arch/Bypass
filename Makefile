TWEAK_NAME = bypassV4

SpaceXitV4_FILES = Tweak.xm
SpaceXitV4_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden
SpaceXitV4_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
