local data = {}
ed.presetData = data
data.preseTeamInfo = {
  {},
  {},
  {},
  {}
}
data.preseAllInfo = {}
data.preseAllKeyToIdx = {}
data.preseBitNum = 16
data.preseMaxTeam = 40
data.teamNum = 0

function data.analyzePreseIds(id)
  local groupId = ed.bits(id, 0, data.preseBitNum)
  local indexId = ed.bits(id, data.preseBitNum, data.preseBitNum)
  indexId = indexId == 0 and 1 or indexId
  return indexId, groupId
end

function data.packPreseIds(indexId, groupId)
  if 65535 < indexId or 65535 < groupId then
    ed.showToast(T("\233\162\132\232\174\190\233\152\181\229\174\185\232\191\135\229\164\154"))
    return
  end
  return ed.makebits(data.preseBitNum, indexId, data.preseBitNum, groupId)
end

function data.setPreseInitInfo(info)
  data.preseAllInfo = {}
  data.teamNum = 0
  for i, v in ipairs(ed.copyProto(info)) do
    local indexId, groupId = data.analyzePreseIds(v._id)
    data.preseAllInfo[groupId] = data.preseAllInfo[groupId] or {}
    table.insert(data.preseAllInfo[groupId], {
      indexId = indexId,
      name = v._name,
      heros = v._hero_ids
    })
    data.preseAllKeyToIdx[groupId] = data.preseAllKeyToIdx[groupId] or {}
    data.preseAllKeyToIdx[groupId][indexId] = true
    data.teamNum = data.teamNum + 1
  end
end

function data.canAdd()
  return data.preseMaxTeam > data.teamNum
end

function data.refreshPreseInfo(info)
  if info.setLineup then
    info = info.setLineup
    local indexId, groupId = data.analyzePreseIds(info.idx)
    data.preseAllKeyToIdx[groupId] = data.preseAllKeyToIdx[groupId] or {}
    data.preseAllInfo[groupId] = data.preseAllInfo[groupId] or {}
    if data.preseAllKeyToIdx[groupId][indexId] then
      for i, v in ipairs(data.preseAllInfo[groupId]) do
        if v.indexId == indexId then
          v.name = info.name
          v.heros = info.heros
        end
      end
    else
      table.insert(data.preseAllInfo[groupId], {
        indexId = indexId,
        name = info.name,
        heros = info.heros
      })
      data.preseAllKeyToIdx[groupId][indexId] = true
      data.teamNum = data.teamNum + 1
    end
  elseif info.deleteLineup then
    info = info.deleteLineup
    local indexId, groupId = data.analyzePreseIds(info.idx)
    for i, v in ipairs(data.preseAllInfo[groupId]) do
      if v.indexId == indexId then
        table.remove(data.preseAllInfo[groupId], i)
        break
      end
    end
    data.preseAllKeyToIdx[groupId][indexId] = nil
    data.teamNum = data.teamNum - 1
  elseif info.switchLineup then
    local idx1 = info.switchLineup.idx1
    local idx2 = info.switchLineup.idx2
    local indexId1, groupId1 = data.analyzePreseIds(idx1)
    local indexId2, groupId2 = data.analyzePreseIds(idx2)
    local team1 = data.getPreseInfo(groupId1, indexId1)
    local team2 = data.getPreseInfo(groupId2, indexId2)
    data.setPresetInfo(groupId1, indexId1, team2)
    data.setPresetInfo(groupId2, indexId2, team1)
  end
end

function data.getPreseInfo(groupId, indexId)
  local tabs = ed.copyTable(data.preseAllInfo[groupId] or {})
  if indexId then
    for i, v in ipairs(tabs) do
      if v.indexId == indexId then
        return v
      end
    end
    return {}
  end
  return tabs
end

function data.setPresetInfo(groupId, indexId, info)
  for _, v in ipairs(data.preseAllInfo[groupId] or {}) do
    if v.indexId == indexId then
      v.name = info.name
      v.heros = info.heros
    end
  end
end

function data.getPreseTeamInfo(groupId, indexId)
  local tabs = data.getPreseInfo(groupId, indexId)
  return {
    tabs.heros or {},
    {},
    {},
    {}
  }, tabs
end

function data.getPreseTeamNewIndexId(groupId)
  local tabs = data.preseAllKeyToIdx[groupId] or {}
  for i = 1, 65535 do
    if not tabs[i] then
      return i
    end
  end
end

function data.InitHeroListData()
  local serverTime = ed.getServerTime()
  local heroes = {}
  for _, hero in pairs(ed.player:getAllHero() or {}) do
    local datas = hero.data
    if datas and datas._tid and ed.readhero.isHeroOpen(datas._tid, serverTime) then
      local heroInfo = ed.copyProto(datas)
      heroInfo._gs = heroInfo._gs or 5
      table.insert(heroes, heroInfo)
    end
  end
  table.sort(heroes, ed.cmpSort({
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {
      getValue = function(hero)
        local aInitStar = ed.getDataTable("Unit")[hero._tid]["Initial Stars"]
        return aInitStar
      end,
      reverse = true
    },
    {key = "_gs", reverse = true},
    {key = "_tid"}
  }))
  local idToIndex = {}
  local unit = ed.getDataTable("Unit")
  for i, v in ipairs(heroes) do
    local pos = unit[v._tid]["Position Type"]
    local isTitan = unit[v._tid].IsTitan
    if pos == T("\229\137\141\230\142\146") then
      v.category = "front"
    elseif pos == T("\228\184\173\230\142\146") then
      v.category = "middle"
    elseif pos == T("\229\144\142\230\142\146") then
      v.category = "back"
    end
    if isTitan then
      v.isTitan = true
    end
    idToIndex[v._tid] = i
  end
  return heroes, idToIndex
end
