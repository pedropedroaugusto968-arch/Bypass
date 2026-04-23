TWEAK_NAME = BypassLimpeza

# Se o seu arquivo no GitHub se chamar Tweak.xm, deixe assim:
BypassLimpeza_FILES = Tweak.xm
BypassLimpeza_CFLAGS = -fobjc-arc -O3

export ARCHS = arm64
# Usando o SDK que clonamos no main.yml
export TARGET = iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
