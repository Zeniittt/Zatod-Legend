local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.dragonBoatRewardScene = class
ed.UITool.registViewOpenFunc("dragonBoatRewardScene", function()
  local scene = ed.ui.dragonBoatRewardScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("dragonBoatRewardScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initData()
  self:initUI()
  self:registerTouchHandler()
  self:registerEvents()
end

function class:initData()
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.endTime = self.mgr.endTime
  self.boatCurSpeed = self.mgr.start and self.mgr.getBoatSpeed(self.mgr.raceInfo._skin) or 0
  self.boatRank = self.mgr.raceInfo._skin
  self.nextStageProgress = self.mgr.nextStageProgress
  self.nextStageTotal = self.mgr.nextStageTotal
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.DragonBoatRewardScene)
  self.container = container
  self.mainLayer:addChild(self.container)
  self.ui = ui
  self:initBG()
  self:initLabel()
  self:adaptUI()
  self:initRewards()
  self:talkLayerTouchShow()
  self:setBackButton(function()
    if ed.dragonBoatMgr:getInstance():isInRace() then
      FireEvent("DragonBoatSetRegisterTime", ed.getServerTime() - 6)
    end
  end)
end

function class:initBG()
  self.ui.bg_sky:setZOrder(-1)
  ed.layout.lazyAdaptBG(self.ui.bg_sky)
  self:doMoveAction(self.ui.bg_sun, ccp(0, 200), 0.3, 0.3)
  self:doMoveAction(self.ui.bg_far_mountain, ccp(0, 80), 0.5)
  self:doMoveAction(self.ui.bg_left_mountain, ccp(40, 0))
  self:doMoveAction(self.ui.bg_right_mountain2, ccp(-40, 0))
  self:doMoveAction(self.ui.bg_right_mountain1, ccp(-80, 0))
  self:doMoveAction(self.ui.bg_right_rock2, ccp(-200, 0))
  self:doMoveAction(self.ui.bg_right_rock1, ccp(-300, 0))
  self:doMoveAction(self.ui.bg_left_rock2, ccp(200, 0))
  self:doMoveAction(self.ui.bg_left_rock1, ccp(300, 0))
  local spine = ed.createSpine("effect/eff_UI_DragonBoat_drum/eff_UI_DragonBoat_drum", 0.5)
  self.spine = spine
  spine:setAnimation(0, "Idle" .. (self.boatRank == 1 and "" or self.boatRank), true)
  self.ui.panel_boat:addChild(spine)
end

function class:initLabel()
  local name = ed.dragonBoatMgr.getInstance():getActivityCfg()["Activity Name"]
  local title = ed.ui.gradientLabel.create({
    text = name,
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(14677158),
    endColor = ed.toccc3(16383983),
    shadowColor = ccc3(39, 100, 105),
    shadowOffset = ccp(0, -2)
  })
  title.node:setAnchorPoint(ccp(0, 0.5))
  self.ui.label_title:addChild(title.node)
  title.node:setScale(math.min(1, 225 / title.node:getContentSize().width))
  self:updateLeftTime()
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(1655099), 1.5)
  local cur_speed_txt = T("\232\136\170\233\128\159%s\229\176\186/\230\151\182", string.format("<lable color=ccc3(149,255,55)  fontSize=f18 strokeColor=ccc3(21,62,35), strokeSize=1 >%s</lable>", self.boatCurSpeed))
  local curSpeed = ed.ui.autoText.new()
  curSpeed:initParam({
    context = cur_speed_txt,
    fontSize = 15,
    color = ccc3(159, 70, 7)
  })
  local wid, _ = curSpeed:getCurContentSize()
  curSpeed.node:setPositionX(-wid * 0.5)
  self.ui.label_current_speed:addChild(curSpeed.node)
  local next_stage_txt = self.nextStageProgress < self.nextStageTotal and T("\228\184\139\233\152\182\230\174\181\229\165\150\229\138\177<lable color=ccc3(255,235,126)>%s</lable>/%s\229\176\186", self.nextStageProgress, self.nextStageTotal) or T("\229\183\178\232\190\190\230\136\144\230\137\128\230\156\137\233\152\182\230\174\181\229\165\150\229\138\177\231\155\174\230\160\135")
  local nextStage = ed.ui.autoText.new()
  nextStage:initParam({
    context = next_stage_txt,
    fontSize = 18,
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(804921),
    stroeSize = 1
  })
  wid, _ = nextStage:getCurContentSize()
  nextStage.node:setPositionX(-wid * 0.5)
  self.ui.label_next_stage:addChild(nextStage.node)
  if self.nextStageProgress < self.nextStageTotal then
    local left_distance_txt = T("\232\183\157\231\166\187\228\184\139\228\184\128\230\161\163\232\191\152\229\137\169%s\229\176\186", "<lable color=ccc3(255,233,39) fontSize=f24  strokeColor=ccc3(118,97,0) strokeSize=1>" .. self.nextStageTotal - self.nextStageProgress .. "</lable>")
    local leftDistance = ed.ui.autoText.new()
    leftDistance:initParam({
      context = left_distance_txt,
      fontSize = 21,
      color = ccc3(250, 249, 247),
      strokeColor = ed.toccc3(2188557),
      stroeSize = 1
    })
    wid, _ = leftDistance:getCurContentSize()
    leftDistance.node:setPositionX(-wid * 0.5)
    self.ui.label_left_distance:addChild(leftDistance.node)
  else
    self.ui.left_distance_bg:setVisible(false)
  end
end

function class:initRewards()
  local draglist = ed.UITool.createDraglist(self.ui.layer_reward, {priority = -300})
  self.draglist = draglist
  self:refreshRewards()
end

function class:refreshRewards()
  self.draglist:clearList()
  local progress_bg = ed.createScale9Sprite("UI/alpha/1080P/dragonboat/stage_reward/bg_db_loading.png", CCRectMake(20, 21, 50, 1))
  local length = 40 + 110 * self.mgr.rewardsCnt
  local bgSize = progress_bg:getContentSize()
  progress_bg:setContentSize(CCSizeMake(length, bgSize.height))
  progress_bg:setAnchorPoint(ccp(0, 0.5))
  progress_bg:setPosition(ccp(6, 14))
  self.draglist:addItem(progress_bg)
  self.draglist:initListWidth(length + 30)
  local progress_bar = ed.createScale9Sprite("UI/alpha/1080P/dragonboat/stage_reward/db_loading.png", CCRectMake(5, 3, 30, 1))
  local barSize = progress_bar:getContentSize()
  progress_bar:setContentSize(CCSizeMake(220, barSize.height))
  progress_bar:setAnchorPoint(ccp(0, 0.5))
  progress_bar:setPosition(ccp(15, bgSize.height * 0.5))
  progress_bg:addChild(progress_bar)
  local progress_flag = true
  local reward_flag = true
  local reward_ind = 1
  for ind, reward in ipairs(self.mgr.rewardTbl) do
    local posX = 20 + 110 * ind
    local container, ui = ed.editorui(ed.uieditor.DragonBoatRewardItem)
    container:setPosition(ccp(posX, bgSize.height * 0.5))
    progress_bg:addChild(container)
    local feet = reward["Require Feet"]
    local feetLabel = ed.createLabelTTF(T("%s\229\176\186", feet), 17)
    ed.setLabelColor(feetLabel, ccc3(255, 247, 174))
    ed.setLabelStroke(feetLabel, ed.toccc3(7758080), 1.5)
    ui.bg_progress:addChild(feetLabel)
    ed.layout.centerInParent(feetLabel)
    local icon = ed.createItemIcon({
      type = reward["Reward Type 1"],
      id = reward["Reward ID 1"],
      amount = reward["Reward Amount 1"]
    })
    icon:setScale(80 / icon:getContentSize().width)
    ui.icon = icon
    ui.img_icon:addChild(icon)
    local reach = feet <= self.nextStageProgress
    local canGet = false
    if reach then
      ed.setTexture(ui.img_zongzi, "UI/alpha/1080P/dragonboat/stage_reward/zongzi_bright.png")
      if ed.isElementInTable(ind, self.mgr.receivedRewards) then
        local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
        mask:setPosition(ccp(45, 45))
        local tick = ed.createSprite("UI/alpha/1080P/rogue/collect/collect_event_done.png")
        mask:addChild(tick)
        tick:setPosition(ccp(50, 40))
        mask:setZOrder(1)
        icon:addChild(mask)
      else
        canGet = true
        local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
        icon:addChild(light)
        light:setPosition(ccp(45, 45))
        light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
        ui.light = light
        local config = {
          button = icon,
          key = "get_reward" .. ind,
          clickHandler = function()
            ed.dragonBoatNet.getInstance():sendGetReward()
          end,
          force = true,
          mcpMode = true,
          mcp_dis = 30,
          clickInterval = 0.3,
          priority = -1,
          extraCheckHandler = function(x, y)
            return ed.containsPoint(self.ui.layer_reward, x, y)
          end
        }
        self:btRegisterButtonClick(config)
      end
    end
    if not canGet then
      local scale = icon:getScale()
      local config = {
        button = icon,
        key = "get_reward" .. ind,
        clickHandler = function()
          ed.ui.packageDetailWin.create({
            type = reward["Reward Type 1"],
            id = reward["Reward ID 1"],
            amount = reward["Reward Amount 1"]
          }):popWindow()
        end,
        force = true,
        mcpMode = true,
        mcp_dis = 30,
        clickInterval = 0.3,
        pressScale = 0.95 * scale,
        normalScale = scale,
        priority = -1,
        extraCheckHandler = function(x, y)
          return ed.containsPoint(self.ui.layer_reward, x, y)
        end
      }
      self:btRegisterButtonClick(config)
    end
    if not (not progress_flag or reach) or ind == self.rewardsCnt then
      local targetLen = 110 * ind
      local leftLen = 1 < ind and 110 * (ind - 1) or 10
      local lastProgress = 1 < ind and self.mgr.rewardTbl[ind - 1]["Require Feet"] or 0
      local rat = (math.min(self.nextStageProgress, feet) - lastProgress) / (feet - lastProgress)
      progress_bar:setContentSize(CCSizeMake(targetLen * rat + leftLen * (1 - rat), barSize.height))
      progress_flag = false
    end
    progress_bar:setVisible(self.nextStageProgress ~= 0)
    if reward_flag and (not (not canGet and reach) or ind == self.rewardsCnt) then
      reward_flag = false
      reward_ind = ind
    end
  end
  self.draglist:setListPos(ccp(self.ui.layer_reward:getContentSize().width * 0.5 - 110 * reward_ind - 30, 0), true)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.title_bg, {left = 65, top = 0})
  ed.layout.layoutWithMagin(self.ui.next_stage_bg, {right = 0, top = 40})
  local layerSize = self.ui.layer_reward:getContentSize()
  self.ui.layer_reward:setContentSize(CCSizeMake(ed.display.halfFixedWidth * 2 + layerSize.width, layerSize.height))
  ed.UITool.setPositionBy(self.ui.layer_reward, ccp(-ed.display.halfFixedWidth, 0))
end

function class:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_rule", function()
    local rules = self.mgr:getActivityCfg().Rules
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = rules
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
end

function class:registerEvents()
  self:listenTimer(Timer:Always(1), function()
    self:updateLeftTime()
  end)
  self:listenEvent("dragonBoatRefreshRewardList", function()
    self:refreshRewards()
  end)
end

function class:updateLeftTime()
  local leftTime = self.endTime - ed.getServerTime()
  if leftTime <= 0 then
    ed.popScene()
    return
  end
  ed.setLabelString(self.ui.label_left_time, T("\229\137\169\228\189\153 %s", ed.time2dhms(leftTime)))
end

function class:doMoveAction(node, moveOffset, costTime, delayTime)
  costTime = costTime or 0.3
  local oriPosX, oriPosY = node:getPosition()
  local startPos = ccp(oriPosX - moveOffset.x, oriPosY - moveOffset.y)
  node:setPosition(startPos)
  local targetPos = ccp(oriPosX, oriPosY)
  local action = CCMoveTo:create(costTime, targetPos)
  if delayTime then
    node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), action))
  else
    node:runAction(action)
  end
end

function class:talkLayerTouchShow()
  local taskLink = {}
  self.ui.img_dialog:setOpacity(0)
  local str = ""
  local strLab = ed.createLabelTTF(str, 19)
  ed.setLabelColor(strLab, ccc3(127, 66, 17))
  self.ui.img_dialog:addChild(strLab)
  self.talkStr = strLab
  self.talkStr:setOpacity(0)
  for k, v in pairs(ed.getDataTable("DragonBoatTalk")) do
    local taskStr = {}
    for ii, vv in ipairs(v) do
      taskStr[ii] = vv["Talk Text"]
    end
    table.insert(taskLink, taskStr)
  end
  self.NTLink = math.random(1, #taskLink)
  self.NTIndex = 1
  local ui = self.ui
  
  local function talkActFunc()
    local txt = ""
    if not taskLink[self.NTLink][self.NTIndex] then
      self.NTLink = math.random(1, #taskLink)
      self.NTIndex = 1
    end
    txt = taskLink[self.NTLink][self.NTIndex]
    self.NTIndex = self.NTIndex + 1
    self.talkStr:setString(txt)
    self.ui.img_dialog:setContentSize(CCSizeMake(self.talkStr:getContentSize().width + 30, self.ui.img_dialog:getContentSize().height))
    self.talkStr:setPosition(ccp(self.talkStr:getContentSize().width * 0.5 + 15, 35))
    self.ui.img_dialog:setOpacity(255)
    self.talkStr:setOpacity(255)
    self.ui.img_dialog:stopAllActions()
    self.ui.img_dialog:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.3, 255), CCDelayTime:create(2), CCFadeTo:create(0.5, 0))))
    self.talkStr:stopAllActions()
    self.talkStr:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.3, 255), CCDelayTime:create(2), CCFadeTo:create(0.5, 0))))
  end
  
  talkActFunc()
  local tak = 0
  self:listenTimer(Timer:Always(1), function()
    tak = tak + 1
    if 7 <= tak then
      tak = 0
      talkActFunc()
    end
  end)
  self:btRegisterButtonClick({
    button = self.ui.talk_touch,
    key = "dragon_boat_talkTouch",
    clickHandler = function()
      tak = 0
      talkActFunc()
    end,
    clickInterval = 0.2
  })
end
