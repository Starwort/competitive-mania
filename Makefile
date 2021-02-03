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
INCLUDE_DIR=include
CC_LIN=gcc
CC_W32=i686-w64-mingw32-gcc
CC_W64=x86_64-w64-mingw32-gcc
CC_FLAGS=-I $(INCLUDE_DIR) -O$(OPTIMISE_LEVEL) -flto $(ADDITIONAL_FLAGS) $(CFLAGS) $(WARN_SETTINGS) $(DEBUG_FLAGS)
CC_FLAGS_WIN32=$(CC_FLAGS) -L $(SDL_DIR_WIN32)/lib -lmingw32 -lSDL2main -lSDL2
CC_FLAGS_WIN64=$(CC_FLAGS) -L $(SDL_DIR_WIN64)/lib -lmingw32 -lSDL2main -lSDL2
CC_FLAGS_LINUX=$(CC_FLAGS) -lSDL2main -lSDL2
OBJECT_DIR=object
EXE_DIR_WIN32=dist/win32
EXE_DIR_WIN64=dist/win64
EXE_DIR_LINUX=dist/linux
CLIENT_COMMON=audio common
CLIENT_COMMON_OBJECTS_WIN32=$(addsuffix .32.o,$(addprefix ${OBJECT_DIR}/,${CLIENT_COMMON}))
CLIENT_COMMON_OBJECTS_WIN64=$(addsuffix .64.o,$(addprefix ${OBJECT_DIR}/,${CLIENT_COMMON}))
CLIENT_COMMON_OBJECTS_LINUX=$(addsuffix .o,$(addprefix ${OBJECT_DIR}/,${CLIENT_COMMON}))
SERVER_COMMON=common
SERVER_COMMON_OBJECTS_WIN32=$(addsuffix .32.o,$(addprefix ${OBJECT_DIR}/,${SERVER_COMMON}))
SERVER_COMMON_OBJECTS_WIN64=$(addsuffix .64.o,$(addprefix ${OBJECT_DIR}/,${SERVER_COMMON}))
SERVER_COMMON_OBJECTS_LINUX=$(addsuffix .o,$(addprefix ${OBJECT_DIR}/,${SERVER_COMMON}))

all: format client

client: ${EXE_DIR_WIN32}/client.exe ${EXE_DIR_WIN64}/client.exe ${EXE_DIR_LINUX}/client
server: ${EXE_DIR_WIN32}/server.exe ${EXE_DIR_WIN64}/server.exe ${EXE_DIR_LINUX}/server

${OBJECT_DIR}/%.32.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_W32) -c -o $@ $< $(CC_FLAGS_WIN32)
${OBJECT_DIR}/%.64.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_W64) -c -o $@ $< $(CC_FLAGS_WIN64)
${OBJECT_DIR}/%.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_LIN) -c -o $@ $< $(CC_FLAGS_LINUX)

${OBJECT_DIR}/%.32.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_W32) -c -o $@ $< $(CC_FLAGS_WIN32)
${OBJECT_DIR}/%.64.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_W64) -c -o $@ $< $(CC_FLAGS_WIN64)
${OBJECT_DIR}/%.o: ${SOURCE_DIR}/%.c ${SOURCE_DIR}/%.h
	$(CC_LIN) -c -o $@ $< $(CC_FLAGS_LINUX)

${EXE_DIR_WIN32}/client.exe: ${OBJECT_DIR}/client.32.o ${CLIENT_COMMON_OBJECTS_WIN32}
	$(CC_W32) -o $@ $^ $(CC_FLAGS_WIN32)
	cp $(SDL_DIR_WIN32)/bin/SDL2.dll ${EXE_DIR_WIN32}/
	cp -r assets ${EXE_DIR_WIN32}/

${EXE_DIR_WIN64}/client.exe: ${OBJECT_DIR}/client.64.o ${CLIENT_COMMON_OBJECTS_WIN64}
	$(CC_W64) -o $@ $^ $(CC_FLAGS_WIN64)
	cp $(SDL_DIR_WIN64)/bin/SDL2.dll ${EXE_DIR_WIN64}/
	cp -r assets ${EXE_DIR_WIN64}/

${EXE_DIR_LINUX}/client: ${OBJECT_DIR}/client.o ${CLIENT_COMMON_OBJECTS_WIN64}
	$(CC_LIN) -o $@ $^ $(CC_FLAGS_LINUX)
	cp -r assets ${EXE_DIR_LINUX}/

${EXE_DIR_WIN32}/server.exe: ${OBJECT_DIR}/server.32.o ${SERVER_COMMON_OBJECTS_WIN32}
	$(CC_W32) -o $@ $^ $(CC_FLAGS_WIN32)
	cp -r assets ${EXE_DIR_WIN32}/

${EXE_DIR_WIN64}/server.exe: ${OBJECT_DIR}/server.64.o ${SERVER_COMMON_OBJECTS_WIN64}
	$(CC_W64) -o $@ $^ $(CC_FLAGS_WIN64)
	cp -r assets ${EXE_DIR_WIN64}/

${EXE_DIR_LINUX}/server: ${OBJECT_DIR}/server.o ${SERVER_COMMON_OBJECTS_WIN64}
	$(CC_LIN) -o $@ $^ $(CC_FLAGS_LINUX)
	cp -r assets ${EXE_DIR_LINUX}/

.PHONY: all clean format

format:
	clang-format-10 -i $(SOURCE_DIR)/*

clean:
	rm -rf ${OBJECT_DIR}/*.o *~ core $(INCLUDE_DIR)/*~ ${EXE_DIR_WIN32}/* ${EXE_DIR_WIN64}/*
