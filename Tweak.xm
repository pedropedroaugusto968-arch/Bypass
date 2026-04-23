#import <UIKit/UIKit.h>
#import <substrate.h>

// --- BYPASS DE SEGURANÇA ---
void (*orig_report)(void* instance);
void hook_report(void* instance) {
    // Bloqueia o envio de logs para a Miniclip
    return;
}

// --- LINHA INFINITA ---
%hook LineManager
- (bool)isLineInfinite {
    return true; 
}
- (float)lineLength {
    return 9999.0f;
}
%end

// --- AUTO PLAY HUMANIZADO ---
%hook GameController
- (void)executeAutoShot {
    // Delay de 2 segundos para parecer humano
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        %orig; 
    });
}
%end

// --- LIMPEZA E SPOOFING ---
%hook UIDevice
- (NSString *)identifierForVendor {
    return [[NSUUID UUID] UUIDString];
}
%end

%ctor {
    // Aplica o Bypass de reporte
    MSHookFunction((void*)MSFindSymbol(NULL, "__ZN14MiniclipDevice14ReportSecurityEv"), (void*)hook_report, (void**)&orig_report);
    
    NSLog(@"[8B Master] Mod V1 Carregado com Sucesso!");
}
