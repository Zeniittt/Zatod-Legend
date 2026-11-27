local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueCollectEventScene = class
ed.UITool.registViewOpenFunc("rogueCollectEventScene", function()
  local scene = ed.ui.rogueCollectEventScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("rogueCollectEventScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.eventDataList = {}
  self.rogueEventTB = ed.getDataTable("RogueEvent")
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCollectEventScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  self:initLabels()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\228\186\139\228\187\182"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.layout.relateLayout(titleTxt, self.ui.label_total_progress_tips, {
    right = titleTxt:getContentSize().width * 0.5 + 10
  })
  ed.layout.relateLayout(self.ui.label_total_progress_tips, self.ui.label_total_progress, {
    right = self.ui.label_total_progress_tips:getContentSize().width * 0.5 + 7 - self.ui.label_total_progress:getContentSize().width
  })
  self:adaptUI()
  self:initTableView()
end

function class:initLabels()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.eventDataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(286, 110)
    end,
    createCell = function(index)
      local eventData = self.eventDataList[index]
      local itemContainer, ui = self:createListItem(index, eventData)
      return itemContainer, {eventData = eventData, ui = ui}
    end,
    doClickIn = function(cell, x, y)
      local eventData = cell.data.eventData
      local ui = cell.data.ui
      local eventId = eventData.eventId
      local flag = eventData.flag
      if flag == nil then
        ed.showToast(T("\231\187\167\231\187\173\230\184\184\231\142\169\229\185\187\228\185\166\229\165\135\232\176\173\228\187\165\229\143\145\231\142\176\230\155\180\229\164\154\228\186\139\228\187\182"))
      elseif flag == 0 then
        ed.rogueLikeNet.sendViewEventReward(eventId)
      end
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 3,
    dragMode = 1,
    touchpriority = -300,
    padding = {width = 30, height = 0},
    noshade = true,
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width, size.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    }
  }
  self.tableView = Tableview.create(param)
  self:refreshTableView()
end

function class:createListItem(index, eventData)
  local container, ui = ed.editorui(ed.uieditor.rogueCollectEventItem)
  container:setContentSize(ui.image_bg:getContentSize())
  local eventId = eventData.eventId
  local flag = eventData.flag
  local eventCfg = self.rogueEventTB[eventId]
  ed.setLabelStroke(ui.label_event_name, ed.toccc3(3746837), 1)
  if flag then
    if flag == 1 then
      ui.btn_reward:setVisible(false)
      ui.image_done:setVisible(true)
    else
      ui.btn_reward:setVisible(true)
      ui.image_done:setVisible(false)
      ui.image_reward_light:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
    end
    ed.setString(ui.label_event_name, eventCfg.Title)
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/collect/collect_event_frame.png")
  else
    ui.btn_reward:setVisible(false)
    ui.image_done:setVisible(false)
    ed.setString(ui.label_event_name, T("\239\188\159\239\188\159\239\188\159"))
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/collect/collect_event_frame_unlock.png")
  end
  return container, ui
end

function class:refreshTableView(isHoldPos)
  self.eventDataList = {}
  for eventId, eventCfg in ipairs(self.rogueEventTB) do
    local flag = self.rogueLikeMgr:getEventRewardFlag(eventId)
    table.insert(self.eventDataList, {eventId = eventId, flag = flag})
  end
  table.sort(self.eventDataList, ed.cmpSort({
    {
      getValue = function(t)
        local flag = t.flag
        return flag and flag or 99
      end
    }
  }))
  if isHoldPos then
    local x, y = self.tableView:getListPos()
    self.tableView:reloadData()
    self.tableView:setListPos(ccp(x, y))
  else
    self.tableView:reloadData()
  end
  local viewEvent = self.rogueLikeMgr:getViewEvent() or {}
  ed.setLabelString(self.ui.label_total_progress, string.format("%s/%s", #viewEvent, #self.eventDataList))
end

function class:addTouchEvent()
end

function class:addEventListener()
  self:listenEvent("rogueViewEventReward", function()
    self:refreshTableView(true)
  end)
end
