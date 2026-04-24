#import <UIKit/UIKit.h>
#import <substrate.h>

// --- DECLARAÇÕES OBRIGATÓRIAS (Para o compilador não reclamar) ---
@interface FlexMasterMenu : NSObject
+ (void)abrirPainel;
+ (void)toggleAim:(UIButton *)sender;
+ (void)toggleESP:(UIButton *)sender;
+ (void)fechar;
@end

@interface PlayerController : NSObject
- (void)Update;
- (id)getClosestPlayer;
- (void)lockCameraOnTarget:(id)target;
@end

// Variáveis Globais
static bool aimbotOn = false;
static bool espOn = false;

// --- IMPLEMENTAÇÃO DO MENU ---
@implementation FlexMasterMenu

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 150, 55, 55);
        btn.backgroundColor = [UIColor purpleColor];
        btn.layer.cornerRadius = 27.5;
        [btn setTitle:@"SPACE" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [btn addTarget:self action:@selector(abrirPainel) forControlEvents:UIControlEventTouchUpInside];
        
        // Forma segura de pegar a tela no iOS 15/16/17
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        [window addSubview:btn];
    });
}

+ (void)abrirPainel {
    UIWindow *window = nil;
    for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            window = scene.windows.firstObject;
            break;
        }
    }

    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(window.center.x - 100, window.center.y - 100, 200, 250)];
    panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    panel.layer.cornerRadius = 15;
    panel.tag = 888;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
    title.text = @"SPACE XIT - VICE";
    title.textColor = [UIColor cyanColor];
    title.textAlignment = NSTextAlignmentCenter;
    [panel addSubview:title];

    // Botão Aimbot
    UIButton *aimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aimBtn.frame = CGRectMake(20, 50, 160, 40);
    aimBtn.backgroundColor = [UIColor darkGrayColor];
    [aimBtn setTitle:@"AIMBOT: OFF" forState:UIControlStateNormal];
    [aimBtn addTarget:self action:@selector(toggleAim:) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:aimBtn];

    // Botão ESP
    UIButton *espBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    espBtn.frame = CGRectMake(20, 100, 160, 40);
    espBtn.backgroundColor = [UIColor darkGrayColor];
    [espBtn setTitle:@"ESP: OFF" forState:UIControlStateNormal];
    [espBtn addTarget:self action:@selector(toggleESP:) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:espBtn];

    // Botão Fechar
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(50, 210, 100, 30);
    [close setTitle:@"FECHAR" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(fechar) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:close];

    [window addSubview:panel];
}

+ (void)toggleAim:(UIButton *)sender {
    aimbotOn = !aimbotOn;
    [sender setTitle:aimbotOn ? @"AIMBOT: ON ✅" : @"AIMBOT: OFF" forState:UIControlStateNormal];
    sender.backgroundColor = aimbotOn ? [UIColor greenColor] : [UIColor darkGrayColor];
}

+ (void)toggleESP:(UIButton *)sender {
    espOn = !espOn;
    [sender setTitle:espOn ? @"ESP: ON ✅" : @"ESP: OFF" forState:UIControlStateNormal];
    sender.backgroundColor = espOn ? [UIColor greenColor] : [UIColor darkGrayColor];
}

+ (void)fechar {
    for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
        UIView *p = [scene.windows.firstObject viewWithTag:888];
        [p removeFromSuperview];
    }
}
@end

// --- HOOKS ---
%hook PlayerController
- (void)Update {
    %orig;
    if (aimbotOn) {
        id target = [self getClosestPlayer];
        if (target) [self lockCameraOnTarget:target];
    }
}
%end
