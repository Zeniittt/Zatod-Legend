local base = ed.ui.popwindow
local activityBbgsPop = newclass(base.mt)
ed.ui.activityBbgsPop = activityBbgsPop
ed.UITool.registViewOpenFunc("activityBbgsPop", function(param)
  ed.ui.activityBbgsPop.create(param or {}):popWindow()
end)

function activityBbgsPop.create(param)
  return setmetatable(base.create("activityBbgsPop"), activityBbgsPop.mt):init(param or {})
end

function activityBbgsPop:init(param)
  self.param = param
  self:editorui()
  self:initView()
  self:addEventListen()
  self:show({skipAnim = false})
  return self
end

function activityBbgsPop:editorui()
  local ui = {}
  local width, height = 696, 410
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/com_new_3.png",
    pos = ccp(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight),
    parent = self.container,
    scale = 1,
    rectMake = CCRectMake(8, 8, 37, 37),
    sizeMake = CCSizeMake(width, height)
  })
  ui.close = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt_bj.png",
    pos = ccp(width - 10, height - 10),
    parent = ui.bg,
    scale = 0.85
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/butt_off.png",
    pos = ccp(28, 28),
    parent = ui.close
  })
  local selfItem = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/bubugaosheng/bg_4.png",
    pos = ccp(width / 2, height - 62),
    parent = ui.bg
  })
  local hand = ed.getTeamHead({
    id = ed.player:getAvatar()
  })
  selfItem:addChild(hand)
  hand:setPosition(95, 42.5)
  hand:setScale(0.65)
  local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
    notClick = true,
    anchorPoint = ccp(0, 0.5)
  })
  name:setPosition(134, 54.5)
  selfItem:addChild(name)
  ed.createLabelTools({
    txt = tostring(game_server_name),
    size = 15,
    pos = ccp(134, 30.5),
    color = ed.toccc3(16773256),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = selfItem,
    anchor = ccp(0, 0.5)
  })
  ed.createLabelTools({
    txt = T("\231\180\175\232\174\161\230\156\128\233\171\152\228\188\164\229\174\179\239\188\154"),
    size = 19,
    pos = ccp(340, 42.5),
    color = ed.toccc3(16776423),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = selfItem,
    anchor = ccp(0, 0.5)
  })
  ui.selfItem = selfItem
  ui.itemLayer = ed.createCCLayer({
    pos = ccp(15, 15),
    sizeMake = CCSizeMake(width - 30, height - 130),
    parent = ui.bg
  })
  self.ui = ui
end

function activityBbgsPop:initView()
  local ui = self.ui
  local param = self.param
  local text = ed.getNumberNode({
    text = param._total_damage,
    folder = "peak_score"
  }).node
  text:setPosition(465, 42.5)
  text:setAnchorPoint(ccp(0, 0.5))
  ui.selfItem:addChild(text)
  text:setScale(0.7)
  local thisCon = ui.itemLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = ui.itemLayer,
    priority = -300,
    noshade = true,
    zorder = 10
  }
  self.dragList = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  if param._records then
    self.items = {}
    local data = param._records
    local index = 1
    ed.timeSchedule(ui.itemLayer, function()
      if not data[index] then
        ui.itemLayer:stopAllActions()
        self.listOver = true
        return
      end
      local item = self.itemBox.create(self, data[index], index)
      self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2, thisCon.height - index * 78 + 33))
      table.insert(self.items, item)
      index = index + 1
    end, 0.02)
    self.dragList:initListHeight(#data * 78 + 10)
  end
end

function activityBbgsPop:addEventListen()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.close,
    key = "close",
    clickInterval = 1,
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true,
    pressScale = 0.8,
    normalScale = 0.85
  })
end

local itemBox = {}

function itemBox.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemBox})
  this:initUi(param)
  return this
end

function itemBox:initUi(param)
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/bubugaosheng/bg_5.png",
    pos = ccp(0, 0)
  })
  local time = ed.getYMDHMS(param._time)
  ed.createLabelTools({
    txt = T("%s\230\156\136%s\230\151\165", time.month, time.day),
    size = 19,
    pos = ccp(65, 36.75),
    color = ed.toccc3(16776423),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = bg
  })
  for i, v in ipairs(param._heroes) do
    local icon = ed.readhero.createIconByServer(v).icon
    icon:setPosition(100 + i * 60, 36.75)
    bg:addChild(icon)
    icon:setScale(0.7)
  end
  ed.createLabelTools({
    txt = T("\230\156\128\233\171\152\228\188\164\229\174\179\239\188\154"),
    size = 19,
    pos = ccp(488, 36.75),
    color = ed.toccc3(16776423),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = bg
  })
  ed.createLabelTools({
    txt = param._damage,
    size = 19,
    pos = ccp(527, 36.75),
    color = ed.toccc3(16768885),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    },
    parent = bg,
    anchor = ccp(0, 0.5)
  })
  self.ui = {bg = bg}
end

activityBbgsPop.itemBox = itemBox
