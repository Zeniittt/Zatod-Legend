local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.moonFestivalRewardScene = class
ed.UITool.registViewOpenFunc("moonFestivalRewardScene", function()
  local scene = ed.ui.moonFestivalRewardScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("moonFestivalRewardScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initData()
  self:initUI()
  self:registerEvents()
end

function class:initData()
  self.endTime = ed.getServerTime() + 252000 + 556
  self.mgr = ed.moonFestivalMgr.getInstance()
  self.nextStageProgress = self.mgr.nextStageProgress
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.moonFestivalRewardScene)
  self.container = container
  self.mainLayer:addChild(self.container)
  self.ui = ui
  self:initBG()
  self:initLabel()
  self:initRewards()
  self:initLight()
  self:setBackButton(function()
  end)
end

function class:initBG()
  ed.layout.lazyAdaptBG(self.ui.bg)
  ed.layout.layoutWithMagin(self.ui.bg_title, {top = 0, left = 0})
  self:doMoveAction(self.ui.left_door_3, ccp(-565, 0), 0.4, nil, true)
  self:doMoveAction(self.ui.left_door_2, ccp(-320, 0), 0.22, 0.18, true)
  self:doMoveAction(self.ui.left_door_1, ccp(-75, 0), 0.05, 0.35, true)
  self:doMoveAction(self.ui.right_door_3, ccp(565, 0), 0.4, nil, true)
  self:doMoveAction(self.ui.right_door_2, ccp(320, 0), 0.22, 0.18, true)
  self:doMoveAction(self.ui.right_door_1, ccp(75, 0), 0.05, 0.35, true)
  self:doScaleAction(self.ui.front_floor, 1, 1.01, 0.6, 0.24)
  self:doScaleAction(self.ui.table, 1, 1.01, 0.6, 0.24)
  self.ui.bunny:setScale(0.96)
  local bunnyAction = CCSequence:create(ccArrayMake(CCDelayTime:create(0.24), CCScaleTo:create(0.6, 0.98), CCScaleTo:create(0.16, 1)))
  self.ui.bunny:runAction(bunnyAction)
  self:doSpawnAction(self.ui.tree, ccp(0, 3), 0.6, 0.24, false, 0.995, 1, 0.6, 0.24)
  self:doSpawnAction(self.ui.moon, ccp(0, 12), 0.48, 0.24, false, 0.9, 1, 0.48, 0.24)
  self:doSpawnAction(self.ui.stone, ccp(0, -10), 0.6, 0.2, false, 0.9, 1, 0.6, 0.2)
  self:doSpawnAction(self.ui.floor, ccp(0, 10), 0.6, 0.24, false, 0.96, 1, 0.6, 0.24)
  self:doSpawnAction(self.ui.right_village, ccp(14, 13), 0.56, 0.24, false, 0.97, 1, 0.56, 0.24)
  self:doSpawnAction(self.ui.left_village, ccp(-8, 9), 0.56, 0.24, false, 0.97, 1, 0.56, 0.24)
  self:doSpawnAction(self.ui.right_mountain2, ccp(9, 36), 0.4, 0.24, false, 0.9, 1, 0.4, 0.24)
  self:doSpawnAction(self.ui.right_mountain1, ccp(20, 29), 0.44, 0.24, false, 0.9, 1, 0.44, 0.24)
  self:doSpawnAction(self.ui.left_mountain, ccp(-6, 8), 0.44, 0.24, false, 0.9, 1, 0.44, 0.24)
  self:doSpawnAction(self.ui.left_building, ccp(3, 12), 0.44, 0.24, false, 0.96, 1.065, 0.44, 0.24)
  local oriPosx, oriPosy = self.ui.flower_pos1:getPosition()
  local curPosx, curPosy = self.ui.flower1:getPosition()
  local action1 = CCDelayTime:create(1.8)
  local action2 = CCMoveTo:create(1.2, ccp(curPosx - oriPosx, curPosy - oriPosy))
  local action4 = CCCallFunc:create(function()
    self.ui.flower1:setVisible(true)
    self.ui.fall_flower1:setPosition(0, 0)
  end)
  local action3 = CCDelayTime:create(1)
  self.ui.fall_flower1:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2, action3, action4))))
  oriPosx, oriPosy = self.ui.flower_pos2:getPosition()
  curPosx, curPosy = self.ui.flower2:getPosition()
  action1 = CCDelayTime:create(0.92)
  action2 = CCMoveTo:create(1.4, ccp(curPosx - oriPosx, curPosy - oriPosy))
  action4 = CCCallFunc:create(function()
    self.ui.flower2:setVisible(true)
    self.ui.fall_flower2:setPosition(0, 0)
  end)
  action3 = CCDelayTime:create(1.68)
  self.ui.fall_flower2:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2, action3, action4))))
end

function class:initLabel()
  local label_bg, label = ed.UITool.createSceneTitle(T("\230\152\159\230\190\156\232\183\131\229\189\177"), self.ui.bg_title, {
    position = ccp(60, 18),
    maxWidth = 180
  })
  ed.layout.centerInParent(label_bg)
  local label_left_time = ed.createLabelTTF("", 17)
  label_left_time:setPositionY(self.ui.left_time_icon:getPositionY())
  label_left_time:setAnchorPoint(ccp(0, 0.5))
  self.ui.left_time_bg:addChild(label_left_time)
  ed.right2(label_left_time, self.ui.left_time_icon, 4)
  ed.setLabelColor(label_left_time, ccc3(255, 255, 255))
  ed.setLabelStroke(label_left_time, ed.toccc3(4406386), 1)
  self.ui.label_left_time = label_left_time
  do return end
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
  local draglist = ed.UITool.createDraglist(self.ui.reward_layer, {priority = -300})
  local layerScale = ed.layout.getScale(self.ui.reward_layer, true)
  local clip = draglist.cliprect
  clip.size.width = clip.size.width * layerScale
  clip.size.height = clip.size.height * layerScale
  draglist:initClipRect(clip)
  self.draglist = draglist
  self.firstRefreshReward = true
  self:refreshRewards()
end

function class:createRewardItem(idx)
  local container, ui = ed.editorui(ed.uieditor.moonFestivalRewardItem)
  local reward = self.mgr.rewardTbl[idx]
  local itemIcon = ed.createItemIcon({
    type = reward["Reward Type 1"],
    id = reward["Reward ID 1"],
    amount = reward["Reward Amount 1"]
  })
  itemIcon:setScale(80 / itemIcon:getContentSize().width)
  ui.itemIcon = itemIcon
  ui.plate:addChild(itemIcon)
  itemIcon:setPosition(ui.icon:getPosition())
  local feet = reward["Require Feet"]
  local reach = feet <= self.nextStageProgress
  local canGet = false
  local feetColor = ccc3(255, 247, 174)
  local feetStrokeColor = ed.toccc3(7758080)
  if reach then
    if ed.isElementInTable(idx, self.mgr.receivedRewards) then
      ed.setTexture(ui.plate, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_silver.png")
      ed.setTexture(ui.feet_bg, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_silver_bg.png")
      feetColor = ccc3(255, 160, 86)
      feetStrokeColor = ed.toccc3(5121819)
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      mask:setPosition(ccp(45, 45))
      local tick = ed.createSprite("UI/alpha/1080P/rogue/collect/collect_event_done.png")
      mask:addChild(tick)
      tick:setPosition(ccp(50, 40))
      mask:setZOrder(1)
      itemIcon:addChild(mask)
    else
      ed.setTexture(ui.plate, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_golden.png")
      ed.setTexture(ui.feet_bg, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_golden_bg.png")
      feetColor = ccc3(255, 255, 255)
      feetStrokeColor = ed.toccc3(15295000)
      canGet = true
      local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
      itemIcon:addChild(light)
      light:setPosition(ccp(45, 45))
      light:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
      ui.light = light
      local config = {
        button = icon,
        key = "get_reward" .. idx,
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
    end
  end
  local feetLabel = ed.ui.autoText.new()
  feetLabel:initParam({
    context = T("%s\229\176\186", "<lable fontSize=f22>" .. feet .. "</lable>"),
    color = feetColor,
    strokeColor = feetStrokeColor,
    strokeSize = 1,
    fontSize = 15
  })
  ui.feet_bg:addChild(feetLabel.node)
  ed.layout.centerInParent(feetLabel.node)
  local wid, _ = feetLabel:getCurContentSize()
  ed.UITool.setPositionBy(feetLabel.node, ccp(-wid * 0.5, 0))
  if not canGet and false then
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
  return container, {ui = ui, canGet = canGet}
end

function class:refreshRewards(stayPos)
  local oldPosX, oldPosY = self.draglist:getListPos()
  self.rewardList = {}
  self.draglist:clearList()
  local reward_flag = true
  local reward_ind = 1
  self.rewardCnt = 0
  for ind, reward in ipairs(self.mgr.rewardTbl) do
    self.rewardCnt = self.rewardCnt + 1
  end
  for ind, reward in ipairs(self.mgr.rewardTbl) do
    local posX = 60 + 148 * (ind - 1)
    local container, ui = ed.editorui(ed.uieditor.moonFestivalRewardItem)
    container:setPosition(ccp(posX, 2))
    self.draglist:addItem(container)
    local itemIcon = ed.createItemIcon({
      type = reward["Reward Type 1"],
      id = reward["Reward ID 1"],
      amount = reward["Reward Amount 1"]
    })
    itemIcon:setScale(80 / itemIcon:getContentSize().width)
    ui.itemIcon = itemIcon
    ui.plate:addChild(itemIcon)
    itemIcon:setPosition(ui.icon:getPosition())
    local feet = reward["Require Feet"]
    local reach = feet <= self.nextStageProgress
    local canGet = false
    local feetColor = ccc3(255, 247, 174)
    local feetStrokeColor = ed.toccc3(7758080)
    if reach then
      if ed.isElementInTable(ind, self.mgr.receivedRewards) then
        ed.setTexture(ui.plate, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_silver.png")
        ed.setTexture(ui.feet_bg, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_silver_bg.png")
        feetColor = ccc3(255, 160, 86)
        feetStrokeColor = ed.toccc3(5121819)
        local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
        mask:setPosition(ccp(45, 45))
        local tick = ed.createSprite("UI/alpha/1080P/rogue/collect/collect_event_done.png")
        mask:addChild(tick)
        tick:setPosition(ccp(50, 40))
        mask:setZOrder(1)
        itemIcon:addChild(mask)
      else
        ed.setTexture(ui.plate, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_golden.png")
        ed.setTexture(ui.feet_bg, "UI/alpha/1080P/bunnyrace/br_reward/br_reward_golden_bg.png")
        feetColor = ccc3(255, 255, 255)
        feetStrokeColor = ed.toccc3(15295000)
        canGet = true
        local light = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
        itemIcon:addChild(light)
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
      end
    end
    local feetLabel = ed.ui.autoText.new()
    feetLabel:initParam({
      context = T("%s\229\176\186", "<lable fontSize=f22>" .. feet .. "</lable>"),
      color = feetColor,
      strokeColor = feetStrokeColor,
      strokeSize = 1,
      fontSize = 15
    })
    ui.feet_bg:addChild(feetLabel.node)
    ed.layout.centerInParent(feetLabel.node)
    local wid, _ = feetLabel:getCurContentSize()
    ed.UITool.setPositionBy(feetLabel.node, ccp(-wid * 0.5, 0))
    if not canGet and false then
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
    table.insert(self.rewardList, {container = container, ui = ui})
    if reward_flag and (not (not canGet and reach) or ind == self.rewardCnt) then
      reward_flag = false
      reward_ind = math.min(math.max(ind - 1, 1), self.rewardCnt - 5)
    end
  end
  self.draglist:initListWidth(148 * self.rewardCnt - 178)
  if stayPos then
    self.draglist:setListPos(ccp(oldPosX, oldPosY), true)
  else
    local posX = 148 * (reward_ind - 1)
    self.draglist:setListPos(ccp(-posX, 0), true)
  end
  if self.firstRefreshReward then
    self.firstRefreshReward = false
    for i = 0, 5 do
      local reward = self.rewardList[reward_ind + i]
      ed.setCascadeOpacityEnabled(reward.ui.plate, true, true)
      reward.ui.plate:setOpacity(0)
      reward.ui.plate:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.16 + i * 0.125), CCFadeTo:create(0.125, 255)))
    end
  end
end

function class:initLight()
  math.randomseed(os.time())
  self.circleItems = {}
  local randomParam = {
    [1] = {
      speed = {60, 140},
      height = {2, 10},
      widScale = {0.2, 0.6},
      initTime = {0, 360},
      shakeTime = {3, 8},
      shakeAngleRange = {3, 7}
    },
    [2] = {
      speed = {10, 36},
      height = {2, 25},
      widScale = {0.5, 1.5},
      initTime = {0, 360}
    }
  }
  self.ui.light1:setScale(0.95)
  local specAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCScaleTo:create(0.6, 1))
  self.ui.light1:runAction(specAction)
  local lightParam = randomParam[1]
  for i = 1, 8 do
    local param = {}
    for key, table in pairs(lightParam) do
      param[key] = table[1] + math.random() * (table[2] - table[1])
    end
    param.bShake = true
    param.node = self.ui["light" .. i]
    if 4 < i then
      param.speed = (param.speed or 0) / 4
      param.shakeTime = (param.shakeTime or 0) * 4
    end
    table.insert(self.circleItems, self.circleItem.create(param))
  end
  lightParam = randomParam[2]
  for i = 1, 15 do
    local param = {}
    for key, table in pairs(lightParam) do
      param[key] = table[1] + math.random() * (table[2] - table[1])
    end
    param.bShake = false
    param.node = self.ui["point" .. i]
    local breathTime = math.random() * 2 + 1
    param.node:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(breathTime), CCFadeIn:create(breathTime))))
    table.insert(self.circleItems, self.circleItem.create(param))
  end
  self:registerUpdateHandler("circleItemUpdateFunc", function(dt)
    for _, item in ipairs(self.circleItems) do
      item:update(dt)
    end
  end)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.title_bg, {left = 65, top = 0})
  ed.layout.layoutWithMagin(self.ui.next_stage_bg, {right = 0, top = 40})
  local layerSize = self.ui.layer_reward:getContentSize()
  self.ui.layer_reward:setContentSize(CCSizeMake(ed.display.halfFixedWidth * 2 + layerSize.width, layerSize.height))
  ed.UITool.setPositionBy(self.ui.layer_reward, ccp(-ed.display.halfFixedWidth, 0))
end

function class:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_tips", function()
    local rules = self.mgr:getActivityCfg().Rules
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = rules
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
end

function class:registerEvents()
  self:updateLeftTime()
  self:listenTimer(Timer:Always(1), function()
    self:updateLeftTime()
  end)
  self:listenEvent("moonFestivalRefreshRewardList", function()
    self:refreshRewards(true)
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

function class:doMoveAction(node, moveOffset, costTime, delayTime, inOriPos)
  costTime = costTime or 0.3
  local oriPosX, oriPosY = node:getPosition()
  if inOriPos then
    oriPosX, oriPosY = oriPosX + moveOffset.x, oriPosY + moveOffset.y
  end
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

function class:doScaleAction(node, oriScale, dstScale, costTime, delayTime)
  costTime = costTime or 0.3
  node:setScale(oriScale)
  local action = CCScaleTo:create(costTime, dstScale)
  if delayTime then
    node:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(delayTime), action))
  else
    node:runAction(action)
  end
end

function class:doSpawnAction(node, moveOffset, moveCostTime, moveDelayTime, inOriPos, oriScale, dstScale, scaleCostTime, scaleDelayTime)
  if not moveOffset or not oriScale then
    return
  end
  moveCostTime = moveCostTime or 0.3
  scaleCostTime = scaleCostTime or 0.3
  local oriPosX, oriPosY = node:getPosition()
  if inOriPos then
    oriPosX, oriPosY = oriPosX + moveOffset.x, oriPosY + moveOffset.y
  end
  local startPos = ccp(oriPosX - moveOffset.x, oriPosY - moveOffset.y)
  node:setPosition(startPos)
  local targetPos = ccp(oriPosX, oriPosY)
  local action = CCMoveTo:create(moveCostTime, targetPos)
  local moveAction = action
  if moveDelayTime then
    moveAction = CCSequence:createWithTwoActions(CCDelayTime:create(moveDelayTime), action)
  end
  node:setScale(oriScale)
  action = CCScaleTo:create(scaleCostTime, dstScale)
  local scaleAction = action
  if scaleDelayTime then
    scaleAction = CCSequence:createWithTwoActions(CCDelayTime:create(scaleDelayTime), action)
  end
  local spawnAction = CCSpawn:create(ccArrayMake(moveAction, scaleAction))
  node:runAction(spawnAction)
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

local circleItem = {}
class.circleItem = circleItem

function circleItem.create(param)
  local self = {}
  setmetatable(self, {__index = circleItem})
  self:init(param)
  return self
end

function circleItem:init(param)
  self.speed = (param.speed or 0) * (math.random() > 0.5 and 1 or -1)
  self.height = param.height or 10
  self.widScale = param.widScale or 1
  self.initTime = param.initTime or 0
  self.bShake = param.bShake or false
  if self.bShake then
    self.shakeTime = param.shakeTime or 1
    self.shakeAngleRange = param.shakeAngleRange or 5
  end
  self.node = param.node
  self.oriPosX, self.oriPosY = param.node:getPosition()
  self.angle = self.initTime
  self.shakeAngle = self.initTime
  self.width = self.height * self.widScale
  self.centerPos = ccp(self.oriPosX - self.width * 0.5, self.oriPosY)
end

function circleItem:getNewPosition()
  local angle = self.angle / 180 * math.pi
  local posX = self.centerPos.x + math.cos(angle) * self.width * 0.5
  local posY = self.centerPos.y + math.sin(angle) * self.height * 0.5
  return ccp(posX, posY)
end

function circleItem:update(dt)
  self.angle = self.angle + self.speed * dt
  self.node:setPosition(self:getNewPosition())
  if self.bShake then
    self.shakeAngle = self.shakeAngle + 360 / self.shakeTime * dt
    self.node:setRotation(self.shakeAngleRange * math.sin(self.shakeAngle / 180 * math.pi))
  end
end

local rewardItem = {}
class.rewardItem = rewardItem

function rewardItem.create(mainSelf, param)
  local self = {}
  setmetatable(self, {__index = rewardItem})
  self.mainSelf = mainSelf
  self:init(param)
  return self
end

function rewardItem:init(param)
end
