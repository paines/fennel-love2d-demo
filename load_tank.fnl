;; load_tank.fnl
(local openfbx (require :openfbx))

(print "openfbx require: " openfbx (type openfbx))


(fn load-tank [pfad]
  (print "Vor openfbx.load")
  (print "openfbx.load: " openfbx.load (type openfbx.load))

  (let [result (openfbx.load pfad)]
    (print "Nach openfbx.load")
    (print "DEBUG: result=" result "type=" (type result) "tostring=" (tostring result))
    (print "RESULT-TYPE: " (type result) "TOSTRING: " (tostring result))
    (if (= (type result) "table")
      result
      (do
        (print "FBX-Fehler: Kein Table zurückgegeben!" result)
        nil))))

{:load-tank load-tank}
