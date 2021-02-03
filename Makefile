# add some overridable macros for setting additional args
ADDITIONAL_FLAGS=
CFLAGS=
OPTIMISE_LEVEL=3
WARN_LEVEL=error
WARN_SETTINGS=
ifeq ($(WARN_LEVEL),all)
    WARN_SETTINGS=-Wall -Wextra -pedantic
else ifeq ($(WARN_LEVEL),error)
    WARN_SETTINGS=-Wall -Wextra -Werror -pedantic-errors
endif

SDL_DIR_WIN32=lib/win32
SDL_DIR_WIN64=lib/win64
SOURCE_DIR=src
INCLUDE_DIR=$(SOURCE_DIR)
CC_W32=i686-w64-mingw32-gcc
CC_W64=x86_64-w64-mingw32-gcc
CC_FLAGS=-I $(INCLUDE_DIR) -O$(OPTIMISE_LEVEL) -flto $(ADDITIONAL_FLAGS) $(CFLAGS) $(WARN_SETTINGS) $(DEBUG_FLAGS)
CC_FLAGS_WIN32=$(CC_FLAGS) -I $(SDL_DIR_WIN32)/include -L $(SDL_DIR_WIN32)/lib -lmingw32 -lSDL2main -lSDL2
CC_FLAGS_WIN64=$(CC_FLAGS) -I $(SDL_DIR_WIN64)/include -L $(SDL_DIR_WIN64)/lib -lmingw32 -lSDL2main -lSDL2
OBJECT_DIR=object
EXE_DIR_WIN32=dist/win32
EXE_DIR_WIN64=dist/win64
COMMON=audio common
COMMON_OBJECTS_WIN32=$(addsuffix .32.o,$(addprefix ${OBJECT_DIR}/,${COMMON}))
COMMON_OBJECTS_WIN64=$(addsuffix .64.o,$(addprefix ${OBJECT_DIR}/,${COMMON}))

all: mania

mania: ${EXE_DIR_WIN32}/mania.exe ${EXE_DIR_WIN64}/mania.exe

${OBJECT_DIR}/%.32.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_W32) -c -o $@ $< $(CC_FLAGS_WIN32)
${OBJECT_DIR}/%.64.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_W64) -c -o $@ $< $(CC_FLAGS_WIN64)

${EXE_DIR_WIN32}/mania.exe: ${OBJECT_DIR}/mania.32.o ${COMMON_OBJECTS_WIN32}
	$(CC_W32) -o $@ $^ $(CC_FLAGS_WIN32)
	cp $(SDL_DIR_WIN32)/bin/SDL2.dll ${EXE_DIR_WIN32}/
	cp -r assets ${EXE_DIR_WIN32}/

${EXE_DIR_WIN64}/mania.exe: ${OBJECT_DIR}/mania.64.o ${COMMON_OBJECTS_WIN64}
	$(CC_W64) -o $@ $^ $(CC_FLAGS_WIN64)
	cp $(SDL_DIR_WIN64)/bin/SDL2.dll ${EXE_DIR_WIN64}/
	cp -r assets ${EXE_DIR_WIN64}/

.PHONY: all clean

clean:
	rm -f ${OBJECT_DIR}/*.o *~ core $(INCLUDE_DIR)/*~ ${EXE_DIR_WIN32}/* ${EXE_DIR_WIN64}/*
