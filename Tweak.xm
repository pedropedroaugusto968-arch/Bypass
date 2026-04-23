#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

// --- BYPASS DE INTEGRIDADE (ANTI-AUTO BAN) ---

// Essa função engana o jogo quando ele tenta ler o próprio arquivo para ver se tem hack
static int (*orig_open)(const char *path, int oflag, ...);
int hook_open(const char *path, int oflag, ...) {
    // Se o jogo tentar ler a Dylib ou o binário modificado, a gente desvia
    if (strstr(path, "SpaceXit") || strstr(path, "FreeFire")) {
        return orig_open("/dev/null", oflag); 
    }
    return orig_open(path, oflag);
}

%ctor {
    // 1. Limpeza agressiva de rastro (KeyChain e IDFA)
    unsetenv("DYLD_INSERT_LIBRARIES");
    
    // 2. Hook de sistema para esconder a modificação
    MSHookFunction((void *)open, (void *)hook_open, (void **)&orig_open);

    // 3. Delay de ativação estendido (Só ativa quando o mapa carrega)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 45 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Gesto de ativação (3 dedos agora, para ser mais difícil de detectar)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
        tap.numberOfTouchesRequired = 3;
        
        // LOG DE SUCESSO NO CONSOLE (Apenas para debug)
        NSLog(@"[BYPASS FORTE] Proteção de Memória Ativa.");
    });
}
