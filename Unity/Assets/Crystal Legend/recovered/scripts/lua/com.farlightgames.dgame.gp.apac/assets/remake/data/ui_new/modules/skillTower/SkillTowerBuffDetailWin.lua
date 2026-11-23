local base = ed.ui.popwindow
local SkillTowerBuffDetailWin = newclass(base.mt)
ed.ui.SkillTowerBuffDetailWin = SkillTowerBuffDetailWin

function SkillTowerBuffDetailWin.create()
  local self = base.create("SkillTowerBuffDetailWin")
  setmetatable(self, SkillTowerBuffDetailWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function SkillTowerBuffDetailWin:initData()
  self.buffId = ed.SkillTowerManager.exTowerData.buffId
end

function SkillTowerBuffDetailWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.SkillBuffDetailWin, {
    container = self.container,
    ui = self.ui
  })
  local buffName = ed.getDataTable("FancyAbyssSeason")[ed.SkillTowerManager.curAbyssSeason]["Skill Name"] or T("\230\183\177\230\184\138BUFF")
  ui.name:setString(string.format(T("\230\156\172\230\156\159\230\149\136\230\158\156\239\188\154%s"), buffName))
  ui.name:limitWidthByScale(250)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {})
  self:refreshDraglist()
end

function SkillTowerBuffDetailWin:createItem()
  local skillId = ed.getDataTable("StageSkill")[self.buffId]["Skill 1 ID"]
  local skillDesc = ed.getDataTable("Skill")[skillId][0]["Full Description"]
  local buffDesc = ed.ui.autoText.new()
  buffDesc:initParam({
    context = skillDesc,
    fontSize = 16,
    maxWidth = 464,
    maxHeight = 110,
    color = ccc3(255, 252, 231)
  })
  return buffDesc
end

function SkillTowerBuffDetailWin:refreshDraglist()
  self.draglist:clearList()
  local autoText = self:createItem()
  self.draglist:addItem(autoText.node)
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(232 - width / 2, 100))
end

function SkillTowerBuffDetailWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "close",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
