local guideEventNames = {
  OPEN_VIEW = "GUIDE_OPEN_VIEW",
  CLOSE_VIEW = "GUIDE_CLOSE_VIEW",
  FUNCTION_OPEN = "GUIDE_FUNCTION_OPEN",
  GUIDE_NODE_CHANGE = "GUIDE_NODE_CHANGE",
  USE_SKILL_5V5 = "GUIDE_5V5_USE_SKILL",
  NEXT_WAVE = "GUIDE_NEXT_WAVE",
  AFTER_DR = "GUIDE_AFTER_GET_DR_FIRST",
  BATTLE_RESULT = "GUIDE_BATTLE_RESULT",
  COMPLETE_STAGE = "GUIDE_COMPLETE_STAGE",
  HERO_CAN_BE_SUMMONED = "GUIDE_HERO_CAN_BE_SUMMONED",
  HERO_CAN_INCREASE_RANK = "GUIDE_HERO_CAN_INCREASE_RANK",
  UNLOCK_TWOSPEED = "GUIDE_UNLOCK_TWOSPEED",
  UNLOCK_THREESPEED = "GUIDE_UNLOCK_THREESPEED",
  USE_SKILL = "GUIDE_USE_SKILL",
  GUIDE_DATA_READY = "GUIDE_DATA_READY",
  GUIDE_PREPARE = "GUIDE_PREPARE",
  GUIDE_START = "GUIDE_START",
  GUIDE_PROGRESSING = "GUIDE_PROGRESSING",
  GUIDE_COMPLETE = "GUIDE_COMPLETE"
}
ed.guide.eventNames = guideEventNames
local eventCheckers = {
  [guideEventNames.FUNCTION_OPEN] = {
    doCheck = function(triggerParams, funName)
      return triggerParams[1] == funName
    end
  },
  [guideEventNames.USE_SKILL_5V5] = {
    doCheck = function(triggerParams, heroName)
      return triggerParams[1] == heroName
    end
  },
  [guideEventNames.COMPLETE_STAGE] = {
    doCheck = function(triggerParams, stageId)
      return tonumber(triggerParams[1]) == stageId
    end
  }
}
ed.guide.eventCheckers = eventCheckers
