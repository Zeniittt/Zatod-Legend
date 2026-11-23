require("edebug")
require("lfs")
local lfs = lfs
local assetsPath = EDFilePath:getInstance():getAssetsPath()
print("assetsPath", assetsPath)
local animdura = {}
local animatkfram = {}

local function visit_folder_tree(dir, visitor)
  for entry in lfs.dir(dir) do
    if entry == "." or entry == ".." then
    else
      local path = dir .. "/" .. entry
      local mode = lfs.attributes(path, "mode")
      if mode == "directory" then
        visit_folder_tree(path, visitor)
      else
        visitor(path)
      end
    end
  end
end

local function set_animdura(sp_name, ani_name, duration)
  if not animdura[sp_name] then
    animdura[sp_name] = {}
  end
  animdura[sp_name][ani_name] = {Duration = duration}
end

local function get_atkframe_xy(ani_name, evt_time, atkFrames)
  if atkFrames and atkFrames.framecount > 0 then
    print("attack ani name:", ani_name)
    print("attack evt time:", evt_time)
    local cnt = atkFrames.framecount
    for i = 1, cnt do
      local atkFrame = atkFrames:getFrame(i - 1)
      if math.abs(atkFrame.time - evt_time) < 1.0E-4 then
        print("atk frame time:", atkFrame.time)
        print(atkFrame.x, atkFrame.y)
        return atkFrame.x, atkFrame.y
      end
    end
  end
  return 0, 0
end

local function set_animatkfram(sp_name, ani_name, evt_name, evt_time, atkFrames)
  if evt_name ~= "Attack" then
    return
  end
  local x, y = get_atkframe_xy(ani_name, evt_time, atkFrames)
  if not animatkfram[sp_name] then
    animatkfram[sp_name] = {}
  end
  if not animatkfram[sp_name][ani_name] then
    animatkfram[sp_name][ani_name] = {}
  end
  table.insert(animatkfram[sp_name][ani_name], {
    Time = evt_time,
    X = x or 0,
    Y = y or 0
  })
end

local function loadInfo(name)
  print("loadInfo", name)
  local fcaSpInfo = EDFcaSpInfo:getFcaInfo(name, 1, 1)
  local aniInfo = fcaSpInfo:getAnimationInfo()
  for i = 1, aniInfo.aniCount do
    local ani = aniInfo:getFcaSpAni(i - 1)
    set_animdura(name, ani.name, ani.duration)
    local atkFrames = fcaSpInfo:getAtkFrameInfo(ani.name)
    for j = 1, ani.evtCount do
      local evt = ani:getFcaSpAniEvt(j - 1)
      set_animatkfram(name, ani.name, evt.name, evt.time, atkFrames)
    end
  end
end

local function make(path)
  local isEff = string.match(path, "%/spine/effect/eff_")
  if isEff then
    return
  end
  local isJson = string.match(path, "%.json$")
  if not isJson then
    return
  end
  local lastSlashIndex = string.match(path, ".*/")
  if not lastSlashIndex then
    print("error:" .. path)
    return
  end
  local name = string.sub(path, string.len(lastSlashIndex) + 1, -6)
  loadInfo(name)
end

local function exportCSV()
  local filePath = assetsPath .. "/csv/AnimDurationSp.csv"
  local file = io.open(filePath, "w")
  local durationSpList = {}
  file:write("KS,KS,N\n")
  file:write("Cha,Action,Duration\n")
  for k, v in pairs(animdura) do
    for kk, vv in pairs(v) do
      if vv.Duration then
        file:write(string.format("%s.sp,%s,%f\n", k, kk, vv.Duration))
        table.insert(durationSpList, {
          Cha = k,
          Action = kk,
          Duration = vv.Duration
        })
      end
    end
  end
  file:close()
  local filePath = assetsPath .. "/csv/AnimAtkFrameSp.csv"
  local file = io.open(filePath, "w")
  local atkFrameSpList = {}
  file:write("KS,KS,KN,N,N\n")
  file:write("Cha,Action,Time,X,Y\n")
  for k, v in pairs(animatkfram) do
    for kk, vv in pairs(v) do
      for _, row in pairs(vv) do
        if row.Time then
          file:write(string.format("%s.sp,%s,%f,%f,%f\n", k, kk, row.Time, row.X or 0, row.Y or 0))
          table.insert(atkFrameSpList, {
            Cha = k,
            Action = kk,
            Time = row.Time,
            X = row.X or 0,
            Y = row.Y or 0
          })
        end
      end
    end
  end
  FireEvent("SpineExportCsvSuccess", {durationSpList = durationSpList, atkFrameSpList = atkFrameSpList})
  file:close()
end

local function main()
  animdura = {}
  animatkfram = {}
  local path = assetsPath .. "/spine"
  visit_folder_tree(path, make)
  exportCSV()
end

function ed.export_spine(...)
  xpcall(function()
    main()
  end, EDDebug)
end
