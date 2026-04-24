TWEAK_NAME = SpaceLoader

SpaceLoader_FILES = Tweak.xm
# Flags de otimização máxima para esconder o código
SpaceLoader_CFLAGS = -fobjc-arc -O3 -Wno-deprecated-declarations
SpaceLoader_LDFLAGS = -Wl,-segalign,4000

export ARCHS = arm64
export TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
