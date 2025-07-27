local width = 800
local height = 600
local terrain_state = {width = 256, height = 256, data = nil}
local cam = {x = (terrain_state.width / 2), y = (terrain_state.height / 2), z = 20, angle = 0, pitch = 0.5}
local terrainmod = require("terrain")
local fog_alpha_min = 0.55
local _local_1_ = require("load_tank")
local load_tank = _local_1_["load-tank"]
local tank_mesh = nil
local depth_loop
local function _2_(terrain, terrain_width, terrain_height, screen_x, angle, depth, max_screen_y)
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
depth_loop = _2_
local function generate_heightmap(w, h)
  local arr = {}
  local freq = 0.045
  local amp = 18
  local base_h = 155
  for x = 0, (w - 1) do
    arr[x] = {}
    for y = 0, (h - 1) do
      local base = ((math.sin((x * freq)) * amp) + (math.cos((y * freq)) * amp))
      local peak1
      do
        local dx = (x - 180)
        local dy = (y - 180)
        peak1 = math.max(0, (30 - math.sqrt(((dx * dx) + (dy * dy)))))
      end
      local noise = (math.random() * 2)
      local h0 = math.max(0, math.min(255, (base_h + base + peak1 + noise)))
      do end (arr[x])[y] = h0
    end
  end
  return {data = arr, width = w, height = h}
end
local function draw_terrain()
  return terrainmod.draw_terrain(terrain_state.data, cam, width, height, fog_alpha_min)
end
local function draw()
  love.graphics.setBackgroundColor(0.55, 0.75, 1.0, 1)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(("Pitch: " .. tostring(cam.pitch) .. "  H\195\182he: " .. tostring(cam.z)), 10, 10)
  draw_terrain()
  if (type(tank_mesh) == "table") then
    love.graphics.setColor(1, 0, 0, 1)
    return love.graphics.print("Tank geladen!", 10, 30)
  else
    return nil
  end
end
local function load()
  do
    local result = load_tank("PanzerIV/PanzerIV/PanzerIV_Body.fbx")
    print("GAME.FNL: result type: ", type(result), " tostring: ", tostring(result))
  end
  do
    local tstate = generate_heightmap(256, 256)
    local mid_x = (tstate.width / 2)
    local mid_y = (tstate.height / 2)
    do end (terrain_state)["data"] = tstate.data
    terrain_state["width"] = tstate.width
    terrain_state["height"] = tstate.height
    cam["x"] = mid_x
    cam["y"] = mid_y
    cam["z"] = 180
    cam["pitch"] = -0.45
    cam["terrain_width"] = tstate.width
    cam["terrain_height"] = tstate.height
  end
  love.window.setMode(width, height)
  love.window.setTitle("Voxel Terrain Demo")
  return love.mouse.setRelativeMode(false)
end
local function update(dt)
  local speed = (60 * dt)
  local turn_speed = (1.5 * dt)
  local pitch_speed = (0.8 * dt)
  local z_speed = (20 * dt)
  local terrain_width = terrain_state.width
  local terrain_height = terrain_state.height
  if love.keyboard.isDown("a") then
    cam["angle"] = (cam.angle - turn_speed)
  else
  end
  if love.keyboard.isDown("d") then
    cam["angle"] = (cam.angle + turn_speed)
  else
  end
  if love.keyboard.isDown("w") then
    cam["x"] = math.fmod((cam.x + (math.cos(cam.angle) * speed)), terrain_width)
    do end (cam)["y"] = math.fmod((cam.y + (math.sin(cam.angle) * speed)), terrain_height)
  else
  end
  if love.keyboard.isDown("s") then
    cam["x"] = math.fmod((cam.x - (math.cos(cam.angle) * speed)), terrain_width)
    do end (cam)["y"] = math.fmod((cam.y - (math.sin(cam.angle) * speed)), terrain_height)
  else
  end
  if love.keyboard.isDown("up") then
    cam["pitch"] = math.max(-1, (cam.pitch - pitch_speed))
  else
  end
  if love.keyboard.isDown("down") then
    cam["pitch"] = math.min(1, (cam.pitch + pitch_speed))
  else
  end
  if love.keyboard.isDown("q") then
    cam["z"] = math.max(1, (cam.z - z_speed))
  else
  end
  if love.keyboard.isDown("e") then
    cam["z"] = math.min(500, (cam.z + z_speed))
  else
  end
  if love.keyboard.isDown("u") then
    _G["fog-alpha-min"] = math.max(0.1, (fog_alpha_min - 0.01))
  else
  end
  if love.keyboard.isDown("i") then
    _G["fog-alpha-min"] = math.min(1, (fog_alpha_min + 0.01))
  else
  end
  cam["pitch"] = math.max(-1, math.min(1, cam.pitch))
  do end (cam)["x"] = math.fmod(cam.x, terrain_width)
  do end (cam)["y"] = math.fmod(cam.y, terrain_height)
  do end (cam)["z"] = math.max(1, math.min(500, cam.z))
  return nil
end
local function mousemoved(x, y, dx, dy, istouch)
  if love.keyboard.isDown("lshift") then
    cam["pitch"] = math.max(-1, math.min(1, (cam.pitch + (dy * 0.01))))
    return nil
  else
    return nil
  end
end
local function keypressed(key, scancode, isrepeat)
  return print("KEYPRESSED!", key)
end
return {update = update, draw = draw, load = load, mousemoved = mousemoved, keypressed = keypressed}
