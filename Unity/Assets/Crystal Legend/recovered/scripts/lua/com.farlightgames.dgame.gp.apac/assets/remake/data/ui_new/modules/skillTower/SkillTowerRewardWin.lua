local base = ed.ui.popwindow
local SkillTowerRewardWin = newclass(base.mt)
ed.ui.SkillTowerRewardWin = SkillTowerRewardWin

function SkillTowerRewardWin.create(param)
  local self = base.create("SkillTowerRewardWin")
  setmetatable(self, SkillTowerRewardWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function SkillTowerRewardWin:initData(param)
  self.mgr = ed.SkillTowerManager
  self.callback = param.callback
end

function SkillTowerRewardWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      local btn_get = v.btn_get
      
      if ed.containsPoint(btn_get, x, y) and v.data.state == "enable" then
        btn_get:setScale(0.95)
        return v
      end
      for i = 1, 5 do
        if v["reward" .. i] and ed.containsPoint(v["reward" .. i], x, y) then
          return v
        end
      end
    end
    return nil
  end
  
  return handler
end

function SkillTowerRewardWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local btn_get = v.btn_get
    if ed.containsPoint(btn_get, x, y) and v.data.state == "enable" then
      ed.SkillTowerNetwork:sendTowerStarReward(v.data.id)
    end
    for i = 1, 5 do
      if v["reward" .. i] and ed.containsPoint(v["reward" .. i], x, y) then
        ed.ui.packageDetailWin.create(v.data.rewards[i]):popWindow()
      end
    end
  end
  
  return handler
end

function SkillTowerRewardWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.btn_get and not tolua.isnull(v.btn_get) then
      v.btn_get:setScale(1)
    end
  end
  
  return handler
end

function SkillTowerRewardWin:createRewardItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "unable" then
    readnode:addNode(ed.uieditor.SkillTowerRewardItemUn)
  elseif data.state == "enable" then
    readnode:addNode(ed.uieditor.SkillTowerRewardItem)
  else
    readnode:addNode(ed.uieditor.SkillTowerRewardItemGet)
    ed.setLabelStroke(ui.label_get, ccc3(8, 48, 18), 1)
  end
  local autoText = ed.ui.autoText.new()
  local richText = string.format(T("<lable color=ccc3(255,252,231) strokeColor=ccc3(85,64,39) strokeSize=1>\230\148\182\233\155\134</lable><lable color=ccc3(141,244,118) strokeColor=ccc3(85,64,39) strokeSize=1>%d</lable><lable color=ccc3(255,252,231) strokeColor=ccc3(85,64,39) strokeSize=1>\233\162\151\230\152\159</lable>"), data.needStars)
  autoText:initParam({context = richText})
  for k, v in ipairs(data.rewards or {}) do
    local icon = ed.createItemIcon(v)
    icon:setPosition(k * 60, 40)
    ui["reward" .. k] = icon
    ui.layer_reward:addChild(icon)
  end
  local x, y = ui.label_star_num:getPosition()
  ui.label_star_num:setVisible(false)
  autoText.node:setPosition(ccp(15, 42))
  ui.bg:addChild(autoText.node)
  local atWid, _ = autoText:getCurContentSize()
  if 125 < atWid then
    autoText.node:setScale(125 / atWid)
  end
  return container, ui
end

function SkillTowerRewardWin:getPos(i)
  return ccp(self.ui.layer_reward_item:getContentSize().width / 2, self.ui.layer_reward_item:getContentSize().height - 88 * i + 44)
end

function SkillTowerRewardWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  local x, y = self.draglist.listLayer:getPosition()
  self.rewardData = self.mgr.rewardList
  for k, v in ipairs(self.rewardData) do
    local container, ui = self:createRewardItem(v)
    ui.data = v
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(self:getPos(#self.rewardData - k + 1))
  end
  local amountLabelScale
  local amountLabelArr = {}
  for i, v in ipairs(uiList) do
    for i = 1, 5 do
      local rewardIcon = v["reward" .. i]
      if rewardIcon and rewardIcon.amountLabel then
        local scale = rewardIcon.amountLabel:getScaleX()
        local size = rewardIcon.amountLabel:getContentSize()
        if nil == amountLabelScale then
          amountLabelScale = scale
        end
        print("amountLabelScale", amountLabelScale)
        amountLabelScale = math.min(amountLabelScale, 70 / size.width)
        table.insert(amountLabelArr, rewardIcon.amountLabel)
      end
    end
  end
  for i, v in ipairs(amountLabelArr) do
    v:setScale(amountLabelScale)
  end
  self.uiList = uiList
  self.draglist:initListHeight(88 * #self.rewardData)
  self.draglist.listLayer:setPosition(ccp(x, y))
end

function SkillTowerRewardWin:findCanGetReward()
  local x, y = self.draglist.listLayer:getPosition()
  local k = #self.rewardData
  for k, v in ipairs(self.rewardData) do
    if v.state == "enable" then
      local y = math.max(0, 88 * (#self.rewardData - k + 1) - self.ui.layer_reward_item:getContentSize().height)
      self.draglist.listLayer:setPosition(ccp(x, y))
      return
    end
  end
  for k, v in ipairs(self.rewardData) do
    if v.state == "unable" then
      local y = math.max(0, 88 * (#self.rewardData - k + 1) - self.ui.layer_reward_item:getContentSize().height)
      self.draglist.listLayer:setPosition(ccp(x, y))
      return
    end
  end
end

function SkillTowerRewardWin:refreshUI()
  self:refreshDraglist()
end

function SkillTowerRewardWin:initUI()
  local container = self.mainLayer
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.SkillTowerRewardWin)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_reward_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -515
  })
  local x, y = self.ui.bg:getPosition()
  self.ui.bg:setPosition(ccp(x + ed.display.winSize.width / 2 - 480, y + ed.display.winSize.height / 2 - 270))
  ed.setString(self.ui.label_star_num, string.format("%d/%d", self.mgr.curStars, self.mgr.allStars))
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(1781328), 1.5)
  self.ui.label_title:setFontName(ed.fontBold)
  ed.layout.horizontalSortNode({
    self.ui.label_star,
    self.ui.icon_star,
    self.ui.label_star_num
  }, {
    3,
    3,
    0
  }, self.ui.label_title:getPositionX(), 0)
  self:refreshDraglist()
  self:findCanGetReward()
end

function SkillTowerRewardWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  self:listenEvent("SkillTowerStarRewardReply", function()
    self:refreshUI()
  end)
end

function SkillTowerRewardWin:destroy()
  base.destroy(self, {skipAnim = true})
  if self.callback then
    self.callback()
  end
end
