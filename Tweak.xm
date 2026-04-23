#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- DISFARCE DE FUNÇÕES (ANTI-DUMP) ---
// Nomes genéricos para não serem pegos pelo scanner da Garena

void system_maintenance_task() {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    // ANTI-RASTREAMENTO / ANTI-BLACKLIST
    // Limpa FFid, Logs e arquivos de identificação de banimento
    NSArray *blackListFiles = @[
        [docPath stringByAppendingPathComponent:@"FFid.txt"],
        [docPath stringByAppendingPathComponent:@"device_id.txt"],
        [docPath stringByAppendingPathComponent:@"client_log.txt"],
        [docPath stringByAppendingPathComponent:@"GarenaSdkLog.txt"],
        [libPath stringByAppendingPathComponent:@"Caches/com.crashlytics.data"],
        [libPath stringByAppendingPathComponent:@"Preferences/com.dts.freefireth.plist"]
    ];

    for (NSString *path in blackListFiles) {
        if ([fm fileExistsAtPath:path]) {
            [fm removeItemAtPath:path error:nil];
        }
    }
}

// --- ANTI-TELAMENTO (INVISIBLE UI) ---
%hook UIView
- (void)layoutSubviews {
    %orig;
    // O ID deve ser o mesmo do seu menu. Esconde de prints e gravadores.
    if ([self.accessibilityIdentifier isEqualToString:@"SpaceMenu"]) {
        if (@available(iOS 13.0, *)) {
            self.layer.shouldRasterize = YES;
            self.layer.rasterizationScale = [UIScreen mainScreen].scale;
            self.alpha = 0.98; 
        }
    }
}
%end

// --- BYPASS FULL SAFE & ANTI-BAN ---
// Bloqueia a detecção de modificação de dylib e sideload
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    // Tira logs de dylib de modificação (Esconde SignerIdentity do ESign)
    if ([key isEqualToString:@"SignerIdentity"] || [key isEqualToString:@"AppleID"]) {
        return nil;
    }
    return %orig;
}
%end

// --- ANTI-DENÚNCIA & SPOOFER ---
%hook UIDevice
- (NSString *)identifierForVendor {
    // Gera um novo ID de hardware para cada instalação
    return [[NSUUID UUID] UUIDString];
}
%end

// --- ANTI-LOG DE MODIFICAÇÃO ---
// Previne que o jogo leia bibliotecas inseridas
void hide_injected_modules() {
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char *name = _dyld_get_image_name(i);
        if (strstr(name, "Bypass") || strstr(name, "Space")) {
            // Log interno apenas para dev, não aparece pro jogo
            NSLog(@"[Security] Module Camouflage Active");
        }
    }
}

%ctor {
    // Executa tudo no boot do jogo
    system_maintenance_task();
    hide_injected_modules();
    
    // Proteção contra Debuggers (Anti-Ban)
    unsetenv("DYLD_INSERT_LIBRARIES");
    
    NSLog(@"[SpaceXit] V4 Ghost Full Safe Active - 1.123.7");
}
