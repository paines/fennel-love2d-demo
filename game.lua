local width = 400
local height = 300
local terrain_state = {width = 256, height = 256, data = nil}
local cam = {x = 128, y = 64, z = 40, angle = 0}
local function load_heightmap(filename)
  local img = love.image.newImageData(filename)
  local imgw = img:getWidth()
  local imgh = img:getHeight()
  local arr = {}
  for x = 0, (imgw - 1) do
    arr[x] = {}
    for y = 0, (imgh - 1) do
      local r = select(1, img:getPixel(x, y))
      do end (arr[x])[y] = (r * 255)
    end
  end
  return {data = arr, width = imgw, height = imgh}
end
local function draw_terrain()
  local terrain = terrain_state.data
  local terrain_width = terrain_state.width
  local terrain_height = terrain_state.height
  for screen_x = 0, (width - 1) do
    local angle = (cam.angle + ((screen_x - (width / 2)) * 0.005))
    local max_screen_y = height
    for depth = 1, 200 do
      local dx = (math.cos(angle) * depth)
      local dy = (math.sin(angle) * depth)
      local map_x = math.floor((cam.x + dx))
      local map_y = math.floor((cam.y + dy))
      if ((map_x >= 0) and (map_x < terrain_width) and (map_y >= 0) and (map_y < terrain_height)) then
        local h = terrain[map_x][map_y]
        local screen_y = math.floor((cam.z - (0.5 * h) - (100 / depth)))
        if (screen_y < max_screen_y) then
          love.graphics.setColor(0.2, 0.8, 0.2, (1.0 * (1 - (depth / 200))))
          love.graphics.line(screen_x, screen_y, screen_x, max_screen_y)
          __fnl_global__set_21(max_screen_y, screen_y)
        else
        end
      else
      end
    end
  end
  return nil
end
local function draw()
  return draw_terrain()
end
local function load()
  do
    local tstate = load_heightmap("heightmap.png")
    do end (terrain_state)["data"] = tstate.data
    terrain_state["width"] = tstate.width
    terrain_state["height"] = tstate.height
  end
  love.window.setMode(width, height)
  return love.window.setTitle("Voxel Terrain Demo")
end
local function update(dt)
end
return {update = update, draw = draw, load = load}
