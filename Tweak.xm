#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- DISFARCE DE FUNÇÕES (ANTI-DUMP) ---

void sys_security_check() {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *lp = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray *r = @[
        [dp stringByAppendingPathComponent:@"FFid.txt"],
        [dp stringByAppendingPathComponent:@"client_log.txt"],
        [lp stringByAppendingPathComponent:@"Caches/com.crashlytics.data"]
    ];

    for (NSString *path in r) {
        if ([fm fileExistsAtPath:path]) {
            [fm removeItemAtPath:path error:nil];
        }
    }
}

// ANTI-TELAMENTO (Invisible UI)
%hook UIView
- (void)layoutSubviews {
    %orig;
    if ([self.accessibilityIdentifier isEqualToString:@"SpaceMenu"]) {
        // Se o iOS detectar captura, essa layer não é renderizada no vídeo
        self.layer.shouldRasterize = YES;
        if (@available(iOS 13.0, *)) {
            self.alpha = 0.99; // Pequena alteração que buga gravadores simples
        }
    }
}
%end

// ANTI-DENÚNCIA E OCULTAÇÃO DE ASSINATURA
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"SignerIdentity"]) return nil;
    return %orig;
}
%end

// BYPASS DE HARDWARE (ID ALEATÓRIO)
%hook UIDevice
- (NSString *)identifierForVendor {
    return [[NSUUID UUID] UUIDString];
}
%end

%ctor {
    // Inicia limpeza profunda
    sys_security_check();
    
    // Bloqueia logs de erro
    unsetenv("DYLD_INSERT_LIBRARIES");
    
    NSLog(@"[SpaceXit] V4 Ghost Active");
}
