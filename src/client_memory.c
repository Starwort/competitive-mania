#include "client_memory.h"

Song* load_song(string id) {
    int len = strlen(id);
    string map_path = malloc((len + sizeof("assets/maps/.map")) * sizeof(char));
    sprintf(map_path, "assets/map/%s.map", id);
    string song_path = malloc((len + sizeof("assets/music/.wav")) * sizeof(char));
    sprintf(song_path, "assets/music/%s.wav", id);
    FILE* file = fopen(map_path, "r");
    if (file == NULL) {
        eprintfln("ERROR: Could not open map %s", id);
        return NULL;
    }
    Audio* track = createAudio(song_path, 0, SDL_MIX_MAXVOLUME);
    if (track == NULL) {
        return NULL;
    }
    Beat* map = read_map(file);
    if (map == NULL) {
        return NULL;
    }
    Song* rv = malloc(sizeof(Song));
    rv->map = map;
    rv->track = track;
    return rv;
}

Beat* read_map(FILE* map) {
    char beat[5];
    int bytes = fread(beat, 1, 5, map);
    if (bytes != 5) {
        eprintln("ERROR: Map ended prematurely") return NULL;
    }
    uint32 time = beat[0] | (beat[1] << 8) | (beat[2] << 16) | (beat[3] << 24);
    Flags flags = beat[4];
    if (flags & FLAG_INVALID) {
        eprintln("ERROR: Beat has malformed flags");
        return NULL;
    }
    Beat* rv = malloc(sizeof(Beat));
    rv->time = time;
    rv->flags = flags;
    if (flags & FLAG_SONGEND) {
        rv->next = NULL;
    } else {
        rv->next = read_map(map);
    }
    return rv;
}
