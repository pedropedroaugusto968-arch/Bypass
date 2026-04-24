#import <UIKit/UIKit.h>
#import <substrate.h>

// Declarações para o compilador não se perder
@interface PlayerController : NSObject
- (float)getDistanceToNearestEnemy;
- (void)lockOnTarget;
@end

// Variáveis de controle
static bool hackAtivo = false;
static float aimbotFOV = 150.0f;

// --- FUNÇÃO DO BYPASS (DECLARAÇÃO CORRETA) ---
void hook_security(void* instance) {
    return;
}

// --- INTERFACE DO MENU (VERSÃO MODERNA) ---
@interface StandoffMenu : NSObject
+ (void)showMenu;
@end

@implementation StandoffMenu
+ (void)showMenu {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Pega a tela da forma que o iOS 13+ exige
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = ((UIWindowScene*)scene).windows.firstObject;
                    break;
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 150, 50, 50);
        btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        btn.layer.cornerRadius = 25;
        [btn setTitle:@"S2" forState:UIControlStateNormal];
        
        // Cor do botão muda para avisar se está ligado ou desligado
        [btn addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:btn];
    });
}

+ (void)toggle:(UIButton*)sender {
    hackAtivo = !hackAtivo;
    sender.backgroundColor = hackAtivo ? [[UIColor redColor] colorWithAlphaComponent:0.7] : [[UIColor blackColor] colorWithAlphaComponent:0.7];
}
@end

// --- HOOKS DO JOGO ---
%hook PlayerController
- (void)update { // Supondo que 'update' seja o loop do jogo
    %orig;
    if (hackAtivo) {
        float dist = [self getDistanceToNearestEnemy];
        if (dist <= aimbotFOV) {
            [self lockOnTarget];
        }
    }
}
%end

%hook UIDevice
- (NSString *)identifierForVendor {
    return [[NSUUID UUID] UUIDString];
}
%end

// --- INICIALIZAÇÃO ---
%ctor {
    // Bypass de Segurança
    void* securitySym = (void*)MSFindSymbol(NULL, "__ZN10AxleboltOS14SecurityCheckEv");
    if (securitySym) {
        MSHookFunction(securitySym, (void*)hook_security, NULL);
    }

    // Carrega o menu
    [StandoffMenu showMenu];
    
    NSLog(@"[StandoffGhost] Rodando com Sucesso!");
}
