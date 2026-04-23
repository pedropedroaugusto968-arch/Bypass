TWEAK_NAME = AntiAutoBanSpace

AntiAutoBanSpace_FILES = Tweak.xm
# O3 e fvisibility=hidden escondem as funções do seu código
AntiAutoBanSpace_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden
AntiAutoBanSpace_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
