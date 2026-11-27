local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.GuildMountChangeActorWin = class

function class:initData(param)
  self.selectTid = param and param.selectTid or ed.GuildMountManager:getDisplayTid()
end

function class:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local data = v.info
    self.selectTid = data.id
    self.selectIcon:setPosition(ccp(v.icon:getPosition()))
  end
  
  return handler
end

function class:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon, x, y) then
        v.icon:setScale(0.95)
        
        return v
      end
    end
    return nil
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.icon:setScale(1)
  end
  
  return handler
end

function class:initUI(param)
  ed.editorui(ed.uieditor.GuildMountChangeActorWin, {
    container = self.container,
    ui = self.ui
  })
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
  local tip = ed.ui.autoText.new()
  tip:initParam({
    context = param and param.txt or T("\229\143\175\229\185\187\229\140\150\230\136\144\228\187\187\230\132\143\228\184\128\228\184\170<lable color=ccc3(255,219,124)>\229\183\178\230\139\165\230\156\137</lable>\232\139\177\233\155\132"),
    color = ed.toccc3(16710632),
    fontSize = 16
  })
  ed.UITool.replaceUINew(self.ui, "Label_2931", tip.node)
  self.ui.Label_2931:setPositionX(self.ui.Label_2931:getPositionX() - tip:getCurContentSize() / 2)
  if param and param.btnTxt then
    self.ui.btn_ok_label:setString(param.btnTxt)
  end
end

function class:refreshDraglist()
  local listData = ed.readhero.classify("prepare", "position", nil, nil, true)
  local dx, dy = 50, 90
  local contentSize = self.ui.layer_item:getContentSize()
  local ncol = 6
  local offsetX = (contentSize.width - dx * ncol) / (ncol + 1)
  local ox, oy = 25 + offsetX, contentSize.height - 42
  local maxRow = 1
  
  local function getPos(index)
    local col = (index - 1) % ncol
    local row = math.floor((index - 1) / ncol)
    maxRow = math.max(maxRow, row + 1)
    return ccp(ox + col * (dx + offsetX), oy - dy * row)
  end
  
  local selectIcon = ed.createSprite("UI/alpha/1080P/guildmount/changehero_selected.png")
  local tick = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
  tick:setScale(0.6)
  tick:setPosition(ccp(65, 25))
  selectIcon:addChild(tick)
  self.draglist:addItem(selectIcon)
  selectIcon:setZOrder(2)
  self.selectIcon = selectIcon
  self.uiList = {}
  table.sort(listData, function(a, b)
    return a._gs > b._gs
  end)
  for k, v in ipairs(listData) do
    local headIcon = ed.readhero.createIconByID(v._tid, {state = "idle"})
    headIcon.icon:setPosition(getPos(k))
    if v._tid == self.selectTid then
      selectIcon:setPosition(getPos(k))
    end
    self.draglist:addItem(headIcon.icon)
    table.insert(self.uiList, headIcon)
  end
  self.draglist:initListHeight(dy * maxRow)
end

function class:registerEvents()
  self:listenEvent("GuildMountChangeDisplaySuccess", function()
    self:destroy()
  end)
  self:listenEvent("collection_point_reply_show", function()
    self:destroy()
  end)
end

function class:registerTouchEvents(param)
  local callBack = param and param.callBack
  ed.UITool.registerBtn(self, "btn_ok", function()
    if callBack then
      callBack(self.selectTid)
    elseif self.selectTid ~= ed.GuildMountManager:getDisplayTid() then
      ed.GuildMountNetwork:sendChangeDisplay(self.selectTid)
    else
      self:destroy()
    end
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:destroy()
    end,
    priority = -1
  })
end

function class.create(param)
  local self = base.create("GuildMountChangeActorWin")
  setmetatable(self, class.mt)
  self:initData(param)
  self:initUI(param)
  self:registerEvents()
  self:registerTouchEvents(param)
  self:popWindow()
  self:show()
  return self
end
