local fennel = require("fennel")
fennel.install()
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
local lurker = love.filesystem.load("lurker.lua")()
local game = require("game")
local function _1_()
  package.loaded["game"] = nil
  game = require("game")
  print("[Lurker] Reloaded game module!")
  if game.load then
    game.load()
  else
  end
  return print("game.load wurde nach reload aufgerufen")
end
lurker.postreload(_1_)
love.update = function(dt)
  lurker.update()
  return game.update(dt)
end
love.draw = function()
  return game.draw()
end
love.load = function()
  return game.load()
end
love.keypressed = function(key, scancode, isrepeat)
  if game.keypressed then
    return game.keypressed(key, scancode, isrepeat)
  else
    return nil
  end
end
love.mousemoved = function(x, y, dx, dy, istouch)
  if game.mousemoved then
    return game.mousemoved(x, y, dx, dy, istouch)
  else
    return nil
  end
end
lurker.path = "."
return nil
