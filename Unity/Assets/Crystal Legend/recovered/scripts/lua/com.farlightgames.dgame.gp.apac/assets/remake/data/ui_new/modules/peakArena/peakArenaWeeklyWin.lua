local base = ed.ui.popwindow
local peakArenaWeeklyWin = newclass(base.mt)
ed.ui.peakArenaWeeklyWin = peakArenaWeeklyWin

function peakArenaWeeklyWin:initData(params)
  self.mgr = ed.PeakArenaManager
  local data = self.mgr.tallyResult
  self.grade = data._grade
  self.score = data._score
  self.coin = data._coin
  self.zoneRank = data._zone_rank
  self.destroyCallback = params.callback
end

function peakArenaWeeklyWin:initLabels()
  ed.setLabelShadow(self.ui.Label_896, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(self.ui.Label_4141, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.Label_4141_Copy0, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.Label_4141_Copy1, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.Label_4141_Copy2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.Label_4150_Copy0, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.Label_4150, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.Label_4149, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(11821085), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
end

function peakArenaWeeklyWin:initUI()
  ed.editorui(ed.uieditor.PeakArenaWeeklyWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  if self.coin and self.coin > 0 then
    ed.setString(self.ui.Label_4150_Copy0, self.coin)
  else
    self.ui.Label_4141_Copy1:setVisible(false)
    self.ui.Label_4150_Copy0:setVisible(false)
    self.ui.ImageView_4153:setVisible(false)
    self.ui.Label_4141:setPositionY(self.ui.Label_4141:getPositionY() - 20)
    self.ui.ImageView_4145:setPositionY(self.ui.ImageView_4145:getPositionY() - 20)
    self.ui.ImageView_4146:setPositionY(self.ui.ImageView_4146:getPositionY() - 20)
    self.ui.Label_4141_Copy0:setPositionY(self.ui.Label_4141_Copy0:getPositionY() - 20)
    self.ui.Label_4150_Copy1:setPositionY(self.ui.Label_4150_Copy1:getPositionY() - 20)
    self.ui.Label_4141_Copy2:setPositionY(self.ui.Label_4141_Copy2:getPositionY() + 20)
    self.ui.Label_4150:setPositionY(self.ui.Label_4150:getPositionY() + 20)
    local state = ed.PeakArenaManager:getState()
    if state and state == "playoffs" then
      self.ui.Label_4149:setString(T("\229\189\147\229\137\141\229\164\132\228\186\142\228\188\145\233\151\178\232\181\155"))
    end
  end
  local iconRes = self.mgr:getGradeIconRes(self.grade)
  local nameRes = self.mgr:getGradeTextRes(self.grade)
  ed.setTexture(self.ui.ImageView_4145, iconRes)
  ed.setTexture(self.ui.ImageView_4146, nameRes)
  local numberNode = ed.getNumberNode({
    text = self.score,
    folder = "peak_score",
    scale = 0.5,
    anchor = ccp(0, 1)
  }).node
  ed.UITool.replaceUI(self.ui, "bg1", "Label_4150_Copy1", numberNode)
  if self.zoneRank and 0 < self.zoneRank then
    ed.setString(self.ui.Label_4150, self.zoneRank)
  else
    self.ui.Label_4150:setVisible(false)
    self.ui.Label_4141_Copy2:setVisible(false)
  end
  ed.layout.horizontalSortNode({
    self.ui.Label_4141_Copy1,
    self.ui.Label_4150_Copy0,
    self.ui.ImageView_4153
  }, {
    17,
    3.5,
    0
  }, self.ui.Label_4141_Copy1:getPositionX(), 0)
  ed.layout.horizontalSortNode({
    self.ui.Label_4141,
    self.ui.ImageView_4145,
    self.ui.ImageView_4146
  }, {
    11,
    -13,
    0
  }, self.ui.Label_4141:getPositionX(), 0)
  ed.layout.horizontalSortNode({
    self.ui.Label_4141_Copy0,
    self.ui.Label_4150_Copy1
  }, {17, 0}, self.ui.Label_4141_Copy0:getPositionX(), 0)
  ed.layout.horizontalSortNode({
    self.ui.Label_4141_Copy2,
    self.ui.Label_4150
  }, {17, 0}, self.ui.Label_4141_Copy2:getPositionX(), 0)
end

function peakArenaWeeklyWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.66, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:destroy()
  end, {pressScale = 0.9})
end

function peakArenaWeeklyWin.create(params)
  local self = base.create("peakArenaWeeklyWin", {notBlurBg = true})
  setmetatable(self, peakArenaWeeklyWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  self:popWindow()
  if self.coin and self.coin > 0 then
    FireEvent("ResourceNumChange", "PeakArenaPoint")
  end
  self.mgr.tallyResult = nil
  return self
end
