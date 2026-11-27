local base = ed.ui.popwindow
local GuildChangeFrameWin = newclass(base.mt)
ed.ui.GuildChangeFrameWin = GuildChangeFrameWin

function GuildChangeFrameWin.create(param)
  local self = base.create("GuildChangeFrameWin")
  setmetatable(self, GuildChangeFrameWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildChangeFrameWin:initData(param)
  self.callback = param.callback
  self.frame = ed.GuildManager.frame
end

function GuildChangeFrameWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v, x, y) then
        v:setScale(0.95)
        
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildChangeFrameWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    self.frame = v.data
    self:destroy()
  end
  
  return handler
end

function GuildChangeFrameWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function GuildChangeFrameWin:createItem(res, str)
  local frameIcon = ed.createSprite(res)
  local name = ed.createttf(str, 18)
  ed.setLabelColor(name, ed.toccc3(16776423))
  name:setPosition(ccp(frameIcon:getContentSize().width / 2 + 80, frameIcon:getContentSize().height / 2))
  frameIcon:addChild(name)
  name:setAnchorPoint(ccp(0, 0.5))
  return frameIcon
end

function GuildChangeFrameWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  self.frameData = ed.GuildManager.unlockIconFrames or {1}
  local guildFrameTb = ed.getDataTable("GuildAvatarFrame")
  for k, v in ipairs(self.frameData) do
    local frameItem = guildFrameTb[v]
    if not frameItem.Hide then
      local res = guildFrameTb[v].Picture
      local name = guildFrameTb[v].Name
      local ui = self:createItem(res, name)
      ui.data = v
      ui:setPosition(ccp(120, 330 - k * 100))
      self.draglist:addItem(ui)
      table.insert(uiList, ui)
    end
  end
  self.uiList = uiList
  self.draglist:initListHeight(100 * #self.frameData)
end

function GuildChangeFrameWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildHeadChangeWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setString(ui.title, T("\233\128\137\230\139\169\229\164\180\229\131\143\230\161\134"))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
end

function GuildChangeFrameWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
end

function GuildChangeFrameWin:destroy()
  if self.callback then
    self.callback(self.frame)
  end
  base.destroy(self)
end
