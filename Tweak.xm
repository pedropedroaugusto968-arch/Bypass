#import <UIKit/UIKit.h>
#import <substrate.h>

// Variáveis do Painel
bool hackAtivo = false;
float aimbotFOV = 150.0f; // 0 a 500
UIButton *menuButton;

// --- INTERFACE DO PAINEL (Overlay para você) ---
void criarPainel() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        // Botão flutuante que SÓ VOCÊ VÊ
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(100, 100, 50, 50);
        menuButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        menuButton.layer.cornerRadius = 25;
        [menuButton setTitle:@"S2" forState:UIControlStateNormal];
        
        // Ação de ligar/desligar
        [menuButton addTarget:self action:@selector(toggleHack) forControlEvents:UIControlEventTouchUpInside];
        
        [window addSubview:menuButton];
    });
}

// --- LOGICA LIGA/DESLIGA ---
void toggleHack() {
    hackAtivo = !hackAtivo;
    NSLog(@"[StandoffGhost] Hack %@", hackAtivo ? @"ON" : @"OFF");
}

// --- TOTAL BYPASS (Invisibilidade para o Anti-Cheat) ---
// Esconde os hooks para o Scanner do jogo não achar modificações
MSHook(void, _ZN10AxleboltOS14SecurityCheckEv, void* instance) {
    return; // Engana o verificador de integridade
}

// --- AIMBOT COM FOV ---
%hook PlayerController
- (void)updateAimbot {
    if (hackAtivo) {
        float dist = [self getDistanceToNearestEnemy];
        if (dist <= aimbotFOV) {
            [self lockOnTarget];
        }
    }
    %orig;
}
%end

// --- ANTI-SHADOWBAN (SPOOFER) ---
%hook UIDevice
- (NSString *)identifierForVendor {
    return [[NSUUID UUID] UUIDString]; // Muda o ID do celular
}
%end

%ctor {
    // Injeta o bypass silencioso
    void* securitySym = (void*)MSFindSymbol(NULL, "__ZN10AxleboltOS14SecurityCheckEv");
    if (securitySym) {
        MSHookFunction(securitySym, (void*)_ZN10AxleboltOS14SecurityCheckEv, NULL);
    }
    
    // Cria o menu na tela do usuário
    criarPainel();
    
    NSLog(@"[StandoffGhost] Painel e Bypass Carregados!");
}
