package.path = package.path .. ";../../lib/?.lua" .. ";../../lua/?.lua"
require("edebug")
require("tools")
require("datatable")
local encode_value

local function encode_table(writer, table, columnInfo, keyCnt)
  writer:write("{")
  if keyCnt == 0 then
    for i, v in ipairs(columnInfo) do
      if i ~= 1 then
        writer:write(",")
      end
      encode_value(writer, table[v], columnInfo, keyCnt - 1)
    end
  else
    local idx = 1
    for k, v in pairs(table) do
      if idx ~= 1 then
        writer:write(",\n")
      end
      writer:write("[")
      encode_value(writer, k, columnInfo, keyCnt - 1)
      writer:write("] = ")
      encode_value(writer, v, columnInfo, keyCnt - 1)
      idx = idx + 1
    end
  end
  writer:write("}")
end

function encode_value(writer, value, columnInfo, keyCnt)
  local t = type(value)
  if t == "table" then
    encode_table(writer, value, columnInfo, keyCnt)
  elseif t == "string" then
    writer:write(string.format("%q", value))
  else
    writer:write(tostring(value))
  end
end

local function encode_table_column(writer, columnInfo)
  writer:write("{")
  for i, v in ipairs(columnInfo) do
    if i ~= 1 then
      writer:write(",")
    end
    writer:write("[")
    encode_value(writer, v)
    writer:write("] = ")
    encode_value(writer, i)
  end
  writer:write("}")
end

local function exportLuaModule(file, table, columnInfo, keyCnt)
  local writer = io.open(file, "wb")
  writer:write("return {")
  encode_table(writer, table, columnInfo, keyCnt)
  writer:write(",\n")
  encode_table_column(writer, columnInfo)
  writer:write(",")
  writer:write("" .. keyCnt)
  writer:write("}")
  writer:close()
  return file
end

local csvFiles = {}
local lfs = require("lfs")
local folderPath = "../"
for file in lfs.dir(folderPath) do
  if file ~= "." and file ~= ".." then
    local filePath = folderPath .. "/" .. file
    if string.match(file, "%.csv$") then
      table.insert(csvFiles, filePath)
    end
  end
end
local filter_csv_dic = {
  StageBotResult = true,
  CrusadeServerData = true,
  ["DailyLoginReward\232\190\147\229\133\165"] = true,
  errorinfo_idn = true,
  WCA = true,
  errorinfo_taiwan = true,
  ChaosTowerSeason = true,
  TradeHouse = true,
  errorinfo_en = true,
  errorinfo_vietnam = true,
  ["Chest4Boss(O)"] = true,
  RechargGiftDefault = true,
  FiveBossProgress = true,
  MagicStoneGuide = true,
  errorinfo_euen = true,
  errorinfo = true,
  BooksCondition = true,
  errorinfo_thai = true,
  errorinfo_korea = true,
  errorinfo_jp = true,
  errorinfo_japanese = true,
  errorinfo_us = true,
  Tavern = true,
  BabelSwitch = true,
  DailyVariable = true,
  DailyVariable_ptr = true,
  DailyVariableSpecialLoot = true,
  DailyVariableSpecialLootDisplay = true,
  DailyVariableSpell = true,
  SummonCircle = true,
  AwakeDungeonMap = true,
  DailyVariable_global = true
}

local function export2Lua(table_name)
  if not filter_csv_dic[table_name] then
    local ret, columnInfo, keyCnt = ed.loadCSV1(string.format("../%s.csv", table_name))
    exportLuaModule("../../csvlua/" .. table_name .. ".lua", ret, columnInfo, keyCnt)
    print(table_name, "done!")
  end
end

if arg[1] then
  if arg[2] then
    local table_name = arg[2]
    export2Lua(table_name)
  else
    local file_content = EDGetFileData("./config.txt")
    for line in string.gmatch(file_content, "[^\r\n]*") do
      if line ~= "" then
        local table_name = line
        export2Lua(table_name)
      end
    end
  end
else
  for i, file in ipairs(csvFiles) do
    local table_name = string.match(file, ".+/([^/]*%.%w+)$")
    table_name = string.sub(table_name, 1, #table_name - 4)
    export2Lua(table_name)
  end
end
