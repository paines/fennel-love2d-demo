-- fbxloader.lua
-- Einfache Schnittstelle zum Laden von .fbx-Dateien (nur Struktur, keine echte 3D-Engine)
-- ACHTUNG: LÖVE2D unterstützt kein echtes .fbx-Parsing! Dies ist ein Platzhalter für ein natives Lua-Modul.
-- Für echtes .fbx-Parsing empfiehlt sich ein externes Tool oder C-Binding.

local fbxloader = {}

-- Dummy-Parser: Liest nur Text, erkennt keine echte FBX-Struktur
function fbxloader.load(path)
    local file = io.open(path, "rb")
    if not file then
        return nil, "Datei nicht gefunden: " .. tostring(path)
    end
    local content = file:read("*a")
    file:close()
    -- Hier müsste ein echter FBX-Parser stehen!
    return {
        raw = content,
        info = "Nur Dummy: Kein echtes FBX-Parsing in reinem Lua!"
    }
end

return fbxloader
