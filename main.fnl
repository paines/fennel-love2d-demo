(local fennel (require :fennel))
(fennel.install)

(local Camera
  {:x 0 :y 0 :w 400 :h 300})

(local Player
  {:x 200 :y 150 :speed 120})

(local World
  {:w 1000 :h 800})

(fn clamp [val min max]
  (math.max min (math.min max val)))

(fn update-camera []
  (let [half-w (/ Camera.w 2)
        half-h (/ Camera.h 2)]
    (tset Camera :x (clamp (- Player.x half-w) 0 (- World.w Camera.w)))
    (tset Camera :y (clamp (- Player.y half-h) 0 (- World.h Camera.h)))))

(local lurker ((love.filesystem.load "lurker.lua")))
(var game (require :game))

(lurker.postreload (fn []
  (tset package.loaded "game" nil)
  (set game (require :game))
  (print "[Lurker] Reloaded game module!")
  (when game.load (game.load))
  (print "game.load wurde nach reload aufgerufen")))

(fn love.update [dt]
  (lurker.update)
  (game.update dt))

(fn love.draw []
  (game.draw))

(fn love.load []
  (game.load))

(fn love.keypressed [key scancode isrepeat]
  (when game.keypressed (game.keypressed key scancode isrepeat)))

(fn love.mousemoved [x y dx dy istouch]
  (when game.mousemoved (game.mousemoved x y dx dy istouch)))

(set lurker.path ".")