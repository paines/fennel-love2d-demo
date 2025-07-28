;; --- Hilfsfunktionen und Konstanten ---
(local width 800)
(local height 600)
(local terrain-state {:width 256 :height 256 :data nil})
(local cam {:x (/ terrain-state.width 2) :y (/ terrain-state.height 2) :z 20 :angle 0 :pitch 0.5})

(local terrainmod (require :terrain))
;; Terrain-Alpha (Fog) Manipulation
(var fog-alpha-min 0.55)

;; Panzer-Ladefunktion importieren
(local {:load-tank load-tank} (require :load_tank))
;; Panzer-Modell laden (z.B. beim Start)
(var tank-mesh nil)


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

(fn generate-heightmap [w h]
  (let [arr {}
        freq 0.045 ; noch längere Wellen
        amp 18      ; noch kleinere Amplitude
        base-h 155]
    (for [x 0 (- w 1)]
      (tset arr x {})
      (for [y 0 (- h 1)]
        ;; Basis: Flachere Sinuswellen
        (let [base (+ (* (math.sin (* x freq)) amp)
                      (* (math.cos (* y freq)) amp))
              ;; Nur ein großer Peak, kleiner und weiter außen
              peak1 (let [dx (- x 180) dy (- y 180)]
                      (math.max 0 (- 30 (math.sqrt (+ (* dx dx) (* dy dy))))))
              noise (* (math.random) 2)
              h (math.max 0 (math.min 255 (+ base-h base peak1 noise)))]
          (tset (. arr x) y h))))
    {:data arr :width w :height h}))


(fn draw-terrain []
  (terrainmod.draw_terrain terrain-state.data cam width height fog-alpha-min))

(fn draw []
  (love.graphics.setBackgroundColor 0.55 0.75 1.0 1)
  (love.graphics.setColor 1 1 1 1)
  (love.graphics.print (.. "Pitch: " (tostring cam.pitch) "  Höhe: " (tostring cam.z)) 10 10)
  (draw-terrain)
  ;; Tank-Mesh als Wireframe rendern (robust)
  (when (and tank-mesh (= (type tank-mesh) "table")
             (. tank-mesh :meshes) (= (type (. tank-mesh :meshes)) "table")
             (> (# (. tank-mesh :meshes)) 0))
    (love.graphics.setColor 1 0 0 1)
    (love.graphics.print "Tank geladen! (Wireframe)" 10 30)
    (let [tank-x (/ terrain-state.width 2)
          tank-y (/ terrain-state.height 2)
          tank-z 0
          project
            (fn [vx vy vz]
              (let [scale 32
                    wx (- vx tank-x)
                    wy (- vy tank-y)
                    wz (- vz tank-z)
                    cx cam.x
                    cy cam.y
                    cz cam.z
                    pitch cam.pitch
                    angle cam.angle
                    dx (- wx (- cx tank-x))
                    dy (- wy (- cy tank-y))
                    dz (- wz (- cz tank-z))
                    rx (+ (* dx (math.cos angle)) (* dy (math.sin angle)))
                    ry (- (* dy (math.cos angle)) (* dx (math.sin angle)))
                    rz dz
                    py (+ (* ry (math.cos pitch)) (* rz (math.sin pitch)))
                    pz (- (* rz (math.cos pitch)) (* ry (math.sin pitch)))
                    sx (+ (/ width 2) (* rx scale))
                    sy (+ (/ height 2) (* py scale))]
                [sx sy]))]
      (for [i 1 (# (. tank-mesh :meshes))]
        (let [mesh (. (. tank-mesh :meshes) i)
              verts (and mesh (= (type mesh) "table") (. mesh :vertices))
              inds (and mesh (= (type mesh) "table") (. mesh :indices))]
          (when (and verts (= (type verts) "table") inds (= (type inds) "table") (> (# inds) 2))
            (for [f 1 (/ (# inds) 3)]
              (let [i1 (+ 1 (* 3 (- f 1)))
                    i2 (+ i1 1)
                    i3 (+ i1 2)
                    idx1 (or (. inds i1) 1)
                      idx2 (or (. inds i2) 1)
                      idx3 (or (. inds i3) 1)
                      v1 (or (. verts idx1) {[1] 0 [2] 0 [3] 0})
                      v2 (or (. verts idx2) {[1] 0 [2] 0 [3] 0})
                      v3 (or (. verts idx3) {[1] 0 [2] 0 [3] 0})
                      [x1 y1] (project (or (. v1 1) 0) (or (. v1 2) 0) (or (. v1 3) 0))
                      [x2 y2] (project (or (. v2 1) 0) (or (. v2 2) 0) (or (. v2 3) 0))
                      [x3 y3] (project (or (. v3 1) 0) (or (. v3 2) 0) (or (. v3 3) 0))]
                  (love.graphics.line x1 y1 x2 y2)
                  (love.graphics.line x2 y2 x3 y3)
                  (love.graphics.line x3 y3 x1 y1)))))))))


(fn load []

  (let [result (load-tank "PanzerIV/PanzerIV/PanzerIV_Body.fbx")]
    (print "GAME.FNL: result type: " (type result) " tostring: " (tostring result))
    (when (= (type result) "table")
      (set tank-mesh {:meshes result})))

  (let [tstate (generate-heightmap 256 256)
        mid-x (/ tstate.width 2)
        mid-y (/ tstate.height 2)]
    (tset terrain-state :data tstate.data)
    (tset terrain-state :width tstate.width)
    (tset terrain-state :height tstate.height)
    (tset cam :x mid-x)
    (tset cam :y mid-y)
    (tset cam :z 180)
    (tset cam :pitch -0.45)
    (tset cam :terrain_width tstate.width)
    (tset cam :terrain_height tstate.height))
  (love.window.setMode width height)
  (love.window.setTitle "Voxel Terrain Demo")
  (love.mouse.setRelativeMode false))


(fn update [dt]
  (let [speed (* 60 dt)
        turn-speed (* 1.5 dt)
        pitch-speed (* 0.8 dt)
        z-speed (* 20 dt)
        terrain-width terrain-state.width
        terrain-height terrain-state.height]
    (when (love.keyboard.isDown "a")
      (tset cam :angle (- cam.angle turn-speed)))
    (when (love.keyboard.isDown "d")
      (tset cam :angle (+ cam.angle turn-speed)))
    (when (love.keyboard.isDown "w")
      (do
        (tset cam :x (math.fmod (+ cam.x (* (math.cos cam.angle) speed)) terrain-width))
        (tset cam :y (math.fmod (+ cam.y (* (math.sin cam.angle) speed)) terrain-height))))
    (when (love.keyboard.isDown "s")
      (do
        (tset cam :x (math.fmod (- cam.x (* (math.cos cam.angle) speed)) terrain-width))
        (tset cam :y (math.fmod (- cam.y (* (math.sin cam.angle) speed)) terrain-height))))
    ;; Pitch mit Pfeiltasten steuern
    (when (love.keyboard.isDown "up")
      (tset cam :pitch (math.max -1 (- cam.pitch pitch-speed))))
    (when (love.keyboard.isDown "down")
      (tset cam :pitch (math.min 1 (+ cam.pitch pitch-speed))))
    ;; Höhe mit Q/E steuern
    (when (love.keyboard.isDown "q")
      (tset cam :z (math.max 1 (- cam.z z-speed))))
    (when (love.keyboard.isDown "e")
      (tset cam :z (math.min 500 (+ cam.z z-speed))))
    ;; Fog-Alpha mit U/I steuern
    (when (love.keyboard.isDown "u")
      (tset _G :fog-alpha-min (math.max 0.1 (- fog-alpha-min 0.01))))
    (when (love.keyboard.isDown "i")
      (tset _G :fog-alpha-min (math.min 1 (+ fog-alpha-min 0.01))))
    ;; Begrenzungen nach allen Bewegungen
    (tset cam :pitch (math.max -1 (math.min 1 cam.pitch)))
    (tset cam :x (math.fmod cam.x terrain-width))
    (tset cam :y (math.fmod cam.y terrain-height))
    (tset cam :z (math.max 1 (math.min 500 cam.z)))))

(fn mousemoved [x y dx dy istouch]
  (when (love.keyboard.isDown "lshift")
    (tset cam :pitch (math.max -1 (math.min 1 (+ cam.pitch (* dy 0.01)))))))

(fn keypressed [key scancode isrepeat]
  (print "KEYPRESSED!" key))

{:update update :draw draw :load load :mousemoved mousemoved :keypressed keypressed}