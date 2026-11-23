local base = ed.ui.commonscene
local SecretBoxScene = newclass(base.mt)
ed.ui.SecretBoxScene = SecretBoxScene

function SecretBoxScene:initData(param)
  self.vaultId = param._vault_id
  self.rewards = {}
  local vaultTb = ed.getDataTable("ChargeVaultReward")[self.vaultId]
  for k, v in pairs(vaultTb or {}) do
    local item = {
      index = v.Index,
      progress = v["Need Score"],
      rewards = {
        id = v["Reward ID"],
        amount = v["Reward Amount"],
        type = v["Reward Type"]
      },
      state = 0
    }
    self.rewards[k] = item
  end
  local circleGotTimes = 0
  for k, v in ipairs(param._reward_flags or {}) do
    if 10000 < v then
      circleGotTimes = circleGotTimes + 1
    else
      self.rewards[v].state = 1
    end
  end
  local chargeVaultTb = ed.getDataTable("ChargeVault")[self.vaultId]
  self.hadCircleReward = chargeVaultTb["Circulation Score"] and 0 < tonumber(chargeVaultTb["Circulation Score"])
  if self.hadCircleReward then
    self.circleReward = {
      score = chargeVaultTb["Circulation Score"],
      type = chargeVaultTb["Circulation Reward Type"],
      id = chargeVaultTb["Circulation Reward ID"],
      amount = chargeVaultTb["Circulation Reward Amount"]
    }
  end
  self.timeStr = string.format(T("\231\187\147\230\157\159\230\151\182\233\151\180:%s") .. ed.getUTCLabel(), ed.getYMDHMSTime(ed.time2Server(param._end_time)))
  self.curProgress = param._score
  local totalTimes = math.floor((self.curProgress - self.rewards[#self.rewards].progress) / 1000)
  self.totalTimes = totalTimes
  self.circleTimes = totalTimes - circleGotTimes
end

function SecretBoxScene:adaptUI()
  local leftPos = self.ui.main_title:getPositionX() + self.ui.main_title:getContentSize().width * 0.5
  self.ui.btn_rule:setPositionX(leftPos + self.ui.btn_rule:getContentSize().width * 0.6)
end

function SecretBoxScene:initLabels()
  ed.setLabelStroke(self.ui.label_progress, ed.toccc3(3219729), 1.5)
  ed.setString(self.ui.label_progress, string.format("%d", self.curProgress))
  ed.setLabelStroke(self.ui.Label_1159, ed.toccc3(5586983), 1)
  ed.setString(self.ui.Label_1159, self.timeStr)
end

function SecretBoxScene:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.SecretItem)
  local icon = ed.createItemIcon(data.rewards)
  icon:setScale(1)
  ed.UITool.replaceUI(ui, "bg", "icon_reward", icon)
  ui.redlight:setVisible(false)
  if data.state == 1 then
    ui.icon_fin:setVisible(true)
    ui.mask:setVisible(true)
    ui.icon_lock:setVisible(false)
  elseif data.progress <= self.curProgress then
    ui.icon_unlock:setVisible(true)
    ui.icon_lock:setVisible(false)
    local redLight = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    redLight:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    redLight:setPosition(44, 44)
    icon:addChild(redLight)
    ui.redlight:setVisible(true)
  end
  ed.setLabelStroke(ui.Label_1073, ed.toccc3(4073745), 1.5)
  ed.setString(ui.Label_1073, string.format(T("%d\231\167\175\229\136\134"), data.progress))
  return container, ui
end

function SecretBoxScene:createCircleItem(data)
  local container, ui = ed.editorui(ed.uieditor.SecretItem1)
  print(self.circleTimes)
  local reward = {
    type = data.type,
    amount = data.amount,
    id = data.id
  }
  local icon = ed.createItemIcon(reward)
  icon:setScale(1)
  ed.UITool.replaceUI(ui, "bg", "icon_reward", icon)
  ui.redlight:setVisible(false)
  ed.setLabelStroke(ui.Label_128, ed.toccc3(1315346), 1)
  ui.Label_128:setString(self.circleTimes)
  if self.circleTimes < 1 and self.totalTimes > 0 then
    ui.icon_fin:setVisible(true)
    ui.mask:setVisible(true)
    ui.icon_lock:setVisible(false)
  elseif self.circleTimes > 0 then
    ui.icon_unlock:setVisible(true)
    ui.icon_lock:setVisible(false)
    local redLight = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    redLight:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    redLight:setPosition(44, 44)
    icon:addChild(redLight)
    ui.redlight:setVisible(true)
  end
  ed.setLabelStroke(ui.Label_1073, ed.toccc3(4073745), 1.5)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format(T("\230\175\143\233\162\157\229\164\150<lable color=ccc3(255,242,148)>%d</lable>\231\167\175\229\136\134\229\143\175\232\142\183\229\190\151\233\162\157\229\164\150\229\165\150\229\138\177"), data.score),
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(4073745),
    strokeSize = 1,
    maxWidth = 130,
    fontSize = 17
  })
  ed.UITool.replaceUINew(ui, "Label_1073", autoText.node)
  return container, ui
end

function SecretBoxScene:refreshDraglist(oldPos)
  local x, y
  if oldPos then
    x, y = self.draglist.listLayer:getPosition()
  end
  for k, v in ipairs(self.containUI or {}) do
    v:removeFromParentAndCleanup(true)
  end
  self.uiList = {}
  self.containUI = {}
  local listData = self.rewards
  
  local function getPos(index)
    return ccp(12 + 150 * index, 12)
  end
  
  for k, v in ipairs(listData) do
    local container, ui = self:createItem(v)
    ui.data = v
    table.insert(self.uiList, ui)
    table.insert(self.containUI, container)
    self.ui.bg_bar:addChild(container, 1)
    if v.state == 0 and self.curProgress > v.progress then
      local point = ed.createSprite("UI/alpha/1080P/newshop/secretbox/secretbox_point.png")
      point:setPosition(getPos(k))
      self.ui.bg_bar:addChild(point, 5)
    end
    container:setPosition(getPos(k))
  end
  if self.circleReward then
    local container, ui = self:createCircleItem(self.circleReward)
    ui.data = self.circleReward
    ui.type = "circleReward"
    table.insert(self.uiList, ui)
    table.insert(self.containUI, container)
    self.ui.bg_bar:addChild(container, 1)
    container:setPosition(getPos(#listData + 1))
  end
  if oldPos then
    self.draglist.listLayer:setPosition(ccp(x, y))
  end
end

function SecretBoxScene:findUnGetReward()
  for k, v in ipairs(self.rewards) do
    if v.state == 0 and v.progress <= self.curProgress then
      local posx = -538 + 150 * k
      posx = math.min(880, posx)
      posx = math.max(0, posx)
      self.draglist.listLayer:setPosition(ccp(-posx, 0))
      return
    end
  end
  if self.circleTimes and 0 < self.circleTimes then
    self.draglist.listLayer:setPosition(ccp(-575, 0))
  end
end

function SecretBoxScene:refreshLayer(oldPos)
  self:refreshDraglist(oldPos)
end

function SecretBoxScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon_reward, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function SecretBoxScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function SecretBoxScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local data = v.data
    if v.type == "circleReward" then
      ed.RechargeNetwork:sendGetSecretBoxReward(nil, true)
    else
      if v.data.state == 1 or v.data.progress > self.curProgress then
        ed.ui.packageDetailWin.create(v.data.rewards):popWindow()
        return
      end
      ed.RechargeNetwork:sendGetSecretBoxReward(data.index)
    end
  end
  
  return handler
end

function SecretBoxScene:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -100,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  local bg_bar = self.ui.bg_bar
  bg_bar:removeFromParentAndCleanup(false)
  bg_bar:setPosition(ccp(55, 60))
  local numOfSteps = #self.rewards
  local ox = 12
  local pxOfStep = 150
  for i = 1, numOfSteps do
    if self.rewards[i].progress <= self.curProgress then
      ox = ox + pxOfStep
    else
      local perc = 1
      if i == 1 then
        perc = (self.curProgress - 0) / (self.rewards[i].progress - 0)
      else
        perc = (self.curProgress - self.rewards[i - 1].progress) / (self.rewards[i].progress - self.rewards[i - 1].progress)
      end
      ox = ox + pxOfStep * perc
      break
    end
  end
  local circlePx = 0
  if self.circleReward then
    circlePx = 150
    local perc = (self.curProgress - self.rewards[#self.rewards].progress) / self.circleReward.score
    ox = ox + 150 * math.max(0, math.min(perc, 1))
  elseif self.rewards[#self.rewards].progress < self.curProgress then
    ox = 150 * numOfSteps + 32
  end
  print("ox:", ox)
  self.ui.bar:setContentSize(CCSizeMake(ox, 24.5))
  self.ui.icon_cur:setPositionX(ox)
  self.ui.icon_cur:setZOrder(999)
  bg_bar:setContentSize(CCSizeMake(150 * numOfSteps + circlePx + 23, 24.5))
  self.draglist:initListWidth(150 * numOfSteps + 140 + circlePx)
  self.draglist:addItem(bg_bar)
end

function SecretBoxScene:initUI()
  local container = self.mainLayer
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.SecretboxScene)
  self:setBackground("UI/alpha/1080P/newshop/secretbox/secretbox_bg.jpg")
  self:setBackButton(function()
  end)
  self:adaptUI()
  self:initLabels()
  self:createDraglist()
  self:refreshLayer()
  self:findUnGetReward()
end

function SecretBoxScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.SecretBoxRuleWin.create():popWindow()
  end)
end

function SecretBoxScene:registerEvents()
  self:listenEvent("ChangeSecretBoxState", function(index)
    self.rewards[index].state = 1
    self:refreshDraglist(true)
    local isNeedRed = self.circleTimes and self.circleTimes > 0
    for k, v in ipairs(self.rewards) do
      if v.state == 0 and self.curProgress >= v.progress then
        isNeedRed = true
        break
      end
    end
    if isNeedRed ~= ed.RechargeManager.SecretBoxRedLight then
      ed.RechargeManager.SecretBoxRedLight = isNeedRed
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.RECHARGE)
    else
      ed.RechargeManager.SecretBoxRedLight = isNeedRed
    end
  end)
  self:listenEvent("ChangeSecretCircle", function()
    self.circleTimes = 0
    self:refreshDraglist(true)
    local isNeedRed = false
    for k, v in ipairs(self.rewards) do
      if v.state == 0 and self.curProgress >= v.progress then
        isNeedRed = true
        break
      end
    end
    if isNeedRed ~= ed.RechargeManager.SecretBoxRedLight then
      ed.RechargeManager.SecretBoxRedLight = isNeedRed
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.RECHARGE)
    else
      ed.RechargeManager.SecretBoxRedLight = isNeedRed
    end
  end)
end

function SecretBoxScene.create(param)
  local self = base.create("SecretBoxScene", {noBottomButton = true})
  setmetatable(self, SecretBoxScene.mt)
  self:initData(param)
  self:initUI()
  self:registerEvents()
  self:registerTouchHandlers()
  self:registerOnPopSceneHandler("OnPopSecretBoxScene", function()
    if self.callback then
      self.callback()
    end
  end)
  return self
end
