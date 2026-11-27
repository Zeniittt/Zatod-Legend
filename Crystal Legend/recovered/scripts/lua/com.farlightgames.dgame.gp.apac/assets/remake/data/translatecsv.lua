local function formatcsvKey(ret, table_name)
  local csv_list = {
    SkillGroup = {
      level = 2,
      
      sourceColumn = "Display Name",
      keyColumn = "Caster Name",
      cha_list = {
        "\229\138\155\233\135\143\229\188\186\229\140\150",
        "\231\136\134\232\189\176",
        "\230\154\180\229\135\187"
      }
    }
  }
  local cfg = csv_list[table_name]
  if cfg then
    local function getValue(t, index)
      if index < (cfg.level or 1) then
        for k, v in pairs(t) do
          if type(v) == "table" then
            getValue(v, index + 1)
          end
        end
      end
      for k, v in pairs(t) do
        if v[cfg.sourceColumn] and ed.isElementInTable(v[cfg.sourceColumn], cfg.cha_list) then
          v[cfg.sourceColumn] = string.format("%s<key:%s>", v[cfg.sourceColumn], v[cfg.keyColumn])
        end
      end
    end
    
    getValue(ret, 1)
  end
end

ed.formatcsvKey = formatcsvKey

local function formatcsvStringKey(vv, table_name)
  local cha_list = {
    ["\230\178\137\233\187\152"] = {"Unit", "SkillGroup"},
    ["\230\189\174\230\177\144"] = {"Unit", "SkillGroup"},
    ["\229\183\168\233\173\148"] = {"Unit", "Tags"},
    ["\229\134\176\231\148\178"] = {"SkillGroup", "equip"}
  }
  if cha_list[vv] then
    local areaList = cha_list[vv]
    local area = string.gsub(table_name, ".csv", "")
    
    local function getArea()
      for k, v in ipairs(areaList) do
        if area == v then
          return area
        end
      end
      return areaList[1]
    end
    
    vv = string.format("%s<key:%s>", vv, getArea())
  end
  return vv
end

ed.formatcsvStringKey = formatcsvStringKey
local ignoredColumns = {
  equip = {
    "Consume Type"
  }
}
ed.ignoredColumns = ignoredColumns

local function formatDataTable(ret, table_name, key_map)
  if not ret then
    return
  end
  if table_name == "textconfig" then
    return
  end
  EDCurLanguage = EDCurLanguage or "cn"
  local ignoredColumns = ed.ignoredColumns[table_name]
  
  local function contains(columns)
    if ignoredColumns then
      for i, v in ipairs(ignoredColumns) do
        if v == columns then
          return true
        end
      end
    end
    return false
  end
  
  local function formatvv(vv, layer)
    local ltype = type
    local stringmatch = string.match
    local lt = T
    local formatcsvStringKey = ed.formatcsvStringKey
    for k, v in pairs(vv) do
      if ltype(v) == "table" then
        formatvv(v, layer + 1)
      elseif ltype(v) == "string" then
        if EDCurLanguage == "cn" then
          if stringmatch(v, "^<\230\179\168\233\135\138>") then
            vv[k] = ""
          end
        else
          local ignore = layer == 1 and contains(k)
          if not ignore and ed.textConfig and ed.checkChinese(vv[k]) then
            vv[k] = lt(vv[k])
          end
        end
      end
    end
  end
  
  formatvv(ret, 0)
end

ed.formatDataTable = formatDataTable
