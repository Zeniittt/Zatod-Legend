local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloResultDetailWin = class

function class:initData(data)
  self.data = data
end

function class:initLabels()
  for i = 1, 5 do
    ed.setLabelStroke(self.ui["label_title" .. i], ed.toccc3(2891270), 1)
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloResultDetailWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:createItems()
end

function class:initSkillIcons(ui, heroId)
  local hid = heroId or ed.SoloModel:getHeroId()
  local tbData = ed.lookupDataTable("SoloUnit", nil, hid)
  local heroId = tbData["Hero ID"]
  local slot = {1, 2}
  for i = 1, 2 do
    ui["skill" .. i]:removeAllChildrenWithCleanup(true)
    local skillIcon = ed.readhero.createSoloUnitSkillIcon(heroId, slot[i])
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill_2.png")
    clipNode:addChild(skillIcon)
    clipNode:setScale(0.88)
    ui["skill" .. i]:addChild(clipNode)
    ed.layout.centerInParent(clipNode)
  end
end

function class:createItem(k, player)
  local container, ui = ed.editorui(ed.uieditor.SoloResultDetailItem)
  ed.setLabelFontName(ui.label_rank, ed.fontBold)
  ed.setLabelStroke(ui.label_rank, ed.toccc3(7162639), 1)
  ed.setLabelStroke(ui.label_name, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_level, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_bar, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_exp, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_vic, ed.toccc3(2891270), 1)
  ui.label_bar:setZOrder(1)
  local hpBar = CCProgressTimer:create(ui.bar)
  hpBar:setType(kCCProgressTimerTypeBar)
  hpBar:setMidpoint(ccp(0, 0.5))
  hpBar:setBarChangeRate(ccp(1, 0))
  ui.bg_bar:addChild(hpBar)
  ed.layout.centerInParent(hpBar)
  ui.bar:setVisible(false)
  hpBar:setPercentage(16.666666666666664)
  ed.setString(ui.label_rank, k)
  ui.ImageView_13148:setVisible(false)
  if player._team then
    local heroId = player._team._heroes[1]._hid
    local heroIcon = ed.readhero.createSoloUnitIcon({id = heroId}).icon
    heroIcon:setScale(0.5)
    ed.UITool.replaceUINew(ui, "icon_head", heroIcon)
    local factionData = player._team._card_factions[1]
    if factionData then
      local factionIconRes = ed.getDataTable("SoloCardTag")[factionData._id]["Tag Icon"]
      ed.setTexture(ui.icon_faction, factionIconRes)
      local stepData = ed.getDataTable("SoloCardTag")[factionData._id]["Star Count"]
      local nextExp = stepData[1]
      for i = 1, 4 do
        if factionData._exp >= stepData[i] then
          ui["star" .. i]:setVisible(true)
          nextExp = stepData[math.min(4, i + 1)]
        end
      end
      ed.setString(ui.label_exp, string.format("%d/%d", factionData._exp, nextExp))
      ui.ImageView_13148:setVisible(true)
    end
  end
  ed.setString(ui.label_bar, string.format("%d/%d", 5, 30))
  ed.setString(ui.label_level, string.format("Lv%d", 1))
  ed.setString(ui.label_name, player._user_summary._user_summary._name)
  local color = "ccc3(255,120,120)"
  local flag = "-"
  if player._is_win == 1 then
    color = "ccc3(112,255,84)"
    flag = "+"
    local node = ed.createFcaNode("eff_UI_pvp_light")
    self:addFca(node)
    local x, y = self.ui.ImageView_13082:getPosition()
    node:setPosition(ccp(x, y))
    self.ui.bg:addChild(node)
    local node = ed.createFcaNode("eff_UI_pve_victory_wings")
    self:addFca(node)
    node:setPosition(ccp(x, y + 44))
    self.ui.bg:addChild(node)
    local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
    self:addFca(node)
    node:setPosition(ccp(x, y + 24))
    self.ui.bg:addChild(node, 2)
  else
  end
  local scoreStr = string.format("%d(<lable color=%s>%s%d</lable>)", 100, color, flag, math.abs(player._base_score))
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = scoreStr,
    fontSize = 13,
    strokeColor = ed.toccc3(2891270),
    strokeSize = 1,
    color = ed.toccc3(16776423)
  })
  ed.UITool.replaceUINew(ui, "label_score", autoText.node)
  ed.setString(ui.label_vic, string.format("%d-%d", player._victory_cnt, player._defeat_cnt))
  local powers = player._hero_powers or {}
  for i = 1, 3 do
    local power = powers[i]
    if power then
      local powerId = power._id
      local icon = ed.createSprite(ed.getDataTable("SoloPower")[powerId].Icon)
      local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_prismatic.png")
      icon:addChild(frame)
      ed.layout.centerInParent(frame)
      ui["power" .. i]:addChild(icon)
      icon:setPosition(ccp(45, 44))
    end
  end
  return container, ui
end

function class:createItems()
  for k, v in ipairs(self.data) do
    local container, ui = self:createItem(k, v)
    self.ui.bg:addChild(container)
    container:setPosition(ccp(347, 432 - k * 50))
  end
end

function class:registerEvents()
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end

function class.create(data)
  local self = base.create("SoloResultDetailWin")
  setmetatable(self, class.mt)
  self:initData(data)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  return self
end
