local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.hadesBossDetail = class
ed.UITool.registViewOpenFunc("hadesBossDetail", function(param)
  class.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("hadesBossDetail")
  setmetatable(self, class.mt)
  self:init(param)
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  return self
end

function class:init(param)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
end

function class:initData(param)
  self.bossHeroIdList = param.bossHeroIdList or {}
  self.bossAmount = #self.bossHeroIdList
  self.showBossIndex = 1
end

function class:initLabels()
  ed.setLabelStroke(self.ui.name, ed.toccc3(0), 1)
  ed.setLabelDimensions(self.ui.desc, CCSizeMake(320, 0))
  ed.setLabelStroke(self.ui.skillname, ed.toccc3(2758668), 1)
end

function class:refreshSkill()
  self.skillsBtn[self.selectIndex].select:setVisible(true)
  ed.setString(self.ui.skillname, self.skills[self.selectIndex].name)
  local skillDesc = ed.ui.autoText.new()
  skillDesc:initParam({
    context = self.skills[self.selectIndex].desc,
    maxWidth = self.ui.panel_skill_desc:getContentSize().width - 5,
    lineSpacing = 0
  })
  local size = self.ui.panel_skill_desc:getContentSize()
  skillDesc.node:setPosition(ccp(0, size.height - 10))
  self.skillDescDraglist:addItem(skillDesc.node)
  if self.skillDesc then
    self.skillDesc.node:removeFromParentAndCleanup(true)
  end
  self.skillDesc = skillDesc
  local width, height = skillDesc:getCurContentSize()
  self.skillDescDraglist:initListHeight(height + 5)
end

function class:selectSkill(index)
  if self.selectIndex then
    self.skillsBtn[self.selectIndex].select:setVisible(false)
  end
  self.selectIndex = index
  self:refreshSkill()
end

function class:createSkillIcon(param)
  local btn = ed.createSprite(param.icon)
  local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_white.png")
  local select = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_selected.png")
  btn:addChild(frame)
  btn:addChild(select)
  ed.layout.centerInParent(frame)
  ed.layout.centerInParent(select)
  select:setVisible(false)
  btn.select = select
  table.insert(self.skillsBtn, btn)
  local iconLength = self.ui.layer_skill:getContentSize().height + 8
  local dragListHeight = self.ui.layer_skill:getContentSize().height
  local posX = iconLength / 2 + (param.index - 1) * iconLength
  local posY = dragListHeight / 2
  local scale = dragListHeight / frame:getContentSize().height
  btn:setScale(scale)
  btn:setPosition(ccp(posX, posY))
  self.draglist:addItem(btn)
end

function class:refreshSkillDraglist()
  local bossId = self.bossHeroIdList[self.showBossIndex]
  local bossConfig = ed.getDataTable("HeatBossSkill")[bossId]
  self.draglist:clearList()
  self.skills = {}
  self.skillsBtn = {}
  for i = 1, 50 do
    if not bossConfig["Boss Skill " .. i .. " Name"] then
      break
    else
      local skill = {
        name = bossConfig["Boss Skill " .. i .. " Name"],
        icon = bossConfig["Boss Skill " .. i .. " Icon"],
        desc = bossConfig["Boss Skill " .. i .. " Description"]
      }
      table.insert(self.skills, skill)
      self:createSkillIcon({
        icon = skill.icon,
        index = i
      })
    end
  end
  self.draglist:initListWidth((self.ui.layer_skill:getContentSize().height + 8) * #self.skills + 10)
  if #self.skills == 4 then
    self:adaptSkillIcon()
  end
  self:selectSkill(1)
end

function class:adaptSkillIcon()
  self.draglist:initListWidth((self.ui.layer_skill:getContentSize().height + 18) * #self.skills + 10)
  for i = 1, #self.skills do
    ed.UITool.setPositionBy(self.skillsBtn[i], ccp(10 * i, 0))
  end
end

function class:createSkillDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_skill, {
    priority = -300,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList()
  })
  self.skillDescDraglist = ed.UITool.createDraglist(self.ui.panel_skill_desc, {priority = -300})
end

function class:initUI()
  ed.editorui(ed.uieditor.hades_boss_detail, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:createSkillDraglist()
  self:refreshBossInfo()
  self:refreshArrowBtn()
  self.ui.btn_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(-10, 0)), CCMoveBy:create(0.7, ccp(10, 0)))))
  self.ui.btn_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(10, 0)), CCMoveBy:create(0.7, ccp(-10, 0)))))
end

function class:refreshBossInfo()
  local bossId = self.bossHeroIdList[self.showBossIndex]
  local bossConfig = ed.getDataTable("HeatBossSkill")[bossId]
  ed.setString(self.ui.name, bossConfig["Boss Name"])
  ed.setString(self.ui.desc, bossConfig["Boss Description"])
  local icon = ed.readhero.createIcon({
    id = bossId,
    rank = ed.heroLevel2Rank(self.bossLevel),
    isNoLevelStar = true
  }).icon
  self.ui.panel_icon:removeAllChildrenWithCleanup(true)
  self.ui.panel_icon:addChild(icon)
  ed.layout.centerInParent(icon)
  self:refreshSkillDraglist()
end

function class:refreshArrowBtn()
  self.ui.btn_left:setVisible(self.showBossIndex > 1)
  self.ui.btn_right:setVisible(self.showBossIndex < self.bossAmount)
end

function class:onClickArrowBtn(delta)
  self.showBossIndex = self.showBossIndex + delta
  if self.showBossIndex > self.bossAmount then
    self.showBossIndex = self.bossAmount
  elseif self.showBossIndex < 1 then
    self.showBossIndex = 1
  end
  self:refreshBossInfo()
  self:refreshArrowBtn()
end

function class:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.click_area,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_left", function()
    self:onClickArrowBtn(-1)
  end)
  ed.UITool.registerBtn(self, "btn_right", function()
    self:onClickArrowBtn(1)
  end)
end

function class:registerEvents()
end

function class:doPressInList()
  local function handler(x, y)
    for k, v in pairs(self.skillsBtn or {}) do
      local btn_press = v
      
      if btn_press:isVisible() and ed.containsPoint(btn_press, x, y) then
        v.index = k
        return v
      end
    end
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local index
    if not tolua.isnull(v) and v:isVisible() and ed.containsPoint(v, x, y) then
      self:selectSkill(v.index)
    end
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    return
  end
  
  return handler
end
