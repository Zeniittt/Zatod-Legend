local base = ed.ui.popwindow
local KingsPvpFindOppoWin = newclass(base.mt)
ed.ui.KingsPvpFindOppoWin = KingsPvpFindOppoWin

function KingsPvpFindOppoWin.create(param)
  local self = base.create("KingsPvpFindOppoWin")
  setmetatable(self, KingsPvpFindOppoWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function KingsPvpFindOppoWin.close(param)
  local window = ed.getPopWindow("KingsPvpFindOppoWin")
  if window then
    window:destroy(param)
  end
end

function KingsPvpFindOppoWin:initData(param)
  param = param or {}
  local hostInfo = param.hostInfo
  local guestInfo = param.guestInfo
  self.hostServerName = hostInfo._server_name
  self.hostUserSummary = hostInfo._summary
  self.hostRankInfo = hostInfo._rank_info
  self.guestServerName = guestInfo._server_name
  self.guestUserSummary = guestInfo._summary
  self.guestRankInfo = guestInfo._rank_info
end

function KingsPvpFindOppoWin:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4594194), 1.5)
  ed.setLabelStroke(self.ui.label_guild_tips_blue, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_server_tips_blue, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_guild_blue, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_server_blue, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_guild_tips_red, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_server_tips_red, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_guild_red, ed.toccc3(4271123), 1)
  ed.setLabelStroke(self.ui.label_server_red, ed.toccc3(4271123), 1)
end

function KingsPvpFindOppoWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.KingsFindOppoWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initPlayerInfo()
end

function KingsPvpFindOppoWin:initPlayerInfo()
  ed.setString(self.ui.label_server_blue, self.hostServerName)
  ed.setString(self.ui.label_guild_blue, self.hostUserSummary._guild_name or T("\230\151\160"))
  local nameBlue = ed.getPlayerName(self.hostUserSummary._name, self.hostUserSummary._medal, {
    anchorPoint = ccp(0.5, 0.5),
    fontSize = 24
  })
  self.ui.bg:addChild(nameBlue, 3)
  nameBlue:setPosition(self.ui.bg_name_blue:getPosition())
  local headBlue = ed.getWholeHeadIcon({
    id = self.hostUserSummary._avatar
  })
  self.ui.panel_head_blue:addChild(headBlue)
  ed.layout.centerInParent(headBlue)
  local blueIconPath = ed.realarena.mgr:getGradeIconPath({
    score = self.hostRankInfo._score
  })
  ed.setTexture(self.ui.grade_icon_blue, blueIconPath, true)
  ed.setString(self.ui.label_server_red, self.guestServerName)
  ed.setString(self.ui.label_guild_red, self.guestUserSummary._guild_name or T("\230\151\160"))
  local nameRed = ed.getPlayerName(self.guestUserSummary._name, self.guestUserSummary._medal, {
    anchorPoint = ccp(0.5, 0.5),
    fontSize = 24
  })
  self.ui.bg:addChild(nameRed, 3)
  nameRed:setPosition(self.ui.bg_name_red:getPosition())
  local headRed = ed.getWholeHeadIcon({
    id = self.guestUserSummary._avatar
  })
  self.ui.panel_head_red:addChild(headRed)
  ed.layout.centerInParent(headRed)
  local redIconPath = ed.realarena.mgr:getGradeIconPath({
    score = self.guestRankInfo._score
  })
  ed.setTexture(self.ui.grade_icon_red, redIconPath, true)
end

function KingsPvpFindOppoWin:registerEvents()
  self:listenEvent("RealPVPOpponentLost", function()
    ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\230\150\173\229\188\128\232\191\158\230\142\165"))
    self:destroy({skipAnim = true})
  end)
end

function KingsPvpFindOppoWin:registerTouchHandlers()
end
