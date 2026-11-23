local base = ed.ui.popwindow
local summonRiseStarRecommendWin = newclass(base.mt)
ed.ui.summonRiseStarRecommendWin = summonRiseStarRecommendWin
local Card_Pos_Config = {
  [3] = {
    bg_group_1 = {
      pos = ccp(253.5, 266)
    },
    bg_group_2 = {
      pos = ccp(482, 265.5)
    },
    bg_group_3 = {
      pos = ccp(709.5, 266.5)
    }
  },
  [4] = {
    bg_group_1 = {
      pos = ccp(388.5, 254)
    },
    bg_group_2 = {
      pos = ccp(607, 272.5)
    },
    bg_group_3 = {
      pos = ccp(824, 254.5)
    }
  }
}
local Top_Color_Config = {
  [1] = {
    startColor = ed.toccc3(15728537),
    endColor = ed.toccc3(16777215),
    strokeColor = ed.toccc3(12529416)
  },
  [2] = {
    startColor = ed.toccc3(16710720),
    endColor = ed.toccc3(16711656),
    strokeColor = ed.toccc3(11033603)
  },
  [3] = {
    startColor = ed.toccc3(16768082),
    endColor = ed.toccc3(16775300),
    strokeColor = ed.toccc3(7733447)
  }
}

function summonRiseStarRecommendWin.create(param)
  local self = base.create("summonRiseStarRecommendWin", {layer_opacity = 229})
  setmetatable(self, summonRiseStarRecommendWin.mt)
  self:init(param)
  self:popWindow()
  self:show()
  return self
end

function summonRiseStarRecommendWin:init(param)
  param = param or {}
  self:initView()
  self:addEventListener()
end

function summonRiseStarRecommendWin:initView()
  ed.editorui(ed.uieditor.summonRiseStarRecommendWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local isExistNew = nil ~= ed.summonMgr.riseStarNewestHeroId
  local uiConfig = Card_Pos_Config[isExistNew and 4 or 3]
  for k, v in pairs(uiConfig) do
    local node = self.ui[k]
    if v.pos then
      node:setPosition(v.pos)
    end
  end
  for i, v in ipairs(ed.summonMgr.riseStarHeroList) do
    self:updateHeroCard(i, v._hero_id)
  end
  if isExistNew then
    self:updateHeroCard(0, ed.summonMgr.riseStarNewestHeroId)
  end
  self.ui.bg_group_0:setVisible(isExistNew)
end

function summonRiseStarRecommendWin:initLabels()
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\230\152\159\232\190\137\229\143\172\229\148\164\230\142\168\232\141\144"),
    fontSize = 45.5,
    fontName = ed.fontBold,
    startColor = ed.toccc3(14018047),
    endColor = ed.toccc3(16768759),
    strokeSize = 1,
    strokeColor = ed.toccc3(1769664)
  })
  self.ui.bg_title_light:addChild(titleLabel.node)
  local bgSize = self.ui.bg_title_light:getContentSize()
  titleLabel.node:setPosition(bgSize.width * 0.5 + 3, bgSize.height * 0.5)
  self.closeCountTime = 3
  self:updateTipFunc()
  self:listenTimer(Timer:Always(1), function()
    if self.closeCountTime > 0 then
      self.closeCountTime = self.closeCountTime - 1
      self:updateTipFunc()
    end
  end)
end

function summonRiseStarRecommendWin:updateTipFunc()
  if self.closeCountTime > 0 then
    ed.setLabelString(self.ui.label_close_tip, T("%d\231\167\146\229\144\142\231\130\185\229\135\187\228\187\187\230\132\143\229\140\186\229\159\159\229\133\179\233\151\173", self.closeCountTime))
  else
    ed.setLabelString(self.ui.label_close_tip, T("\231\130\185\229\135\187\228\187\187\230\132\143\229\140\186\229\159\159\229\133\179\233\151\173"))
  end
end

function summonRiseStarRecommendWin:createHeroCard(index, id)
  local maskRes = 0 == index and "UI/alpha/1080P/summonbeginner/banner/recommend_card_new.png" or "UI/alpha/1080P/summonbeginner/banner/recommend_card.png"
  local fashionId
  if fashionId and 0 < fashionId then
    local cardres = ed.lookupDataTable("Fashion", "Art Switch", fashionId)
    local cardNode, ci = ed.createClippingNode(cardres, maskRes, nil, CCSizeMake(-20, -8))
    local stencil = cardNode:getStencil()
    stencil:setScale(1)
    local offsetY = -20
    local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashionId)
    local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashionId)
    if fashion_effect_res and fashionId == 13 and not ed.isAreaZhCn() then
      fashion_effect_res = fashion_effect_res .. "_globe"
    end
    ci:setScale(0.7)
    ci:setPositionY(offsetY)
    local size = ci:getContentSize()
    if fashion_spine_res and ed.isSupportSpine() then
      local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, size.height / 928)
      spine:setAnimation(0, "Idle", true)
      ci:addChild(spine)
    elseif fashion_effect_res then
      local effect_fca = ed.createFcaActor(fashion_effect_res)
      effect_fca:setLoop(true)
      effect_fca:setAction("Loop")
      ci:addChild(effect_fca, 5)
      effect_fca:setPosition(size.width / 2, size.height / 2)
      self:addFca(effect_fca)
    end
    local fashion_plist_res = ed.lookupDataTable("Fashion", "Plist", fashionId)
    if fashion_plist_res then
      local particle = CCParticleSystemQuad:create("UI/particle/" .. fashion_plist_res)
      ci:addChild(particle, 6)
      particle:setPosition(size.width / 2, size.height / 2)
    end
    return cardNode
  else
    local offsetY = -20
    local cardres = ed.getUnitArt(id)
    local cardNode, ci = ed.createClippingNode(cardres, maskRes, nil, CCSizeMake(-10, -8))
    ci:setScale(0.7)
    ci:setPositionY(offsetY)
    local stencil = cardNode:getStencil()
    stencil:setScale(1)
    return cardNode
  end
end

function summonRiseStarRecommendWin:createHeroModel(index, id)
  local fashionId
  local modelNode, cha = ed.readhero.getActor(id, "Idle", true, false, fashionId, false)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = row.Scale * wscale
  end
  modelNode:setScale(scale * 0.6)
  self:addFca(modelNode)
  return modelNode
end

function summonRiseStarRecommendWin:updateHeroCard(index, id)
  local groupBg = self.ui["bg_group_" .. index]
  local bgSize = groupBg:getContentSize()
  local nameKey = "hero_name_" .. index
  local nameNode = self.ui[nameKey]
  if nil ~= nameNode then
    nameNode:removeFromParentAndCleanup(true)
    nameNode = nil
    self.ui[nameKey] = nil
  end
  nameNode = ed.ui.gradientLabel.create({
    text = ed.lookupDataTable("Unit", "Display Name", id),
    fontSize = 20,
    fontName = ed.fontBold,
    startColor = ed.toccc3(4153495),
    endColor = ed.toccc3(7562960)
  })
  groupBg:addChild(nameNode.node)
  nameNode.node:setPosition(bgSize.width * 0.5, 0 == index and 75 or 60)
  self.ui[nameKey] = nameNode.node
  local cardKey = "hero_card_" .. index
  local cardNode = self.ui[cardKey]
  if nil ~= cardNode then
    cardNode:removeFromParentAndCleanup(true)
    cardNode = nil
    self.ui[cardKey] = nil
  end
  cardNode = self:createHeroCard(index, id)
  groupBg:addChild(cardNode, -1)
  cardNode:setPosition(bgSize.width * 0.5, bgSize.height * 0.5 + (0 == index and 25 or 10))
  self.ui[cardKey] = cardNode
  local stageImg = self.ui["bg_stage_" .. index]
  local modelKey = "hero_model_" .. index
  local modelNode = self.ui[modelKey]
  if nil ~= modelNode then
    modelNode:removeFromParentAndCleanup(true)
    modelNode = nil
    self.ui[modelKey] = nil
  end
  modelNode = self:createHeroModel(index, id)
  groupBg:addChild(modelNode)
  local stagePosX, stagePosY = stageImg:getPosition()
  modelNode:setPosition(stagePosX, stagePosY + 5)
  if 0 < index then
    local topKey = "title_top_" .. index
    if nil == self.ui[topKey] then
      local colorConfig = Top_Color_Config[index]
      local topNode = ed.ui.gradientLabel.create({
        text = "Top" .. index,
        fontSize = 22,
        fontName = ed.fontBold,
        startColor = colorConfig.startColor,
        endColor = colorConfig.endColor,
        strokeSize = 1.5,
        strokeColor = colorConfig.strokeColor
      })
      groupBg:addChild(topNode.node)
      topNode.node:setPosition(bgSize.width * 0.5, bgSize.height - 45)
      self.ui[topKey] = topNode.node
    end
  end
end

function summonRiseStarRecommendWin:addEventListener()
  self:btRegisterOutClick({
    area = {
      self.ui.bg_group_1,
      self.ui.bg_group_2,
      self.ui.bg_group_3
    },
    key = "out_click",
    extraCheckHandler = function(x, y)
      if self.ui.bg_group_0:isVisible() and ed.containsPoint(self.ui.bg_group_0, x, y) then
        return false
      end
      return true
    end,
    clickHandler = function()
      if self.closeCountTime > 0 then
        return
      end
      self:destroy()
    end,
    force = true
  })
end
