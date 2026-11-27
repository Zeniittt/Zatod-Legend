module("ed", package.seeall)
ResourceNameBlackList = {}
ResourceMd5BlackList = {}

local function getMd5String(file_name)
  local file_content = EDGetFileData(file_name)
  local sum = md5.sum(file_content)
  return string.gsub(sum, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
end

function createResourceMd5BlackList()
  local black_list = {}
  for _, file_name in ipairs(ResourceNameBlackList) do
    local md5_string = getMd5String(file_name)
    ResourceMd5BlackList[md5_string] = true
    black_list[file_name] = md5_string
  end
  exportLuaModule("resource_md5_black_list.txt", black_list)
end
