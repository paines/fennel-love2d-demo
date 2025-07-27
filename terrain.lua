-- terrain.lua
-- Terrain-Rendering als Lua-Modul für Fennel/LÖVE

local terrain = {}

local function lerp(a, b, t)
    return a + (b - a) * t
end

function terrain.draw_terrain(terrain_data, cam, width, height)
    local terrain_width = cam.terrain_width or 256
    local terrain_height = cam.terrain_height or 256
    local pitch = cam.pitch or 0
    for screen_x = 0, width - 1 do
        local angle = cam.angle + (screen_x - width / 2) * 0.005
        local max_depth = 200
        local max_screen_y = height
        local function depth_loop(depth, max_screen_y)
            if depth > max_depth then return end
            local dx = math.cos(angle) * depth
            local dy = math.sin(angle) * depth
            local map_x = math.floor(cam.x + dx)
            local map_y = math.floor(cam.y + dy)
            if map_x >= 0 and map_x < terrain_width and map_y >= 0 and map_y < terrain_height then
                local h = terrain_data[map_x] and terrain_data[map_x][map_y] or 0
                -- Pitch-Einfluss noch stärker machen
                local screen_y = math.floor(height - 0.7 * h + (pitch * 400))
                local t = math.min(math.max(h / 255, 0), 1)
                local r = lerp(0.1, 0.6, t)
                local g = lerp(0.6, 0.6, t)
                local b = lerp(0.1, 0.6, t)
                love.graphics.setColor(r, g, b, 1)
                if screen_y < max_screen_y then
                    love.graphics.line(screen_x, screen_y, screen_x, max_screen_y)
                    depth_loop(depth + 1, screen_y)
                else
                    depth_loop(depth + 1, max_screen_y)
                end
            else
                depth_loop(depth + 1, max_screen_y)
            end
        end
        depth_loop(1, max_screen_y)
    end
end

return terrain
