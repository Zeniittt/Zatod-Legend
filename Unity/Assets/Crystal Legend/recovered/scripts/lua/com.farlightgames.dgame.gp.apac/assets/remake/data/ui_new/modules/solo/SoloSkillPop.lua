local base = ed.ui.popwindow
local SoloSkillPop = newclass(base.mt)
ed.ui.SoloSkillPop = SoloSkillPop

function SoloSkillPop:initUI()
  ed.editorui(ed.uieditor.SoloSkillPop, {
    container = self.container,
    ui = self.ui
  })
  local heroId = self.params.heroId
  local slot = self.params.slot
  local skillGroupInfo = ed.lookupDataTable("SoloSkillGroup", nil, heroId)
  local skillId = skillGroupInfo[slot]["Skill Group ID"]
  local skillName = skillGroupInfo[slot]["Display Name"]
  local skillInfo = ed.lookupDataTable("SoloSkill", nil, skillId, 0)
  local name = skillName
  local desc = skillInfo.Description
  desc = string.gsub(desc, "<#%d+#(.-)#>", "%1")
  ed.setString(self.ui.Label_588, name)
  local skillIcon = ed.readhero.createSoloUnitSkillIcon(heroId, slot)
  local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/hero/bg_6_mask.png")
  clipNode:addChild(skillIcon)
  skillIcon:setScale(0.75)
  self.ui.ImageView_585:addChild(clipNode)
  clipNode:setPosition(ccp(26, 26))
  if slot == 2 then
    ed.setTexture(self.ui.ImageView_584, "UI/alpha/1080P/chesscard/hero/bg_icon_pasv.png")
    ed.setTexture(self.ui.ImageView_586, "UI/alpha/1080P/chesscard/hero/tip_skill_pasv.png")
    local txt = ed.ui.gradientLabel.create({
      text = T("\229\164\169\232\181\139"),
      fontSize = 13,
      startColor = ed.toccc3(6758174),
      endColor = ed.toccc3(6758174),
      strokeSize = 1,
      strokeStartColor = ed.toccc3(16767099),
      strokeEndColor = ed.toccc3(15368773)
    })
    ed.UITool.replaceUINew(self.ui, "Label_587", txt.node)
  else
    local txt = ed.ui.gradientLabel.create({
      text = T("\229\164\167\230\139\155"),
      fontSize = 13,
      startColor = ed.toccc3(868221),
      endColor = ed.toccc3(868221),
      strokeSize = 1,
      strokeStartColor = ed.toccc3(12313343),
      strokeEndColor = ed.toccc3(6147583)
    })
    ed.UITool.replaceUINew(self.ui, "Label_587", txt.node)
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16710887),
    maxWidth = 160,
    fontSize = 13,
    lineSpacing = 1
  })
  ed.UITool.replaceUINew(self.ui, "Label_589", autoText.node)
  local powerId = skillInfo["Solo Power ID"]
  if powerId and powerId ~= 0 then
    local effectType = ed.getDataTable("SoloPower")[powerId]["Effect 1 Type"]
    local desc = ""
    if effectType == "battle_ult_extra_power" then
      desc = "\229\164\167\230\139\155\230\143\144\229\141\135\228\188\164\229\174\179:%d"
    elseif effectType == "battle_attr_ad" then
      desc = "\230\148\187\229\135\187\229\138\155\230\143\144\229\141\135:%d"
    end
    local powers = self.powers or {}
    for k, v in ipairs(powers) do
      if v._id == powerId then
        self.power = v
      end
    end
    local value = 0
    if self.power then
      for k, effect in ipairs(self.power._effects or {}) do
        for kk, record in ipairs(effect._records or {}) do
          local type = record._type
          if type == "battle_ult_extra_power" then
            value = record._int_values[1]
          elseif type == "battle_attr_ad" then
            value = record._int_values[1]
          end
        end
      end
    end
    desc = string.format(desc, value)
    ed.setString(self.ui.Label_2804, desc)
  else
    self.ui.ImageView_2803:setVisible(false)
    self.ui.Label_2804:setVisible(false)
  end
end

function SoloSkillPop:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:destroy()
    end,
    priority = -1
  })
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
end

function SoloSkillPop:destroy()
  base.destroy(self, {skipAnim = true})
end

function SoloSkillPop:initData(params)
  self.params = params or {}
  self.powers = (params.hero or {})._powers
end

function SoloSkillPop.create(params)
  local self = base.create("SoloSkillPop", {
    notBlurBg = true,
    noShade = true,
    priority = -999,
    swallow = true
  })
  setmetatable(self, SoloSkillPop.mt)
  self:initData(params)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  return self
end
