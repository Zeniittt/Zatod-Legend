local base = ed.ui.popwindow
local PetGainWin = newclass(base.mt)
ed.ui.PetGainWin = PetGainWin

function PetGainWin.create(param)
  local self = base.create("PetGainWin")
  setmetatable(self, PetGainWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function PetGainWin:initData(param)
  self.pet = ed.player:getPets()[param.pet_id]
  self.isBest = param.isBest
end

function PetGainWin:initLabels()
  ed.setLabelStroke(self.ui.Label_4831, ed.toccc3(4271642), 1)
  ed.setLabelStroke(self.ui.Label_4831_Copy0, ed.toccc3(4271642), 1)
  ed.setLabelStroke(self.ui.Label_4831_Copy1, ed.toccc3(4271642), 1)
  ed.setLabelStroke(self.ui.bodysize, ed.toccc3(4271642), 1)
  ed.setLabelStroke(self.ui.bodyheight, ed.toccc3(4271642), 1)
  ed.setLabelStroke(self.ui.att_str, ed.toccc3(2562837), 1)
  ed.setLabelStroke(self.ui.att_int, ed.toccc3(2562837), 1)
  ed.setLabelStroke(self.ui.att_agi, ed.toccc3(2562837), 1)
  ed.setLabelStroke(self.ui.label_noTalent, ed.toccc3(4271642), 1)
end

function PetGainWin:getDescLine(color)
  local config = {
    "UI/alpha/1080P/pet/incubate/pet_house_get_frame_blue.png",
    "UI/alpha/1080P/pet/incubate/pet_house_get_frame_blue.png",
    "UI/alpha/1080P/pet/incubate/pet_house_get_frame_purple.png",
    "UI/alpha/1080P/pet/incubate/pet_house_get_frame_gold.png",
    "UI/alpha/1080P/pet/incubate/pet_house_get_frame_gold.png"
  }
  return config[color]
end

function PetGainWin:refreshTitleAndName()
  local typeId = self.pet:getTypeId()
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\232\142\183\229\190\151\230\150\176\228\191\161\228\189\191"),
    fontSize = 46,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776423),
    endColor = ed.toccc3(16767851),
    strokeSize = 2,
    strokeStartColor = ed.toccc3(7886633),
    strokeEndColor = ed.toccc3(7886633)
  })
  ed.UITool.replaceUINew(self.ui, "title", titleLabel.node)
  ed.setTexture(self.ui.icon_tag, ed.Pet.getTagResByTypeId(typeId))
  ed.setTexture(self.ui.bg_name, ed.Pet.getNameBgResByTypeId(typeId))
  local nameLabel = ed.ui.gradientLabel.create({
    text = ed.lookupDataTable("Unit", "Display Name", typeId),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776423),
    endColor = ed.Pet.getNameColorByTypeId(typeId),
    strokeSize = 1.5,
    strokeStartColor = ed.Pet.getStartColor(typeId),
    strokeEndColor = ed.Pet.getEndColor(typeId)
  })
  ed.UITool.replaceUINew(self.ui, "name", nameLabel.node)
  ed.setTexture(self.ui.ImageView_4847, self:getDescLine(ed.Pet.getColorByType(typeId)))
  ed.setTexture(self.ui.ImageView_4847_Copy0, self:getDescLine(ed.Pet.getColorByType(typeId)))
end

function PetGainWin:refreshActor()
  local colorLightConfig = {
    [2] = "blue",
    [3] = "purple",
    [4] = "gold"
  }
  local lightFca = ed.createFcaNode("eff_UI_pet_hatch_light")
  local color = colorLightConfig[self.pet:getColor()]
  lightFca:setStartAction("Start_" .. color)
  lightFca:setLoopAction("Loop_" .. color)
  lightFca:setScale(1.2)
  self.ui.layer_actor:addChild(lightFca)
  local height = self.ui.layer_actor:getContentSize().height
  lightFca:setPosition(ccp(10, height * 0.75))
  self:addFca(lightFca)
  local actor = ed.readpet.getActor(self.pet:getTypeId(), self.pet:isVariation())
  local baseScale = ed.lookupDataTable("Pet", "Puppet Scale", self.pet:getTypeId())
  local scale = 1
  if baseScale then
    scale = scale * baseScale * self.pet:getBody()
  end
  actor:setScale(scale)
  local extraShader = self.pet:getExtraShader()
  if extraShader then
    ed.useShader(actor, extraShader)
  end
  for k, v in ipairs(self.pet:getTalents()) do
    if v == 2 then
      actor:addEffect("eff_buff_pet_shine", 1)
    end
  end
  self.ui.layer_actor:addChild(actor)
  self:addFca(actor)
end

function PetGainWin:refreshAttr()
  ed.setString(self.ui.att_str, string.format(T("\229\138\155\233\135\143:%.1f%%"), self.pet:getPetAttrRadio("STR")))
  ed.setString(self.ui.att_int, string.format(T("\230\153\186\229\138\155:%.1f%%"), self.pet:getPetAttrRadio("INT")))
  ed.setString(self.ui.att_agi, string.format(T("\230\149\143\230\141\183:%.1f%%"), self.pet:getPetAttrRadio("AGI")))
  local petScale = self.pet:getBody()
  ed.setString(self.ui.bodysize, string.format("%.3f", petScale))
  local petLength = petScale * ed.getDataTable("Pet")[self.pet:getTypeId()]["Scale Length"]
  ed.setString(self.ui.bodyheight, string.format("%.3f\231\177\179", petLength))
  self.ui.icon_best:setVisible(self.isBest)
end

function PetGainWin:refreshTalents()
  local talents = self.pet:getTalents()
  if talents and 0 < #talents then
    local ui = self.ui
    ui.label_noTalent:setVisible(false)
    for i, v in ipairs(talents) do
      local talent = self:createTalentLabel(v, i)
      ui.bg:addChild(talent)
      ed.right2(talent, ui.Label_4831, 52 * i - 52)
    end
  end
end

function PetGainWin:initUI()
  ed.editorui(ed.uieditor.PetGetTipWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:refreshTitleAndName()
  self:refreshActor()
  self:refreshAttr()
  self:refreshTalents()
end

function PetGainWin:showTalentInfo(index)
  if not tolua.isnull(self.talentDetailBg) then
    self.talentDetailBg:removeFromParentAndCleanup(true)
  end
  local talentId = self.pet:getTalents()[index]
  if not talentId then
    return
  end
  local desc = ed.getDataTable("PetTalent")[talentId]["Pet Talent Description"]
  desc = string.gsub(desc, "#br#", "<br/>")
  local autoText = ed.ui.autoText:new()
  autoText:initParam({
    context = desc,
    fontSize = 16,
    maxWidth = 400,
    color = ccc3(255, 251, 231)
  })
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/dialog_timely_summon_show.png", CCRectMake(40, 16, 10, 20))
  bg:setAnchorPoint(ccp(0, 0.5))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 40, height + 20))
  local bgWidth = bg:getContentSize().width
  bg:setPosition(ccp(605 + index * 55, 220))
  autoText.node:setPosition(ccp(20, height + 2))
  bg:addChild(autoText.node)
  ListenTimer(Timer:Once(0), function()
    self:btRegisterOutClick({
      area = bg,
      key = "talent_out_click" .. index,
      clickHandler = function()
        if not tolua.isnull(bg) and not self.showInfo then
          bg:removeFromParentAndCleanup(true)
        end
      end,
      force = true
    })
  end)
  self.talentDetailBg = bg
  self.ui.bg:addChild(bg, 999)
end

function PetGainWin:createTalentLabel(talent, index)
  local bg = ed.createSprite("UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png")
  local label = ed.createLabelTTF(ed.getDataTable("PetTalent")[talent]["Pet Talent Name"], 16)
  ed.setLabelColor(label, ed.toccc3(16310150))
  ed.setLabelStroke(label, ed.toccc3(11622675), 1)
  bg:addChild(label)
  ed.layout.centerInParent(label)
  self:btRegisterButtonClick({
    button = bg,
    key = "click_talent_" .. talent,
    clickHandler = function()
      self:showTalentInfo(index)
    end,
    force = true,
    mcpMode = true
  })
  return bg
end

function PetGainWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
