#include "client.h"

int main(__attribute__((unused)) int argc, __attribute__((unused)) string argv[]) {
    if (SDL_Init(SDL_INIT_AUDIO) < 0) {
        return 1;
    }
    initAudio();

    // todo: stuff

    endAudio();
    SDL_Quit();
    return 0;
}
