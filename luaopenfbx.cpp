// luaopenfbx.c
extern "C" {
#include <lua.h>
#include <lauxlib.h>
}
#include <cstdlib>
#include "ofbx.h"

static int l_fbx_load(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);
    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        lua_pushnil(L);
        lua_pushstring(L, "Datei nicht gefunden");
        return 2;
    }
    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    unsigned char *data = (unsigned char*)malloc(size);
    fread(data, 1, size, fp);
    fclose(fp);

    const ofbx::IScene* scene = ofbx::load(data, size, 0);
    free(data);

    if (!scene) {
        lua_pushnil(L);
        lua_pushstring(L, "FBX konnte nicht geladen werden");
        return 2;
    }
    lua_newtable(L);
    lua_pushstring(L, "ok");
    lua_setfield(L, -2, "status");
    // Hier könntest du weitere Infos aus scene extrahieren!
    return 1;
}

extern "C" int luaopen_openfbx(lua_State *L) {
    lua_newtable(L);
    lua_pushcfunction(L, l_fbx_load);
    lua_setfield(L, -2, "load");
    return 1;
}