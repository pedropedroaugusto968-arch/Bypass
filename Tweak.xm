#import <UIKit/UIKit.h>
#import <substrate.h>

static bool aimbotOn = false, espOn = false, godModeOn = false;

// --- ESTRUTURAS PARA O SPAWN E ARMAS ---
@interface GameServer : NSObject
+ (void)spawnVehicle:(NSString *)modelName atPosition:(CGPoint)pos;
+ (void)giveWeaponToPlayer:(int)weaponID;
@end

@interface WeaponManager : NSObject
- (bool)hasWeaponUnlocked:(int)id;
@end

// --- 🔓 UNLOCKER DE ARMAS (TER TUDO GRÁTIS) ---
%hook WeaponManager
- (bool)hasWeaponUnlocked:(int)id {
    return true; // Diz que você já comprou/liberou todas as armas
}
- (int)getWeaponPrice:(int)id {
    return 0; // Se o jogo checar preço, retorna zero
}
%end

// --- 🏎️ FUNÇÃO DE SPAWN (LOGICA) ---
void spawnCarroNinja() {
    // Exemplo: Spawna o carro "Sport_01" na frente do jogador
    // [GameServer spawnVehicle:@"Supra_Custom" atPosition:CGPointMake(0,0)];
    NSLog(@"[FlexCity] Comando de Spawn enviado!");
}

// --- 📦 ESP (DESENHAR CAIXAS) ---
%hook PlayerRenderer
- (void)renderESP {
    if (espOn) {
        // Lógica de desenho de Overlay (Bounding Box)
    }
    %orig;
}
%end

// --- 📱 PAINEL ATUALIZADO COM SPAWN ---
@implementation FlexMasterMenu

+ (void)abrirPainel {
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(window.center.x - 110, window.center.y - 150, 220, 320)];
    panel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
    panel.layer.cornerRadius = 20;
    panel.layer.borderWidth = 1;
    panel.layer.borderColor = [UIColor purpleColor].CGColor;
    panel.tag = 888;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 220, 30)];
    title.text = @"SPACE XIT - VICE ONLINE";
    title.textColor = [UIColor cyanColor];
    title.textAlignment = NSTextAlignmentCenter;
    [panel addSubview:title];

    // Botões de Toggle (Aimbot, ESP, God)
    [self addToggle:@"AIMBOT" y:50 tag:1 view:panel action:@selector(toggleAim:)];
    [self addToggle:@"ESP BOX" y:90 tag:2 view:panel action:@selector(toggleESP:)];
    
    // Botão Especial: UNLOCK ALL WEAPONS
    UIButton *unlBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    unlBtn.frame = CGRectMake(20, 130, 180, 35);
    unlBtn.backgroundColor = [UIColor orangeColor];
    [unlBtn setTitle:@"LIBERAR TODAS ARMAS" forState:UIControlStateNormal];
    [unlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unlBtn.layer.cornerRadius = 5;
    [panel addSubview:unlBtn];

    // Botão de SPAWN CARRO
    UIButton *spawnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    spawnBtn.frame = CGRectMake(20, 175, 180, 35);
    spawnBtn.backgroundColor = [UIColor blueColor];
    [spawnBtn setTitle:@"SPAWN: CARRO LUXO" forState:UIControlStateNormal];
    [spawnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [spawnBtn addTarget:self action:@selector(spawnCar) forControlEvents:UIControlEventTouchUpInside];
    spawnBtn.layer.cornerRadius = 5;
    [panel addSubview:spawnBtn];

    // Botão Fechar
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(60, 280, 100, 30);
    [close setTitle:@"[ ESCONDER ]" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(fechar) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:close];

    [window addSubview:panel];
}

+ (void)addToggle:(NSString *)name y:(float)y tag:(int)tag view:(UIView *)v action:(SEL)sel {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(20, y, 180, 35);
    b.backgroundColor = [UIColor darkGrayColor];
    b.layer.cornerRadius = 5;
    [b setTitle:[NSString stringWithFormat:@"%@: OFF", name] forState:UIControlStateNormal];
    [b addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b];
}

+ (void)spawnCar {
    spawnCarroNinja();
}

+ (void)fechar {
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    [[window viewWithTag:888] removeFromSuperview];
}

@end
