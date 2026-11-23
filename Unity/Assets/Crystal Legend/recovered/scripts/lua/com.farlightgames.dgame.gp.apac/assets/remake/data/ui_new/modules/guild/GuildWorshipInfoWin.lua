local base = ed.ui.popwindow
local GuildWorshipInfoWin = newclass(base.mt)
ed.ui.GuildWorshipInfoWin = GuildWorshipInfoWin

function GuildWorshipInfoWin.create()
  local self = base.create("GuildWorshipInfoWin")
  setmetatable(self, GuildWorshipInfoWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildWorshipInfoWin:initData()
end

function GuildWorshipInfoWin:initLabels()
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label1, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label2, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label3, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label4, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_time, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_gold, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelDimensions(self.ui.label1, CCSizeMake(420, 0))
  ed.setLabelDimensions(self.ui.label2, CCSizeMake(420, 0))
  self.ui.label2:setPositionY(self.ui.label1:getPositionY() - self.ui.label1:getContentSize().height * 0.5 - self.ui.label2:getContentSize().height * 0.5)
  self.ui.label_time:setPositionX(self.ui.label3:getContentSize().width + 0.5)
  self.ui.ImageView_16477:setPositionX(self.ui.label4:getContentSize().width + self.ui.ImageView_16477:getContentSize().width * 0.5)
  self.ui.label_gold:setPositionX(self.ui.ImageView_16477:getPositionX() + self.ui.ImageView_16477:getContentSize().width * 0.5 + 3)
end

function GuildWorshipInfoWin:refreshWorshipTimes()
  local vipLevel = ed.player:getvip()
  local worshipTimes = ed.getDataTable("VIP")[vipLevel]["Worship Times"]
  local leftTime = math.max(0, worshipTimes - ed.GuildManager.curWorshipTime)
  local str = string.format("%d/%d", leftTime, worshipTimes)
  ed.setString(self.ui.label_time, str)
end

function GuildWorshipInfoWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.GuildWorshipInfoWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:refreshWorshipTimes()
  ed.setString(self.ui.label_gold, ed.GuildManager.worshipGold)
end

function GuildWorshipInfoWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_get", function()
    if ed.GuildManager.worshipGold == 0 then
      ed.showToast(T("\230\154\130\230\151\160\229\143\175\233\162\134\229\143\150\229\165\150\229\138\177"))
      return
    end
    local msg = ed.upmsg.guild()
    msg._worship_withdraw = {}
    ed.send(msg, "guild")
    self:destroy()
  end, {pressScale = 0.9, clickInterval = 0.5})
end

function GuildWorshipInfoWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
