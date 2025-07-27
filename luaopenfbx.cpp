// luaopenfbx.c
extern "C" {
#include <lua.h>
#include <lauxlib.h>
}
#include <cstdlib>
#include "ofbx.h"

static int l_fbx_load(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);

    printf("NATIVES MODUL WIRD VERWENDET\n");
    fflush(stdout);

    FILE *fp = fopen(filename, "rb");
    if (!fp) {
        lua_newtable(L);
        lua_pushstring(L, "error");
        lua_setfield(L, -2, "status");
        lua_pushstring(L, "Datei nicht gefunden");
        lua_setfield(L, -2, "message");
        return 1;
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
        lua_newtable(L);
        lua_pushstring(L, "error");
        lua_setfield(L, -2, "status");
        lua_pushstring(L, "FBX konnte nicht geladen werden");
        lua_setfield(L, -2, "message");
        return 1;
    }

    lua_newtable(L); // result table (index -1)
    lua_pushstring(L, "ok");
    lua_setfield(L, -2, "status");

    lua_newtable(L); // meshes table (index -1)
    int meshCount = scene->getMeshCount();
lua_newtable(L); // meshes table
for (int i = 0; i < meshCount; ++i) {
    const ofbx::Mesh* mesh = (const ofbx::Mesh*)scene->getMesh(i);
    if (!mesh) continue;
    const ofbx::Geometry* geom = mesh->getGeometry();
    if (!geom) continue;
    const ofbx::GeometryData& gdata = geom->getGeometryData();
    ofbx::Vec3Attributes positions = gdata.getPositions();
    int vertexCount = positions.count;
    lua_newtable(L); // mesh table
    lua_newtable(L); // vertices
    for (int v = 0; v < vertexCount; ++v) {
        ofbx::Vec3 pos = positions.get(v);
        lua_newtable(L); // vertex
        lua_pushnumber(L, pos.x);
        lua_rawseti(L, -2, 1);
        lua_pushnumber(L, pos.y);
        lua_rawseti(L, -2, 2);
        lua_pushnumber(L, pos.z);
        lua_rawseti(L, -2, 3);
        lua_rawseti(L, -2, v+1);
    }
    lua_setfield(L, -2, "vertices");
    lua_setfield(L, -2, "mesh");
    lua_rawseti(L, -2, i+1);
}
lua_setfield(L, -2, "meshes");

    printf("C-BINDING: return 1, status=%s\n", lua_tostring(L, -1));
    fflush(stdout);

    return 1;
}

extern "C" int luaopen_openfbx(lua_State *L) {
    lua_newtable(L);
    lua_pushcfunction(L, l_fbx_load);
    lua_setfield(L, -2, "load");
    printf("C-BINDING: return 1, status=%s\\n", lua_tostring(L, -1));
    fflush(stdout);
    return 1;
}