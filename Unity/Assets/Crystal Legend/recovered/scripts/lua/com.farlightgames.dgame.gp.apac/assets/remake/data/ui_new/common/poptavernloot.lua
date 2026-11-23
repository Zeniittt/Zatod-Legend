local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.poptavernloot = class
local lsr = ed.ui.poptavernlootlsr.create()
local matrix_center_pos = ccp(400, 220)

local function isShowHundredTavern(self)
  if self.type == "bronze" and ed.isElementInTable(self.times, {"thousand", "hundred"}) and ed.player._level >= 40 then
    return true
  end
  return false
end

class.isShowHundredTavern = isShowHundredTavern

local function isConvertAmount(loot)
  local convertAmount = {}
  for k, v in pairs(ed.getDataTable("HeroStars")) do
    if type(k) == "number" then
      table.insert(convertAmount, v["Convert Fragments"])
    end
  end
  local id = loot.id
  local amount = loot.amount
  local mhid = ed.readhero.getMakeid(id)
  if mhid and ed.itemType(mhid) == "hero" and ed.isElementInTable(amount, convertAmount) then
    return true, mhid
  end
  if ed.itemType(id) == "hero" then
    return true, id
  end
  return false
end

class.isConvertAmount = isConvertAmount

local function isHero(loot)
  local mhid = ed.readhero.getMakeid(loot.id)
  if mhid and loot.isHero then
    return true, mhid
  end
  if ed.itemType(loot.id) == "hero" then
    return true, loot.id
  end
  return false
end

class.isHero = isHero

local function checkSameHero(loot_1, loot_2)
  local result_1, id_1 = isHero(loot_1)
  local result_2, id_2 = isHero(loot_2)
  if not result_1 or not result_2 then
    return false
  end
  if id_1 ~= id_2 then
    return false
  end
  return true
end

class.checkSameHero = checkSameHero
local magic_loot_pos = {
  ccp(-105, 65),
  ccp(105, 65),
  ccp(215, 10),
  ccp(100, -65),
  ccp(-100, -65),
  ccp(-215, 10),
  ccp(0, 0)
}

local function destroyLootCard(self)
  lsr:report("closeLootCard")
  if not tolua.isnull(self.lootDetailCard) then
    self.lootDetailCard:removeFromParentAndCleanup(true)
    self.lootDetailCard = nil
  end
end

class.destroyLootCard = destroyLootCard

local function createLootCard(self, id)
  lsr:report("createLootCard")
  local panel = ed.readequip.getDetailCard(id)
  if not self.lootDetailCard then
    self.lootDetailCard = panel
    self.container:addChild(panel, 50)
  end
  return panel
end

class.createLootCard = createLootCard

local function registerLootsTouch(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  local click
  self:btRegisterClick({
    checkClickHandler = function(x, y)
      if CCRectMake(114, 80, 540, 230):containsPoint(ccp(x, y)) then
        return true
      end
      return false
    end,
    pressHandler = function(param, x, y)
      local id
      if not self.lootIcons then
        return
      end
      local loots = self.loots
      local lootIcons = self.lootIcons
      for i = 1, #lootIcons do
        local icon = lootIcons[i]
        local loot = loots[i]
        if ed.containsPoint(icon, x, y) then
          icon:setScale(0.95)
          local panel = self:createLootCard(loot.id)
          local x, y = icon:getPosition()
          if (self.type == "magic" or self.type == "newmagic") and self.times == "one" then
            panel:setAnchorPoint(ccp(0.5, 0.5))
            panel:setPosition(matrix_center_pos)
          else
            panel:setPosition(self.lootDraglist.listLayer:convertToWorldSpace(ccp(x, y + 35)))
          end
          return i
        end
      end
    end,
    cancelPressHandler = function(param, x, y)
      local id = param.clickParam
      if not id then
        return
      end
      local lootIcons = self.lootIcons
      lootIcons[id]:setScale(1)
      self:destroyLootCard()
    end,
    clickHandler = function(param, x, y)
      local id = param.clickParam
      if not id then
        return
      end
      local lootIcons = self.lootIcons
      lootIcons[id]:setScale(1)
      self:destroyLootCard()
    end,
    mcpMode = true
  })
end

class.registerLootsTouch = registerLootsTouch

local function registerTouchHandler(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "ok_button",
    clickHandler = function()
      self:doClickClose()
    end,
    clickInterval = 0.5
  })
  if self.teachKey then
    return
  end
  if not tolua.isnull(ui.tavern) then
    self:btRegisterButtonClick({
      button = ui.tavern,
      press = ui.tavern_press,
      key = "tavern_button",
      clickHandler = function()
        self:doClickTavern()
      end,
      clickInterval = 0.5
    })
  end
  if not tolua.isnull(ui.tavern_10) then
    self:btRegisterButtonClick({
      button = ui.tavern_10,
      press = ui.tavern_10_press,
      key = "tavern_button_10",
      clickHandler = function()
        self:doClickTavern10()
      end,
      clickInterval = 0.5
    })
  end
end

class.registerTouchHandler = registerTouchHandler

local function doClickClose(self)
  lsr:report("clickCloseLoots")
  self:destroy()
end

class.doClickClose = doClickClose

local function doClickTavern(self)
  lsr:report("clickTavernAgain")
  self.isDoTavern = true
  self.times = self.oriTimes
  if "magic" == self.type then
    self.times = "one"
  end
  self:destroy()
end

class.doClickTavern = doClickTavern

local function doClickTavern10(self)
  lsr:report("clickTavernAgain")
  self.isDoTavern = true
  if self.type == "bronze" then
    if self.oriTimes == "hundred" then
      self.times = "thousand"
    end
  else
    self.times = "ten"
  end
  self:destroy()
end

class.doClickTavern10 = doClickTavern10

local function throwLoots(self)
  if #self.loots <= 1 then
    return
  end
  if self.times == "hundred" or self.times == "thousand" then
    local category_value = {
      ["\230\182\136\232\128\151\229\147\129"] = 1,
      ["\231\162\142\231\137\135"] = 2,
      ["\229\141\183\232\189\180"] = 3,
      ["\233\155\182\228\187\182"] = 4,
      ["\229\144\136\230\136\144\229\147\129"] = 5,
      ["\231\129\181\233\173\130\231\159\179"] = 6
    }
    table.sort(self.loots, function(a, b)
      local quality_a = ed.itemType(a.id) == "hero" and 10 or ed.readequip.quality(a.id)
      local quality_b = ed.itemType(b.id) == "hero" and 10 or ed.readequip.quality(b.id)
      local value_a = quality_a * 10 + (category_value[ed.readequip.value(a.id, "Category")] or 0)
      local value_b = quality_b * 10 + (category_value[ed.readequip.value(b.id, "Category")] or 0)
      if value_a > value_b then
        return true
      end
      return false
    end)
    return
  end
  math.randomseed(tostring(os.time()):reverse():sub(1, 6))
  local r = math.random(1, #self.loots)
  local t = self.loots[1]
  self.loots[1] = self.loots[r]
  self.loots[r] = t
  for i = 1, 20 do
    local r1 = math.random(1, #self.loots)
    local r2 = math.random(1, #self.loots)
    local t = self.loots[r1]
    self.loots[r1] = self.loots[r2]
    self.loots[r2] = t
  end
  for i = 1, #self.loots do
    local loot = self.loots[i]
    if isHero(loot) then
      local id = loot.id
      for j = i, #self.loots do
        local l = self.loots[j]
        if checkSameHero(l, loot) and l.amount < loot.amount then
          local temp = self.loots[i]
          self.loots[i] = l
          self.loots[j] = temp
        end
      end
    end
  end
end

class.throwLoots = throwLoots

local function create(param)
  param = param or {}
  local self = base.create("poptavernloot", param)
  setmetatable(self, class.mt)
  self.baseScene = ed.getCurrentScene()
  self.type = param.type
  self.times = param.times
  self.oriTimes = self.times
  self.idx = param.idx or {}
  self.again = param.again
  self.addition = param.addition or {}
  self.boxType = param.boxType or self.type
  if self.type == "newmagic" then
    self.heroId = param.heroId
  end
  if ed.isElementInTable(self.type, {"starshop"}) then
    self.cost = self.addition.cost
  else
    local times = self.times
    if times == "thousand" then
      times = "hundred"
    end
    self.cost = ed.ui.tavernScene:getCost(self.type, times)
    if self.type == "newmagic" then
      local discount_price = ed.lookupDataTable("TitanToHeros", "NewSoulPrice", self.heroId) or 0
      if 0 < discount_price then
        self.cost.number = discount_price * self.cost.num
      end
    end
    print("self.type == >> ", self.type, times)
    ed.printTable(self.cost)
  end
  if self.times == "hundred" then
    self.isSkipLootAnim = true
  elseif self.times == "thousand" then
    if self.cost.id == 3038 then
      self.cost = ed.ui.tavernScene:getCost(self.type, "hundred")
    else
    end
    self.oriTimes = "hundred"
    self.isSkipLootAnim = true
  end
  self.destroyHandler = self.addition.destroyHandler
  local loots = param.loots
  for i = 1, #loots do
    local v = loots[i]
    local id, amount = ed.analyzeItem2(v)
    loots[i] = {
      id = id,
      amount = amount,
      isHero = ed.isElementInTable(i, self.idx)
    }
  end
  self.loots = loots
  if self:isMagicTenBuy() or self:isNewMagicTenBuy() then
    self:doMagicTenBuy()
  else
    self:throwLoots()
    self:registerLootsTouch()
    self:show()
  end
  return self
end

class.create = create

local function pop(param)
  local window = create(param)
  local scene = window:ccScene()
  scene:addChild(window.mainLayer, 150)
end

class.pop = pop

local function show(self)
  lsr:report("createLootsLayer")
  self.container:setScale(0)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      self:playBoxAnim()
    end, EDDebug)
  end)
  s = CCSequence:createWithTwoActions(s, f)
  self.container:runAction(s)
end

class.show = show

local function destroy(self)
  lsr:report("closeLootsLayer")
  
  local function dst()
    self.mainLayer:removeFromParentAndCleanup(true)
    if self.isDoTavern then
      self.tavernHandler(true, self.type, self.times)
    end
    if self.destroyHandler then
      self.destroyHandler()
    end
  end
  
  dst()
end

class.destroy = destroy
local type2Keywords = {
  bronze = T("\231\187\143\233\170\140\232\141\175\232\134\143"),
  gold = T("\231\187\143\233\170\140\229\165\182\233\133\170"),
  magic = T("\231\187\143\233\170\140\230\177\137\229\160\161"),
  newmagic = "\231\187\143\233\170\140\230\138\171\232\144\168"
}
local type2equipid = {
  bronze = 218,
  gold = 290,
  magic = 440,
  newmagic = 1609
}
local introLabelPosTbl = {
  bronze = ccp(400, 320),
  silver = ccp(400, 320),
  gold = ccp(400, 320),
  magic = ccp(400, 360),
  newmagic = ccp(400, 360),
  starshop = ccp(400, 320),
  stone_green = ccp(400, 320),
  stone_blue = ccp(400, 320),
  stone_purple = ccp(400, 320)
}

local function createIntroLabel(self)
  if self.type == "bronze" or self.type == "gold" or self.type == "magic" or self.type == "newmagic" then
    local num = 1
    if self.times == "ten" then
      num = 10
    end
    if self.times == "hundred" then
      num = 100
    end
    if self.times == "thousand" then
      num = 1000
    end
    local tip = ""
    if self.heroId then
      local hero = ed.player:getHero(self.heroId)
      local stoneAmount = ed.readhero.getStoneAmount(self.heroId)
      local needStoneAmount = ed.ui.herodetail.getHeroEvolveStoneNeed(self.heroId)
      tip = T("%s\231\129\181\233\173\130\231\159\179\239\188\154%d/%d", hero:getDisplayName(), stoneAmount, needStoneAmount)
    end
    local introtext = tip .. "    "
    if EDLanguageArea == "taiwan" then
      introtext = "\230\136\144\229\138\159\231\141\178\229\190\151\228\187\165\228\184\139\231\137\169\229\147\129\239\188\140\229\143\166\232\180\136"
      introtext = introtext .. type2Keywords[self.type]
      if num == 10 then
        introtext = introtext .. "10\229\128\139\239\188\154"
      else
        introtext = introtext .. "1\229\128\139\239\188\154"
      end
    else
      introtext = introtext .. T("\230\136\144\229\138\159\232\180\173\228\185\176")
      introtext = introtext .. type2Keywords[self.type]
      introtext = introtext .. T("%d\228\184\170", num)
      introtext = introtext .. T("\239\188\140\232\181\160\233\128\129\239\188\154")
    end
    local introLabel = ed.createLabelTTF(introtext, 20)
    introLabel:setColor(ccc3(255, 239, 47))
    if self:isMagicTenBuy() or self:isNewMagicTenBuy() then
      introLabel:setPosition(ccp(400, 430))
    else
      introLabel:setPosition(introLabelPosTbl[self.type])
    end
    introLabel:setScale(0)
    self.container:addChild(introLabel, -1)
    self.introLabel = introLabel
    local eid = type2equipid[self.type]
    ed.player:addEquip(eid, num)
  end
end

class.createIntroLabel = createIntroLabel
local fca_res = {
  bronze = "eff_UI_tarven_open_naru",
  silver = "eff_UI_tarven_open_naru",
  gold = "eff_UI_tarven_open_naru",
  magic = "eff_UI_tavern_open_magicsoul",
  newmagic = "eff_UI_tavern_open_magicsoul",
  starshop = "eff_UI_tarven_open_chest_gold",
  stone_green = "eff_UI_shop_star_box_green",
  stone_blue = "eff_UI_shop_star_box_blue",
  stone_purple = "eff_UI_shop_star_box_purple",
  skin = "eff_UI_tavern_open_skin"
}

local function playBoxAnim(self)
  self:createIntroLabel()
  local type = self.type
  local times = self.times
  local bscale = 1.5
  local bpos = ccp(400, 240)
  local epos
  local endScale = 0.5
  if times == "one" then
    epos = ccp(0, 110)
  elseif ed.isElementInTable(self.times, {
    "ten",
    "hundred",
    "thousand"
  }) then
    epos = ccp(0, 120)
  end
  if self.type == "magic" or self.type == "newmagic" then
    bpos = ccp(400, 80)
    epos = bpos
    bscale = 1
    endScale = 1
  end
  if self.type == "starshop" then
    epos = ccp(0, 120)
    bscale = 1
  end
  lsr:report("openBoxAnim")
  local boxContainer
  if self.type == "magic" or self.type == "newmagic" then
    boxContainer = CCSprite:create()
    boxContainer:setCascadeOpacityEnabled(true)
  else
    boxContainer = CCLayer:create()
  end
  self.boxContainer = boxContainer
  self.container:addChild(boxContainer, 20)
  local noDelay
  if self:isMagicTenBuy() or self:isNewMagicTenBuy() then
    noDelay = 0
  else
    local boxFcaRes = fca_res[self.boxType]
    local box
    if self.again then
      if self.type ~= "magic" and self.type ~= "newmagic" then
        box = ed.createFcaActor(boxFcaRes)
        box:setAction("Loop")
        box:setLoop(true)
      end
    else
      box = ed.createFcaNode(boxFcaRes)
    end
    if box then
      self.boxContainer:addChild(box)
      self.baseScene:addFca(box)
      box:setPosition(bpos)
      box:setScale(bscale)
      self.box = box
    end
  end
  local as = {}
  if self.type == "magic" or self.type == "newmagic" then
    local dt = noDelay or self.again and 0 or 1.2
    local delay = CCDelayTime:create(dt)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self:createMatrixContainerAnim()
      end, EDDeug)
    end)
    as = {
      t = "seq",
      delay,
      func
    }
  else
    local dt = noDelay or self.again and 0 or 1.5
    local delay = CCDelayTime:create(dt)
    local s = CCScaleTo:create(0.3, endScale)
    s = CCEaseSineOut:create(s)
    local m = CCMoveTo:create(0.3, epos)
    m = CCEaseSineOut:create(m)
    s = CCSpawn:createWithTwoActions(s, m)
    local func = CCCallFunc:create(function()
      xpcall(function()
        local info = {
          cliprect = CCRectMake(0, 80, 800, 230),
          noshade = true,
          container = self.container,
          priority = self.mainTouchPriority - 5,
          zorder = 20
        }
        self.lootDraglist = ed.draglist.create(info)
        self:playLootAnim(1)
      end, EDDebug)
    end)
    as = {
      t = "seq",
      delay,
      s,
      func
    }
  end
  boxContainer:runAction(ed.readaction.create(as))
end

class.playBoxAnim = playBoxAnim

local function createMatrixAnim(self)
  local fo = CCFadeTo:create(2, 100)
  local fi = CCFadeTo:create(2, 255)
  local s = CCSequence:createWithTwoActions(fo, fi)
  s = CCRepeatForever:create(s)
  self.matrixui.matrix:runAction(s)
  self:playLootAnim(1)
end

class.createMatrixAnim = createMatrixAnim

local function createMatrixContainerAnim(self)
  local matrixContainer = CCSprite:create()
  matrixContainer:setCascadeOpacityEnabled(true)
  matrixContainer:setPosition(ccp(400, 170))
  matrixContainer:setScaleX(1.2)
  matrixContainer:setScaleY(0.45)
  self.container:addChild(matrixContainer)
  self.matrixContainer = matrixContainer
  local matrix = ed.createSprite("UI/alpha/HVGA/tavern_magicsoul_circle_1.png")
  matrixContainer:addChild(matrix)
  matrix:setRotation(30)
  local matrixStar = ed.createSprite("UI/alpha/HVGA/tavern_magicsoul_circle_2.png")
  matrixStar:setPosition(ccp(0, 60))
  matrixContainer:addChild(matrixStar)
  matrixStar:setRotation(30)
  matrixStar:setVisible(false)
  local isMagicTen = self:isMagicTenBuy() or self:isNewMagicTenBuy()
  if isMagicTen then
    matrixContainer:setPositionY(matrixContainer:getPositionY() + 110)
  end
  self.matrixui = {matrix = matrix, star = matrixStar}
  matrixContainer:setOpacity(0)
  local fin = CCFadeIn:create(0.2)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not isMagicTen then
        self:createMatrixAnim()
      end
    end, EDDebug)
  end)
  local s = CCSequence:createWithTwoActions(fin, func)
  matrixContainer:runAction(s)
end

class.createMatrixContainerAnim = createMatrixContainerAnim

local function getLootPos(self, index)
  if self.type == "magic" or self.type == "newmagic" then
    local pos = ccpAdd(matrix_center_pos, magic_loot_pos[index])
    return pos.x, pos.y
  elseif self.type == "starshop" then
    local ox, oy, dx, dy
    if resource_config.starshop_loots_seperated then
      ox, oy = 255, 250
      dx, dy = 125, 105
    else
      ox, oy = 305, 250
      dx, dy = 100, 105
    end
    local x = ox + dx * ((index - 1) % 3)
    local y = oy - dy * math.floor((index - 1) / 3)
    return x, y
  else
    local ox, oy
    local dx, dy = 100, 105
    if self.times == "one" then
      ox, oy = 400, 200
    elseif ed.isElementInTable(self.times, {
      "ten",
      "hundred",
      "thousand"
    }) then
      ox, oy = 190, 250
      if resource_config.tavern_loot_seperate then
        ox = 140
        dx = 130
      end
    end
    local x = ox + dx * ((index - 1) % 5)
    local y = oy - dy * math.floor((index - 1) / 5)
    return x, y
  end
end

class.getLootPos = getLootPos

local function playMagicLootShadeAnim(self, index)
  local x, y
  if self:isMagicTenBuy() or self:isNewMagicTenBuy() then
    x, y = self:getMagicRewardHeroIconPos(index)
  else
    x, y = self:getLootPos(index)
  end
  local up = ccp(x, y)
  local dp = ccp(x, y - 60)
  local icon = ed.createSprite("UI/alpha/HVGA/tavern_magicsoul_item_bg.png")
  icon:setPosition(dp)
  icon:setScale(0)
  self.container:addChild(icon)
  local a = CCArray:create()
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseSineIn:create(s)
  local m = CCMoveTo:create(0.2, up)
  m = CCEaseSineOut:create(m)
  local f = CCFadeOut:create(1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      icon:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  local as = {
    s,
    m,
    f
  }
  for i = 1, #as do
    a:addObject(as[i])
  end
  s = CCSpawn:create(a)
  s = CCSequence:createWithTwoActions(s, func)
  icon:runAction(s)
end

class.playMagicLootShadeAnim = playMagicLootShadeAnim
local light_res = {
  "UI/alpha/HVGA/tavern_get_item_bg_light_blue.png",
  "UI/alpha/HVGA/tavern_get_item_bg_light_blue.png",
  "UI/alpha/HVGA/tavern_get_item_bg_light_blue.png",
  "UI/alpha/HVGA/tavern_get_item_bg_light_purple.png",
  "UI/alpha/HVGA/tavern_get_item_bg_light_purple.png",
  "UI/alpha/HVGA/tavern_get_item_bg_light_orange.png"
}

local function playBurst(self, icon, quality)
  if nil == icon then
    return
  end
  local light = ed.createSprite(light_res[quality])
  light:setPosition(ccp(33, 35))
  icon:addChild(light, -3)
  light:setScale(1 / icon:getScale())
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
end

class.playBurst = playBurst

local function createLootAnim(self, index, param)
  param = param or {}
  local skipCheckHero = param.skipCheckHero
  local boxType = self.type
  local loots = self.loots
  local times = self.times
  local loot = loots[index]
  local type = ed.itemType(loot.id)
  if self.times == "hundred" then
    self.lootDraglist:setListPos(ccp(0, -220))
  end
  local ih, ihid = isHero(loot)
  if not skipCheckHero and ih then
    local function handler(self, index)
      local function hd()
        self:playLootAnim(index, {skipCheckHero = true})
      end
      
      return hd
    end
    
    ed.ui.SummonRewardCardWindow.create({
      rewards = {
        {
          id = ihid,
          amount = loot.amount,
          type = "hero"
        }
      },
      noRewards = true
    }):popWindow()
    return
  end
  local bpos = ccp(400, 350)
  local x, y = self:getLootPos(index)
  local epos = ccp(x, y)
  local icon, prop, listIcon
  if boxType == "magic" or boxType == "newmagic" then
    icon, prop = ed.readequip.createIconWithAmount(loot.id, nil, loot.amount)
    self:createCritItem(self.type, icon, loot.amount, loot.id)
    self.container:addChild(icon)
    self.lootIcons[index] = listIcon
  else
    listIcon = ed.readequip.createIconWithAmount(loot.id, nil, loot.amount)
    self.lootDraglist:addItem(listIcon)
    self.lootIcons[index] = listIcon
    listIcon:setPosition(epos)
    if not self.isSkipLootAnim then
      icon, prop = ed.readequip.createIconWithAmount(loot.id, nil, loot.amount)
      self.container:addChild(icon, 60)
      listIcon:setVisible(false)
    end
    epos = self.lootDraglist.listLayer:convertToWorldSpace(epos)
  end
  if boxType ~= "magic" and boxType ~= "newmagic" and not self.isSkipLootAnim then
    local shadow = ed.createSprite("UI/alpha/HVGA/tavern_get_item_bg_light_white.png")
    shadow:setPosition(ccp(35, 35))
    icon:addChild(shadow)
    local fo = CCFadeOut:create(0.4)
    shadow:runAction(fo)
  end
  local s
  if isHero(loot) then
    if not self.isSkipLootAnim then
      icon:setPosition(epos)
      local gap1 = 0.2
      s = CCScaleTo:create(gap1, 1)
      s = CCEaseBackOut:create(s)
    end
  elseif boxType ~= "magic" then
    if not self.isSkipLootAnim then
      icon:setScale(0)
      icon:setPosition(bpos)
      local a1 = CCArray:create()
      local gap1 = 0.2
      s = CCScaleTo:create(gap1, 1)
      s = CCEaseSineOut:create(s)
      local m = CCMoveTo:create(gap1, epos)
      m = CCEaseSineOut:create(m)
      local r = CCRotateBy:create(gap1, 720)
      r = CCEaseSineOut:create(r)
      a1:addObject(s)
      a1:addObject(m)
      a1:addObject(r)
      s = CCSpawn:create(a1)
    end
  else
    icon:setPosition(epos)
    icon:setOpacity(0)
    icon:setScale(0)
    local d = CCDelayTime:create(0.1)
    local f = CCFadeIn:create(0.2)
    s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    s = CCSpawn:createWithTwoActions(f, s)
    s = CCSequence:createWithTwoActions(d, s)
    self:playMagicLootShadeAnim(index)
  end
  
  local function callback()
    local iconName = self:createEquipName(loot.id, icon, prop, x, y, loot.amount)
    if boxType == "magic" or boxType == "newmagic" then
      self.container:addChild(iconName)
    else
      removeNode(icon)
      listIcon:setVisible(true)
      self.lootDraglist:addItem(iconName)
    end
    self:playLootAnim(index + 1)
  end
  
  if not self.isSkipLootAnim then
    local f = CCCallFunc:create(function()
      xpcall(function()
        callback()
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    icon:runAction(s)
  else
    callback()
  end
  lsr:report("showLootAnim")
end

class.createLootAnim = createLootAnim

local function playLootAnim(self, index, param)
  param = param or {}
  local loots = self.loots
  self.lootIcons = self.lootIcons or {}
  if self.introLabel then
    self.introLabel:runAction(CCScaleTo:create(0.2, 1))
  end
  if index > #loots then
    if self.times == "hundred" or self.times == "thousand" then
      self.lootDraglist:refreshListHeight(30, false)
      self.lootDraglist:setTouchEnabled(false)
      self.lootDraglist.listLayer:runAction(ed.readaction.create({
        t = "seq",
        CCMoveTo:create(1, ccp(0, 0)),
        CCCallFunc:create(function()
          xpcall(function()
            self:playButtonAnim()
            self.lootDraglist:setTouchEnabled(true)
          end, EDDebug)
        end)
      }))
    else
      self:playButtonAnim()
    end
  else
    self:createLootAnim(index, param)
  end
end

class.playLootAnim = playLootAnim
local iconres = {
  Gold = "UI/alpha/HVGA/task_gold_icon_2.png",
  silver = "UI/alpha/HVGA/task_rmb_icon_2.png",
  Diamond = "UI/alpha/HVGA/task_rmb_icon_2.png",
  magic = "UI/alpha/HVGA/task_rmb_icon_2.png"
}

local function createCostEquipIcon(self, times)
  local icon
  local cost = ed.ui.tavernScene:getCost(self.type, times)
  print("times-----------------" .. times)
  if cost.pay == "ticket" then
    local id = cost.id
    print("ticket" .. id)
    icon = ed.readequip.createIcon(tonumber(id))
    icon:setScale(0.35)
  else
    icon = ed.createSprite(iconres[cost.pay])
  end
  return icon
end

class.createCostEquipIcon = createCostEquipIcon

local function playButtonAnim(self)
  local tvText
  local times = self.times
  if times == "one" then
    tvText = T("\229\134\141\228\185\176\228\184\128\228\184\170")
  elseif ed.isElementInTable(self.times, {
    "ten",
    "hundred",
    "thousand"
  }) then
    tvText = T("\229\134\141\228\185\176\229\141\129\228\184\170")
    if self.type == "bronze" then
      tvText = T("\229\134\141\228\185\176\231\153\190\228\184\170")
    end
  end
  if self:isMagicTenBuy() then
    tvText = T("\229\134\141\228\185\176\228\184\128\228\184\170")
  end
  local ui = self.ui
  local ui_info
  if ed.isElementInTable(self.type, {"starshop"}) then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "ok",
          res = "UI/alpha/1080P/common/tavern_button_normal_1.png"
        },
        layout = {
          position = ccp(400, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ok_press",
          res = "UI/alpha/1080P/common/tavern_button_normal_2.png",
          parent = "ok"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "ok_label",
          text = T("\231\161\174\229\174\154"),
          size = 18,
          parent = "ok"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {}
      }
    }
    local readNode = ed.readnode.create(self.container, ui)
    readNode:addNode(ui_info)
  else
    local pay = self.cost.pay
    local cost = self.cost.number
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "cost_bg",
          res = "UI/alpha/1080P/common/tip_detail_bg.png"
        },
        layout = {
          position = ccp(0, 0)
        },
        config = {
          scalexy = {y = 2}
        }
      },
      {
        t = "Sprite",
        base = {name = "cost_icon", res = ""},
        layout = {
          position = ccp(160, 48)
        }
      },
      {
        t = "Label",
        base = {
          name = "cost",
          text = cost,
          size = 18
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(240, 50)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "tavern",
          res = "UI/alpha/HVGA/tavern_button_1.png"
        },
        layout = {
          position = ccp(310, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "tavern_press",
          res = "UI/alpha/HVGA/tavern_button_2.png",
          parent = "tavern"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "tavern_label",
          text = tvText,
          size = 18,
          parent = "tavern"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {
          color = ccc3(231, 206, 19)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "up_crit_tip",
          res = "UI/alpha/HVGA/new_soulchest/NSC_CriticalTag.png",
          parent = "tavern"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(2.5, 1)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "cost_10_bg",
          res = "UI/alpha/1080P/common/tip_detail_bg.png"
        },
        layout = {
          position = ccp(0, 0)
        },
        config = {
          scalexy = {y = 2},
          visible = false
        }
      },
      {
        t = "Sprite",
        base = {
          name = "cost_10_icon",
          res = ""
        },
        layout = {
          position = ccp(160, 48)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "cost_10",
          text = "4000",
          size = 18
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(240, 50)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "tavern_Crit_img",
          res = ""
        },
        layout = {
          position = ccp(190, 90)
        },
        config = {visible = true}
      },
      {
        t = "Sprite",
        base = {
          name = "tavern_10",
          res = "UI/alpha/HVGA/tavern_button_1.png"
        },
        layout = {
          position = ccp(310, 50)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "tavern_10_press",
          res = "UI/alpha/HVGA/tavern_button_2.png",
          parent = "tavern_10"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "tavern_10_label",
          text = T("\229\134\141\228\185\176\229\141\129\228\184\170"),
          size = 18,
          parent = "tavern_10"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {
          color = ccc3(231, 206, 19),
          visible = false
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ok",
          res = "UI/alpha/1080P/common/tavern_button_normal_1.png"
        },
        layout = {
          position = ccp(508, 50)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "ok_press",
          res = "UI/alpha/1080P/common/tavern_button_normal_2.png",
          parent = "ok"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "ok_label",
          text = T("\231\161\174\229\174\154"),
          size = 18,
          parent = "ok"
        },
        layout = {
          position = ccp(64, 25)
        },
        config = {}
      }
    }
    local readNode = ed.readnode.create(self.container, ui)
    readNode:addNode(ui_info)
    local cost_icon = ui.cost_icon
    local cost_10_icon = ui.cost_10_icon
    if self.type == "bronze" then
      if times == "one" then
        cost_icon:addChild(self:createCostEquipIcon("one"))
      else
        cost_icon:addChild(self:createCostEquipIcon("hundred"))
      end
      cost_10_icon:addChild(self:createCostEquipIcon("thousand"))
    else
      cost_icon:addChild(self:createCostEquipIcon("ten"))
      cost_10_icon:addChild(self:createCostEquipIcon("hundred"))
    end
    local cost = ed.ui.tavernScene:getCost(self.type, "hundred")
    ui.cost_10:setString(cost.number)
    local cl = ui.cost
    local ci = ui.cost_icon
    local w = cl:getContentSize().width
    ci:setAnchorPoint(ccp(1, 0.5))
    ci:setPosition(ccp(220 - w, 48))
    w = w + ci:getContentSize().width
    local cb = ui.cost_bg
    cb:setPosition(ccp(220 - w / 2, 50))
    if self.type ~= "newmagic" then
      ui.tavern_Crit_img:setVisible(false)
    elseif self.times == "ten" then
      ui.up_crit_tip:setVisible(ed.tavern.manager:isUpSoulHero(self.heroId) and not ed.tavern.manager:isUpSoulEnd())
    end
    local tkeys = {
      "FTBronzeClose",
      "FTGoldClose"
    }
  end
  if "magic" == self.type then
    self:adjustTenfold()
  end
  if self:isShowHundredTavern() then
    ed.setLabelString(ui.tavern_10_label, T("\229\134\141\228\185\176\231\153\190\228\184\170"))
    local cost = ed.ui.tavernScene:getCost(self.type, "hundred")
    if self.type == "bronze" then
      ed.setLabelString(ui.tavern_10_label, T("\229\134\141\228\185\176\229\141\131\228\184\170"))
      cost = ed.ui.tavernScene:getCost(self.type, "thousand")
    end
    ed.setLabelString(ui.cost_10, cost.number)
    self:adjustTenfold(true)
  end
  self:registerTouchHandler()
end

class.playButtonAnim = playButtonAnim

local function createCritItem(self, box, icon, amount, id)
  if box == "newmagic" and ed.newmagic_multi and amount / ed.newmagic_multi > 1 then
    local type = ed.itemType(id)
    if type == "equip" then
      local row = ed.getDataTable("equip")[id]
      local cg = row.Category
      if cg == T("\231\129\181\233\173\130\231\159\179") then
        local node, ui = ed.editorui(ed.uieditor.CritItem)
        node:setPosition(ccp(70, 62))
        if icon then
          icon:addChild(node, 20)
        end
        ui.lable_tip_2:setString("x" .. amount / ed.newmagic_multi)
        ui.lable_tip_1:setShadow(ccc3(0, 0, 0), ccp(0, 2))
        ui.lable_tip_2:setShadow(ccc3(0, 0, 0), ccp(0, 2))
        if amount / ed.newmagic_multi == 10 then
          ed.setTexture(ui.bg, "UI/alpha/HVGA/new_soulchest/NSC_NewBonusMark.png")
          ui.lable_tip_1:setShadow(ccc3(82, 8, 129), ccp(0, 2))
          ui.lable_tip_2:setShadow(ccc3(82, 8, 129), ccp(0, 2))
        end
      end
    end
  end
end

class.createCritItem = createCritItem

local function createEquipName(self, id, icon, prop, x, y, amount)
  local name
  local type = ed.itemType(id)
  if type == "hero" then
    name = ed.getDataTable("Unit")[id]["Display Name"]
    self:playBurst(icon, 6)
  elseif type == "equip" then
    local row = ed.getDataTable("equip")[id]
    name = row.Name
    local cg = row.Category
    local q = row.Quality
    local mq
    if cg == T("\231\129\181\233\173\130\231\159\179") then
      if ed.isElementInTable(self.type, {
        "newmagic",
        "magic",
        "starshop"
      }) then
        self:playBurst(icon, 6)
      else
        mq = self.baseScene:getExRank(self.type)
        if q >= mq then
          self:playBurst(icon, q)
        end
      end
    else
      local lootIcon
      if cg == T("\231\162\142\231\137\135") then
        lootIcon = icon
      else
        lootIcon = prop
      end
      if self.type == "starshop" then
        local tkeys = {
          stone_green = 8,
          stone_blue = 9,
          stone_purple = 10
        }
        mq = ed.getDataTable("TavernBoxType")[tkeys[self.boxType]][1]["Exhibition Rank"]
      else
        mq = self.baseScene:getExRank(self.type)
      end
      if q >= mq then
        self:playBurst(lootIcon, q)
      end
    end
  end
  if ed.isComplexText(name) then
    name = ed.createNode({
      t = "ComplexLabel",
      base = {text = name, size = 18},
      layout = {
        position = ccp(x, y - 45)
      }
    })
  else
    name = ed.createNode({
      t = "Label",
      base = {text = name, size = 18},
      layout = {
        position = ccp(x, y - 45)
      },
      config = {
        stroke = {
          color = ccc3(0, 0, 0),
          size = 2
        }
      }
    })
  end
  local size = name:getContentSize()
  if not resource_config.tavern_lootname_no_scale and size.width > 100 then
    name:setScale(100 / size.width)
  end
  return name
end

class.createEquipName = createEquipName

local function isMagicTenBuy(self)
  return "ten" == self.times and "magic" == self.type
end

class.isMagicTenBuy = isMagicTenBuy

local function isNewMagicTenBuy(self)
  return "ten" == self.times and "newmagic" == self.type
end

class.isNewMagicTenBuy = isNewMagicTenBuy

local function isOpenMagicTenBuy(self)
  local id = 959
  if ed.player:getEquipAmount(id) >= 1 then
    return true
  end
  local vip = ed.player:getvip()
  local row = ed.getDataTable("VIP")[vip]
  if row["Soul Box Quick Purchase"] then
    return true
  end
  return false
end

class.isOpenMagicTenBuy = isOpenMagicTenBuy

local function adjustTenfold(self, force)
  if force or self:isOpenMagicTenBuy() then
    local ui = self.ui
    local dx = 150
    ui.ok:setPositionX(ui.ok:getPositionX() + dx)
    ui.tavern:setPositionX(ui.tavern:getPositionX() + dx)
    ui.cost_bg:setPositionX(ui.cost_bg:getPositionX() + dx)
    ui.cost_icon:setPositionX(ui.cost_icon:getPositionX() + dx)
    ui.cost:setPositionX(ui.cost:getPositionX() + dx)
    ui.cost_10_bg:setVisible(true)
    ui.cost_10_icon:setVisible(true)
    ui.cost_10:setVisible(true)
    ui.tavern_10:setVisible(true)
    ui.tavern_10_label:setVisible(true)
    ui.tavern_10:setPositionX(230)
    ui.cost_10_bg:setPosition(120, 50)
    ed.left2(ui.cost_10, ui.tavern_10)
    ed.left2(ui.cost_10_icon, ui.cost_10, 20)
  end
end

class.adjustTenfold = adjustTenfold

local function getMagicRewardHeroIconPos(self, index)
  local ox, oy = 190, 355
  local dx, dy = 100, 105
  local x = ox + dx * ((index - 1) % 5)
  local y = oy - dy * math.floor((index - 1) / 5)
  return x, y
end

class.getMagicRewardHeroIconPos = getMagicRewardHeroIconPos

local function getMagicRewardEquipIconPos(self, index)
  index = index - 10
  local ox, oy = 168, 150
  local dx, dy = 65, 65
  local x = ox + dx * ((index - 1) % 8)
  local y = oy - dy * math.floor((index - 1) / 8)
  return x, y
end

class.getMagicRewardEquipIconPos = getMagicRewardEquipIconPos

local function playEquipListAnim(self)
  if self.equipsAnim then
    for idx, item in pairs(self.equipsAnim) do
      item.icon:runAction(item.action)
    end
  end
end

class.playEquipListAnim = playEquipListAnim

local function heroIconPressIn(self)
  local function handler(x, y)
    for index, item in pairs(self.heroIcons) do
      if ed.containsPoint(item.icon, x, y) then
        item.icon:setScale(0.95)
        
        local panel = self:createLootCard(item.id)
        local x, y = item.icon:getPosition()
        panel:setPosition(ccp(x, y + 35))
        return index
      end
    end
  end
  
  return handler
end

class.heroIconPressIn = heroIconPressIn

local function heroIconPressOut(self)
  local function handler(x, y, index)
    self.heroIcons[index].icon:setScale(1)
    
    self:destroyLootCard()
  end
  
  return handler
end

class.heroIconPressOut = heroIconPressOut

local function createDragListLayer(self)
  local info = {
    cliprect = CCRectMake(138, 80, 525, 320),
    noshade = true,
    container = self.container,
    priority = self.mainTouchPriority - 5,
    zorder = 20,
    doPressIn = self:heroIconPressIn(),
    cancelPressIn = self:heroIconPressOut()
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:initListHeight(350)
end

class.createDragListLayer = createDragListLayer

local function createEquipList(self)
  self.equipsAnim = self.equipsAnim or {}
  local movedt = 0.5
  local x, y = 0, 0
  local default = 50
  for index = 11, #self.loots do
    local icon = ed.readequip.createIconWithAmount(self.loots[index].id, nil, self.loots[index].amount)
    local scale = default / icon:getContentSize().width
    x, y = self:getMagicRewardEquipIconPos(index)
    icon:setScale(scale)
    icon:setPosition(ccp(x, y - 95))
    self:createCritItem(self.type, icon, self.loots[index].amount, self.loots[index].id)
    local iconName = self:createEquipName(self.loots[index].id, nil, nil, x, y - 95, self.loots[index].amount)
    iconName:setScale(scale)
    self.draglist:addItem(iconName)
    self.draglist:addItem(icon)
    table.insert(self.equipsAnim, {
      icon = icon,
      action = CCMoveTo:create(movedt, ccp(x, y))
    })
    table.insert(self.equipsAnim, {
      icon = iconName,
      action = CCMoveTo:create(movedt, ccp(x, y - 30))
    })
  end
end

class.createEquipList = createEquipList

local function popHeroCard(self, param)
  ed.ui.SummonRewardCardWindow.create({
    rewards = {
      {
        id = param.id,
        amount = param.amount,
        type = "hero"
      }
    },
    noRewards = true,
    callback = param.handler
  }):popWindow()
end

class.popHeroCard = popHeroCard

local function createDelimiter(self, pos, scalexy)
  local type = "Sprite"
  local name = "delimiter"
  local res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
  local layout = {position = pos}
  local config = {visible = true, scalexy = scalexy}
  local delimiter = ed.createNode({
    t = type,
    base = {name = name, res = res},
    layout = layout,
    config = config
  })
  return delimiter
end

class.createDelimiter = createDelimiter

local function doneCallback(self, loot, x, y, doneHandler)
  local iconName = self:createEquipName(loot.id, nil, nil, x, y, loot.amount)
  iconName:setPosition(x, y - 50)
  self.draglist:addItem(iconName)
  local bHero, hId = isHero(loot)
  if bHero then
    self:popHeroCard({
      id = hId,
      amount = loot.amount,
      handler = doneHandler
    })
  else
    doneHandler()
  end
end

class.doneCallback = doneCallback

local function createActions(self, dt)
  local delay = CCDelayTime:create(dt)
  local fadeIn = CCFadeIn:create(2 * dt)
  local scaleTo = CCScaleTo:create(2 * dt, 1)
  local easeBO = CCEaseBackOut:create(scaleTo)
  local spawn = CCSpawn:createWithTwoActions(fadeIn, easeBO)
  local show = CCShow:create()
  local actAras = CCArray:create()
  actAras:addObject(delay)
  actAras:addObject(spawn)
  actAras:addObject(show)
  return actAras
end

class.createActions = createActions

local function doMagicTenBuy(self)
  self:createDragListLayer()
  self:createIntroLabel()
  self.introLabel:runAction(CCScaleTo:create(0.2, 1))
  self:createMatrixContainerAnim()
  self.heroIcons = self.heroIcons or {}
  self.index = 0
  
  local function handler()
    self.index = self.index + 1
    if self.index <= 10 then
      local loot = self.loots[self.index]
      local x, y = self:getMagicRewardHeroIconPos(self.index)
      local icon = ed.readequip.createIconWithAmount(self.loots[self.index].id, nil, self.loots[self.index].amount)
      self:createCritItem(self.type, icon, self.loots[self.index].amount, self.loots[self.index].id)
      icon:setVisible(false)
      icon:setPosition(ccp(x, y))
      self.draglist:addItem(icon)
      table.insert(self.heroIcons, {
        icon = icon,
        id = loot.id
      })
      self:playMagicLootShadeAnim(self.index)
      lsr:report("showLootAnim")
      local done = CCCallFunc:create(function()
        self:doneCallback(loot, x, y, handler)
      end)
      local actAras = self:createActions(0.1)
      actAras:addObject(done)
      local seqAct = CCSequence:create(actAras)
      icon:runAction(seqAct)
    elseif 11 == self.index then
      self.draglist:addItem(self:createDelimiter(ccp(400, 185), {x = 1.4, y = 1.2}))
      self:playButtonAnim()
      self:createEquipList()
      self:playEquipListAnim()
    end
  end
  
  xpcall(handler, EDDebug)
end

class.doMagicTenBuy = doMagicTenBuy
