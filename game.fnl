(local width 400)
(local height 300)
(local terrain
  (let [arr {}]
    (for [i 1 width]
      (tset arr i (+ 100 (* 50 (math.sin (/ i 20))))))
    arr))
(local heli {:x 50 :y 50 :vy 0})

(fn update [dt]
  (when (love.keyboard.isDown "right") (tset heli :x (+ heli.x (* 100 dt))))
  (when (love.keyboard.isDown "left") (tset heli :x (- heli.x (* 100 dt))))
  (when (love.keyboard.isDown "up") (tset heli :vy (- heli.vy (* 200 dt))))
  (when (love.keyboard.isDown "down") (tset heli :vy (+ heli.vy (* 200 dt))))
  (tset heli :y (+ heli.y (* heli.vy dt)))
  (tset heli :vy (* heli.vy 0.98))) ; Dämpfung

(fn draw-world []
  (love.graphics.setColor 0.3 0.8 0.3)
  (for [i 1 width]
    (love.graphics.line i height i (- height (. terrain i)))))

(fn draw []
  (draw-world)
  (love.graphics.setColor 1 1 0)
  (love.graphics.rectangle "fill" heli.x (- height heli.y) 20 10))

(fn load []
  (love.window.setMode width height)
  (love.window.setTitle "Helikopter über Terrain"))

{:update update :draw draw :load load}
