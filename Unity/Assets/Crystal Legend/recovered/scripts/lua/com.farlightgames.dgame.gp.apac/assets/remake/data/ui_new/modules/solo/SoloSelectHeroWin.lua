local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloSelectHeroWin = class

function class:initData(data)
  self.heroData = data._hero_options
  self.chooseId = data._choose_id
  self.fRefreshTimes = data._max_free_refresh_times - data._cur_free_refresh_times
  self.cPayRefreshTimes = data._cur_pay_refresh_times
  self.mPayRefreshTimes = data._max_pay_refresh_times
  self.coins = data._pay_coin_num
  self.payLeftRTimes = math.min(self.mPayRefreshTimes - self.cPayRefreshTimes, self.coins)
end

function class:initLabels()
  ed.setLabelFontName(self.ui.Label_443, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_443, ed.toccc3(9658393), 2.5)
  ed.setLabelFontName(self.ui.Label_192, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_192, ed.toccc3(4665375), 1.5)
  ed.setLabelFontName(self.ui.label_attr_hp, ed.fontBold)
  ed.setLabelStroke(self.ui.label_attr_hp, ccc3(0, 0, 0), 1.5)
  ed.setLabelFontName(self.ui.label_attr_atk, ed.fontBold)
  ed.setLabelStroke(self.ui.label_attr_atk, ccc3(0, 0, 0), 1.5)
  ed.setLabelFontName(self.ui.label_attr_mp, ed.fontBold)
  ed.setLabelStroke(self.ui.label_attr_mp, ccc3(0, 0, 0), 1.5)
  ed.setLabelFontName(self.ui.label_attr_speed, ed.fontBold)
  ed.setLabelStroke(self.ui.label_attr_speed, ccc3(0, 0, 0), 1.5)
  ed.setLabelFontName(self.ui.label_attr_sb, ed.fontBold)
  ed.setLabelStroke(self.ui.label_attr_sb, ccc3(0, 0, 0), 1.5)
  ed.setLabelFontName(self.ui.label_attr_crit, ed.fontBold)
  ed.setLabelStroke(self.ui.label_attr_crit, ccc3(0, 0, 0), 1.5)
  ed.setLabelStroke(self.ui.label_skill_desc1, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_skill_desc2, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_skill_name1, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_skill_name2, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.tag1, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.tag2, ccc3(20, 18, 18), 1)
  ed.setLabelFontName(self.ui.tag1, ed.fontBold)
  ed.setLabelFontName(self.ui.tag2, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_9032, ccc3(20, 18, 18), 1)
  ed.setLabelFontName(self.ui.Label_9032, ed.fontBold)
end

function class:initFactions()
  local activeFaction = {}
  for k, v in pairs(ed.SoloModel.factions or {}) do
    table.insert(activeFaction, k)
  end
  local unActiveFaction = ed.SoloModel.frozonFactions or {}
  
  local function createTag(k, v, isActive)
    local tagData = ed.getDataTable("SoloCardTag")[v]
    local tagSprite = ed.createSprite(tagData["Tag2 Icon"])
    local name = ed.createLabelTTF(tagData.Name, 11.5)
    name:setAnchorPoint(ccp(0, 0.5))
    ed.setLabelColor(name, isActive and ed.toccc3(16776423) or ed.toccc3(10592673))
    ed.setLabelStroke(name, ccc3(34, 24, 16), 1)
    local n = isActive and #activeFaction or #unActiveFaction
    local pos = ccp((k - n / 2 - 0.5) * 80, isActive and 0 or -40)
    tagSprite:setPosition(ccpAdd(pos, ccp(-9, 0)))
    self.ui.node_factions:addChild(tagSprite)
    name:setPosition(ccpAdd(pos, ccp(6, 0)))
    self.ui.node_factions:addChild(name)
    if not isActive then
      ed.setSpriteGray(tagSprite)
    end
  end
  
  for k, v in pairs(activeFaction) do
    createTag(k, v, true)
  end
end

function class:updateHeroPanel(shopHero, index)
  local hid = shopHero._hero_id
  local name = ed.getDataTable("SoloUnit")[hid]["Display Name"]
  local txt = ed.ui.gradientLabel.create({
    text = name,
    fontSize = 21,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16513768),
    endColor = ed.toccc3(16771228),
    strokeSize = 2,
    strokeStartColor = ed.toccc3(9460010),
    strokeEndColor = ed.toccc3(5123602)
  })
  ed.UITool.replaceUINew(self.ui, "name" .. index, txt.node)
  self.ui["icon" .. index]:removeAllChildrenWithCleanup(true)
  local heroIcon = ed.createSprite(ed.getSoloUnitPortrait(hid))
  heroIcon:setScale(1.4)
  self.ui["icon" .. index]:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
end

function class:initHeroPanel()
  for i = 1, 3 do
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/hero/hero_unlock.png")
    clipNode:setScale(1.15)
    ed.UITool.replaceUINew(self.ui, "icon" .. i, clipNode)
  end
  for i = 1, 3 do
    local shopHero = self.heroData[i]
    self.ui["panel_hero_" .. i]:setPositionY(407)
    self.ui["panel_hero_" .. i]:setVisible(false)
    self:listenTimer(Timer:Once(0.05 * i), function()
      if shopHero then
        self.ui["panel_hero_" .. i]:setVisible(true)
        self.ui["panel_hero_" .. i]:runAction(CCMoveBy:create(0.2, ccp(0, -100)))
        self:updateHeroPanel(shopHero, i)
      else
        self.ui["panel_hero_" .. i]:setVisible(false)
      end
    end)
  end
end

function class:showChessDetail(heroId)
  local name = ed.getDataTable("SoloUnit")[heroId]["Display Name"]
  local txt = ed.ui.gradientLabel.create({
    text = name,
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16513768),
    endColor = ed.toccc3(16771228),
    strokeSize = 2,
    strokeStartColor = ed.toccc3(9460010),
    strokeEndColor = ed.toccc3(5123602)
  })
  ed.UITool.replaceUINew(self.ui, "name", txt.node)
  local uinfo = ed.lookupDataTable("SoloUnit", nil, heroId)
  local ARM = uinfo.ARM
  local MR = uinfo.MR
  ed.setString(self.ui.label_attr_hp, uinfo.HP)
  ed.setString(self.ui.label_attr_atk, uinfo.AD)
  ed.setString(self.ui.label_attr_mp, uinfo.MPR)
  local resourceName = ed.lookupDataTable("Puppet", "Resource", uinfo.Puppet) .. ".cha"
  local nPerSecond = string.format("%.1f", 1 / ed.lookupDataTable("AnimDuration", "Duration", resourceName, "atk"))
  ed.setString(self.ui.label_attr_speed, nPerSecond)
  ed.setString(self.ui.label_attr_sb, uinfo.DODG)
  ed.setString(self.ui.label_attr_crit, uinfo.CRIT)
  local uinfo = ed.lookupDataTable("SoloUnit", nil, heroId)
  local skillGroupInfo = ed.lookupDataTable("SoloSkillGroup", nil, heroId)
  local skillId = skillGroupInfo[1]["Skill Group ID"]
  local skillInfo = ed.lookupDataTable("SoloSkill", nil, skillId, 0)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.gsub(skillInfo.Description, "<#%d+#(.-)#>", "%1"),
    maxWidth = 145,
    color = ccc3(255, 252, 231),
    fontSize = 11.5,
    lineSpacing = 0
  })
  ed.UITool.replaceUINew(self.ui, "label_skill_desc2", autoText.node)
  local txt = ed.ui.gradientLabel.create({
    text = skillGroupInfo[1]["Display Name"],
    fontSize = 15,
    startColor = ed.toccc3(16632692),
    endColor = ed.toccc3(15039555)
  })
  txt.node:setAnchorPoint(ccp(0, 0.5))
  ed.UITool.replaceUINew(self.ui, "label_skill_name2", txt.node)
  local skillId1 = skillGroupInfo[2]["Skill Group ID"]
  local skillInfo1 = ed.lookupDataTable("SoloSkill", nil, skillId1, 0)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.gsub(skillInfo1.Description, "<#%d+#(.-)#>", "%1"),
    maxWidth = 145,
    color = ccc3(255, 252, 231),
    fontSize = 11.5,
    lineSpacing = 0
  })
  ed.UITool.replaceUINew(self.ui, "label_skill_desc1", autoText.node)
  local txt = ed.ui.gradientLabel.create({
    text = skillGroupInfo[2]["Display Name"],
    fontSize = 15,
    startColor = ed.toccc3(12379380),
    endColor = ed.toccc3(6147327)
  })
  txt.node:setAnchorPoint(ccp(0, 0.5))
  ed.UITool.replaceUINew(self.ui, "label_skill_name1", txt.node)
  local skillIcon1 = ed.readhero.createSoloUnitSkillIcon(heroId, 2)
  local clipNode1 = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill_2.png")
  skillIcon1:setScale(0.6)
  clipNode1:addChild(skillIcon1)
  self.ui.icon_skill1:addChild(clipNode1)
  ed.layout.centerInParent(clipNode1)
  local skillIcon2 = ed.readhero.createSoloUnitSkillIcon(heroId, 1)
  local clipNode2 = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill_2.png")
  skillIcon2:setScale(0.6)
  clipNode2:addChild(skillIcon2)
  self.ui.icon_skill2:addChild(clipNode2)
  ed.layout.centerInParent(clipNode2)
  local factions = ed.getSoloUnitFaction(heroId) or {}
  for i = 1, 2 do
    if factions[i] then
      self.ui["faction" .. i]:setVisible(true)
      local tagData = ed.getDataTable("SoloCardTag")[factions[i]]
      ed.setTexture(self.ui["faction" .. i], tagData["Tag2 Icon"])
    else
      self.ui["faction" .. i]:setVisible(false)
    end
  end
  local txt = ed.ui.gradientLabel.create({
    text = T("\229\164\169\232\181\139"),
    fontSize = 12,
    startColor = ed.toccc3(6758174),
    endColor = ed.toccc3(6758174),
    strokeSize = 1,
    strokeStartColor = ed.toccc3(16767099),
    strokeEndColor = ed.toccc3(15368773)
  })
  ed.UITool.replaceUINew(self.ui, "tag1", txt.node)
  local txt = ed.ui.gradientLabel.create({
    text = T("\229\164\167\230\139\155"),
    fontSize = 12,
    startColor = ed.toccc3(865661),
    endColor = ed.toccc3(865661),
    strokeSize = 1,
    strokeStartColor = ed.toccc3(12313343),
    strokeEndColor = ed.toccc3(6147583)
  })
  ed.UITool.replaceUINew(self.ui, "tag2", txt.node)
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloSelectHeroWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:initFactions()
  self:initHeroPanel()
  for i = 1, 3 do
    ed.playBlinkActionV3(self.ui["bg_selected" .. i], 2, 128)
  end
  self.ui.btn_ok:setVisible(false)
  self:listenTimer(Timer:Always(1), function()
    local leftSec = math.max(ed.SoloModel.waitChooseTime - ed.getServerTime(), 0)
    if leftSec <= 0 then
      base.destroy(self, {skipAnim = true})
    end
  end)
  if self.fRefreshTimes > 0 then
    self.ui.ImageView_9031:setVisible(true)
    self.ui.ImageView_3084:setVisible(false)
  else
    self.ui.ImageView_9031:setVisible(false)
    self.ui.ImageView_3084:setVisible(true)
    ed.setString(self.ui.Label_3085, string.format("%d/%d", self.payLeftRTimes, self.mPayRefreshTimes))
  end
  ed.setString(self.ui.Label_9032, self.fRefreshTimes)
end

function class:updateOkBtn()
  self.ui.btn_ok:setVisible(self.curSelect ~= nil)
  self.ui.bg_herodetail:setVisible(self.curSelect ~= nil)
end

function class:registerEvents()
  ed.UITool.registerBtn(self, "btn_refresh", function()
    if self.fRefreshTimes <= 0 and 0 >= self.payLeftRTimes then
      ed.showToast(T("\229\136\183\230\150\176\233\129\147\229\133\183\228\184\141\232\182\179"))
      return
    end
    ed.SoloNetwork:sendRefreshChoices(self.fRefreshTimes <= 0)
  end)
  ed.UITool.registerBtn(self, "frame4", function()
    ed.showToast(T("\230\136\152\232\175\129\232\180\173\228\185\176\229\143\175\231\148\168(\230\154\130\230\156\170\229\174\158\231\142\176)"))
  end)
  for i = 1, 3 do
    ed.UITool.registerBtn(self, "frame" .. i, function()
      if self.isSelected then
        return
      end
      if self.curSelect then
        self.ui["bg_selected" .. self.curSelect]:setVisible(false)
        self.ui["panel_hero_" .. self.curSelect]:setScale(1)
      end
      if self.curSelect == i then
        self.curSelect = nil
      else
        self.curSelect = i
        self.chessDetail = self:showChessDetail(self.heroData[i]._hero_id)
        ed.SoloNetwork:sendChooseChessHero(self.chooseId, i, 0)
      end
      if self.curSelect then
        self.ui["bg_selected" .. self.curSelect]:setVisible(true)
        self.ui["panel_hero_" .. self.curSelect]:setScale(1.1)
      end
      local x, y = self.ui["panel_hero_" .. i]:getPosition()
      self.ui.bg_herodetail:setPosition(ccp(x + 50, y + 10))
      self:updateOkBtn()
    end)
  end
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.curSelect then
      ed.SoloNetwork:sendChooseChessHero(self.chooseId, self.curSelect, 1)
      self.ui.btn_refresh:setVisible(false)
      self.ui.btn_ok:setVisible(false)
      self.ui.bg_herodetail:setVisible(false)
      self.isSelected = true
      for i = 1, 3 do
        local x, y = 480, 300
        if i == self.curSelect then
          local action = CCSpawn:create(ccArrayMake({
            CCMoveTo:create(0.6, ccp(x, y)),
            CCScaleTo:create(0.6, 1.3)
          }))
          local action = CCSequence:create(ccArrayMake({
            action,
            CCEaseOut:create(CCScaleTo:create(0.2, 0.95), 0.3),
            CCScaleTo:create(0.05, 1)
          }))
          self.ui["panel_hero_" .. self.curSelect]:runAction(action)
        else
          self.ui["panel_hero_" .. i]:setVisible(false)
        end
      end
    end
  end, {normalScale = 0.8, pressScale = 0.75})
  self:btRegisterOutClick({
    area = self.ui.bg_herodetail,
    key = "out_click",
    clickHandler = function()
      self.ui.bg_herodetail:setVisible(false)
      self.ui.btn_ok:setVisible(false)
      if self.curSelect then
        self.ui["bg_selected" .. self.curSelect]:setVisible(false)
        self.ui["panel_hero_" .. self.curSelect]:setScale(1)
        self.curSelect = nil
      end
    end,
    clickInterval = 0.5
  })
  self:listenEvent("EventCloseOtherWin", function()
    base.destroy(self, {skipAnim = true})
  end)
end

function class.create(data)
  local self = base.create("SoloSelectHeroWin", {layer_opacity = 200})
  setmetatable(self, class.mt)
  self:initData(data)
  self:initUI()
  self:registerEvents()
  self:popWindow()
  return self
end
