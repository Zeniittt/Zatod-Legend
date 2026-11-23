local ed = ed
local unit = ed.Unit
ed.openAsyncLoad = true
ed.testAsyncLoad = false

function ed.isOpenAsyncLoad()
  return ed.openAsyncLoad
end

if ed.isOpenAsyncLoad() then
  CCResourceManager:sharedResourceManager():setPerFramePushSize(20)
end
local asyncload = {
  isdDirty = false,
  isCompleted = true,
  listener = nil
}
ed.asyncload = asyncload

function asyncload.preloadByList(list)
  for _, obj in pairs(list) do
    local type = obj.type
    local res = obj.res
    if type == "image" then
      asyncload.preloadImageByName(res)
    elseif type == "plist" then
      asyncload.preloadPlistByName(res)
    elseif type == "fca" then
      asyncload.preloadFcaByName(res)
    elseif type == "id" then
      asyncload.preloadFcaByUnitID(res)
    elseif type == "stage" then
      asyncload.preloadFcaOfStage(res)
    end
  end
end

function asyncload.preloadImageByName(name)
  if not name or name == "" then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  CCResourceManager:sharedResourceManager():addImageAsync(name, nil)
  asyncload.isdDirty = true
end

function asyncload.preloadPlistByName(name)
  if not name or name == "" then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  CCResourceManager:sharedResourceManager():addPlistAsync(name)
  asyncload.isdDirty = true
end

local scaleFactor = 1.5625

function asyncload.preloadFcaByName(name)
  if not name or name == "" or not ed.isOpenAsyncLoad() then
    return
  end
  if string.match(name, "%.sp$") then
    asyncload.preloadFcaSpByName(name)
    return
  end
  local isUI = string.match(name, "^eff_UI")
  local fcaScale = ed.cha_scale
  if isUI then
    name = "effect/" .. name
    fcaScale = ed.cha_ui_scale
  end
  name = string.gsub(name, ".cha", "")
  CCResourceManager:sharedResourceManager():addFcaAsync(name, fcaScale)
  asyncload.isdDirty = true
end

function asyncload.preloadFcaSpByName(name)
  if not ed.isSupportFcaSpine() then
    return
  end
  if not name or name == "" or not ed.isOpenAsyncLoad() then
    return
  end
  local isUI = string.match(name, "^eff_UI")
  local fcaScale = 1
  local texCnt = 1
  name = string.gsub(name, ".sp", "")
  CCResourceManager:sharedResourceManager():addFcaSpAsync(name, fcaScale, texCnt)
  asyncload.isdDirty = true
end

function asyncload.preloadFcaByUnitID(playerID, onlyActor)
  if playerID == nil or playerID <= 0 then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  local puppetId = ed.getUnitPuppet(playerID)
  local puppetRes = ed.getPuppetResource(puppetId)
  if onlyActor then
    asyncload.preloadFcaByName(puppetRes)
  else
    asyncload.preloadFcaByName(puppetRes)
    asyncload.preloadHeroEffect(playerID)
  end
  asyncload.isdDirty = true
end

function asyncload.preloadChessHeroEffect(playerID)
  local tabskills = ed.getDataTable("ChessSkill")
  if ed.getChessUnitType(playerID) == "Hero" then
    local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, playerID)
    if skillGroupInfo and skillGroupInfo[1] then
      local skillId = skillGroupInfo[1].none["Skill Group ID"]
      local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0)
      if skillInfo then
        asyncload.preloadUnitSkillInfo(skillInfo)
      end
    end
  end
end

function asyncload.preloadFcaByChessUnitID(playerID)
  if playerID == nil or playerID <= 0 then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  local tb = ed.getDataTable("ChessUnit")
  local puppet = ed.recoverColum(tb[playerID].Puppet)
  local info = ed.lookupDataTable("Puppet", nil, puppet)
  local playerName = info.Resource
  asyncload.preloadFcaByName(playerName)
  asyncload.preloadChessHeroEffect(playerID)
  asyncload.isdDirty = true
end

function asyncload.preloadHeroEffect(playerID)
  local tabskills = ed.getDataTable("Skill")
  if ed.getUnitType(playerID) == "Hero" then
    for i = 0, 9 do
      local index = tonumber(playerID .. i)
      local skill = tabskills[index]
      if skill then
        asyncload.preloadUnitSkill(skill)
      end
    end
  end
end

function asyncload.preloadUnitSkill(skill)
  if not skill then
    return
  end
  local info = skill[0]
  if not info then
    return
  end
  unit.preloadCha(info["Launch Effect"])
  unit.preloadCha(info["Point Effect"])
  unit.preloadCha(info["Impact Effect"])
  unit.preloadCha(info["Chain Effect"])
  local art = info["Tile Art"]
  if art and string.match(art, "%.png$") then
    ed.getSpriteFrame(art)
  elseif art then
    unit.preloadCha(art)
  end
end

function asyncload.preloadUnitSkillInfo(skillInfo)
  if not skillInfo then
    return
  end
  unit.preloadCha(skillInfo["Launch Effect"])
  unit.preloadCha(skillInfo["Point Effect"])
  unit.preloadCha(skillInfo["Impact Effect"])
  unit.preloadCha(skillInfo["Chain Effect"])
  local art = skillInfo["Tile Art"]
  if art and string.match(art, "%.png$") then
    ed.getSpriteFrame(art)
  elseif art then
    unit.preloadCha(art)
  end
end

function asyncload.preloadFcaOfTowerStage(stage)
  if stage == nil or stage <= 0 then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  local enemyNum = 5
  local tabBattle = ed.getDataTable("FancyTowerBattle")
  local tBattle = tabBattle[stage]
  for _, obj in pairs(tBattle) do
    for j = 1, enemyNum do
      local enemyIdentify = "Monster " .. j .. " ID"
      local enemyID = obj[enemyIdentify]
      asyncload.preloadFcaByUnitID(enemyID)
    end
  end
end

function asyncload.preloadFcaOfActivityAdventure(stage)
  if stage == nil or stage <= 0 then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  local enemyNum = 5
  local tabBattle = ed.getDataTable("ActivityAdventureBattle")
  local tBattle = tabBattle[stage]
  for _, obj in pairs(tBattle) do
    for j = 1, enemyNum do
      local enemyIdentify = "Monster " .. j .. " ID"
      local enemyID = obj[enemyIdentify]
      if enemyID and enemyID ~= 0 then
        asyncload.preloadFcaByUnitID(enemyID)
      end
    end
  end
end

function asyncload.preloadFcaOfStage(stage)
  if stage == nil or stage <= 0 then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  local enemyNum = 5
  local tabBattle = ed.getDataTable("Battle")
  local tBattle = tabBattle[stage]
  for _, obj in pairs(tBattle or {}) do
    for j = 1, enemyNum do
      local enemyIdentify = "Monster " .. j .. " ID"
      local enemyID = obj[enemyIdentify]
      if EDEngineVersion() >= 4 then
        asyncload.preloadFcaByUnitID(enemyID)
      end
    end
  end
end

function asyncload.preloadFcaOfCrusade(stage)
  if stage == nil or -2 <= stage then
    return
  end
  if not ed.isOpenAsyncLoad() then
    return
  end
  stage = -2 - stage
  local herosIdList = ed.getLocalHerosIdList(stage)
  for _, id in pairs(herosIdList) do
    asyncload.preloadFcaByUnitID(id)
  end
end

function asyncload.preloadFcaOfHeroList(herolist)
  if not herolist then
    return
  end
  for _, hero in pairs(herolist) do
    asyncload.preloadFcaByUnitID(hero._tid)
  end
end

function ed.getLocalHerosIdList(selectStage)
  local herosIdList = {}
  for i = 1, 5 do
    local index = (selectStage - 1) * 5 + i
    local sId = string.format("tbcHero%d", index)
    local id = ed.storage.getInt(sId)
    table.insert(herosIdList, id)
  end
  return herosIdList
end

function asyncload.preloadInBattlePrepare(info)
  local mode = info.mode
  local stage = info.stage_id
  local pvpMode = info.pvpMode
  local enemyHeros = info.enemyHeros
  if mode == "crusade" then
    asyncload.preloadFcaOfCrusade(stage)
  elseif mode == "tower" then
    asyncload.preloadFcaOfHeroList(enemyHeros)
  elseif pvpMode == "attack" and stage == -1 then
    asyncload.preloadFcaOfHeroList(enemyHeros)
  elseif mode == "FancyTower" then
    asyncload.preloadFcaOfTowerStage(stage)
  elseif mode == "FancyAbyss" then
  elseif mode == "ActivityAdventure" then
    asyncload.preloadFcaOfActivityAdventure(stage)
  elseif stage and 0 < stage then
    asyncload.preloadFcaOfStage(stage)
  end
end

function asyncload.preloadInEnterGame()
  local preloadList = {}
  local buildingConfigs = ed.ui.configs.mainSceneMap.buildingsConfigs
  for _, item in pairs(buildingConfigs) do
    if item then
      if item.res then
        table.insert(preloadList, {
          type = "fca",
          res = item.res
        })
      end
      if item.titlePressres then
        table.insert(preloadList, {
          type = "image",
          res = item.titlePressres
        })
      end
    end
  end
  local sceneEffectsConfigs = ed.ui.configs.mainSceneMap.sceneEffectsConfigs
  for _, item in ipairs(sceneEffectsConfigs) do
    if item.res then
      table.insert(preloadList, {
        type = "fca",
        res = item.res
      })
    end
  end
  local layerCfgs = ed.ui.configs.mainSceneMap.mapLayersConfigs
  for _, item in pairs(layerCfgs) do
    for _, cmp in pairs(item.commponents) do
      if cmp.res then
        local obj = {
          type = "image",
          res = cmp.res
        }
        table.insert(preloadList, obj)
      end
    end
  end
  asyncload.preloadByList(preloadList)
end

function asyncload.update()
  if not asyncload.isdDirty then
    return
  end
  asyncload.isCompleted = CCResourceManager:sharedResourceManager():isCompleted()
  if asyncload.isCompleted then
    asyncload.isdDirty = false
    if asyncload.listener then
      asyncload.listener()
      asyncload.unregistLoadingListener()
    end
  end
end

function asyncload.update()
  if not asyncload.isdDirty then
    return
  end
  asyncload.isCompleted = CCResourceManager:sharedResourceManager():isCompleted()
  if asyncload.isCompleted then
    asyncload.isdDirty = false
    if asyncload.listener then
      asyncload.listener()
      asyncload.unregistLoadingListener()
    end
  end
end

function asyncload.registLoadingListener(func)
  asyncload.listener = func
end

function asyncload.unregistLoadingListener()
  asyncload.listener = nil
end
