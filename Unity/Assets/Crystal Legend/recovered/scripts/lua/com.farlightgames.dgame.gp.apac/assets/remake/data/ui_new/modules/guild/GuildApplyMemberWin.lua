local base = ed.ui.popwindow
local GuildApplyMemberWin = newclass(base.mt)
ed.ui.GuildApplyMemberWin = GuildApplyMemberWin

function GuildApplyMemberWin.create()
  local self = base.create("GuildApplyMemberWin")
  setmetatable(self, GuildApplyMemberWin.mt)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function GuildApplyMemberWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.head, x, y) then
        v.head:setScale(0.6)
        
        return v
      end
      if ed.containsPoint(v.btn_unagree, x, y) then
        v.btn_unagree:setScale(0.9)
        return v
      end
      if ed.containsPoint(v.btn_agree, x, y) then
        v.btn_agree:setScale(0.9)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildApplyMemberWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.head, x, y) then
      self.curUI = v
      if self.delayOpen then
        return
      end
      ed.registerNetReply("req_home_page", function(data)
        local panel = ed.ui.PlayerInfoPanel.create(data, false)
        panel:popWindow()
        self.delayOpen = false
      end)
      ed.PlayerInfoNetwork:requestHomePage(v.data._user_summary._role_id)
      self.delayOpen = true
      return
    end
    if ed.containsPoint(v.btn_unagree, x, y) then
      self.curUI = v
      ed.GuildNetwork:sendConfirmJoinGuild("reject", v.data._uid)
      return
    end
    if ed.containsPoint(v.btn_agree, x, y) then
      if #ed.GuildManager.members < ed.GuildManager.maxMember then
        self.curUI = v
        ed.GuildNetwork:sendConfirmJoinGuild("accept", v.data._uid)
      else
        ed.showToast(T("\229\133\172\228\188\154\228\186\186\229\145\152\229\183\178\230\187\161"))
      end
    end
  end
  
  return handler
end

function GuildApplyMemberWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.head:setScale(0.65)
    v.btn_unagree:setScale(1)
    v.btn_agree:setScale(1)
  end
  
  return handler
end

function GuildApplyMemberWin:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildApplyItem)
  local param = {
    id = data._user_summary._avatar,
    level = data._user_summary._level,
    scale = 0.65,
    name = data._user_summary._name,
    no_name_bg = true
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "head", head)
  ui.head = headIcon
  return container, ui
end

function GuildApplyMemberWin:refreshDraglist()
  self.uiList = {}
  self.draglist:clearList()
  local data = ed.GuildManager.appliers or {}
  local size = self.ui.layer_item:getContentSize()
  local py, gapY = 75, 2
  local ox, oy = size.width / 2, size.height + py / 2
  
  local function getPos(i)
    return ccp(ox, oy - (py + gapY) * i)
  end
  
  for k, v in ipairs(data) do
    local container, ui = self:createItem(v)
    container:setPosition(getPos(k))
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
  end
  self.draglist:initListHeight((py + gapY) * #data)
end

function GuildApplyMemberWin:initLabels()
  ed.setLabelShadow(self.ui.num, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.member, ccc3(0, 0, 0), ccp(2, 0))
end

function GuildApplyMemberWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildApplyMemberWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.num, string.format("%d/%d", #ed.GuildManager.members, 50))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function GuildApplyMemberWin:registerEvents()
  self:listenEvent("GuildJoinConfirmReply", function(newPeople)
    local ui = self.curUI
    ui.btn_agree:setVisible(false)
    ui.btn_unagree:setVisible(false)
    ui.label_tip:setVisible(true)
    if newPeople then
      ed.showToast(T("\229\183\178\230\137\185\229\135\134\229\138\160\229\133\165"))
      ed.setString(ui.label_tip, T("\229\183\178\230\137\185\229\135\134\229\138\160\229\133\165"))
      ed.setLabelColor(ui.label_tip, ed.toccc3(7405396))
      ed.setLabelStroke(ui.label_tip, ed.toccc3(1519903), 1)
    else
      ed.showToast(T("\229\183\178\230\139\146\231\187\157\229\138\160\229\133\165"))
      ed.setString(ui.label_tip, T("\229\183\178\230\139\146\231\187\157\229\138\160\229\133\165"))
      ed.setLabelColor(ui.label_tip, ed.toccc3(16739436))
      ed.setLabelStroke(ui.label_tip, ed.toccc3(5577228), 1)
    end
    for k, v in ipairs(ed.GuildManager.appliers or {}) do
      if ui.data._uid == v._uid then
        table.remove(ed.GuildManager.appliers, k)
        break
      end
    end
  end)
end

function GuildApplyMemberWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
end
