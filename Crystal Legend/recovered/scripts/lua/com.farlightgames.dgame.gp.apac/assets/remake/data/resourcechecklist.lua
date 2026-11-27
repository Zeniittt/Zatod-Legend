module("ed", package.seeall)
local files_to_check = {}
ResourceCheckList = {}

local function getMd5String(file_name)
  local file_content = EDGetFileData(file_name)
  local sum = md5.sum(file_content)
  return string.gsub(sum, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
end

function _G.IsResouceCheckListValid()
  if next(ResourceCheckList) == nil then
    return false
  else
    return true
  end
end

function _G.CreateResourceCheckList()
  for _, file_name in ipairs(files_to_check) do
    local md5_string = getMd5String(file_name)
    ResourceCheckList[file_name] = md5_string
  end
  exportLuaModule("resource_check_list.txt", ResourceCheckList)
end

function _G.CheckResourceConsistency(name, md5)
  local md5_value = string.gsub(md5, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
  local result = true
  if ResourceCheckList[name] and md5_value ~= ResourceCheckList[name] then
    result = false
  end
  return result
end
