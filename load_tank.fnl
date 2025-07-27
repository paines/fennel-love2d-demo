;; load_tank.fnl
(local openfbx (require :openfbx))

(print "openfbx require: " openfbx (type openfbx))

(fn load-tank [pfad]
  (print "Vor openfbx.load")
  (print "openfbx.load: " openfbx.load (type openfbx.load))
  (let [[result err] (openfbx.load pfad)]
    (print "Nach openfbx.load")
    (print "RESULT-TYPE: " (type result) "TOSTRING: " (tostring result))
    (print "ERR-TYPE: " (type err) "TOSTRING: " (tostring err))
    result))

{:load-tank load-tank}
