TWEAK_NAME = PoolModV1

PoolModV1_FILES = Tweak.xm
PoolModV1_CFLAGS = -fobjc-arc -O3
PoolModV1_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
