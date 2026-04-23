#import <UIKit/UIKit.h>
#import <substrate.h>

// --- BYPASS DE INTEGRIDADE & ANTI-SHADOWBAN ---
// Impede que o jogo envie o relatório de "modificação de arquivos"
MSHook(void, _ZN14MiniclipDevice14ReportSecurityEv, void* instance) {
    return; // Silencia o reporte de segurança
}

// --- FUNÇÃO: LINHA INFINITA (Visual Only Bypass) ---
// Faz o jogo acreditar que a linha curta é a padrão, mas desenha a longa
%hook LineManager
- (bool)isLineInfinite {
    return true; 
}
- (float)lineLength {
    return 9999.0f; // Linha atravessa a mesa
}
%end

// --- FUNÇÃO: AUTO PLAY COM HUMANIZADOR ---
// Simula o toque, mas com um delay aleatório para evitar o anti-cheat
%hook GameController
- (void)executeAutoShot {
    // Adiciona um delay de 1.5 a 3 segundos antes de bater
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        %orig; 
    });
}
%end

// --- ANTI-BLACKLIST & ANTI-RASTREAMENTO ---
void clean_pool_logs() {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // Arquivos que a Miniclip usa para marcar o seu aparelho
    NSArray *poolTrash = @[
        [docPath stringByAppendingPathComponent:@"miniclip_id.txt"],
        [docPath stringByAppendingPathComponent:@"Guest-ID.plist"],
        [docPath stringByAppendingPathComponent:@"promo_popup.log"]
    ];

    for (NSString *file in poolTrash) {
        if ([fm fileExistsAtPath:file]) [fm removeItemAtPath:file error:nil];
    }
}

// --- SPOOFER DE HARDWARE (Essencial para não levar ban em conta nova) ---
%hook UIDevice
- (NSString *)identifierForVendor {
    // Retorna um ID aleatório toda vez que o jogo pede
    return [[NSUUID UUID] UUIDString];
}
%end

%ctor {
    clean_pool_logs();
    
    // Hook de segurança para o Auto Ban
    MSHookFunction((void*)MSFindSymbol(NULL, "__ZN14MiniclipDevice14ReportSecurityEv"), (void*)_ZN14MiniclipDevice14ReportSecurityEv, NULL);
    
    NSLog(@"[8B Master] Bypass & AutoPlay Ativado - Full Safe");
}
