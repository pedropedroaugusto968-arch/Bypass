TWEAK_NAME = SpaceLoader

SpaceLoader_FILES = Tweak.xm
# Strip remove os nomes das funções para o anti-cheat não ler "Aimbot" ou "Hack"
SpaceLoader_LDFLAGS = -Wl,-segalign,4000 -Wl,-dead_strip
SpaceLoader_CFLAGS = -fobjc-arc -O3

export ARCHS = arm64
export TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
