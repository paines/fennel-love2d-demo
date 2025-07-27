-- terrain.lua
-- Terrain-Rendering als Lua-Modul für Fennel/LÖVE

local terrain = {}

function terrain.draw_terrain(terrain_data, cam, width, height)
    local terrain_width = cam.terrain_width or 256
    local terrain_height = cam.terrain_height or 256
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
                local screen_y = math.floor(height - 0.7 * h)
                if screen_y < max_screen_y then
                    love.graphics.setColor(0, 1, 0, 1)
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
