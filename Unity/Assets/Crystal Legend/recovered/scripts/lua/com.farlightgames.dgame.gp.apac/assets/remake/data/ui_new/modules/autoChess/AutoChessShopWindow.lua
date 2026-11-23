local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessShopWindow = class
local ColorParam = ed.AutoChessDefine.ColorParam
local ColorStrokeParam = ed.AutoChessDefine.ColorStrokeParam
local BaseParam = ed.AutoChessDefine.BaseParam
local LightParam = ed.AutoChessDefine.LightParam

function class:initData()
  self.shopHeroList = ed.AutoChessModel:getShopHeroList()
end

function class:initLabels()
  for i = 1, 5 do
    ed.setLabelStroke(self.ui["label_cost_hero_" .. i], ccc3(20, 20, 20), 1)
    ed.setLabelColor(self.ui["label_chess_rate_" .. i], ColorParam["color_" .. i])
    ed.setLabelStroke(self.ui["label_chess_rate_" .. i], ColorStrokeParam["color_" .. i], 1)
  end
  ed.setLabelStroke(self.ui.label_team_level_title, ed.toccc3(1315860), 1)
  ed.setLabelStroke(self.ui.label_team_level, ed.toccc3(2565412), 1.5)
  ed.setLabelStroke(self.ui.label_cost_num, ed.toccc3(1315860), 1)
  ed.setLabelStroke(self.ui.label_refresh_title, ed.toccc3(1315860), 1)
end

function class:adaptUI()
  self.adaptScale = ed.display.winSize.width / 1170
  self.ui.bg:setScale(self.adaptScale)
end

function class:initRateInfo()
  local teamLevel = ed.AutoChessModel:getTeamLevel()
  ed.setString(self.ui.label_team_level, teamLevel)
  local playerData = ed.getDataTable("ChessPlayer")[teamLevel]
  for i = 1, 5 do
    local rate = playerData["Gold" .. i .. " Weight"]
    ed.setString(self.ui["label_chess_rate_" .. i], rate .. "%")
  end
end

function class:updateTagNode(hid, index)
  local tagNode = CCNode:create()
  local raceTags = ed.getChessUnitRaceTags(hid)
  local offsetX = 0
  local scale = 1
  for _, tag in pairs(raceTags) do
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, 0))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
  end
  local abilityTags = ed.getChessUnitAbilityTags(hid)
  for _, tag in pairs(abilityTags) do
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    local tagSize = tagSprite:getContentSize()
    tagSprite:setAnchorPoint(ccp(0, 0))
    tagSprite:setPosition(ccp(offsetX, 0))
    tagSprite:setScale(scale)
    tagNode:addChild(tagSprite)
    offsetX = offsetX + tagSize.width * scale
  end
  tagNode:setPosition(ccp(-offsetX / 2, -22))
  self.ui["node_hero_" .. index]:addChild(tagNode, 20)
end

function class:updateHaveNode(hid, index)
  local totalHeroList = ed.AutoChessModel:getTotalHeroList()
  local heroId = ed.getDataTable("ChessUnit")[hid]["Hero ID"]
  local haveNum = 0
  for _, hero in pairs(totalHeroList) do
    local tempId = ed.getDataTable("ChessUnit")[hero:getChessId()]["Hero ID"]
    if tempId == heroId then
      haveNum = haveNum + 1
    end
  end
  self.ui["img_hero_have_" .. index]:setVisible(0 < haveNum)
  self.ui["img_hero_have_" .. index]:removeAllChildrenWithCleanup(true)
  local size = self.ui["img_hero_have_" .. index]:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("\229\183\178\230\156\137%s\229\144\141", string.format("<lable color=ccc3(255,252,231) strokeColor=ccc3(45,31,27) strokeSize=1>%d</lable>", haveNum)),
    color = ed.toccc3(16169363),
    strokeColor = ccc3(45, 31, 27),
    strokeSize = 1
  })
  autoText:setVerticalCenter()
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp((size.width - width) / 2, size.height / 2))
  self.ui["img_hero_have_" .. index]:addChild(autoText.node, 1)
end

function class:updateHeroPanel(shopHero, index)
  self.ui["node_hero_" .. index]:removeAllChildrenWithCleanup(true)
  local hid = shopHero:getChessId()
  local price = shopHero:getSoldPrice()
  local name = ed.getDataTable("ChessUnit")[hid]["Display Name"]
  ed.setString(self.ui["label_name_" .. index], name)
  ed.setLabelColor(self.ui["label_name_" .. index], ColorParam["color_" .. price])
  ed.setLabelStroke(self.ui["label_name_" .. index], ColorStrokeParam["color_" .. price], 1)
  self.ui["label_name_" .. index]:limitWidthByScale(130)
  ed.setString(self.ui["label_cost_hero_" .. index], price)
  local actor = ed.readhero.getChessActor(hid, "Idle")
  actor:setScale(1.2)
  self.ui["node_hero_" .. index]:addChild(actor, 10)
  self:addFca(actor)
  self:updateTagNode(hid, index)
  self:updateHaveNode(hid, index)
  ed.setTexture(self.ui["img_base_" .. index], BaseParam["base_" .. price])
  ed.setTexture(self.ui["img_light_" .. index], LightParam["light_" .. price])
end

function class:initHeroPanel()
  for i = 1, 5 do
    local shopHero = self.shopHeroList["slot_" .. i]
    if shopHero then
      self.ui["panel_hero_" .. i]:setVisible(true)
      self:updateHeroPanel(shopHero, i)
    else
      self.ui["panel_hero_" .. i]:setVisible(false)
      self.ui["node_hero_" .. i]:removeAllChildrenWithCleanup(true)
    end
  end
end

function class:updateGold()
  ed.setString(self.ui.label_gold, ed.AutoChessModel:getTotalGold())
end

function class:updateShopPanel()
  local totalGold = ed.AutoChessModel:getTotalGold()
  for i = 1, 5 do
    local shopHero = self.shopHeroList["slot_" .. i]
    if shopHero and shopHero:isChessSold() then
      self.ui["panel_hero_" .. i]:setVisible(false)
      self.ui["node_hero_" .. i]:removeAllChildrenWithCleanup(true)
    elseif shopHero then
      local hid = shopHero:getChessId()
      self:updateHaveNode(hid, i)
      if totalGold < shopHero:getSoldPrice() then
        self.ui["label_cost_hero_" .. i]:setColor(ccc3(255, 0, 0))
      else
        self.ui["label_cost_hero_" .. i]:setColor(ed.toccc3(16502287))
      end
    end
  end
  ed.setString(self.ui.label_cost_num, ed.AutoChessManager.refreshCost)
  if totalGold < ed.AutoChessManager.refreshCost then
    self.ui.label_cost_num:setColor(ccc3(255, 0, 0))
  else
    self.ui.label_cost_num:setColor(ed.toccc3(16502287))
  end
end

function class:updateLock()
  local isLock = ed.AutoChessModel:getShopLock()
  if isLock then
    ed.setTexture(self.ui.img_lock, "UI/alpha/1080P/chess/battle/lock.png")
  else
    ed.setTexture(self.ui.img_lock, "UI/alpha/1080P/chess/battle/unlock.png")
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessShopWindow, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:adaptUI()
end

function class:handlerRefresh()
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "lock"})
  if isGuideFlag and not nextFlag then
    return
  end
  if not ed.chess_debug_mode then
    local gold = ed.AutoChessModel:getTotalGold()
    if gold < ed.AutoChessManager.refreshCost then
      ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
    else
      ed.AutoChessNetwork:sendChessShopRefresh()
    end
  else
    ed.AutoChessManager:dispatchDebugReply("shoprefresh")
  end
end

function class:handlerLock()
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "lock"})
  if isGuideFlag and not nextFlag then
    return
  end
  if not ed.chess_debug_mode then
    local isLock = ed.AutoChessModel:getShopLock() and 1 or 0
    ed.AutoChessNetwork:sendChessShopLock(isLock)
  end
end

function class:handlerHeroIconClick(index)
  local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "shopchess", index = index})
  if isGuideFlag then
    if not nextFlag then
      return
    end
    ed.AutoChessTeachManager:dispatchGuideReply("buychess")
    ed.AutoChessTeachManager:updateStep(nextFlag)
    return
  end
  local shopHero = self.shopHeroList["slot_" .. index]
  local price = shopHero:getSoldPrice()
  local totalGold = ed.AutoChessModel:getTotalGold()
  if price <= totalGold then
    if ed.chess_debug_mode then
      ed.AutoChessManager:dispatchDebugReply("buyhero", {
        _gold = totalGold - price,
        _hero = {
          _insid = shopHero:getHeroInsid(),
          _hid = shopHero:getChessId()
        }
      })
    elseif not shopHero:isChessSold() then
      local insid = shopHero:getHeroInsid()
      ed.AutoChessNetwork:sendChessBuyHero(insid)
    end
  else
    ed.showToast(T("\233\135\145\229\184\129\228\184\141\232\182\179"))
  end
end

function class:handlerCompose(chessHero)
  local hid = chessHero:getChessId()
  local insidList = {}
  local totalHeroList = ed.AutoChessModel:getTotalHeroList()
  for _, hero in pairs(totalHeroList) do
    if hero:getChessId() == hid then
      table.insert(insidList, hero:getHeroInsid())
    end
    if 3 <= #insidList then
      break
    end
  end
  if 3 <= #insidList then
    local composeList = {}
    local battleData = ed.AutoChessModel:getBattleHeroData()
    local composeSid
    for _, battleHero in pairs(battleData) do
      local insid = battleHero.heroSid
      if ed.isElementInTable(insid, insidList) and #composeList < 3 then
        composeList[#composeList + 1] = insid
        composeSid = insid
        break
      end
    end
    for i = 1, #insidList do
      if insidList[i] ~= composeSid then
        composeList[#composeList + 1] = insidList[i]
      end
      if 3 <= #composeList then
        break
      end
    end
    if ed.chess_debug_mode then
      ed.AutoChessManager:dispatchDebugReply("compose", {
        _hero_insids = {
          composeList[2],
          composeList[3]
        },
        _hero = {
          _insid = composeList[1],
          _hid = 102
        }
      })
    else
      ed.AutoChessNetwork:sendChessComposeHero(composeList)
    end
  end
end

function class:destroy(param)
  FireEvent("EventChessShopClosed")
  self:removeOnEnterHandler("auto_chess_shop")
  base.destroy(self, param)
end

function class:registerBtnEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "outClickBg",
    clickHandler = function()
      local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "closeshop"})
      if isGuideFlag then
        ed.AutoChessTeachManager:updateStep(nextFlag)
        if not nextFlag then
          return
        end
      end
      ed.playEffect(ed.sound.deo.common_close_popup_window)
      self:destroy({skipAnim = true})
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_refresh", function()
    if ed.AutoChessTeachManager:checkGuideStep({type = "refresh"}) then
      return
    end
    self:handlerRefresh()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "img_lock", function()
    if ed.AutoChessTeachManager:checkGuideStep({type = "lock"}) then
      return
    end
    self:handlerLock()
  end)
  for i = 1, 5 do
    ed.UITool.registerBtn(self, "panel_hero_" .. i, function()
      self:handlerHeroIconClick(i)
    end)
  end
end

function class:registerNetEvents()
  self:listenEvent("EventShopDataRefresh", function(data)
    self:initData()
    self:initHeroPanel()
    self:updateGold()
    self:updateShopPanel()
    self:updateLock()
  end)
  self:listenEvent("EventBuyChessHeroSuccess", function(chessHero)
    self:updateGold()
    self:updateShopPanel()
  end)
  self:listenEvent("EventChessRoundStart", function()
    self:updateGold()
  end)
  self:listenEvent("EventChessRoundPrepare", function()
    self:initData()
    self:initHeroPanel()
    self:updateShopPanel()
    self:updateLock()
  end)
  self:listenEvent("EventShopDataLock", function()
    self:updateLock()
  end)
  self:listenEvent("EventCloseChessShop", function()
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("EventGuideNextStep", function()
    if ed.AutoChessTeachManager:isShopGuideType() then
      ed.AutoChessTeachManager:createTeach(self.container)
    end
  end)
end

function class:registerEvents()
  self:registerBtnEvents()
  self:registerNetEvents()
end

function class:onEnter()
  self:initRateInfo()
  self:initHeroPanel()
  self:updateGold()
  self:updateShopPanel()
  self:updateLock()
  if ed.AutoChessTeachManager:isGuideFlag() then
    FireEvent("EventGuideNextStep")
  end
  FireEvent("EventCloseOtherWin")
end

function class.create()
  local self = base.create("AutoChessShopWindow", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:registerOnEnterHandler("auto_chess_shop", function()
    self:onEnter()
  end)
  return self
end
