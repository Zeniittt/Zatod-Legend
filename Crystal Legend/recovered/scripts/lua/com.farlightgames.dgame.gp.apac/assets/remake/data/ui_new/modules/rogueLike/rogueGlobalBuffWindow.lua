local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueGlobalBuffWindow = class
ed.UITool.registViewOpenFunc("rogueGlobalBuffWindow", function()
  ed.ui.rogueGlobalBuffWindow.create():popWindow()
end)

function class.create()
  local self = base.create("rogueGlobalBuffWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:initGlobalDesc()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueGlobalBuffWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
end

function class:initLabels()
end

function class:initGlobalDesc()
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local chapterId = curChapter._chapter_id
  local diff = curChapter._difficulty
  local context = ed.getDataTable("RogueChapter")[chapterId][diff]["Buff Des"]
  autoText:initParam({
    context = context,
    color = ed.toccc3(16710632),
    maxWidth = panelSize.width,
    fontSize = 18
  })
  self.ui.panel_desc:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(0, (panelSize.height + h) / 2 - 9))
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
end

function class:addEventListener()
end
