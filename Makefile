TWEAK_NAME = BypassLimpeza
BypassLimpeza_FILES = Tweak.xm
BypassLimpeza_CFLAGS = -fobjc-arc -O3
include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
