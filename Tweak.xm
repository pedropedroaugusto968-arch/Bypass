#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>

// Função para checar se o Anti-Cheat está vigiando
bool estaSendoVigiado() {
    // Se o jogo tentar ver as bibliotecas carregadas, a gente retorna falso
    return false; 
}

%ctor {
    // Espera o jogo estabilizar para não dar crash na abertura
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // O segredo está aqui: o caminho para a sua dylib de hack real
        // Ela deve estar na pasta Frameworks com esse nome
        NSString *dylibPath = [[NSBundle mainBundle] pathForResource:@"SpaceXit" ofType:@"dylib" inDirectory:@"Frameworks"];
        
        if (dylibPath) {
            // RTLD_NOW | RTLD_GLOBAL faz a dylib entrar direto na memória
            void *handle = dlopen([dylibPath UTF8String], RTLD_NOW);
            
            if (handle) {
                NSLog(@"[SpaceLoader] Hack injetado com sucesso e oculto!");
            } else {
                NSLog(@"[SpaceLoader] Erro ao injetar: %s", dlerror());
            }
        }
    });
}

// Hook para esconder a modificação do Anti-Cheat do Vice Online
%hook NSBundle
- (id)objectForInfoDictionaryKey:(NSString *)key {
    if ([key isEqualToString:@"SignerIdentity"]) {
        return nil; // Esconde que o app foi assinado por ESign/GBox
    }
    return %orig;
}
%end
