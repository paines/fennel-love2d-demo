local width = 800
local height = 600
local terrain_state = {width = 256, height = 256, data = nil}
local cam = {x = (terrain_state.width / 2), y = (terrain_state.height / 2), z = 20, angle = 0, pitch = 0.5}
local terrainmod = require("terrain")
local depth_loop
local function _1_(terrain, terrain_width, terrain_height, screen_x, angle, depth, max_screen_y)
  if (depth <= 200) then
    local dx = (math.cos(angle) * depth)
    local dy = (math.sin(angle) * depth)
    local map_x = math.floor((cam.x + dx))
    local map_y = math.floor((cam.y + dy))
    if ((map_x >= 0) and (map_x < terrain_width) and (map_y >= 0) and (map_y < terrain_height)) then
      local h = terrain[map_x][map_y]
      local screen_y = math.floor((height - (0.7 * h)))
      if ((screen_x == 200) and (depth <= 10)) then
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.print(("d=" .. depth .. ", mx=" .. map_x .. ", my=" .. map_y .. ", h=" .. h .. ", y=" .. screen_y), 250, (10 + (depth * 12)))
      else
      end
      if ((screen_x == 200) and (h == 100)) then
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.line(screen_x, 100, screen_x, 120)
      else
      end
      if (screen_y < max_screen_y) then
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.line(screen_x, screen_y, screen_x, max_screen_y)
        return __fnl_global__depth_2dloop(terrain, terrain_width, terrain_height, screen_x, angle, (depth + 1), screen_y)
      else
        return __fnl_global__depth_2dloop(terrain, terrain_width, terrain_height, screen_x, angle, (depth + 1), max_screen_y)
      end
    else
      return __fnl_global__depth_2dloop(terrain, terrain_width, terrain_height, screen_x, angle, (depth + 1), max_screen_y)
    end
  else
    return nil
  end
end
depth_loop = _1_
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
  return terrainmod.draw_terrain(terrain_state.data, cam, width, height)
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
    cam["x"] = (terrain_state.width / 2)
    do end (cam)["y"] = (terrain_state.height / 2)
  end
  love.window.setMode(width, height)
  return love.window.setTitle("Voxel Terrain Demo")
end
local function update(dt)
end
return {update = update, draw = draw, load = load}
