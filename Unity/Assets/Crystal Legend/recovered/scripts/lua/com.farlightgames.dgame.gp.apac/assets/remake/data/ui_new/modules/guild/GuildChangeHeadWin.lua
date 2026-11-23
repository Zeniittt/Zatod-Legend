local base = ed.ui.popwindow
local GuildChangeHeadWin = newclass(base.mt)
ed.ui.GuildChangeHeadWin = GuildChangeHeadWin

function GuildChangeHeadWin.create(param)
  local self = base.create("GuildChangeHeadWin")
  setmetatable(self, GuildChangeHeadWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildChangeHeadWin:initData(param)
  self.avatar = ed.GuildManager.avatar
  self.callback = param.callback
  local tb = ed.getDataTable("GuildAvatar")
  self.normalAvatar = {}
  for k, v in pairs(tb) do
    if type(k) == "number" and not v.Lock then
      table.insert(self.normalAvatar, k)
    end
  end
  table.sort(self.normalAvatar, function(a, b)
    return b <= a
  end)
end

function GuildChangeHeadWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon, x, y) then
        v:setScale(0.95)
        
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildChangeHeadWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.icon, x, y) then
      self.avatar = v.data
      self:destroy()
    end
  end
  
  return handler
end

function GuildChangeHeadWin:cancelPressInList()
  local function handler(x, y, v)
  end
  
  return handler
end

function GuildChangeHeadWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  
  local function getPos(i)
    local ox = -38
    local oy = self.ui.layer_item:getContentSize().height + 38
    local dx, dy = 80, 80
    local row = math.floor((i + 4) / 5)
    local col = (i - 1) % 5 + 1
    return ccp(ox + col * dx, oy - row * dy)
  end
  
  local avatarData = ed.GuildManager.unlockIconAvatars or {}
  for k, v in ipairs(self.normalAvatar) do
    local icon = ed.createGuildAvatar(v, 1)
    icon.data = v
    table.insert(uiList, icon)
    self.draglist:addItem(icon)
    icon:setPosition(getPos(k))
  end
  self.uiList = uiList
  self.draglist:initListHeight(80 * math.floor((#self.normalAvatar + #avatarData + 4) / 5))
end

function GuildChangeHeadWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildHeadChangeWin, {
    container = self.container,
    ui = self.ui
  })
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function GuildChangeHeadWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
end

function GuildChangeHeadWin:destroy()
  if self.callback then
    self.callback(self.avatar)
  end
  base.destroy(self)
end
