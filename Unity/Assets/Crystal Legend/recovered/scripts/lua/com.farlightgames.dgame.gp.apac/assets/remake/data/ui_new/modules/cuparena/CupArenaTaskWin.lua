local base = ed.ui.popwindow
local CupArenaTaskWin = newclass(base.mt)
ed.ui.CupArenaTaskWin = CupArenaTaskWin

function CupArenaTaskWin.create(data)
  local self = base.create("CupArenaTaskWin")
  setmetatable(self, CupArenaTaskWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function CupArenaTaskWin:initData(data)
  self.data = data
end

function CupArenaTaskWin:initUI()
  ed.editorui(ed.uieditor.CupArenaTaskWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(16182488), 1.5)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  self:initDraglist()
end

function CupArenaTaskWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.65, normalScale = 0.7})
end

function CupArenaTaskWin:registerEvents()
  self:listenEvent("EventCupArenaFreshTask", function(data)
    self:initData(data)
    self:initDraglist()
  end)
  self:listenEvent("DailyJobBoxGot", function(data)
    ed.CupArenaNetwork:sendOpenTask(false)
  end)
  self:registerOnEnterHandler("onEnter", function()
    ed.CupArenaNetwork:sendOpenTask(false)
  end)
end

function CupArenaTaskWin:createTaskItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.CupArenaTaskItem)
  container:setContentSize(ui.bg:getContentSize())
  local autoText = ed.ui.autoText.new()
  ui.bg:addChild(autoText.node)
  ui.desLabel = autoText
  ed.setLabelStroke(ui.label_medal, ed.toccc3(1381132), 1)
  ed.setLabelStroke(ui.label_go, ed.toccc3(11033137), 1)
  ed.setLabelStroke(ui.label_done, ed.toccc3(539671), 1)
  ed.layout.horizontalSortNode({
    ui.label_done,
    ui.img_done
  }, {2, 0}, ui.bg_done:getContentSize().width * 0.5 + 4)
  local touchKey = "task_go_" .. index
  self:btRemoveMainTouchHandler({key = touchKey})
  self:btRegisterButtonClick({
    button = ui.btn_go,
    key = touchKey,
    pressScale = 0.95,
    clickHandler = function()
      self:onJumpEvent(index)
    end
  })
  self:refreshTaskItem(ui, data)
  return container, ui
end

function CupArenaTaskWin:refreshTaskItem(ui, data)
  local taskTable = ed.getDataTable("CupArenaTask")[data._id]
  local desStr = string.format(taskTable["Task Display"], string.format("<lable color=ccc3(255,190,51) strokeColor=0x4E2C1A strokeSize=1>%d/%d</lable>", data._progress, taskTable["Task Target"]))
  ui.desLabel:initParam({
    context = desStr,
    fontSize = 15,
    maxWidth = 150,
    color = ed.toccc3(3551023)
  })
  local desWidth, desHeight = ui.desLabel:getCurContentSize()
  local bgSize = ui.bg:getContentSize()
  ui.desLabel.node:setPosition(ccp((bgSize.width - desWidth) * 0.5, bgSize.height * 0.5 + 15 - ui.desLabel:getFirstLineHeight()))
  ed.setLabelString(ui.label_medal, string.format("+%d", taskTable["Reward Medal"]))
  local isComplete = data._has_completed == 1
  ui.btn_go:setVisible(not isComplete)
  ui.bg_done:setVisible(isComplete)
  local campTableItem = ed.getDataTable("CupArenaCamp")[ed.CupArenaManager:getCampId()]
  ed.setTexture(ui.img_camp, campTableItem["Camp Symbol"])
end

function CupArenaTaskWin:getPos(i)
  local size = self.ui.panel_task:getContentSize()
  local ox = size.width
  local oy = size.height / 2
  local itemWidth = 217
  local itemSpace = 20
  local dx = (i - 0.5) * itemWidth + (i - 1) * itemSpace
  return ccp(dx, oy)
end

function CupArenaTaskWin:getWidth(num)
  local itemWidth = 217
  local itemSpace = 20
  return (itemWidth + itemSpace) * num - itemSpace
end

function CupArenaTaskWin:initDraglist()
  if nil == self.ui.taskDraglist then
    self.ui.taskDraglist = ed.UITool.createDraglist(self.ui.panel_task, {priority = -300})
  else
    self.ui.taskDraglist:clearList()
  end
  local taskNum = 0
  for i, v in ipairs(self.data._task_list) do
    local itemContainer, itemUI = self:createTaskItem(i, v)
    self.ui.taskDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i))
    taskNum = taskNum + 1
  end
  self.ui.taskDraglist:initListWidth(self:getWidth(taskNum))
  self.refreshCliprectConfig = {
    draglist = self.ui.taskDraglist
  }
end

function CupArenaTaskWin:onJumpEvent(index)
  if nil == self.data or nil == self.data._task_list then
    return
  end
  local taskData = self.data._task_list[index]
  local taskTable = ed.getDataTable("CupArenaTask")[taskData._id]
  local type = taskTable["Task Progress Type"]
  if "DailyjobOpenChest" == type then
    ed.activityTaskTool.openTaskScene(2)
  elseif "ChallengeCampEnemy" == type then
    self:destroy({skipAnim = true})
    FireEvent("EventCupArenaClickChallenge")
  elseif "UseVit" == type then
    ed.activityTaskTool.openStageSelect()
  elseif "TavernGroupUse" == type then
    ed.activityTaskTool.openSummonScene(1)
  elseif "TbcVictory" == type then
    ed.activityTaskTool.openCrusadeScene()
  end
end
