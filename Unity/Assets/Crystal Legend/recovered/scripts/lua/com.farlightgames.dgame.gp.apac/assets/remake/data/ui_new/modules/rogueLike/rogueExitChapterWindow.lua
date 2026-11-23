local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueExitChapterWindow = class
ed.UITool.registViewOpenFunc("rogueExitChapterWindow", function()
  ed.ui.rogueExitChapterWindow.create():popWindow()
end)

function class.create()
  local self = base.create("rogueExitChapterWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.curChapter = self.rogueLikeMgr:getCurChapter()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueExitChapterWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:refreshView()
  self:startCountDown()
end

function class:initLabels()
  ed.setLabelShadow(self.ui.label_diff, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_progress_tips, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_progress, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_left_time, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_left_time_tips, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_exit_tips, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_end, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_left, ed.toccc3(0), ccp(0, 2))
  self.ui.image_line_right:setScaleX(-1)
  self.ui.label_left_time_tips:limitWidthByScale(130)
end

function class:refreshView()
  local bgSize = self.ui.image_bg:getContentSize()
  local chapterId = self.curChapter._chapter_id
  local diff = self.curChapter._difficulty
  local chapterCfg = ed.getDataTable("RogueChapter")[chapterId][diff] or {}
  ed.setLabelString(self.ui.label_title, chapterCfg.Name or "")
  local diffCfg = {
    "I",
    "II",
    "III",
    "IV",
    "V"
  }
  ed.setLabelString(self.ui.label_diff, string.format(T("\233\154\190\229\186\166%s"), diffCfg[diff] or ""))
  local curWave = self.curChapter._cur_wave or 0
  local waves = self.curChapter._waves or {}
  local totalWave = waves[#waves]._wave_id or 0
  ed.setLabelString(self.ui.label_progress, string.format("%s/%s", curWave, totalWave))
  ed.layout.horizontalSortNode({
    self.ui.label_progress_tips,
    self.ui.label_progress
  }, {0}, bgSize.width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.image_left,
    self.ui.label_title,
    self.ui.image_line,
    self.ui.label_diff,
    self.ui.image_right
  }, {
    10,
    6,
    6,
    10
  }, bgSize.width * 0.5)
end

function class:startCountDown()
  self:refreshLeftTime()
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local endTime = self.curChapter._end_time
  local leftTime = endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local sec = leftTime % 60
  self.ui.label_left_time:setString((string.format(T("%.2d:%.2d:%.2d"), hour, min, sec)))
end

function class:onClickBtnEnd()
  ed.rogueLikeNet.sendExitChapter()
end

function class:onClickBtnLeave()
  ed.popScene()
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_end", function()
    self:onClickBtnEnd()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_left", function()
    self:onClickBtnLeave()
  end, {pressScale = 0.95})
end

function class:addEventListener()
end
