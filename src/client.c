#include "client.h"

int main(int argc, string argv[]) {
    printfln("%d %s", argc, argv[0]);
    /* Initialize only SDL Audio on default device */
    if (SDL_Init(SDL_INIT_AUDIO) < 0) {
        return 1;
    }
    println("Initialised SDL2 successfully");

    /* Init Simple-SDL2-Audio */
    initAudio();
    println("Initialised Simple-SDL2-Audio successfully");

    /* Play music and a sound */
    playMusic("assets/music/highlands.wav", SDL_MIX_MAXVOLUME);
    println("Started music");
    playSound("assets/sfx/door1.wav", SDL_MIX_MAXVOLUME / 2);
    println("Started sound");

    /* While using delay for showcase, don't actually do this in your project */
    SDL_Delay(1000);

    /* Override music, play another sound */
    playMusic("assets/music/road.wav", SDL_MIX_MAXVOLUME - 1);
    println("Changed music");
    SDL_Delay(5000);

    /* Pause audio test */
    pauseAudio();
    println("Paused all audio");
    SDL_Delay(1000);
    unpauseAudio();
    println("Resumed audio");

    // playSound("assets/sfx/door2.wav", SDL_MIX_MAXVOLUME / 2);
    playSound("assets/sfx/door2.wav", SDL_MIX_MAXVOLUME / 2);
    println("Played sound effect");
    SDL_Delay(2000);

    /* Caching sound example, create, play from Memory, clear */

    Audio* sound = createAudio("assets/sfx/door1.wav", 0, SDL_MIX_MAXVOLUME / 2);
    playSoundFromMemory(sound, SDL_MIX_MAXVOLUME);
    println("Played sound effect");
    SDL_Delay(2000);

    Audio* music = createAudio("assets/music/highlands.wav", 1, SDL_MIX_MAXVOLUME);
    playMusicFromMemory(music, SDL_MIX_MAXVOLUME);
    println("Changed music");
    SDL_Delay(10000);

    /* End Simple-SDL2-Audio */
    endAudio();
    println("Stopped audio");

    /* Important to free audio after ending Simple-SDL2-Audio because they might be
     * referenced still */
    freeAudio(sound);
    freeAudio(music);

    SDL_Quit();

    return 0;
}
