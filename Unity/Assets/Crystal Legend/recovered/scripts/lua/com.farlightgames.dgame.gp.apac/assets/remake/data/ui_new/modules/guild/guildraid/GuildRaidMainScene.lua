local base = ed.ui.commonscene
local GuildRaidMainScene = newclass(base.mt)
ed.ui.GuildRaidMainScene = GuildRaidMainScene
local raidConfig = ed.GuildRaidConfig.RaidConfig

function GuildRaidMainScene:setOpenRaids(params)
  self.canEnterRaids = {}
  for k, v in ipairs(ed.GuildRaidManager.raidInfo) do
    if v.isOpen then
      table.insert(self.canEnterRaids, v.raidId)
    end
  end
  for k, v in ipairs(self.canEnterRaids) do
    if self.raidId == v then
      self.raidIndex = k
      break
    end
  end
end

function GuildRaidMainScene:initData(params)
  self.raidId = params.raidId
  self.raidData = ed.GuildRaidManager.raidInfo[self.raidId]
  self.progressBar = {}
  self.allFca = {}
  self.curChallengeUI = {}
  self:setOpenRaids()
end

function GuildRaidMainScene:createProcessBar(res, parentUI, ccRect)
  local size = parentUI:getContentSize()
  local clippingNode = ed.createClippingNodeOnly(res, 0.5)
  clippingNode:setPosition(ccp(0.5, size.height / 2))
  local stencil = clippingNode:getStencil()
  stencil:setAnchorPoint(ccp(0, 0.5))
  local barScale = size.width / stencil:getContentSize().width
  stencil:setScaleX(barScale)
  local bar = ed.createScale9Sprite(res, CCRectMake(18, 5.5, 150, 6))
  bar:setContentSize(CCSizeMake(112, 15))
  bar:setAnchorPoint(ccp(0, 0.5))
  clippingNode:addChild(bar)
  parentUI:addChild(clippingNode)
  return stencil, barScale
end

function GuildRaidMainScene:refreshBar(index)
  local stageData = self.raidData.stages[index]
  local ui = self.progressBar[index]
  ui.bar:setScaleX(stageData.stageProgress / ed.GuildRaidConfig.MaxStageProgress * ui.barScale)
  if stageData.stageProgress < ed.GuildRaidConfig.MaxStageProgress then
    ui.text:setString(string.format("%.2f%%", stageData.stageProgress / 100))
  else
    ui.bar:setScaleX(ui.barScale)
    ui.text:setString(T("\229\183\178\229\174\140\230\136\144"))
    ui.text:setColor(ed.toccc3(7405396))
  end
end

function GuildRaidMainScene:createBar(node, stageIndex)
  local barBg = ed.createScale9Sprite("UI/alpha/1080P/raid/progressbar_bg_1.png", CCRectMake(18, 5.5, 150, 6))
  barBg:setContentSize(CCSizeMake(112, 17))
  barBg:setPosition(ccp(102, 60))
  barBg:setCascadeOpacityEnabled(true)
  local label = ed.createLabelTTF("0%", 16)
  ed.setLabelColor(label, ed.toccc3(16776423))
  ed.setLabelStroke(label, ed.toccc3(2103574), 1)
  label:setPosition(ccp(56, 8.5))
  barBg:addChild(label, 2)
  node:addChild(barBg)
  local bar, barScale = self:createProcessBar("UI/alpha/1080P/raid/progressbar_1.png", barBg, CCRectMake(45, 8, 45, 2))
  self.progressBar[stageIndex] = {
    bar = bar,
    text = label,
    barScale = barScale
  }
end

function GuildRaidMainScene:playStageFca(info, stageIndex)
  if stageIndex ~= #self.raidData.stages and info.stageProgress == ed.GuildRaidConfig.MaxStageProgress then
    local fcaPos = raidConfig[self.raidId].fcaPos
    if fcaPos and fcaPos[stageIndex] then
      local fcaName = string.format("eff_UI_Raid_%d_line%d", raidConfig[self.raidId].fcaIndex, stageIndex)
      local fca = ed.createFcaNode(fcaName)
      fca:setPosition(fcaPos[stageIndex])
      self:addFca(fca)
      self.currentLayer.bg:addChild(fca)
      if info.fcaPlayed == true then
        fca:setAction("Loop")
        fca:setStartAction("Loop")
      else
        info.fcaPlayed = true
        fca:setStartAction("Loop")
      end
      table.insert(self.allFca, fca)
    end
  end
end

function GuildRaidMainScene:createStageBar(info, stageIndex)
  local isBossStage = stageIndex == #self.raidData.stages
  local ui = self.currentLayer
  local stageIcon = isBossStage and ui.boss or ui["stage" .. stageIndex]
  stageIcon:setCascadeOpacityEnabled(true)
  self:createBar(stageIcon, stageIndex)
  self:refreshBar(stageIndex)
end

function GuildRaidMainScene:adaptUI()
end

function GuildRaidMainScene:initLabels()
  ed.setLabelShadow(self.ui.label_rank, ed.toccc3(2565412), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_shop, ed.toccc3(2565412), ccp(1, 0))
  self.ui.label_rank:limitWidthByScale(75)
  self.ui.label_shop:limitWidthByScale(75)
end

function GuildRaidMainScene:refreshCurChallenge(info, stageIndex)
  if self.curChallengeUI[stageIndex] then
    self.curChallengeUI[stageIndex]:removeFromParentAndCleanup(true)
    self.curChallengeUI[stageIndex] = nil
  end
  local isBossStage = stageIndex == #self.raidData.stages
  local ui = self.currentLayer
  local stageIcon = isBossStage and ui.boss or ui["stage" .. stageIndex]
  if info.curChallenge and info.curChallenge._user_summary then
    local summary = info.curChallenge._user_summary
    local otherChallenge = ed.createSprite("UI/alpha/1080P/raid/tips.png")
    local param = {
      id = summary._avatar,
      scale = 0.4
    }
    local chanllenger = ed.getWholeHeadIcon(param)
    otherChallenge:setPosition(ccp(100, 130))
    chanllenger:setPosition(ccp(30, 45))
    otherChallenge:addChild(chanllenger)
    local name = ed.createLabelTTF(summary._name, 12)
    ed.setLabelColor(name, ed.toccc3(16776423))
    ed.setLabelStroke(name, ed.toccc3(2565412), 1)
    name:setAnchorPoint(ccp(0, 0.5))
    name:setPosition(ccp(10, 23))
    otherChallenge:addChild(name)
    local battleIcon = ed.createSprite("UI/alpha/1080P/raid/challenging_icon.png")
    battleIcon:setPosition(ccp(70, 45))
    battleIcon:setScale(0.6)
    otherChallenge:addChild(battleIcon)
    stageIcon:addChild(otherChallenge, 3)
    self.curChallengeUI[stageIndex] = otherChallenge
    local endTime = info.curChallenge._end_time - ed.getServerTime()
    self.listenTimer(Timer:Once(endTime), function()
      ed.GuildRaidNetwork:sendQueryInstance(info.raidId)
    end)
  else
  end
end

function GuildRaidMainScene:isUnLockBossStage()
  for i = 1, #self.raidData.stages - 1 do
    if self.raidData.stages[i].stageProgress < ed.GuildRaidConfig.MaxStageProgress then
      return false
    end
  end
  return true
end

function GuildRaidMainScene:addClickEvents(info, stageIndex)
  local isBossStage = stageIndex == #self.raidData.stages
  local ui = self.currentLayer
  local stageIcon = isBossStage and ui.boss or ui["stage" .. stageIndex]
  local posX, posY = stageIcon:getPosition()
  self:btRemoveMainTouchHandler({
    key = "stage" .. stageIndex
  })
  self:btRegisterCircleClick({
    center = ccp(posX, posY),
    radius = isBossStage and 55 or 40,
    parent = ui.bg,
    pressHandler = function()
      if isBossStage then
        stageIcon:setScale(1.18)
      else
        stageIcon:setScale(0.98)
      end
    end,
    key = "stage" .. stageIndex,
    cancelPressHandler = function()
      if isBossStage then
        stageIcon:setScale(1.2)
      else
        stageIcon:setScale(1)
      end
    end,
    clickHandler = function()
      if isBossStage then
        if self:isUnLockBossStage() then
          self.preStageProgress = info.stageProgress
          self:onClickStageIcon(info, stageIndex)
        else
          ed.showToast(T("\233\156\128\232\166\129\233\128\154\229\133\179\230\137\128\230\156\137\229\133\182\228\187\150\229\133\179\229\141\161\230\137\141\232\131\189\232\167\163\233\148\129Boss\229\133\179\230\140\145\230\136\152"))
        end
      else
        self:onClickStageIcon(info, stageIndex)
      end
    end
  })
end

function GuildRaidMainScene:onClickStageIcon(stageInfo, stageIndex)
  self.curStageInfo = stageInfo
  self.curStageIndex = stageIndex
  ed.GuildRaidNetwork:sendQueryStage(stageInfo.stageId)
end

function GuildRaidMainScene:addStageAction(info, stageIndex)
  local isBossStage = stageIndex == #self.raidData.stages
  if isBossStage then
    return
  end
  local ui = self.currentLayer
  local mask = ui["stage" .. stageIndex .. "_light"]
  if not mask then
    return
  end
  mask:setZOrder(111)
  local action = CCFadeTo:create(1, 0)
  local reverse = CCFadeTo:create(1, 255)
  local sequence = CCSequence:createWithTwoActions(action, reverse)
  mask:runAction(CCRepeatForever:create(sequence))
end

function GuildRaidMainScene:refreshBoss()
  if self:isUnLockBossStage() then
    ed.setTexture(self.currentLayer.boss, string.format("UI/alpha/1080P/stages/stage-%d.png", raidConfig[self.raidId].bossResId))
    self.currentLayer.boss_light:setVisible(true)
    local sequence = CCSequence:createWithTwoActions(CCFadeTo:create(1, 0), CCFadeTo:create(1, 255))
    self.currentLayer.boss_light:runAction(CCRepeatForever:create(sequence))
  end
end

function GuildRaidMainScene:refreshEnterProgress(v)
  if v.joinProcess and v.joinProcess > 0 then
    self.ui.enter_progress:setVisible(true)
    self.ui.enter_progress:removeAllChildrenWithCleanup(true)
    local autoText = ed.ui.autoText.new()
    local str = T("\232\191\155\229\133\172\228\188\154\230\151\182\232\191\155\229\186\166\228\184\186%s,\231\187\147\231\174\151\229\165\150\229\138\177\229\176\134\232\191\155\232\161\140\230\138\152\231\174\151", string.format("<lable color=ccc3(225,143,108) strokeColor=strokeColor1 strokeSize=1>%.2f%%</lable>", v.joinProcess / 100))
    autoText:initParam({
      context = str,
      fontSize = 14,
      color = ccc3(255, 252, 231),
      strokeColor = ccc3(32, 31, 28),
      strokeSize = 1,
      maxWidth = 800
    })
    local width, height = autoText:getCurContentSize()
    autoText.node:setPosition(ccp(209.5 - width / 2, 10))
    self.ui.enter_progress:addChild(autoText.node, 1)
  else
    self.ui.enter_progress:setVisible(false)
  end
end

function GuildRaidMainScene:refreshStages()
  for k, v in ipairs(self.raidData.stages) do
    self:createStageBar(v, k)
    self:playStageFca(v, k)
    self:refreshCurChallenge(v, k)
    self:addClickEvents(v, k)
    self:addStageAction(v, k)
    self:refreshBoss()
  end
end

function GuildRaidMainScene:refreshStageLayer()
  local container, ui = ed.editorui(ed.uieditor["RaidLayer" .. self.raidId])
  ui.bg:setCascadeOpacityEnabled(true)
  container:setPosition(ed.getCenterPos(self.ui.bg))
  self.ui.bg:addChild(container, 1)
  self.currentLayer = ui
  ui.container = container
  self:refreshStages()
  if self.needAction then
    ui.bg:setOpacity(0)
    for k, v in ipairs(self.allFca or {}) do
      v:setVisible(false)
    end
    self.currentLayer.bg:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.6), CCCallFunc:create(function()
      self.mainLayer:setTouchEnabled(true)
      for k, v in ipairs(self.allFca or {}) do
        v:setVisible(true)
      end
    end)))
    self.needAction = false
  end
  self.mainLayer:setTouchEnabled(true)
end

function GuildRaidMainScene:initUI()
  self.container = self.mainLayer
  self.ui = {}
  local readnode = ed.readnode.create(self.container, self.ui)
  readnode:addNode(ed.uieditor.RaidScene)
  self:setBackButton()
  self:adaptUI()
  self:initLabels()
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(1, ccp(-30, 0)), CCMoveBy:create(1, ccp(30, 0)))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(1, ccp(30, 0)), CCMoveBy:create(1, ccp(-30, 0)))))
end

function GuildRaidMainScene:registerEvents()
  self:listenEvent("GuildRaidQueryInstance", function()
    self:refreshStageLayer()
    self:refreshUI()
  end)
  self:listenEvent("GuildRaidMemberRank", function(data)
    if data and data._damages then
      ed.ui.GuildRaidDamageRanklistWin.create(data)
    else
      ed.showToast(T("\230\154\130\230\151\160\230\142\146\232\161\140\230\166\156\230\149\176\230\141\174"))
    end
  end)
  self:listenEvent("GuildRaidQueryStage", function()
    self:refreshCurChallenge(self.curStageInfo, self.curStageIndex)
    ed.ui.GuildRaidStageDetailWin.create({
      stageInfo = self.curStageInfo,
      raidId = self.raidId
    })
  end)
end

function GuildRaidMainScene:clearCurRaidUI()
  self.mainLayer:setTouchEnabled(false)
  for k, v in ipairs(self.allFca or {}) do
    self:removeFca(v)
  end
  for k, v in ipairs(self.raidData.stages) do
    self:btRemoveMainTouchHandler({
      key = "stage" .. k
    })
  end
  local curLayer = self.currentLayer.bg
  curLayer:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.6), CCCallFunc:create(function()
    curLayer:removeFromParentAndCleanup(true)
  end)))
  self.progressBar = {}
  self.allFca = {}
  self.curChallengeUI = {}
end

function GuildRaidMainScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_rank", function()
    ed.GuildRaidNetwork:sendMemberRank(self.raidId)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_shop", function()
    ed.UITool.openView("shopMain", {page = 5})
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "arrow_left", function()
    self.raidIndex = self.raidIndex - 1
    self:clearCurRaidUI()
    self.raidId = self.canEnterRaids[self.raidIndex]
    self.raidData = ed.GuildRaidManager.raidInfo[self.raidId]
    self.needAction = true
    ed.GuildRaidNetwork:sendQueryInstance(self.canEnterRaids[self.raidIndex])
  end)
  ed.UITool.registerBtn(self, "arrow_right", function()
    self.raidIndex = self.raidIndex + 1
    self:clearCurRaidUI()
    self.raidId = self.canEnterRaids[self.raidIndex]
    self.raidData = ed.GuildRaidManager.raidInfo[self.raidId]
    self.needAction = true
    ed.GuildRaidNetwork:sendQueryInstance(self.canEnterRaids[self.raidIndex])
  end)
end

function GuildRaidMainScene:refreshTimeAutoStr()
  if self.info1AutoText then
    self.info1AutoText:removeFromParentAndCleanup(true)
  end
  local str1 = "<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>" .. T("\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154") .. string.format("</lable><lable color=ccc3(255,173,76) strokeColor=strokeColor1 strokeSize=1>%d/%d</lable>", self.raidData.maxBattleTimes - self.raidData.curBattleTimes, self.raidData.maxBattleTimes)
  local info1 = ed.ui.autoText.new()
  info1:initParam({context = str1, fontSize = 16})
  info1.node:setPosition(self.ui.info1:getPosition())
  self.ui.bg_info:addChild(info1.node)
  self.info1AutoText = info1.node
end

function GuildRaidMainScene:refreshPreRewardAutoStr()
  if self.info2AutoText then
    self.info2AutoText:removeFromParentAndCleanup(true)
  end
  local color = "ccc3(112,255,84)"
  local text = string.format(T("(+%d%%\231\173\137\231\186\167\229\138\160\230\136\144)"), self.raidData.gsLevelBonus - 100)
  if self.raidData.gsLevelBonus < 100 then
    color = "ccc3(255,108,108)"
    text = string.format(T("(%d%%\231\173\137\231\186\167\229\138\160\230\136\144)"), self.raidData.gsLevelBonus - 100)
  end
  local str2 = "<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>" .. T("\233\162\132\232\174\161\233\128\154\229\133\179\229\165\150\229\138\177\239\188\154") .. string.format("</lable><sprite src=UI/alpha/1080P/icon/money_guildtoken_new.png scale=0.8><lable color=ccc3(255,173,76) strokeColor=strokeColor1 strokeSize=1>%d</lable><lable color=%s strokeColor=strokeColor1 strokeSize=1>%s</lable>", self.raidData.raidPoint, color, text)
  local info2 = ed.ui.autoText.new()
  info2:initParam({context = str2, fontSize = 16})
  info2.node:setPosition(self.ui.info2:getPosition())
  info2:limitWidthByScale(270)
  self.ui.bg_info:addChild(info2.node)
  self.info2AutoText = info2.node
end

function GuildRaidMainScene:refreshTimeRewardAutoStr()
  local timeLimit = T("\229\189\147\229\137\141\229\183\178\232\182\133\230\151\182")
  local color = "ccc3(255,108,108)"
  if self.raidData.fastDeadline > ed.getServerTime() then
    timeLimit = T("\229\137\169\228\189\153") .. ed.time2dhms(self.raidData.fastDeadline - ed.getServerTime())
    color = "ccc3(112,255,84)"
  end
  if self.info3AutoText then
    self.info3AutoText:removeFromParentAndCleanup(true)
  end
  local str3 = "<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>" .. T("\233\162\157\229\164\150\233\153\144\230\151\182\229\165\150\229\138\177\239\188\154") .. string.format("</lable><sprite src=UI/alpha/1080P/icon/money_guildtoken_new.png scale=0.8><lable color=ccc3(255,173,76) strokeColor=strokeColor1 strokeSize=1>%d</lable> <lable color=%s strokeColor=strokeColor1 strokeSize=1>%s</lable>", self.raidData.fastRaidPoint, color, timeLimit)
  local info3 = ed.ui.autoText.new()
  info3:initParam({context = str3, fontSize = 16})
  info3.node:setPosition(self.ui.info3:getPosition())
  self.ui.bg_info:addChild(info3.node)
  self.info3AutoText = info3.node
end

function GuildRaidMainScene:refreshUI()
  ed.setString(self.ui.title, self.raidData.name)
  self:refreshTimeAutoStr()
  self:refreshPreRewardAutoStr()
  self:refreshTimeRewardAutoStr()
  self:updateAutoTextSize()
  self:refreshEnterProgress(self.raidData)
  self.ui.arrow_left:setVisible(self.raidIndex ~= 1)
  self.ui.arrow_right:setVisible(self.raidIndex ~= #self.canEnterRaids)
end

function GuildRaidMainScene:updateAutoTextSize()
  local scale = self.info2AutoText:getScale()
  self.info1AutoText:setScale(scale)
  self.info3AutoText:setScale(scale)
end

function GuildRaidMainScene:endBattleRefresh()
  self:refreshTimeAutoStr()
  self:refreshPreRewardAutoStr()
  self:updateAutoTextSize()
  for k, v in ipairs(self.raidData.stages) do
    self:refreshCurChallenge(v, k)
  end
  local shouldPlayUnlockBossFca = true
  for i = 1, #self.raidData.stages do
    local stageData = self.raidData.stages[i]
    local ui = self.progressBar[i]
    ui.bar:setScaleX(stageData.stageProgress / ed.GuildRaidConfig.MaxStageProgress * ui.barScale)
    ui.text:setString(string.format("%.2f%%", stageData.stageProgress / 100))
    if stageData.stageProgress == ed.GuildRaidConfig.MaxStageProgress then
      ui.text:setString(T("\229\183\178\229\174\140\230\136\144"))
      ui.text:setColor(ed.toccc3(7405396))
      if i == #self.raidData.stages then
        self.raidData.isPassed = true
        self:listenTimer(Timer:Once(1.5), function()
          local fca = ed.createFcaNode("eff_UI_SeasonTower_congraduation")
          local cong_label = ed.createSprite("UI/alpha/1080P/common/seasontower_congraduation.png")
          local cong_node = CCSprite:create()
          cong_node:addChild(cong_label)
          fca:addNodeToComponent(cong_node, "Node", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
          self:addFca(fca, 2)
          fca:setPosition(ccp(425, 400))
          self.currentLayer.bg:addChild(fca, 100)
          self:listenTimer(Timer:Once(2.5), function()
            if fca and not tolua.isnull(fca) then
              fca:removeFromParentAndCleanup(true)
            end
          end)
        end)
      elseif stageData.fcaPlayed ~= true then
        self:listenTimer(Timer:Once(1), function()
          local fcaPos = raidConfig[self.raidId].fcaPos
          if fcaPos and fcaPos[i] then
            local fcaName = string.format("eff_UI_Raid_%d_line%d", raidConfig[self.raidId].fcaIndex, i)
            local fca = ed.createFcaNode(fcaName)
            self:addFca(fca)
            fca:setPosition(fcaPos[i])
            self.currentLayer.bg:addChild(fca)
            stageData.fcaPlayed = true
            fca:setStartAction("Loop")
            table.insert(self.allFca, fca)
          end
        end)
      end
    end
  end
  for i = 1, #self.raidData.stages - 1 do
    local stageData = self.raidData.stages[i]
    if stageData.stageProgress < ed.GuildRaidConfig.MaxStageProgress then
      shouldPlayUnlockBossFca = false
    end
  end
  local bossStage = self.raidData.stages[#self.raidData.stages]
  if ed.GuildRaidManager.curChallengeStageId == bossStage.stageId then
    shouldPlayUnlockBossFca = false
  end
  if shouldPlayUnlockBossFca then
    local fcaPos = raidConfig[self.raidId].fcaPos
    if fcaPos and fcaPos[#self.raidData.stages] then
      self:listenTimer(Timer:Once(2.5), function()
        local fcaBoss1 = ed.createFcaNode("eff_UI_Raid_Boss_unlock_1")
        self:addFcaOnce(fcaBoss1)
        fcaBoss1:setPosition(fcaPos[#self.raidData.stages])
        self.currentLayer.bg:addChild(fcaBoss1, 1)
        fcaBoss1:update(0.2)
        local fcaBoss2 = ed.createFcaNode("eff_UI_Raid_Boss_unlock_2")
        self:addFcaOnce(fcaBoss2)
        fcaBoss2:setPosition(fcaPos[#self.raidData.stages])
        self.currentLayer.bg:addChild(fcaBoss2, 3)
        fcaBoss2:update(0.2)
        table.insert(self.allFca, fcaBoss1)
        table.insert(self.allFca, fcaBoss2)
        self:listenTimer(Timer:Once(2.7), function()
          if raidConfig[self.raidId].bossResId then
            ed.setTexture(self.currentLayer.boss, string.format("UI/alpha/1080P/stages/stage-%d.png", raidConfig[self.raidId].bossResId))
            local sequence = CCSequence:createWithTwoActions(CCFadeTo:create(1, 0), CCFadeTo:create(1, 255))
            self.currentLayer.boss_light:setVisible(true)
            self.currentLayer.boss_light:runAction(CCRepeatForever:create(sequence))
          end
        end)
      end)
    end
  end
  ed.GuildRaidManager.curChallengeStageId = nil
end

function GuildRaidMainScene.create(params)
  local self = base.create("GuildRaidMainScene")
  setmetatable(self, GuildRaidMainScene.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnEnterHandler("onEnter", function()
    if ed.GuildRaidManager.curChallengeStageId then
      self:endBattleRefresh()
    end
  end)
  ed.GuildRaidManager.win = self
  return self
end
