(local Camera {:x 0 :y 0 :w 400 :h 300})
(local Player {:x 200 :y 150 :speed 120})
(local World {:w 1000 :h 800})

(fn clamp [val min max]
  (math.max min (math.min max val)))

(fn update-camera []
  (let [half-w (/ Camera.w 2)
        half-h (/ Camera.h 2)]
    (tset Camera :x (clamp (- Player.x half-w) 0 (- World.w Camera.w)))
    (tset Camera :y (clamp (- Player.y half-h) 0 (- World.h Camera.h)))))

(fn update [dt]
  (when (love.keyboard.isDown "right")
    (tset Player :x (+ Player.x (* Player.speed dt))))
  (when (love.keyboard.isDown "left")
    (tset Player :x (- Player.x (* Player.speed dt))))
  (when (love.keyboard.isDown "down")
    (tset Player :y (+ Player.y (* Player.speed dt))))
  (when (love.keyboard.isDown "up")
    (tset Player :y (- Player.y (* Player.speed dt))))

  (update-camera))

(fn draw-world []
  (love.graphics.setColor 0.1 0.8 0.8)
  (love.graphics.rectangle "fill" 0 0 World.w World.h)
  (love.graphics.setColor 0.2 0.2 0.8)
  (love.graphics.circle "fill" Player.x Player.y 20)
  ;; Zeichne ein paar Objekte
  (love.graphics.setColor 0.8 0.2 0.2)
  (for [i 1 10]
    (love.graphics.rectangle "fill" (* i 80) 400 40 40)))

(fn draw []
  (love.graphics.push)
  (love.graphics.translate (- Camera.x) (- Camera.y))
  (draw-world)´
  (love.graphics.pop)
  ;; Kamera-Rahmen
  (love.graphics.setColor 1 1 1)
  (love.graphics.rectangle "line" 0 0 Camera.w Camera.h))

(fn load []
 (print "GAME.LOAD: " (os.time))
  (love.window.setTitle "TEST")
  (love.window.setMode Camera.w Camera.h)
  (update-camera))

{:update update :draw draw :load load}
