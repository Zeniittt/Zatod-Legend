local storyUI = {}
local widhtWin = ed.display.winSize.width
local heightWin = ed.display.winSize.height
local newWid = ed.display.halfFixedWidth
local newHei = ed.display.halfFixedHeight
local heroNameFramePos = {
  left = ccp(230, 170),
  right = ccp(widhtWin - 230, 170)
}
local heroNamePos = {
  left = ccp(230, 170),
  right = ccp(widhtWin - 230, 170)
}
local heroIconPos = {
  left = ccp(225, 160),
  right = ccp(widhtWin - 225, 160)
}
local uiRes = {
  {
    t = "Sprite",
    base = {
      name = "shadowBg",
      res = "UI/alpha/1080P/common/dialogue_bottom_shadow.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(widhtWin / 2, heightWin / 2)
    },
    config = {
      fix_size = CCSizeMake(widhtWin, heightWin)
    }
  },
  {
    t = "Layer",
    base = {
      name = "heroIconLay"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    },
    config = {
      scaleSize = CCSizeMake(widhtWin, heightWin)
    }
  },
  {
    t = "Scale9Sprite",
    base = {
      name = "storyBg",
      res = "UI/alpha/1080P/talk/talk_frame.png",
      capInsets = CCRectMake(20, 20, 50, 50)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(widhtWin / 2, 90)
    },
    config = {
      scaleSize = CCSizeMake(widhtWin - 100, 160)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "hint",
      res = "UI/alpha/1080P/talk/talk_arrow.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(widhtWin - 100, 40)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "nameFrame",
      res = "UI/alpha/1080P/talk/talk_unit_name.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 120)
    }
  },
  {
    t = "Label",
    base = {
      name = "heroName",
      text = "",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 120)
    },
    config = {
      color = ccc3(254, 211, 109)
    }
  },
  {
    t = "Label",
    base = {
      name = "content",
      text = "",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(widhtWin / 2, 85)
    },
    config = {
      dimension = CCSizeMake(widhtWin - 180, 134),
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCTextAlignmentCenter,
      color = ccc3(255, 252, 231)
    }
  }
}
local mainLayer, storyData
local currentSection = 1
local storyName = ""

local function getFadeAction()
  local fadeInAction = CCFadeIn:create(1)
  local fadeOutAction = CCFadeOut:create(1)
  local fadeAction = CCSequence:createWithTwoActions(fadeInAction, fadeOutAction)
  fadeAction = CCRepeatForever:create(fadeAction)
  return fadeAction
end

local function createMainLayer()
  local Layer = CCLayer:create()
  storyUI = {}
  local readNode = ed.readnode.create(Layer, storyUI)
  readNode:addNode(uiRes)
  local clipLayer = CCLayer:create()
  storyUI.clipLayer = clipLayer
  storyUI.heroIconLay:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(0, 170, widhtWin, heightWin))
  local heroIcon = ed.createSprite()
  clipLayer:addChild(heroIcon)
  storyUI.heroIcon = heroIcon
  local fadeAction = getFadeAction()
  storyUI.hint:runAction(fadeAction)
  return Layer
end

local function getUnitInfo(playerIndex, monsterIndex)
  local unit
  if playerIndex ~= nil then
    local num = ed.engine:getUnitNum(ed.emCampPlayer)
    unit = ed.engine:getUnitByIndex(playerIndex > num and num or playerIndex, ed.emCampPlayer)
  elseif monsterIndex ~= nil then
    local num = ed.engine:getUnitNum(ed.emCampEnemy)
    unit = ed.engine:getUnitByIndex(monsterIndex > num and num or monsterIndex, ed.emCampEnemy)
  end
  return unit
end

local function setHeroInfo(icon, name, playerIndex, monsterIndex)
  local unit = getUnitInfo(playerIndex, monsterIndex)
  local info = unit and unit.info or nil
  local icon = info and ed.getUnitIconName(unit.tid) or icon
  local name = info and info["Display Name"] or name
  local frame = ed.getSpriteFrame(icon)
  if frame then
    storyUI.heroIcon:initWithSpriteFrame(frame)
  end
  if name then
    ed.setString(storyUI.heroName, name)
    storyUI.heroName:limitSizeByScale(200, 50, 0.1)
  end
end

local function changeStoryInfo()
  local data = storyData[currentSection]
  if nil == data then
    return
  end
  if data.icon or data.name then
    setHeroInfo(data.icon, data.name, data.playIndex, data.monsterIndex)
    if data.position == "left" then
      storyUI.heroIcon:setFlipX(false)
    else
      storyUI.heroIcon:setFlipX(true)
    end
    storyUI.heroIcon:setAnchorPoint(ccp(0.5, 0))
    local size = storyUI.heroIcon:getContentSize()
    local scale = 1
    if size.width > 600 then
      scale = 0.6
    elseif size.width > 400 then
      scale = 0.7
    else
      scale = 0.8
    end
    storyUI.heroIcon:setScale(scale)
    local posx = 0
    if size.width > 600 then
      posx = (size.width - 600) * scale / 2 * (data.position == "left" and 1 or -1)
    end
    storyUI.heroIcon:setPosition(heroIconPos[data.position].x + posx, heroIconPos[data.position].y - size.height / 5 * scale + 7)
    storyUI.heroName:setPosition(heroNamePos[data.position])
    storyUI.nameFrame:setPosition(heroNameFramePos[data.position])
    storyUI.heroIcon:setVisible(not data.noPortrait)
    storyUI.heroName:setVisible(not data.noPortrait)
    storyUI.nameFrame:setVisible(not data.noPortrait)
  else
    storyUI.heroIcon:setVisible(false)
    storyUI.heroName:setVisible(false)
    storyUI.nameFrame:setVisible(false)
  end
  ed.setString(storyUI.content, data.text)
end

local function closeStory()
  storyUI = {}
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and mainLayer and not tolua.isnull(mainLayer) then
    currentScene:removeChild(mainLayer, true)
    mainLayer = nil
  end
  if ed.getCurrentScene() == ed.scene then
    ed.scene:resumeBattle("story")
  end
  FireEvent("StoryEnd", storyName)
end

local function showStorySection()
  if currentSection > #storyData and mainLayer then
    closeStory()
    return
  end
  changeStoryInfo()
  currentSection = currentSection + 1
end

local function onMainLayerTouch()
  local function handler(event, x, y)
    xpcall(function()
      if event == "ended" then
        ed.playEffect(ed.sound.dialogue.click)
        
        showStorySection()
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

local function showStory(data, param, param2)
  xpcall(function()
    if data == nil then
      return
    end
    currentSection = 1
    if EDTables.story[data] == nil then
      return
    end
    storyName = data
    storyData = param or EDTables.story[data].Content
    local storyKey
    if param and param.storyKey then
      storyKey = param.storyKey
    else
      storyKey = data
    end
    if EDTables.story[data].ShowOnce or param and param.ShowOnce then
      local storyUidKey = ed.getRoleKey(storyKey)
      if ed.storage.getBool(storyUidKey) then
        return
      end
      ed.storage.setValue(storyUidKey, true)
    end
    if mainLayer then
      closeStory()
    end
    mainLayer = createMainLayer()
    local currentScene = ed.getCurrentScene():ccScene()
    if currentScene then
      mainLayer:setTouchEnabled(true)
      local priority = param2 and param2.priority or -900
      mainLayer:registerScriptTouchHandler(onMainLayerTouch(), false, priority, true)
      currentScene:addChild(mainLayer, 1000)
      showStorySection()
      if ed.getCurrentScene() == ed.scene then
        ed.scene:pauseBattle("story")
      end
    end
  end, EDDebug)
end

ed.showStory = showStory

local function checkStoryEnded(storyKey)
  return ed.storage.getBool(ed.getRoleKey(storyKey))
end

ed.checkStoryEnded = checkStoryEnded

local function NeedChangeToHeroTaskStory(stage)
  local herotask = ed.player:withHeroTask("working")
  if herotask then
    local heroTaskTable = ed.getDataTable("HeroTask")
    local eid = heroTaskTable[herotask._line][herotask._id]
    for k, v in pairs(eid["Task Progress ID"]) do
      if v ~= 0 and (eid["Task Progress Type"] == "FarmStageAlone" or eid["Task Progress Type"] == "FarmStageNoDie" or eid["Task Progress Type"] == "FarmStageKill" or eid["Task Progress Type"] == "FarmStageDamage") and v == stage then
        return eid["Hero ID"]
      end
    end
    return -1
  else
    return -1
  end
end

local function showStageStory(stage, wave)
  local storyName = string.format("Stage%dWave%d", stage, wave)
  showStory(storyName)
end

local function EnterBattleStage(stage, wave)
  local scene = ed.getCurrentScene()
  if scene and ed.isElementInTable(scene.identity, {
    "awakeDungeonScene",
    "awakeDungeonGridMapScene"
  }) then
    return
  end
  local heroid = NeedChangeToHeroTaskStory(stage)
  if stage ~= 20105 then
    if 0 < heroid then
      local heroname = ed.lookupDataTable("Unit", "Name", heroid)
      local storyName = string.format("%sWave%d", heroname, wave)
      showStory(storyName)
      print("################battle stage" .. storyName)
    else
      showStageStory(stage, wave)
    end
  elseif ed.engine:withBattleHero(10001) then
    showStageStory(stage, wave)
  end
end

local function NoDieCheck(stage)
  local herotask = ed.player:withHeroTask("working")
  if herotask then
    local heroTaskTable = ed.getDataTable("HeroTask")
    local eid = heroTaskTable[herotask._line][herotask._id]
    for k, v in pairs(eid["Task Progress ID"]) do
      if v ~= 0 and v == stage and eid["Task Progress Type"] == "FarmStageNoDie" and 0 < ed.engine.death_count then
        return false
      end
    end
    return true
  else
    return true
  end
end

local function BattleEnding(stage, state)
  local scene = ed.getCurrentScene()
  if scene and ed.isElementInTable(scene.identity, {
    "awakeDungeonScene",
    "awakeDungeonGridMapScene"
  }) then
    return
  end
  local heroid = NeedChangeToHeroTaskStory(stage)
  local herotask = ed.player:withHeroTask("working")
  if 0 < heroid and herotask then
    local heroname = ed.lookupDataTable("Unit", "Name", heroid)
    local statename
    if state == "success" and ed.heroTaskResultCheck(herotask._line, herotask._id) then
      statename = "Success"
    else
      statename = "Failure"
    end
    local storyName = string.format("%s%s", heroname, statename)
    showStory(storyName)
    print("################battleend" .. storyName)
  else
  end
end

local function WinBackToSelect(state)
  local scene = ed.getCurrentScene()
  if scene and ed.isElementInTable(scene.identity, {
    "awakeDungeonScene",
    "awakeDungeonGridMapScene"
  }) then
    return
  end
  local storyName = string.format("WinBackToSelect%d", state)
  showStory(storyName)
end

local function EnterMainUi()
  local scene = ed.getCurrentScene()
  if scene and ed.isElementInTable(scene.identity, {
    "awakeDungeonScene",
    "awakeDungeonGridMapScene"
  }) then
    return
  end
  local storyName = "OpeningMain"
  if ed.player:getLevel() < 10 then
    showStory(storyName)
  end
end

ListenEvent("EnterBattleStage", EnterBattleStage)
ListenEvent("BattleEnding", BattleEnding)
ListenEvent("WinBackToSelect", WinBackToSelect)
ListenEvent("mainSceneEnter", EnterMainUi)
