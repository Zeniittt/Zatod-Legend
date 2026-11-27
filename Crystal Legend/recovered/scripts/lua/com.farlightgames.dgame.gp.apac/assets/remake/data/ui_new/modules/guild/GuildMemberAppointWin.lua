local base = ed.ui.popwindow
local GuildMemberAppointWin = newclass(base.mt)
ed.ui.GuildMemberAppointWin = GuildMemberAppointWin

function GuildMemberAppointWin.create(param)
  local self = base.create("GuildMemberAppointWin", {priority = -302})
  setmetatable(self, GuildMemberAppointWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildMemberAppointWin:initData(param)
  self.data = param.data
  ed.GuildManager.selectMemberId = self.data._uid
end

function GuildMemberAppointWin:initLabels()
  ed.setLabelShadow(self.ui.label_elder, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_chairman, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_out, ccc3(0, 0, 0), ccp(2, 0))
  ed.adaptLabel(self.ui.label_elder, {maxWidth = 90, minScale = 0.7})
  ed.adaptLabel(self.ui.label_chairman, {maxWidth = 90, minScale = 0.7})
  ed.adaptLabel(self.ui.label_out, {maxWidth = 90, minScale = 0.7})
  self.ui.label_elder:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.label_chairman:setHorizontalAlignment(kCCTextAlignmentCenter)
end

function GuildMemberAppointWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMemberAppointWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local summary = self.data._summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.6,
    name = summary._name,
    no_name_bg = true
  }
  local head = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "avatar", head)
  self.ui.label_monthcard:setVisible(false)
  if ed.player:getGuildJob() == "chairman" then
    if self.data._job == "elder" then
      ed.setString(self.ui.label_elder, T("\230\146\164\233\148\128\233\149\191\232\128\129"))
    end
  else
    self.ui.btn_elder:setVisible(false)
    self.ui.btn_chairman:setVisible(false)
  end
end

function GuildMemberAppointWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_elder", function()
    local str = string.format(T("\231\161\174\229\174\154\229\176\134%s\230\143\144\229\141\135\228\184\186\233\149\191\232\128\129\239\188\159"), self.data._summary._name)
    if self.data._job == "elder" then
      str = string.format(T("\231\161\174\229\174\154\229\176\134%s\230\146\164\233\148\128\228\184\186\230\136\144\229\145\152\239\188\159"), self.data._summary._name)
    end
    ed.GuildManager.jobChange = self.data._job == "elder" and "member" or "elder"
    local info = {
      text = str,
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        local msg = ed.upmsg.guild()
        msg._set_job = {}
        msg._set_job._uid = self.data._summary._uid
        msg._set_job._job = ed.GuildManager.jobChange
        ed.send(msg, "guild")
        self:destroy()
      end
    }
    ed.showConfirmDialog(info)
  end, {pressScale = 0.9, clickInterval = 0.5})
  ed.UITool.registerBtn(self, "btn_chairman", function()
    ed.GuildManager.jobChange = "chairman"
    local info = {
      text = T("\231\161\174\229\174\154\229\176\134%s\230\143\144\229\141\135\228\184\186\228\188\154\233\149\191\239\188\159", self.data._summary._name),
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        local msg = ed.upmsg.guild()
        msg._set_job = {}
        msg._set_job._uid = self.data._summary._uid
        msg._set_job._job = "chairman"
        ed.send(msg, "guild")
        self:destroy()
      end
    }
    ed.showConfirmDialog(info)
  end, {pressScale = 0.9, clickInterval = 0.5})
  ed.UITool.registerBtn(self, "btn_out", function()
    local cardText = T("\231\161\174\229\174\154\229\176\134%s\232\184\162\229\135\186\229\133\172\228\188\154\239\188\159\228\187\150\229\176\134\229\156\1681\229\176\143\230\151\182\228\185\139\229\134\133\230\151\160\230\179\149\229\138\160\229\133\165\228\187\187\228\189\149\229\133\172\228\188\154\239\188\14048\229\176\143\230\151\182\229\134\133\230\151\160\230\179\149\229\155\158\229\136\176\230\156\172\229\133\172\228\188\154\227\128\130", self.data._summary._name)
    local info = {
      text = cardText,
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        if self.data._job == "elder" then
          local info = {
            text = T("\232\175\165\231\142\169\229\174\182\228\184\186\233\149\191\232\128\129\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\232\184\162\229\135\186\229\133\172\228\188\154"),
            leftText = T("\229\143\150\230\182\136"),
            rightText = T("\231\161\174\229\174\154"),
            rightHandler = function()
              local msg = ed.upmsg.guild()
              msg._kick = {}
              msg._kick._uid = self.data._summary._uid
              ed.GuildNetwork.kickId = self.data._summary._uid
              ed.send(msg, "guild")
            end
          }
          ed.showConfirmDialog(info)
        else
          local msg = ed.upmsg.guild()
          msg._kick = {}
          msg._kick._uid = self.data._summary._uid
          ed.GuildNetwork.kickId = self.data._summary._uid
          ed.send(msg, "guild")
        end
        self:destroy()
      end
    }
    ed.showConfirmDialog(info)
  end, {pressScale = 0.9, clickInterval = 0.5})
end

function GuildMemberAppointWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
