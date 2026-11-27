local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipResetRewardWindow = class
ed.UITool.registViewOpenFunc("legendEquipResetRewardWindow", function(params)
  local window = ed.ui.legendEquipResetRewardWindow.create(params)
  window:popWindow()
end)

function class.create(params)
  local self = base.create("legendEquipResetRewardWindow", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData(params or {})
  self:initView()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  return self
end

function class:initData(params)
  self.rewards = params.rewards or {}
  self.callback = params.callback
  self.tipStr = params.tipStr
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_reset_reward_window)
  self.ui = ui
  self.container:addChild(container)
  self:adaptUI()
  self:initTips()
  self:initLabels()
  self:initRewardsView()
end

function class:adaptUI()
  self.col = 5
  local itemSize = CCSizeMake(200, 180)
  self.itemSize = itemSize
  local spaceSize = CCSizeMake(-50, 0)
  self.spaceSize = spaceSize
  local rewardsLen = #self.rewards
  local w, h = itemSize.width + spaceSize.width, itemSize.height + spaceSize.height
  local realCol = math.min(self.col, rewardsLen)
  local totalSize = CCSizeMake(realCol * itemSize.width + (realCol - 1) * spaceSize.width, h * math.ceil(rewardsLen / 5))
  self.totalSize = totalSize
  local oldHeight = self.ui.bg:getContentSize().height
  local oldWidth = self.ui.bg:getContentSize().width
  if 5 < #self.rewards then
    local newHeight = 459
    self.ui.bg:setContentSize(CCSizeMake(oldWidth, newHeight))
    local diffHeight = newHeight - oldHeight
    self.ui.image_title:setPositionY(self.ui.image_title:getPositionY() + diffHeight)
    self.ui.panel_tips:setPositionY(self.ui.panel_tips:getPositionY() + diffHeight)
    self.ui.btn_confirm:setPositionY(self.ui.btn_confirm:getPositionY() - diffHeight)
    ed.UITool.setPositionBy(self.ui.bg, ccp(0, -diffHeight * 0.5))
    local oldPanelSize = self.ui.panel_content:getContentSize()
    self.ui.panel_content:setContentSize(CCSizeMake(oldPanelSize.width, oldPanelSize.height + diffHeight))
    ed.UITool.setPositionBy(self.ui.panel_content, ccp(0, -diffHeight))
  else
    local newWidth = totalSize.width
    local oldPanelSize = self.ui.panel_content:getContentSize()
    self.ui.panel_content:setContentSize(CCSizeMake(newWidth, oldPanelSize.height))
    self.ui.panel_content:setPositionX(self.ui.panel_content:getPositionX() + (oldPanelSize.width - newWidth) / 2)
  end
end

function class:initLabels()
  local label_confirm = ed.ui.gradientLabel.create({
    text = T("\231\161\174\229\174\154"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_confirm:addChild(label_confirm.node)
  local btnSize = self.ui.btn_confirm:getContentSize()
  label_confirm.node:setPosition(ccp(btnSize.width / 2, btnSize.height / 2))
end

function class:initTips()
  if nil == self.tipStr then
    return
  end
  local panelSize = self.ui.panel_tips:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self.tipStr,
    color = ccc3(255, 230, 154),
    shadowColor = ccc3(0, 0, 0),
    shadowOffset = ccp(0, 1.5),
    fontSize = 15,
    maxWidth = panelSize.width
  })
  self.ui.panel_tips:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(panelSize.width / 2 - w / 2, panelSize.height / 2))
end

function class:initRewardsView()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_content, {
    priority = -300,
    doPressIn = function(x, y)
      for index, rewardItemCfg in ipairs(self.rewardItemList or {}) do
        local icon = rewardItemCfg.icon
        if icon and ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          return rewardItemCfg
        end
      end
    end,
    doClickIn = function(x, y, rewardItemCfg)
      local reward = rewardItemCfg.reward
      ed.UITool.openView("packageDetail", {
        id = reward._id,
        type = reward._type
      })
    end,
    cancelPressIn = function(x, y, rewardItemCfg)
      local icon = rewardItemCfg.icon
      if icon then
        icon:setScale(1)
      end
    end
  })
  self:updateRewardsList()
end

function class:updateRewardsList()
  local col = self.col
  local panelSize = self.ui.panel_content:getContentSize()
  local itemSize = self.itemSize
  local spaceSize = self.spaceSize
  local totalSize = self.totalSize
  local offsetX = (panelSize.width - self.totalSize.width) / 2
  local posX = 0
  local posY = 0
  self.rewardItemList = {}
  for index, reward in ipairs(self.rewards) do
    local item = self:createRewardItem(reward)
    item:setPosition(ccp(posX + itemSize.width / 2 + offsetX, panelSize.height - posY - itemSize.height / 2))
    self.dragList:addItem(item)
    posX = posX + itemSize.width * 0.95 + spaceSize.width
    table.insert(self.rewardItemList, {
      item = item,
      reward = reward,
      icon = item.icon
    })
    if index % col == 0 then
      posX = 0
      posY = posY + itemSize.height + spaceSize.height
    end
  end
  self.dragList:initListHeight(totalSize.height)
  self:showRewardAction()
end

function class:showRewardAction()
  if #self.rewardItemList > self.col then
    self.dragList:setListPos(ccp(0, 30))
  else
    self.dragList:setListPos(ccp(0, 10))
  end
  local totalDelayTime = 0
  local targetPos
  for index, rewardItemCfg in ipairs(self.rewardItemList) do
    local item = rewardItemCfg.item
    local icon = rewardItemCfg.icon
    local light = item.light
    local light_2 = item.light_2
    local light_fragment_1 = item.light_fragment_1
    local lightParent = item.lightParent
    targetPos = self.container:convertToNodeSpace(ed.getWorldPos(item))
    icon:setCascadeOpacityEnabled(true)
    icon:setOpacity(0)
    local delay = CCDelayTime:create(0.1 + totalDelayTime)
    local fade = CCFadeTo:create(0.2, 255)
    icon:runAction(CCSequence:create(ccArrayMake(delay, fade)))
    totalDelayTime = totalDelayTime + 0.1
    if 1 < index and index < #self.rewardItemList and index % self.col == 0 then
      local delayAction = CCDelayTime:create(totalDelayTime)
      local actionMove = CCMoveBy:create(0.2, ccp(0, self.itemSize.height))
      self.dragList.listLayer:runAction(CCSequence:create(ccArrayMake(delayAction, actionMove)))
    end
  end
  self.ui.btn_confirm:setVisible(false)
  self.dragList:setTouchEnabled(false)
  self.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(totalDelayTime), CCCallFunc:create(function()
    self.actionEnd = true
    self.dragList:setTouchEnabled(true)
    self.ui.btn_confirm:setVisible(true)
  end))))
end

function class:createRewardItem(reward)
  local id = reward._id
  local type = reward._type or "item"
  local amount = reward._amount
  local bg = ed.createSprite()
  bg:setContentSize(self.itemSize)
  local icon = ed.createItemIcon({
    type = type,
    id = id,
    amount = amount
  })
  icon:setScale(1)
  if icon.amountLabel then
    icon.amountLabel:setScale(1)
  end
  if type == "legend_equip" then
    if icon.amountLabel then
      ed.setLabelString(icon.amountLabel, "x" .. amount)
    end
    local legendEquipCfg = ed.getDataTable("LegendEquip")[id]
    local labelName = ed.createttf(legendEquipCfg["Equip Name"], 16)
    icon:addChild(labelName)
    ed.setLabelColor(labelName, ed.toccc3(16748591))
    ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
    labelName:setPosition(ccp(45, -10))
    ed.adaptLabel(labelName, {maxWidth = 120, minScale = 0.8})
    local isOnly = legendEquipCfg["Is Only"]
    if isOnly then
      local imageOnlyTag = ed.createSprite("UI/alpha/1080P/legendequip/onlyequip_board2.png")
      icon:addChild(imageOnlyTag)
      imageOnlyTag:setPosition(ccp(45, 95))
      local onlyTag = ed.ui.gradientLabel.create({
        text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
        fontSize = 13,
        startColor = ed.toccc3(16777215),
        endColor = ed.toccc3(16776069)
      })
      imageOnlyTag:addChild(onlyTag.node)
      imageOnlyTag:setCascadeOpacityEnabled(true)
      ed.layout.centerInParent(onlyTag.node)
      imageOnlyTag:setScale(0.85)
    end
  else
    local name = ed.lookupDataTable("equip", "Name", id) or ed.getVirtualName(type, id)
    if not ed.isAreaZh() then
      name = name:gsub("%(", [[

%(]], 1)
    end
    local labelName = ed.createttf(name, 16)
    ed.setLabelColor(labelName, ed.toccc3(16776423))
    ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
    labelName:setPosition(ccp(45, -10))
    ed.adaptLabel(labelName, {maxWidth = 120, minScale = 0.8})
    icon:addChild(labelName)
  end
  if icon then
    bg:addChild(icon)
    icon:setPosition(ccp(self.itemSize.width / 2, self.itemSize.height / 2))
  end
  bg.icon = icon
  return bg
end

function class:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      if self.actionEnd then
        self:destroy()
      end
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.83, normalScale = 0.88})
end

function class:onDestroy()
  if self.callback then
    self.callback()
  end
  if self.closeAction then
    self.closeAction()
  end
end
