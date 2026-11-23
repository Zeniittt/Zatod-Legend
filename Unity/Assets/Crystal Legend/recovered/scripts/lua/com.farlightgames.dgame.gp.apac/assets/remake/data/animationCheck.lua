package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("tools")

local function scandirwin(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen("dir \"" .. directory .. "\" /b"):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

local function checkPuppetChangeCompentValid(foladName)
  for id, info in pairs(ed.getDataTable("Puppet")) do
    local itemInfo = info
    local resource = itemInfo.Resource
    local changeCompents = itemInfo["Change Components"]
    if changeCompents then
      local _foladName = foladName .. resource
      local file = scandirwin(_foladName)
      local component
      for index = 1, #changeCompents do
        local bFindResource = false
        component = changeCompents[index] .. ".png"
        for i = 1, #file do
          if component == file[i] then
            bFindResource = true
            break
          end
        end
        if not bFindResource then
          print("change component not valid -> " .. component .. " not found in " .. resource)
        end
      end
    end
  end
end

xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  require("resource_manager")
  require("datatable")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/rechargemetatable")
  checkPuppetChangeCompentValid("./fca/")
end, EDDebug)
