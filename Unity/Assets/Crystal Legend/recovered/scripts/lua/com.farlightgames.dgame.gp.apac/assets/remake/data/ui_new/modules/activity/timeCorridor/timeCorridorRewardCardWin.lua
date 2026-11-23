local base = ed.ui.popwindow
local timeCorridorRewardCardWin = newclass(base.mt)
ed.ui.timeCorridorRewardCardWin = timeCorridorRewardCardWin
local lsr = ed.ui.popherocardlsr.create()

function timeCorridorRewardCardWin.create(params)
  local self = base.create("timeCorridorRewardCardWin")
  setmetatable(self, timeCorridorRewardCardWin.mt)
  timeCorridorRewardCardWin.eventScope = {}
  self:initData(params)
  self:initView()
  self:addEventListener()
  self:show()
  return self
end

function timeCorridorRewardCardWin:initData(params)
  self.rewards = params.rewards or {}
  self.summonAction = params.summonAction
  self.closeAction = params.closeAction
  self.smashMap = params.smashMap
  self.callback = params.callback
  self.newFashion = params.newFashion
  self.showRewardsList = self.rewards
  if self.newFashion then
    self.showRewardsList = self.newFashion
  end
  self.rewardInd = 1
  self.timerTbl = {}
end

function timeCorridorRewardCardWin:initView()
  local container, ui = ed.editorui(ed.uieditor.timeCorridorRewardCardWin)
  self.container:addChild(container)
  self.ui = ui
  ed.layout.layoutWithMagin(self.ui.btn_skip, {top = 0, right = 0})
  local rotate = CCRotateBy:create(5, 370)
  self.ui.get_skin_light:runAction(CCRepeatForever:create(rotate))
  local getLab = ed.ui.gradientLabel.create({
    text = T("\230\129\173\229\150\156\232\142\183\229\190\151"),
    fontName = ed.fontBold,
    fontSize = 33,
    startColor = ed.toccc3(16776946),
    endColor = ed.toccc3(16775073),
    strokeColor = ed.toccc3(10504457),
    strokeSize = 1.5
  })
  ed.UITool.replaceUINew(ui, "label_title", getLab.node)
  ed.setLabelStroke(self.ui.label_skip, ed.toccc3(3483679), 1)
  ed.setLabelStroke(self.ui.content_decomp_tip, ed.toccc3(3483156), 1)
  ed.setLabelStroke(self.ui.content_decomp_num, ed.toccc3(3483156), 1)
  ed.setLabelStroke(self.ui.fashion_decomp_tip, ed.toccc3(3483156), 1)
  ed.setLabelStroke(self.ui.fashion_decomp_num, ed.toccc3(3483156), 1)
  ed.setLabelFontName(self.ui.label_name, ed.fontBold)
  ed.setLabelFontName(self.ui.label_fashion_name, ed.fontBold)
  ed.setLabelStroke(self.ui.label_fashion_name, ed.toccc3(16775110), 1)
  self:showNext()
end

function timeCorridorRewardCardWin:showNext()
  if self.rewardInd > #self.showRewardsList then
    self:closeWin()
    return
  end
  local reward = self.showRewardsList[self.rewardInd]
  local isSmash = self.smashMap[self.rewardInd]
  local rewardId = reward._id
  local isFashion = ed.isElementInTable(ed.readequip.value(rewardId, "Consume Type"), {"\231\154\174\232\130\164"})
  local isNewFashion = isFashion and not isSmash
  local bgRes = ed.getFashionFrameResByQuality(ed.readequip.value(rewardId, "Quality"), "fashionRewardCardBg")
  ed.initSpriteWithFrame(self.ui.bg, bgRes)
  ed.layout.lazyAdaptBG(self.ui.bg)
  self.ui.btn_skip:setVisible(not isFashion)
  self.ui.content_panel:setVisible(not isFashion)
  self.ui.fashion_panel:setVisible(isFashion)
  local cardNode = isFashion and self.ui.fashion_panel or self.ui.content_panel
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
  local delay = CCDelayTime:create(0.4)
  local f = CCCallFunc:create(function()
    xpcall(function()
      local fi = CCFadeIn:create(0.2)
      cardNode:setVisible(true)
      cardNode:runAction(fi)
      if not self.fbBubble then
        local fb = ed.createFcaNode("eff_UI_tavern_bubble")
        self.ui.content_panel:addChild(fb, -1)
        fb:setPosition(self.ui.pos:getPosition())
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
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(delay, f)
  cardNode:runAction(s)
  if isFashion then
    self:showFashion(reward, isSmash)
  else
    self:showContent(reward, isSmash)
  end
  self.rewardInd = self.rewardInd + 1
end

function timeCorridorRewardCardWin:showFashion(reward, isSmash)
  self.showingType = "showFashion"
  self.ui.puppet_pos:removeAllChildrenWithCleanup(true)
  self.ui.fashion_decomp:setVisible(false)
  self.isPlaying = true
  if isSmash then
    self.ui.fashion_decomp_num:setString("+" .. ed.timeCorridorMgr:getRewardSmashNumById(reward._id))
    ed.layout.horizontalSortNode({
      self.ui.fashion_decomp_tip,
      self.ui.fashion_decomp_icon,
      self.ui.fashion_decomp_num
    }, {
      8,
      2,
      0
    }, self.ui.fashion_decomp:getContentSize().width * 0.5)
  end
  self.hid = nil
  self.fashionId = nil
  self.actor = nil
  self.fashionId = ed.getDataTable("equip")[reward._id]["Fashion ID"]
  self.hid = ed.lookupDataTable("Fashion", "Hero ID", self.fashionId)
  local name = ed.lookupDataTable("Fashion", "Name", self.fashionId)
  self.ui.fashion_name_label:setString(name)
  local puppet_id = ed.lookupDataTable("Fashion", "Puppet", self.fashionId)
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local comps = info["Change Components"]
  local actor2, cha2
  local actor, cha = ed.readhero.getActor(self.hid, "Move", true, false)
  actor:setPosition(ccp(0, -60))
  self:addFca(actor)
  self.ui.puppet_pos:addChild(actor, 5)
  local actor2, cha2 = ed.readhero.getActor(self.hid, "Move", true, false, self.fashionId)
  actor2:setPosition(ccp(0, -60))
  self:addFca(actor2)
  self.ui.puppet_pos:addChild(actor2, 5)
  actor2:setVisible(false)
  local sound = ed.lookupDataTable("Fashion", "Voice Ready", self.fashionId)
  ed.playEffect(sound)
  self.timerTbl[1] = self:listenTimer(Timer:Once(1), function()
    actor:setAction("Idle")
    actor:setLoop(false)
    local rootPos = ccp(0, -60)
    self:listenTimer(Timer:Once(1.3), function()
      local sprBehind = ed.createFcaNode("eff_UI_hero_awake")
      sprBehind:setPosition(rootPos)
      self:addFca(sprBehind)
      self.ui.puppet_pos:addChild(sprBehind)
    end)
    local sprFront = ed.createFcaNode("eff_UI_hero_awake2")
    sprFront:setPosition(rootPos)
    self:addFcaOnce(sprFront)
    self.ui.puppet_pos:addChild(sprFront, 115)
    self.timerTbl[2] = self:listenTimer(Timer:Once(0.5), function()
      actor2:setVisible(true)
      actor2:setAction("Cheer")
      actor:setVisible(false)
    end)
    self.timerTbl[3] = self:listenTimer(Timer:Once(self.getDuration(actor, cha, "Idle")), function()
      local changeFcaName = "Rage"
      if comps and 0 < #comps then
        changeFcaName = "Cheer"
        actor:setAction(changeFcaName)
        actor:setLoop(true)
      else
        changeFcaName = "Idle"
      end
      self.isPlaying = nil
      if isSmash then
        self.ui.fashion_decomp:setVisible(true)
        self.ui.btn_skip:setVisible(true)
      end
      self.timerTbl[4] = self:listenTimer(Timer:Once(self.getDuration(actor, cha, changeFcaName)), function()
        self.actor = actor
      end)
    end)
  end)
end

function timeCorridorRewardCardWin:showContent(reward, isSmash)
  self.showingType = "showContent"
  self.ui.pos:removeAllChildrenWithCleanup(true)
  self.ui.content_decomp:setVisible(false)
  self.isPlaying = true
  local icon = ed.readequip.createIconWithAmount(reward._id, 95, reward._amount)
  self.ui.pos:addChild(icon, 10)
  icon:setVisible(false)
  local name = ed.readequip.value(reward._id, "Name")
  self.ui.label_name:setString(name)
  if isSmash then
    self.ui.content_decomp_num:setString("+" .. ed.timeCorridorMgr:getRewardSmashNumById(reward._id))
    ed.layout.horizontalSortNode({
      self.ui.content_decomp_tip,
      self.ui.content_decomp_icon,
      self.ui.content_decomp_num
    }, {
      8,
      2,
      0
    }, self.ui.content_decomp:getContentSize().width * 0.5)
  end
  local shadow = ed.createSprite("UI/alpha/1080P/summon/tavern_get_item_bg_light_white.png")
  shadow:setPosition(0, 200)
  shadow:setScale(0)
  local duration = 0.3
  local scaleTo = CCEaseSineOut:create(CCScaleTo:create(duration, 2))
  local moveTo = CCEaseSineOut:create(CCMoveTo:create(duration, ccp(0, 0)))
  local rotateBy = CCEaseSineOut:create(CCRotateBy:create(duration, 720))
  local array = ccArrayMake(scaleTo, moveTo, rotateBy)
  local spawn = CCSpawn:create(array)
  local func = CCCallFunc:create(function()
    xpcall(function()
      icon:setVisible(true)
      self.isPlaying = nil
      shadow:setVisible(false)
      if isSmash then
        self.ui.content_decomp:setVisible(true)
      end
    end, EDDebug)
  end)
  shadow:runAction(CCSequence:create(ccArrayMake(spawn, CCDelayTime:create(0.1), func)))
  self.ui.pos:addChild(shadow)
  ed.playEffect(ed.sound.deo.summon_get_item)
end

function timeCorridorRewardCardWin:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "ended" and not self.isPlaying then
        self:showNext()
      end
    end,
    key = "screenTouch",
    priority = 10
  })
  self:registerBtnClick("btn_skip", function()
    self:closeWin()
  end)
end

function timeCorridorRewardCardWin:registerBtnClick(key, func)
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

function timeCorridorRewardCardWin:closeWin()
  ed.ui.timeCorridorRewardsWin.create({
    rewards = self.rewards,
    smashMap = self.smashMap,
    summonAction = self.summonAction
  })
  self:destroy({skipAnim = true})
  CloseScope(timeCorridorRewardCardWin.eventScope)
end

local function getDuration(actor, cha, name)
  local row = ed.getDataTable("AnimDuration")[cha]
  local dur = 1
  for k, v in pairs(row or {}) do
    if name and k == name then
      return v.Duration
    end
  end
  for k, v in pairs(row or {}) do
    if k == "Cheer" then
      return v.Duration
    end
  end
  return dur
end

timeCorridorRewardCardWin.getDuration = getDuration
