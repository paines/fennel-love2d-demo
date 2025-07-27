local Camera = {x = 0, y = 0, w = 400, h = 300}
local Player = {x = 200, y = 150, speed = 120}
local World = {w = 1000, h = 800}
local function clamp(val, min, max)
  return math.max(min, math.min(max, val))
end
local function update_camera()
  local half_w = (Camera.w / 2)
  local half_h = (Camera.h / 2)
  do end (Camera)["x"] = clamp((Player.x - half_w), 0, (World.w - Camera.w))
  do end (Camera)["y"] = clamp((Player.y - half_h), 0, (World.h - Camera.h))
  return nil
end
local function update(dt)
  if love.keyboard.isDown("right") then
    Player["x"] = (Player.x + (Player.speed * dt))
  else
  end
  if love.keyboard.isDown("left") then
    Player["x"] = (Player.x - (Player.speed * dt))
  else
  end
  if love.keyboard.isDown("down") then
    Player["y"] = (Player.y + (Player.speed * dt))
  else
  end
  if love.keyboard.isDown("up") then
    Player["y"] = (Player.y - (Player.speed * dt))
  else
  end
  return update_camera()
end
local function draw_world()
  love.graphics.setColor(0.1, 0.8, 0.8)
  love.graphics.rectangle("fill", 0, 0, World.w, World.h)
  love.graphics.setColor(0.2, 0.2, 0.8)
  love.graphics.circle("fill", Player.x, Player.y, 20)
  love.graphics.setColor(0.8, 0.2, 0.2)
  for i = 1, 10 do
    love.graphics.rectangle("fill", (i * 80), 400, 40, 40)
  end
  return nil
end
local function draw()
  love.graphics.push()
  love.graphics.translate(( - Camera.x), ( - Camera.y))
  draw_world()
  love.graphics.pop()
  love.graphics.setColor(1, 1, 1)
  return love.graphics.rectangle("line", 0, 0, Camera.w, Camera.h)
end
local function load()
  print("GAME.LOAD: ", os.time())
  love.window.setTitle("TEST")
  love.window.setMode(Camera.w, Camera.h)
  return update_camera()
end
return {update = update, draw = draw, load = load}
