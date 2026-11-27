local base = ed.ui.popwindow
local activityLotteryRewardPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("activityLotteryRewardPop", function(param)
  activityLotteryRewardPop.create(param or {}):popWindow()
end)

function activityLotteryRewardPop.create(param)
  return setmetatable(base.create("activityLotteryRewardPop"), activityLotteryRewardPop.mt):init(param or {})
end

function activityLotteryRewardPop:init(param)
  self.param = param
  self.uieditorLayer, self.ui = ed.editorui(ed.uieditor.activity_lottery_reward_pop)
  self.container:addChild(self.uieditorLayer)
  self.uieditorLayer:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  self:addEventListen()
  self:initView()
  self:listenEvent("activity_lottery_reply", function(info)
    self:viewRefresh(info)
  end)
  self:show({skipAnim = false})
  return self
end

function activityLotteryRewardPop:initView()
  if self.draglist then
    self.ui.list_layer:removeAllChildrenWithCleanup(true)
  end
  self.ui.label_collection:setString(T("\229\183\178\231\191\187\231\137\140\239\188\154%s", self.param.progress))
  local thisCon = self.ui.list_layer:getContentSize()
  self.draglist = ed.draglist.create({
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.list_layer,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end
  })
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:listRefresh()
end

function activityLotteryRewardPop:listRefresh()
  local thisCon = self.ui.list_layer:getContentSize()
  self.listItems = self.listItems or {}
  local height = 0
  for i, v in ipairs(self.param.lineReward or {}) do
    if self.listItems[i] then
      self.listItems[i]:refresh(v)
    else
      local item = self.itemMod.new(self, v)
      self.draglist:addItem(item.container, ccp(0, thisCon.height - i * 102 - 5))
      self.listItems[i] = item
      height = height + 102
    end
  end
  if height ~= 0 then
    self.draglist:initListHeight(height + 8)
  end
end

function activityLotteryRewardPop:viewRefresh(info)
  info = ed.copyProto(info)
  if info._open_panel then
    info = info._open_panel
    self.progress = info._progress
    self.ui.Label_count_item:setString(T("\229\183\178\231\187\143\231\130\185\229\135\187:%s", info._progress))
    self.ui.Label_coins:setString(info._coins)
  elseif info._open_card then
    info = info._open_card
    self.progress = self.progress + 1
    self.ui.Label_count_item:setString(T("\229\183\178\231\187\143\231\130\185\229\135\187:%s", self.progress))
  elseif info._line_reward then
    info = info._line_reward
    for i, v in ipairs(self.param.lineReward) do
      if info._index == v.progress then
        v.state = 3
        self:listRefresh()
        break
      end
    end
  end
end

function activityLotteryRewardPop:addEventListen()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_2999,
    key = "close_btn",
    clickInterval = 1,
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  self.itemTouchKey = {}
  
  function self:btRegisterButtonClickToListItems(param)
    self:btRegisterButtonClick({
      button = param.button,
      key = "touch_items_" .. param.index,
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.list_layer, x, y) then
          return
        end
        if self.touch then
          local data = param.data or {}
          ed.UITool.openView("packageDetail", data)
        end
      end,
      force = true,
      pressScale = 0.75,
      normalScale = 0.8
    })
    table.insert(self.itemTouchKey, "touch_items_" .. param.index)
  end
  
  function self:btRegisterButtonClickToListBtns(param)
    self:btRegisterButtonClick({
      button = param.button,
      key = "touch_btns_" .. param.index,
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.list_layer, x, y) then
          return
        end
        if self.touch then
          ed.activityHints.network:sendLotteryReq("_line_reward", {
            _reward_index = param.data.progress
          })
        end
      end,
      force = true,
      pressScale = 0.95,
      normalScale = 1
    })
    table.insert(self.itemTouchKey, "touch_btns_" .. param.index)
  end
  
  function self:removeItemTouchKey()
    for i, v in ipairs(self.itemTouchKey) do
      self:btRemoveMainTouchHandler({key = v})
    end
    self.itemTouchKey = {}
  end
end

local itemMod = {}

function itemMod.new(mainSelf, param)
  return setmetatable({mainSelf = mainSelf, param = param}, {__index = itemMod}):create()
end

function itemMod:create()
  self.container, self.ui = ed.editorui(ed.uieditor.activity_lottery_reward_pop_item)
  ed.setLabelStroke(self.ui.Label_3004, ed.toccc3(2037784), 1)
  ed.setLabelStroke(self.ui.Label_btn_ing, ed.toccc3(2037784), 1)
  local item = ed.taskItemModule.new(self.mainSelf, self.param.item, nil, self.param.index, false, false, true)
  item.icon:setPosition(ccp(387, 50))
  self.ui.Panel_3005:addChild(item.icon, 99)
  local labelKey = {
    "label_ing",
    "label_over",
    "label_available"
  }
  for i, v in ipairs(labelKey) do
    self.ui[v]:setString(T("\231\180\175\232\174\161\231\191\187\231\137\140 %s \230\172\161", self.param.progress))
    ed.setLabelStroke(self.ui[v], ed.toccc3(2037784), 1)
  end
  self.mainSelf:btRegisterButtonClickToListBtns({
    button = self.ui.Image_gift_btn,
    data = self.param,
    index = self.param.index
  })
  self.item = item
  self:refresh(self.param)
  return self
end

function itemMod:refresh(param)
  self.item:refresh(param.state - 1)
  local layerKey = {
    "Image_ing",
    "Image_available",
    "Image_over"
  }
  for i, v in ipairs(layerKey) do
    self.ui[v]:setVisible(i == param.state)
  end
  self.param = param
end

activityLotteryRewardPop.itemMod = itemMod
