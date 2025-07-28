-- In der Lua-Konsole:
local openfbx = require("openfbx")

-- Teste das Laden einer FBX-Datei
local result = openfbx.load("PanzerIV/PanzerIV/PanzerIV_Body.fbx")
print("Load result:", result)
print("Type:", type(result))

-- Falls es ein Tisch ist, schaue was drin ist
if type(result) == "table" then
    for k, v in pairs(result) do
        print(k .. " = " .. tostring(v))
    end
    
    -- Mehr Details über die Meshes
    if result.meshes and type(result.meshes) == "table" then
        print("\nMesh Details:")
        for i, mesh in ipairs(result.meshes) do
            print("Mesh " .. i .. ":")
            if type(mesh) == "table" then
                for mk, mv in pairs(mesh) do
                    if mk == "vertices" and type(mv) == "table" then
                        print("  " .. mk .. " = table with " .. #mv .. " vertices")
                        -- Zeige erste paar Vertices mit deren Inhalt
                        for j = 1, math.min(3, #mv) do
                            print("    vertex[" .. j .. "] = " .. tostring(mv[j]))
                            if type(mv[j]) == "table" then
                                print("      vertex data:")
                                for vk, vv in pairs(mv[j]) do
                                    print("        " .. vk .. " = " .. tostring(vv))
                                end
                            end
                        end
                        if #mv > 3 then print("    ... (" .. (#mv - 3) .. " more vertices)") end
                    elseif mk == "indices" and type(mv) == "table" then
                        print("  " .. mk .. " = table with " .. #mv .. " indices")
                        -- Zeige erste paar Indices
                        for j = 1, math.min(6, #mv) do
                            print("    index[" .. j .. "] = " .. tostring(mv[j]))
                        end
                        if #mv > 6 then print("    ... (" .. (#mv - 6) .. " more indices)") end
                    else
                        print("  " .. mk .. " = " .. tostring(mv))
                    end
                end
            else
                print("  " .. tostring(mesh))
            end
        end
    end
end