#import <UIKit/UIKit.h>
#import <substrate.h>

// --- FUNÇÃO DE LIMPEZA PROFUNDA ---
void DeepCleanStorage() {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Caminhos principais de rastro
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];

    // Lista de arquivos "dedos-duros" (Rastreadores da Garena)
    NSArray *filesToRemove = @[
        [docPath stringByAppendingPathComponent:@"FFid.txt"],
        [docPath stringByAppendingPathComponent:@"device_id.txt"],
        [docPath stringByAppendingPathComponent:@"client_log.txt"],
        [docPath stringByAppendingPathComponent:@"GarenaSdkLog.txt"],
        [cachePath stringByAppendingPathComponent:@"com.crashlytics.data"],
        [cachePath stringByAppendingPathComponent:@"com.facebook.sdk.AD_PERSISTENCE"],
        [libPath stringByAppendingPathComponent:@"Preferences/com.dts.freefireth.plist"],
        [libPath stringByAppendingPathComponent:@"Application Support/com.apple.TCC"]
    ];

    for (NSString *filePath in filesToRemove) {
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error;
            [fileManager removeItemAtPath:filePath error:&error];
            if (!error) {
                NSLog(@"[Limpeza] Rastro removido com sucesso: %@", [filePath lastPathComponent]);
            }
        }
    }
}

// --- BYPASS DE IDENTIFICAÇÃO (SPOOFER LEVE) ---
%hook UIDevice
- (NSString *)identifierForVendor {
    // Retorna um ID aleatório toda vez para o jogo não marcar o hardware original
    return [[NSUUID UUID] UUIDString];
}
%end

%ctor {
    // Executa a limpeza assim que o app é lançado
    DeepCleanStorage();
    
    // Segunda limpeza após 10 segundos para garantir que arquivos criados no boot sumam
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        DeepCleanStorage();
        NSLog(@"[Limpeza] Segunda varredura concluída. Cliente Protegido.");
    });
}
