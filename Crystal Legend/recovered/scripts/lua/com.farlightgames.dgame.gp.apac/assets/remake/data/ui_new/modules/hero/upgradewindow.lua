local UpgradeWindow = {}
UpgradeWindow.__index = UpgradeWindow
local ed = ed
local lsr = ed.heroDetailManager.listener.create()
local base = ed.ui.popwindow
setmetatable(UpgradeWindow, base.mt)
ed.ui.upgradewindow = UpgradeWindow

function UpgradeWindow.create(heroId, heroLevel, destroyCallback)
  local self = base.create("upgradewindow", {priority = -299})
  setmetatable(self, UpgradeWindow)
  self:initData(heroId, heroLevel)
  self:initApperance()
  self:registerTouchHandler()
  
  function self.destroyCallback()
    lsr:report("closeWindow")
    destroyCallback(heroLevel)
  end
  
  self:show()
  return self
end

function UpgradeWindow:initData(heroId, heroLevel)
  self.ui = {}
  self.upgradeEffectNode = {}
  self.baseScene = ed.getCurrentScene()
  self.configEquipId = {
    169,
    218,
    290,
    440,
    1609
  }
  self.consumeEquip = {
    0,
    0,
    0,
    0,
    0
  }
  self.equipExp = self:getEquipExp()
  self.heroId = heroId
  self.increaseDtLevel = 0
  self.reduceDtLevel = 0
  self.currentLevel = heroLevel
  self.targetLevel = self.currentLevel
  self.existEquip = self:getExistEquip()
  self.currentExp = self.getHeroCurrentExp(heroId)
end

function UpgradeWindow:initApperance()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.heroUpLevelWin)
  ed.setString(ui.use_amount, tostring(self.targetLevel))
  ed.setLabelShadow(self.ui.label_use, ed.toccc3(0), ccp(1, 0))
  local head = ed.readhero.createIconByID(self.heroId, {state = "idle"})
  local x, y = ui.icon:getPosition()
  ui.icon:setVisible(false)
  head.icon:setPosition(ccp(x, y))
  ui.bg_main:addChild(head.icon)
  self:initLevelAndConsumeEquip()
end

function UpgradeWindow:registerTouchHandler()
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.minus_button,
    pressScale = 0.95,
    key = "reduce_level",
    pressHandler = function()
      self:registerKeepeatHandler("reduce")
    end,
    clickHandler = function()
      self:reduceTargetLevel()
    end,
    cancelPressHandler = function()
      self:cancelKeepeatHandler("reduce")
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.add_button,
    pressScale = 0.95,
    key = "increase_level",
    pressHandler = function()
      self:registerKeepeatHandler("increase")
    end,
    clickHandler = function()
      self:increaseTargetLevel()
    end,
    cancelPressHandler = function()
      self:cancelKeepeatHandler("increase")
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.btn_use,
    pressScale = 0.95,
    key = "confirm_bt",
    clickHandler = function()
      self:confirmUpgradeHero()
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.btn_back,
    normalScale = 0.8,
    pressScale = 0.75,
    key = "cancel_bt",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
end

function UpgradeWindow:initLevelAndConsumeEquip()
  local limitLevel = self.getHeroLevelLimit()
  local gapExp = self:calculateGapExp(limitLevel)
  if gapExp <= self:getTotalExistExp() then
    self.consumeEquip = self:calculateConsumeEquip(gapExp, self.existEquip)
  else
    self.consumeEquip = self:calculateConsumeEquip(self:getTotalExistExp(), self.existEquip)
  end
  self.targetLevel = self:getLevelAndExp(self:getTotalConsumeExp())
  if self.currentLevel == limitLevel or self.targetLevel == self.currentLevel then
    self.consumeEquip = {
      0,
      0,
      0,
      0,
      0
    }
    ed.setLabelColor(self.ui.label_none, ed.toccc3(7037275))
    self.ui.label_none:setVisible(true)
    if ed.getHeroMaxLevel() == self.currentLevel then
      ed.setString(self.ui.label_none, T("\232\139\177\233\155\132\229\183\178\232\190\190\230\156\128\229\164\167\231\173\137\231\186\167"))
    elseif not self:canUpgradeWithExistEquip(self:calculateGapExp(self.currentLevel + 1)) then
      ed.setString(self.ui.label_none, T("\231\187\143\233\170\140\233\129\147\229\133\183\228\184\141\232\182\179"))
    elseif self:isLargeTargetLevel() then
      ed.setString(self.ui.label_none, T("\230\143\144\229\141\135\230\136\152\233\152\159\231\173\137\231\186\167\228\187\165\230\143\144\233\171\152\232\139\177\233\155\132\231\173\137\231\186\167\228\184\138\233\153\144"))
    end
    ed.setLabelDimensions(self.ui.label_none, CCSizeMake(360, 0))
    self.ui.btn_disable:setVisible(true)
  end
  self:refreshAnimation()
end

function UpgradeWindow:keepeatHandler(type)
  local count = 0
  local delay = 0.8
  local oriSpeed = 10
  local oriAccSpeed = 2
  local accAcc = 2
  local speed = oriSpeed
  local accSpeed = oriAccSpeed
  local times = 0
  
  local function increaseHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        self:increaseTargetLevel()
        times = times - 1
      end
    end
  end
  
  local function reduceHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        self:reduceTargetLevel()
        times = times - 1
      end
    end
  end
  
  if type == "increase" then
    return increaseHandler
  else
    return reduceHandler
  end
end

function UpgradeWindow:registerKeepeatHandler(type)
  if type == "increase" then
    self.baseScene:registerUpdateHandler("upgrade_hero_long_increase_click_button", self:keepeatHandler(type))
  else
    self.baseScene:registerUpdateHandler("upgrade_hero_long_reduce_click_button", self:keepeatHandler(type))
  end
end

function UpgradeWindow:cancelKeepeatHandler(type)
  if type == "increase" then
    self.baseScene:removeUpdateHandler("upgrade_hero_long_increase_click_button")
  else
    self.baseScene:removeUpdateHandler("upgrade_hero_long_reduce_click_button")
  end
end

function UpgradeWindow:setButtonGray(isGray)
end

function UpgradeWindow:increaseTargetLevel()
  if self:isLargeTargetLevel() then
    ed.showToast(T("\232\139\177\233\155\132\231\173\137\231\186\167\229\183\178\232\190\190\229\136\176\230\136\152\233\152\159\231\173\137\231\186\167"))
    return
  end
  if not self:canUpgradeWithExistEquip(self:calculateGapExp(self.targetLevel + 1)) then
    ed.showToast(T("\232\181\132\230\186\144\228\184\141\232\182\179"))
    return
  end
  lsr:report("clickIncreaseButton")
  local preTargetLevel = self.targetLevel
  self.targetLevel = self.targetLevel + 1
  if self:calculateGapExp(self.targetLevel) == 0 then
    preTargetLevel = self.targetLevel
    self.targetLevel = self.targetLevel + 1
  end
  self.consumeEquip = self:calculateConsumeEquip(self:calculateGapExp(self.targetLevel), self.existEquip)
  local upLevel = self:getLevelAndExp(self:getTotalConsumeExp())
  if upLevel > self.targetLevel then
    self.targetLevel = upLevel
    self.consumeEquip = self:calculateConsumeEquip(self:calculateGapExp(self.targetLevel), self.existEquip)
  end
  self:refreshAnimation()
  if self.targetLevel > self.currentLevel then
    self:setButtonGray(false)
  end
end

function UpgradeWindow:reduceTargetLevel()
  if self.targetLevel <= self.currentLevel then
    ed.showToast(T("\228\184\141\232\131\189\230\175\148\231\142\176\229\156\168\231\173\137\231\186\167\228\189\142"))
    return
  end
  lsr:report("clickReduceButton")
  local preTargetLevel = self.targetLevel
  self.targetLevel = self.targetLevel - 1
  self.consumeEquip = self:calculateConsumeEquip(self:calculateGapExp(self.targetLevel), self.existEquip)
  if self:getTotalConsumeExp() > 0 then
    while self:getLevelAndExp(self:getTotalConsumeExp()) == preTargetLevel and self.targetLevel > self.currentLevel do
      self.targetLevel = self.targetLevel - 1
      self.consumeEquip = self:calculateConsumeEquip(self:calculateGapExp(self.targetLevel), self.existEquip)
    end
  end
  self:refreshAnimation()
  if self.targetLevel <= self.currentLevel then
    self:setButtonGray(true)
  end
end

function UpgradeWindow:refreshAnimation()
  local consumeRes = {}
  for i = 1, #self.configEquipId do
    table.insert(consumeRes, {
      id = self.configEquipId[i],
      amount = self.consumeEquip[i]
    })
  end
  self:refreshConsumeRes(consumeRes)
  ed.setString(self.ui.use_amount, tostring(self.targetLevel))
end

function UpgradeWindow:confirmUpgradeHero()
  if self.targetLevel == self.currentLevel then
    ed.showToast(T("\231\155\174\230\160\135\231\173\137\231\186\167\233\156\128\232\166\129\229\164\167\228\186\142\229\189\147\229\137\141\231\173\137\231\186\167"))
    return
  end
  if not self:canUpgradeWithExistEquip(self:calculateGapExp(self.targetLevel)) then
    ed.showToast(T("\232\181\132\230\186\144\228\184\141\232\182\179\228\187\165\229\141\135\231\186\167\229\136\176\230\140\135\229\174\154\231\173\137\231\186\167"))
    return
  end
  lsr:report("clickConfirmButton")
  local consumeItems = {}
  for i = 1, #self.configEquipId do
    table.insert(consumeItems, {
      id = self.configEquipId[i],
      amount = self.consumeEquip[i]
    })
  end
  self:sendConsumeExpItems({
    heroId = self.heroId,
    consumeItems = consumeItems
  })
end

function UpgradeWindow:getExistEquip()
  local existEquip = {}
  for i = 1, #self.configEquipId do
    table.insert(existEquip, ed.player.equip_qunty[self.configEquipId[i]] or 0)
  end
  return existEquip
end

function UpgradeWindow:getEquipExp()
  local equipExp = {}
  for i = 1, #self.configEquipId do
    table.insert(equipExp, self.getExpWithId(self.configEquipId[i]))
  end
  return equipExp
end

function UpgradeWindow.getHeroExpWithLevel(level)
  return ed.lookupDataTable("Levels", "Exp", level)
end

function UpgradeWindow.getHeroCurrentExp(heroId)
  return ed.player.heroes[heroId]._exp
end

function UpgradeWindow.getExpWithId(equipId)
  return ed.getDataTable("equip")[equipId].Exp
end

function UpgradeWindow.getHeroLevelLimit()
  return ed.playerlimit.heroLevelLimit()
end

function UpgradeWindow:isLargeTargetLevel()
  if self.targetLevel < self.getHeroLevelLimit() then
    return false
  end
  return true
end

function UpgradeWindow:refreshHeroLevelLabel()
  ed.setString(self.ui.use_amount, tostring(self.targetLevel))
end

function UpgradeWindow:canUpgradeWithExistEquip(gapExp)
  local totalExp = 0
  for i = 1, #self.configEquipId do
    totalExp = totalExp + self.existEquip[i] * self.equipExp[i]
  end
  if gapExp <= totalExp then
    return true
  end
  return false, totalExp
end

function UpgradeWindow:calculateGapExp(targetLevel)
  local currentLevel = self.currentLevel
  local sumExp = 0
  while targetLevel > currentLevel do
    sumExp = sumExp + self.getHeroExpWithLevel(currentLevel)
    currentLevel = currentLevel + 1
  end
  sumExp = sumExp - self.currentExp
  return sumExp
end

function UpgradeWindow:getLevelAndExp(addExp)
  local oe = self.currentExp
  local ol = self.currentLevel
  local ee = oe + addExp
  local el = ol
  local levelLimit = self.getHeroLevelLimit()
  while true do
    local lue = self.getHeroExpWithLevel(el)
    if not lue then
      return ol, oe
    end
    if ee >= lue then
      if el < levelLimit then
        ee = ee - lue
        el = el + 1
      else
        ee = lue
        break
      end
    else
      break
    end
  end
  return el, ee
end

function UpgradeWindow:calculateConsumeEquip(exp, existEquip)
  assert(type(existEquip) ~= table, "existEquip must be a table")
  local consumeEquip = {
    0,
    0,
    0,
    0,
    0
  }
  local totalExp = exp
  local flag = false
  while 0 < totalExp do
    if consumeEquip[1] < existEquip[1] then
      totalExp = totalExp - self.equipExp[1]
      consumeEquip[1] = consumeEquip[1] + 1
    elseif consumeEquip[2] < existEquip[2] then
      totalExp = totalExp - self.equipExp[2]
      consumeEquip[2] = consumeEquip[2] + 1
    elseif consumeEquip[3] < existEquip[3] then
      totalExp = totalExp - self.equipExp[3]
      consumeEquip[3] = consumeEquip[3] + 1
    elseif consumeEquip[4] < existEquip[4] then
      totalExp = totalExp - self.equipExp[4]
      consumeEquip[4] = consumeEquip[4] + 1
    elseif consumeEquip[5] < existEquip[5] then
      totalExp = totalExp - self.equipExp[5]
      consumeEquip[5] = consumeEquip[5] + 1
    else
      break
    end
  end
  return consumeEquip
end

function UpgradeWindow:getTotalConsumeExp()
  local totalExp = 0
  for i = 1, #self.configEquipId do
    totalExp = totalExp + self.consumeEquip[i] * self.equipExp[i]
  end
  return totalExp
end

function UpgradeWindow:getTotalExistExp()
  local totalExp = 0
  for i = 1, #self.configEquipId do
    totalExp = totalExp + self.existEquip[i] * self.equipExp[i]
  end
  return totalExp
end

function UpgradeWindow:refreshConsumeRes(consumeItem)
  local consumeItem = consumeItem
  local i = #consumeItem
  while 1 <= i do
    if consumeItem[i].amount == 0 then
      table.remove(consumeItem, i)
    end
    i = i - 1
  end
  table.sort(consumeItem, function(itemA, itemB)
    return itemA.id < itemB.id
  end)
  local pos = 1
  local ox = 86 - #consumeItem / 2 * 90
  
  local function handler(index)
    if index > #consumeItem then
      return
    end
    local equipBg
    if consumeItem[index].amount > 0 then
      equipBg = ed.readequip.createIconWithAmount(consumeItem[index].id, 80, consumeItem[index].amount)
      equipBg:setPosition(ccp(ox + pos * 90, 40))
      self.ui.bg_materials:addChild(equipBg)
      pos = pos + 1
    end
    handler(index + 1)
  end
  
  self.ui.bg_materials:removeAllChildrenWithCleanup(true)
  handler(1)
end

function UpgradeWindow:playUpgradeEffect()
  local node = ed.createFcaNode("eff_UI_levelup")
  local img_levelUp
  if ed.isAreaZhCn() then
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr.png")
  else
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr-global.png")
    img_levelUp:setScale(0.9)
  end
  local img_node = CCSprite:create()
  img_node:addChild(img_levelUp)
  node:addNodeToComponent(img_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  self.baseScene:addFca(node)
  local x, y = self.ui.icon:getPosition()
  node:setPosition(ccp(x, y))
  node:setScale(1.05)
  self.ui.bg_main:addChild(node, 8)
  self:checkUpgradeEffect(node)
end

function UpgradeWindow:checkUpgradeEffect(node)
  local list = self.upgradeEffectNode
  table.insert(list, node)
  
  local function handler()
    for k, v in pairs(list) do
      if not tolua.isnull(v) and v:isTerminated() then
        v:removeFromParentAndCleanup(true)
        list[k] = nil
        table.remove(list, k)
        return
      end
    end
    if #(list or {}) == 0 then
      self.baseScene:removeUpdateHandler("heroUpgradeEffect")
      self:destroy()
    end
  end
  
  self.baseScene:registerUpdateHandler("heroUpgradeEffect", handler)
end

function UpgradeWindow:refresh()
  local function handler(hero, args)
    lsr:report("upgradeReply")
    
    self:refreshData(hero)
    self:refreshUi(args)
  end
  
  return handler
end

function UpgradeWindow:refreshData(hero)
  self.increaseDtLevel = 0
  self.reduceDtLevel = 0
  self.currentLevel = hero._level
  self.targetLevel = self.currentLevel
  self.currentExp = hero._exp
  self.existEquip = self:getExistEquip()
  self.consumeEquip = self:calculateConsumeEquip(self:calculateGapExp(self.targetLevel), self.existEquip)
end

function UpgradeWindow:refreshUi(args)
  if self.isDestroyed then
    return
  end
  self:refreshAnimation()
  self:refreshHeroLevelLabel()
  self:playUpgradeEffect()
end

function UpgradeWindow:sendConsumeExpItems(args)
  local msg = ed.upmsg.consume_exp_items()
  msg._heroid = args.heroId
  local itemsInfo = {}
  for i, item in ipairs(args.consumeItems) do
    itemsInfo[i] = ed.packItem(item.id, item.amount)
  end
  msg._items = itemsInfo
  local data = {
    consumeItems = args.consumeItems,
    originalLevel = self.currentLevel,
    originalExp = self.currentExp
  }
  ed.registerNetReply("consume_exp", self:refresh(), data)
  ed.send(msg, "consume_exp_items")
end

ListenEvent("ConsumeExpItemReply", function(args)
  local result = args._result
  local hero = args._hero
  if result == "success" then
    local handler, data = ed.getNetReply("consume_exp")
    if data and data.consumeItems then
      for i, item in ipairs(data.consumeItems) do
        if item.amount > 0 then
          ed.player:consumeEquip(item.id, item.amount)
        end
      end
      ed.player:resetHero(hero)
    end
    if handler then
      handler(hero, data)
    end
  else
    ed.showToast(T("\229\141\135\231\186\167\229\164\177\232\180\165"))
  end
end)
