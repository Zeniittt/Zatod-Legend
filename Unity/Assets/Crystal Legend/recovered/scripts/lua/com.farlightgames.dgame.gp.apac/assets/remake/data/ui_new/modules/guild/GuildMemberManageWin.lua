local base = ed.ui.popwindow
local GuildMemberManageWin = newclass(base.mt)
ed.ui.GuildMemberManageWin = GuildMemberManageWin

function GuildMemberManageWin.create()
  local self = base.create("GuildMemberManageWin")
  setmetatable(self, GuildMemberManageWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function GuildMemberManageWin:initData()
  self.tabIndex = 1
end

function GuildMemberManageWin:initLabels()
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label1, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label2, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label3, ccc3(0, 0, 0), ccp(1, 0))
  ed.adaptLabel(self.ui.label2, {maxWidth = 125, minScale = 0.7})
  ed.adaptLabel(self.ui.label3, {maxWidth = 125, minScale = 0.7})
  ed.right2(self.ui.num, self.ui.member, 0)
end

function GuildMemberManageWin:registerEvents()
  self:listenEvent("GuildMemberRefresh", function()
    ed.setString(self.ui.num, string.format("%d/%d", #ed.GuildManager.members, 50))
    self:refreshDraglist(true)
  end)
end

function GuildMemberManageWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildMemberManageWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function GuildMemberManageWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.bg, x, y) then
      if v.data._uid == ed.getUserid() then
        return
      elseif ed.player:getGuildJob() == "elder" and (v.data._job == "elder" or v.data._job == "chairman") then
        return
      end
      ed.ui.GuildMemberAppointWin.create({
        data = v.data
      })
    end
  end
  
  return handler
end

function GuildMemberManageWin:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildMemberItem1)
  local summary = data._summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.6,
    name = summary._name,
    no_name_bg = true
  }
  local head = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "icon", head)
  if data._job == "member" then
    ui.title:setVisible(false)
  elseif data._job == "chairman" then
    ed.setLabelStroke(ui.title, ed.toccc3(5586983), 1)
    ed.setLabelColor(ui.title, ed.toccc3(15492947))
    ed.setString(ui.title, T("\228\188\154\233\149\191"))
  elseif data._job == "elder" then
    ed.setLabelStroke(ui.title, ed.toccc3(5586983), 1)
    ed.setLabelColor(ui.title, ed.toccc3(13534950))
    ed.setString(ui.title, T("\233\149\191\232\128\129"))
  end
  local timeStr = T("\229\156\168\231\186\191")
  if data._is_online == 0 then
    local y, m, d, h, min, sec = ed.time2YMDHMS(data._last_login)
    local nowY, nowM, nowD = ed.time2YMDHMS(ed.getServerTime())
    local passSecond = ed.getServerTime() - data._last_login
    if d == nowD and passSecond < 86400 or data._last_login == 0 then
      timeStr = string.format(T("\228\187\138\230\151\165%02d:%02d"), h, min)
    else
      local days = math.floor(passSecond / 86400)
      timeStr = string.format(T("%d\229\164\169\229\137\141"), days)
    end
  end
  local str
  if self.tabIndex == 1 then
    str = string.format(T("<lable color=ccc3(87,65,48) strokeColor=onlineStr1 strokeSize=1>\230\156\128\229\144\142\228\184\138\231\186\191\230\151\182\233\151\180\239\188\154</lable>") .. "<lable color=ccc3(174,98,42) strokeColor=onlineStr1 strokeSize=1>%s</lable>", timeStr)
  elseif self.tabIndex == 2 then
    str = string.format(T("<lable color=ccc3(87,65,48) strokeColor=onlineStr1 strokeSize=1>\230\156\128\232\191\1457\230\151\165\232\180\161\231\140\174\239\188\154</lable>") .. "<lable color=ccc3(147,255,126) strokeColor=onlineStr2 strokeSize=1 fontSize=f16>%d </lable><lable color=ccc3(246,243,222) strokeColor=onlineStr2 strokeSize=1>" .. T("\230\180\187\232\183\131") .. "</lable>", data._active)
  else
    str = string.format(T("<lable color=ccc3(87,65,48) strokeColor=onlineStr1 strokeSize=1>\230\156\128\232\191\1457\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\239\188\154</lable>") .. "<lable color=ccc3(147,255,126) strokeColor=onlineStr2 strokeSize=1>%d</lable>", data._join_instance_time)
  end
  local info = ed.ui.autoText.new()
  info:initParam({
    context = str,
    fontSize = 14,
    maxWidth = 170,
    maxHeight = 16
  })
  ui.bg:addChild(info.node)
  ui.info:setVisible(false)
  local x, y = ui.info:getPosition()
  info.node:setPosition(ccp(x, y))
  return container, ui
end

function GuildMemberManageWin:refreshDraglist(oldY)
  self.uiList = {}
  local posX, posY = self.draglist:getListPos()
  self.draglist:clearList()
  local data = ed.GuildManager.members or {}
  if self.tabIndex == 1 then
    table.sort(data, function(a, b)
      return a._last_login > b._last_login
    end)
  elseif self.tabIndex == 2 then
    table.sort(data, function(a, b)
      return a._active > b._active
    end)
  elseif self.tabIndex == 3 then
    table.sort(data, function(a, b)
      return a._join_instance_time > b._join_instance_time
    end)
  end
  for k, v in ipairs(data) do
    local container, ui = self:createItem(v)
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(ccp(277, 262 - 62 * k))
  end
  if oldY then
    self.draglist:setListPos(ccp(posX, posY))
  end
  self.draglist:initListHeight(62 * #data)
end

function GuildMemberManageWin:refreshUI()
  self:refreshDraglist()
end

function GuildMemberManageWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMemberManageWin, {
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

function GuildMemberManageWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn1", function()
    if self.tabIndex == 1 then
      return
    end
    self.ui["btn_select" .. self.tabIndex]:setVisible(false)
    self.tabIndex = 1
    self.ui["btn_select" .. self.tabIndex]:setVisible(true)
    self:refreshUI()
  end, {clickInterval = 0.5})
  ed.UITool.registerBtn(self, "btn2", function()
    if self.tabIndex == 2 then
      return
    end
    self.ui["btn_select" .. self.tabIndex]:setVisible(false)
    self.tabIndex = 2
    self.ui["btn_select" .. self.tabIndex]:setVisible(true)
    self:refreshUI()
  end, {clickInterval = 0.5})
  ed.UITool.registerBtn(self, "btn3", function()
    if self.tabIndex == 3 then
      return
    end
    self.ui["btn_select" .. self.tabIndex]:setVisible(false)
    self.tabIndex = 3
    self.ui["btn_select" .. self.tabIndex]:setVisible(true)
    self:refreshUI()
  end, {clickInterval = 0.5})
end

function GuildMemberManageWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
