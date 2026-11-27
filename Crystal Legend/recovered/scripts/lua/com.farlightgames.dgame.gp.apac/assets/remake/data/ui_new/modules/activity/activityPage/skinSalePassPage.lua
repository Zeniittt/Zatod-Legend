local class = newclass("g")
ed.ui.skinSalePassPage = class
class.SKIN_QUALITY_TO_CONFIG = {
  [5] = {
    nameBgPath = "UI/alpha/1080P/activity/skin_sale/skin_sale_rank_5.png",
    framePath = "UI/alpha/1080P/activity/skin_sale/skin_sale_rankframe_5.png"
  },
  [7] = {
    nameBgPath = "UI/alpha/1080P/activity/skin_sale/skin_sale_rank_7.png",
    framePath = "UI/alpha/1080P/activity/skin_sale/skin_sale_rankframe_7.png"
  }
}

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.param = param or {}
  self.pageKey = pageKey or ""
  self:initData()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:setButtonClick()
end

function class:initData()
  self.buyRank = 1
  self.simplePassId = self.param._simple_pass_id
  self.simplePassConfig = ed.getDataTable("SimplePass")[self.simplePassId]
  self.fashionItemId = self.simplePassConfig["Extra AN"][1]
  self.puppetScale = self.simplePassConfig["Extra AN"][2] or 1
  self.fashionId = ed.getDataTable("equip")[self.fashionItemId]["Fashion ID"]
  self.price = self.simplePassConfig[string.format("R%s Price Value", self.buyRank)]
  self.openTime = ed.dateStringToTime(self.simplePassConfig.OpenTime)
  self.endTime = self.openTime + self.simplePassConfig.DuringHour * 3600
end

function class:setButtonClick()
  ed.passNetWork:simplePassOpenPanel(self.simplePassId)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.skin_sale_pass_page)
  self.container = container
  self.ui = ui
  self:adaptUI()
  self:initLabel()
  self:initDragList()
  self:initHeroCard()
  self:initDisplayHero()
  self:refreshView()
end

function class:adaptUI()
  local offsetWidth = ed.display.winSize.width - 960
  self.ui.panel_hero_card:setPositionX(self.ui.panel_hero_card:getPositionX() - offsetWidth * 0.35)
end

function class:initLabel()
  ed.setLabelStroke(self.ui.label_skin_name, ed.toccc3(3612734), 1.5)
  self.ui.label_skin_name:setFontName(ed.fontBold)
  self.ui.label_skin_name:setHorizontalAlignment(kCCVerticalTextAlignmentCenter)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(3611185), 1)
  ed.setLabelStroke(self.ui.label_reward_title, ed.toccc3(4533522), 1)
  ed.setLabelStroke(self.ui.label_buy, ed.toccc3(8210442), 1.5)
  self.ui.label_reward_title:limitWidthByScale(240)
  local titleText = self.simplePassConfig["Extra Str"][1]
  local title = ed.ui.gradientLabel.create({
    text = titleText,
    fontSize = 67.5,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16775668),
    endColor = ed.toccc3(16769974),
    strokeSize = 3,
    strokeColor = ed.toccc3(9714958)
  })
  self.ui.title_bg:addChild(title.node)
  title.node:setPosition(ccp(227, 80))
  title.node:setScale(math.min(1, (self.ui.title_bg:getContentSize().width + 40) / title.node:getContentSize().width))
  ed.setLabelString(self.ui.label_buy, T("%s\232\167\163\233\148\129", ed.RechargeManager:getCostDisplayByCNYCost(self.price)))
  self.ui.label_buy:limitWidthByScale(160)
end

function class:initHeroCard()
  local quality = ed.lookupDataTable("Fashion", "Quality", self.fashionId)
  local qualityConfig = self.SKIN_QUALITY_TO_CONFIG[quality]
  if qualityConfig then
    ed.setTexture(self.ui.hero_card_frame, qualityConfig.framePath)
    ed.setTexture(self.ui.skin_name_bg, qualityConfig.nameBgPath)
  end
  local qualityBg = ed.getFashionFrameRes(self.fashionId, "qualityBg")
  ed.setTexture(self.ui.quality_bg, qualityBg)
  local createLabelQualityFunc = ed.createFashionFrameName(quality)
  local qualityLabel = createLabelQualityFunc(self.ui.quality_bg, ccp(27.5, 27.5), 18)
  qualityLabel:limitWidthByScale(45)
  local skinName = ed.lookupDataTable("Fashion", "Name", self.fashionId)
  ed.setLabelString(self.ui.label_skin_name, skinName)
  if ed.isAreaZh() then
    self.ui.label_skin_name:setDimensions(CCSizeMake(19, 0))
    self.ui.skin_name_bg:setRotation(0)
    self.ui.label_skin_name:setRotation(0)
    self.ui.quality_bg:setRotation(0)
    self.ui.skin_name_bg:setPosition(ccp(4.25, 300.5))
    self.ui.label_skin_name:setPosition(ccp(22.5, 99.75))
    self.ui.quality_bg:setPosition(ccp(22.5, 20.25))
  else
    self.ui.label_skin_name:setDimensions(CCSizeMake(0, 0))
    self.ui.skin_name_bg:setRotation(90)
    self.ui.label_skin_name:setRotation(-90)
    self.ui.quality_bg:setRotation(-90)
    self.ui.skin_name_bg:setPosition(ccp(86, 55.5))
    self.ui.label_skin_name:setPosition(ccp(22.5, 99.75))
    self.ui.quality_bg:setPosition(ccp(22.5, 20.25))
    ed.adaptLabel(self.ui.label_skin_name, {maxWidth = 120, minScale = 0.8})
  end
  local panelSize = self.ui.panel_card_clip:getContentSize()
  self.ui.panel_card_clip:setClipRect(CCRectMake(0, 0, panelSize.width, panelSize.height))
  local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", self.fashionId)
  local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", self.fashionId)
  if fashion_effect_res and self.fashionId == 13 and not ed.isAreaZhCn() then
    fashion_effect_res = fashion_effect_res .. "_globe"
  end
  local art_switch_res = ed.lookupDataTable("Fashion", "Art Switch", self.fashionId)
  if fashion_spine_res and ed.isSupportSpine() then
    local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, panelSize.width / 530)
    spine:setAnimation(0, "Idle", true)
    self.ui.panel_card_clip:addChild(spine)
  else
    if art_switch_res then
      local cardBg = ed.createSprite(art_switch_res)
      self.ui.panel_card_clip:addChild(cardBg)
      ed.layout.centerInParent(cardBg)
    end
    if fashion_effect_res then
      local effect_fca = ed.createFcaActor(fashion_effect_res)
      effect_fca:setLoop(true)
      effect_fca:setAction("Loop")
      effect_fca:setPosition(panelSize.width / 2, panelSize.height / 2)
      self:addFca(effect_fca)
      self.ui.panel_card_clip:addChild(effect_fca)
    end
  end
end

function class:initDisplayHero()
  local heroId = ed.lookupDataTable("Fashion", "Hero ID", self.fashionId)
  local puppet, cha = ed.readhero.getActor(heroId, "Idle", true, false, self.fashionId, false)
  self:addFca(puppet)
  self.puppet = puppet
  self.puppet:setScale(self.puppetScale)
  self.ui.panel_hero_pos:addChild(puppet)
  puppet:setPositionX(self.ui.panel_hero_pos:getContentSize().width / 2)
  local actions = {}
  local row = ed.getDataTable("AnimDuration")[cha]
  for k, v in pairs(row or {}) do
    if not ed.isElementInTable(k, {"Idle"}) then
      table.insert(actions, {
        act = k,
        time = v.Duration
      })
    end
  end
  self.actions = actions
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.reward_list, {priority = -300})
end

function class:refreshView()
  self:refreshBuyBtn()
  self:refreshRewardList()
  self:refreshTime()
end

function class:refreshBuyBtn()
  if ed.passDataMgr:getPassRank(self.simplePassId) >= 1 then
    self.ui.btn_buy:setVisible(false)
  else
    self.ui.btn_buy:setVisible(true)
  end
end

function class:refreshRewardList()
  local rewardDataList = ed.passDataMgr:getPassRewardList(self.simplePassId)
  self.dragList:clearList()
  local posX, gapX, offsetX = 0, 130, 70
  local layerSize = self.ui.reward_list:getContentSize()
  for requireLevel, rewardData in ipairs(rewardDataList) do
    local rewardItem = self:createRewardItem(requireLevel, rewardData)
    rewardItem:setPosition(ccp(posX + offsetX, 0))
    self.dragList:addItem(rewardItem)
    posX = posX + gapX
  end
  self.dragList:initListWidth(posX)
end

function class:refreshTime()
  local isBuy = ed.passDataMgr:getPassRank(self.simplePassId) >= 1
  if isBuy then
    self.ui.time_bg:setVisible(false)
    return
  end
  self.ui.time_bg:setVisible(true)
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function class:createRewardItem(requireLevel, data)
  local rewardData = data[1]
  local container = CCLayer:create()
  container:setContentSize(CCSizeMake(90, 130))
  local rewardIcon = self:createRewardIcon(rewardData)
  rewardIcon:setScale(1.1)
  container:addChild(rewardIcon)
  rewardIcon:setPosition(ccp(0, 77))
  local dayBg = ed.createSprite("UI/alpha/1080P/activity/skin_sale/day_bg.png")
  local day = ed.createttf(string.format(T("\231\172\172%s\229\164\169"), requireLevel), 22)
  ed.setLabelColor(day, ed.toccc3(16776423))
  ed.setLabelStroke(day, ed.toccc3(4533522), 1)
  dayBg:addChild(day)
  ed.layout.centerInParent(day)
  rewardIcon:addChild(dayBg)
  dayBg:setPosition(ccp(45, -10))
  self:btRegisterButtonClick({
    button = rewardIcon,
    key = "baseReward" .. rewardData.rewardPos .. rewardData.rewardIndex,
    force = true,
    clickHandler = function()
      self:onClickReward(rewardData)
    end
  })
  return container
end

function class:createRewardIcon(rewardData)
  local id = rewardData.rewardId
  local rewardType = rewardData.rewardType
  local amount = rewardData.rewardAmount
  local rewardState = rewardData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = rewardType,
    amount = amount
  })
  if rewardState == ed.passDefine.REWARD_STATE_COMPLETED then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  elseif rewardState == ed.passDefine.REWARD_STATE_LOCK then
    local imageLock = ed.createSprite("UI/alpha/1080P/common/pvp_battle_lock.png")
    icon:addChild(imageLock)
    imageLock:setPosition(ccp(75, 75))
  end
  return icon
end

function class:onClickReward(rewardData)
  if rewardData.rewardState == ed.passDefine.REWARD_STATE_AVAILABLE then
    local param = {
      passId = self.simplePassId,
      isAllReward = false,
      rewardPos = rewardData.rewardPos,
      rewardIndex = rewardData.rewardIndex
    }
    ed.passNetWork:simplePassReq(param)
  else
    ed.ui.packageDetailWin.create({
      id = rewardData.rewardId,
      count = rewardData.rewardAmount,
      type = rewardData.rewardType
    }):popWindow()
  end
end

function class:onClickPuppet()
  if self.isRunningAction then
    return
  end
  local actions = ed.copyProto(self.actions)
  if self.oldIdx then
    table.remove(actions, self.oldIdx)
  end
  self.oldIdx = math.random(1, #actions)
  local action = actions[self.oldIdx].act
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  self.isRunningAction = true
  self:listenTimer(Timer:Once(actions[self.oldIdx].time), function()
    self.puppet:setAction("Idle")
    self.puppet:setLoop(true)
    self.isRunningAction = false
  end)
end

function class:addTouchEvent()
  self:btRegisterButtonClick({
    button = self.ui.btn_buy,
    key = "btn_buy",
    force = true,
    pressScale = 0.95,
    clickHandler = function()
      local buyRank = 1
      ed.passDataMgr:doRechargePass(self.simplePassId, buyRank)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.panel_hero_pos,
    key = "panel_hero_pos",
    force = true,
    mcpMode = true,
    clickHandler = function()
      self:onClickPuppet()
    end
  })
end

function class:addEventListener()
  self:listenEvent("UpdatePassData", function(id)
    if id == self.simplePassId then
      self:refreshView()
    end
  end)
  self:listenEvent("passBuySuccess", function(id, rank)
    if id == self.simplePassId then
      self:refreshView()
    end
  end)
end
