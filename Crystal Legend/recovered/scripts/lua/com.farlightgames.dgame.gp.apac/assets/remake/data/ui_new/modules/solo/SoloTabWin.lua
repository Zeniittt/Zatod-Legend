local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloTabWin = class

function class:initLabels()
  for i = 1, 4 do
    ed.setLabelStroke(self.ui["label_title" .. i], ed.toccc3(2891270), 1)
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloTabWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
end

function class:initSkillIcons(ui, hero, k)
  if not hero then
    return
  end
  local slot = {1, 2}
  for i = 1, 2 do
    ui["skill" .. i]:removeAllChildrenWithCleanup(true)
    local skillIcon = ed.readhero.createSoloUnitSkillIcon(hero._hid, slot[i])
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill_2.png")
    clipNode:addChild(skillIcon)
    clipNode:setScale(0.88)
    ui["skill" .. i]:addChild(clipNode)
    ed.layout.centerInParent(clipNode)
    self:btRegisterButtonClick({
      button = ui["skill" .. i],
      key = "skillIcon_" .. k .. "_" .. slot[i],
      clickHandler = function()
        local skillPanel = ed.ui.SoloSkillPop.create({
          heroId = hero._hid,
          slot = slot[i],
          hero = hero
        })
        ed.layout.relateLayout(ui["skill" .. i], skillPanel.ui.bg, {top = -80, left = 217.5}, true)
      end
    })
  end
end

function class:createItem(k, player)
  local container, ui = ed.editorui(ed.uieditor.SoloTabItem)
  ed.setLabelFontName(ui.label_rank, ed.fontBold)
  ed.setLabelStroke(ui.label_rank, ed.toccc3(7162639), 1)
  ed.setLabelStroke(ui.label_name, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_level, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_bar, ed.toccc3(2891270), 1)
  ed.setLabelStroke(ui.label_exp, ed.toccc3(2891270), 1)
  ui.label_bar:setZOrder(1)
  if ed.SoloManager:isMemberEqual(ed.SkillPlayer.getMyUserKey(), player._summary._user_key) then
    ed.setTexture(ui.bg, "UI/alpha/1080P/chesscard/log/player_bg.png")
  end
  local num = math.clamp(k, 1, 4)
  ed.setTexture(ui.bg_rank, string.format("UI/alpha/1080P/chesscard/log/label_%d.png", num))
  local hpBar = CCProgressTimer:create(ui.bar)
  hpBar:setType(kCCProgressTimerTypeBar)
  hpBar:setMidpoint(ccp(0, 0.5))
  hpBar:setBarChangeRate(ccp(1, 0))
  ui.bg_bar:addChild(hpBar)
  ed.layout.centerInParent(hpBar)
  ui.bar:setVisible(false)
  hpBar:setPercentage(player._summary._hp / player._summary._max_hp * 100)
  ed.setString(ui.label_rank, k)
  local heroId = player._summary._hero_id
  local heroIcon = ed.readhero.createSoloUnitIcon({id = heroId}).icon
  heroIcon:setScale(0.5)
  ed.UITool.replaceUINew(ui, "icon_head", heroIcon)
  ed.setString(ui.label_bar, string.format("%d/%d", player._summary._hp, player._summary._max_hp))
  ed.setString(ui.label_level, string.format("\231\173\137\231\186\167%d", player._summary._level))
  ed.setString(ui.label_name, player._summary._user_summary._name)
  self:initSkillIcons(ui, player._hero, k)
  if player._factions and player._factions[1] then
    local factionId = player._factions[1]._faction
    local exp = player._factions[1]._exp
    local level = player._factions[1]._level
    local factionIconRes = ed.getDataTable("SoloCardTag")[factionId]["Tag Icon"]
    ed.setTextureV2(ui.icon_faction, factionIconRes)
    local stepData = ed.getDataTable("SoloCardTag")[factionId]["Star Count"]
    local nextExp = stepData[1]
    if level == 4 then
      local effect = ed.createSpine("effect/eff_UI_solo_fashion_light/eff_UI_solo_fashion_light", 0.5)
      ui.icon_faction:addChild(effect, 5)
      ed.layout.centerInParent(effect)
      effect:setAnimation(0, "Loop", true)
    end
    for i = 1, level do
      ui["star" .. i]:setVisible(true)
    end
    nextExp = stepData[math.min(4, level + 1)]
    ed.setString(ui.label_exp, string.format("%d/%d", exp, nextExp))
    self:btRegisterButtonClick({
      button = ui.icon_faction,
      key = "icon_faction" .. k,
      clickHandler = function()
        local win = ed.ui.SoloFactionPop.create(factionId)
        ed.layout.relateLayout(ui.icon_faction, win.ui.bg, {left = 0, bottom = 70}, true)
      end
    })
  else
    ui.icon_faction:setVisible(false)
  end
  local powers = player._powers or {}
  for i = 1, 3 do
    local power = powers[i]
    if power then
      local powerId = power._id
      local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/treasure_2.png")
      local powerIcon = ed.createSprite(ed.getDataTable("SoloPower")[powerId].Icon)
      clipNode:addChild(powerIcon)
      ui["power" .. i]:addChild(clipNode)
      clipNode:setPosition(ccp(26.7, 26.7))
      self:btRegisterButtonClick({
        button = ui["power" .. i],
        key = "powerIcon_" .. k .. "_" .. i,
        clickHandler = function()
          local win = ed.ui.SoloPowerInfoPop.create({power = power, canOp = false})
          win:popWindow()
          ed.layout.relateLayout(clipNode, win.ui.bg, {left = -5}, true)
        end
      })
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
  self:listenEvent("SoloViewDashboard", function(data)
    self.data = data
    self:createItems()
  end)
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "btn_destroy",
    clickHandler = function()
      base.destroy(self, {skipAnim = true})
    end,
    priority = 1
  })
end

function class.create(records)
  local self = base.create("SoloTabWin", {
    notBlurBg = true,
    swallow = true,
    layer_opacity = 90
  })
  setmetatable(self, class.mt)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  self:show()
  if records then
    self.data = records
    self:createItems()
  else
    ed.SoloNetwork:sendViewDashboard()
  end
  return self
end
