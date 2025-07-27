-- Lurker: https://github.com/rxi/lurker
-- Kopiere diese Datei in dein Projektverzeichnis
local lurker = {}

lurker.path = "."
lurker.interval = 1
lurker.last = {}
lurker.callbacks = {}

local function get_modtime(path)
  local attr = io.popen("stat -f %m " .. path):read("*n")
  return attr
end

local function get_native_files(path)
  local files = {}
  for file in io.popen('ls "'..path..'"'):lines() do
    table.insert(files, file)
  end
  return files
end

function lurker.scan()
  -- print("[Lurker] Absoluter Pfad:", love.filesystem.getWorkingDirectory() .. "/" .. lurker.path)
  local changed = false
  local items = get_native_files(lurker.path)
  -- print("[Lurker] Dateien im Verzeichnis:", #items)
  for _, file in ipairs(items) do
    -- print("[Lurker] Datei gefunden:", file)
    if file:match("%.lua$") then
      local modtime = get_modtime(file)
      if modtime and (not lurker.last[file] or lurker.last[file] ~= modtime) then
        lurker.last[file] = modtime
        changed = true
        -- print("Lurker erkennt Änderung an:", file)
      end
    end
  end
  if changed then
    for _, cb in ipairs(lurker.callbacks) do cb() end
  end
end

function lurker.update()
  if not lurker._timer then lurker._timer = 0 end
  lurker._timer = lurker._timer + love.timer.getDelta()
  if lurker._timer > lurker.interval then
    lurker._timer = 0
    lurker.scan()
  end
end

function lurker.postreload(cb)
  table.insert(lurker.callbacks, cb)
end

return lurker
