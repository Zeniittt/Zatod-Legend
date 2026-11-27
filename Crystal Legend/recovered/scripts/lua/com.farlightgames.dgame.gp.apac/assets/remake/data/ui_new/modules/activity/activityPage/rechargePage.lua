local rechargePage = {}
ed.ui.activityRechargePage = rechargePage

function rechargePage.create(base, param, pageKey)
  local this = {}
  setmetatable(rechargePage, {__index = base})
  setmetatable(this, {__index = rechargePage})
  local container, ui = ed.editorui(ed.uieditor.activity_recharge_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:setButtonClick()
  this:initItems(param)
  return this
end

function rechargePage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  local btnVis = true
  for i = 1, 3 do
    local tsk = task[i] or {}
    self.items[i]:update(tsk)
    if btnVis and (self.items[i].isFinished or self.items[i].isCompleted) then
      btnVis = false
    end
  end
  self.ui.ImageView_53:setVisible(btnVis)
end

local rechargeBox = {}

function rechargePage:initItems(param)
  self.ui.Label_52:setString(T("\229\137\169\228\189\153 %s", self.param.endTimeStr or 0))
  if self.param and self.param.openType then
    self.ui.ImageView_50:setVisible(self.param.openType ~= "Open Svr")
    self.ui.Label_52:setVisible(self.param.openType ~= "Open Svr")
  end
  local newWid = ed.display.winSize.width
  if 1024 <= newWid then
    ed.initSpriteWithFrame(self.ui.ImageView_46, "UI/alpha/1080P/activity/recharge_gift/recharge_gift_title_bg_2340.png")
  end
  self.ui.Label_52:setVisible(false)
  
  local function ClickFunc(item)
    return function()
      if item.isCompleted then
        self.objWork:activitySubmit(param._id, item.param._id)
      else
        ed.UITool.openView("packageDetail", {
          id = item.items.id,
          count = item.items.count,
          type = item.items.type
        })
      end
    end
  end
  
  local task = param._tasks
  local btnVis = true
  self.items = {}
  for i = 1, 3 do
    local tsk = task[i] or {}
    local item = rechargeBox.create(self.ui["gift_box_" .. i], tsk)
    self:btRegisterButtonClick({
      button = item.itemIcon,
      key = "itemIcon" .. i,
      force = true,
      mcpMode = true,
      pressScale = 0.96,
      clickHandler = ClickFunc(item)
    })
    self.items[i] = item
    if btnVis and (self.items[i].isFinished or self.items[i].isCompleted) then
      btnVis = false
    end
  end
  self.ui.ImageView_53:setVisible(btnVis)
  ed.setLabelStroke(self.ui.Label_54, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.Label_day_1, ed.toccc3(8727058), 1)
  ed.setLabelStroke(self.ui.Label_day_2, ed.toccc3(8727058), 1)
  ed.setLabelStroke(self.ui.Label_day_3, ed.toccc3(8727058), 1)
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(16355348), 1.5)
  ed.setLabelFontName(self.ui.label_tips, ed.fontBold)
  ed.setLabelShadow(self.ui.label_tips, ed.toccc3(12998677), ccp(0, 3))
  self.ui.label_tips:limitWidthByScale(340)
end

function rechargePage:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.ImageView_53,
    key = "gift_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "Diamonds"}))
      end
      self.objWork:setEnterHandler(self.param._id)
    end
  })
end

function rechargeBox.create(layer, param)
  local this = {}
  setmetatable(this, {__index = rechargeBox})
  this.layer = layer
  this.param = param
  this:initUi(param)
  return this
end

function rechargeBox:initUi(param)
  local items = {}
  for i, v in ipairs(param._rewards) do
    local data = v
    table.insert(items, {
      id = data._id,
      count = data._amount or 1,
      type = data._type or "item"
    })
  end
  self.items = items[1]
  local icon = ed.createItemIcon(items[1])
  icon:setPosition(60, 47)
  icon:setScale(1)
  self.layer:addChild(icon)
  self.itemIcon = icon
  local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
  eff:setPosition(60, 47)
  self.layer:addChild(eff, 9)
  self.itemEff = eff
  local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
  tick:setPosition(30, 25)
  tick:setVisible(false)
  icon:addChild(tick)
  self.tick = tick
  self:update(param)
end

function rechargeBox:update(param)
  self.param = param
  self.isCompleted = nil
  local str = ""
  local isCompleted = param._progress >= param._cond_target
  local isFinished = param._cur_reward_times and param._cur_reward_times >= param._max_reward_times
  if isFinished then
    self.tick:setVisible(true)
  elseif isCompleted then
    self.isCompleted = true
  end
  self.itemEff:setVisible(self.isCompleted)
  if self.isCompleted then
    self.itemEff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  else
    self.itemEff:stopAllActions()
  end
  self.isFinished = isFinished
end
