package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("tools")
require("stringbuffer")
require("lfs")
require("debug.serialize")
local lfs = lfs
local allRes = {}
local useRes = {}
local unUseRes = {}
local unuseCount = 0

function testString()
  local match1 = "\"UI/.-\""
  local match2 = "\"installer/.-\""
  local resCount = 0
  
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
  
  local suffix_1 = "%.png$"
  local suffix_2 = "%.jpg$"
  
  local function getUseRes(path)
    local file = io.open(path, "r")
    local ct = file:read("*a")
    for str in string.gmatch(ct, match1) do
      resCount = resCount + 1
      local file = string.sub(str, 2, string.len(str) - 1)
      file = string.gsub(file, suffix_1, "")
      file = string.gsub(file, suffix_2, "")
      useRes[file] = true
    end
    for str in string.gmatch(ct, match2) do
      resCount = resCount + 1
      local file = string.sub(str, 2, string.len(str) - 1)
      file = string.gsub(file, suffix_1, "")
      file = string.gsub(file, suffix_2, "")
      useRes[file] = true
    end
  end
  
  local match_csv_1 = ",UI/.-,"
  local match_csv_2 = ",installer/.-,"
  
  local function getUseCsvRes(path)
    local file = io.open(path, "r")
    local ct = file:read("*a")
    for str in string.gmatch(ct, match_csv_1) do
      resCount = resCount + 1
      local file = string.sub(str, 2, string.len(str) - 1)
      file = string.gsub(file, suffix_1, "")
      file = string.gsub(file, suffix_2, "")
      useRes[file] = true
    end
    for str in string.gmatch(ct, match_csv_2) do
      resCount = resCount + 1
      local file = string.sub(str, 2, string.len(str) - 1)
      file = string.gsub(file, suffix_1, "")
      file = string.gsub(file, suffix_2, "")
      useRes[file] = true
    end
  end
  
  local function getAllRes(path)
    local file = string.gsub(path, suffix_1, "")
    file = string.gsub(file, suffix_2, "")
    allRes[file] = true
  end
  
  local function getResolutionAllRes(path)
    local start, iend = string.find(path, "iPhone/")
    local file = string.sub(path, iend + 1, string.len(path))
    file = string.gsub(file, suffix_1, "")
    file = string.gsub(file, suffix_2, "")
    allRes[file] = true
  end
  
  local function getUnuseRes()
    for i, v in pairs(allRes) do
      if not useRes[i] then
        unuseCount = unuseCount + 1
        unUseRes[i] = true
      end
    end
    local sortedRes = {}
    for i, v in pairs(unUseRes) do
      table.insert(sortedRes, i)
    end
    table.sort(sortedRes, function(a, b)
      return a < b
    end)
    local file = io.open("resourc_check_result.txt", "w")
    if file then
      ed.exportLuaModule(file, sortedRes)
    end
  end
  
  local luaDir = "lua"
  local csvDir = "csv"
  visit_folder_tree(luaDir, getUseRes)
  visit_folder_tree(csvDir, getUseCsvRes)
  local resDir = "UI"
  local resDir2 = "installer"
  local resDir3 = "../resolutions/iPhone/UI/alpha/HVGA"
  visit_folder_tree(resDir, getAllRes)
  visit_folder_tree(resDir2, getAllRes)
  getUnuseRes()
  print("unuseCount:" .. unuseCount)
end

testString()
