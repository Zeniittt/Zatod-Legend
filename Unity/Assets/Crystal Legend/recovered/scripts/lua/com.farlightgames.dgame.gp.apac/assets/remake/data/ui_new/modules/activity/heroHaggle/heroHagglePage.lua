local heroHagglePage = {}
ed.ui.heroHagglePage = heroHagglePage
local buttonEnum = {
  [1] = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_gray.png",
  [2] = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_orange.png",
  [3] = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_red.png"
}
local processEnum = {
  [1] = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_1.png",
  [2] = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_2.png",
  [3] = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_3.png"
}
local animationMap = {
  [2] = 37,
  [3] = 104,
  [4] = 33,
  [5] = 160,
  [6] = 75,
  [7] = 90
}
local languageTextCN = {
  [1] = "<lable color=ccc3(61,61,61)>\229\143\175\231\171\139\229\141\179\231\160\141%s\229\133\131</lable>",
  [2] = "<lable color=ccc3(61,61,61)>\229\183\174</lable><lable color=ccc3(207,67,118)>%s</lable><sprite src=UI/alpha/1080P/activity/hero_haggle/hero_haggle_item_icon.png><lable color=ccc3(61,61,61)>\229\134\141\231\160\141%s\229\133\131</lable>",
  [3] = "<lable color=ccc3(61,61,61)>\229\183\178\231\160\141%s\229\133\131, \229\183\174</lable><lable color=ccc3(207,67,118)>%s</lable><sprite src=UI/alpha/1080P/activity/hero_haggle/hero_haggle_item_icon.png><lable color=ccc3(61,61,61)>\229\134\141\231\160\141%s\229\133\131</lable>",
  [4] = "<lable color=ccc3(61,61,61)>\229\183\178\231\160\141%s\229\133\131, </lable><lable color=ccc3(61,61,61)>\229\143\175\231\171\139\229\141\179\229\134\141\231\160\141%s\229\133\131</lable>",
  [5] = "<lable color=ccc3(61,61,61)>\229\183\178\231\160\141%s\229\133\131, \233\128\159\233\128\159\230\139\191\228\184\139</lable>"
}
local languageTextOther = {
  [1] = T("<lable color=ccc3(61,61,61)>\229\143\175\231\171\139\229\141\179\231\160\141\228\187\183</lable>"),
  [2] = T("<lable color=ccc3(61,61,61)>\229\183\174</lable><lable color=ccc3(207,67,118)>%s</lable><sprite src=UI/alpha/1080P/activity/hero_haggle/hero_haggle_item_icon.png><lable color=ccc3(61,61,61)>\229\134\141\230\172\161\231\160\141\228\187\183</lable>"),
  [3] = T("<lable color=ccc3(61,61,61)>\229\183\174</lable><lable color=ccc3(207,67,118)>%s</lable><sprite src=UI/alpha/1080P/activity/hero_haggle/hero_haggle_item_icon.png><lable color=ccc3(61,61,61)>\229\134\141\230\172\161\231\160\141\228\187\183</lable>"),
  [4] = T("<lable color=ccc3(61,61,61)>\229\143\175\231\171\139\229\141\179\231\160\141\228\187\183</lable>"),
  [5] = T("<lable color=ccc3(61,61,61)>\232\182\133\229\128\188\228\188\152\230\131\160\239\188\140\233\128\159\233\128\159\230\139\191\228\184\139</lable>")
}
local maxLevel = 5

function heroHagglePage.create(base, param, pageKey)
  local self = {}
  setmetatable(heroHagglePage, {__index = base})
  setmetatable(self, {__index = heroHagglePage})
  self:init(param, pageKey)
  return self
end

function heroHagglePage:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.timeOutClick = false
  self.page_mask = false
  self:initView()
  self:onSendOpenPanel()
  self:addEventClick()
  self:addListenEvent()
end

function heroHagglePage:onSendOpenPanel()
  if self.timeOutClick then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
    return
  end
  ed.heroHaggleNet:sendOpenPanel()
  ed.heroHaggleNet:sendTaskOpenPanel()
end

function heroHagglePage:onSceneEnter()
  if self.timeOutClick then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
    return
  end
  ed.heroHaggleNet:sendTaskOpenPanel()
end

function heroHagglePage:pageUpDate(param)
  if self.timeOutClick then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
    return
  end
  ed.heroHaggleNet:sendOpenPanel()
  ed.heroHaggleNet:sendTaskOpenPanel()
end

function heroHagglePage:registerBtn(btn, key, func, params)
  local config = {
    button = btn,
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function heroHagglePage:addEventClick()
  self:registerBtn(self.ui.btn_hero, "btn_hero", function()
    self:onClickHero()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.btn_fca, "btn_fca", function()
    self:onClickHero()
  end, {pressScale = 0.98})
  self:registerBtn(self.ui.btn_haggle, "btn_haggle", function()
    self:onClickHaggle()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.btn_unlock, "btn_unlock", function()
    self:onClickBuyHero()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.btn_currency, "btn_currency", function()
    self:onClickOpenTask()
  end, {pressScale = 0.95})
  self:registerBtn(self.ui.layer_clickFca, "layer_clickFca", function()
    self:onClickRandomFca()
  end, {pressScale = 0.95})
end

function heroHagglePage:addListenEvent()
  self:listenEvent("EventHeroHaggleOpenPanel", function()
    self:initProcessMap()
    self:refreshHeroPanel()
    self:refreshProgress()
    self:refreshButton()
    self:refreshRedPoint()
    self:updateHaggleNumLabel()
    local buyHeroId = ed.heroHaggleMgr.getInstance():getHaggleBuyHeroId()
    if nil ~= self.ui.eff_UI_Hero_haggle_Minimum then
      self.ui.eff_UI_Hero_haggle_Minimum:setVisible(buyHeroId == 0)
    end
    self:toMaxLevel()
  end)
  self:listenEvent("EventHeroHaggleSelectHero", function()
    self:refreshHeroPanel()
    self:refreshButton()
  end)
  self:listenEvent("EventHeroHagglePrice", function()
    self:onHaggleSuccess()
    self:refreshProgress()
    self:refreshButton()
    self:refreshRedPoint()
  end)
  self:listenEvent("EventHeroHaggleBuyHero", function()
    self:refreshButton()
    self:toMaxLevel()
  end)
  self:listenEvent("EventHeroHaggleUpdateRed", function()
    self:refreshRedPoint()
  end)
  self:listenEvent("EventUpdateHeroHaggleTaskNum", function()
    self:refreshProgress()
    self:refreshRedPoint()
    self:refreshHaggleBtnState()
    self:updateHaggleNumLabel()
  end)
  self:listenEvent("EventUpdateHeroHaggleTaskMsg", function()
    self:pageUpDate()
  end)
  self:listenTimer(Timer:Always(1), function()
    self:updateLeftTime()
  end)
end

function heroHagglePage:initView()
  local container, ui = ed.editorui(ed.uieditor.heroHaggleWin)
  self.container = container
  self.ui = ui
  self:initLabel()
  self:updateLeftTime()
  self:onAddFcaNode()
end

function heroHagglePage:initLabel()
  ed.setLabelColor(self.ui.label_currency1, ed.toccc3(16772996))
  ed.setLabelStroke(self.ui.label_currency1, ed.toccc3(10765376), 1)
  ed.setLabelColor(self.ui.label_currency2, ed.toccc3(16775909))
  ed.setLabelStroke(self.ui.label_currency2, ed.toccc3(10765376), 1)
  for i = 1, 6 do
    ed.setLabelColor(self.ui["label_price" .. i], ed.toccc3(10828855))
    ed.setLabelStroke(self.ui["label_price" .. i], ed.toccc3(16775664), 1)
  end
  ed.setLabelColor(self.ui["label_ BenefitPrice"], ed.toccc3(16443595))
  ed.setLabelColor(self.ui.label_buy, ed.toccc3(16711146))
  ed.setLabelStroke(self.ui.label_buy, ed.toccc3(9056273), 1)
  ed.setLabelColor(self.ui.label_haggle, ed.toccc3(16711146))
  ed.setLabelStroke(self.ui.label_haggle, ed.toccc3(7740716), 1)
  ed.setLabelColor(self.ui.label_title_time, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_title_time, ed.toccc3(9444395), 1)
  ed.setLabelColor(self.ui.label_haggle_done, ed.toccc3(16509388))
  ed.setLabelStroke(self.ui.label_haggle_done, ed.toccc3(7813186), 2)
  ed.setLabelColor(self.ui.label_currency_num, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_currency_num, ed.toccc3(3868680), 2)
  self.ui.image_haggleNum_icon:setScale(1.3)
  self.init_posX = self.ui.btn_unlock:getPositionX()
  self:adaptLanguage()
end

function heroHagglePage:adaptLanguage()
  if ed.isAreaOverSea() then
    ed.setLabelString(self.ui["label_ BenefitPrice"], T("\231\166\143\229\136\169\228\187\183"))
  else
    ed.setLabelString(self.ui["label_ BenefitPrice"], T("\229\145\168\229\185\180\231\166\143\229\136\169\228\187\183"))
  end
  ed.setLabelString(self.ui.label_haggle, T("\231\160\141\228\184\128\229\136\128"))
  ed.setLabelString(self.ui.label_currency1, T("\232\142\183\229\143\150"))
  ed.setLabelString(self.ui.label_currency2, T("\231\140\170\231\140\170\229\184\129"))
  self.ui.label_currency1:limitWidthBySize(64)
  self.ui.label_currency2:limitWidthBySize(70)
  self.ui["label_ BenefitPrice"]:limitWidthBySize(75)
  self.ui.label_haggle:limitWidthBySize(90)
end

function heroHagglePage:updateLeftTime()
  local endTime = ed.heroHaggleMgr.getInstance():getEndTime()
  if endTime then
    local leftTime = endTime - ed.getServerTime()
    if 0 < leftTime then
      ed.setLabelString(self.ui.label_title_time, T("\229\137\169\228\189\153%s", ed.time2dhmsV2(leftTime, true)))
    else
      self.timeOutClick = true
    end
  end
end

function heroHagglePage:refreshHeroPanel()
  local heroId = ed.heroHaggleMgr.getInstance():getSelectHero()
  local state = heroId == nil or heroId == 0
  if not state then
    self:updateHeroCard(heroId)
  end
  self.ui.btn_hero:setVisible(state)
  self.ui.btn_fca:setVisible(not state)
end

function heroHagglePage:updateHeroCard(hid)
  local card = ed.readhero.getHeroCardByNormal(hid, {
    hide_star = true,
    starType = "init",
    OriSize = true
  })
  local card_ui = card.container
  card_ui:setScale(0.8)
  card_ui:setZOrder(2)
  self.ui.layer_fca:addChild(card_ui)
  self.ui.card = card_ui
  for fashion_id, effect_fca in pairs(card.card_fashion_effect or {}) do
    self:addFca(effect_fca)
  end
  local cardSize = self.ui.layer_fca:getContentSize()
  card_ui:setPosition(ccp(5, -80))
  self.ui.layer_fca:setClipRect(CCRectMake(0, 0, cardSize.width, cardSize.height))
  if self.puppet then
    self.puppet:removeFromParentAndCleanup(true)
    self.puppet = nil
  end
  ed.asyncload.unregistLoadingListener()
  ed.asyncload.preloadFcaByUnitID(hid)
  ed.asyncload.registLoadingListener(function()
    local puppet, cha = ed.readhero.getActor(hid, "Idle", true, false, nil, false)
    local row = ed.getDataTable("Puppet")[cha]
    local scale = row.Scale
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = scale * wscale
    end
    puppet:setScale(scale)
    puppet:setPosition(ccp(100, 0))
    self.ui.layer_art_fca:addChild(puppet, 10)
    self:addFca(puppet)
    self.puppet = puppet
    self.cha = row.Resource
    self.action_pre = "Idle"
    local isSpine = string.match(self.cha, "%.sp$")
    if not isSpine then
      self.cha = self.cha .. ".cha"
    end
  end)
end

function heroHagglePage:getCostItemNum()
  local num = ed.player:getEquipAmount(self.costItemId)
  if num > self.haggleShowMax then
    num = self.haggleShowMax
  end
  return num
end

function heroHagglePage:getHaggleNum()
  local buyHeroId = ed.heroHaggleMgr.getInstance():getHaggleBuyHeroId()
  if buyHeroId ~= 0 then
    return maxLevel
  end
  return ed.heroHaggleMgr.getInstance():getHaggleNum()
end

function heroHagglePage:isHaggleMax()
  local haggleNum = self:getHaggleNum()
  return haggleNum == maxLevel
end

function heroHagglePage:canHaggle()
  local haveItemNum = self:getCostItemNum()
  local haggleNum = self:getHaggleNum()
  if haggleNum == maxLevel then
    return false
  end
  local haggleConfig = self.haggleMap[haggleNum + 1]
  local amount
  if haggleConfig then
    amount = haggleConfig.costNum
    if haveItemNum >= amount then
      return true
    end
  end
  return false
end

function heroHagglePage:initProcessMap()
  local seasonId = ed.heroHaggleMgr.getInstance():getCurrentSeasonId()
  self.costItemId = ed.heroHaggleMgr.getInstance():getCostItem()
  self.initPos = ed.getWorldPos(self.ui["step" .. 1])
  self.haggleMap = {}
  for i = 1, 6 do
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][i]
    if lineConfig then
      ed.setString(self.ui["label_price" .. i], ed.RechargeManager:getCostDisplayByCNYCost(lineConfig["Price Before"]))
    else
      ed.setString(self.ui["label_price" .. i], ed.RechargeManager:getCostDisplayByCNYCost(ed.getDataTable("HeroHaggleLine")[seasonId][i - 1]["Price After"]))
    end
  end
  local costAmount = 0
  for haggleNum = 1, 6 do
    local worldPos = ed.getWorldPos(self.ui["step" .. haggleNum])
    if haggleNum == 6 then
      self.haggleMap[haggleNum] = {
        costNum = costAmount,
        stepNum = 0,
        pos = worldPos
      }
    else
      local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][haggleNum]
      costAmount = costAmount + lineConfig["Require Item Amount"]
      self.haggleMap[haggleNum] = {
        costNum = costAmount,
        stepNum = lineConfig["Require Item Amount"],
        pos = worldPos
      }
    end
  end
  self.haggleShowMax = costAmount
  self.progressWidth = 1092
  self:updateProgress()
end

function heroHagglePage:refreshButton()
  local seasonId = ed.heroHaggleMgr.getInstance():getCurrentSeasonId()
  local haggleNum = self:getHaggleNum()
  local targetNum = haggleNum + 1
  if targetNum < 6 then
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][targetNum]
    ed.setString(self.ui.label_buy, string.format(T("%s\229\133\131\232\167\163\233\148\129"), ed.RechargeManager:getCostDisplayByCNYCost(lineConfig["Price Before"])))
  else
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][maxLevel]
    ed.setString(self.ui.label_buy, string.format(T("%s\229\133\131\232\167\163\233\148\129"), ed.RechargeManager:getCostDisplayByCNYCost(lineConfig["Price After"])))
  end
  self.ui.label_buy:limitWidthBySize(90)
  self:refreshHaggleBtnState()
  local buyHeroId = ed.heroHaggleMgr.getInstance():getHaggleBuyHeroId()
  if buyHeroId == 0 then
    if haggleNum == maxLevel then
      self.ui.btn_unlock:setPositionX(self.init_posX + 150)
      self.ui.btn_unlock:setVisible(true)
      self.ui.btn_haggle:setVisible(false)
      self.ui.btn_haggle_done:setVisible(false)
    else
      self.ui.btn_unlock:setVisible(buyHeroId == 0)
      self.ui.btn_haggle:setVisible(buyHeroId == 0)
      self.ui.btn_haggle_done:setVisible(false)
    end
    self.ui.btn_change:setVisible(true)
  else
    self.ui.btn_unlock:setVisible(false)
    self.ui.btn_haggle:setVisible(false)
    self.ui.btn_haggle_done:setVisible(true)
    self.ui.btn_change:setVisible(false)
  end
end

function heroHagglePage:refreshHaggleBtnState()
  local state = self:canHaggle()
  self.ui.btn_haggle:stopAllActions()
  local selectHeroId = ed.heroHaggleMgr.getInstance():getSelectHero()
  if state and selectHeroId ~= 0 then
    ed.setTexture(self.ui.btn_haggle, buttonEnum[3])
    self.ui.eff_UI_Hero_haggle_Button:setVisible(true)
    local action1 = CCScaleTo:create(1, 0.9)
    local action2 = CCScaleTo:create(1, 1)
    local breathAction = CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2)))
    self.ui.btn_haggle:runAction(breathAction)
  else
    ed.setTexture(self.ui.btn_haggle, buttonEnum[1])
    self.ui.eff_UI_Hero_haggle_Button:setVisible(false)
  end
end

function heroHagglePage:updateHaggleNumLabel()
  local costNum = self:getCostItemNum()
  ed.setString(self.ui.label_currency_num, string.format(T("%s/%s"), costNum, self.haggleShowMax))
end

function heroHagglePage:refreshProgress()
  self:updateProgress()
  self:refreshProgressInfo()
  self:addProcessInfo()
end

function heroHagglePage:updateProgress()
  local haveItemNum = self:getCostItemNum()
  local index = 0
  for i, v in ipairs(self.haggleMap) do
    if haveItemNum >= v.costNum then
      index = index + 1
    end
  end
  if 6 <= index then
    local node = self.ui.image_clipNode:getContentSize()
    self.ui.image_clipNode:setClipRect(CCRectMake(0, 0, node.width, 20))
  else
    self:setHaggleNum(index, haveItemNum)
  end
end

function heroHagglePage:setHaggleNum(haggleNum, haveItemNum)
  local beforeNum
  if haggleNum == 0 then
    beforeNum = 0
  else
    beforeNum = self.haggleMap[haggleNum].costNum
  end
  local addNum = haveItemNum - beforeNum
  local index = haggleNum + 1
  local pos = self.haggleMap[index].pos
  local nextPos = self.haggleMap[index + 1].pos
  local moveScale = addNum / self.haggleMap[index].stepNum
  local totalMoveX = nextPos.x - pos.x
  local moveX = pos.x - self.initPos.x
  self.progressValue = (moveX + totalMoveX * moveScale + 5) / (self.haggleMap[6].pos.x - self.initPos.x)
  local node = self.ui.image_clipNode:getContentSize()
  self.ui.image_clipNode:setClipRect(CCRectMake(0, 0, self.progressValue * node.width, 20))
end

function heroHagglePage:refreshProgressInfo()
  local haveItemNum = self:getCostItemNum()
  local next_haggleIndex = 1
  for i, v in ipairs(self.haggleMap) do
    if haveItemNum >= v.costNum then
      next_haggleIndex = i + 1
    end
  end
  local haggleNum = self:getHaggleNum()
  local ui_haggleIndex = haggleNum + 1
  for index = 1, 6 do
    if index <= ui_haggleIndex then
      ed.setTexture(self.ui["step" .. index], processEnum[3])
    elseif index <= next_haggleIndex then
      ed.setTexture(self.ui["step" .. index], processEnum[2])
    else
      ed.setTexture(self.ui["step" .. index], processEnum[1])
    end
  end
end

function heroHagglePage:addProcessInfo()
  local buyHeroId = ed.heroHaggleMgr.getInstance():getHaggleBuyHeroId()
  local haggleNum = self:getHaggleNum()
  local haveItemNum = self:getCostItemNum()
  local targetNum = haggleNum + 1
  if buyHeroId ~= 0 or 6 <= targetNum or haveItemNum == 0 then
    if nil ~= self.uiBg then
      self.uiBg:removeFromParentAndCleanup(true)
      self.uiBg = nil
    end
    return
  end
  if 1 <= targetNum then
    local beforeNum
    if targetNum == 1 then
      beforeNum = 0
    else
      beforeNum = self.haggleMap[targetNum - 1].costNum
    end
    local addNum = haveItemNum - beforeNum
    local mapConfig = self.haggleMap[targetNum]
    if addNum == 0 then
      local moveX = mapConfig.pos.x - self.initPos.x + 10
      self:showProgressInfo(moveX)
    else
      local nextMapConfig = self.haggleMap[targetNum + 1]
      if self:canHaggle() then
        local moveX = nextMapConfig.pos.x - self.initPos.x + 10
        self:showProgressInfo(moveX)
      else
        local pos = mapConfig.pos
        local moveX = pos.x - self.initPos.x + 10
        local totalMoveX = nextMapConfig.pos.x - pos.x
        local canMoveX = totalMoveX * (addNum / mapConfig.stepNum)
        self:showProgressInfo(moveX + canMoveX)
      end
    end
  end
end

function heroHagglePage:showProgressInfo(x)
  if nil ~= self.uiBg then
    self.uiBg:removeFromParentAndCleanup(true)
    self.uiBg = nil
  end
  local languageText = languageTextCN
  if ed.isAreaOverSea() then
    languageText = languageTextOther
  end
  local seasonId = ed.heroHaggleMgr.getInstance():getCurrentSeasonId()
  local haggleNum = self:getHaggleNum()
  local haveItemNum = self:getCostItemNum()
  local content
  local tipYOffset = -10
  local targetNum = haggleNum + 1
  if targetNum == 1 then
    local costNum = self.haggleMap[targetNum].costNum - haveItemNum
    local initPrice = ed.getDataTable("HeroHaggleLine")[seasonId][1]["Price Before"]
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][targetNum]
    local afterPrice = lineConfig["Price After"]
    if costNum <= 0 then
      if ed.isAreaOverSea() then
        content = languageText[1]
      else
        content = string.format(languageText[1], initPrice - afterPrice)
      end
      tipYOffset = -5
    elseif ed.isAreaOverSea() then
      content = string.format(languageText[2], costNum)
    else
      content = string.format(languageText[2], costNum, initPrice - afterPrice)
    end
  elseif targetNum < maxLevel then
    local initPrice = ed.getDataTable("HeroHaggleLine")[seasonId][1]["Price Before"]
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][haggleNum]
    local afterPrice = lineConfig["Price After"]
    local next_lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][targetNum]
    local beforePrice2 = next_lineConfig["Price Before"]
    local afterPrice2 = next_lineConfig["Price After"]
    local latePrice = beforePrice2 - afterPrice2
    local costNum = self.haggleMap[targetNum].costNum - haveItemNum
    if costNum <= 0 then
      if ed.isAreaOverSea() then
        content = languageText[4]
      else
        content = string.format(languageText[4], initPrice - afterPrice, latePrice)
      end
      tipYOffset = -5
    elseif 0 <= haveItemNum then
      if ed.isAreaOverSea() then
        content = string.format(languageText[3], costNum)
      else
        content = string.format(languageText[3], initPrice - afterPrice, costNum, latePrice)
      end
    end
  elseif targetNum == 5 then
    local initPrice = ed.getDataTable("HeroHaggleLine")[seasonId][1]["Price Before"]
    local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][targetNum]
    local afterPrice = lineConfig["Price After"]
    local costNum = self.haggleMap[targetNum].costNum - haveItemNum
    if costNum <= 0 then
      if ed.isAreaOverSea() then
        content = languageText[5]
      else
        content = string.format(languageText[5], initPrice - afterPrice)
      end
    elseif ed.isAreaOverSea() then
      content = string.format(languageText[3], costNum)
    else
      content = string.format(languageText[3], initPrice - afterPrice, costNum, 30)
    end
    tipYOffset = -5
  end
  local autoText = ed.ui.autoText:new()
  autoText:initParam({context = content, fontSize = 16})
  ed.setLabelShadow(autoText, ed.toccc3(4854547), 1)
  local bg = ed.createScale9Sprite("UI/alpha/1080P/activity/hero_haggle/hero_haggle_text_bubble_1.png", CCRectMake(5, 5, 10, 10))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 35, height + 10))
  autoText.node:setPosition(ccp(20, height + tipYOffset))
  bg:addChild(autoText.node)
  local offset = ccp(-135, -10)
  bg:setPosition(ccp(600 + (x + offset.x), ed.display.winSize.height / 2 + 40 + offset.y))
  self.ui.layer_progressInfo:setPosition(0, 0)
  self.uiBg = bg
  self.ui.layer_progressInfo:addChild(bg)
  local tips = ed.createSprite("UI/alpha/1080P/activity/hero_haggle/hero_haggle_text_bubble_2.png")
  bg:addChild(tips)
  local parent = bg:getParent()
  local beforePos = ccp(bg:getPosition())
  local pos = parent:convertToWorldSpace(ccp(bg:getPosition()))
  if pos.x + bg:getContentSize().width / 2 > ed.display.winSize.width then
    ed.layout.layoutWithMagin(bg, {
      right = ed.display.getNotchHeight()
    })
    local afterPos = ccp(bg:getPosition())
    tips:setPosition(ccp(width / 2 + 15 + (beforePos.x - afterPos.x), -3.9))
  else
    tips:setPosition(ccp(width / 2 + 20, -3.9))
  end
  tips:stopAllActions()
  local action1 = CCScaleTo:create(0.5, 1.15)
  local action2 = CCScaleTo:create(1.5, 1)
  local breathAction2 = CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2, CCDelayTime:create(8))))
  bg:runAction(breathAction2)
end

function heroHagglePage:onHaggleSuccess()
  local seasonId = ed.heroHaggleMgr.getInstance():getCurrentSeasonId()
  local haggleNum = self:getHaggleNum()
  local lineConfig = ed.getDataTable("HeroHaggleLine")[seasonId][haggleNum]
  local beforeAmount = lineConfig["Price Before"]
  self.ui.layer_haggleFca:stopAllActions()
  local index = math.random(2, 4)
  self.successTime = animationMap[index] + 3
  if not ed.isAreaOverSea() then
    self.ui.layer_haggleFca:runAction(CCSequence:create(ccArrayMake(CCCallFunc:create(function()
      FireEvent("EventHeroHaggleFcaTopView", beforeAmount)
      self.page_mask = true
    end), CCDelayTime:create(2.966666666666667), CCCallFunc:create(function()
      local spineLeft = ed.createSpine("effect/eff_UI_Hero_haggle_Refresh/eff_UI_Hero_haggle_Refresh", 0.5)
      spineLeft:setAnimation(0, "Idle", false)
      self.ui.layer_refreshEffect:addChild(spineLeft, 3)
      local x, y = spineLeft:getPosition()
      spineLeft:setPosition(ccp(x + 4, y + 2))
    end), CCDelayTime:create(0.03333333333333333), CCCallFunc:create(function()
      local spineLeft = ed.createSpine("effect/eff_UI_Hero_haggle_Star/eff_UI_Hero_haggle_Star", 0.5)
      spineLeft:setAnimation(0, "Idle", false)
      self.ui["step" .. haggleNum + 1]:addChild(spineLeft, 1)
      local x, y = spineLeft:getPosition()
      spineLeft:setPosition(ccp(x + 20, y + 28))
      self.page_mask = false
    end), CCDelayTime:create(0.3333333333333333), CCCallFunc:create(function()
      self.ui.eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle_" .. index, false)
    end), CCDelayTime:create(self.successTime / 30), CCCallFunc:create(function()
      self.ui.eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle", true)
    end))))
  else
    self.ui.layer_haggleFca:runAction(CCSequence:create(ccArrayMake(CCCallFunc:create(function()
      local spineLeft = ed.createSpine("effect/eff_UI_Hero_haggle_Refresh/eff_UI_Hero_haggle_Refresh", 0.5)
      spineLeft:setAnimation(0, "Idle", false)
      self.ui.layer_refreshEffect:addChild(spineLeft, 3)
      local x, y = spineLeft:getPosition()
      spineLeft:setPosition(ccp(x + 4, y + 2))
    end), CCDelayTime:create(0.03333333333333333), CCCallFunc:create(function()
      local spineLeft = ed.createSpine("effect/eff_UI_Hero_haggle_Star/eff_UI_Hero_haggle_Star", 0.5)
      spineLeft:setAnimation(0, "Idle", false)
      self.ui["step" .. haggleNum + 1]:addChild(spineLeft, 1)
      local x, y = spineLeft:getPosition()
      spineLeft:setPosition(ccp(x + 20, y + 28))
      self.page_mask = false
    end), CCDelayTime:create(0.3333333333333333), CCCallFunc:create(function()
      self.ui.eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle_" .. index, false)
    end), CCDelayTime:create(self.successTime / 30), CCCallFunc:create(function()
      self.ui.eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle", true)
    end))))
  end
end

function heroHagglePage:refreshRedPoint()
  local mgr = ed.heroHaggleMgr.getInstance()
  local heroId = mgr:getSelectHero()
  self.ui.task_redpoint:setVisible(mgr:getTaskState())
  self.ui.haggle_redpoint:setVisible(mgr.canHaggle == 1 and heroId ~= 0)
  self.ui.select_redpoint:setVisible(heroId == 0)
end

function heroHagglePage:onClickHero()
  if self.page_mask then
    return
  end
  local buyHeroId = ed.heroHaggleMgr.getInstance():getHaggleBuyHeroId()
  if buyHeroId == 0 then
    ed.UITool.openView("OpenHeroHaggleHeroWin")
  end
end

function heroHagglePage:onClickHaggle()
  if self.page_mask then
    return
  end
  if self.timeOutClick then
    return
  end
  local heroId = ed.heroHaggleMgr.getInstance():getSelectHero()
  if heroId == 0 then
    ed.showToast(T("\232\175\183\229\133\136\233\128\137\230\139\169\228\184\128\228\184\170\229\191\131\228\187\170\231\154\132\232\139\177\233\155\132!"))
    return
  end
  if self:canHaggle() then
    ed.heroHaggleNet:sendHeroHagglePrice()
  elseif self:isHaggleMax() then
    ed.showToast(T("\231\160\141\228\184\141\228\186\134\228\186\134,\229\134\141\231\160\141\229\176\177\232\166\129\233\170\168\230\138\152\228\186\134!"))
  else
    ed.showToast(T("\231\140\170\231\140\170\229\184\129\228\184\141\232\182\179,\230\148\182\233\155\134\230\155\180\229\164\154\231\140\170\231\140\170\229\184\129\229\134\141\230\157\165\229\144\167!"))
  end
end

function heroHagglePage:onClickOpenTask()
  if self.page_mask then
    return
  end
  if self.timeOutClick then
    return
  end
  ed.UITool.openView("OpenHeroHaggleTaskWin")
end

function heroHagglePage:onClickBuyHero()
  if self.page_mask then
    return
  end
  if self.timeOutClick then
    return
  end
  local heroId = ed.heroHaggleMgr.getInstance():getSelectHero()
  if heroId == 0 then
    ed.showToast(T("\232\175\183\229\133\136\233\128\137\230\139\169\228\184\128\228\184\170\229\191\131\228\187\170\231\154\132\232\139\177\233\155\132!"))
    return
  end
  if self:canHaggle() then
    local info = {
      autoText = T("\230\156\137\231\160\141\228\187\183\230\156\186\228\188\154\229\176\154\230\156\170\228\189\191\231\148\168 <br/>\230\132\163\231\157\128\229\185\178\229\152\155, \233\128\159\233\128\159\231\160\141\228\187\183"),
      leftText = T("\229\143\150\230\182\136"),
      rightHandler = function()
        ed.heroHaggleNet:sendHeroHagglePrice()
      end,
      rightText = T("\231\161\174\229\174\154"),
      mode = "simple",
      fontSize = 17
    }
    ed.showConfirmDialog(info)
  elseif self:isHaggleMax() then
    ed.heroHaggleMgr.getInstance():doRechargeByHeroHaggle()
  else
    ed.UITool.openView("commonDelayRewardPop", {
      autoStr = T("\229\176\154\230\156\170\231\160\141\229\136\176\230\156\128\228\189\142\228\187\183\230\160\188,\230\152\175\229\144\166\232\166\129\232\191\155\232\161\140\232\180\173\228\185\176?"),
      clickHandler = function()
        ed.heroHaggleMgr.getInstance():doRechargeByHeroHaggle()
      end
    })
  end
end

function heroHagglePage:onClickRandomFca()
  local index = math.random(1, 3)
  self.ui.eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle_" .. index + 4, false)
  self.ui.layer_haggleFca:stopAllActions()
  self.ui.layer_haggleFca:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create((animationMap[index + 4] + 3) / 30), CCCallFunc:create(function()
    self.ui.eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle", true)
  end))))
end

function heroHagglePage:onAddFcaNode()
  if not ed.isAreaOverSea() then
    local eff_UI_Hero_haggle_Minimum = ed.createSpine("effect/eff_UI_Hero_haggle_Minimum/eff_UI_Hero_haggle_Minimum", 0.5)
    eff_UI_Hero_haggle_Minimum:setAnimation(0, "Idle", true)
    self.ui.eff_UI_Hero_haggle_Minimum = eff_UI_Hero_haggle_Minimum
    self.ui.layer_price:addChild(eff_UI_Hero_haggle_Minimum, 1)
    self.ui.eff_UI_Hero_haggle_Minimum:setVisible(false)
  end
  local eff_UI_Hero_haggle_Button = ed.createSpine("effect/eff_UI_Hero_haggle_Button/eff_UI_Hero_haggle_Button", 0.5)
  eff_UI_Hero_haggle_Button:setAnimation(0, "Idle", true)
  self.ui.btn_haggle:addChild(eff_UI_Hero_haggle_Button, 1)
  local x_r, y_r = eff_UI_Hero_haggle_Button:getPosition()
  eff_UI_Hero_haggle_Button:setPosition(ccp(x_r + 75, y_r + 25))
  self.ui.eff_UI_Hero_haggle_Button = eff_UI_Hero_haggle_Button
  self.ui.eff_UI_Hero_haggle_Button:setVisible(false)
  local cardSize = self.ui.layer_art:getContentSize()
  self.ui.layer_art:setClipRect(CCRectMake(0, 0, cardSize.width, cardSize.height))
  self:adaptModel()
end

function heroHagglePage:adaptModel()
  local winRatio = ed.display.winSize.width / ed.display.winSize.height
  local modelScale, offsetX, offsetY
  if winRatio <= 1.7777777777777777 then
    modelScale = 0.4
    offsetX = 255
    offsetY = 0
  else
    modelScale = 0.5
    offsetX = 235
    offsetY = -35
  end
  local eff_UI_Hero_haggle_Cungu = ed.createSpine("effect/eff_UI_Hero_haggle_Cungu/eff_UI_Hero_haggle_Cungu", modelScale)
  eff_UI_Hero_haggle_Cungu:setAnimation(0, "Idle", true)
  self.ui.layer_art:addChild(eff_UI_Hero_haggle_Cungu, 1)
  self.ui.eff_UI_Hero_haggle_Cungu = eff_UI_Hero_haggle_Cungu
  local x_r, y_r = eff_UI_Hero_haggle_Cungu:getPosition()
  eff_UI_Hero_haggle_Cungu:setPosition(ccp(x_r + offsetX, y_r + offsetY))
end

function heroHagglePage:toMaxLevel()
  local buyHeroId = ed.heroHaggleMgr.getInstance():getHaggleBuyHeroId()
  if buyHeroId ~= 0 then
    self.ui.image_progress:setScaleX(1)
    self.ui.image_haggleNum:setVisible(false)
    if nil ~= self.ui.eff_UI_Hero_haggle_Minimum then
      self.ui.eff_UI_Hero_haggle_Minimum:setVisible(false)
    end
    if nil ~= self.uiBg then
      self.uiBg:removeFromParentAndCleanup(true)
      self.uiBg = nil
    end
  end
end
