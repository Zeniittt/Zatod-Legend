require("lfs")
local lfs = lfs
local os_remove = os.remove

function os.exists(path)
  local attr = lfs.attributes(path)
  if attr == nil then
    return false
  end
  return true
end

function os.mkdir(path)
  if not os.exists(path) then
    return lfs.mkdir(path)
  end
  return true
end

function os.rmdir(path)
  if os.exists(path) then
    local function _rmdir(path)
      local iter, dir_obj = lfs.dir(path)
      
      while true do
        local dir = iter(dir_obj)
        if dir == nil then
          break
        end
        if dir ~= "." and dir ~= ".." then
          local curDir = path .. dir
          local mode = lfs.attributes(curDir, "mode")
          if mode == "directory" then
            _rmdir(curDir .. "/")
          elseif mode == "file" then
            os_remove(curDir)
          end
        end
      end
      local succ, des = os_remove(path)
      if des then
        print(des)
      end
      return succ
    end
    
    _rmdir(path)
  end
  return true
end

function os.cldir(path)
  if os.exists(path) then
    local function _rmdir(path)
      local iter, dir_obj = lfs.dir(path)
      
      while true do
        local dir = iter(dir_obj)
        if dir == nil then
          break
        end
        if dir ~= "." and dir ~= ".." then
          local curDir = path .. dir
          local mode = lfs.attributes(curDir, "mode")
          if mode == "directory" then
            _rmdir(curDir .. "/")
          elseif mode == "file" then
            os_remove(curDir)
          end
        end
      end
    end
    
    _rmdir(path)
  end
  return true
end
