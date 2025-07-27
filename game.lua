local width = 400
local height = 300
local terrain
do
  local arr = {}
  for i = 1, width do
    arr[i] = (100 + (50 * math.sin((i / 20))))
  end
  terrain = arr
end
local heli = {x = 50, y = 50, vy = 0}
local function update(dt)
  if love.keyboard.isDown("right") then
    heli["x"] = (heli.x + (100 * dt))
  else
  end
  if love.keyboard.isDown("left") then
    heli["x"] = (heli.x - (100 * dt))
  else
  end
  if love.keyboard.isDown("up") then
    heli["vy"] = (heli.vy - (200 * dt))
  else
  end
  if love.keyboard.isDown("down") then
    heli["vy"] = (heli.vy + (200 * dt))
  else
  end
  heli["y"] = (heli.y + (heli.vy * dt))
  do end (heli)["vy"] = (heli.vy * 0.98)
  return nil
end
local function draw_world()
  love.graphics.setColor(0.3, 0.8, 0.3)
  for i = 1, width do
    love.graphics.line(i, height, i, (height - terrain[i]))
  end
  return nil
end
local function draw()
  draw_world()
  love.graphics.setColor(1, 1, 0)
  return love.graphics.rectangle("fill", heli.x, (height - heli.y), 20, 10)
end
local function load()
  love.window.setMode(width, height)
  return love.window.setTitle("Helikopter \195\188ber Terrain")
end
return {update = update, draw = draw, load = load}
