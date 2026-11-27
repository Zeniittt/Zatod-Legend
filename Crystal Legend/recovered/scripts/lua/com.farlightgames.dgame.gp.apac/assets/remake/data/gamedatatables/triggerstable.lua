local guildhero_max_level = 100

function ed.checkTriggers(id, param)
  local tb = ed.getDataTable("Triggers")
  local row = tb[id]
  local type = row["Trigger Type"]
  local condition = row["Trigger Condition"]
  if type == "CompleteStage" then
    if ed.player:getStageStar(condition) <= 0 then
      return false
    end
  elseif type == "PlayerLevel" then
    if condition > ed.player:getLevel() then
      return false
    end
  elseif type == "HaveItem" then
    if ed.player:getEquipAmount(condition) == 0 then
      return false
    end
  elseif type == "TowerComplete" then
    if condition > ed.player:getLevel() then
      return false
    end
  elseif type == "StartTime" then
    if condition > ed.getServerTime() then
      return false
    end
  elseif type == "EndTime" then
    if condition < ed.getServerTime() then
      return false
    end
  elseif type == "QuestBoardLevel" then
    if condition > ed.player:getQuestBuildingLevel() then
      return false
    end
  elseif type == "Mentorship" then
    if condition > ed.player:getLevel() then
      return false
    end
  elseif type == "PlatformID" then
    if EDSDKType ~= condition then
      return false
    end
  elseif type == "HaveTitan98" then
    local count = 0
    local tbl = ed.getDataTable("TitanToHeros")
    for id, info in pairs(tbl) do
      if id ~= "name" and tonumber(id) and 0 == info.MatrixHeroID1 then
        local hero = ed.player:getHero(id)
        if hero then
          count = count + 1
        end
      end
    end
    return condition <= count
  elseif type == "HaveTitan" then
    local count = 0
    local tbl = ed.getDataTable("TitanToHeros")
    for id, info in pairs(tbl) do
      if id ~= "name" and tonumber(id) and 0 ~= info.MatrixHeroID1 then
        local hero = ed.player:getHero(id)
        if hero then
          count = count + 1
        end
      end
    end
    return condition <= count
  elseif type == "IsHeroShardOpen" then
    if not param then
      return false
    end
    if param.heroId[1] then
      local jumpId = 0
      for _, v in pairs(ed.getDataTable("ShardToHero")) do
        if jumpId ~= v["Hero ID"] and v["Hero ID"] == param.heroId[1] then
          return true
        end
        jumpId = v["Hero ID"]
      end
      return false
    end
    return true
  end
  return true
end
