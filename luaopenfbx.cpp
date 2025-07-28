// luaopenfbx.cpp
extern "C" {
#include <stdio.h>
#include <lua.h>
#include <lauxlib.h>
}
#include <cstdlib>
#include "ufbx.h"

static int l_fbx_load(lua_State *L) {
    const char *filename = luaL_checkstring(L, 1);
    printf("NATIVES MODUL WIRD VERWENDET\n"); fflush(stdout);

    ufbx_error error;
    ufbx_scene *scene = ufbx_load_file(filename, NULL, &error);
    if (!scene) {
        lua_newtable(L);
        lua_pushstring(L, "error");
        lua_setfield(L, -2, "status");
        lua_pushstring(L, error.description.data ? error.description.data : "FBX konnte nicht geladen werden");
        lua_setfield(L, -2, "message");
        return 1;
    }

    lua_newtable(L); // result table
    size_t meshCount = scene->meshes.count;
    if (meshCount == 0) {
        lua_pushstring(L, "error");
        lua_setfield(L, -2, "status");
        lua_pushstring(L, "Keine Meshes im FBX gefunden");
        lua_setfield(L, -2, "message");
        ufbx_free_scene(scene);
        return 1;
    }
    lua_pushstring(L, "ok");
    lua_setfield(L, -2, "status");
    lua_newtable(L); // meshes table
    for (size_t i = 0; i < meshCount; ++i) {
        ufbx_mesh *mesh = scene->meshes.data[i];
        if (!mesh) continue;
        lua_newtable(L); // mesh table
        // Vertices
        lua_newtable(L); // vertices
        for (size_t v = 0; v < mesh->num_vertices; ++v) {
            ufbx_vec3 pos = mesh->vertex_position[v];
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
        // Indices
        lua_newtable(L); // indices
        for (size_t idx = 0; idx < mesh->num_indices; ++idx) {
            lua_pushinteger(L, mesh->vertex_indices[idx]);
            lua_rawseti(L, -2, idx+1);
        }
        lua_setfield(L, -2, "indices");
        lua_rawseti(L, -2, i+1);
    }
    lua_setfield(L, -2, "meshes");
    ufbx_free_scene(scene);
    return 1;
}

extern "C" int luaopen_openfbx(lua_State *L) {
    lua_newtable(L);
    lua_pushcfunction(L, l_fbx_load);
    lua_setfield(L, -2, "load");
    fflush(stdout);
    return 1;
}
