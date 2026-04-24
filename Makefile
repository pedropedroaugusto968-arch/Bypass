# Nome que vai aparecer no arquivo final (ex: SystemAsset.dylib)
TWEAK_NAME = SystemAsset

SystemAsset_FILES = Tweak.xm
SystemAsset_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden
SystemAsset_LDFLAGS = -Wl,-segalign,4000

# Arquitetura para iPhones modernos (arm64)
export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
