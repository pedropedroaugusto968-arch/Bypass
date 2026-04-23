# O nome que você quer para o projeto
TWEAK_NAME = BypassV4

BypassV4_FILES = Tweak.xm
BypassV4_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden
BypassV4_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
