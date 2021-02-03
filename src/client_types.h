#pragma once
#include "audio.h"
#include "common.h"

typedef struct _Beat {
    bool up;
    bool down;
    bool left;
    bool right;
    uint64 time;
    struct _Beat* next;
} Beat;

typedef struct _Song {
    Audio* track;
    Beat* map;
    string id;
} Song;
