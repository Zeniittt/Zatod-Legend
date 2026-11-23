local ed = ed
local BattleSceneUI = {}
setimplements(BattleSceneUI, ed.guide.interface)
ed.sceneui = BattleSceneUI
ed.commonBattleSceneUI = BattleSceneUI
require("battle/battle_sceneui_extra")
local returnBtnTapHandler, nextBtnTapHandler, jumpBtnTapHandler

function BattleSceneUI:getCurrentMode()
  return ed.scene:getCurrentMode()
end

function BattleSceneUI:createUILayers(ccscene)
  self.ui_layer = CCLayer:create()
  ccscene:addChild(self.ui_layer, 2)
  self.ui_layer:setTouchEnabled(true)
  self.ui_layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -129, false)
  local texture = ed.loadNumTexture()
  self.damageBath_layer = CCSpriteBatchNode:createWithTexture(texture, 500)
  self.ui_layer:addChild(self.damageBath_layer)
  self.menu_touch_layer = CCLayer:create()
  self.ui_layer:addChild(self.menu_touch_layer)
  self.menu_touch_node = ed.ui.basetouchnode.btCreate()
  self.menu_touch_layer:setTouchEnabled(true)
  self.menu_touch_layer:registerScriptTouchHandler(self.menu_touch_node:btGetMainTouchHandler(), false, -150, false)
end

local needClearLayerNames = {"ui_layer"}
local protectedNode = {
  {
    node = "damageBath_layer",
    parent = "ui_layer"
  },
  {
    node = "menu_touch_layer",
    parent = "ui_layer"
  }
}

function BattleSceneUI:clearSceneUI()
  for i, v in ipairs(protectedNode) do
    local node = self[v.node]
    if node then
      node:retain()
    end
  end
  for i, layerName in ipairs(needClearLayerNames) do
    local layer = self[layerName]
    if layer then
      layer:removeAllChildrenWithCleanup(true)
    end
  end
  for i, v in ipairs(protectedNode) do
    local node = self[v.node]
    local parent = self[v.parent]
    if node then
      parent:addChild(node, node:getZOrder())
      node:release()
    end
  end
  self.menu_touch_node:btClearMainTouchHandler()
end

function BattleSceneUI:adaptPosition(winSize, backSize)
  self.adaptZeroX = 0
  self.adaptZeroY = winSize.height > backSize.height and (winSize.height - backSize.height) / 2 or 0
  self.adaptMaxX = winSize.width
  self.adaptMaxY = winSize.height - self.adaptZeroY
  self.adaptCenterX = self.adaptZeroX + (self.adaptMaxX - self.adaptZeroX) / 2
  self.adaptCenterY = self.adaptZeroY + (self.adaptMaxY - self.adaptZeroY) / 2
end

function BattleSceneUI:getGuideNode(nodeKey)
  local hero = ed.engine:findHero(nodeKey)
  if hero then
    return hero.heroPanel.portrait
  elseif nodeKey == "next_btn" then
    local area = ed.guide.helper.createNodeTouchArea(self.next_btn)
    local width = area.width * 1.6
    area.center.x = (area.width - width) / 2 + 10
    area.width = width
    return self.next_btn, area
  elseif nodeKey == "full_energy_hero" then
    local list = ed.engine.alive_units[ed.emCampPlayer]
    for i, v in ipairs(list) do
      if v.heroPanel:checkManulCanCast() then
        return v.heroPanel.portrait
      end
    end
  end
  return self[nodeKey] or self.ui[nodeKey]
end

function BattleSceneUI:addGuildBloodPanel()
  if ed.engine.monsterNum ~= 1 then
    local panel = ed.ui.GuildHpBarCreate(self:calculateBigHpLength())
    self.ui_layer:addChild(panel.node)
    ed.layout.layoutWithMagin(panel.node, {
      left = ed.display.winSize.width / 2,
      top = 50
    })
    table.insert(self.ui_list, panel)
  end
end

function BattleSceneUI:addGuildMountBossBloodPanel()
  for i, unit in ipairs(ed.engine.unit_list) do
    if unit.camp == ed.emCampEnemy then
      local panel
      panel = ed.BigHpBarNoIconCreate(unit, self:calculateBigHpLength(), 5)
      self.ui_layer:addChild(panel.node)
      ed.layout.layoutWithMagin(panel.node, {
        left = ed.display.winSize.width / 2,
        top = 50
      })
      table.insert(self.ui_list, panel)
      for _, buff in ipairs(unit.buff_list) do
        if buff.info["Show Icon"] then
          self:addBuffStack(buff)
        end
      end
      break
    end
  end
end

function BattleSceneUI:addStageWaveProgress()
  local stage_info = ed.engine.stage_info
  local refreshTimeList = stage_info["Refresh Time"]
  if not refreshTimeList or #refreshTimeList == 0 then
    return
  end
  self:showBattleStage(false)
  local stageWaveProgress = ed.ui.stageWaveProgress.create({
    totalTime = refreshTimeList[#refreshTimeList],
    totalWave = #refreshTimeList + 1,
    waveTimeList = refreshTimeList
  })
  self.stageWaveProgress = stageWaveProgress
  self.ui_layer:addChild(stageWaveProgress.bg)
  local widthWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  stageWaveProgress.bg:setPosition(widthWin / 2, heightWin - 50)
  table.insert(self.ui_list, stageWaveProgress)
end

function BattleSceneUI:checkUILayerClicked(event, x, y)
  local canClickBall = ed.engine.running and not ed.engine:arenaMode() and not ed.engine.replayMode and not ed.engine.crevicedefend_mode and ed.engine.playerKaelHero and ed.engine.playerKaelHero:isAlive()
  if canClickBall and event == "began" then
    for _, v in pairs(self.ballSlots) do
      local radius = 30
      local rect = CCRectMake(ed.engine.slotPositions[v.slotIdx][1] - radius, ed.engine.slotPositions[v.slotIdx][2] - radius, radius * 2, radius * 2)
      if rect:containsPoint(ccp(x, y)) then
        v:onTapped()
        break
      end
    end
  end
  if self.alreadyAddBuffIcon == true then
    if event == "began" then
      local idx = 0
      for _, p in ipairs(self.ui_list) do
        if p.buffstack then
          if ed.containsPoint(p.node, x, y) then
            local str = T("<text|chat_channel_active|" .. p.buff.info["Icon Text"] .. ">")
            local posX, posY
            local pos = p.node:getParent():convertToWorldSpace(ccp(p.node:getPosition()))
            posX = pos.x + idx * 45
            posY = pos.y - 40
            if 660 < posX then
              posX = 650
            end
            ed.showHintText(str, ccp(posX, posY))
            return true
          end
          idx = idx + 1
        end
      end
    elseif event == "ended" then
      ed.closeHintText()
    end
  end
  FireEvent("OnHeroRequestJoinBattle", ccp(x * 2, (y - 265) * 2), x, y, event)
  if ed.engine.autoChessMode then
    FireEvent("OnChessHeroJoinBattle", ccp(x, y - 265), x, y, event)
  end
  return false
end

function BattleSceneUI:doPauseLayerTouch()
  local function handler(event, x, y)
    if event == "began" then
      for k, v in pairs(self.pauseLayerButton) do
        if ed.containsPoint(self.pauseLayerButton[k], x, y) and self.pauseLayerButton[k]:isVisible() then
          self.pauseLayerButtonPress[k]:setVisible(true)
          
          self.isPressPauseButtonID = k
          break
        end
      end
    elseif event == "ended" then
      local k = self.isPressPauseButtonID
      self.isPressPauseButtonID = nil
      if k then
        self.pauseLayerButtonPress[k]:setVisible(false)
        if ed.containsPoint(self.pauseLayerButton[k], x, y) then
          self.pauseLayerButtonHandler[k]()
        end
      end
    end
    return true
  end
  
  return handler
end

function BattleSceneUI:createPauseLayer()
  if self.pauseLayer and not tolua.isnull(self.pauseLayer) and self.pauseLayer:getParent() == self.ui_layer then
    return
  end
  ed.scene:pauseBattle("pauseButton")
  ed.scene:stopNextwaveAction()
  ed.setMusicVolume(0.25)
  local pauseLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.ui_layer:addChild(pauseLayer, 400)
  pauseLayer:registerScriptTouchHandler(self:doPauseLayerTouch(), false, -130, true)
  self.pauseLayer = pauseLayer
  local pauseContainer = ed.createSprite("UI/alpha/1080P/crusade/bg_pause.png")
  pauseContainer:setAnchorPoint(ccp(0.5, 0.5))
  pauseLayer:addChild(pauseContainer)
  self.pauseContainer = pauseContainer
  ed.layout.centerInScreen(pauseContainer, true)
  self.pauseLayerButton = {}
  self.pauseLayerButtonPress = {}
  self.pauseLayerButtonHandler = {}
  self.pauseLayerButtonLabel = {}
  local pos = ed.getCenterPos(pauseContainer)
  local exit = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local exitPress = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local exitIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_back.png")
  exitIcon:setPosition(ccp(38, 42))
  exit:addChild(exitIcon)
  local exitPressIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_back.png")
  exitPressIcon:setPosition(ccp(38, 42))
  exitPress:addChild(exitPressIcon)
  exit:setPosition(ccp(pos.x - 225, pos.y + 4.5))
  exitPress:setPosition(ccp(pos.x - 225, pos.y + 4.5))
  pauseContainer:addChild(exit)
  exitPress:setVisible(false)
  pauseContainer:addChild(exitPress)
  local key = "exit"
  self.pauseLayerButton[key] = exit
  self.pauseLayerButtonPress[key] = exitPress
  self.pauseLayerButtonHandler[key] = function()
    ed.playEffect(ed.sound.deo.common_click_feedback)
    if self:getCurrentMode() == "dreamland" then
      ed.showConfirmDialog({
        text = T("\233\128\128\229\135\186\230\136\152\230\150\151\228\188\154\230\182\136\232\128\151\230\156\172\230\172\161\230\140\145\230\136\152\230\156\186\228\188\154\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
        rightText = T("\231\161\174\229\174\154"),
        skipDestroyAnim = true,
        rightHandler = function()
          ed.resetMusicVolume()
          ed.scene:exit()
        end
      })
      print(ed.scene:getCurrentMode())
    elseif self:getCurrentMode() == "guildMountBoss" then
      if ed.scene.battleModeInfo.guildMountBossInfo.practice then
        ed.GuildMountManager.battleCanceled = true
        ed.resetMusicVolume()
        ed.scene:exit()
      elseif not ed.GuildMountManager.isTestBattle then
        if ed.GuildMountManager.leftExitTimes > 0 then
          ed.showConfirmDialog({
            text = string.format(T("\230\156\172\230\172\161\233\128\128\229\135\186\230\136\152\230\150\151\228\184\141\230\182\136\232\128\151\230\140\145\230\136\152\230\156\186\228\188\154(\229\137\169\228\189\153%d\230\172\161)\239\188\140\230\152\175\229\144\166\233\128\128\229\135\186\239\188\159"), ed.GuildMountManager.leftExitTimes),
            rightText = T("\231\161\174\229\174\154"),
            skipDestroyAnim = true,
            rightHandler = function()
              ed.resetMusicVolume()
              ed.scene:exit()
            end
          })
        else
          ed.showConfirmDialog({
            text = T("\233\128\128\229\135\186\230\136\152\230\150\151\228\188\154\230\182\136\232\128\151\230\156\172\230\172\161\230\140\145\230\136\152\230\156\186\228\188\154\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
            rightText = T("\231\161\174\229\174\154"),
            skipDestroyAnim = true,
            rightHandler = function()
              FireEvent("EventGuildMountStageEnd")
              ed.resetMusicVolume()
              ed.scene:exit()
            end
          })
        end
      else
        ed.resetMusicVolume()
        ed.scene:exit()
      end
    elseif self:getCurrentMode() == "fancyTower" or ed.engine.fancyAbyssMode then
      ed.resetMusicVolume()
      ed.scene:exit()
    elseif ed.isElementInTable(self:getCurrentMode(), {
      "activityAdventure",
      "awakeStage",
      "hadesHeat"
    }) then
      ed.resetMusicVolume()
      ed.scene:exit()
    elseif self:getCurrentMode() == "autoChessMode" then
      if ed.AutoChessModel:isMySelfDead() then
        ed.AutoChessNetwork:sendChessQuit()
      else
        ed.scene:exit()
      end
    elseif self:getCurrentMode() == "rogueMode" then
      local retryTimes = ed.rogueLikeMgr.getInstance():getRetryTimes()
      if 0 < retryTimes then
        ed.UITool.openView("rogueExitBattleTipsWindow", {
          content = T("\230\130\168\232\191\152\230\156\137\229\143\175\233\135\141\232\175\149\230\172\161\230\149\176\239\188\140<lable color=ccc3(255,108,108)>\233\128\128\229\135\186\229\176\134\231\187\147\230\157\159\230\156\172\230\172\161\230\184\184\231\142\169\239\188\140</lable>\230\152\175\229\144\166\231\161\174\229\174\154\233\128\128\229\135\186\239\188\159"),
          confirmCallBack = function()
            ed.rogueLikeNet.sendEndChapter()
            ed.resetMusicVolume()
            ed.scene:exit()
          end
        })
      else
        ed.rogueLikeNet.sendEndChapter()
        ed.resetMusicVolume()
        ed.scene:exit()
      end
    elseif self:getCurrentMode() == "crevicedefend" then
      if ed.engine.replayMode == true then
        ed.resetMusicVolume()
        ed.scene:exit()
        return
      end
      ed.showConfirmDialog({
        text = T("\233\128\128\229\135\186\230\136\152\230\150\151\228\188\154\230\182\136\232\128\151\230\156\172\230\172\161\230\140\145\230\136\152\230\156\186\228\188\154\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
        rightText = T("\231\161\174\229\174\154"),
        skipDestroyAnim = true,
        rightHandler = function()
          FireEvent("EventCreviceDefendStageEnd")
          FireEvent("EventCreviceDefendStageForceEnd")
          ed.resetMusicVolume()
          ed.scene:exit()
        end
      })
    elseif ed.engine.custom_mode then
      ed.resetMusicVolume()
      ed.scene:exit()
    else
      local stageid = ed.engine.stage_info["Stage ID"]
      if stageid then
        local failExp = ed.getDataTable("Stage")[stageid]["Fail Exp Reward"]
        if failExp then
          ed.player:addExp(failExp)
        end
      end
      ed.resetMusicVolume()
      ed.scene:exit()
    end
  end
  local exitLabel = ed.createttf(T("\233\128\128\229\135\186\230\136\152\230\150\151"), 18)
  ed.setLabelColor(exitLabel, ccc3(254, 241, 169))
  ed.setLabelStroke(exitLabel, ccc3(144, 85, 15), 1)
  exitLabel:setPosition(ccp(pos.x - 225, pos.y - 44.5))
  pauseContainer:addChild(exitLabel)
  self.pauseLayerButtonLabel[key] = exitLabel
  local retry = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local retryPress = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local retryIcon = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_battle_retry.png", 1)
  retryIcon:setPosition(ccp(39, 40))
  retry:addChild(retryIcon)
  local retryPressIcon = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_battle_retry.png", 1)
  retryPressIcon:setPosition(ccp(39, 40))
  retryPress:addChild(retryPressIcon)
  retry:setPosition(ccp(pos.x - 75, pos.y + 4.5))
  retryPress:setPosition(ccp(pos.x - 75, pos.y + 4.5))
  retryPress:setVisible(false)
  pauseContainer:addChild(retry)
  pauseContainer:addChild(retryPress)
  local key = "retry"
  self.pauseLayerButton[key] = retry
  self.pauseLayerButtonPress[key] = retryPress
  self.pauseLayerButtonHandler[key] = function()
    xpcall(function()
      if self:getCurrentMode() == "rogueMode" then
        self:onClickRogueRetry()
      end
    end, EDDebug)
  end
  local retryLabel = ed.createttf(T("\233\135\141\232\175\149"), 18)
  ed.setLabelColor(retryLabel, ccc3(254, 241, 169))
  ed.setLabelStroke(retryLabel, ccc3(144, 85, 15), 1)
  retryLabel:setPosition(ccp(pos.x - 75, pos.y - 44.5))
  self.pauseContainer:addChild(retryLabel)
  self.pauseLayerButtonLabel[key] = retryLabel
  local sound = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local soundPress = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local soundIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_play_music2.png", 1)
  soundIcon:setPosition(ccp(38, 42))
  sound:addChild(soundIcon)
  local soundPressIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_pause_music1.png", 1)
  soundPressIcon:setPosition(ccp(38, 42))
  soundPress:addChild(soundPressIcon)
  sound:setPosition(ccp(pos.x - 75, pos.y + 4.5))
  soundPress:setPosition(ccp(pos.x - 75, pos.y + 4.5))
  soundPress:setVisible(false)
  pauseContainer:addChild(sound)
  pauseContainer:addChild(soundPress)
  if not ed.getSoundSwitch() then
    local temp = soundPress
    soundPress = sound
    sound = temp
    sound:setVisible(true)
    soundPress:setVisible(false)
  end
  local key = "sound"
  self.pauseLayerButton[key] = sound
  self.pauseLayerButtonPress[key] = soundPress
  self.pauseLayerButtonHandler[key] = function()
    xpcall(function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.turnSoundSwitch()
      local key = "sound"
      local temp = self.pauseLayerButton[key]
      self.pauseLayerButton[key] = self.pauseLayerButtonPress[key]
      self.pauseLayerButtonPress[key] = temp
      self.pauseLayerButton[key]:setVisible(true)
      self.pauseLayerButtonPress[key]:setVisible(false)
      ed.setString(self.pauseLayerButtonLabel[key], ed.getSoundSwitch() and T("\232\131\140\230\153\175\229\163\176\233\159\179\239\188\154\229\188\128") or T("\232\131\140\230\153\175\229\163\176\233\159\179\239\188\154\229\133\179"))
    end, EDDebug)
  end
  local soundLabel = ed.createttf(ed.getSoundSwitch() and T("\232\131\140\230\153\175\229\163\176\233\159\179\239\188\154\229\188\128") or T("\232\131\140\230\153\175\229\163\176\233\159\179\239\188\154\229\133\179"), 18)
  ed.setLabelColor(soundLabel, ccc3(254, 241, 169))
  ed.setLabelStroke(soundLabel, ccc3(144, 85, 15), 1)
  soundLabel:setPosition(ccp(pos.x - 75, pos.y - 44.5))
  self.pauseContainer:addChild(soundLabel)
  self.pauseLayerButtonLabel[key] = soundLabel
  local soundEffect = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local soundEffectPress = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local soundEffectIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_play_music.png", 1)
  soundEffectIcon:setPosition(ccp(38, 42))
  soundEffect:addChild(soundEffectIcon)
  local soundEffectPressIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_pause_music.png", 1)
  soundEffectPressIcon:setPosition(ccp(38, 42))
  soundEffectPress:addChild(soundEffectPressIcon)
  soundEffect:setPosition(ccp(pos.x + 75, pos.y + 4.5))
  soundEffectPress:setPosition(ccp(pos.x + 75, pos.y + 4.5))
  soundEffectPress:setVisible(false)
  pauseContainer:addChild(soundEffect)
  pauseContainer:addChild(soundEffectPress)
  if not ed.getSoundEffectsSwitch() then
    local temp = soundEffectPress
    soundEffectPress = soundEffect
    soundEffect = temp
    soundEffect:setVisible(true)
    soundEffectPress:setVisible(false)
  end
  local key = "sound_effect"
  self.pauseLayerButton[key] = soundEffect
  self.pauseLayerButtonPress[key] = soundEffectPress
  self.pauseLayerButtonHandler[key] = function()
    xpcall(function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      if ed.getSoundEffectsSwitch() then
        ed.turnSoundEffect(false)
      else
        ed.turnSoundEffect(true)
      end
      ed.playEffect(ed.sound.deo.common_click_feedback)
      local key = "sound_effect"
      local temp = self.pauseLayerButton[key]
      self.pauseLayerButton[key] = self.pauseLayerButtonPress[key]
      self.pauseLayerButtonPress[key] = temp
      self.pauseLayerButton[key]:setVisible(true)
      self.pauseLayerButtonPress[key]:setVisible(false)
      ed.setString(self.pauseLayerButtonLabel[key], ed.getSoundEffectsSwitch() and T("\231\137\185\230\149\136\229\163\176\233\159\179\239\188\154\229\188\128") or T("\231\137\185\230\149\136\229\163\176\233\159\179\239\188\154\229\133\179"))
    end, EDDebug)
  end
  local labelEffect = ed.createttf(ed.getSoundEffectsSwitch() and T("\231\137\185\230\149\136\229\163\176\233\159\179\239\188\154\229\188\128") or T("\231\137\185\230\149\136\229\163\176\233\159\179\239\188\154\229\133\179"), 18)
  ed.setLabelColor(labelEffect, ccc3(254, 241, 169))
  ed.setLabelStroke(labelEffect, ccc3(144, 85, 15), 1)
  labelEffect:setPosition(ccp(pos.x + 75, pos.y - 44.5))
  self.pauseContainer:addChild(labelEffect)
  self.pauseLayerButtonLabel[key] = labelEffect
  local resume = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local resumePress = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local resumeIcon = ed.createSprite("UI/alpha/1080P/crusade/btn_restart.png")
  resumeIcon:setPosition(ccp(38, 42))
  resume:addChild(resumeIcon)
  resume:setPosition(ccp(pos.x + 225, pos.y + 4.5))
  resumePress:setPosition(ccp(pos.x + 225, pos.y + 4.5))
  pauseContainer:addChild(resume)
  resumePress:setAnchorPoint(ccp(0, 0))
  resumePress:setVisible(false)
  resume:addChild(resumePress)
  local key = "resume"
  self.pauseLayerButton[key] = resume
  self.pauseLayerButtonPress[key] = resumePress
  self.pauseLayerButtonHandler[key] = function()
    xpcall(function()
      ed.resetMusicVolume()
      local s = CCScaleTo:create(0.2, 0)
      s = CCEaseBackIn:create(s)
      local func = CCCallFunc:create(function()
        xpcall(function()
          ed.playEffect(ed.sound.deo.common_click_feedback)
          ed.scene:resumeBattle("pauseButton")
          self.pauseLayer:removeFromParentAndCleanup(true)
          self.pauseLayer = nil
          ed.scene:runNextwaveAction()
        end, EDDebug)
      end)
      local sequence = CCSequence:createWithTwoActions(s, func)
      self.pauseContainer:runAction(sequence)
    end, EDDebug)
  end
  local resuLelabel = ed.createttf(T("\231\187\167\231\187\173\230\136\152\230\150\151"), 18)
  ed.setLabelColor(resuLelabel, ccc3(254, 241, 169))
  ed.setLabelStroke(resuLelabel, ccc3(144, 85, 15), 1)
  resuLelabel:setPosition(ccp(pos.x + 225, pos.y - 44.5))
  pauseContainer:addChild(resuLelabel)
  self.pauseLayerButtonLabel[key] = resuLelabel
  local skillCombine = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local skillCombinePress = ed.createSprite("UI/alpha/1080P/crusade/btn_challenge.png")
  local skillCombineIcon = ed.createSprite("UI/alpha/1080P/crusade/skill_combine_icon.png")
  skillCombineIcon:setPosition(ccp(38, 42))
  skillCombine:addChild(skillCombineIcon)
  skillCombine:setPosition(ccp(pos.x + 225, pos.y + 4.5))
  skillCombinePress:setPosition(ccp(pos.x + 225, pos.y + 4.5))
  pauseContainer:addChild(skillCombine)
  skillCombinePress:setAnchorPoint(ccp(0, 0))
  skillCombinePress:setVisible(false)
  skillCombine:addChild(skillCombinePress)
  local key = "skill_combine"
  self.pauseLayerButton[key] = skillCombine
  self.pauseLayerButtonPress[key] = skillCombinePress
  self.pauseLayerButtonHandler[key] = function()
    xpcall(function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.ui.kaelSkillCombineWin:create():popWindow()
    end, EDDebug)
  end
  local skillCombineLabel = ed.createttf(T("\230\138\128\232\131\189\230\144\173\233\133\141"), 18)
  ed.setLabelColor(skillCombineLabel, ccc3(254, 241, 169))
  ed.setLabelStroke(skillCombineLabel, ccc3(144, 85, 15), 1)
  skillCombineLabel:setPosition(ccp(pos.x + 225, pos.y - 44.5))
  pauseContainer:addChild(skillCombineLabel)
  self.pauseLayerButtonLabel[key] = skillCombineLabel
  self:layoutPauseButton()
  pauseContainer:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local func = CCCallFunc:create(function()
    xpcall(function()
      pauseLayer:setTouchEnabled(true)
    end, EDDebug)
  end)
  local sequence = CCSequence:createWithTwoActions(s, func)
  pauseContainer:runAction(sequence)
end

function BattleSceneUI:layoutPauseButton()
  local btnKeyList = {
    "retry",
    "exit",
    "sound",
    "sound_effect",
    "resume",
    "skill_combine"
  }
  local showKey = {}
  local showAmount = 0
  
  local function getButtonShow(key)
    local showCfg = {
      exit = true,
      retry = false,
      sound = true,
      sound_effect = true,
      resume = true,
      skill_combine = false
    }
    if self:getCurrentMode() == "rogueMode" then
      showCfg.retry = true
      showCfg.exit = false
    end
    if nil ~= ed.engine.playerKaelHero then
      showCfg.skill_combine = true
    end
    return showCfg[key] or false
  end
  
  for index, key in ipairs(btnKeyList) do
    if getButtonShow(key) then
      showAmount = showAmount + 1
      showKey[key] = true
    end
  end
  local centerPos = ed.getCenterPos(self.pauseContainer)
  local gapX = 150
  local showIndex = 0
  for _, key in ipairs(btnKeyList) do
    local button = self.pauseLayerButton[key]
    local buttonPress = self.pauseLayerButtonPress[key]
    local buttonLabel = self.pauseLayerButtonLabel[key]
    local isVisible = showKey[key] or false
    button:setVisible(button:isVisible() and isVisible)
    buttonPress:setVisible(buttonPress:isVisible() and isVisible)
    buttonLabel:setVisible(buttonLabel:isVisible() and isVisible)
    if isVisible then
      showIndex = showIndex + 1
      local x = centerPos.x + (showIndex - (showAmount + 1) / 2) * gapX
      button:setPositionX(x)
      buttonPress:setPositionX(x)
      buttonLabel:setPositionX(x)
    end
  end
end

function BattleSceneUI:onClickRogueRetry()
  local rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  local retryTimes = rogueLikeMgr:getRetryTimes()
  local canBattle = rogueLikeMgr:getCanBattle()
  if not canBattle or retryTimes == 0 then
    ed.showToast(T("\232\161\165\231\187\153\229\183\178\232\128\151\229\176\189"))
    return
  end
  ed.UITool.openView("rogueExitBattleTipsWindow", {
    content = T("\230\152\175\229\144\166\230\182\136\232\128\151\232\161\165\231\187\153\232\191\155\232\161\140\233\135\141\232\175\149\239\188\159\233\135\141\232\175\149\229\176\134\229\155\158\229\136\176\230\140\145\230\136\152\229\137\141\231\154\132\231\138\182\230\128\129"),
    extTips = string.format(T("\229\189\147\229\137\141\232\161\165\231\187\153\230\149\176\233\135\143\239\188\154<lable color=ccc3(255,165,49)>%s</lable>"), retryTimes),
    confirmCallBack = function()
      local curChapter = rogueLikeMgr:getCurChapter()
      ed.scene:exit()
      local stageInfo = ed.engine.stage_info
      local stageId = stageInfo["Stage ID"]
      ed.UITool.openView("rogueBattlePrepare", {
        mode = "fight",
        stageId = stageId,
        destinyId = curChapter._destiny,
        chapterId = curChapter._chapter_id,
        difficulty = curChapter._difficulty
      })
    end
  })
end

function BattleSceneUI:exitUI()
  if self.pauseLayer and not tolua.isnull(self.pauseLayer) then
    self.pauseLayer:removeFromParentAndCleanup(true)
    self.pauseLayer = nil
  end
  FireEvent(ed.guide.eventNames.CLOSE_VIEW, self)
end

local function returnBtnTapHandler()
  ed.playSound(ed.sound.battle.clickReturn)
  ed.sceneui:createPauseLayer()
end

ed.next_battle_walk_speeder = 1.75

local function nextBtnTapHandler()
  xpcall(function()
    ed.playEffect(ed.sound.battle.goNextBattle)
    ed.sceneui.next_btn:setEnabled(false)
    ed.sceneui.next_btn:runAction(CCFadeOut:create(0.1))
    ed.scene:nextWaveBynextBtn()
    ed.sceneui:autoCollectLoots()
  end, EDDebug)
end

local function jumpBtnTapHandler()
end

BattleSceneUI.jumpBtnTapHandler = jumpBtnTapHandler

function BattleSceneUI:autoCollectLoots(delay)
  delay = delay or 0
  for _, v in ipairs(self.ui_list) do
    if v.what == "Loot" and not v.terminated then
      local action = CCCallFunc:create(function()
        v.btn:setEnabled(false)
        v:onAutoCollect()
      end)
      action = CCSequence:createWithTwoActions(CCDelayTime:create(delay), action)
      v.node:runAction(action)
      delay = delay + 0.16666666666666666
    end
  end
end

function BattleSceneUI:nextBattle_1()
  ed.guide.manager:stopGuide(38)
  self.damageBath_layer:removeAllChildrenWithCleanup(true)
end

function BattleSceneUI:nextBattle_2()
  self.ui.speedButtonBg:setVisible(false)
  self.pause_btn:setVisible(false)
  self.auto_btn:setVisible(false)
  self.auto_btn:setEnabled(false)
  self:showBattleStage(false)
  self.goldmarker:setVisible(false)
  self.lootmarker:setVisible(false)
end

function BattleSceneUI:nextBattle_3()
  local auto = ed.scene.auto_combat
  self.auto_btn:setSelectedIndex(auto and 1 or 0)
end

function BattleSceneUI:canAddHeroPanel(unit, viewCamp)
  return unit.camp == viewCamp and unit:isHero()
end

function BattleSceneUI:addHeroPanel(unit)
  self:addBottomHeroPanel(unit)
end

function BattleSceneUI:addBottomHeroPanel(unit)
  local panel = ed.HeroPanelCreate(unit, "green")
  unit.heroPanel = panel
  self.heroes_panel:addChild(panel.node)
  table.insert(self.ui_list, panel)
  local spaceX = 51 / ed.display.scaleFactor
  local w = self.heroes_panel:getContentSize().width
  local originX = (w - panel.width * #self.ui_list - spaceX * (#self.ui_list - 1)) / 2
  originX = w - originX - panel.width / 2
  for idx, p in ipairs(self.ui_list) do
    if p.node then
      p.node:setPosition(ccp(originX - (panel.width + spaceX) * (idx - 1), 0))
    end
  end
  for idx, p in ipairs(self.ui_list) do
    if p.ball_bar then
      self.ballPositions = {}
      local px = self.heroes_panel:getPosition()
      local x = p.node:getPosition()
      local dst = px - self.heroes_panel:getContentSize().width / 2 + x
      self.ballPositions[1] = ccp(dst - 27, 165)
      self.ballPositions[2] = ccp(dst, 165)
      self.ballPositions[3] = ccp(dst + 27, 165)
    end
  end
end

function BattleSceneUI:addHeroObInfoPanel()
  local spaceX = 25 / ed.display.scaleFactor
  local heroPanelSize = CCSizeMake(78, 78)
  local blueCamp = ed.emCampPlayer
  local blueHeroPanelList = {}
  for index, unit in ipairs(ed.engine.unit_list) do
    if self:canAddHeroPanel(unit, blueCamp) then
      local panel = ed.HeroPanelCreate(unit, "green")
      unit.heroPanel = panel
      self.obHeroPanelBlue:addChild(panel.node)
      table.insert(self.ui_list, panel)
      table.insert(blueHeroPanelList, panel)
    end
  end
  local totalWidth = #blueHeroPanelList * heroPanelSize.width + (#blueHeroPanelList - 1) * spaceX
  local originX = (self.obHeroPanelBlue:getContentSize().width - totalWidth) / 2
  for index = #blueHeroPanelList, 1, -1 do
    local heroPanel = blueHeroPanelList[index]
    heroPanel.node:setPositionX(originX + heroPanelSize.width / 2)
    originX = originX + heroPanelSize.width + spaceX
  end
  local redCamp = ed.emCampEnemy
  local redHeroPanelList = {}
  for i, unit in ipairs(ed.engine.unit_list) do
    if self:canAddHeroPanel(unit, redCamp) then
      local panel = ed.HeroPanelCreate(unit, "green")
      unit.heroPanel = panel
      self.obHeroPanelRed:addChild(panel.node)
      table.insert(self.ui_list, panel)
      table.insert(redHeroPanelList, panel)
    end
  end
  local totalWidth = #redHeroPanelList * heroPanelSize.width + (#redHeroPanelList - 1) * spaceX
  local originX = (self.obHeroPanelRed:getContentSize().width - totalWidth) / 2
  for index = #redHeroPanelList, 1, -1 do
    local heroPanel = redHeroPanelList[index]
    heroPanel.node:setPositionX(originX + heroPanelSize.width / 2)
    originX = originX + heroPanelSize.width + spaceX
  end
end

function BattleSceneUI:calculateBigHpLength()
  local origin = CCDirector:sharedDirector():getVisibleOrigin()
  local ox, oy = origin.x, -origin.y * 0.25
  local leftX = 84 + origin.x + 106
  local rightX = 587 - origin.x
  return rightX - leftX
end

function BattleSceneUI:isBanAddBigBlood()
  local banModes = {
    "mythBoss",
    "campBoss",
    "campTower",
    "seasonTower"
  }
  return ed.isElementInTable(self:getCurrentMode(), banModes)
end

function BattleSceneUI:addBigBloodPanelList(hpBigList)
  if self:isBanAddBigBlood() then
    return
  end
  self.bigHpBarList = {}
  local param = {
    iconFrameScale = #hpBigList == 1 and 1 or 0.7,
    stageProgressScale = #hpBigList == 1 and 1 or 0.7
  }
  for index, unit in ipairs(hpBigList) do
    self:addBigBloodPanel(unit, param)
  end
  self:updateBigHpBarPos()
end

function BattleSceneUI:addBigBloodPanel(unit, param)
  local panel
  if ed.isElementInTable(ed.scene.battleInfo["Stage Type"], {
    "dreamland",
    "guildMountBoss"
  }) then
    panel = ed.BigHpBarCreate(unit, self:calculateBigHpLength(), ccp(3, 5), nil, param)
  else
    panel = ed.BigHpBarCreate(unit, self:calculateBigHpLength(self), nil, nil, param)
  end
  self.ui_layer:addChild(panel.node)
  table.insert(self.bigHpBarList, panel)
  table.insert(self.ui_list, panel)
end

function BattleSceneUI:addHeatBuffPanel()
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local heatBuffPanel = ed.ui.HeatbuffPanel.create({
    activeHeat = ed.engine.activeHeat
  })
  self.heatBuffPanel = heatBuffPanel
  self.ui_layer:addChild(heatBuffPanel.node)
  heatBuffPanel.node:setPosition(widhtWin / 2, heightWin - 94)
end

function BattleSceneUI:addEchoSkillIcon()
  if self.echoSkill then
    self.echoSkill:clear()
    self.echoSkill = nil
  end
  local echoSkillMgr = ed.engine:getEchoSkillMgr()
  if not echoSkillMgr then
    return
  end
  local echoId = echoSkillMgr:getEchoId()
  if not echoId then
    return
  end
  local echoSkill = ed.echoSkillIcon.create({
    mode = self:getCurrentMode(),
    echoId = echoId,
    container = self.ui_layer
  })
  ed.layout.layoutWithMagin(echoSkill.icon, {left = 130}, true)
  echoSkill.icon:setPositionY(self.adaptZeroY + 255 / ed.display.scaleFactor / 2 + 16)
  self.echoSkill = echoSkill
  self.menu_touch_node:btRegisterButtonClick({
    button = echoSkill.icon,
    key = "echoSkill" .. echoId,
    pressScale = 0.98,
    pressHandler = function()
      echoSkill:onPressInMagicIcon()
    end,
    cancelPressHandler = function()
      echoSkill:onCancelPressInMagicIcon()
    end,
    clickHandler = function()
      echoSkill:onClickMagicIcon()
    end
  })
end

function BattleSceneUI:addRogueSkillIcon()
  if self.rogueSkill then
    self.rogueSkill:clear()
    self.rogueSkill = nil
  end
  local rogueSkillMgr = ed.engine:getRogueSkillMgr()
  if not rogueSkillMgr then
    return
  end
  local rogueSkill = ed.rogueSkillIcon.create({
    container = self.ui_layer
  })
  ed.layout.layoutWithMagin(rogueSkill.icon, {left = 130}, true)
  rogueSkill.icon:setPositionY(self.adaptZeroY + 255 / ed.display.scaleFactor / 2 + 16)
  self.rogueSkill = rogueSkill
  self.menu_touch_node:btRegisterButtonClick({
    button = rogueSkill.icon,
    key = "rogueSkill",
    force = true,
    pressScale = 0.98,
    pressHandler = function()
      rogueSkill:onPressInMagicIcon()
    end,
    cancelPressHandler = function()
      rogueSkill:onCancelPressInMagicIcon()
    end,
    clickHandler = function()
      rogueSkill:onClickMagicIcon()
    end
  })
end

function BattleSceneUI:createRealPvpUI()
  local container, ui = ed.editorui(ed.uieditor.kingsBattleUI)
  self.lagUI = ui
  self.ui_layer:addChild(container)
  ed.layout.layoutWithMagin(ui.image_bg, {top = 40}, true)
  local width = ed.display.winSize.width
  ui.image_bg:setPositionX(width / 2)
  local roundBattleData = ed.realarena.mgr.roundBattleData or {}
  local hostScore, guestScore = 0, 0
  for round, battleData in ipairs(roundBattleData) do
    if battleData.victory and battleData.is_host or not battleData.victory and not battleData.is_host then
      hostScore = hostScore + 1
    else
      guestScore = guestScore + 1
    end
  end
  ed.setLabelString(ui.label_score_blue, hostScore)
  ed.setLabelString(ui.label_score_red, guestScore)
  ed.setLabelStroke(ui.label_round, ed.toccc3(2827300), 1)
  ed.setLabelStroke(ui.label_delay_blue, ed.toccc3(2827300), 1)
  ed.setLabelStroke(ui.label_score_blue, ed.toccc3(2827300), 1)
  ed.setLabelFontName(ui.label_score_blue, ed.fontBold)
  ed.setLabelStroke(ui.label_delay_red, ed.toccc3(2827300), 1)
  ed.setLabelStroke(ui.label_score_red, ed.toccc3(2827300), 1)
  ed.setLabelFontName(ui.label_score_red, ed.fontBold)
  local hostUserSummary = ed.realarena.mgr.hostUserSummary
  local guestUserSummary = ed.realarena.mgr.guestUserSummary
  local isHost = ed.realarena.mgr.isHost
  local roundId = ed.realarena.mgr.roundId or 0
  ed.setLabelString(ui.label_round, string.format(T("\231\172\172%s\229\156\186"), roundId))
  local isAudience = hostUserSummary._role_id ~= ed.getRoleId() and guestUserSummary._role_id ~= ed.getRoleId()
  ui.self_icon_blue:setVisible(isHost and not isAudience)
  local blueName, blueNameWidth = ed.getPlayerName(hostUserSummary._name, hostUserSummary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  ui.panel_name_blue:addChild(blueName)
  blueName:setPosition(ccp(10, ui.panel_name_blue:getContentSize().height / 2))
  local blueHead = ed.getWholeHeadIcon({
    id = hostUserSummary._avatar
  })
  blueHead:setScale(0.7)
  ui.panel_head_blue:addChild(blueHead, 1)
  ed.layout.centerInParent(blueHead)
  ui.self_icon_red:setVisible(not isHost and not isAudience)
  local redName, redNameWidth = ed.getPlayerName(guestUserSummary._name, guestUserSummary._medal, {
    anchorPoint = ccp(1, 0.5),
    medalRight = true
  })
  ui.panel_name_red:addChild(redName)
  redName:setPosition(ccp(ui.panel_name_blue:getContentSize().width - 10, ui.panel_name_blue:getContentSize().height / 2))
  local redHead = ed.getWholeHeadIcon({
    id = guestUserSummary._avatar
  })
  redHead:setScale(0.7)
  ui.panel_head_red:addChild(redHead, 1)
  ed.layout.centerInParent(redHead)
  if isAudience then
    ui.image_chat_selection_bg:setVisible(false)
  else
    ui.image_chat_selection_bg:setVisible(true)
    ed.layout.layoutWithMagin(ui.image_chat_selection_bg, {left = 62}, true)
    self.chatSelectionWrap = ed.ui.KingsPvpChatSelectionWrap.create({
      ui = ui,
      touchListener = self.menu_touch_node,
      sendFunc = function(content)
        ed.realarena.network_mgr:RequestPvpChat(content)
      end
    })
  end
end

function BattleSceneUI:showRealPvpChatContentUI(data)
  if nil == ed.realarena.mgr.hostUserSummary or nil == ed.realarena.mgr.guestUserSummary then
    return
  end
  local isBlue
  if data._role_id == ed.realarena.mgr.hostUserSummary._role_id then
    isBlue = true
  elseif data._role_id == ed.realarena.mgr.guestUserSummary._role_id then
    isBlue = false
  else
    return
  end
  local parent = self.lagUI.image_bg
  local worldPos
  if isBlue then
    local size = self.lagUI.panel_head_blue:getContentSize()
    worldPos = self.lagUI.panel_head_blue:convertToWorldSpace(ccp(-5, size.height * 0.5 - 5))
  else
    local size = self.lagUI.panel_head_red:getContentSize()
    worldPos = self.lagUI.panel_head_red:convertToWorldSpace(ccp(size.width + 5, size.height * 0.5 - 5))
  end
  ed.ui.KingsPvpChatSelectionWrap.createChatContent(parent, worldPos, data._chat_data, isBlue, 1)
end

function BattleSceneUI:updateSignal()
  if not self.lagUI then
    return
  end
  local myLag = ed.realarena.network_mgr:GetLag()
  local myLagStatus = ed.realarena.network_mgr:GetLagStatus()
  local oppoLag = ed.realarena.network_mgr:GetOppoLag()
  local oppoLagStatus = ed.realarena.network_mgr:GetOppoLagStatus()
  local hostLag, hostLagStatus, guestLag, guestLagStatus
  if ed.realarena.mgr.isHost then
    hostLag = myLag
    hostLagStatus = myLagStatus
    guestLag = oppoLag
    guestLagStatus = oppoLagStatus
  else
    hostLag = oppoLag
    hostLagStatus = oppoLagStatus
    guestLag = myLag
    guestLagStatus = myLagStatus
  end
  ed.setLabelString(self.lagUI.label_delay_blue, string.format("%sms", hostLag))
  ed.setLabelString(self.lagUI.label_delay_red, string.format("%sms", guestLag))
end

function BattleSceneUI:removeBigBloodPanel(panel)
  for i = 1, #self.ui_list do
    local item = self.ui_list[i]
    if item == panel then
      table.remove(self.ui_list, i)
    end
  end
end

function BattleSceneUI:getBuffStackPos(index)
  local mode = self:getCurrentMode()
  local x = ed.display.center.x + 240
  local y = ed.display.winSize.height - 55
  x = x + index * 80
  return x, y
end

function BattleSceneUI:addBuffStack(buff)
  if ed.scene.running == true then
    local buffstack = ed.buffstackCreate(buff)
    buffstack.node:setScale(1.4)
    self.ui_layer:addChild(buffstack.node)
    table.insert(self.ui_list, buffstack)
    self.alreadyAddBuffIcon = true
    local idx = 0
    for _, p in ipairs(self.ui_list) do
      if p.buffstack then
        local x, y = self:getBuffStackPos(idx)
        buffstack.node:setPosition(ccp(x, y))
        idx = idx + 1
      end
    end
  end
end

function BattleSceneUI:addGoldBean()
  local goldBean = ed.goldBeanCreate()
  self.goldBean = goldBean
  self.ui_layer:addChild(goldBean.node)
  goldBean.node:setPosition(ccp(self.adaptZeroX + 90 / ed.display.scaleFactor + goldBean.bg:getContentSize().width / 2, self.adaptZeroY + self.heroes_panel:getContentSize().height / 2))
  table.insert(self.ui_list, goldBean)
end

function BattleSceneUI:addBeanMarker(pos)
  if not self.goldBean then
    return
  end
  self.goldBean.locked = true
  local res = "UI/alpha/1080P/common/money_dreampoint2_big.png"
  local sprt = ed.createSprite(res)
  sprt:setPosition(pos)
  self.ui_layer:addChild(sprt)
  
  local function handler()
    self.goldBean.locked = false
  end
  
  local dt = 1
  local action = CCMoveBy:create(dt, ccp(0, 70))
  action = CCEaseOut:create(action, 4)
  local action2 = Actions.flyNodeToMakerAndCleanup(sprt, ccp(50, 110), handler, dt)
  action = CCSequence:createWithTwoActions(action, action2)
  sprt:runAction(action)
end

function BattleSceneUI:closeEnergyBeanGainMp()
  for i, ui in ipairs(self.ui_list) do
    if ui.what == "HeroPanel" then
      ui.btn:setEnabled(false)
    end
  end
end

function BattleSceneUI:addEffect_UI(effect)
  self.ui_layer:addChild(effect.node or effect)
end

function BattleSceneUI:removeEffect_UI(effect)
  self.ui_layer:removeChild(effect.node or effect, true)
end

function BattleSceneUI:addParticle_UI(particle)
  self.ui_layer:addChild(particle)
end

function BattleSceneUI:removeParticle_UI(particle)
  self.ui_layer:removeChild(particle, true)
end

function BattleSceneUI:addSprite_UI(sprite)
  self.ui_layer:addChild(sprite)
end

function BattleSceneUI:removeSprite_UI(sprite)
  self.ui_layer:removeChild(sprite, true)
end

function BattleSceneUI:setImageDamage(damage)
  if self.image_damage then
    self.image_damage:removeAllChildrenWithCleanup(true)
    ed.createNumbers(self.image_damage, ed.formatNumWithComma(damage), -1, true, "white")
  end
end

function BattleSceneUI:updateEchoSkill(dt)
  if self.echoSkill then
    self.echoSkill:update(dt)
  end
  if self.rogueSkill then
    self.rogueSkill:update(dt)
  end
end

local sub = string.sub
local createNumbers = ed.createNumbers
local insert = table.insert
local pairs = pairs
local ipairs = ipairs

function BattleSceneUI:updateui(dt, paused)
  self:updateSignal()
  local new_list = {}
  for _, ui in ipairs(self.ui_list) do
    ui:update(dt)
    if ui.terminated then
      if ui.type == "HP" and self.battle_stage_node and not tolua.isnull(self.battle_stage_node) then
        self.battle_stage_node:removeFromParentAndCleanup(true)
        self.battle_stage_node = nil
      end
    else
      insert(new_list, ui)
    end
  end
  self.ui_list = new_list
  self:updateTimer()
  self:updateExtra(dt, paused)
  self:updateAddSpeedBtnState()
  self:updateBigHpBarPos()
end

function BattleSceneUI:showMonsterLootsOnUI(list, monster)
  for i, v in ipairs(list) do
    local _type = v.type
    local _id = v.id
    local icon
    if _type == "equip" then
      icon = ed.lookupDataTable("equip", "Icon", _id)
    elseif _type == "hero" then
      icon = ed.getUnitPortrait(_id)
    elseif _type == "book" then
      EDDebug("Skill books not supported")
    end
    local loot = ed.LootCreate(icon, _type, monster, i, _id)
    loot.node:setScale(ed.engine.unitScale)
    table.insert(self.ui_list, loot)
    self.ui_layer:addChild(loot.node)
  end
end

local function removeBall(self, idx, force)
  if self.ballSlots[idx] and self.ballSlots[idx].status ~= 5 and self.ballSlots[idx].status ~= 6 then
    self.ballSlots[idx].terminated = true
    self.ballSlots[idx].node:setVisible(false)
    self.ballSlots[idx] = nil
    return true
  end
  return false
end

BattleSceneUI.removeBall = removeBall

local function removeBallBar(self)
  for idx, p in ipairs(self.ui_list) do
    if p.ball_bar then
      p.ball_bar:removeBall()
      break
    end
  end
end

BattleSceneUI.removeBallBar = removeBallBar

local function removeAllBall(self)
  for k, v in pairs(self.ballSlots) do
    local picknode = ed.createFcaNode("eff_UI_Kael_pickball_" .. v.ballType)
    picknode:setPosition(v.node:getPosition())
    ed.scene:addEffect(picknode, 2)
    v.node:setVisible(false)
  end
  for idx, p in ipairs(self.ui_list) do
    if p.ball_bar then
      p.ball_bar:removeBall()
    end
  end
end

BattleSceneUI.removeAllBall = removeAllBall

local function addLootMarker(self, num)
  num = num or 1
  local value
  if ed.engine and ed.engine.loot_count then
    ed.engine.loot_count = ed.engine.loot_count + num
    value = ed.engine.loot_count
  else
    value = 0
  end
  self.lootmarker_text:setString(value)
  if 0 < num then
    local duration = 0.3
    local holo = ed.createSprite("UI/alpha/1080P/common/holo.png")
    holo:setPosition(ccp(self.loot:getContentSize().width / 2, self.loot:getContentSize().height / 2))
    self.loot:addChild(holo)
    holo:setScale(0.4)
    local beat = CCScaleTo:create(duration, 1.2)
    holo:setOpacity(255)
    local blink = CCFadeTo:create(duration, 0)
    local action = CCSpawn:create(ccArrayMake(beat, blink))
    action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
      holo:removeFromParentAndCleanup(true)
    end))
    holo:runAction(action)
  end
end

BattleSceneUI.addLootMarker = addLootMarker

local function addGold(self, num)
  local value
  if ed.engine and ed.engine.gold_count then
    ed.engine.gold_count = ed.engine.gold_count + num
    value = ed.engine.gold_count
  else
    value = 0
  end
  local str = ed.formatNumWithComma(value)
  self.goldmarker_text:setString(str)
  if 0 < num then
    local duration = 0.1
    local node = self.goldmarker_text
    node:setOpacity(255)
    node:setScale(1.25)
    node:runAction(CCSpawn:create(ccArrayMake({
      CCFadeTo:create(duration, 255),
      CCScaleTo:create(duration, 1)
    })))
  end
end

BattleSceneUI.addGold = addGold

local function createButtonWithMask(image, mask)
  local normal = ed.createSprite(image)
  local selected = ed.createSprite(image)
  local size = selected:getContentSize()
  local mask = ed.createSprite(mask)
  mask:setPosition(ccp(size.width * 0.5, size.height * 0.5))
  selected:addChild(mask, 1)
  local btn = CCMenuItemSprite:create(normal, selected)
  return btn
end

BattleSceneUI.createButtonWithMask = createButtonWithMask

local function createIcons(self)
  local battleModeInfo = ed.scene.battleModeInfo
  if not battleModeInfo.pvpInfo.self_summary or not battleModeInfo.pvpInfo.oppo_summary then
    return
  end
  local self_summary = battleModeInfo.pvpInfo.self_summary
  local oppo_summary = battleModeInfo.pvpInfo.oppo_summary
  local pos_host = ccp(100, 440)
  local pos_slave = ccp(550, 440)
  local scale_head = 0.7
  local param = {
    id = self_summary._avatar,
    level = self_summary._level,
    scale = scale_head,
    name = self_summary._name
  }
  if self_summary._medal then
    param.medal = self_summary._medal
  end
  local host_head = ed.getWholeHeadIcon(param)
  self.ui_layer:addChild(host_head)
  host_head:setPosition(pos_host)
  param = {
    id = oppo_summary._avatar,
    level = oppo_summary._level,
    scale = scale_head,
    name = oppo_summary._name,
    vip = oppo_summary._vip > 0
  }
  if oppo_summary._medal then
    param.medal = oppo_summary._medal
  end
  local slave_head = ed.getWholeHeadIcon(param)
  self.ui_layer:addChild(slave_head)
  slave_head:setPosition(pos_slave)
end

local function createReplayUI(self, extraInfo)
  local battleModeInfo = ed.scene.battleModeInfo
  if not battleModeInfo.replayInfo then
    return
  end
  local info = battleModeInfo.replayInfo
  local bShowBaseInfo = not info.hide_board
  if not info.userName and not info.oppoUserName then
    return
  end
  local title = ed.createSprite("UI/alpha/1080P/battle/video_vs.png")
  title:setPosition(ccp(self.adaptCenterX, self.adaptMaxY - title:getContentSize().height / 2 - 53 / ed.display.scaleFactor))
  self.ui_layer:addChild(title)
  local homeGround = 2
  if extraInfo and extraInfo.homeGround then
    homeGround = extraInfo.homeGround
  end
  if bShowBaseInfo then
    local attack = {}
    local uiRes = {
      {
        t = "Sprite",
        base = {name = "ui"},
        layout = {},
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "iconParent", parent = "ui"},
        layout = {},
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "name",
          text = "",
          size = 16,
          parent = "ui"
        },
        layout = {},
        config = {
          color = ccc3(ed.colorToStr("#fffce7")),
          stroke = {
            color = ccc3(ed.colorToStr("#000000")),
            size = 2
          }
        }
      }
    }
    local readNode = ed.readnode.create(self.ui_layer, attack)
    readNode:addNode(uiRes)
    attack.name:setAnchorPoint(ccp(0, 0.5))
    local name = ed.getPlayerName(info.userName, info.userMedal, {
      anchorPoint = ccp(0, 0.5)
    })
    ed.UITool.replaceUI(attack, "ui", "name", name)
    if homeGround == 0 then
      local homeGroundBg = ed.createSpriteTools({
        res = "UI/alpha/1080P/pvp/arena_background_owner_small.png",
        pos = ccp(50, 12),
        parent = attack.iconParent
      })
      local label = ed.ui.gradientLabel.create({
        text = T("\230\136\152\230\150\151\228\184\187\229\156\186"),
        fontName = ed.fontBold,
        fontSize = 12,
        startColor = ed.toccc3(16777174),
        endColor = ed.toccc3(16771719),
        strokeColor = ed.toccc3(8729870),
        strokeSize = 1.5
      })
      label.node:setPosition(48, 10)
      homeGroundBg:addChild(label.node)
    end
    local head = ed.getHeroIconByID({
      id = info.userAvatar,
      vip = 0 < (info.vip or 0)
    })
    if head then
      head:setScale(0.6)
      attack.iconParent:addChild(head)
    end
    local video_name_bg = ed.createSprite("UI/alpha/1080P/battle/video_name_bg.png")
    video_name_bg:setAnchorPoint(ccp(0, 0.94))
    attack.iconParent:addChild(video_name_bg, -1)
    attack.name:setPosition(ccp(head:getContentSize().width / 2, -10))
    attack.ui:setPosition(ccp(self.adaptZeroX + 438 / ed.display.scaleFactor + head:getContentSize().width / 2, title:getPositionY()))
    local enemy = {}
    readNode = ed.readnode.create(self.ui_layer, enemy)
    readNode:addNode(uiRes)
    enemy.name:setAnchorPoint(ccp(1, 0.5))
    local name = ed.getPlayerName(info.oppoUserName, info.oppoMedal, {
      anchorPoint = ccp(1, 0.5),
      medalRight = true
    })
    ed.UITool.replaceUI(enemy, "ui", "name", name)
    if homeGround == 1 then
      local homeGroundBg = ed.createSpriteTools({
        res = "UI/alpha/1080P/pvp/arena_background_owner_small.png",
        pos = ccp(-50, 12),
        parent = enemy.iconParent
      })
      local label = ed.ui.gradientLabel.create({
        text = T("\230\136\152\230\150\151\228\184\187\229\156\186"),
        fontName = ed.fontBold,
        fontSize = 12,
        startColor = ed.toccc3(16777174),
        endColor = ed.toccc3(16771719),
        strokeColor = ed.toccc3(8729870),
        strokeSize = 1.5
      })
      label.node:setPosition(48, 10)
      homeGroundBg:addChild(label.node)
    end
    local head = ed.getHeroIconByID({
      id = info.oppoUserAvatar,
      vip = 0 < (info.oppovip or 0)
    })
    if head then
      head:setScale(0.6)
      enemy.iconParent:addChild(head)
    end
    local video_name_bg = ed.createSprite("UI/alpha/1080P/battle/video_name_bg.png")
    video_name_bg:setAnchorPoint(ccp(0, 0.94))
    enemy.iconParent:addChild(video_name_bg, -1)
    enemy.name:setPosition(ccp(-head:getContentSize().width / 2, -10))
    video_name_bg:setScaleX(-1)
    enemy.ui:setPosition(ccp(self.adaptMaxX - 438 / ed.display.scaleFactor - head:getContentSize().width / 2 + 10, title:getPositionY()))
  end
  local buffResTbl = {
    [316] = "mage",
    [317] = "armory",
    [318] = "blacksmith",
    [319] = "totem",
    [320] = "well"
  }
  local buffPosConfig = {
    [1] = ccp(110, 388),
    [2] = ccp(610, 388)
  }
  local self_buffs = battleModeInfo.replayInfo.self_buffs or {}
  for idx, buff_id in ipairs(self_buffs) do
    local buff_icon = ed.createSprite("UI/alpha/HVGA/gcw/chaoswar_buff_" .. buffResTbl[buff_id] .. ".png")
    buff_icon:setPosition(ccpAdd(buffPosConfig[1], ccp(41 * (idx - 1), 0)))
    buff_icon:setScale(0.95)
    self.ui_layer:addChild(buff_icon)
  end
  local oppo_buffs = battleModeInfo.replayInfo.oppo_buffs or {}
  for idx, buff_id in ipairs(oppo_buffs) do
    local buff_icon = ed.createSprite("UI/alpha/HVGA/gcw/chaoswar_buff_" .. buffResTbl[buff_id] .. ".png")
    buff_icon:setPosition(ccpAdd(buffPosConfig[2], ccp(41 * (idx - 1), 0)))
    buff_icon:setScale(0.95)
    self.ui_layer:addChild(buff_icon)
  end
end

function BattleSceneUI:createCheakidUI()
  local battleModeInfo = ed.scene.battleModeInfo
  local checkidStr = T("\231\188\150\229\143\183:")
  local checkid = 0
  local currentMode = self:getCurrentMode()
  print("______________________________________", currentMode)
  if currentMode == "replay" then
    checkid = battleModeInfo.replayInfo.checkid
  elseif currentMode == "babelReplay" then
    checkid = battleModeInfo.babelReplayMode.checkid
  elseif currentMode == "babelMonstersealReplay" then
    checkid = battleModeInfo.babelMonstersealReplayMode.checkid
  elseif currentMode == "multiArenaReplay" then
    checkid = battleModeInfo.multiArenaReplayMode.checkid
  elseif currentMode == "videoplayer" then
    checkid = battleModeInfo.videoplayer.checkid
  end
  checkid = checkid or 0
  checkidStr = checkidStr .. checkid
  local checkidLabel = richText:new()
  checkidLabel:setString(string.format(T("<text|battle_reply_yellow|\230\136\152\230\150\151\229\155\158\230\148\190 ><sprite|UI/alpha/1080P/battle/video_line.png><text|battle_reply_white| %s>"), checkidStr))
  checkidLabel:setVerticalCenter()
  self.ui_layer:addChild(checkidLabel.rootNode)
  local hero_panel_size = self.heroes_panel:getContentSize()
  local _, label_height = checkidLabel:getSize()
  checkidLabel:setPosition(ccp(self.adaptCenterX - hero_panel_size.width / 2, self.adaptZeroY + hero_panel_size.height + 34 / ed.display.scaleFactor + label_height / 2))
end

function BattleSceneUI:showCalculateDamageUI()
  local currentMode = self:getCurrentMode()
  if ed.scene:canShowCalculateDamageUI() then
    local widhtWin = ed.display.winSize.width
    local heightWin = ed.display.winSize.height
    local damage_title = ed.createSprite("UI/alpha/1080P/common/dreamland_totaldam.png")
    damage_title:setPosition(widhtWin / 2 + 40, heightWin - 28)
    damage_title:setAnchorPoint(ccp(0, 0.5))
    self.ui_layer:addChild(damage_title)
    local damWid = damage_title:getContentSize().width
    if 100 < damWid then
      damage_title:setScale(100 / damWid)
    end
    local damage = ed.createSprite()
    ed.createNumbers(damage, "0", -1, true, "white")
    damage:setPosition(widhtWin / 2 + 30, heightWin - 28)
    damage:setAnchorPoint(ccp(1, 0.5))
    self.ui_layer:addChild(damage)
    self.image_damage = damage
  end
end

function BattleSceneUI:showConditionScorePanel()
  for conditionId, condition in pairs(ed.engine.battleConditionList) do
    if condition.getShowData then
      local conditionScorePanel = ed.ui.conditionScorePanel.create(condition)
      self.conditionScorePanel = conditionScorePanel
      self.ui_layer:addChild(conditionScorePanel.container)
      local widthWin = ed.display.winSize.width
      local heightWin = ed.display.winSize.height
      conditionScorePanel.container:setPosition(widthWin / 2, heightWin - 30)
      table.insert(self.ui_list, conditionScorePanel)
      break
    end
  end
end

function BattleSceneUI:playDamageGoalCompletedAnim(count)
  local hint_pos = ccp(ed.display.winSize.width / 2, ed.display.winSize.height - 100)
  local suffix_node = ed.createttf(T("%s\228\188\164\229\174\179\232\190\190\230\136\144\239\188\129", ed.numberFormat(count * 10000)), 26)
  ed.setLabelColor(suffix_node, ed.toccc3(16736583))
  ed.setLabelStroke(suffix_node, ed.toccc3(0), 2.5)
  suffix_node:setAnchorPoint(ccp(0.5, 0.5))
  suffix_node:setCascadeOpacityEnabled(true)
  local hint = ed.createSprite()
  hint:setAnchorPoint(ccp(0.5, 0.5))
  hint:setPosition(hint_pos)
  self.ui_layer:addChild(hint)
  hint:addChild(suffix_node)
  local duration_show = 0.2
  local fade_in = CCFadeIn:create(duration_show)
  local scale_big = CCScaleTo:create(duration_show, 1.5)
  local action_show = CCSpawn:create(ed.ccArrayMake(fade_in, scale_big))
  local duration_last = 0.3
  local scale_small = CCScaleTo:create(duration_last, 1)
  local duration_disappear = 1
  local move_to = CCMoveTo:create(duration_disappear, ccp(hint_pos.x, hint_pos.y + 30))
  local fade_out = CCFadeOut:create(duration_disappear)
  local action_disappear = CCSpawn:create(ed.ccArrayMake(fade_out, move_to))
  local action = CCSequence:create(ed.ccArrayMake(action_show, scale_small, action_disappear, CCCallFunc:create(function()
    hint:removeFromParentAndCleanup(true)
  end)))
  hint:runAction(action)
end

function BattleSceneUI:isNextBtnEnable()
  return self.next_btn:isEnabled()
end

function BattleSceneUI:nextBtnTap()
  nextBtnTapHandler()
end

local function showNextButton(self)
  local btn = self.next_btn
  btn:setVisible(true)
  btn:setEnabled(true)
  local action = CCSequence:createWithTwoActions(CCMoveBy:create(0.65, ccp(30, 0)), CCMoveBy:create(0.65, ccp(-30, 0)))
  action = CCRepeatForever:create(action)
  btn:runAction(action)
end

BattleSceneUI.showNextButton = showNextButton

local function showJumpButton(self)
  local btn = self.jump_btn
  btn:setVisible(true)
  btn:setEnabled(true)
  local action = CCSequence:createWithTwoActions(CCMoveBy:create(0.65, ccp(30, 0)), CCMoveBy:create(0.65, ccp(-30, 0)))
  action = CCRepeatForever:create(action)
  btn:runAction(action)
end

BattleSceneUI.showJumpButton = showJumpButton

local function updateTimer(self)
  if not self.timer then
    return
  end
  local seconds = math.ceil(ed.engine.time_limit)
  local node = self.timer.text
  local FVTimeZoneLevel = ed.scene.FVTimeZoneLevel
  if FVTimeZoneLevel and 0 < FVTimeZoneLevel then
    local str
    if math.random() < 0.4 then
      str = string.format("%02i:%02i", math.random() * 10, math.random() * 100)
    else
      local seconds = math.ceil(self.FVTimeZoneLockTime)
      str = string.format("%02i:%02i", seconds / 60, seconds % 60)
    end
    node:setString(str)
  elseif seconds ~= self.timer.value then
    self.timer.value = seconds
    local str = string.format("%02i:%02i", seconds / 60, seconds % 60)
    node:setString(str)
    if seconds < 20 then
      self.timer.mask:setVisible(true)
      node:runAction(CCTintTo:create(1, 255, 210, 210))
    end
  end
  if not ed.engine.running then
    self.timer.mask:setVisible(false)
  end
end

BattleSceneUI.updateTimer = updateTimer

local function addTimeOutUI(self)
  local node = ed.createSprite("UI/alpha/1080P/common/battletext_timeover.png")
  node:setScale(0)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseExponentialOut:create(action)
  node:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 1.5))
  self.ui_layer:addChild(node)
  node:runAction(action)
end

BattleSceneUI.addTimeOutUI = addTimeOutUI

function BattleSceneUI:doMainLayerTouch()
  local function handler(event, x, y)
    for _, handler in ipairs(self.handlerList) do
      xpcall(function()
        handler(event, x, y)
      end, EDDebug)
    end
    self:checkUILayerClicked(event, x, y)
    return true
  end
  
  return handler
end

function BattleSceneUI:addMianLayerTouchHandler(handler)
  table.insert(self.handlerList, handler)
end

function BattleSceneUI:createHeroPanel()
  self.leftPanelWidth = 60
  self.heroes_panel = ed.createScale9Sprite("UI/alpha/1080P/battle/battle_hero_bg.png", CCRectMake(10, 5, 10, 2))
  self.heroes_panel:setContentSize(CCSizeMake(1079 / ed.display.scaleFactor, 255 / ed.display.scaleFactor))
  self.heroes_panel:setPosition(ccp(self.adaptCenterX, self.adaptZeroY + 255 / ed.display.scaleFactor / 2 + 8))
  self.ui_layer:addChild(self.heroes_panel)
end

function BattleSceneUI:createMultiHeroPanel()
  local multiHeroPanel = ed.ui.multiHeroPanel.create()
  self.multiHeroPanel = multiHeroPanel
  self.ui_layer:addChild(multiHeroPanel.container)
  local size = multiHeroPanel.container:getContentSize()
  local winSize = ed.display.winSize
  local edge = 230
  local scale = math.min((winSize.width - edge) / size.width, 1)
  multiHeroPanel.container:setScale(scale)
  multiHeroPanel.container:setPosition(ccp(self.adaptCenterX, self.adaptZeroY + 255 / ed.display.scaleFactor / 2 - 5))
  table.insert(self.ui_list, multiHeroPanel)
end

function BattleSceneUI:createObHeroPanel()
  local panelSize = CCSizeMake(940 / ed.display.scaleFactor, 254 / ed.display.scaleFactor)
  self.obHeroPanelBlue = ed.createScale9Sprite("UI/alpha/1080P/newkingspvp/ob/battle_2.png")
  self.obHeroPanelBlue:setContentSize(panelSize)
  self.obHeroPanelBlue:setPosition(ccp(self.adaptCenterX - panelSize.width / 2, self.adaptZeroY + 255 / ed.display.scaleFactor / 2 + 8))
  self.ui_layer:addChild(self.obHeroPanelBlue)
  self.obHeroPanelRed = ed.createScale9Sprite("UI/alpha/1080P/newkingspvp/ob/battle_1.png")
  self.obHeroPanelRed:setContentSize(panelSize)
  self.obHeroPanelRed:setPosition(ccp(self.adaptCenterX + panelSize.width / 2, self.adaptZeroY + 255 / ed.display.scaleFactor / 2 + 8))
  self.ui_layer:addChild(self.obHeroPanelRed)
end

function BattleSceneUI:createVoicetalk(mode, priority)
  local touch_node = ed.ui.basetouchnode.btCreate()
  self.main_layer:setTouchEnabled(true)
  self.main_layer:registerScriptTouchHandler(touch_node:btGetMainTouchHandler(), false, -130, false)
  local param = {
    touchNode = touch_node,
    priority = priority or -300,
    uimode = mode or 1
  }
  self.voicetalk = ed.voicetalk.getInstance()
  local container = self.voicetalk:createVoiceTalkUI(param)
  self.ui_layer:addChild(container)
end

function BattleSceneUI:openVoicetalk(partner)
  if self.voicetalk then
    self.voicetalk:openVoicetalk(partner)
  end
end

function BattleSceneUI:closeVoicetalk()
  if self.voicetalk then
    self.voicetalk:closeVoicetalk()
  end
end

function BattleSceneUI:setVoicetalkUIPosition(position)
  if self.voicetalk and self.voicetalk.mainLayer then
    local voicetalkMainLayer = self.voicetalk.mainLayer
    voicetalkMainLayer:setPosition(position)
  end
end

function BattleSceneUI:createPauseButton()
  local UIRes = {
    {
      t = "DGButton",
      base = {
        capInsets = CCRectMake(25, 25, 4, 5),
        name = "pause_btn",
        normal = "UI/alpha/1080P/common/break_butt_bj.png",
        press = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      layout = {},
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "pause",
        res = "UI/alpha/1080P/battle/battle_pause.png",
        parent = "pause_btn"
      },
      layout = {},
      config = {}
    }
  }
  local container, ui = ed.editorui(UIRes)
  local pause_btn_size = ui.pause_btn:getContentSize()
  ui.pause_btn:setPosition(ccp(self.adaptZeroX + 90 / ed.display.scaleFactor + pause_btn_size.width / 2, self.adaptMaxY - 20 / ed.display.scaleFactor - pause_btn_size.height / 2))
  ui.pause:setPosition(ccp(pause_btn_size.width / 2, pause_btn_size.height / 2))
  self.ui_layer:addChild(container)
  self.pause_btn = ui.pause_btn
  self.menu_touch_node:btRegisterButtonClick({
    button = self.pause_btn,
    key = "pause_btn",
    clickHandler = function()
      returnBtnTapHandler()
    end
  })
end

function BattleSceneUI:createPeakArenaRoundUI(round)
  local roundBg = ed.createSprite("UI/alpha/1080P/toparena/toparena_battle_round_bg.png")
  roundBg:setPositionX(ed.display.winSize.width / 2)
  self.ui_layer:addChild(roundBg)
  ed.layout.layoutWithMagin(roundBg, {top = 20})
  local roundIdx = ed.createttf(T("\231\172\172%s\229\156\186", round), 24)
  ed.setLabelColor(roundIdx, ed.toccc3(16776423))
  ed.setLabelStroke(roundIdx, ed.toccc3(0), 1)
  roundBg:addChild(roundIdx)
  ed.layout.centerInParent(roundIdx)
  if round == 1 then
    local roundStart = ed.createScale9Sprite("UI/alpha/1080P/common/title_light.png", CCRectMake(25, 27, 1, 2))
    local label = ed.createttf(T("\230\136\152\230\150\151\229\188\128\229\167\139"), 61)
    roundStart:addChild(label)
    roundStart:setCascadeOpacityEnabled(true)
    ed.setLabelColor(label, ed.toccc3(16776876))
    ed.setLabelStroke(label, ed.toccc3(12605952), 3)
    local labelSize = label:getContentSize()
    roundStart:setContentSize(CCSizeMake(labelSize.width, labelSize.height))
    ed.layout.centerInParent(label)
    self.ui_layer:addChild(roundStart)
    ed.layout.centerInScreen(roundStart)
    roundStart:setOpacity(0)
    roundStart:setScale(5)
    local fadeIn = CCFadeIn:create(0.3)
    local scaleTo = CCScaleTo:create(0.3, 1)
    local spawn = CCSpawn:create(ccArrayMake(fadeIn, scaleTo))
    local delay = CCDelayTime:create(0.5)
    local fadeOut = CCFadeOut:create(0.1)
    local action = CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), spawn, delay, fadeOut))
    roundStart:runAction(action)
  else
    roundIdx:setScale(5)
    roundIdx:runAction(CCScaleTo:create(0.3, 1))
  end
end

function BattleSceneUI:createBattleStage(wave_id)
  local totalWaves = ed.engine and ed.engine.stage_info and ed.engine.stage_info.Waves or 3
  self.battle_stage_line = CCSprite:create("UI/alpha/1080P/battle/battle_stage_line.png")
  local battle_stage_line_size = self.battle_stage_line:getContentSize()
  self.battle_stage_line:setPosition(ccp(0, 0))
  local x, y = self.battle_stage_line:getPosition()
  self.battle_stage_id = CCSprite:create(T("UI/alpha/1080P/battle/battle_stage_%s.png", tostring(wave_id)))
  self.battle_stage_id:setPosition(ccp(x - (battle_stage_line_size.width + self.battle_stage_id:getContentSize().width) / 2, y))
  self.battle_stage_total = CCSprite:create(T("UI/alpha/1080P/battle/battle_stage_%s.png", tostring(totalWaves)))
  self.battle_stage_total:setPosition(ccp(x + (battle_stage_line_size.width + self.battle_stage_total:getContentSize().width) / 2, y))
  self.battle_stage_node = CCNode:create()
  self.battle_stage_node:setPosition(ccp(self.adaptCenterX, self.adaptMaxY - 44 / ed.display.scaleFactor - battle_stage_line_size.height / 2 + 4))
  self.battle_stage_node:addChild(self.battle_stage_line)
  self.battle_stage_node:addChild(self.battle_stage_id)
  self.battle_stage_node:addChild(self.battle_stage_total)
  self.ui_layer:addChild(self.battle_stage_node)
end

function BattleSceneUI:showBattleStage(visible)
  if not tolua.isnull(self.battle_stage_node) then
    self.battle_stage_node:setVisible(visible)
  end
end

function BattleSceneUI:createGoldAndLoot()
  local UIRes = {
    {
      config = {},
      t = "Sprite",
      base = {
        name = "lootmarker",
        res = "UI/alpha/1080P/battle/battle_resource_bg.png"
      },
      layout = {}
    },
    {
      t = "DGButton",
      base = {
        name = "loot",
        normal = "UI/alpha/1080P/common/chest1.png",
        press = "UI/alpha/1080P/common/chest1.png",
        parent = "lootmarker"
      },
      layout = {},
      config = {}
    },
    {
      config = {
        color = ccc3(ed.colorToStr("#fffce7")),
        stroke = {
          color = ccc3(ed.colorToStr("#000000")),
          size = 2
        }
      },
      t = "Label",
      base = {
        name = "lootmarker_text",
        parent = "lootmarker",
        text = "",
        size = 18
      },
      layout = {}
    },
    {
      config = {},
      t = "Sprite",
      base = {
        name = "goldmarker",
        res = "UI/alpha/1080P/battle/battle_resource_bg.png"
      },
      layout = {}
    },
    {
      t = "Sprite",
      base = {
        name = "gold",
        res = "UI/alpha/1080P/icon/gold.png",
        parent = "goldmarker"
      },
      layout = {},
      config = {}
    },
    {
      config = {
        color = ccc3(ed.colorToStr("#fffce7")),
        stroke = {
          color = ccc3(ed.colorToStr("#000000")),
          size = 2
        }
      },
      t = "Label",
      base = {
        name = "goldmarker_text",
        parent = "goldmarker",
        text = "",
        size = 18
      },
      layout = {}
    }
  }
  local container, ui = ed.editorui(UIRes)
  local lootmarker_size = ui.lootmarker:getContentSize()
  ui.lootmarker:setPosition(ccp(self.adaptMaxX - 90 / ed.display.scaleFactor - lootmarker_size.width / 2, self.adaptMaxY - 37 / ed.display.scaleFactor - lootmarker_size.height / 2))
  ui.loot:setPosition(ccp(lootmarker_size.width / 2 + 52 / ed.display.scaleFactor, lootmarker_size.height / 2 - 2 / ed.display.scaleFactor))
  ui.lootmarker_text:setPosition(ccp(lootmarker_size.width / 2 - 28 / ed.display.scaleFactor, lootmarker_size.height / 2))
  local lootmarker_x, lootmarker_y = ui.lootmarker:getPosition()
  local goldmarker_size = ui.goldmarker:getContentSize()
  ui.goldmarker:setPosition(ccp(lootmarker_x - (goldmarker_size.width + lootmarker_size.width) / 2 - 34 / ed.display.scaleFactor, lootmarker_y))
  ui.gold:setPosition(ccp(goldmarker_size.width / 2 + 52 / ed.display.scaleFactor, goldmarker_size.height / 2 - 2 / ed.display.scaleFactor))
  ui.goldmarker_text:setPosition(ccp(goldmarker_size.width / 2 - 28 / ed.display.scaleFactor, goldmarker_size.height / 2))
  self.ui_layer:addChild(container)
  self.lootmarker = ui.lootmarker
  self.loot = ui.loot
  self.lootmarker_text = ui.lootmarker_text
  self.loot_pos = ccp(ui.lootmarker:getPositionX() + 52 / ed.display.scaleFactor, ui.lootmarker:getPositionY() - 2 / ed.display.scaleFactor)
  self.goldmarker = ui.goldmarker
  self.gold_pos = ccp(ui.goldmarker:getPositionX() + 52 / ed.display.scaleFactor, ui.goldmarker:getPositionY() - 2 / ed.display.scaleFactor)
  self.goldmarker_text = ui.goldmarker_text
  self:addLootMarker(0)
  self:addGold(0)
end

function BattleSceneUI:createTimer(currentMode)
  local UIRes = {
    {
      config = {},
      t = "Sprite",
      base = {
        name = "time_bg",
        z = 0,
        res = "UI/alpha/1080P/battle/battle_resource_bg.png"
      },
      layout = {}
    },
    {
      config = {},
      t = "Sprite",
      base = {
        name = "time_mask",
        z = 0,
        res = "UI/alpha/1080P/battle/battle_resource_bg_2.png"
      },
      layout = {}
    },
    {
      t = "DGButton",
      base = {
        name = "time_btn",
        z = 1,
        normal = "UI/alpha/1080P/common/hourglass.png",
        press = "UI/alpha/1080P/common/hourglass.png"
      },
      layout = {},
      config = {}
    },
    {
      config = {
        color = ccc3(ed.colorToStr("#fffce7")),
        stroke = {
          color = ccc3(ed.colorToStr("#000000")),
          size = 2
        }
      },
      t = "Label",
      base = {
        name = "time_text",
        z = 1,
        text = "",
        size = 18
      },
      layout = {}
    }
  }
  local container, ui = ed.editorui(UIRes)
  local time_bg_size = ui.time_bg:getContentSize()
  local pause_btn_x, pause_btn_y = self.pause_btn:getPosition()
  if currentMode == "realarena" then
    ui.time_bg:setPosition(ccp(time_bg_size.width / 2 + 46 / ed.display.scaleFactor, pause_btn_y))
  else
    ui.time_bg:setPosition(ccp(pause_btn_x + (self.pause_btn:getContentSize().width + time_bg_size.width) / 2 + 46 / ed.display.scaleFactor, pause_btn_y))
  end
  local time_bg_x, time_bg_y = ui.time_bg:getPosition()
  ui.time_mask:setPosition(ccp(time_bg_x, time_bg_y))
  ui.time_btn:setPosition(ccp(time_bg_x + 52 / ed.display.scaleFactor, time_bg_y))
  ui.time_text:setPosition(ccp(time_bg_x - 28 / ed.display.scaleFactor, time_bg_y))
  self.ui_layer:addChild(container)
  self.timer = {
    bg = ui.time_bg,
    mask = ui.time_mask,
    hourglass = ui.time_btn,
    text = ui.time_text,
    value = -1
  }
  local action = CCSequence:createWithTwoActions(CCFadeTo:create(0.8, 100), CCFadeTo:create(0.2, 255))
  action = CCRepeatForever:create(action)
  self.timer.mask:runAction(action)
  self.timer.mask:setVisible(false)
  self.menu_touch_node:btRegisterButtonClick({
    button = ui.time_btn,
    key = "time_btn",
    clickHandler = function()
      local stageInfo = ed.engine.stage_info
      local stageId = (stageInfo or {})["Stage ID"]
      if stageId == -2 then
        return
      end
      self:skipHandler()
    end
  })
end

function BattleSceneUI:skipHandler()
  if ed.debug_mode then
    ed.engine:victory(true)
  end
end

function BattleSceneUI:createSpeedButton()
  if not tolua.isnull(self.speedNode) then
    self.speedNode:removeFromParentAndCleanup(true)
    self.speedNode = nil
  end
  local isOpenMode = ed.checkIsOpenAddSpeed()
  if isOpenMode then
    local node = CCNode:create()
    local layer = CCLayer:create()
    layer:setTouchEnabled(true)
    node:addChild(layer)
    local speedButtonBg = ed.createNode({
      t = "Sprite",
      name = "speedButtonBg",
      base = {
        res = "UI/alpha/1080P/battle/battle_auto_bg_1.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5)
      }
    }, layer)
    local speedButtonBg_size = speedButtonBg:getContentSize()
    speedButtonBg:setPosition(ccp(self.adaptMaxX - 90 / ed.display.scaleFactor - speedButtonBg_size.width / 2, self.adaptZeroY + 16 / ed.display.scaleFactor + speedButtonBg_size.height / 2))
    self.speedButton = {}
    local speedButton1 = ed.createNode({
      t = "Sprite",
      name = "speedButton1",
      base = {
        res = "UI/alpha/1080P/battle/battle_fastforward_unchoose.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(speedButtonBg_size.width / 2, speedButtonBg_size.height / 2)
      }
    })
    speedButtonBg:addChild(speedButton1)
    table.insert(self.speedButton, speedButton1)
    local speedButton2 = ed.createNode({
      t = "Sprite",
      name = "speedButton2",
      base = {
        res = "UI/alpha/1080P/battle/battle_fastforward_2.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(speedButtonBg_size.width / 2, speedButtonBg_size.height / 2)
      }
    })
    speedButtonBg:addChild(speedButton2)
    table.insert(self.speedButton, speedButton2)
    local speedButton3 = ed.createNode({
      t = "Sprite",
      name = "speedButton3",
      base = {
        res = "UI/alpha/1080P/battle/battle_fastforward_3.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(speedButtonBg_size.width / 2, speedButtonBg_size.height / 2)
      }
    })
    speedButtonBg:addChild(speedButton3)
    table.insert(self.speedButton, speedButton3)
    self.ui = self.ui or {}
    self.ui.speedButtonBg = speedButtonBg
    self:updateSpeedButtonImg()
    layer:registerScriptTouchHandler(function(event, x, y)
      if tolua.isnull(speedButtonBg) then
        return false
      end
      if event == "began" then
        if ed.checkVisible(speedButtonBg) and ed.containsPoint(speedButtonBg, x, y) then
          return true
        else
          return false
        end
      elseif event == "ended" and ed.checkVisible(speedButtonBg) and ed.containsPoint(speedButtonBg, x, y) then
        self:refreshAddSpeedState()
        return true
      end
      return false
    end, false, -130, true)
    self.ui_layer:addChild(node, 100)
    self.speedNode = node
    if not tolua.isnull(self.speedNode) then
      self.speedNode:setVisible(false)
    end
    self.speedNode:setVisible(not battle_tick.getMpTimePvp())
  end
end

function BattleSceneUI:updateSpeedButtonImg()
  local speedImgBg = {
    "UI/alpha/1080P/battle/battle_auto_bg_1.png",
    "UI/alpha/1080P/battle/battle_fastforward_2_bg.png",
    "UI/alpha/1080P/battle/battle_fastforward_3_bg.png"
  }
  local idx = ed.getBattleSpeedIdx()
  for i, speed in ipairs(self.speedButton) do
    speed:setVisible(i == idx)
  end
  ed.setTexture(self.ui.speedButtonBg, speedImgBg[ed.getBattleSpeedIdx()])
end

function BattleSceneUI:refreshAddSpeedState()
  local nextSpeedIdx = math.max(1, (ed.getBattleSpeedIdx() + 1) % 4)
  nextSpeedIdx = not ed.playerlimit:moduleIsOpened("ThreeSpeed") and 2 < nextSpeedIdx and 1 or nextSpeedIdx
  ed.setBattleSpeedIdx(nextSpeedIdx)
  self:updateSpeedButtonImg()
end

function BattleSceneUI:updateAddSpeedBtnState()
  if not tolua.isnull(self.speedNode) and ed.engine:checkDefaultBattleResult() then
    self.speedNode:setVisible(false)
  end
end

function BattleSceneUI:updateBigHpBarPos()
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local height
  if self.bigHpBarList and #self.bigHpBarList == 1 then
    height = 55
  else
    height = 40
  end
  local bigHpBarList = {}
  for index, bigHpBar in ipairs(self.bigHpBarList or {}) do
    if not bigHpBar.terminated then
      table.insert(bigHpBarList, bigHpBar)
    end
  end
  for index, bigHpBar in ipairs(bigHpBarList) do
    bigHpBar.node:setPosition(widhtWin / 2, heightWin - height * index)
  end
  if self.heatBuffPanel and not tolua.isnull(self.heatBuffPanel.node) then
    if #bigHpBarList == 0 then
      self.heatBuffPanel.node:removeFromParentAndCleanup(true)
      self.heatBuffPanel = nil
    else
      self.heatBuffPanel.node:setPosition(widhtWin / 2, heightWin - height * #bigHpBarList - 15)
    end
  end
end

function BattleSceneUI:IsLockAutoBtn(currentMode)
  if currentMode == "attack" then
    return true
  elseif currentMode == "toppvp" then
    return true
  elseif currentMode == "share_fight" then
    return true
  elseif currentMode == "peakArena" then
    return true
  elseif currentMode == "cupArena" then
    return true
  elseif currentMode == "guildClash" then
    return true
  elseif currentMode == "crevicedefend" then
    return true
  elseif currentMode == "awakeStage" then
    return ed.engine.stage_info["Ally Num"] > 5
  end
  return false
end

function BattleSceneUI:createAutoButton(currentMode)
  print("auto_combat", ed.scene.auto_combat)
  local auto_btn
  local battleModeInfo = ed.scene.battleModeInfo
  if battleModeInfo and (battleModeInfo.pvpInfo or battleModeInfo.peakArenaInfo or battleModeInfo.cupArenaInfo or battleModeInfo.guildClashInfo or battleModeInfo.creviceDefendInfo or battleModeInfo.awakeStageInfo and ed.engine.stage_info["Ally Num"] > 5) and currentMode ~= "realarena" then
    auto_btn = CCMenuItemImage:create("UI/alpha/1080P/battle/battle_auto_bg_2.png", "UI/alpha/1080P/battle/battle_auto_bg_2.png")
    if self:IsLockAutoBtn(currentMode) then
      local lock = ed.createSprite("UI/alpha/1080P/common/pvp_battle_lock.png")
      lock:setAnchorPoint(ccp(0, 0.5))
      local size = auto_btn:getContentSize()
      lock:setPosition(ccp(0, size.height))
      auto_btn:addChild(lock)
    end
  else
    local auto_off = CCMenuItemImage:create("UI/alpha/1080P/battle/battle_auto_bg_2.png", "UI/alpha/1080P/battle/battle_auto_bg_1.png")
    local auto_on = CCMenuItemImage:create("UI/alpha/1080P/battle/battle_auto_bg_1.png", "UI/alpha/1080P/battle/battle_auto_bg_2.png")
    auto_btn = CCMenuItemToggle:create(auto_on)
    auto_btn:addSubItem(auto_off)
    if currentMode == "pve" or currentMode == "awakeStage" or currentMode == "rogueMode" then
      local auto = ed.storage.getBool("BATTLE_" .. currentMode .. "_AUTO_COMBAT")
      ed.scene.auto_combat = auto
      if ed.engine.playerKaelHero then
        ed.engine.playerKaelHero.auto_combat = ed.scene.auto_combat
      end
      auto_btn:setSelectedIndex(auto and 1 or 0)
    end
  end
  if battleModeInfo and battleModeInfo.battleCheckInfo then
    auto_btn = CCMenuItemImage:create("UI/alpha/1080P/battle/battle_auto_bg_2.png", "UI/alpha/1080P/battle/battle_auto_bg_2.png")
    if "battle_check" == currentMode then
      ed.scene.auto_combat = true
      if ed.engine.playerKaelHero then
        ed.engine.playerKaelHero.auto_combat = ed.scene.auto_combat
      end
      local lock = ed.createSprite("UI/alpha/1080P/common/pvp_battle_lock.png")
      lock:setAnchorPoint(ccp(0, 0.5))
      local size = auto_btn:getContentSize()
      lock:setPosition(ccp(0, size.height))
      auto_btn:addChild(lock)
    end
  end
  local size = auto_btn:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("\232\135\170\229\138\168<br/>\230\136\152\230\150\151"),
    color = ccc3(255, 252, 231),
    strokeColor = ccc3(19, 92, 13),
    strokeSize = 2,
    maxWidth = size.width,
    lineSpacing = 0
  })
  autoText:setVerticalCenter()
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp((size.width - width) / 2, size.height / 2))
  auto_btn:addChild(autoText.node, 1)
  auto_btn:setPosition(ccp(self.adaptMaxX - 90 / ed.display.scaleFactor - size.width / 2, self.adaptZeroY + size.height * 1.5 + 30 / ed.display.scaleFactor))
  auto_btn:registerScriptTapHandler(function()
    ed.scene:autoCombatHandler()
  end)
  self.auto_btn = auto_btn
  print("auto_combat", ed.scene.auto_combat)
end

function BattleSceneUI:updateMenuButtonState(currentMode)
  if currentMode == "attack" or currentMode == "guildInstance" or currentMode == "share_fight" or currentMode == "peakArena" or currentMode == "cupArena" or currentMode == "autoChessMode" then
    self.pause_btn:setVisible(false)
  end
  if currentMode == "crevicedefend" and not ed.engine.replayMode then
    self.pause_btn:setVisible(false)
  end
  if currentMode == "guildMountBoss" and not ed.GuildMountManager.isTestBattle and ed.GuildMountManager.leftExitTimes <= 0 and not ed.scene.battleModeInfo.guildMountBossInfo.practice then
    self.pause_btn:setVisible(false)
  end
  if currentMode == "fancyTower" then
    self:showBattleStage(false)
  elseif currentMode == "guildInstance" then
    local battle_stage_line_size = self.battle_stage_line:getContentSize()
    self.battle_stage_node:setPosition(ccp(self.adaptCenterX + 180, self.adaptMaxY - 44 / ed.display.scaleFactor - battle_stage_line_size.height / 2 - 15))
    self.battle_stage_node:setScale(0.65)
    self:showBattleStage(true)
  end
  if currentMode == "replay" then
    self.auto_btn:setVisible(false)
  elseif currentMode == "realarena" then
    ed.scene.auto_combat = false
    if ed.scene.obMode then
      self.auto_btn:setVisible(false)
    end
    self:createRealPvpUI()
    self.pause_btn:setVisible(false)
  end
end

local function resetUI(self, stage_info, battle_info, extraInfo)
  self.identity = "battle"
  self.ui_list = {}
  self.left_list = {}
  self.alreadyAddBuffIcon = false
  self.image_damage = nil
  self.signal_image_host = nil
  self.signal_image_slave = nil
  self.closeHeroPanelClick = false
  self.conditionScorePanel = nil
  self.multiHeroPanel = nil
  self.handlerList = {}
  self.bigHpBarList = {}
  self.ballSlots = {}
  local origin = CCDirector:sharedDirector():getVisibleOrigin()
  local ox, oy = origin.x, -origin.y * 0.25
  local header_y = 440 + oy
  self.heroTaskDamageLabel = nil
  self.heroTaskDamageLabelFront = nil
  self.resultico_fail = nil
  self.resultico_succeed = nil
  self.heroTaskMonsterId = nil
  self.chatSelectionWrap = nil
  self.ui = {}
  local currentMode = self:getCurrentMode()
  self:createPauseButton()
  local wave_id = battle_info["Wave ID"]
  if wave_id and currentMode == "pve" or currentMode == "act" or currentMode == "guildInstance" or currentMode == "activityAdventure" or currentMode == "fancyAbyss" or currentMode == "awakeStage" or currentMode == "rogueMode" then
    self:createBattleStage(wave_id, currentMode)
  end
  if currentMode == "pve" or currentMode == "guildInstance" or currentMode == "act" or currentMode == "arcanaTrial" then
    self:createGoldAndLoot()
  end
  if currentMode == "peakArena" or currentMode == "cupArena" then
    self:createPeakArenaRoundUI(ed.engine.battleIdx)
  end
  self:createSpeedButton()
  self:createAutoButton(currentMode)
  self:updateMenuButtonState(currentMode)
  local next_btn = createButtonWithMask("UI/alpha/1080P/common/nextbtn.png", "UI/alpha/1080P/common/nextbtnmask.png")
  self.next_btn = next_btn
  local nextScale = 1.25
  next_btn:setScale(nextScale)
  local next_btn_size = next_btn:getContentSize()
  next_btn:setPosition(ccp(self.adaptMaxX - 90 / ed.display.scaleFactor - next_btn_size.width / 2, self.adaptZeroY + (self.adaptMaxY - self.adaptZeroY) * 0.55))
  next_btn:setVisible(false)
  next_btn:setEnabled(false)
  next_btn:setTouchingArea(CCRectMake(-30 * nextScale, -30 * nextScale, 120 * nextScale, 120 * nextScale))
  next_btn:registerScriptTapHandler(nextBtnTapHandler)
  local jump_btn = createButtonWithMask("UI/alpha/1080P/common/nextbtn.png", "UI/alpha/1080P/common/nextbtnmask.png")
  self.jump_btn = jump_btn
  jump_btn:setPosition(ed.display.winSize.width - 100, ed.display.winSize.height - 100)
  jump_btn:setVisible(false)
  jump_btn:setEnabled(false)
  jump_btn:setTouchingArea(CCRectMake(-30, -30, 120, 120))
  jump_btn:registerScriptTapHandler(ed.sceneui.jumpBtnTapHandler)
  local menu = CCMenu:createWithArray(ccArrayMake(next_btn, jump_btn, self.auto_btn))
  menu:setPosition(ed.ccpZero)
  if ed.scene.obMode then
    self.closeHeroPanelClick = true
    self:createObHeroPanel()
  elseif self:getCurrentMode() == "awakeStage" and ed.engine.stage_info["Ally Num"] > 5 then
    self:createMultiHeroPanel()
  else
    self:createHeroPanel()
  end
  if ed.scene:isReplayMode() then
    self.closeHeroPanelClick = true
  end
  if currentMode == "crevicedefend" then
    self.closeHeroPanelClick = true
  end
  if ed.scene:isShowCheckid() then
    self:createCheakidUI()
  end
  if "replay" == currentMode then
    self.timer = nil
    createReplayUI(self, extraInfo)
    self:createTimer(currentMode)
  else
    self:createTimer(currentMode)
    self:createBackgroundHomeGround(extraInfo)
  end
  if ed.config.vsmodedebug == 1 then
    ed.vsdebug = {}
    for i = 1, 3 do
      local label = ed.createttf("VSDebugInfo:", 14)
      label:setAnchorPoint(ccp(0, 1))
      label:setPosition(ccp(70, 400 - i * 16))
      label:setHorizontalAlignment(kCCTextAlignmentLeft)
      label:setColor(ccc3(255, 246, 255))
      ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
      ed.vsdebug[i] = label
      self.ui_layer:addChild(label)
    end
  end
  self:showCalculateDamageUI()
  self:showConditionScorePanel()
  self.ui_layer:addChild(menu)
  local stageInfo = ed.engine.stage_info
  local stageId = (stageInfo or {})["Stage ID"]
  self:resetUIExtra()
end

BattleSceneUI.resetUI = resetUI

function BattleSceneUI:createBackgroundHomeGround(extraInfo)
  if extraInfo and extraInfo.homeGround then
    local homeGroundBg = ed.createSpriteTools({
      res = "UI/alpha/1080P/pvp/arena_background_owner.png",
      pos = ccp(ed.display.winSize.width - 185, ed.display.winSize.height - 50),
      parent = self.ui_layer
    })
    ed.createLabelTools({
      txt = T("\230\136\152\230\150\151\228\184\187\229\156\186"),
      size = 12,
      pos = ccp(35, 24),
      color = ccc3(ed.colorToStr("#f4f1dd")),
      parent = homeGroundBg,
      stroke = {
        ccc3(ed.colorToStr("#5a2305")),
        1.3
      }
    })
    local summary = extraInfo.oppoSummary
    if extraInfo.homeGround == 0 then
      summary = ed.player:getUserSummary()
    end
    local head = ed.getTeamHead({
      id = summary._avatar
    })
    head:setScale(0.48)
    head:setPosition(85, 24)
    homeGroundBg:addChild(head)
    local name = ed.getPlayerName(ed.transBotName(summary._name), summary._medal, {
      disableOffset = true,
      anchorPoint = ccp(0.5, 0.5)
    })
    name:setPosition(179, 24)
    name:setScale(0.9)
    homeGroundBg:addChild(name)
  end
end

function BattleSceneUI:isShowHeroPanel()
  if ed.engine.autoChessMode then
    return false
  elseif ed.scene.obMode then
    return false
  elseif self.getCurrentMode() == "awakeStage" and ed.engine.stage_info["Ally Num"] > 5 then
    return false
  end
  return true
end

function BattleSceneUI:initUI()
  local viewCamp = ed.emCampPlayer
  local showHeroPanel = self:isShowHeroPanel()
  if ed.scene.battleModeInfo and ed.scene.battleModeInfo.replayInfo and ed.scene.battleModeInfo.replayInfo.oppoUserid == ed.getUserid() then
    viewCamp = ed.emCampEnemy
  end
  local hpBigList = {}
  for i, unit in ipairs(ed.engine.unit_list) do
    if self:canAddHeroPanel(unit, viewCamp) and showHeroPanel then
      self:addHeroPanel(unit)
    end
    if unit.hpLayer and 0 ~= unit.hpLayer then
      table.insert(hpBigList, unit)
      for _, buff in ipairs(unit.buff_list) do
        if buff.info["Show Icon"] then
          self:addBuffStack(buff)
        end
      end
    end
  end
  if 0 < #hpBigList then
    self:addBigBloodPanelList(hpBigList)
  end
  if ed.engine.energyBean_mode and not ed.engine.replayMode then
    self:addGoldBean()
  end
  if self:getCurrentMode() == "guildInstance" then
    self:addGuildBloodPanel()
  end
  if self:getCurrentMode() == "hadesHeat" then
    self:addHeatBuffPanel()
  end
  if self.getCurrentMode() == "awakeStage" then
    self:addStageWaveProgress()
    if self.multiHeroPanel then
      self.multiHeroPanel:initHeroList()
    end
  end
  if ed.scene.obMode then
    self:addHeroObInfoPanel()
  end
  self:addEchoSkillIcon()
  self:addRogueSkillIcon()
  if (self:getCurrentMode() == "peakArena" or self:getCurrentMode() == "cupArena" or self:getCurrentMode() == "crevicedefend") and not ed.engine.replayMode then
    local function createLabel(btn, context)
      local size = btn:getContentSize()
      
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = context,
        maxWidth = size.width,
        color = ccc3(255, 252, 231),
        strokeColor = ccc3(19, 92, 13),
        strokeSize = 2,
        lineSpacing = 0
      })
      autoText:setVerticalCenter()
      local width, height = autoText:getCurContentSize()
      autoText.node:setPosition(ccp((size.width - width) / 2, size.height / 2))
      btn:addChild(autoText.node, 1)
      if width > size.width - 10 then
        local scale = (size.width - 10) / width
        autoText.node:setScale(scale)
        autoText.node:setPositionX(autoText.node:getPositionX() + width / 2 - (size.width - 10) / 2)
      end
    end
    
    local skipOnce = ed.createSprite("UI/alpha/1080P/battle/battle_auto_bg_2.png")
    createLabel(skipOnce, T("\228\184\139\228\184\128\229\156\186"))
    local skipAll = ed.createSprite("UI/alpha/1080P/battle/battle_auto_bg_2.png")
    createLabel(skipAll, T("\232\183\179\232\191\135<br/>\229\133\168\233\131\168"))
    self.ui_layer:addChild(skipOnce)
    self.ui_layer:addChild(skipAll)
    if self:getCurrentMode() == "crevicedefend" then
      ed.layout.layoutWithMagin(skipOnce, {top = 20, right = 115})
      ed.layout.layoutWithMagin(skipAll, {top = 20, right = 15})
    else
      ed.layout.layoutWithMagin(skipOnce, {top = 20, right = 150})
      ed.layout.layoutWithMagin(skipAll, {top = 20, right = 50})
    end
    self.menu_touch_node:btRegisterButtonClick({
      button = skipOnce,
      key = "skipOnce",
      clickHandler = function()
        ed.engine.enabled = false
        ed.engine.running = false
        ed.popScene()
        if self:getCurrentMode() == "peakArena" then
          FireEvent("PeakArenaPlayNextBattle")
        elseif self:getCurrentMode() == "cupArena" then
          FireEvent("CupArenaPlayNextBattle")
        elseif self:getCurrentMode() == "crevicedefend" then
          FireEvent("EventCreviceDefendPlayNextBattle")
        end
      end
    })
    self.menu_touch_node:btRegisterButtonClick({
      button = skipAll,
      key = "skipAll",
      clickHandler = function()
        ed.engine.enabled = false
        ed.engine.running = false
        ed.popScene()
        if self:getCurrentMode() == "peakArena" then
          FireEvent("PeakArenaPlayNextBattle", 999)
        elseif self:getCurrentMode() == "cupArena" then
          FireEvent("CupArenaPlayNextBattle", nil, 999)
        elseif self:getCurrentMode() == "crevicedefend" then
          FireEvent("EventCreviceDefendPlayNextBattle", nil, 999)
        end
      end
    })
  end
end
