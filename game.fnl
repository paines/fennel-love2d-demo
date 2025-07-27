;; --- Hilfsfunktionen und Konstanten ---
(local width 800)
(local height 600)
(local terrain-state {:width 256 :height 256 :data nil})
(local cam {:x (/ terrain-state.width 2) :y (/ terrain-state.height 2) :z 20 :angle 0 :pitch 0.5})
(local terrainmod (require :terrain))

;; Rekursive Hilfsfunktion für Terrain-Rendering (jetzt mit var!)
(var depth-loop
  (fn [terrain terrain-width terrain-height screen-x angle depth max-screen-y]
    (when (<= depth 200)
      (let [dx (* (math.cos angle) depth)
            dy (* (math.sin angle) depth)
            map-x (math.floor (+ cam.x dx))
            map-y (math.floor (+ cam.y dy))]
        (if (and (>= map-x 0) (< map-x terrain-width)
                 (>= map-y 0) (< map-y terrain-height))
          (let [h (. (. terrain map-x) map-y)
                screen-y (math.floor (- height (* 0.7 h)))]
            (when (and (= screen-x 200) (<= depth 10))
              (love.graphics.setColor 1 1 0 1)
              (love.graphics.print (.. "d=" depth ", mx=" map-x ", my=" map-y ", h=" h ", y=" screen-y) 250 (+ 10 (* depth 12))))
            (when (and (= screen-x 200) (= h 100))
              (love.graphics.setColor 1 0 1 1)
              (love.graphics.line screen-x 100 screen-x 120))
            (if (< screen-y max-screen-y)
              (do
                (love.graphics.setColor 0 1 0 1)
                (love.graphics.line screen-x screen-y screen-x max-screen-y)
                (depth-loop terrain terrain-width terrain-height screen-x angle (+ depth 1) screen-y))
              (depth-loop terrain terrain-width terrain-height screen-x angle (+ depth 1) max-screen-y)))
          (depth-loop terrain terrain-width terrain-height screen-x angle (+ depth 1) max-screen-y))))))

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
  (terrainmod.draw_terrain terrain-state.data cam width height))

(fn draw []
  ;; Test: Zeichne ein weißes Rechteck oben links
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.rectangle "fill" 10 10 30 30)
  ;; Debug: Terrain-Status anzeigen
  (love.graphics.setColor 1 1 0 1)
  (love.graphics.print (.. "Terrain: " (tostring terrain-state.data)) 50 10)
  (let [first-x 0
        first-y 0
        first-row (. terrain-state.data first-x)
        first-val (and first-row (. first-row first-y))]
    (love.graphics.print (.. "T[0][0]: " (tostring first-val)) 50 30)
    (when (and first-val (> first-val 0))
      (love.graphics.setColor 1 0 0 1)
      (love.graphics.line 100 100 200 100)))
  (draw-terrain))

(fn load []
  (let [tstate (load-heightmap "heightmap.png")]
    (tset terrain-state :data tstate.data)
    (tset terrain-state :width tstate.width)
    (tset terrain-state :height tstate.height)
    (tset cam :x (/ terrain-state.width 2))
    (tset cam :y (/ terrain-state.height 2)))
  (love.window.setMode width height)
  (love.window.setTitle "Voxel Terrain Demo"))

(fn update [dt]
  ;; Helikopter/Kamera-Steuerung (z.B. mit Tasten)
  )

{:update update :draw draw :load load}