local DevSyncCode = {}

function DevSyncCode:ctor()
  self.classInstances = {}
end

function DevSyncCode:addInstances(ins)
  table.insert(self.classInstances, ins)
end

function DevSyncCode:updateLuaCode(packageName)
  if packageName == nil or packageName == "" then
    return
  end
  local oldInfo = package.loaded[packageName]
  if oldInfo == nil then
    return
  end
  local package1 = package
  package.loaded[packageName] = nil
  local temp_G = {}
  for k, v in ipairs(package.loaded._G) do
    temp_G[k] = v
  end
  local newInfo
  
  local function requireUpdateLua(...)
    newInfo = require(packageName)
  end
  
  function tryCatch(fun)
    local ret, errMessage = pcall(fun)
    if ret == false then
      package.loaded[packageName] = oldInfo
      local _g = package.loaded._G
      for k, v in ipairs(temp_G) do
        if k ~= "CSBTableCache" then
          _g[k] = v
        end
      end
      print("\229\173\152\229\156\168\233\148\153\232\175\175\228\184\141\229\164\132\231\144\134:" .. packageName)
    elseif ret then
      local _g = package.loaded._G
      for k, v in ipairs(temp_G) do
        _g[k] = v
      end
      local tempInfo = {}
      if type(oldInfo) == "table" then
        for k, v in pairs(oldInfo) do
          if type(v) ~= "function" then
            tempInfo[k] = v
          else
            self:replaceEventManagerHandler(oldInfo, v, newInfo[k])
          end
        end
      end
      local infoType = type(newInfo)
      if infoType == "table" then
        for k, v in pairs(newInfo) do
          local typestr = type(v)
          if typestr == "function" then
            oldInfo[k] = v
          end
        end
        local currentInfo = oldInfo
        if newInfo.__ctype then
          package.loaded[packageName] = oldInfo
        else
          currentInfo = newInfo
        end
        for k, v in pairs(tempInfo) do
          if type(v) ~= "function" then
            currentInfo[k] = v
          end
        end
        if newInfo.__ctype == 1 then
          local delTable = {}
          for k, v in ipairs(__dscInstances__) do
            if not tolua.isnull(v) then
              local itype = type(v)
              if itype == "userdata" and iskindof(v, newInfo.__cname) then
                self:replaceInfo(v, newInfo)
              end
            else
              table.insert(delTable, v)
            end
          end
          self:delTables(__dscInstances__, delTable)
        end
      end
      print("\229\164\132\231\144\134\229\174\140\230\175\149:" .. packageName)
    end
  end
  
  tryCatch(requireUpdateLua)
end

return DevSyncCode
