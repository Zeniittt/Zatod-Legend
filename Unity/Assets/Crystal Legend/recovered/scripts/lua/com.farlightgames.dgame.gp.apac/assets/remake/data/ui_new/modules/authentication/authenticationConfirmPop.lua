local base = ed.ui.popwindow
local authenticationConfirmPop = {}
authenticationConfirmPop.__index = authenticationConfirmPop
setmetatable(authenticationConfirmPop, base.mt)
ed.ui.authenticationConfirmPop = authenticationConfirmPop

function authenticationConfirmPop.create(params)
  local self = base.create("authenticationConfirmPop")
  setmetatable(self, authenticationConfirmPop)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:registerListener()
  return self
end

function authenticationConfirmPop:initData(params)
  self.isAuth = params.status == "authentication"
  self.params = params
end

function authenticationConfirmPop:initUI()
  local container, ui = ed.editorui(ed.uieditor.authenticationConfirmPop)
  self.container:addChild(container)
  self.ui = ui
  local winSize = ed.display.winSize
  container:setPosition(ccp(480, 260))
  ed.setLabelString(self.ui.Label_18820, self.isAuth and T("\230\130\168\229\183\178\229\174\140\230\136\144\232\174\164\232\175\129") or T("\232\175\183\229\134\141\230\172\161\231\161\174\232\174\164\230\130\168\231\154\132\232\180\166\229\143\183\228\191\161\230\129\175"))
  self.ui.btn_confirm:setVisible(not self.isAuth)
  self.ui.name1:setVisible(self.isAuth)
  self.ui.name2:setVisible(self.isAuth)
  self.ui.btn_close:setVisible(self.isAuth)
  local serverInfo = self.params.serverInfo
  ed.setLabelString(self.ui.server2, serverInfo._server_display_id .. " " .. serverInfo._server_name)
  ed.setLabelString(self.ui.userid2, self.params.playerId)
  if self.isAuth then
    ed.setLabelString(self.ui.name2, self.params.playerName)
  else
    ed.setLabelString(self.ui.label_confirm, T("\231\161\174\232\174\164\230\151\160\232\175\175(%s)", 5))
    local posX, posY = self.ui.label_confirm:getPosition()
    self.ui.label_confirm:setPosition(ccp(posX * 0.75, posY * 0.75))
    local cnt = 4
    self:listenTimer(Timer:Times(1, 5), function()
      if 0 < cnt then
        ed.setLabelString(self.ui.label_confirm, T("\231\161\174\232\174\164\230\151\160\232\175\175(%s)", cnt))
      else
        ed.setLabelString(self.ui.label_confirm, T("\231\161\174\232\174\164\230\151\160\232\175\175"))
        self.canConfirm = true
      end
      cnt = cnt - 1
    end)
  end
end

function authenticationConfirmPop:registerTouchHandlers()
  if self.isAuth then
    ed.UITool.registerBtn(self, "btn_close", function()
      self:destroy()
    end, {normalScale = 0.75, pressScale = 0.7})
  else
    ed.UITool.registerBtn(self, "btn_confirm", function()
      if self.canConfirm then
        ed.authenticationNet:sendGetCode(self.params.playerId)
      end
    end, {normalScale = 1, pressScale = 0.95})
    self:btRegisterOutClick({
      area = self.ui.bg,
      key = "out_click",
      clickHandler = function()
        self:destroy()
      end,
      force = true
    })
  end
end

function authenticationConfirmPop:registerListener()
  self:listenEvent("PlayerShiftGetCodeReply", function(result)
    if result ~= "success" then
      ed.showToast(T("\229\143\145\233\128\129\233\170\140\232\175\129\231\160\129\229\164\177\232\180\165\239\188\129"))
    else
      ed.showToast(T("\229\183\178\229\143\145\233\128\129\233\170\140\232\175\129\231\160\129"))
      self.params.controller:handleGetCode()
    end
    ed.authenticationMgr.nextSendCodeTime = ed.getServerTime() + 3600
    self:destroy()
  end)
end
