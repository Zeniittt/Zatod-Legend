local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.stagedetail = class
class.LootDropSituation = {
  ["Least Level"] = function(situationParam)
    local level = situationParam
    return level <= ed.player:getLevel()
  end
}

function class.checkDropSituation(itemId)
  local lootCfg = ed.getDataTable("Loot")[itemId]
  if not lootCfg then
    return true
  end
  local dropSituation = lootCfg["Drop Situation"]
  if lootCfg and dropSituation and class.LootDropSituation[dropSituation] then
    local dropParam = lootCfg["Situation Param"]
    return class.LootDropSituation[dropSituation](dropParam)
  end
  return true
end

local maxReward = 20
local res = ed.ui.stagedetailres
local lsr = ed.ui.stagedetaillsr.create()
local delta = 20
local sweepAct = {
  102,
  103,
  105,
  300
}
local isSweep = false
local confirmHeroTaskStep = 2

local function readSweepReply(self, info)
  local list = {}
  local wave = info._loot
  for k, v in pairs(wave) do
    local exp = v._exp
    local money = v._money
    local ll = {
      exp = exp,
      money = money,
      loots = {}
    }
    for ck, cv in pairs(v._items or {}) do
      local id, amount = ed.analyzeItem2(cv)
      table.insert(ll.loots, {id = id, amount = amount})
    end
    table.insert(list, ll)
  end
  local el = {
    loots = {}
  }
  for k, v in pairs(info._items or {}) do
    local id, amount = ed.analyzeItem2(v)
    table.insert(el.loots, {id = id, amount = amount})
  end
  table.insert(list, el)
  return list
end

class.readSweepReply = readSweepReply

local function doSendSweepReply(self, sweep, isOnce)
  local sweep = sweep
  
  local function handler(info)
    ed.delayHandleNotifyMsgData = true
    self:resetSweepLabel()
    local lootList = self:readSweepReply(info)
    local sweepWindow = ed.ui.repeatRewardWindow.create(lootList, {
      stageId = self.stage,
      times = self.times,
      getWayItemId = self.getWayItemId,
      getWayItemNeed = self.getWayItemNeed,
      isOnce = isOnce
    })
    sweepWindow:popWindow()
    self:refreshStageLimit()
    self:refreshSweepSomeLabel()
    self:refreshSweepContainer()
  end
  
  return handler
end

class.doSendSweepReply = doSendSweepReply

local function getSweepPrice(self, times)
  local price = ed.parameter.pay_sweep_unit_price
  price = price * times
  return price
end

class.getSweepPrice = getSweepPrice

local function isSweepMode()
  return isSweep
end

class.isSweepMode = isSweepMode

local function setSweepMode(mode)
  isSweep = mode
end

class.setSweepMode = setSweepMode

local function canSweepHeroTask(self)
  local heroTask = ed.player:withHeroTask("working")
  if not heroTask then
    return
  end
  for k, sid in pairs(heroTask._sweepStages or {}) do
    if sid == self.stage then
      return true
    end
  end
end

class.canSweepHeroTask = canSweepHeroTask

function class:canSweepHeroSuperTask()
  local heroSuperTask = ed.player:withHeroSuperTask("working")
  if not heroSuperTask then
    return
  end
  for k, sid in pairs(heroSuperTask._sweepStages or {}) do
    if sid == self.stage then
      return true
    end
  end
end

function class:doSweep(type, times, isOnce)
  self.playerLevelPreSweep = ed.player:getLevel()
  if self:canSweepHeroTask() or self:canSweepHeroSuperTask() then
    self:setSweepMode(true)
  end
  ed.netdata.sweep = {
    type = type,
    times = times,
    power = self.stageInfo.power,
    cost = type == "pay" and self:getSweepPrice(times) or 0,
    stage = self.stage
  }
  ed.netreply.sweep = self:doSendSweepReply({
    stage = self.stage,
    times = times
  }, isOnce)
  local msg = ed.upmsg.sweep_stage()
  msg._type = type == "free" and "sweep_with_ticket" or "sweep_with_rmb"
  msg._stageid = self.stage
  msg._times = times
  ed.send(msg, "sweep_stage")
  self.times = times
  if self.identity == "exerciseStageDetail" then
    function ed.netreply.sweepReply()
      self.rtimes = self.rtimes + times
    end
    
    local sg = ed.getDataTable("Stage")[self.stage]["Stage Group"]
    ed.player:addActTimes(sg, times)
  end
end

local function doSweepConfirm(self, type, times)
  ed.showConfirmDialog({
    text = T("\230\156\172\230\172\161\230\137\171\232\141\161\228\184\141\232\174\161\229\133\165\232\139\177\233\155\132\232\167\137\233\134\146\228\187\187\229\138\161\230\172\161\230\149\176.\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
    rightHandler = function()
      self:doSweep(type, times)
    end
  })
end

class.doSweepConfirm = doSweepConfirm

local function doSendSweep(self, type, times, isOnce)
  local function handler()
    if times < 1 then
      return
    end
    local cost = self:getSweepPrice(times) or 0
    if type == "pay" and cost > ed.player._rmb then
      ed.showHandyDialog("toRecharge")
      return
    end
    self:doSweep(type, times, isOnce)
  end
  
  return handler
end

class.doSendSweep = doSendSweep

local function doPaySweepConfirm(self, times, isOnce)
  local price = self:getSweepPrice(times)
  ed.showConfirmDialog({
    text = T("\230\137\171\232\141\161\229\136\184\228\184\141\232\182\179\239\188\140\232\191\155\232\161\140\230\137\171\232\141\161\233\156\128\232\166\129\232\138\177\232\180\185 %d \233\146\187\231\159\179.\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", price),
    rightHandler = self:doSendSweep("pay", times, isOnce)
  })
end

class.doPaySweepConfirm = doPaySweepConfirm

local function refreshSweepSomeLabel(self)
  if not self.repeatui then
    return
  end
  if tolua.isnull(self.repeatui.some_label) then
    return
  end
  self:getRepeatInformation()
  local text = ""
  if self.repeatInfo.limit < 1 then
    text = T("\230\151\160\230\179\149\230\137\171\232\141\161")
  else
    text = T("\230\137\171\232\141\161%d\230\172\161", self.repeatInfo.limit)
  end
  ed.setString(self.repeatui.some_label, text)
end

class.refreshSweepSomeLabel = refreshSweepSomeLabel

local function doClickSweep(self, times, isOnce)
  times = times < 1 and 1 or times
  if self.addition.lootStage and self.addition.lootStage.bossId then
    local stageItemId
    for _, v in ipairs(ed.player:getStageSelectReward() or {}) do
      if v._stage_id == self.addition.lootStage.eid then
        stageItemId = v._reward_id
        break
      end
    end
    if not stageItemId then
      ed.showToast(T("\229\176\154\230\156\170\233\128\137\230\139\169\229\143\175\230\142\137\232\144\189\231\154\132\231\129\181\233\173\130\231\159\179"))
      ed.ui.stageChooseLootPop.create(self.addition.lootStage):popWindow()
      return
    end
  end
  local info = self.repeatInfo
  if self.addition.lootStage and self.addition.lootStage.eid then
    if not ed.ui.stageselectres.getLootStagesIsOpen(self.addition.lootStage.eid) then
      ed.showToast(T("\233\128\154\229\133\179\229\144\142\232\167\163\233\148\129\230\137\171\232\141\161"))
      return
    end
  elseif info.star < 3 then
    ed.showToast(T("\233\128\154\229\133\179\229\185\182\232\190\190\230\136\144\228\184\137\230\152\159\229\144\142\232\167\163\233\148\129\230\137\171\232\141\161"))
    return
  end
  ed.playEffect(ed.sound.deo.common_popup_window)
  if times > self.repeatInfo.cLimit and self.identity ~= "exerciseStageDetail" then
    ed.showToast(T("\232\175\165\229\133\179\229\141\161\232\191\155\229\133\165\230\172\161\230\149\176\229\183\178\232\190\190\230\156\172\230\151\165\228\184\138\233\153\144"))
    return
  end
  if self.identity == "exerciseStageDetail" and self.rtimes - self.leftTimes >= 0 then
    ed.showToast(T("\232\175\165\229\133\179\229\141\161\232\191\155\229\133\165\230\172\161\230\149\176\229\183\178\232\190\190\230\156\172\230\151\165\228\184\138\233\153\144"))
    return
  end
  if self.sendSweepTime then
    local time = ed.getSystemTime()
    if time - self.sendSweepTime < 1.5 then
      return
    end
  end
  local price = self:getSweepPrice(times)
  local vc = self.stageInfo.power * times
  if vc > ed.player:getVitality() then
    self:doBuyVitality()
    return
  end
  if times > self.repeatInfo.tLimit then
    self:doPaySweepConfirm(times, isOnce)
    return
  end
  self:doSendSweep("free", times, isOnce)()
  self.sendSweepTime = ed.getSystemTime()
end

class.doClickSweep = doClickSweep

local function doRepeatOnce(self)
  self:doClickSweep(1, true)
end

class.doRepeatOnce = doRepeatOnce

local function doRepeatSome(self)
  self:doClickSweep(self.repeatInfo.limit)
end

class.doRepeatSome = doRepeatSome

local function doRepeatOnceTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if not self.repeatui then
      return
    end
    if tolua.isnull(self.repeatui.once) then
      return
    end
    local ui = self.repeatui
    if event == "began" then
      if ed.containsPoint(ui.once, x, y) then
        isPress = true
        ui.once:setScale(1.05)
      end
    elseif event == "ended" then
      if isPress then
        ui.once:setScale(1)
        if ed.containsPoint(ui.once, x, y) and ui.once:isVisible() then
          self:doRepeatOnce()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doRepeatOnceTouch = doRepeatOnceTouch

local function doRepeatSomeTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if not self.repeatui then
      return
    end
    if tolua.isnull(self.repeatui.some) then
      return
    end
    local ui = self.repeatui
    if event == "began" then
      if ed.containsPoint(ui.some, x, y) and ui.some:isVisible() then
        isPress = true
        ui.some:setScale(1.05)
      end
    elseif event == "ended" then
      if isPress then
        ui.some:setScale(1)
        if ed.containsPoint(ui.some, x, y) and ui.some:isVisible() then
          self:doRepeatSome()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doRepeatSomeTouch = doRepeatSomeTouch

local function getRepeatInformation(self)
  local info = self.stageInfo
  local star = info.star
  local power = info.power
  local powerLimit = math.floor(ed.player:getVitality() / power)
  local countLimit
  if info.countLimit == 0 then
    countLimit = 999
  else
    countLimit = self:getLeftTimes()
  end
  local timeLimit = ed.player:getSweepTimes()
  local dt = ed.parameter.default_normal_sweep_times
  local limit
  if timeLimit == 0 then
    limit = dt
  else
    limit = math.min(timeLimit, dt)
  end
  limit = math.min(countLimit, limit)
  if ed.stageType(self.stage) == "elite" then
    limit = ed.parameter.default_elite_sweep_times
    limit = math.min(countLimit, limit)
    local vitality = ed.player:getVitality() or 0
    if vitality < self.stageInfo.power then
    else
      limit = math.min(math.floor(vitality / self.stageInfo.power), limit)
    end
  elseif ed.stageType(self.stage) == "act" then
    limit = self.leftTimes - self.rtimes
    limit = math.min(countLimit, limit)
  else
    local vitality = ed.player:getVitality() or 0
    limit = math.floor(vitality / self.stageInfo.power)
    if limit >= ed.parameter.default_normal_sweep_times then
      limit = ed.parameter.default_normal_sweep_times
    elseif vitality < self.stageInfo.power then
      limit = ed.parameter.default_normal_sweep_times
    end
  end
  if self:canSweepHeroTask() or self:canSweepHeroSuperTask() and self.identity == "exerciseStageDetail" then
    local herostage, hid, _ = ed.isHeroTaskStage(self)
    local issuperawake, shid, _ = ed.isHeroTaskStage(self, self.stage, "superawake")
    local heroTask = ed.player:withHeroTask("working")
    if issuperawake then
      heroTask = ed.player:withHeroSuperTask("working")
    end
    local row = ed.getDataTable("HeroTask")[heroTask._line][heroTask._id]
    local target = row["Task Target"]
    local pro = heroTask._task_target
    local heroLimt = target - pro
    if 0 < heroLimt then
      limit = math.min(heroLimt, limit)
    end
  end
  if self.identity == "exerciseStageDetail" then
    limit = self.leftTimes - self.rtimes
  end
  self.repeatInfo = {
    star = star,
    pLimit = powerLimit,
    cLimit = countLimit,
    tLimit = timeLimit,
    limit = limit
  }
end

class.getRepeatInformation = getRepeatInformation

local function filterCreateRepeatStage(self)
  local chapterID = ed.getDataTable("Stage")[self.stage]["Chapter ID"]
  if ed.isElementInTable(chapterID, sweepAct) then
    return true
  end
end

class.filterCreateRepeatStage = filterCreateRepeatStage

local function createRepeatBattle(self)
  if self.mode == "guild" or self.mode == "challenge" then
    return
  end
  if self.identity == "exerciseStageDetail" and not self:filterCreateRepeatStage() then
    return
  end
  if self.identity == "exerciseStageDetail" and ed.player:getLevel() < 42 then
    return
  end
  if not tolua.isnull(self.repeatContainer) then
    self.repeatContainer:removeFromParentAndCleanup(true)
  end
  self:getRepeatInformation()
  local stageTbl = self.StageConfig or ed.getDataTable("Stage")
  local keyStage = stageTbl[self.stage]["Key Stage"]
  if not keyStage then
    return
  end
  local repeatContainer = CCSprite:create()
  self.repeatContainer = repeatContainer
  if tolua.isnull(self.ui.frameBg) then
    return false
  end
  if self.ui.frameBg then
    self.ui.frameBg:addChild(repeatContainer)
  else
    return
  end
  local stext = ""
  if self.repeatInfo.limit < 1 then
    stext = T("\230\151\160\230\179\149\230\137\171\232\141\161")
  else
    stext = T("\230\137\171\232\141\161%d\230\172\161", self.repeatInfo.limit)
  end
  local btnY = self.ui.go_button:getPositionY()
  self.repeatui = {}
  local ui_info = class.mode_ui_info["repeat"]
  local readNode = ed.readnode.create(repeatContainer, self.repeatui)
  readNode:addNode(ui_info)
  self.repeatui.count:setPositionX(self.repeatui.last_title:getContentSize().width + 10)
  self.repeatui.last_title:setPositionY(btnY + 38)
  self.repeatui.some:setPositionY(btnY)
  self.repeatui.some_label:setPositionY(btnY)
  self.repeatui.once:setPositionY(btnY)
  self.repeatui.once_label:setPositionY(btnY)
  self.repeatui.some_label:setShadow(ccc3(ed.colorToStr("#141313")), ccp(1, 0))
  self.repeatui.once_label:setShadow(ccc3(ed.colorToStr("#141313")), ccp(1, 0))
  local info = self.repeatInfo
  ed.setString(self.repeatui.some_label, stext)
  ed.setString(self.repeatui.count, info.tLimit)
  self.repeatui.sweep_icon:setPositionX(self.repeatui.count:getContentSize().width + self.repeatui.count:getPositionX() + 20)
  local res = info.star < 3 and "UI/alpha/1080P/common/button_grey.png" or "UI/alpha/1080P/common/button_com_big.png"
  local cor = info.star < 3 and ccc3(253, 252, 229) or ccc3(253, 240, 158)
  if self.addition.lootStage and self.addition.lootStage.eid then
    if ed.ui.stageselectres.getLootStagesIsOpen(self.addition.lootStage.eid) then
      res = "UI/alpha/1080P/common/button_com_big.png"
      cor = ccc3(253, 240, 158)
    else
      res = "UI/alpha/1080P/common/button_grey.png"
      cor = ccc3(253, 252, 229)
    end
  end
  ed.initSpriteWithFrame(self.repeatui.some, res)
  ed.initSpriteWithFrame(self.repeatui.once, res)
  self.repeatui.some_label:setColor(cor)
  self.repeatui.once_label:setColor(cor)
  local type = ed.stageType(self.stage)
  if not ed.isElementInTable(type, {
    "normal",
    "elite",
    "act"
  }) then
    return
  end
  self:removeMainTouchHandler("buyRepeatTimeTouch")
  self:removeMainTouchHandler("repeatOnce")
  self:removeMainTouchHandler("repeatSome")
  if self:isSpring() and not canSweepHeroTask(self) then
    for k, v in pairs(ui_info) do
      if self.identity == "exerciseStageDetail" then
        break
      end
      if string.find(v.base.name, "some") then
        self.repeatui[v.base.name]:setVisible(false)
      elseif not string.find(v.base.name, "press") then
        print(v.base.name, self.repeatui[v.base.name]:getPositionY() - 40)
        if not string.find(v.base.name, "once") then
          self.repeatui[v.base.name]:setPositionY(self.repeatui[v.base.name]:getPositionY() - 40)
        else
          self.repeatui[v.base.name]:setPositionY(self.repeatui[v.base.name]:getPositionY() + 13)
        end
      end
    end
  end
  self:refreshSweepContainer()
end

class.createRepeatBattle = createRepeatBattle

local function heroTaskPro(heroTask)
  local row = ed.getDataTable("HeroTask")[heroTask._line][heroTask._id]
  local target = row["Task Target"]
  local pro = heroTask._task_target
  return T("%d/%d", pro, target)
end

local function createIcon(hid, ui)
  local icon = ed.readhero.getIcon({id = hid, length = 55})
  icon:setPosition(ccp(67, 117))
  ui.bg:addChild(icon)
end

local function resetSweepUI(self)
  local ui = self.repeatui
  ui.task_title:setVisible(true)
  ui.task_pro:setVisible(true)
  ui.last_title:setVisible(false)
  ui.sweep_icon:setVisible(false)
  ui.last_title_suffix:setVisible(false)
  ui.count:setVisible(false)
  local herostage, hid, _ = ed.isHeroTaskStage(self)
  local issuperawake, shid, _ = ed.isHeroTaskStage(self, self.stage, "superawake")
  if herostage then
    ui.once:setVisible(false)
    ui.once_label:setVisible(false)
    ui.some:setVisible(true)
    ui.some_label:setVisible(true)
    if self.isOffed ~= true then
      self.isOffed = true
      local offY = 50
      local px, py = ui.some:getPosition()
      ui.some:setPosition(px, py - offY)
      px, py = ui.some_label:getPosition()
      ui.some_label:setPosition(px, py - offY)
    end
    local heroTask = ed.player:withHeroTask("working")
    ed.setString(ui.task_pro, heroTaskPro(heroTask))
    createIcon(hid, ui)
  elseif issuperawake then
    ui.once:setVisible(true)
    ui.once_label:setVisible(true)
    ui.some:setVisible(false)
    ui.some_label:setVisible(false)
    local heroTask = ed.player:withHeroSuperTask("working")
    ed.setString(ui.task_pro, heroTaskPro(heroTask))
    createIcon(shid, ui)
  end
end

local function refreshSweepContainer(self)
  if canSweepHeroTask(self) or self:canSweepHeroSuperTask() then
    setSweepMode(false)
    resetSweepUI(self)
  end
  if not tolua.isnull(self.repeatContainer) then
    self.repeatContainer:setVisible(true)
  end
  self:registerMainTouchHandler("repeatOnce", self:doRepeatOnceTouch())
  self:registerMainTouchHandler("repeatSome", self:doRepeatSomeTouch())
end

class.refreshSweepContainer = refreshSweepContainer

local function registerMainTouchHandler(self, key, handler)
  self.mainTouchHandlerList = self.mainTouchHandlerList or {}
  self.mainTouchHandlerList[key] = handler
end

class.registerMainTouchHandler = registerMainTouchHandler

local function removeMainTouchHandler(self, key)
  self.mainTouchHandlerList = self.mainTouchHandlerList or {}
  self.mainTouchHandlerList[key] = nil
end

class.removeMainTouchHandler = removeMainTouchHandler

local function doResetEliteLimit(self, pay)
  local function handler(result)
    if not result then
      return
    end
    self:refreshStageLimit()
    self:createRepeatBattle()
  end
  
  return handler
end

class.doResetEliteLimit = doResetEliteLimit

local function doPayReset(self)
  local id = self.stage
  local cost = ed.player:getResetEliteCost(id)
  local times = ed.player:getStageLimitResetTimes(id)
  if resource_config.elite_stage_reset_max_limit then
    if times >= resource_config.elite_stage_reset_max_limit then
      ed.showToast(T("\228\187\138\230\151\165\231\178\190\232\139\177\229\133\179\233\135\141\231\189\174\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140"))
      return
    end
  elseif ed.player:checkStageLimitResetTimesMax(id) then
    ed.showHandyDialog("needHighervip", {
      number = times,
      name = T("\233\135\141\231\189\174\231\178\190\232\139\177\229\133\179")
    })
    return
  end
  if ed.netreply.resetElite then
    return
  end
  local info = {
    text = T("\233\135\141\231\189\174\229\133\179\229\141\161\232\191\155\229\133\165\230\172\161\230\149\176\233\156\128\232\166\129\232\138\177\232\180\185%d\233\146\187\231\159\179.\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159\239\188\136\228\187\138\230\151\165\229\183\178\233\135\141\231\189\174%d\230\172\161\239\188\137", cost, times),
    rightHandler = function()
      xpcall(function()
        self:doResetElite({pay = true})
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end

class.doPayReset = doPayReset

local function doResetElite(self, config)
  config = config or {}
  local pay = config.pay
  local id = self.stage
  local cost = ed.player:getResetEliteCost(id)
  if pay and cost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  ed.netdata.resetElite = {
    isPay = pay,
    cost = cost,
    stage = self.stage
  }
  ed.netreply.resetElite = self:doResetEliteLimit(pay)
  if pay then
    local msg = ed.upmsg.reset_elite()
    msg._type = 1
    msg._stageid = self.stage
    ed.send(msg, "reset_elite")
  else
    ed.player:resetEliteRequest_type0()
  end
end

class.doResetElite = doResetElite

local function checkResetEliteLimit()
  local lastTime = ed.player:getEliteResetTime()
  local time = ed.getServerTime()
  return ed.checkTwoDateod(lastTime, time)
end

class.checkResetEliteLimit = checkResetEliteLimit

local function doCheckResetEliteLimit(self)
  if self:checkResetEliteLimit() then
    self:doResetElite()
  end
end

class.doCheckResetEliteLimit = doCheckResetEliteLimit

local function resetSweepLabel(self)
  if not self.repeatui then
    return
  end
  if tolua.isnull(self.repeatui.count) then
    return
  end
  ed.setString(self.repeatui.count, ed.player:getSweepTimes())
  self:refreshSweepSomeLabel()
  self:checkEnabled()
end

class.resetSweepLabel = resetSweepLabel

local function doUpdateCheckResetHandler(self)
  local count = 0
  self:doCheckResetEliteLimit()
  
  local function handler(dt)
    count = count + dt
    if 60 < count then
      count = count - 60
      self:doCheckResetEliteLimit()
    end
  end
  
  return handler
end

class.doUpdateCheckResetHandler = doUpdateCheckResetHandler

local function isSpring(self)
  return self.actType == "spring"
end

class.isSpring = isSpring

function class.getStageName(stageId)
  local stageTable = ed.getDataTable("Stage")
  local row = stageTable[stageId]
  local stageName = row["Stage Name"]
  local chapter = row["Chapter ID"]
  local chapterTable = ed.getDataTable("Chapter")
  local chapterName = chapterTable[chapter]["Chapter Name"]
  return stageName, chapterName
end

local function getStageInformation(stage)
  local info = {}
  info.stage = stage
  local stageTable = ed.getDataTable("Stage")
  local row = stageTable[stage]
  info.chapter = row["Chapter ID"]
  local chapterTable = ed.getDataTable("Chapter")
  info.chapterName = chapterTable[info.chapter]["Chapter Name"]
  info.title = row["Stage Name"]
  info.titleName = row["Stage Name"]
  info.title = info.title
  info.detail = row.description
  info.star = ed.player:getStageStar(stage)
  info.power = row["Vitality Cost"]
  info.countLimit = row["Daily Limit"]
  if ed.player.stage_limit then
    info.count = ed.player.stage_limit[ed.elite2NormalStage(stage)] or 0
  else
    info.count = 0
  end
  return info
end

class.getStageInformation = getStageInformation

local function getResInformation(self, stage)
  local info = {}
  local type = ed.stageType(stage)
  if ed.isElementInTable(type, {
    "elite",
    "act",
    "challenge"
  }) then
    info.frameRes = ""
    info.framePos = res.framePosElite
    info.titleBgSize = CCSizeMake(404, 12)
    info.starLeft = 530
    info.starGap = 40
    info.goButtonPos = res.goButtonPosElite
    if self:filterCreateRepeatStage() then
      info.titleBgSize = CCSizeMake(424, 12)
    end
    if type == "challenge" then
      info.frameRes = ""
      info.starGap = 45
    end
  elseif type == "normal" then
    info.frameRes = ""
    info.framePos = res.framePosNormal
    info.titleBgSize = CCSizeMake(504, 12)
    info.starLeft = 580
    info.starGap = 45
    info.goButtonPos = res.goButtonPosNormal
  elseif type == "raid" then
    info.frameRes = ""
    info.framePos = res.framePosElite
    info.titleBgSize = CCSizeMake(404, 12)
    info.starLeft = 530
    info.starGap = 40
    info.goButtonPos = res.goButtonPosElite
  end
  local starGrey = self.stageInfo.star > 0 and "UI/alpha/1080P/campaign/main/campaign_stage_star_3.png" or "UI/alpha/1080P/campaign/main/campaign_stage_star_2.png"
  info.stars = {}
  for i = 1, 3 do
    if i <= (self.stageInfo.star or 0) then
      info.stars[i] = "UI/alpha/1080P/campaign/main/campaign_stage_star_1.png"
    else
      info.stars[i] = starGrey
    end
  end
  if self.mode == "challenge" then
    local res = self.challengeModeIcons
    for i = 1, 3 do
      info.stars[i] = res[i]
    end
  end
  ed.guildStageStar = {
    self.stage,
    self.stageInfo.star
  }
  self.resInfo = info
end

class.getResInformation = getResInformation

local function findBoss(self, stage)
  local info = self.enemyInfo
  local bossPos
  if not self:isSpring() then
    bossPos = ed.getDataTable("Battle")[stage][self.step]["Boss Position"] or 0
  else
    bossPos = ed.getDataTable("Battle")[stage]["Boss Position"] or 0
  end
  info.bossPos = bossPos
  if self.enemyInfo[bossPos] then
    self.enemyInfo[bossPos].isBoss = true
    local boss = self.enemyInfo[bossPos]
    table.remove(self.enemyInfo, bossPos)
    table.insert(self.enemyInfo, boss)
  end
  self.enemyInfo = info
end

class.findBoss = findBoss

local function getEnemyInformation(self, stage)
  local info = {}
  local battleTb = ed.getDataTable("Battle")
  local row = ed.getDataTable("Stage")[stage]
  local ids = {}
  if not self:isSpring() then
    for i = 1, 5 do
      local brow = battleTb[stage][self.step]
      local tn = string.format("Monster %d ID", i)
      local enemy = brow[tn]
      if enemy then
        ids[i] = enemy
      end
    end
  else
    ids[1] = battleTb[stage][1]["Monster 1 ID"]
  end
  for i = 1, #ids do
    if ids[i] ~= 0 then
      local id = ids[i]
      local shardId = battleTb[self.stage][self.step]["Shard ID " .. i]
      local shardLevel = battleTb[self.stage][self.step]["Shard Level " .. i]
      local shard
      if shardId and 0 < shardId then
        shard = {_id = shardId, _level = shardLevel}
      end
      info[i] = {
        id = id,
        res = ed.getUnitPortrait(ids[i]),
        level = ed.getDataTable("Stage")[self.stage]["Monster Level"],
        stars = battleTb[self.stage][self.step]["Stars " .. i],
        rank = battleTb[self.stage][self.step]["Rank " .. i],
        shard = shard,
        index = i
      }
    end
  end
  self.enemyInfo = info
  self:findBoss(stage)
end

class.getEnemyInformation = getEnemyInformation

local function getRecommendInformation(self, stage)
  self.recommendInfo = {}
  local ids = ed.getDataTable("ActStageGroup")[self.stageGroup]["Recommended Hero List"]
  for _, v in ipairs(ids) do
    if v ~= 0 then
      self.recommendInfo[#self.recommendInfo + 1] = v
    end
  end
end

class.getRecommendInformation = getRecommendInformation

local function getSpecialRewardInfo(self, stage)
  local serverTime = ed.getServerTime()
  local spLoot = ed.getDataTable("DailyVariableSpecialLoot")
  local spRewards = {}
  for k, sRow in pairs(spLoot) do
    if type(k) == "number" then
      local sTime = ed.getTimeByYMDHMS(sRow["Start Time"])
      local eTime = ed.getTimeByYMDHMS(sRow["End Time"])
      if serverTime >= sTime and serverTime <= eTime then
        local sType = sRow["Special Loot Type"]
        local s = ""
        local slId = sRow["Special Loot ID"]
        if sType == "StageBonus" then
          s = stage
        elseif sType == "StageGroupBonus" then
          s = ed.getDataTable("Stage")[stage]["Stage Group"]
        end
        for k, id in pairs(slId) do
          if tonumber(id) == tonumber(s) then
            for i = 1, 3 do
              for _, rewardId in ipairs(sRow["Reward ID " .. i]) do
                if 0 < rewardId then
                  table.insert(spRewards, rewardId)
                end
              end
            end
            break
          end
        end
      end
    end
  end
  return spRewards
end

class.getSpecialRewardInfo = getSpecialRewardInfo

function class:addTaskExtraDropEquip(herotask, ids, stage, isDropStage)
  local id = herotask._id
  local line = herotask._line
  local taskinfo = ed.getDataTable("HeroTask")[line][id]
  local isArtifat = taskinfo["Is Artifact"]
  if isArtifat then
    if taskinfo and ed.isElementInTable(stage, taskinfo["Item Stage ID"]) then
      for i = 1, maxReward do
        if ids[i] == 0 then
          ids[i] = taskinfo["Item ID"]
          break
        end
      end
    end
  elseif taskinfo and isDropStage then
    for i = 1, maxReward do
      if ids[i] == 0 then
        ids[i] = taskinfo["Item ID"]
        break
      end
    end
  end
end

local function getRewardInformation(self, stage)
  local info = {}
  local row = ed.getDataTable("Stage")[stage]
  local ids = {}
  local cnts = {}
  local itemIdList = ed.activityHints.data:getStageExtraDropItem()
  for _, itemId in ipairs(itemIdList or {}) do
    table.insert(ids, itemId)
    table.insert(cnts, 1)
  end
  if self:isSpring() and self:stagefd() and not ed.getDataTable("Stage")[stage]["Chest For FD"] then
    local rowb = ed.getDataTable("Battle")[stage][1]
    for i = 1, 5 do
      local tn = "FD Bonus " .. i
      local reward = rowb[tn]
      if reward then
        local recnt = math.floor(#reward / 2)
        for j = 1, recnt do
          table.insert(ids, reward[1 + (j - 1) * 2])
          table.insert(cnts, reward[2 + (j - 1) * 2])
        end
      end
    end
  else
    local index = 0
    for i = 1, maxReward do
      local tn = "UI reward" .. i
      local reward = row[tn]
      if reward and ed.readequip:isEquipOpen(reward) then
        index = index + 1
        if class.checkDropSituation(reward) then
          table.insert(ids, reward)
        end
      end
    end
  end
  local stageItemId, isLootId, isShow
  if ed.ui.stageselectres.getIsLootStages(self.stage) then
    for i, v in ipairs(ed.player:getStageSelectReward() or {}) do
      if v._stage_id == self.stage then
        stageItemId = v._reward_id
        break
      end
    end
    isLootId = stageItemId or 524
    table.insert(ids, isLootId)
    if stageItemId then
      isShow = true
    end
  end
  local unit = ed.getDataTable("Unit")
  local equip = ed.getDataTable("equip")
  for i = 1, #ids do
    local id = ids[i]
    if not ed.getDataTable("equip")[id] then
    end
    if id ~= 0 and ed.getDataTable("equip")[id] and not ed.getDataTable("equip")[id].Invisible then
      local temp = {}
      if isLootId == id then
        temp.id = isLootId
        temp.res = equip[isLootId].Icon
        temp.name = equip[isLootId].Name
        temp.lootId = true
        temp.isShow = isShow
      elseif ed.itemType(id) == "hero" then
        temp.id = id
        temp.res = ed.getUnitPortrait(id)
        temp.rank = unit[id]["Initial Rank"]
        temp.name = unit[id]["Display Name"]
        temp.hero = true
      elseif ed.itemType(id) == "equip" then
        temp.id = id
        temp.res = equip[id].Icon
        temp.name = equip[id].Name
        temp.hero = false
        if cnts[i] then
          temp.cnt = cnts[i]
        end
      end
      table.insert(info, temp)
    end
  end
  self.rewardInfo = info
end

class.getRewardInformation = getRewardInformation

local function getInformation(self, stage)
  self.stageInfo = self.getStageInformation(stage)
  self:getResInformation(stage)
  if self:isSpring() then
    self:getRecommendInformation(stage)
  else
    self:getEnemyInformation(stage)
  end
  self:getRewardInformation(stage)
end

class.getInformation = getInformation

local function getLeftTimes(self)
  local s = ed.elite2NormalStage(self.stage)
  local count = self.stageInfo.countLimit - ((ed.player.stage_limit or {})[s] or 0)
  return count
end

class.getLeftTimes = getLeftTimes

local function refreshEliteTime(self)
  if not resource_config.stagedetail_elitetimes_auto_reposition then
    return
  end
  local count = self:getLeftTimes()
  local title = self.ui.count_title
  local label = self.ui.count_number
  local total = self.ui.total_number
  local power = self.ui.power_icon
  if count < 1 then
    label:setAnchorPoint(ccp(1, 0))
    total:setAnchorPoint(ccp(1, 0))
    title:setPosition(ccp(294, 245))
    total:setPosition(ccp(280 + title:getContentSize().width, 215))
    ed.left2(label, total, 5)
  else
    label:setAnchorPoint(ccp(0, 0))
    total:setAnchorPoint(ccp(0, 0))
    ed.right2(title, power, 15)
    ed.right2(label, title, 5)
    ed.right2(total, label, 5)
  end
end

class.refreshEliteTime = refreshEliteTime

local function checkEnabled(self)
  local s = ed.elite2NormalStage(self.stage)
  local count = self:getLeftTimes()
  local label = self.ui.count_number
  ed.setString(label, count)
  if count < 1 then
    ed.setLabelColor(label, ed.toccc3(16777215))
  else
    ed.setLabelColor(label, ed.toccc3(16753969))
  end
  self:refreshEliteTime()
  local vitality = ed.player:getVitality() or 0
  if vitality >= self.stageInfo.power then
    self.isVitalityEnabled = true
  else
    self.isVitalityEnabled = false
  end
  local limit = self.stageInfo.countLimit
  if limit > ed.player:getStageLimit(s) or (limit or 0) <= 0 then
    self.isCountEnabled = true
  else
    self.isCountEnabled = false
  end
  if self.isVitalityEnabled and self.isCountEnabled then
    ed.setLabelColor(self.ui.power_number, ed.toccc3(16753969))
  end
  if self.mode == "guild" and not ed.ui.guild.isCurrentStageId(self.stage) then
    self.ui.go_button:setVisible(false)
  end
end

class.checkEnabled = checkEnabled

local function refreshVitalityEnabled(self)
  local preVit = ed.player:getVitality()
  
  local function handler()
    if ed.player:getVitality() ~= preVit then
      self:checkEnabled()
    end
  end
  
  return handler
end

class.refreshVitalityEnabled = refreshVitalityEnabled

local function downBuyVitality(self)
  local function handler()
    if not self then
      return
    end
    self:checkEnabled()
  end
  
  return handler
end

class.downBuyVitality = downBuyVitality

function class:getSwitchStage(step)
  local id = self.stage
  local keyId = id
  local st = ed.stageType(keyId)
  local stageTbl = ed.getDataTable("Stage")
  local Chapter = stageTbl[self.stage]["Chapter ID"]
  
  local function passStage(stageId)
    return ed.player:getStageStar(stageId) > 0
  end
  
  local prePassed = passStage(id)
  while true do
    if 0 < step then
      if not prePassed then
        keyId = id
        break
      end
      prePassed = passStage(id + step)
    end
    id = id + step
    local stData = stageTbl[id]
    if nil == stData then
      break
    end
    local newSt = ed.stageType(keyId)
    if st ~= newSt then
      break
    end
    if stData["Chapter ID"] ~= Chapter then
      break
    end
    if stData["Key Stage"] then
      keyId = id
      break
    end
  end
  return keyId
end

function class:switchStage(step)
  if 0 == step then
    return
  end
  local newStageId = self:getSwitchStage(step)
  if newStageId == self.stage then
    return
  end
  self.stage = newStageId
  local nextId = self:getSwitchStage(step)
  local hasNext = nextId ~= newStageId
  if 0 < step then
    self.rightArrow:setVisible(hasNext)
    self.leftArrow:setVisible(true)
  else
    self.leftArrow:setVisible(hasNext)
    self.rightArrow:setVisible(true)
  end
  self.getWayItemId = 0
  self.getWayItemNeed = 0
  self:refreshStageInfo()
end

function class:refreshStageInfo()
  self.stageGroup = ed.getDataTable("Stage")[self.stage]["Stage Group"]
  self:getInformation(self.stage)
  self:initBuffSprite()
  self:refreshStageLimit()
  self:createRepeatBattle()
  self:createStars()
  if not self:isSpring() then
    self:createEnemy()
  end
  self:createReward()
  local info = self.stageInfo
  self.ui.title:setString(info.title)
  self.ui.titledetailLay:removeAllChildrenWithCleanup(true)
  local lineSpace = EDCurLanguage == "ko" and 0 or 3
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = info.detail,
    fontSize = 15,
    lineSpacing = lineSpace,
    maxWidth = self.autoTextWid - 48,
    color = ed.toccc3(16777215)
  })
  local _, atHei = autoText:getCurContentSize()
  local dlList = ed.UITool.createDraglist(self.ui.titledetailLay, {})
  dlList:addItem(autoText.node)
  local layer_size = self.ui.titledetailLay:getContentSize()
  if atHei > layer_size.height then
    autoText.node:setPosition(0, layer_size.height - autoText:getFirstLineHeight() * 0.6)
    dlList:initListHeight(atHei + 5)
  else
    autoText.node:setPosition(0, (atHei + layer_size.height - autoText:getFirstLineHeight()) * 0.5)
  end
  self.ui.power_number:setString(info.power)
end

local function doBuyVitality(self)
  ed.ui.buyVitalityBox.create()
end

class.doBuyVitality = doBuyVitality

local function doChangeChallengeMode(self, mode)
  local currentMode = self.stage
  local modesTable = {}
  local transition = CCTransitionSlideInR
  for k, v in pairs(self.challengeModes or {}) do
    modesTable[v] = k
  end
  if (mode == "+" or mode == 1000) and modesTable[currentMode + 1000] then
    self.stage = currentMode + 1000
  end
  if (mode == "-" or mode == -1000) and modesTable[currentMode - 1000] then
    self.stage = currentMode - 1000
    transition = CCTransitionSlideInL
  end
  ed.replaceScene(self.create(self.stage, self.addition, self.mode))
end

class.doChangeChallengeMode = doChangeChallengeMode

local function doClickGo(self)
  local ul = ed.getDataTable("Stage")[self.stage]["Unlock Level"]
  if ul > ed.player:getLevel() then
    ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\229\136\176\232\190\190%d\231\186\167\229\143\175\232\191\155\229\133\165\230\173\164\229\133\179\229\141\161", ul))
    return
  end
  if self.mode == "elite" then
    local chapterID = ed.getDataTable("Stage")[self.stage]["Chapter ID"]
    local sId = ed.ui.stageselectres.getChapterStageEid(chapterID, self.stage)
    if sId and (ed.player:getStageStar(sId) or 0) == 0 then
      ed.showToast(T("\233\128\154\229\133\179\230\153\174\233\128\154\230\168\161\229\188\143\229\144\142\229\188\128\229\144\175"))
      return
    end
  end
  if self.mode == "guild" then
    local info = ed.ui.guild.getInstanceInfo(self.stageInfo.chapter)
    local h, m = ed.time2HMS()
    if not ed.isAreaOverSea() and tonumber(h) >= 5 and tonumber(h) <= 7 then
      ed.showToast(T("\229\189\147\229\137\141\230\128\170\231\137\169\230\173\163\229\156\168\228\188\145\230\129\175\239\188\140\232\175\183\231\168\141\229\128\153\229\134\141\232\175\149"))
      return
    end
    if info and 0 >= info.leftTime then
      ed.showToast(T("\228\187\138\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140"))
      return
    end
    if self.guildUI and self.guildUI.challenger:isVisible() and self.guildInstanceData.challenger._summary._name ~= ed.player:getName() then
      ed.showToast(T("\228\189\160\231\154\132\228\188\153\228\188\180\230\173\163\229\156\168\230\140\145\230\136\152\229\133\179\229\141\161\239\188\140\232\175\183\231\168\141\229\128\153"))
      return
    end
  end
  if self.alreadyEnd == true then
    ed.showToast(T("\229\189\147\229\137\141\229\133\179\229\141\161\229\183\178\231\187\147\230\157\159"))
    return
  end
  local stage = self.stage
  local GWMode = self.identity == "stageDetailGWMode"
  local heroLimit = self.heroLimit
  local actType = self.actType
  if self.mode == "guild" then
    local msg = ed.upmsg.guild()
    msg._instance_prepare = {}
    msg._instance_prepare._stage_id = self.stage
    ed.send(msg, "guild")
    return
  else
    if ed.getDataTable("ActStageGroup")[self.stageGroup] then
      local act_recommend_heros = {}
      local act_recommend_mode = false
      local ids = ed.getDataTable("ActStageGroup")[self.stageGroup]["Recommended Hero List"]
      if ids and 0 < #ids then
        act_recommend_mode = true
        act_recommend_heros = ids
      end
      ed.pushScene(ed.ui.battleprepare.create({
        mode = "stageDetail",
        stage_id = stage,
        GWMode = GWMode,
        heroLimit = heroLimit,
        actType = actType,
        act_recommend_heros = act_recommend_heros,
        act_recommend_mode = act_recommend_mode,
        isTitan = self.addition.isTitan,
        objData = self.battleData
      }))
    else
      ed.pushScene(ed.ui.battleprepare.create({
        mode = "stageDetail",
        stage_id = stage,
        GWMode = GWMode,
        heroLimit = heroLimit,
        actType = actType,
        isTitan = self.addition.isTitan,
        objData = self.battleData
      }))
    end
    if self.enterHandler then
      self.enterHandler()
    end
    self:destroy({skipAnim = true})
  end
  self.isPushing = true
end

class.doClickGo = doClickGo

local function doGoTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.go_button
  
  local function handler(event, x, y)
    if tolua.isnull(button) then
      return
    end
    if event == "began" and button:isVisible() then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(1.05)
      end
    elseif event == "ended" then
      if isPress then
        if ed.containsPoint(button, x, y) then
          if self.addition.lootStage and self.addition.lootStage.bossId then
            local stageItemId
            for _, v in ipairs(ed.player:getStageSelectReward() or {}) do
              if v._stage_id == self.addition.lootStage.eid then
                stageItemId = v._reward_id
                break
              end
            end
            if not stageItemId then
              ed.showToast(T("\229\176\154\230\156\170\233\128\137\230\139\169\229\143\175\230\142\137\232\144\189\231\154\132\231\129\181\233\173\130\231\159\179"))
              ed.ui.stageChooseLootPop.create(self.addition.lootStage):popWindow()
              return
            end
          end
          if self.identity == "exerciseStageDetail" and self.rtimes - self.leftTimes >= 0 then
            ed.showToast(T("\232\175\165\229\133\179\229\141\161\232\191\155\229\133\165\230\172\161\230\149\176\229\183\178\232\190\190\230\156\172\230\151\165\228\184\138\233\153\144"))
            return
          end
          local vitality = ed.player:getVitality() or 0
          if vitality >= self.stageInfo.power then
            self.isVitalityEnabled = true
          else
            self.isVitalityEnabled = false
          end
          if not self.isVitalityEnabled then
            lsr:report("clickDisabledgo")
            self:doBuyVitality()
          elseif not self.isCountEnabled then
            lsr:report("clickDisabledgo")
            ed.showToast(T("\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\232\190\190\229\136\176\228\184\138\233\153\144"))
          else
            lsr:report("clickgo")
            if self.isPushing then
              return
            end
            self:doClickGo()
          end
        end
        button:setScale(1)
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doGoTouch = doGoTouch

local function doRankTouch(self)
  if not self.guildUI then
    return
  end
  local isPress
  local ui = self.guildUI
  local button = ui.rank
  local press = ui.rank_press
  
  local function handler(event, x, y)
    if tolua.isnull(button) then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          local msg = ed.upmsg.guild()
          msg._guild_stage_rank = {}
          msg._guild_stage_rank._stage_id = self.stage
          ed.send(msg, "guild")
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doRankTouch = doRankTouch

local function doBuffTouch(self)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local showTextX = widhtWin / 2 - 222
  local showTexty = heightWin / 2 + 145
  
  local function handler(event, x, y)
    if event == "began" then
      local buff = self.ui.buff
      local rank_limit = self.ui.rank_limit
      local dropbuff = self.ui.drop_buff
      if buff:isVisible() and ed.containsPoint(buff, x, y) then
        local stage = ed.lookupDataTable("Stage", nil, self.stage)
        if stage and stage["Mps Restraint"] > 0 then
          local str = T("<text|chat_channel_active|\229\143\151\229\136\176\231\165\158\231\167\152\232\175\133\229\146\146\231\154\132\229\189\177\229\147\141,><><text|chat_channel_active|\232\131\189\233\135\143\229\155\158\229\164\141\229\135\143\229\176\145%d%%>", 100 - stage["Mps Restraint"])
          ed.showHintText(str, ccp(showTextX, showTexty))
        end
      end
      if dropbuff:isVisible() and ed.containsPoint(dropbuff, x, y) then
        local stage = ed.lookupDataTable("Stage", nil, self.stage)
        
        local function ShowHintText(chapter_id, difficulty)
          local strText = self:getStageHintText(chapter_id, difficulty, stage)
          ed.showHintText(strText, ccp(showTextX, showTexty))
        end
        
        ShowHintText(stage["Chapter ID"], stage.Difficulty)
      end
      if rank_limit:isVisible() and ed.containsPoint(rank_limit, x, y) then
        local stage = ed.lookupDataTable("Stage", nil, self.stage)
        if stage then
          for i = 1, 5 do
            if stage["Requirement Type " .. i] == "HeroRankAtLeast" and 0 < tonumber(stage["Requirement Detail " .. i] or 0) then
              local rank = tonumber(stage["Requirement Detail " .. i])
              local rank_info = ed.ui.herodetail.res.equip_rank_info[rank]
              local str = T("<text|chat_channel_active|\229\143\151\229\136\176\231\165\158\231\167\152\229\138\155\229\156\186\228\191\157\230\138\164\239\188\140\229\143\170\230\156\137><><text|%s|%s><text|chat_channel_active|\229\147\129\233\152\182\229\143\138\228\187\165\228\184\138\231\154\132\232\139\177\233\155\132><><text|chat_channel_active|\229\143\175\228\187\165\232\191\155\229\133\165\232\191\153\228\184\170\229\133\179\229\141\161>", rank_info.font, rank_info.name)
              ed.showHintText(str, ccp(370, 390))
              break
            end
          end
        end
      end
    elseif event == "ended" then
      ed.closeHintText()
    end
  end
  
  return handler
end

class.doBuffTouch = doBuffTouch

function class:getStageHintText(chapter_id, difficulty, stage)
  return T("<text|gcw_red|" .. "\239\188\136\230\156\170\230\191\128\230\180\187\239\188\137>")
end

local function doRecommendTouch(self)
  local function handler(event, x, y)
    if not self.recommendInfo then
      return
    end
    if event == "began" then
      for i = 1, #self.recommendInfo do
        local hid = self.recommendInfo[i]
        if ed.containsPoint(self.ui["recommend" .. i], x, y) then
          lsr:report("pressEnemy")
          if not self.recommendDetailPanel then
            local panel = ed.readequip.getDetailCard(hid, {
              level = 1,
              isBoss = false,
              isUnit = true
            })
            local enemy = self.ui["recommend" .. i]
            local x, y = enemy:getPosition()
            local size = enemy:getContentSize()
            local sy = enemy:getScaleY()
            panel:setPosition(ccp(x, y + size.height + 20))
            self.mainLayer:addChild(panel, 100)
            self.recommendDetailPanel = panel
          end
        end
      end
    elseif event == "ended" and self.recommendDetailPanel then
      self.recommendDetailPanel:removeFromParentAndCleanup(true)
      self.recommendDetailPanel = nil
    end
  end
  
  return handler
end

class.doRecommendTouch = doRecommendTouch

local function doEnemyTouch(self)
  local function handler(event, x, y)
    if not self.enemyInfo then
      return
    end
    if event == "began" then
      for i = 1, #self.enemyInfo do
        local info = self.enemyInfo[i]
        if ed.containsPoint(self.ui["enemy" .. i], x, y) then
          if not tolua.isnull(self.enemyDetailPanel) then
            self.enemyDetailPanel:removeFromParentAndCleanup(true)
          end
          lsr:report("pressEnemy")
          local panel = ed.readequip.getDetailCard(info.id, {
            level = info.level,
            rank = info.rank,
            isBoss = info.isBoss,
            isUnit = true,
            campLevel = info.campLevel
          }, false, info.shard)
          local enemy = self.ui["enemy" .. i]
          local x, y = enemy:getPosition()
          local size = enemy:getContentSize()
          local sy = enemy:getScaleY()
          panel:setPosition(ccp(x, y + size.height - 60))
          self.ui.enemyContainer:addChild(panel, 999)
          self.enemyDetailPanel = panel
        end
      end
    elseif event == "ended" and not tolua.isnull(self.enemyDetailPanel) then
      self.enemyDetailPanel:removeFromParentAndCleanup(true)
    end
  end
  
  return handler
end

class.doEnemyTouch = doEnemyTouch

local function doRewardTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #self.rewardInfo do
        local info = self.rewardInfo[i]
        
        if self.ui["reward" .. i] and self.ui["reward" .. i]:isVisible() and ed.containsPoint(self.ui["reward" .. i], x, y) then
          lsr:report("pressReward")
          if not self.recommendDetailPanel then
            local panel = ed.readequip.getDetailCard(info.id, {ps = ""}, {
              noArrow = true,
              anchor = ccp(0.5, 0.5)
            })
            if panel then
              panel:setAnchorPoint(ccp(0.5, 0))
              local x, y = self.ui["reward" .. i]:getPosition()
              local size = self.ui["reward" .. i]:getContentSize()
              panel:setPosition(ccp(x + size.width / 2, y + size.height - 100))
              self.rewardDetailPanel = panel
              self.awardContainer:addChild(panel, 999)
            end
          end
          break
        end
      end
    elseif event == "ended" and self.rewardDetailPanel then
      self.rewardDetailPanel:removeFromParentAndCleanup(true)
      self.rewardDetailPanel = nil
    end
  end
  
  return handler
end

class.doRewardTouch = doRewardTouch

local function doChangeChallengeModeTouch(self)
  local pressLeft, pressRight, left, right
  if self.mode == "challenge" then
    left = self.challengeUI.leftArrow
    right = self.challengeUI.rightArrow
  end
  
  local function handler(event, x, y)
    xpcall(function()
      if self.mode ~= "challenge" then
        return
      end
      if event == "began" then
        if left:isVisible() and ed.containsPoint(left, x, y) then
          pressLeft = true
          left:setScale(1.45)
        end
        if right:isVisible() and ed.containsPoint(right, x, y) then
          pressRight = true
          right:setScale(1.45)
        end
      elseif event == "ended" then
        if pressLeft then
          left:setScale(1.5)
          pressLeft = nil
          if ed.containsPoint(left, x, y) then
            lsr:report("clickChangeChapter")
            self:doChangeChallengeMode(-1000)
          end
        end
        if pressRight then
          right:setScale(1.5)
          pressRight = nil
          if ed.containsPoint(right, x, y) then
            lsr:report("clickChangeChapter")
            self:doChangeChallengeMode(1000)
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

class.doChangeChallengeModeTouch = doChangeChallengeModeTouch

function class:doSwitchStageTouch()
  local pressLeft, pressRight
  local left = self.leftArrow
  local right = self.rightArrow
  if nil == left or nil == right then
    return nil
  end
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if left:isVisible() and ed.containsPoint(left, x, y) then
          pressLeft = true
          self.pessArrow = true
          left:setScale(1.4)
        end
        if right:isVisible() and ed.containsPoint(right, x, y) then
          pressRight = true
          self.pessArrow = true
          right:setScale(1.4)
        end
      elseif event == "ended" then
        if pressLeft then
          self.pessArrow = false
          left:setScale(1.5)
          if ed.containsPoint(left, x, y) and not self.dragMode then
            self:switchStage(-1)
          end
        end
        pressLeft = nil
        if pressRight then
          self.pessArrow = false
          right:setScale(1.5)
          if ed.containsPoint(right, x, y) and not self.dragMode then
            self:switchStage(1)
          end
        end
        pressRight = nil
      end
    end, EDDebug)
  end
  
  return handler
end

function class:doOpenLootStageBtnTouch()
  local pressLeft, pressRight
  local left = self.leftArrow
  local right = self.rightArrow
  if nil == left or nil == right then
    return nil
  end
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if self.openLootStageBtn and ed.containsPoint(self.openLootStageBtn, x, y) then
          self.openLootStageBtn:setScale(0.95)
        end
      elseif event == "ended" and self.openLootStageBtn then
        self.openLootStageBtn:setScale(1)
        if ed.containsPoint(self.openLootStageBtn, x, y) and not self.dragMode then
          ed.ui.stageChooseLootPop.create(self.addition.lootStage):popWindow()
        end
      end
    end, EDDebug)
  end
  
  return handler
end

local function doClickReset(self)
  self:doPayReset()
end

class.doClickReset = doClickReset

local function getMainTouchHandler(self)
  local goTouch = self:doGoTouch()
  local rewardTouch = self:doRewardTouch()
  local enemyTouch = self:doEnemyTouch()
  local buffTouch = self:doBuffTouch()
  local rankTouch = self:doRankTouch()
  local recommendTouch = self:doRecommendTouch()
  local changeChallengeModeTouch = self:doChangeChallengeModeTouch()
  local switchStageTouch = self:doSwitchStageTouch()
  local doOpenLootStageBtnTouch = self:doOpenLootStageBtnTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.mainTouchHandlerList or {}) do
        v(event, x, y)
      end
      goTouch(event, x, y)
      rewardTouch(event, x, y)
      enemyTouch(event, x, y)
      buffTouch(event, x, y)
      changeChallengeModeTouch(event, x, y)
      if rankTouch then
        rankTouch(event, x, y)
      end
      if recommendTouch then
        recommendTouch(event, x, y)
      end
      if switchStageTouch then
        switchStageTouch(event, x, y)
      end
      if doOpenLootStageBtnTouch then
        doOpenLootStageBtnTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.getMainTouchHandler = getMainTouchHandler

local function refreshStageLimit(self)
  if not self then
    return
  end
  if not self.ui then
    return
  end
  if tolua.isnull(self.ui.count_number) then
    return
  end
  self:checkEnabled()
end

class.refreshStageLimit = refreshStageLimit

local function createRecommend(self)
  local width = 0
  local ox, oy = 0, 0
  self.ui.enemyContainer:removeAllChildrenWithCleanup(true)
  local param = {
    cliprect = CCRectMake(170, 43, 450, 380),
    noshade = true,
    container = self.mainLayer,
    zorder = 99,
    priority = -235
  }
  local draglist = ed.draglist.create(param)
  self.draglistrecommend = draglist
  self.draglistrecommend:initListWidth(50)
  self.draglistrecommend:setTouchEnabled(true)
  local size = #self.recommendInfo > 6 and 6 or #self.recommendInfo
  for i = 1, size do
    self.ui["recommend" .. i] = nil
  end
  local i = 0
  for idx = 1, size do
    local hid = self.recommendInfo[idx]
    i = i + 1
    local unit = ed.readhero.createIcon({
      id = hid,
      rank = 1,
      awake = false
    })
    local bg = unit.icon
    bg:setFlipX(true)
    local pos
    local length = 60
    pos = ccp(ox + 70 * (i - 1), oy)
    bg:setAnchorPoint(ccp(0.5, 0.5))
    bg:setPosition(pos)
    self.draglistrecommend.listLayer:addChild(bg)
    local eScale = length / bg:getContentSize().width
    bg:setScale(eScale)
    self.ui["recommend" .. i] = bg
  end
end

class.createRecommend = createRecommend

local function createEnemy(self)
  local width = 0
  local ox, oy = 152, 7
  self.ui.enemyContainer:removeAllChildrenWithCleanup(true)
  for i = 1, 5 do
    self.ui["enemy" .. i] = nil
  end
  self.battleData.headData = {}
  for i = 1, #self.enemyInfo do
    local info = self.enemyInfo[i]
    if info then
      local enemyLevel = info.level
      local rank = ed.heroLevel2Rank(enemyLevel)
      if info.rank and 0 < info.rank then
        rank = info.rank
      end
      local stars = info.stars
      local heroTs = {
        id = info.id,
        rank = rank,
        stars = stars,
        shard = info.shard
      }
      local unit = ed.readhero.createIcon(heroTs)
      local bg = unit.icon
      bg:setFlipX(true)
      local pos
      local length = 65
      if info.isBoss == true then
        pos = ccp(ox + 77 * (i - 1) + 5, oy)
        length = 75
      else
        pos = ccp(ox + 77 * (i - 1), oy)
      end
      bg:setPosition(pos)
      self.ui.enemyContainer:addChild(bg)
      local eScale = length / bg:getContentSize().width
      bg:setScale(eScale - 0.1)
      if info.isBoss == true then
        local tag = ed.createSprite("UI/alpha/1080P/campaign/campaign_detail_boss.png")
        tag:setPosition(ccp(60, 65))
        bg:addChild(tag, 10)
      end
      self.ui["enemy" .. i] = bg
      table.insert(self.battleData.headData, heroTs)
      if self.guildInstanceData and self.guildInstanceData.hp[info.index] then
        unit:addMonsterHpInfo({
          hp = self.guildInstanceData.hp[info.index]
        })
      end
    end
  end
end

class.createEnemy = createEnemy

local function createReward(self, Width)
  if self.mode == "challenge" and ed.player:getStageStar(self.stage) > 0 then
    return
  end
  local ox, oy = 0, 0
  oy = self:isSpring() and 80 or 0
  ox = self:isSpring() and self:stagefd() and 40 or 0
  if nil == self.draglistreward then
    local param = {
      cliprect = CCRectMake(0, 0, Width and Width - 147 or 400, 100),
      noshade = true,
      container = self.awardContainer,
      zorder = 999,
      priority = -360
    }
    local draglist = ed.draglist.create(param)
    self.draglistreward = draglist
    self.draglistreward:setTouchEnabled(true)
  end
  self.battleData.items = {}
  self.draglistreward:clearList()
  for i = 1, #self.rewardInfo do
    local reward = self.rewardInfo[i]
    if reward then
      local items = {
        id = reward.id,
        cnt = nil,
        isSpring = false
      }
      local icon
      if reward.hero then
        items.cnt = 4
      elseif self:isSpring() and self:stagefd() then
        items.cnt = reward.cnt
        items.isSpring = true
      end
      if items.isSpring then
        icon = ed.readequip.createIconWithAmount(reward.id, nil, reward.cnt)
      else
        icon = ed.readequip.createIcon(items.id, nil, items.cnt)
      end
      icon:setScale(0.8)
      table.insert(self.battleData.items, items)
      if reward.lootId then
        icon:setVisible(reward.isShow)
        self.autoItemIcon = icon
        self.ui["reward" .. i] = self.autoItemIcon
      else
        self.ui["reward" .. i] = icon
      end
      icon:setAnchorPoint(ccp(0, 0))
      if self:isSpring() then
        icon:setScale(0.8571428571428571)
        icon:setPosition(ccp(ox + 70 * (i - 1), oy - delta))
      else
        icon:setPosition(ccp(ox + 77 * (i - 1), oy))
      end
      self.draglistreward.listLayer:addChild(icon)
    end
  end
  self.draglistreward:initListWidth(self:isSpring() and 70 * #self.rewardInfo or 80 * #self.rewardInfo)
end

class.createReward = createReward

local function createStars(self)
  if self.addition.lootStage and self.addition.lootStage.bossId then
    self.ui.star_bg:setVisible(false)
    self.ui.star_line1:setVisible(false)
    self.ui.star_line2:setVisible(false)
    self.ui.star_bg2:setVisible(false)
    return
  end
  if self.mode == "guild" then
    return
  end
  if self.identity == "exerciseStageDetail" and ed.player:getLevel() < 75 then
    return
  end
  if self.identity == "exerciseStageDetail" and not self:filterCreateRepeatStage() then
    return
  end
  local resInfo = self.resInfo
  if self.ui.star1 then
    for k = 1, 3 do
      ed.setTexture(self.ui["star" .. k], resInfo.stars[k])
    end
  else
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "star1",
          res = resInfo.stars[1],
          parent = "star_bg"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(184 + resInfo.starGap * 0, 5)
        },
        config = {
          scale = self.mode == "challenge" and 0.6 or 1
        }
      },
      {
        t = "Sprite",
        base = {
          name = "star2",
          res = resInfo.stars[2],
          parent = "star_bg"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(184 + resInfo.starGap * 1, 5)
        },
        config = {
          scale = self.mode == "challenge" and 0.6 or 1
        }
      },
      {
        t = "Sprite",
        base = {
          name = "star3",
          res = resInfo.stars[3],
          parent = "star_bg"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(184 + resInfo.starGap * 2, 5)
        },
        config = {
          scale = self.mode == "challenge" and 0.6 or 1
        }
      }
    }
    local readNode = ed.readnode.create(self.mainLayer, self.ui)
    readNode:addNode(ui_info)
  end
  if self.ui.star_bg then
    local bgRes = 0 < self.stageInfo.star and "campaign_detail_star_lock_bg.png" or "campaign_detail_star_unlock_bg.png"
    ed.initSpriteWithFrame(self.ui.star_bg, "UI/alpha/1080P/campaign/" .. bgRes)
  end
  local stageTbl = self.StageConfig or ed.getDataTable("Stage")
  local keyStage = stageTbl[self.stageInfo.stage]["Key Stage"]
  self.ui.star_bg:setVisible(keyStage)
  self.ui.star_line1:setVisible(keyStage)
  self.ui.star_line2:setVisible(keyStage)
  self.ui.star_bg2:setVisible(not keyStage)
  if self.mode == "challenge" then
    for k = 1, 3 do
      if k > self.challengePro then
        ed.setSpriteGray(self.ui[string.format("star%d", k)])
      end
    end
  end
end

class.createStars = createStars

local function createChallengePro(self)
  if self.mode ~= "challenge" then
    return
  end
end

class.createChallengePro = createChallengePro

local function addChallengerIcon(self)
  if self.guildInstanceData == nil then
    self.guildUI.challenger:setVisible(false)
    return
  end
  if self.guildInstanceData.challenger == nil then
    self.guildUI.challenger:setVisible(false)
    return
  end
  local potNum = 0
  CloseTimer("potRefresh")
  ListenTimer(Timer:Always(0.5, "potRefresh"), function()
    potNum = potNum + 1
    if 3 < potNum then
      potNum = 0
    end
    local str = ""
    if self.guildInstanceData.state == "battle" then
      str = T("\230\136\152\230\150\151\228\184\173")
    else
      str = T("\229\135\134\229\164\135\228\184\173")
    end
    for i = 1, potNum do
      str = str .. (resource_config.chinese_character_forbid and "." or "\194\183")
    end
    ed.setString(self.guildUI.hint, str)
  end, self.visibleEventScope)
  self.guildUI.challenger:setVisible(true)
  local icon = ed.getHeroIconByID({
    id = self.guildInstanceData.challenger._summary._avatar,
    vip = 0 < self.guildInstanceData.challenger._summary._vip
  })
  local level = ed.getLevelIcon({
    level = self.guildInstanceData.challenger._summary._level,
    babelLevel = self.guildInstanceData.challenger._summary._babel_level
  })
  self.guildUI.icon:removeAllChildrenWithCleanup(true)
  self.guildUI.icon:addChild(icon)
  level:setPosition(ccp(-15, -20))
  self.guildUI.icon:addChild(level)
  ed.setLabelString(self.guildUI.name, self.guildInstanceData.challenger._summary._name)
end

local function refreshGuildInstanceUI(self, data)
  if self.mode ~= "guild" then
    return
  end
  if data.stage ~= self.stage then
    return
  end
  self.guildInstanceData = data
  self.step = self.guildInstanceData.step
  addChallengerIcon(self)
  self.guildUI.guild_process:setString(T("\230\173\163\229\156\168\230\140\145\230\136\152\231\172\172%d\230\179\162\230\149\140\228\186\186\239\188\136\229\133\1773\230\179\162\239\188\137", self.step))
  self:getEnemyInformation(self.stage)
  self:createEnemy()
end

local function addGuildInstanceUI(self)
  if self.mode ~= "guild" then
    return
  end
  self.guildUI = {}
  local ui_info = class.mode_ui_info.guild
  local readNode = ed.readnode.create(self.mainLayer, self.guildUI)
  readNode:addNode(ui_info)
  self.guildUI.guild_process:setString(string.format(T("\230\173\163\229\156\168\230\140\145\230\136\152\231\172\172%d\230\179\162\230\149\140\228\186\186\239\188\136\229\133\1773\230\179\162\239\188\137"), self.step))
  ed.setString(self.ui.award_title, T("\229\143\175\232\142\183\229\190\151:"))
  addChallengerIcon(self)
end

class.addGuildInstanceUI = addGuildInstanceUI

local function createModeIcon(self)
  local res = self.challengeModeIcons
  local index = math.floor(self.stage / 1000) - 10
  local icon = CCSprite:create(res[index])
  icon:setAnchorPoint(ccp(0.5, 0.5))
  icon:setPosition(ccp(70, 60))
  self.challengeUI.challenger:addChild(icon)
  local title = self.challengeModeTitle[index]
  self.challengeUI.hint:setString(title)
end

class.createModeIcon = createModeIcon

local function addChallengeInstanceUI(self)
  if self.mode ~= "challenge" then
    return
  end
  self.challengeUI = {}
  local ui_info = class.mode_ui_info.challenge
  local readNode = ed.readnode.create(self.mainLayer, self.challengeUI)
  readNode:addNode(ui_info)
  ed.setString(self.ui.award_title, T("\230\140\145\230\136\152\229\165\150\229\138\177:"))
  if ed.player:getStageStar(self.stage) > 0 then
    self.ui.award_title:setVisible(false)
  end
  self:createModeIcon()
end

class.addChallengeInstanceUI = addChallengeInstanceUI

local function addGuildEvent(self)
  if self.mode == "guild" then
    local function OnGuildRsp(data)
      if data == nil then
        return
      end
      if data._instance_prepare then
        if data._instance_prepare._result == "success" then
          local stage = self.stage
          local GWMode = self.identity == "stageDetailGWMode"
          local heroLimit = self.heroLimit
          local actType = self.actType
          ed.pushScene(ed.ui.battleprepare.create({
            stage_id = stage,
            GWMode = GWMode,
            heroLimit = heroLimit,
            actType = actType,
            mode = "guildInstance",
            prepareTime = data._instance_prepare._left_time
          }))
        else
          ed.showToast(T("\229\189\147\229\137\141\228\184\141\232\131\189\232\191\155\229\133\165\232\175\165\229\133\179\229\141\161"))
        end
      end
    end
    
    self:registerOnEnterHandler("onEnter", function()
      CloseScope(self.scope)
      self.scope = {}
      ListenEvent("GuildInstanceQuery2", function()
        local guildInstanceData = {}
        local hpInfo = {}
        for i = 1, 5 do
          hpInfo[i] = 0
        end
        guildInstanceData.step = 3
        guildInstanceData.hp = hpInfo
        guildInstanceData.challenger = nil
        guildInstanceData.stage = self.stage
        self.alreadyEnd = true
        refreshGuildInstanceUI(self, guildInstanceData)
        if canSweepHeroTask(self) or self:canSweepHeroSuperTask() then
          setSweepMode(false)
          resetSweepUI(self)
        end
      end, self.scope)
      ListenEvent("GuildInstanceDetail", function(data)
        refreshGuildInstanceUI(self, data)
      end, self.scope)
      
      local function queryDetail()
        local msg = ed.upmsg.guild()
        msg._instance_detail = {}
        msg._instance_detail._stage_id = self.stage
        ed.send(msg, "guild")
      end
      
      queryDetail()
      ListenTimer(Timer:Always(10), queryDetail, self.scope)
      ListenEvent("GuildRsp", OnGuildRsp)
    end)
    self:registerOnExitHandler("onExit", function()
      CloseScope(self.scope)
      StopListenEvent("GuildRsp", OnGuildRsp)
      FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
    end)
    self:registerOnPopSceneHandler("onPop", function()
      CloseScope(self.scope)
    end)
  end
end

local function addEventListener(self)
  self:listenEvent("sweepStageReply", function()
    self:resetSweepLabel()
  end)
  self:listenEvent("sweepStageReply", function()
    self:resetSweepLabel()
  end)
  self:listenEvent("ResourceNumChange", function(type)
    if type == "vitality" then
      self:resetSweepLabel()
    end
  end)
  self:listenEvent("stageRewardReply", function(data)
    if self.addition.lootStage and self.addition.lootStage.bossId then
      self:addLootStageLayer(self.addition.lootStage)
    end
  end)
  self:listenEvent("lootStagesNewShow", function(data)
    if self.lootStageRedImg and data.eid == self.addition.lootStage.eid then
      self.lootStageRedImg:setVisible(false)
    end
  end)
end

class.addEventListener = addEventListener

local function initBuffSprite(self)
  if not self.ui then
    return
  end
  local ui = self.ui
  local buff_num = 0
  local standard_pos = ccp(193, 355)
  local stage = ed.lookupDataTable("Stage", nil, self.stage)
  if stage and 0 < stage["Mps Restraint"] then
    ui.buff:setPosition(standard_pos)
    ui.buff:setVisible(true)
    buff_num = buff_num + 1
  end
  if stage then
    for i = 1, 5 do
      if stage["Requirement Type " .. i] == "HeroRankAtLeast" and 0 < tonumber(stage["Requirement Detail " .. i] or 0) then
        local rank = tonumber(stage["Requirement Detail " .. i])
        self.heroLimit = {type = "rank", detail = rank}
        local size_buff = ui.buff:getContentSize()
        ui.rank_limit:setPosition(ccp(standard_pos.x + size_buff.width * buff_num, standard_pos.y))
        ui.rank_limit:setVisible(true)
        buff_num = buff_num + 1
        break
      end
    end
  end
  local chapterId = stage["Chapter ID"]
  local difficulty = stage.Difficulty
  local stageType = {
    [1] = "NormalChapterLootRaise",
    [2] = "HighlevelChapterLootRaise",
    [3] = "GuildChapterLootRaise",
    [102] = "TimeCaveLootRaise",
    [103] = "HeroTestLootRaise",
    [105] = "PredictivePoolLootRaise"
  }
  local r, m, n, key1, key2
  if chapterId <= ed.parameter.max_normal_chapter then
    key1 = stageType[difficulty]
    key2 = chapterId
  else
    key1 = stageType[chapterId]
    key2 = difficulty
  end
  if 0 < buff_num then
    ui.title:setPosition(ccp(340 + buff_num * 20, 438))
  end
end

class.initBuffSprite = initBuffSprite

local function stagefd(self)
  local stars = ed.player:getStageStar(self.stage)
  return not stars or not (0 < stars)
end

class.stagefd = stagefd

local function adjustForSpring(self)
  local info = ed.lookupDataTable("ActStageGroup", nil, self.stageGroup)
  local x = 220
  local y = 335
  local t = 25
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "detail1",
        text = info["Boss Skill 1 Name"],
        size = 21
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(x, y)
      },
      config = {
        color = ed.toccc3(15843697),
        dimension = CCSizeMake(490, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "detail2",
        text = info["Boss Skill 1 Description"],
        size = 21
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(x, y - t)
      },
      config = {
        color = ed.toccc3(16777215),
        dimension = CCSizeMake(490, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "detail3",
        text = info["Boss Skill 2 Name"],
        size = 21
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(x, y - t * 2 - (resource_config.stagedetail_boss_sill_description_y or 20))
      },
      config = {
        color = ed.toccc3(15843697),
        dimension = CCSizeMake(490, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "detail4",
        text = info["Boss Skill 2 Description"],
        size = 21
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(x, y - t * 3 - (resource_config.stagedetail_boss_sill_description_y or 20))
      },
      config = {
        color = ed.toccc3(16777215),
        dimension = CCSizeMake(370, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  if self.ui.detail2:getContentSize().height > 60 then
    self.ui.detail2:setFontSize(1155 / self.ui.detail2:getContentSize().height)
  end
  local fcaTb = {}
  local v = ed.ui.exerciseres.spring.entry[self.key]
  for i = 1, #v.fca do
    local f = v.fca[i]
    local n = string.gsub(f, "%.cha$", "")
    local fn
    if ed.getDataTable("Puppet")[f].Resource then
      local res = ed.getDataTable("Puppet")[f].Resource
      local comps = ed.getDataTable("Puppet")[f]["Change Components"]
      fn = ed.createFcaActor(res, v.scale[i])
      if comps and 0 < #comps then
        for i = 1, #comps, 2 do
          fn:setComponent(comps[i], comps[i + 1])
        end
      end
      table.insert(fcaTb, {
        res = res,
        scale = v.scale[i],
        fcaaction = v.fcaaction,
        comps = comps,
        shader = v.shader
      })
    else
      fn = ed.createFcaActor(n, v.scale[i])
      table.insert(fcaTb, {
        res = n,
        scale = v.scale[i],
        fcaaction = v.fcaaction,
        shader = v.shader
      })
    end
    local fa = "Idle"
    if v.fcaaction then
      fa = v.fcaaction
    end
    fn:setAction(fa)
    fn:setLoop(true)
    fn:setPosition(ccp(140, 220))
    self.mainLayer:addChild(fn, 10)
    self:addFca(fn)
    if v.shader then
      fn:useShader(v.shader)
    end
  end
  self.battleData.monMod = fcaTb
end

class.adjustForSpring = adjustForSpring

local function initChallengePro(self)
  if self.mode ~= "challenge" then
    return
  end
  local challengePro = 0
  local challengeModeIcons = {}
  local challengeModeTitle = {}
  for k, v in pairs(self.challengeModes or {}) do
    local isFinish = ed.player:getStageStar(v)
    challengePro = challengePro + (0 < isFinish and 1 or 0)
    local res = ""
    local title = ed.getChallengeName(v)
    table.insert(challengeModeIcons, res)
    table.insert(challengeModeTitle, title)
  end
  self.challengePro = challengePro
  self.challengeModeIcons = challengeModeIcons
  self.challengeModeTitle = challengeModeTitle
end

class.initChallengePro = initChallengePro

local function create(stage, addition, mode, enterHandler)
  local identity
  addition = addition or {}
  local isGetWay = addition.isGetWay
  local isExercise = addition.isExercise
  local actType = addition.actType
  local key = addition.key
  local leftTimes = addition.leftTimes
  local challengeModes = addition.challengeModes
  local getWayItemId = addition.getWayItemId
  local getWayItemNeed = addition.getWayItemNeed
  if isExercise then
    identity = "exerciseStageDetail"
  elseif isGetWay then
    identity = "stageDetailGWMode"
  else
    identity = "stageDetail"
  end
  local self = base.create(identity)
  setmetatable(self, class.mt)
  self.addition = addition
  self.stage = stage
  self.mode = mode or ed.stageType(stage)
  self.heroLimit = addition.heroLimit
  self.actType = actType
  self.key = key
  self.rtimes = 0
  self.leftTimes = leftTimes
  self.challengeModes = challengeModes
  self.getWayItemId = getWayItemId
  self.getWayItemNeed = getWayItemNeed
  local st = ed.stageType(self.stage)
  self.stageGroup = ed.getDataTable("Stage")[stage]["Stage Group"]
  local isNormalMode = ed.stageType(stage) == "normal"
  self.enterHandler = enterHandler
  self.guildInstanceData = addition.guildInstanceData
  if self:isSpring() then
    self.step = 1
  else
    self.step = self.guildInstanceData and self.guildInstanceData.step or 3
  end
  self:initChallengePro()
  self:getInformation(stage)
  local info = self.stageInfo
  local resInfo = self.resInfo
  local map_ui = ed.ui.stageselectres.map["chapter" .. info.chapter]
  if map_ui.lootStage and map_ui.lootStage.bossId and map_ui.lootStage.eid == self.stage then
    self.addition.lootStage = map_ui.lootStage
  end
  self.ui = {}
  local mainLayer = self.mainLayer
  local titlepos = ccp(327, 355)
  local titleinfopos = titlepos
  local diffpos = ccp(-540, 355)
  if identity == "exerciseStageDetail" then
    if not self:filterCreateRepeatStage() or ed.player:getLevel() < 75 then
      titlepos = ccp(400, 355)
    end
    titleinfopos = ccp(titlepos.x - 25, titlepos.y)
  end
  self.battleData = {}
  self.battleData.powerNum = info.power
  self.battleData.titleName = info.titleName
  self.battleData.detail = info.detail
  self.battleData.countLimit = {
    countLimit = info.countLimit,
    count = info.count
  }
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local frameWid = 0.75
  local frameHei = 0.8
  local sise = 960
  if widhtWin ~= sise then
    local sca = sise / widhtWin
    frameWid = frameWid * sca
  end
  sise = 540
  if heightWin ~= sise then
    local sca = sise / heightWin
    frameHei = frameHei * sca
  end
  local frameBgWid = 720
  local frameBgHei = 447
  local frameBgX = (widhtWin - frameBgWid) / 2
  local frameBgY = (heightWin - heightWin * frameHei) / 2 + 7.5
  local starBgY = 403.8
  local detailY = 332
  local detailLineY = 330
  local powerY = 293.76
  local enemyY = 233.28
  local awardY = 146.88
  local lineY = 103.68
  local btnY = 43.2
  local titleBgRes = self.mode == "elite" and "campaign_detail_hard_title.png" or "campaign_detail_normal_title.png"
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame2",
        res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
        capInsets = CCRectMake(17, 17, 11, 11)
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(frameBgX, frameBgY - 15)
      },
      config = {
        scaleSize = CCSizeMake(frameBgWid, frameBgHei)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "frameBg",
        res = "UI/alpha/1080P/scale9/frame_common1.png",
        capInsets = CCRectMake(25, 125, 25, 125)
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(frameBgX, frameBgY - 15)
      },
      config = {
        scaleSize = CCSizeMake(frameBgWid, frameBgHei)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title_bg1",
        res = "UI/alpha/1080P/campaign/" .. titleBgRes,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(frameBgWid / 2, heightWin * frameHei - (self.mode == "elite" and 2 or 9) + 15)
      }
    },
    {
      t = "Label",
      base = {
        name = "title",
        font = ed.fontBold,
        text = info.title,
        size = 24,
        parent = "frameBg"
      },
      layout = {
        position = ccp(frameBgWid / 2, heightWin * frameHei - (self.mode == "elite" and 3 or 9) + 15)
      },
      config = {
        color = ed.toccc3(16772224),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "FixScaleInst",
      name = "title",
      mode = "w",
      size = CCSizeMake(216, 0)
    },
    {
      t = "Sprite",
      base = {
        name = "star_line1",
        res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
        parent = "frameBg"
      },
      layout = {
        position = ccp(frameBgWid / 2 - 130, starBgY - 5)
      },
      config = {
        scalexy = {x = -1, y = 1}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "star_line2",
        res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
        parent = "frameBg"
      },
      layout = {
        position = ccp(frameBgWid / 2 + 130, starBgY - 5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "star_bg",
        res = "UI/alpha/1080P/campaign/campaign_detail_star_lock_bg.png",
        parent = "frameBg"
      },
      layout = {
        position = ccp(frameBgWid / 2, starBgY)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "star_bg2",
        res = "UI/alpha/1080P/campaign/campaign_detail_in_bg.png",
        parent = "frameBg",
        capInsets = CCRectMake(10, 0, 10, 0)
      },
      layout = {
        position = ccp(frameBgWid / 2, starBgY - 5)
      },
      config = {
        scaleSize = CCSizeMake(frameBgWid - 550, 22)
      }
    },
    {
      t = "Label",
      base = {
        name = "star_bg2_label",
        text = T("\230\143\146 \230\155\178"),
        size = 16,
        parent = "star_bg2"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp((frameBgWid - 550) / 2, 11)
      },
      config = {
        color = ed.toccc3(16776423),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Layer",
      base = {
        name = "titledetailLay",
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(24, detailY)
      },
      config = {
        scaleSize = CCSizeMake(frameBgWid - 48, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "detailLine",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
        parent = "frameBg",
        capInsets = CCRectMake(50, 0, 148, 0)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(21, detailLineY)
      },
      config = {
        scaleSize = CCSizeMake(frameBgWid - 42, 10)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buff_bg",
        res = "UI/alpha/1080P/campaign/main/campaign_buff_bg.png",
        parent = "frameBg"
      },
      layout = {
        position = ccp(105, frameBgHei - 24)
      },
      config = {
        scalexy = {x = 0.9, y = 0.9},
        opacity = 80,
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buff",
        res = "UI/alpha/1080P/campaign/stagedetail_energy_leak_icon.png",
        parent = "buff_bg"
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(70, 18)
      },
      config = {
        scalexy = {x = 1.1, y = 1.1},
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "rank_limit",
        res = "UI/alpha/1080P/campaign/stagedetail_rank_limit_icon.png",
        parent = "buff_bg"
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(105, 18)
      },
      config = {
        scalexy = {x = 1.1, y = 1.1},
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "drop_buff",
        res = "UI/alpha/1080P/common/milestone_loot_raise.png",
        parent = "buff_bg"
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(140, 18)
      },
      config = {
        scalexy = {x = 1.1, y = 1.1},
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "power_title",
        text = T("\228\189\147\229\138\155\230\182\136\232\128\151\239\188\154"),
        size = 16,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(24, powerY)
      },
      config = {
        color = ed.toccc3(16753969),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "power_number",
        text = info.power,
        size = 16,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        right2 = {
          name = "power_title",
          offset = 42
        }
      },
      config = {
        color = ed.toccc3(16753969),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "power_icon",
        res = "UI/alpha/1080P/icon/vitality.png",
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0.2),
        right2 = {
          name = "power_number",
          offset = 7
        }
      },
      config = {
        fix_size = CCSizeMake(24, 30)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemy_bg",
        res = "UI/alpha/1080P/campaign/campaign_detail_bg.png",
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, enemyY)
      },
      config = {
        scalexy = {x = 1, y = 5}
      }
    },
    {
      t = "Label",
      base = {
        name = "enemy_title",
        text = T("\230\149\140\230\150\185\233\152\181\229\174\185\239\188\154"),
        size = 16,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(24, enemyY - 6)
      },
      config = {
        color = ed.toccc3(16753969),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "award_title",
        text = T("\229\143\175\232\131\189\232\142\183\229\190\151\239\188\154"),
        size = 16,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(24, awardY)
      },
      config = {
        color = ed.toccc3(16753969),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line_bg",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_2_fa.png",
        parent = "frameBg"
      },
      layout = {
        position = ccp(frameBgWid / 2, lineY)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "line_1",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_2_lin.png",
        parent = "frameBg",
        capInsets = CCRectMake(20, 0, 20, 0)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(21, lineY)
      },
      config = {
        scaleSize = CCSizeMake((frameBgWid - 42) / 2 - 17, 14)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "line_2",
        res = "UI/alpha/1080P/campaign/campaign_detail_line_2_lin.png",
        parent = "frameBg",
        capInsets = CCRectMake(20, 0, 20, 0)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(frameBgWid - 21, lineY)
      },
      config = {
        scaleSize = CCSizeMake((frameBgWid - 42) / 2 - 17, 14),
        scalexy = {x = -1, y = 1}
      }
    },
    {
      t = "Label",
      base = {
        name = "count_title",
        text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176:"),
        size = 15,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(1, 0),
        position = ccp(frameBgWid - 75, btnY + 40)
      },
      config = {
        color = ed.toccc3(16777215),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "count_number",
        text = "" .. info.countLimit - info.count,
        size = 15,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        right2 = {
          name = "count_title",
          offset = 5
        }
      },
      config = {
        color = self.stageInfo.count >= self.stageInfo.countLimit and ed.toccc3(16753969) or ed.toccc3(16777215),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "total_number",
        text = "/" .. (info.countLimit or "??"),
        size = 15,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0, 0),
        right2 = {
          name = "count_number",
          offset = 2
        }
      },
      config = {
        color = ed.toccc3(16753969),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "go_button",
        res = "UI/alpha/1080P/common/buttion_big.png",
        z = 10,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(frameBgWid - 25 - 96, btnY + 2)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "go_button_img",
        res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
        parent = "go_button"
      },
      layout = {
        anchor = ccp(0.5, 0),
        position = ccp(60, 11)
      }
    },
    {
      t = "Label",
      base = {
        name = "reset_label",
        text = T("\230\140\145 \230\136\152"),
        size = 22,
        parent = "go_button"
      },
      layout = {
        position = ccp(85, 30),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ccc3(253, 240, 158)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close_btn",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        z = 10,
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(frameBgWid - 12, frameBgHei - 12)
      },
      config = {
        scalexy = {x = 0.7, y = 0.7}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close_btn_img",
        res = "UI/alpha/1080P/common/butt_off.png",
        parent = "close_btn"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(28, 28)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "stage_lineup_btn",
        res = "UI/alpha/1080P/campaign/lineup_guide/enter_bg.png",
        parent = "frameBg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(frameBgWid / 2 + 260, starBgY - 5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "stage_lineup_img",
        res = "UI/alpha/1080P/campaign/lineup_guide/icon.png",
        parent = "stage_lineup_btn"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(35, 18.75)
      }
    },
    {
      t = "Label",
      base = {
        name = "stage_lineup_label",
        text = T("\230\148\187\231\149\165"),
        size = 18,
        parent = "stage_lineup_btn"
      },
      layout = {
        position = ccp(50, 18.75),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16776893),
        shadow = {
          color = ed.toccc3(7025677),
          offset = ccp(0, -2)
        }
      }
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  ed.adaptLabel(self.ui.stage_lineup_label, {maxWidth = 50, minScale = 0.5})
  ed.layout.horizontalSortNode({
    self.ui.stage_lineup_img,
    self.ui.stage_lineup_label
  }, {1, 0}, self.ui.stage_lineup_btn:getContentSize().width * 0.5)
  self.autoTextWid = frameBgWid
  self.ui.titledetailLay:removeAllChildrenWithCleanup(true)
  local lineSpace = EDCurLanguage == "ko" and 0 or 3
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = info.detail,
    fontSize = 15,
    lineSpacing = lineSpace,
    maxWidth = self.autoTextWid - 48,
    color = ed.toccc3(16777215)
  })
  local _, atHei = autoText:getCurContentSize()
  local dlList = ed.UITool.createDraglist(self.ui.titledetailLay, {})
  dlList:addItem(autoText.node)
  local layer_size = self.ui.titledetailLay:getContentSize()
  if atHei > layer_size.height then
    autoText.node:setPosition(0, layer_size.height - autoText:getFirstLineHeight() * 0.6)
    dlList:initListHeight(atHei + 5)
  else
    autoText.node:setPosition(0, (atHei + layer_size.height - autoText:getFirstLineHeight()) * 0.5)
  end
  local enemyContainer = CCNode:create()
  self.ui.enemyContainer = enemyContainer
  enemyContainer:setPosition(24, enemyY - 6)
  self.ui.frameBg:addChild(enemyContainer, 99)
  local awardContainer = CCNode:create()
  self.awardContainer = awardContainer
  awardContainer:setPosition(140, awardY - 30)
  self.ui.frameBg:addChild(awardContainer, 20)
  ed.setLabelShadow(self.ui.reset_label, ed.toccc3(0), ccp(1, 0))
  self:refreshEliteTime()
  if self:isSpring() then
    self.ui.power_title:setVisible(false)
    self.ui.power_number:setVisible(false)
    self.ui.power_icon:setVisible(false)
    ed.setString(self.ui.enemy_title, self:stagefd() and T("\233\166\150\230\172\161\233\128\154\229\133\179\229\165\150\229\138\177:") or T("\229\143\175\232\131\189\229\165\150\229\138\177:"))
    self.ui.enemy_title:setAnchorPoint(ccp(0, 0.5))
    self.ui.enemy_title:setPosition(ccp(70, 168))
    ed.setString(self.ui.award_title, T("\230\142\168\232\141\144\232\139\177\233\155\132:"))
    ed.setNodeMaxWidth(self.ui.award_title, 118)
    self:adjustForSpring()
    self:createRecommend()
    self.ui.enemy_bg:setVisible(false)
    self.ui.enemy_title:setPosition(ccp(70, 168 - delta))
    self.ui.award_title:setPositionY(self.ui.award_title:getPositionY() - delta + 10)
  end
  initBuffSprite(self)
  self:createRepeatBattle()
  self:createStars()
  if not self:isSpring() then
    self:createEnemy()
  end
  self:createReward(frameBgWid)
  self:addGuildInstanceUI()
  self:addChallengeInstanceUI()
  ed.setLabelDimensions(self.ui.award_title, CCSizeMake(110, 0))
  self.ui.award_title:setHorizontalAlignment(kCCTextAlignmentLeft)
  self.ui.award_title:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
  if isNormalMode or st == "act" or self.mode == "guild" or self.mode == "challenge" then
    self.ui.count_title:setVisible(false)
    self.ui.count_number:setVisible(false)
    self.ui.total_number:setVisible(false)
  end
  for i = 1, 6 do
    if self.ui["reward" .. i] ~= nil and self.rewardInfo[i] and self.rewardInfo[i].hero then
      self.ui["reward" .. i]:setScale(0.9)
      local res = ed.Hero.getIconFrameByRank(self.rewardInfo[i].rank)
      local frame = ed.createSprite(res)
      frame:setPosition(ccp(41, 40))
      self.ui["reward" .. i]:addChild(frame)
    end
  end
  self:showStageSwitchButton()
  self:registerOnEnterHandler("onEnter", function()
    self:checkEnabled()
    self.isPushing = nil
  end)
  self:btRegisterHandler({
    handler = self:getMainTouchHandler(),
    key = "stage_detail_main"
  })
  self:registerUpdateHandler("checkReset", self:doUpdateCheckResetHandler())
  addGuildEvent(self)
  addEventListener(self)
  self:registerTouchHandler()
  if addition.lootStage and addition.lootStage.bossId then
    self:addLootStageLayer(addition.lootStage)
  end
  return self
end

class.create = create

local function addLootStageLayer(self, lootStage)
  if not self.selectedLayer then
    local selectedImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/selectsoul_1.png",
      pos = ccp(self.autoTextWid - 323, 47),
      parent = self.ui.frameBg,
      rectMake = CCRectMake(18, 25, 4, 13),
      sizeMake = CCSizeMake(190, 61.5)
    })
    ed.createLabelTools({
      txt = T("\229\191\131\230\132\191\231\129\181\233\173\130\231\159\179\239\188\154"),
      anchor = ccp(0, 0.5),
      size = 15,
      pos = ccp(self.autoTextWid - 416, 87),
      color = ccc3(255, 255, 247),
      parent = self.ui.frameBg
    })
    self.selectedLayer = CCLayer:create()
    selectedImg:addChild(self.selectedLayer)
  end
  local stageItemId
  for i, v in ipairs(ed.player:getStageSelectReward() or {}) do
    if v._stage_id == lootStage.eid then
      stageItemId = v._reward_id
      break
    end
  end
  self.selectedLayer:removeAllChildrenWithCleanup(true)
  local redImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
    pos = ccp(53, 53),
    parent = self.selectedLayer,
    scale = 1,
    z = 99
  })
  redImg:setVisible(ed.ui.stageselectres.getLootStagesNewRedShow(lootStage.eid))
  self.lootStageRedImg = redImg
  if stageItemId then
    local item = ed.createItemIcon({
      id = stageItemId,
      type = "item",
      amount = 1
    })
    self.selectedLayer:addChild(item)
    item:setScale(0.7)
    item:setPosition(32, 31)
    local button = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/button_a_butt.png",
      pos = ccp(124, 29),
      parent = self.selectedLayer
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/friend/friend_refresh.png",
      pos = ccp(29, 24),
      parent = button,
      scale = 1.2
    })
    ed.createLabelTools({
      txt = T("\230\155\180\230\141\162"),
      anchor = ccp(0, 0.5),
      size = 18,
      pos = ccp(48, 24),
      color = ccc3(ed.colorToStr("#F0E299")),
      parent = button
    })
    local item = ed.createItemIcon({
      id = stageItemId,
      type = "item",
      amount = 1
    })
    item:setAnchorPoint(ccp(0, 0))
    self.autoItemIcon:getParent():addChild(item)
    item:setScale(self.autoItemIcon:getScale())
    item:setPosition(ccp(self.autoItemIcon:getPosition()))
    self.autoItemIcon:removeFromParentAndCleanup(true)
    self.autoItemIcon = item
    self.autoItems = {
      id = stageItemId,
      cnt = nil,
      isSpring = false
    }
    self.battleData.items[#self.battleData.items] = {
      id = stageItemId,
      cnt = nil,
      isSpring = false
    }
    self.ui["reward" .. #self.battleData.items] = self.autoItemIcon
    local equip = ed.getDataTable("equip")
    self.rewardInfo[#self.rewardInfo] = {
      id = stageItemId,
      res = equip[stageItemId].Icon,
      name = equip[stageItemId].Name,
      lootId = true
    }
    local stoneFull = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/main/campaign_stage_soulstone_full.png",
      pos = ccp(45, 50),
      parent = self.selectedLayer,
      z = 99,
      notShow = true
    })
    local heroId = ed.readhero.getMakeid(stageItemId)
    local hero = ed.player.heroes[heroId]
    stoneFull:setVisible(hero and hero._stars >= 5)
    self.openLootStageBtn = button
  else
    local nullImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/selectsoul_3.png",
      pos = ccp(32, 31),
      parent = self.selectedLayer
    })
    local addImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/add_big.png",
      pos = ccp(34, 33),
      parent = nullImg
    })
    addImg:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 50), CCFadeTo:create(1, 255))))
    local text_lab = ed.createLabelTools({
      txt = T("\230\156\170\233\128\137\230\139\169\231\129\181\233\173\130\231\159\179"),
      anchor = ccp(0, 0.5),
      size = 15,
      pos = ccp(74, 30),
      color = ccc3(ed.colorToStr("#70ff54")),
      parent = self.selectedLayer
    })
    text_lab:setDimensions(CCSizeMake(110, 0))
    self.openLootStageBtn = nullImg
  end
end

class.addLootStageLayer = addLootStageLayer

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame2,
    key = "out_click",
    clickHandler = function()
      if self.pessArrow then
        return
      end
      if self.enterHandler then
        self.enterHandler()
      end
      self:destroy({skipAnim = true})
    end
  })
  self:btRegisterButtonClick({
    button = ui.close_btn,
    key = "close",
    clickHandler = function()
      if self.enterHandler then
        self.enterHandler()
      end
      self:destroy({skipAnim = true})
    end,
    pressScale = 0.75,
    normalScale = 0.7
  })
  self:btRegisterButtonClick({
    button = ui.stage_lineup_btn,
    key = "stage_lineup_btn",
    clickHandler = function()
      ed.ui.stageLineupPop.create({
        gameplay = "stage",
        stageid = self.stage
      }):popWindow()
    end,
    pressScale = 0.95,
    normalScale = 1
  })
end

class.registerTouchHandler = registerTouchHandler

function class:canShowCampCounterByMode()
  local mode = self.mode
  if mode == "normal" then
    return true
  elseif mode == "elite" then
    return true
  elseif mode == "challenge" then
    return true
  end
  return false
end

function class:getCampCounterPos()
  local mode = self.mode
  if mode == "normal" then
    return ccp(715, 310)
  elseif mode == "elite" then
    return ccp(715, 310)
  elseif mode == "challenge" then
    return ccp(715, 356)
  end
  return ccp(0, 0)
end

function class:initCampCounterIcon()
  if not ed.CampTowerManager.isTowerModuleEnabled() then
    return
  end
  if not self:canShowCampCounterByMode() then
    return
  end
  local campLevel = ed.getDataTable("Battle")[self.stage][self.step]["Camp Level"]
  if (campLevel or 0) <= 0 then
    return
  end
  if not tolua.isnull(self.ui.campCounterIcon) then
    return
  end
  local touchLayer, touchNode = ed.UITool.createTouchLayer()
  self.mainLayer:addChild(touchLayer)
  self.campTouchLayer = touchLayer
end

local function createForExercise(stage, addition)
  addition = addition or {}
  addition.isExercise = true
  return create(stage, addition)
end

class.createForExercise = createForExercise

function class:showStageSwitchButton()
  local st = ed.stageType(self.stage)
  local isShow = ed.isElementInTable(st, {"normal", "elite"})
  if isShow and nil == self.leftArrow and nil == self.rightArrow then
    local left = ed.createSprite("UI/alpha/1080P/campaign/main/prevchap.png")
    local right = ed.createSprite("UI/alpha/1080P/campaign/main/nextchap.png")
    local widhtWin = ed.display.winSize.width
    local heightWin = ed.display.winSize.height
    local newWid = ed.display.halfFixedWidth
    local newHei = ed.display.halfFixedHeight
    local y = heightWin / 2
    self.leftArrow = left
    self.rightArrow = right
    self.mainLayer:addChild(left, 30)
    self.mainLayer:addChild(right, 30)
    left:setPosition(ccp(78, y))
    right:setPosition(ccp(widhtWin - 78, y))
    left:setScale(1.5)
    right:setScale(1.5)
    local leftPosX = left:getPositionX()
    local rightPosX = right:getPositionX()
    local lmove = CCMoveTo:create(1, ccp(leftPosX - 10, y))
    local lreverse = CCMoveTo:create(1, ccp(leftPosX, y))
    local lsequence = CCSequence:createWithTwoActions(lmove, lreverse)
    self.leftArrow:runAction(CCRepeatForever:create(lsequence))
    local rmove = CCMoveTo:create(1, ccp(rightPosX + 10, y))
    local rreverse = CCMoveTo:create(1, ccp(rightPosX, y))
    local rsequence = CCSequence:createWithTwoActions(rmove, rreverse)
    self.rightArrow:runAction(CCRepeatForever:create(rsequence))
  end
  if self.leftArrow and self.rightArrow then
    local nextId = self:getSwitchStage(1)
    local preId = self:getSwitchStage(-1)
    self.leftArrow:setVisible(isShow and preId ~= self.stage)
    self.rightArrow:setVisible(isShow and nextId ~= self.stage)
  end
end

local mode_ui_info = {
  ["repeat"] = {
    {
      t = "Label",
      base = {
        name = "last_title",
        text = T("\230\137\171\232\141\161\229\136\184:"),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(35, 0)
      },
      config = {
        color = ccc3(255, 234, 198)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sweep_icon",
        res = "UI/alpha/1080P/icon/raidticke.png",
        parent = "last_title"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 6)
      },
      config = {fix_height = 26}
    },
    {
      t = "Label",
      base = {
        name = "count",
        text = "",
        size = 16,
        parent = "last_title"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(60, 8)
      },
      config = {
        color = ed.toccc3(16753969)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "some",
        res = "UI/alpha/1080P/common/button_com_big.png"
      },
      layout = {
        position = ccp(90, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "some_label",
        text = "",
        size = 20
      },
      layout = {
        position = ccp(90, 0)
      },
      config = {
        color = ccc3(253, 240, 158)
      }
    },
    {
      t = "Label",
      base = {
        name = "task_title",
        text = T("\232\191\155\229\186\166:"),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(250, 0)
      },
      config = {
        color = ccc3(241, 193, 113),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "task_pro",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {name = "task_title", offset = 2}
      },
      config = {
        color = ccc3(255, 234, 198),
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "once",
        res = "UI/alpha/1080P/common/button_com_big.png"
      },
      layout = {
        position = ccp(228, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "once_label",
        text = T("\230\137\171\232\141\161"),
        size = 20
      },
      layout = {
        position = ccp(228, 0)
      },
      config = {
        color = ccc3(253, 240, 158)
      }
    }
  },
  guild = {},
  challenge = {}
}
class.mode_ui_info = mode_ui_info
