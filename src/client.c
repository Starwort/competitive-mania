#include "client.h"

int main(int argc, string argv[]) {
    if (SDL_Init(SDL_INIT_AUDIO) < 0) {
        return 1;
    }
    initAudio();

    // todo: stuff

    endAudio();
    return SDL_Quit();
}
