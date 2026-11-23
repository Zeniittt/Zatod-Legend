local adventureDefine = {}
ed.adventureDefine = adventureDefine
adventureDefine.STAGE_STATE_LOCKED = "stage_state_locked"
adventureDefine.STAGE_STATE_TIME_LOCKED = "stage_state_time_locked"
adventureDefine.STAGE_STATE_ENDING = "stage_state_ending"
adventureDefine.STAGE_STATE_CURRENT = "stage_state_current"
adventureDefine.STAGE_STATE_PASSED = "stage_state_passed"
adventureDefine.TASK_UNCOMPLETE = "task_uncomplete"
adventureDefine.TASK_AVAILABLE = "task_available"
adventureDefine.TASK_COMPLETE = "task_complete"
adventureDefine.VITALITY_UPPER_LIMIT = 200
adventureDefine.VITALITY_RECOVER_GAP = 360
adventureDefine.LAST_OPEN_TIME_KEY = "adventure_last_open_time"

function adventureDefine.getAdventureStageMonster(stageId, wave)
  local stageBattleCfg = ed.getDataTable("ActivityAdventureBattle")[stageId][wave]
  if not stageBattleCfg then
    return
  end
  local monsterInfoList = {}
  for index = 1, 5 do
    local monsterId = stageBattleCfg[string.format("Monster %s ID", index)]
    if not monsterId or monsterId == 0 then
      break
    end
    local stars = stageBattleCfg[string.format("Stars %s", index)]
    local level = stageBattleCfg[string.format("Level %s", index)]
    table.insert(monsterInfoList, {
      _tid = monsterId,
      _stars = stars,
      _level = level
    })
  end
  return monsterInfoList
end

function adventureDefine.getAdventureTokenSmallRes(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  if stageBattleCfg then
    return stageBattleCfg["Token Icon"]
  end
  return "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png"
end

function adventureDefine.getAdventureVitalitySmallRes(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  if stageBattleCfg then
    return stageBattleCfg["Vitality Icon"]
  end
  return "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_2.png"
end

function adventureDefine.getAdventureRules(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  if stageBattleCfg then
    return stageBattleCfg.Rules
  end
  return ""
end

function adventureDefine.getAdventureVitalityId(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  if stageBattleCfg then
    return stageBattleCfg["Vitality ID"]
  end
  return nil
end

function adventureDefine.getMainSceneEnterIcon(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  if stageBattleCfg then
    return stageBattleCfg["Main Icon"]
  end
  return "UI/alpha/1080P/activityadventure/main/summer_icon.png"
end

function adventureDefine.getAdventureTitle(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  if stageBattleCfg then
    return stageBattleCfg["Adewenture Name"]
  end
  return T("\229\164\143\230\151\165\229\164\167\229\134\146\233\153\169")
end

function adventureDefine.getAdventureTokenInfo(actId)
  local stageBattleCfg = ed.getDataTable("ActivityAdventure")[actId]
  local tokenInfo = stageBattleCfg["Token info"]
  if tokenInfo then
    return {
      tokenName = tokenInfo[1],
      tokenDesc = tokenInfo[2],
      tokenIconPath = tokenInfo[3]
    }
  else
    return {
      tokenName = T("\232\180\157\229\163\179"),
      tokenDesc = T("\228\186\174\230\153\182\230\153\182\231\154\132\232\180\157\229\163\179\239\188\140\230\148\182\233\155\134\230\173\164\231\137\169\228\188\188\228\185\142\229\143\175\228\187\165\232\142\183\229\190\151\229\165\150\229\138\177"),
      tokenIconPath = T("UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1_big.png")
    }
  end
end
