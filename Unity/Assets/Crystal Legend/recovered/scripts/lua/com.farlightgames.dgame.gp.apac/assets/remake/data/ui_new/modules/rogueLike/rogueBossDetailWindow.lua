local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueBossDetailWindow = class
ed.UITool.registViewOpenFunc("rogueBossDetailWindow", function(param)
  ed.ui.rogueBossDetailWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueBossDetailWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.chapterId = param.chapterId or 1
  self.selectSkillIndex = 1
  self.skillList = {}
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.skillDragList
  }
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBossDetailWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDragList()
  self:refreshBossInfo()
  self:refreshDragList()
  self:refreshSkillSelect()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_boss_name, ed.toccc3(2758668), 1)
  ed.setLabelStroke(self.ui.label_boss_desc, ed.toccc3(4068624), 1)
  ed.setLabelStroke(self.ui.label_skill_name, ed.toccc3(2758668), 1)
end

function class:initDragList()
  self.skillDragList = ed.UITool.createDraglist(self.ui.panel_skill_icon_list, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler()
  })
  self.skillDescDragList = ed.UITool.createDraglist(self.ui.panel_skill_desc)
end

function class:getPressInHandler()
  local function handle(x, y)
    for index, skillCfg in ipairs(self.skillList) do
      if ed.containsPoint(skillCfg.skillIcon, x, y) then
        return skillCfg
      end
    end
  end
  
  return handle
end

function class:getClickInHandler()
  local function handle(x, y, skillCfg)
    self:onClickSkillIcon(skillCfg)
  end
  
  return handle
end

function class:refreshBossInfo()
  local bossCfg = ed.getDataTable("RogueBoss")[self.chapterId]
  local bossIcon = ed.readhero.createIcon({
    id = bossCfg["Boss ID"][1]
  })
  self.ui.panel_boss_icon:addChild(bossIcon.icon)
  ed.layout.centerInParent(bossIcon.icon)
  self.bossIcon = bossIcon.icon
  ed.setLabelString(self.ui.label_boss_name, bossCfg["Boss Name"])
  ed.setLabelDimensions(self.ui.label_boss_desc, CCSizeMake(340, 0))
  ed.setLabelString(self.ui.label_boss_desc, bossCfg["Boss Description"])
end

function class:refreshDragList()
  local panelSize = self.ui.panel_skill_icon_list:getContentSize()
  self.skillDragList:clearList()
  self.skillList = {}
  local bossCfg = ed.getDataTable("RogueBoss")[self.chapterId]
  local iconSize = CCSizeMake(0, 0)
  local amount = 0
  for index = 1, 20 do
    local skillName = bossCfg[string.format("Boss Skill %s Name", index)]
    if not skillName then
      break
    end
    local iconPath = bossCfg[string.format("Boss Skill %s Icon", index)]
    local skillDesc = bossCfg[string.format("Boss Skill %s Description", index)]
    local skillIcon = self:createSkillIcon(iconPath)
    table.insert(self.skillList, {
      index = index,
      skillIcon = skillIcon,
      skillDesc = skillDesc,
      skillName = skillName
    })
    amount = amount + 1
    self.skillDragList:addItem(skillIcon)
    iconSize = skillIcon:getContentSize()
    skillIcon:setPositionX(iconSize.width / 2 + (index - 1) * (iconSize.width + 20) + 20)
    skillIcon:setPositionY(panelSize.height / 2 - 1)
  end
  local totalWidth = amount * (iconSize.width + 20) + 20
  self.skillDragList:initListWidth(totalWidth)
  if totalWidth < panelSize.width then
    self.skillDragList.listLayer:setPositionX(panelSize.width / 2 - totalWidth / 2)
  end
end

function class:createSkillIcon(iconPath)
  local skillIcon = ed.createSprite(iconPath)
  local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_white.png")
  local select = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_selected.png")
  skillIcon:addChild(frame)
  skillIcon:addChild(select)
  ed.layout.centerInParent(frame)
  ed.layout.centerInParent(select)
  skillIcon.select = select
  select:setVisible(false)
  return skillIcon
end

function class:refreshSkillSelect()
  for index, skillCfg in ipairs(self.skillList) do
    local skillIcon = skillCfg.skillIcon
    skillIcon.select:setVisible(index == self.selectSkillIndex)
  end
  local selectSkillCfg = self.skillList[self.selectSkillIndex]
  if selectSkillCfg then
    local panelSkillSize = self.ui.panel_skill_desc:getContentSize()
    ed.setLabelString(self.ui.label_skill_name, selectSkillCfg.skillName)
    self.skillDescDragList:clearList()
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = selectSkillCfg.skillDesc,
      maxWidth = panelSkillSize.width,
      fontSize = 14,
      color = ed.toccc3(4335629)
    })
    local w, h = autoText:getCurContentSize()
    self.skillDescDragList:addItem(autoText.node)
    if h < panelSkillSize.height then
      autoText.node:setPosition(ccp(1, (panelSkillSize.height + h) / 2 - 7))
    else
      autoText.node:setPosition(ccp(1, panelSkillSize.height - 7))
    end
    self.skillDescDragList:initListHeight(h)
  end
end

function class:onClickSkillIcon(skillCfg)
  local index = skillCfg.index
  if index == self.selectSkillIndex then
    return
  end
  self.selectSkillIndex = index
  self:refreshSkillSelect()
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
