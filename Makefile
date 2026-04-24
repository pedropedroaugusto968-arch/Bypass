TWEAK_NAME = SpaceXit

SpaceXit_FILES = Tweak.xm
SpaceXit_FRAMEWORKS = UIKit QuartzCore CoreGraphics
# Ignora os erros de 'deprecated' e 'root-class' das suas imagens
SpaceXit_CFLAGS = -fobjc-arc -O3 -Wno-deprecated-declarations -Wno-error=objc-root-class -Wno-unused-variable

export ARCHS = arm64
export TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
