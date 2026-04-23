TWEAK_NAME = BypassLimpeza

BypassLimpeza_FILES = Tweak.xm
BypassLimpeza_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden
BypassLimpeza_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
