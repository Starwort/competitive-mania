#pragma once
#include "audio.h"
#include "common.h"

typedef uint8 Flags;
#define FLAG_DIRLEFT 0b00001000
#define FLAG_DIRDOWN 0b00000100
#define FLAG_DIR__UP 0b00000010
#define FLAG_DIRRGHT 0b00000001
#define FLAG_DIR_ANY 0b00001111
#define FLAG_SONGEND 0b10000000
#define FLAG_INVALID 0b01110000

typedef struct _Beat {
    Flags flags;
    uint32 time;
    struct _Beat* next;
} Beat;

typedef struct _Song {
    Audio* track;
    Beat* map;
} Song;
