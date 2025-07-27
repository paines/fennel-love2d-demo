(local width 400)
(local height 300)
(local terrain-state {:width 256 :height 256 :data nil})

(local cam {:x 128 :y 64 :z 40 :angle 0})

(fn load-heightmap [filename]
  (let [img (love.image.newImageData filename)
        imgw (img:getWidth)
        imgh (img:getHeight)
        arr {}]
    (for [x 0 (- imgw 1)]
      (tset arr x {})
      (for [y 0 (- imgh 1)]
        (let [r (select 1 (img:getPixel x y))]
          (tset (. arr x) y (* r 255))))) ; Höhe von 0-255
    {:data arr :width imgw :height imgh}))

(fn draw-terrain []
  (let [terrain terrain-state.data
        terrain-width terrain-state.width
        terrain-height terrain-state.height]
    (for [screen-x 0 (- width 1)]
      (let [angle (+ cam.angle (* (- screen-x (/ width 2)) 0.005))]
        (local max-screen-y height)
        (for [depth 1 200]
          (let [dx (* (math.cos angle) depth)
                dy (* (math.sin angle) depth)
                map-x (math.floor (+ cam.x dx))
                map-y (math.floor (+ cam.y dy))]
            (when (and (>= map-x 0) (< map-x terrain-width)
                       (>= map-y 0) (< map-y terrain-height))
              (let [h (. (. terrain map-x) map-y)
                    screen-y (math.floor (- cam.z (* 0.5 h) (/ 100 depth)))]
                (when (< screen-y max-screen-y)
                  (love.graphics.setColor 0.2 0.8 0.2 (* 1.0 (- 1 (/ depth 200))))
                  (love.graphics.line screen-x screen-y screen-x max-screen-y)
                  (set! max-screen-y screen-y))))))))))

(fn draw []
  (draw-terrain))

(fn load []
  (let [tstate (load-heightmap "heightmap.png")]
    (tset terrain-state :data tstate.data)
    (tset terrain-state :width tstate.width)
    (tset terrain-state :height tstate.height))
  (love.window.setMode width height)
  (love.window.setTitle "Voxel Terrain Demo"))

(fn update [dt]
  ;; Helikopter/Kamera-Steuerung (z.B. mit Tasten)
  )

{:update update :draw draw :load load}