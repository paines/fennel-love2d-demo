-- terrain.lua
-- Terrain-Rendering als Lua-Modul für Fennel/LÖVE

local terrain = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function posmod(a, n)
    return ((a % n) + n) % n
end

function terrain.draw_terrain(terrain_data, cam, width, height)
    local terrain_width = cam.terrain_width or 256
    local terrain_height = cam.terrain_height or 256
    local pitch = cam.pitch or 0
    local cam_z = cam.z or 10
    local horizon = height / 2 + (pitch * 180) -- Pitch-Einfluss auf Horizont erhöht
    local scale = 110 -- scale reduziert
    for screen_x = 0, width - 1 do
        local angle = cam.angle + (screen_x - width / 2) * 0.005
        local max_depth = 120
        local max_screen_y = height
        local function depth_loop(depth, max_screen_y)
            if depth > max_depth then return end
            local dx = math.cos(angle) * depth
            local dy = math.sin(angle) * depth
            local map_x = posmod(math.floor(cam.x + dx), terrain_width)
            local map_y = posmod(math.floor(cam.y + dy), terrain_height)
            local h = terrain_data[map_x] and terrain_data[map_x][map_y] or 0
            -- screen_y-Berechnung optimiert: cam_z stärker gewichtet, Pitch-Einfluss auf Horizont
            local screen_y = math.floor(horizon - ((h - cam_z) / (depth * 0.9)) * scale)
            local t = math.min(math.max(h / 255, 0), 1)
            local r = lerp(0.1, 0.6, t)
            local g = lerp(0.6, 0.6, t)
            local b = lerp(0.1, 0.6, t)
            local fog = math.min(depth / max_depth, 1)
            local alpha = lerp(1, 0.15, fog)
            love.graphics.setColor(r, g, b, alpha)
            if screen_y < max_screen_y then
                love.graphics.line(screen_x, screen_y, screen_x, max_screen_y)
                depth_loop(depth + 1, screen_y)
            else
                depth_loop(depth + 1, max_screen_y)
            end
        end
        depth_loop(1, max_screen_y)
    end
end

return terrain
