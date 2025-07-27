;; load_tank.fnl

;; Beispiel: 3D-Modell eines Panzers mit openfbx laden
(local openfbx (require :openfbx))

(fn load-tank [pfad]
  (let [result (openfbx.load pfad)]
    (if result
      (do
        (print "FBX geladen! Status: " (. result :status))
        result)
      (print "Fehler beim Laden des FBX!"))))

{:load-tank load-tank}
