local base = ed.ui.popwindow
local CupArenaChooseCampWin = newclass(base.mt)
ed.ui.CupArenaChooseCampWin = CupArenaChooseCampWin

function CupArenaChooseCampWin.create()
  local self = base.create("CupArenaChooseCampWin")
  setmetatable(self, CupArenaChooseCampWin.mt)
  self:initAppearence()
  self:registerTouchHandler()
  self:registerEvents()
  return self
end

function CupArenaChooseCampWin:initAppearence()
  ed.editorui(ed.uieditor.CupArenaChooseCampWin, {
    container = self.container,
    ui = self.ui
  })
  self:initEffect()
  self:initTipDes()
end

function CupArenaChooseCampWin:initTipDes()
  local tipBgSize = self.ui.img_tip_bg:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("\233\135\145\232\139\185\230\158\156\228\187\142\229\164\169\232\128\140\233\153\141\239\188\140\229\133\171\228\189\141\229\165\179\231\165\158\228\184\186\229\133\182\231\186\183\228\186\137\228\184\141\228\188\145\239\188\140\232\175\183\230\130\168\229\138\160\229\133\165\229\145\189\229\174\154\228\185\139\229\165\179\231\165\158\233\186\190\228\184\139\239\188\140\228\184\186\229\133\182\228\186\137\229\164\186\232\141\163\232\170\137"),
    fontSize = 21,
    color = ed.toccc3(15782803),
    strokeColor = ed.toccc3(4337191),
    lineSpacing = 4,
    maxWidth = tipBgSize.width - 40
  })
  self.ui.img_tip_bg:addChild(autoText.node)
  local desWidth, desHeight = autoText:getCurContentSize()
  autoText.node:setPosition(ccp((tipBgSize.width - desWidth) * 0.5, (tipBgSize.height + desHeight - autoText:getFirstLineHeight()) * 0.5 - 10))
  self.tipDesLabel = autoText
  local joinLabel = ed.ui.gradientLabel.create({
    text = T("\231\130\185\229\135\187\229\138\160\229\133\165"),
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16580533),
    endColor = ed.toccc3(16769018),
    strokeSize = 2,
    strokeColor = ed.toccc3(7225997)
  })
  self.ui.panel_join:addChild(joinLabel.node)
  local joinPanelSize = self.ui.panel_join:getContentSize()
  joinLabel.node:setPosition(joinPanelSize.width * 0.5 + 3, joinPanelSize.height * 0.5)
  self.joinLabel = joinLabel
end

function CupArenaChooseCampWin:initEffect()
  self.campFcaBg = ed.createFcaNode("eff_UI_Main_Cuparena_Mirror_bg")
  self.campFcaBg:setScale(0.8)
  self.ui.panel_bg:addChild(self.campFcaBg, 0)
  self:addFca(self.campFcaBg)
  self.campFcaBg:setPosition(ccp(0, 0))
  self.campFcaBg:setStartAction("Start")
  self.campFcaBg:setLoopAction("Loop")
  self.campFcaBg:setVisible(false)
  self.campFca = ed.createFcaNode("eff_UI_Main_Cuparena_Mirror")
  self.campFca:setScale(0.8)
  self.ui.panel_bg:addChild(self.campFca, 10)
  self:addFca(self.campFca)
  self.campFca:setPosition(ccp(0, 0))
  self.campFca:setStartAction("Start_1")
  self.campFca:setLoopAction("Loop_1")
  self.ui.panel_join:setZOrder(20)
  self:playAnim()
end

function CupArenaChooseCampWin:onCupArenaEntry(data)
  local campId = data._camp_id or 0
  if campId == 0 then
    ed.showToast(T("\230\156\170\231\159\165\233\148\153\232\175\175"))
    return
  end
  self.isAniming = true
  self.ui.panel_join:setVisible(false)
  if self.campFca then
    self.campFca:setAction("Start_2")
    self.campFca:setLoopAction("Loop_2")
  end
  self:listenTimer(Timer:Once(2), function()
    self:initCampInfo(campId)
  end)
  self:listenTimer(Timer:Once(7), function()
    self.ui.img_tip_bg:setVisible(false)
    self:playEnterAnim()
  end)
end

function CupArenaChooseCampWin:initCampInfo(campId)
  if nil ~= self.campFcaBg then
    self.campFcaBg:setVisible(true)
  end
  local campTable = ed.getDataTable("CupArenaCamp")[campId]
  if nil ~= self.tipDesLabel then
    local tipBgSize = self.ui.img_tip_bg:getContentSize()
    self.tipDesLabel:initParam({
      context = string.format(campTable["Camp Describe"], string.format("<lable color=ccc3(248,128,255)>%s</lable>", campTable["Camp Name"])),
      fontSize = 21,
      color = ed.toccc3(15782803),
      strokeColor = ed.toccc3(4337191),
      strokeSize = 1,
      lineSpacing = 4,
      maxWidth = tipBgSize.width - 40
    })
    local desWidth, desHeight = self.tipDesLabel:getCurContentSize()
    self.tipDesLabel.node:setPosition(ccp((tipBgSize.width - desWidth) * 0.5, (tipBgSize.height + desHeight) * 0.5 - self.tipDesLabel:getFirstLineHeight()))
  end
  local fashionId
  local heroID = campTable["Camp Hero ID"]
  if fashionId and 0 < fashionId then
    local cardres = ed.lookupDataTable("Fashion", "Art Switch", fashionId)
    local card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/cuparena/cuparena_mirror.png")
    ci:setScale(0.5)
    ci:setPositionY(-20)
    local stencil = card:getStencil()
    stencil:setScale(1)
    local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashionId)
    local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashionId)
    if fashion_effect_res and fashionId == 13 and not ed.isAreaZhCn() then
      fashion_effect_res = fashion_effect_res .. "_globe"
    end
    if fashion_spine_res and ed.isSupportSpine() then
      local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, height / 928)
      spine:setAnimation(0, "Idle", true)
      local size = ci:getContentSize()
      spine:setPosition(-size.width / 2, -size.height / 2 - 20)
      card:addChild(spine)
      spine:setScale(0.5)
      ui.card_fashion_spine = spine
    elseif fashion_effect_res then
      local effect_fca = ed.createFcaActor(fashion_effect_res)
      effect_fca:setLoop(true)
      effect_fca:setAction("Loop")
      card:addChild(effect_fca, 5)
      effect_fca:setScale(0.5)
      effect_fca:setPositionY(-20)
      self:addFca(effect_fca)
    end
    local fashion_plist_res = ed.lookupDataTable("Fashion", "Plist", fashionId)
    if fashion_plist_res then
      local particle = CCParticleSystemQuad:create("UI/particle/" .. fashion_plist_res)
      particle:setScale(0.5)
      particle:setPositionY(-20)
      card:addChild(particle, 6)
    end
    self.ui.panel_bg:addChild(card, 5)
    card:setPosition(ccp(2, -23))
    card:setScale(1.6)
  else
    local cardres = ed.getUnitArt(heroID)
    local card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/cuparena/cuparena_mirror.png")
    ci:setScale(0.5)
    ci:setPositionY(-20)
    local stencil = card:getStencil()
    stencil:setScale(1)
    self.ui.panel_bg:addChild(card, 5)
    card:setPosition(ccp(2, -23))
    card:setScale(1.6)
  end
end

function CupArenaChooseCampWin:playEnterAnim(callback)
  self.ui.panel_bg:stopAllActions()
  local scaleBy = CCScaleBy:create(0.6, 4)
  scaleBy = CCEaseIn:create(scaleBy, 1)
  local fadeOut = CCFadeOut:create(0.5)
  local spAction1 = CCSpawn:create(ccArrayMake(scaleBy, fadeOut))
  self.ui.panel_bg:runAction(spAction1)
  local lightLayer = CCLayerColor:create(ccc4(255, 255, 255, 255))
  self.mainLayer:addChild(lightLayer, 999)
  lightLayer:setOpacity(0)
  lightLayer:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.6), CCCallFunc:create(function()
    ed.CupArenaNetwork:sendOpenPanel(true, true)
  end)))
end

function CupArenaChooseCampWin:playAnim(...)
  self.ui.panel_bg:stopAllActions()
  local upAction = CCMoveBy:create(1.5, ccp(0, 8))
  local downAction = upAction:reverse()
  local moveAction = CCSequence:createWithTwoActions(upAction, downAction)
  moveAction = CCRepeatForever:create(moveAction)
  self.ui.panel_bg:runAction(moveAction)
end

function CupArenaChooseCampWin:registerTouchHandler()
  ed.UITool.registerBtn(self, "panel_join", function()
    ed.CupArenaNetwork:sendEntryRace()
  end)
  self:btRegisterOutClick({
    area = self.ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      if self.isAniming then
        return
      end
      self:destroy()
    end,
    force = true
  })
end

function CupArenaChooseCampWin:registerEvents()
  self:listenEvent("EventCupArenaEntry", function(data)
    self:onCupArenaEntry(data)
  end)
  self:listenEvent("EventCupArenaAuditionOpenPanel", function(data)
    self:destroy({skipAnim = true})
  end)
end
