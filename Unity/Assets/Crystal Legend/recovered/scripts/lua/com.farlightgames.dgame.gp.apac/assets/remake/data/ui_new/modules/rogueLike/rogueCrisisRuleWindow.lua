local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueCrisisRuleWindow = class
ed.UITool.registViewOpenFunc("rogueCrisisRuleWindow", function(param)
  ed.ui.rogueCrisisRuleWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueCrisisRuleWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.crisisGroupId = param.crisisGroupId or 1
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCrisisRuleWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDragList()
  self:refreshDragList()
  ed.setLabelString(self.ui.label_title, ed.getDataTable("RogueCrisis")[self.crisisGroupId][1]["Crisis Name"])
end

function class:initLabels()
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list)
end

function class:refreshDragList()
  local panelSize = self.ui.panel_list:getContentSize()
  self.dragList:clearList()
  local height = 0
  for _, crisisCfg in ipairs(ed.getDataTable("RogueCrisis")[self.crisisGroupId]) do
    local item, size = self:createDescItem(crisisCfg)
    self.dragList:addItem(item)
    item:setPosition(ccp(0, panelSize.height - height - size.height))
    height = height + size.height
  end
  self.dragList:initListHeight(height)
end

function class:createDescItem(crisisCfg)
  local panelSize = self.ui.panel_list:getContentSize()
  local crisisDiff = crisisCfg["Crisis Difficulty"]
  local container = CCLayerColor:create(ccc4(0, 0, 0, 0))
  local iconBg = ed.createSprite("UI/alpha/1080P/rogue/main/crisis_rule_bg.png")
  container:addChild(iconBg)
  local icon = ed.createSprite("UI/alpha/1080P/rogue/main/main_crisis_heat_icon.png")
  icon:setScale(0.5)
  iconBg:addChild(icon)
  icon:setPosition(ccp(17, 11))
  local labelDiff = ed.createttf(crisisDiff or 1, 18)
  labelDiff:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelDiff, ed.toccc3(16735324))
  ed.setLabelStroke(labelDiff, ed.toccc3(16771980), 1)
  iconBg:addChild(labelDiff)
  labelDiff:setPosition(ccp(28, 11))
  local autoText = ed.ui.autoText.new()
  local desc = string.gsub(crisisCfg["Crisis Description"], "#p#", "%%")
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16776423),
    fontSize = 18,
    maxWidth = panelSize.width - iconBg:getContentSize().width - 10
  })
  container:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local containerSize = CCSizeMake(panelSize.width, autoTextH + 9)
  container:setContentSize(containerSize)
  iconBg:setPosition(ccp(25, containerSize.height - 15))
  autoText.node:setPosition(ccp(50, containerSize.height - 15))
  return container, containerSize
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:close()
    end,
    force = true
  })
end

function class:close()
  self:destroy()
end

function class:addEventListener()
end
