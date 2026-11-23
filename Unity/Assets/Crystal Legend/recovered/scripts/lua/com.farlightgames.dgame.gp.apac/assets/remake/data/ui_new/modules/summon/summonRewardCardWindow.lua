local base = ed.ui.popwindow
local SummonRewardCardWindow = newclass(base.mt)
ed.ui.SummonRewardCardWindow = SummonRewardCardWindow
local lsr = ed.ui.popherocardlsr.create()
ed.UITool.registViewOpenFunc("SummonRewardCardWindow", function(params)
  SummonRewardCardWindow.create(params):popWindow(params.order or 200)
end)

function SummonRewardCardWindow.create(params)
  local self = base.create("SummonRewardCardWindow")
  setmetatable(self, SummonRewardCardWindow.mt)
  SummonRewardCardWindow.eventScope = {}
  self.rewards = params.rewards
  self.convertIdxs = params.convertIdxs or {}
  self.doSummon = params.doSummon
  self.tabName = params.tabName or "normal"
  self.noRewards = params.noRewards
  self.addHero = params.addHero
  self.callback = params.callback or false
  self.closeCallback = params.closeCallback or false
  self.title = params.title
  self.idx = 0
  self.inPlaying = false
  self:initView()
  self:registerEvents()
  return self
end

function SummonRewardCardWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.summonRewardCardWindow)
  self.ui = ui
  self.container:addChild(container)
  self:initFont()
  self:showNext()
  ed.layout.layoutWithMagin(self.ui.btn_skip, {top = 0, right = 0})
  ed.layout.layoutWithMagin(self.ui.tips, {bottom = 40})
  if self.noRewards then
    self.ui.btn_skip:setVisible(false)
  end
  if self.addHero then
    self.ui.btn_skip:setVisible(false)
  end
  if self.tabName == "destiny" then
    ed.setTexture(self.ui.once_res_icon, "UI/alpha/1080P/icon/destiny_ticket.png")
    ed.setTexture(self.ui.ten_res_icon, "UI/alpha/1080P/icon/destiny_ticket.png")
  elseif self.tabName == "timely" or self.tabName == "newbie" then
    ed.setTexture(self.ui.once_res_icon, "UI/alpha/1080P/icon/summontimely_ticket.png")
    ed.setTexture(self.ui.ten_res_icon, "UI/alpha/1080P/icon/summontimely_ticket.png")
  end
  self.ui.btn_share:setVisible(false)
end

function SummonRewardCardWindow:initFont()
  local fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(self.ui.btn_summon_label, fontcolor)
  fontcolor = ccc3(255, 248, 174)
  ed.setLabelShadow(self.ui.name, fontcolor, ccp(0, 1))
  fontcolor = ccc3(39, 37, 36)
  ed.setLabelStroke(self.ui.tips, fontcolor, 1)
  fontcolor = ccc3(59, 25, 67)
  ed.setLabelStroke(self.ui.res_num, fontcolor, 1)
  ed.setLabelStroke(self.ui.label_skip, ed.toccc3(3483679), 1)
end

local colorBG = {
  {
    bg = "UI/alpha/1080P/summon/tavern_get_hero_bg_green.jpg",
    color = "green"
  },
  {
    bg = "UI/alpha/1080P/summon/tavern_get_hero_bg_blue.jpg",
    color = "blue"
  },
  {
    bg = "UI/alpha/1080P/summon/tavern_get_hero_bg_purple.jpg",
    color = "red"
  },
  {
    bg = "UI/alpha/1080P/summon/tavern_get_hero_bg_golden.jpg",
    color = "red"
  },
  {
    bg = "UI/alpha/1080P/summondestiny/destiny_bg.jpg",
    color = "purple"
  }
}

function SummonRewardCardWindow:showNext()
  self.idx = self.idx + 1
  local rewards = self.addHero or self.rewards
  if self.idx > #rewards then
    return false
  end
  local reward = rewards[self.idx]
  print("____________________________________", reward)
  if reward.type == "item" then
    self:showContent(reward)
  elseif reward.type == "hero" then
    self:showCard(reward)
  end
  return true
end

local function getComposedID(id)
  for k, v in pairs(ed.getDataTable("fragment")) do
    if v["Fragment ID"] == id then
      return k
    end
  end
  return nil
end

function SummonRewardCardWindow:showContent(reward)
  self.showingType = "showContent"
  self.ui.card_panel:setVisible(false)
  self.ui.content_panel:setVisible(true)
  self.ui.pos:removeAllChildrenWithCleanup(true)
  local content
  local name = ""
  if reward.type == "item" then
    local progressBj, progress, newScale
    local makeid = getComposedID(reward.id)
    if ed.itemType(makeid) == "hero" then
      local old = ed.summonMgr.equipQunty[reward.id] or 0
      local stoneAmount = old + reward.amount
      local stoneNeed = ed.readhero.getStoneNeed(makeid) or 0
      progressBj = ed.createSprite("UI/alpha/1080P/summon/summon_soulstone_progress_bg.png")
      progressBj:setPosition(4, -57)
      progressBj:setVisible(false)
      local progress2 = ed.createSprite("UI/alpha/1080P/summon/summon_soulstone_progress.png")
      progress2:setPosition(3, 3.1)
      progress2:setAnchorPoint(ccp(0, 0))
      progressBj:addChild(progress2)
      progress2:setOpacity(172)
      progress2:setColor(ccc3(0, 0, 0))
      progress = ed.createSprite("UI/alpha/1080P/summon/summon_soulstone_progress.png")
      progress:setPosition(3, 3.1)
      progress:setAnchorPoint(ccp(0, 0))
      progressBj:addChild(progress)
      local scale = old / stoneNeed
      scale = 1 < scale and 1 or scale
      scale = 1.45 * scale
      progress:setScaleX(scale)
      newScale = stoneAmount / stoneNeed
      newScale = 1 < newScale and 1 or newScale
      newScale = newScale <= 0 and 1 or newScale
      newScale = 1.45 * newScale
      progress2:setScaleX(newScale)
      local soulstone = ed.createSprite("UI/alpha/1080P/common/equip_soulstone_tag.png")
      soulstone:setPosition(1, 12)
      soulstone:setScale(2)
      progressBj:addChild(soulstone)
      stoneNeed = stoneNeed == 0 and "MAX" or stoneNeed
      local label = ed.createttf(stoneAmount .. "/" .. stoneNeed, 16)
      label:setColor(ccc3(237, 222, 244))
      label:setPosition(44, 12)
      progressBj:addChild(label)
      self.ui.pos:addChild(progressBj)
      ed.summonMgr.equipQunty[reward.id] = stoneAmount
    end
    content = ed.readequip.createIconWithAmount(reward.id, 120, reward.amount)
    content:setPositionY(15)
    content:setVisible(false)
    local template = ed.lookupDataTable("equip", nil, reward.id)
    name = template.Name
    ed.initSpriteWithFrame(self.ui.title_img, "UI/alpha/1080P/summon/text_got_title.png")
    if not ed.isAreaZh() then
      local label = ed.createLabelTTF(T("\230\129\173\229\150\156\232\142\183\229\190\151\239\188\129"), 33)
      ed.setLabelFontName(label, ed.fontBold)
      ed.setLabelColor(label, ed.toccc3(267385860))
      ed.setLabelStroke(label, ed.toccc3(13733402), 2)
      ed.setLabelShadow(label, ed.toccc3(6567957), ccp(0, 4))
      ed.adaptLabel(label, {maxWidth = 360, minScale = 0.7})
      ed.UITool.replaceUINew(self.ui, "title_img", label)
      ed.layout.centerInParent(self.ui.title_img)
    end
    ed.initSpriteWithFrame(self.ui.bg, colorBG[1].bg)
    local shadow = ed.createSprite("UI/alpha/1080P/summon/tavern_get_item_bg_light_white.png")
    shadow:setPosition(0, 200)
    shadow:setScale(0)
    local duration = 0.3
    local scaleTo = CCEaseSineOut:create(CCScaleTo:create(duration, 2))
    local moveTo = CCEaseSineOut:create(CCMoveTo:create(duration, ccp(0, 20)))
    local rotateBy = CCEaseSineOut:create(CCRotateBy:create(duration, 720))
    local array = ccArrayMake(scaleTo, moveTo, rotateBy)
    local spawn = CCSpawn:create(array)
    local func = CCCallFunc:create(function()
      xpcall(function()
        content:setVisible(true)
        shadow:setVisible(false)
        if progressBj then
          progressBj:setVisible(true)
          progress:runAction(CCScaleTo:create(0.4, newScale, 1))
        end
      end, EDDebug)
    end)
    shadow:runAction(CCSequence:create(ccArrayMake(spawn, CCDelayTime:create(0.1), func)))
    self.ui.pos:addChild(shadow)
    ed.playEffect(ed.sound.deo.summon_get_item)
  elseif reward.type == "hero" then
    content = ed.readhero.getActor(reward.id)
    content:setAction("Move")
    local effect = ed.getUnitVoiceMove(reward.id)
    if effect then
      ed.playEffect(effect)
    end
    content:setPositionY(-35)
    local template = ed.lookupDataTable("Unit", nil, reward.id)
    name = template["Display Name"]
    local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
    content:setScale(scale)
    self:addFca(content)
    ed.initSpriteWithFrame(self.ui.title_img, "UI/alpha/1080P/summon/text_got_hero.png")
    if not ed.isAreaZh() or self.title then
      local title = self.title or T("\228\189\160\232\142\183\229\190\151\228\186\134\228\184\128\228\184\170\230\150\176\232\139\177\233\155\132\239\188\129")
      local gradientLabel = ed.ui.gradientLabel.create({
        text = title,
        fontSize = 33,
        fontName = ed.fontBold,
        startColor = ed.toccc3(16776946),
        endColor = ed.toccc3(16775073),
        strokeSize = 1.5,
        strokeColor = ed.toccc3(10504457)
      })
      ed.UITool.replaceUINew(self.ui, "title_img", gradientLabel.node)
      ed.layout.centerInParent(self.ui.title_img)
    end
    local star = template["Initial Stars"] or 1
    local bgRes = colorBG[star + 1].bg
    if self.tabName == "destiny" then
      bgRes = colorBG[5].bg
    end
    ed.initSpriteWithFrame(self.ui.bg, bgRes)
  end
  if self.fbBubble then
    local scalex = self.fbBubble:getScaleX()
    local scaley = self.fbBubble:getScaleY()
    local rand = ed.rand() * 100
    local newScalex = 50 <= rand and scalex * -1 or scalex
    rand = ed.rand() * 100
    local newScaley = 50 <= rand and scaley * -1 or scaley
    if newScalex == scalex and newScaley == scaley then
      rand = ed.rand() * 100
      if rand <= 50 then
        newScalex = scalex * -1
      else
        newScaley = scaley * -1
      end
    end
    self.fbBubble:setScaleX(newScalex)
    self.fbBubble:setScaleY(newScaley)
  end
  local cardNode = self.ui.content_panel
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      cardNode:setVisible(true)
      cardNode:runAction(fi)
      if not self.fbBubble then
        local fb = ed.createFcaNode("eff_UI_tavern_bubble")
        self.ui.content_panel:addChild(fb)
        fb:setPosition(self.ui.card:getPosition())
        self:addFca(fb)
        fb:setScale(1.5)
        self.fbBubble = fb
        local rand = ed.rand() * 100
        if rand <= 30 then
          self.fbBubble:setScaleY(-1.5)
        elseif rand <= 70 then
          self.fbBubble:setScaleX(-1.5)
        end
      end
      self.inPlaying = false
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  cardNode:runAction(s)
  ed.layout.lazyAdaptBG(self.ui.bg)
  self.ui.name:setString(name)
  ed.adaptLabel(self.ui.name, {maxWidth = 140, minScale = 0.5})
  if content then
    self.ui.pos:addChild(content)
    self.content = content
  end
end

function SummonRewardCardWindow:showCard(reward)
  self.showingType = "showCard"
  self.ui.card_panel:setVisible(true)
  self.ui.content_panel:setVisible(false)
  self.ui.card:setVisible(false)
  self.ui.tips:setVisible(false)
  self.ui.res_icon:setVisible(false)
  local unitTb = ed.getDataTable("Unit")[reward.id]
  local isDestinySummon = self.tabName == "destiny"
  if self.convertIdxs[self.idx] then
    if isDestinySummon then
      if self.convertIdxs[self.idx] < 90 then
        self.ui.tips:setString(string.format(T("\230\129\173\229\150\156\232\142\183\229\190\151%s,\233\162\157\229\164\150\232\142\183\229\190\151"), unitTb["Display Name"]))
        self.ui.res_num:setString("x" .. self.convertIdxs[self.idx])
      else
        self.ui.tips:setString(T("\233\135\141\229\164\141\232\142\183\229\190\151\232\175\165\232\139\177\233\155\132\239\188\140\229\183\178\232\135\170\229\138\168\229\136\134\232\167\163\228\184\186"))
        self.ui.res_num:setString("x" .. self.convertIdxs[self.idx])
      end
    else
      local stoneNum = ed.summonMgr:getFragmentNumByStar(unitTb["Initial Stars"])
      self.ui.tips:setString(T("\233\135\141\229\164\141\232\142\183\229\190\151\232\175\165\232\139\177\233\155\132\239\188\140\229\183\178\232\135\170\229\138\168\229\136\134\232\167\163\228\184\186"))
      self.ui.res_num:setString("x" .. stoneNum)
      if ed.summonMgr.equipQunty then
        local stoneId = ed.readhero.getStoneid(reward.id)
        ed.summonMgr.equipQunty[stoneId] = (ed.summonMgr.equipQunty[stoneId] or 0) + stoneNum
      end
    end
  end
  local tempWid = self.ui.card_panel:getContentSize().width - self.ui.tips:getContentSize().width - self.ui.res_icon:getContentSize().width - self.ui.res_num:getContentSize().width - 10
  self.ui.tips:setPositionX(tempWid * 0.5)
  ed.right2(self.ui.res_icon, self.ui.tips, 5)
  if self.card_ui then
    self.card_ui.container:removeFromParentAndCleanup(true)
    self.card_ui = nil
  end
  local card_ui = ed.readhero.getHeroCard(reward.id, {
    starType = "init",
    disableswap = true,
    fashion_id = 0
  })
  self.card_ui = card_ui
  local cardNode = card_ui.container
  cardNode:setPosition(self.ui.card:getPosition())
  cardNode:setVisible(false)
  self.ui.card_panel:addChild(cardNode, 2)
  local hero = ed.player:getHero(reward.id)
  local fashion_id
  local star = unitTb["Initial Stars"] or 1
  local bgRes = isDestinySummon and colorBG[5].bg or colorBG[star + 1].bg
  ed.initSpriteWithFrame(self.ui.bg, bgRes)
  ed.layout.lazyAdaptBG(self.ui.bg)
  local addition = isDestinySummon and "destiny" or ed.ui.summonScene.QualityColors[star + 1]
  if self.cardFca then
    self:removeFca(self.cardFca)
    self.cardFca:removeAllChildrenWithCleanup(true)
  end
  local fn = ed.createFcaNode("eff_UI_tavern_card_" .. addition)
  self.ui.card_panel:addChild(fn)
  ed.layout.centerInParent(fn)
  self:addFca(fn)
  fn:setScale(1.5)
  self.cardFca = fn
  
  local function setFashionEffectVisible(visible)
    if not fashion_id then
      return
    end
    for fashion_id, effect_fca in pairs(card_ui.card_fashion_effect or {}) do
      effect_fca:setVisible(visible)
      if visible then
        self:addFca(effect_fca)
      end
    end
    if card_ui.card_fashion_spine then
      card_ui.card_fashion_spine:setVisible(visible)
    end
  end
  
  setFashionEffectVisible(false)
  if self.fbBubbleCard then
    local scalex = self.fbBubbleCard:getScaleX()
    local scaley = self.fbBubbleCard:getScaleY()
    local rand = ed.rand() * 100
    local newScalex = 50 <= rand and scalex * -1 or scalex
    rand = ed.rand() * 100
    local newScaley = 50 <= rand and scaley * -1 or scaley
    if newScalex == scalex and newScaley == scaley then
      rand = ed.rand() * 100
      if rand <= 50 then
        newScalex = scalex * -1
      else
        newScaley = scaley * -1
      end
    end
    self.fbBubbleCard:setScaleX(newScalex)
    self.fbBubbleCard:setScaleY(newScaley)
  end
  if (self.tabName == "normal" or self.tabName == "timely" or self.tabName == "newbie" or self.tabName == "riseStar") and 3 <= star then
    fn:setScale(card_ui.frame:getScale())
    fn:setPosition(cardNode:getPosition())
    fn:setZOrder(2)
    self:listenTimer(Timer:Once(3.7), function()
      self.inPlaying = false
      if tolua.isnull(cardNode) then
        return
      end
      cardNode:setVisible(true)
    end)
    return
  end
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      cardNode:setVisible(true)
      cardNode:runAction(fi)
      if not self.fbBubbleCard then
        local fb = ed.createFcaNode("eff_UI_tavern_bubble")
        self.ui.card_panel:addChild(fb, 1)
        fb:setPosition(self.ui.card:getPosition())
        self:addFca(fb)
        fb:setScale(1.5)
        self.fbBubbleCard = fb
        local rand = ed.rand() * 100
        if rand <= 30 then
          self.fbBubbleCard:setScaleY(-1.5)
        elseif rand <= 70 then
          self.fbBubbleCard:setScaleX(-1.5)
        end
      end
      setFashionEffectVisible(true)
      self.inPlaying = false
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  cardNode:runAction(s)
end

function SummonRewardCardWindow:registerEvents()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "ended" and not self.inPlaying then
        self.inPlaying = true
        if self.showingType == "showCard" then
          local rewards = self.addHero or self.rewards
          local convertIdxs = self.addHero ~= nil and {} or self.convertIdxs
          local reward = rewards[self.idx]
          local isConvert = convertIdxs[self.idx] and true or false
          self.ui.tips:setVisible(isConvert)
          self.ui.res_icon:setVisible(isConvert)
          if isConvert and self.card_ui.container:getScale() == 1 then
            self.card_ui.container:runAction(CCSpawn:createWithTwoActions(CCScaleTo:create(0.2, 0.9), CCMoveBy:create(0.2, ccp(0, 10))))
            self.showingType = nil
            self.inPlaying = false
          else
            self:showContent(reward)
          end
        elseif not self:showNext() then
          if not self.noRewards then
            self:close()
            self:showRewardsList()
          else
            self:close()
          end
        end
      end
    end,
    key = "cardTouch",
    priority = 10
  })
  self:registerBtnClick("btn_share", function()
    self.ui.btn_share:setVisible(false)
    local path = ed.screenshot(self.container, nil)
    ed.share({type = "QQ", path = path})
    self.ui.btn_share:setVisible(true)
  end)
  self:registerBtnClick("btn_skip", function()
    if not ed.guide.data:isCompleted(8) then
      ed.guide.manager:skipGuide(8)
    end
    if not ed.guide.data:isCompleted(9) then
      ed.guide.manager:skipGuide(9)
    end
    self:showRewardsList()
  end)
end

function SummonRewardCardWindow:showRewardsList()
  ed.ui.SummonRewardsWindow.create({
    rewards = self.rewards,
    tabName = self.tabName,
    convertIdxs = self.convertIdxs,
    summonAction = function(times)
      self.doSummon(times)
    end,
    callback = self.callback
  }):popWindow()
  self:close()
end

function SummonRewardCardWindow:registerBtnClick(key, func)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    pressScale = 0.95,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func()
    end,
    clickInterval = 1,
    priority = 9
  }
  self:btRegisterButtonClick(config)
end

function SummonRewardCardWindow:close()
  if self.closeCallback then
    self.closeCallback()
  end
  self:destroy({skipAnim = true})
  CloseScope(SummonRewardCardWindow.eventScope)
end
