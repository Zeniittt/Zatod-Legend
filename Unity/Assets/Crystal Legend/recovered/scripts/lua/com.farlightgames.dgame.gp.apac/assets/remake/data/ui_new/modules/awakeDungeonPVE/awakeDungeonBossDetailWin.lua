local base = ed.ui.popwindow
local awakeDungeonBossDetail = newclass(base.mt)
ed.ui.awakeDungeonBossDetail = awakeDungeonBossDetail

function awakeDungeonBossDetail:initData(param)
  self.groupId = param.groupId
  self.difficulty = param.difficulty
  self.stageId = param.stageId
  self.bossId = param.bossId
  self.bossLevel = param.bossLevel
end

function awakeDungeonBossDetail:initLabels()
  ed.setLabelStroke(self.ui.name, ed.toccc3(0), 1)
  ed.setLabelDimensions(self.ui.desc, CCSizeMake(320, 0))
  ed.setLabelDimensions(self.ui.skilldesc, CCSizeMake(380, 0))
  ed.setLabelStroke(self.ui.skillname, ed.toccc3(2758668), 1)
end

function awakeDungeonBossDetail:refreshSkill()
  self.ui["select" .. self.selectIndex]:setVisible(true)
  ed.setString(self.ui.skillname, self.skills[self.selectIndex].name)
  ed.setString(self.ui.skilldesc, self.skills[self.selectIndex].desc)
end

function awakeDungeonBossDetail:selectSkill(index)
  if self.selectIndex then
    self.ui["select" .. self.selectIndex]:setVisible(false)
  end
  self.selectIndex = index
  self:refreshSkill()
end

function awakeDungeonBossDetail:initSkills()
  local tb = ed.getDataTable("DungeonBoss")[self.groupId][self.difficulty]
  self.skills = {}
  for i = 1, 5 do
    if tb["Boss Skill " .. i .. " Name"] then
      local skill = {
        name = ed.heroToSkill(tb["Boss Skill " .. i .. " Name"]),
        icon = string.gsub(tb["Boss Skill " .. i .. " Icon"], ".png", ".jpg"),
        desc = tb["Boss Skill " .. i .. " Description"]
      }
      table.insert(self.skills, skill)
      self.ui["skill" .. i]:setVisible(true)
      ed.UITool.registerBtn(self, "skill" .. i, function()
        self:selectSkill(i)
      end)
      ed.setTexture(self.ui["skill" .. i], skill.icon)
    else
      self.ui["skill" .. i]:setVisible(false)
    end
  end
  self:selectSkill(1)
end

function awakeDungeonBossDetail:initUI()
  ed.editorui(ed.uieditor.awakeDungeonBossDetail, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local tb = ed.getDataTable("DungeonBoss")[self.groupId][self.difficulty]
  ed.setString(self.ui.name, tb["Boss Name"])
  ed.setString(self.ui.desc, tb["Boss Description"])
  local icon = ed.readhero.createIcon({
    id = self.bossId,
    rank = ed.heroLevel2Rank(self.bossLevel),
    isNoLevelStar = true
  }).icon
  ed.UITool.replaceUI(self.ui, "bg", "icon", icon)
  self:initSkills()
end

function awakeDungeonBossDetail:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function awakeDungeonBossDetail:registerEvents()
end

function awakeDungeonBossDetail.create(param)
  local self = base.create("awakeDungeonBossDetail")
  setmetatable(self, awakeDungeonBossDetail.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end
