-- terrain.lua
-- Terrain-Rendering als Lua-Modul für Fennel/LÖVE

local terrain = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function posmod(a, n)
    return ((a % n) + n) % n
end

function terrain.draw_terrain(terrain_data, cam, width, height, fog_alpha_min)
    local terrain_width = cam.terrain_width or 256
    local terrain_height = cam.terrain_height or 256
    local pitch = cam.pitch or 0
    local cam_z = cam.z or 10
    local horizon = height / 2 + (pitch * 180) -- Pitch-Einfluss auf Horizont erhöht
    local scale = 110 -- scale reduziert
    -- Sky background
    love.graphics.setColor(0.55, 0.75, 1.0, 1)
    love.graphics.rectangle("fill", 0, 0, width, horizon)
    -- Simple moving clouds
    local time = love.timer.getTime()
    for i=1,8 do
        local cx = ((i * 60 + time * 20 * (0.5 + i * 0.07)) % width)
        local cy = horizon * (0.18 + 0.18 * math.sin(i + time * 0.2 + i))
        local cr = 32 + 12 * math.sin(i * 1.7 + time * 0.5)
        love.graphics.setColor(1,1,1,0.22)
        love.graphics.ellipse("fill", cx, cy, cr, cr * 0.45)
        love.graphics.setColor(1,1,1,0.13)
        love.graphics.ellipse("fill", cx+cr*0.5, cy+cr*0.1, cr*0.7, cr*0.3)
    end
    for screen_x = 0, width - 1 do
        local angle = cam.angle + (screen_x - width / 2) * 0.005
        local max_depth = 220 -- increased viewing distance
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
            local r = lerp(0.09, 0.22, t)
            local g = lerp(0.55, 0.95, t)
            local b = lerp(0.08, 0.22, t)
            local fog = math.min(depth / max_depth, 1)
            local alpha = lerp(1, fog_alpha_min or 0.55, fog) -- Fog noch schwächer, Terrain bleibt kräftig
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
