require("md5")
require("bit")
require("hero")
require("pet/pet")
module("ed", package.seeall)
local ed = ed
ed.runeMaxPoint = 999999

local function copyPbMessage(src, creater)
  if src == nil then
    return nil
  end
  local dest = creater()
  for k, v in pairs(src[".data"]) do
    dest[k] = v
  end
  return dest
end

local function copyPbArray(src, creater)
  if src == nil then
    return nil
  end
  local array = {}
  for i, v in ipairs(src) do
    array[i] = copyPbMessage(src[i], creater)
  end
  return array
end

local sub = string.sub

local function _setter(self, key, value)
  local delegate = rawget(self, "data")
  if delegate and sub(key, 1, 1) == "_" then
    delegate[key] = value
  else
    rawset(self, key, value)
  end
end

local function getGetter(class)
  local function _getter(self, key)
    local delegate = rawget(self, "data")
    
    if delegate and sub(key, 1, 1) == "_" then
      return delegate[key]
    else
      return class[key]
    end
  end
  
  return _getter
end

Player = {}
local classmt = {
  __index = getGetter(Player),
  __newindex = _setter
}

local function PlayerCreate()
  local self = {
    data = false,
    equip_order = {},
    equip_qunty = {},
    skillbook_qunty = {},
    heroes = {},
    friends = {},
    aid_list = {},
    tutorial = {},
    stage_stars = {},
    stage_limit_back_key = {},
    stage_limit = {},
    stage_reset_times = {},
    loots = {},
    hpLoots = {},
    initialized = false,
    time_diff = 0,
    warschool = {},
    gcw = {},
    meals = {},
    heroBondsRedStatus = {},
    _rmb = 0,
    _rmb_free = 0,
    _rmb_pay = 0,
    _rmb_debt = 0
  }
  setmetatable(self, classmt)
  return self
end

ed.player = PlayerCreate()

function Player:getPlayerUID(name, value)
  return self.data._userid
end

function Player:getNameCardParam(name)
  if not self._name_card then
    return
  end
  return self._name_card[name]
end

function Player:setNameCardParam(name, value)
  if not self._name_card then
    return
  end
  self._name_card[name] = value
end

function Player:getName()
  local name = self:getNameCardParam("_name")
  if not name then
    return ""
  end
  local noShowName = {
    "NickName",
    "gm_modified"
  }
  if ed.isElementInTable(name, noShowName) then
    return ""
  end
  return name
end

function Player:setMedal(info)
  self.medalInfo = self.medalInfo or {}
  if info._open_panel and (info._open_panel._medal_item or info._open_panel._task_list) then
    if info._open_panel._medal_item then
      self.medalInfo.haveInfo = ed.copyProto(info._open_panel._medal_item)
    end
    if info._open_panel._task_list then
      local taskList = {}
      for i, v in ipairs(info._open_panel._task_list) do
        taskList[v._medal_id] = {
          progress = v._progress,
          target = v._target
        }
      end
      self.medalInfo.taskList = taskList
    end
  elseif info._set_medal and info._set_medal._result == "success" then
    if ed.ui.headSettingWindow.setMedalId then
      self.medalInfo.wearId = ed.ui.headSettingWindow.setMedalId
      for k, v in pairs(self.medalInfo.haveInfo) do
        if self.medalInfo.wearId == v._medal_id then
          self.medalInfo.wearInfo = ed.copyTable(v)
        end
      end
    else
      self.medalInfo.wearId = nil
      self.medalInfo.wearInfo = nil
    end
    self:setNameCardParam("_medal", self.medalInfo.wearInfo)
  end
end

function Player:examineWearInfo(wearInfo)
  wearInfo = wearInfo or self.medalInfo.wearInfo
  if wearInfo and wearInfo._expire_time then
    if wearInfo._expire_time >= ed.getServerTime() then
      return wearInfo
    else
      self.medalInfo.wearInfo = nil
      return
    end
  end
  return wearInfo
end

function Player:getMedal()
  self.medalInfo = self.medalInfo or {}
  self.medalInfo.wearInfo = self.medalInfo.wearInfo or self:getNameCardParam("_medal")
  self.medalInfo.wearInfo = self:examineWearInfo(self.medalInfo.wearInfo)
  return self.medalInfo
end

function Player:getMedalTask()
  return self.medalInfo.taskList or {}
end

function Player:setName(name)
  ed.player.preName = self:getName()
  self:setNameCardParam("_name", name)
end

function Player:refreshSetNameTime()
  local time = ed.getServerTime()
  if ed.player.preName == "" then
    time = time - 259200
  end
  self:setNameCardParam("_last_set_name_time", time)
end

function Player:getSetNameTime()
  return self:getNameCardParam("_last_set_name_time")
end

function Player:getNameCountdown()
  local lt = self:getNameCardParam("_last_set_name_time")
  local cd = 259200
  local time = ed.getServerTime()
  if cd < time - lt then
    return nil
  else
    local dt = cd - (time - lt)
    return ed.getdhmsCString(dt)
  end
end

function Player:getSetNameCost()
  return 100
end

function Player:getHeadIcon()
  local nameAvarar = self:getNameCardParam("_avatar")
  nameAvarar = nameAvarar or 0
  local avatar = ed.analyzeAvatar(nameAvarar)
  local id = avatar.avatar
  if (id or 0) == 0 then
    id = 1
  end
  return ed.lookupDataTable("Avatar", nil, id)
end

function Player:getHeadIconRes()
  return self:getHeadIcon().Picture
end

function Player:getHeadIconF()
  local nameAvarar = self:getNameCardParam("_avatar")
  local avatar = ed.analyzeAvatar(nameAvarar)
  local id = avatar.avatarFrame
  if (id or 0) == 0 then
    id = 1
  end
  return ed.lookupDataTable("AvatarFrame", nil, id)
end

function Player:getHeadIconFres()
  return self:getHeadIconF().Picture
end

function Player:getAvatar()
  return self:getNameCardParam("_avatar")
end

function Player:getAvatarId()
  return ed.analyzeAvatar(self:getAvatar()).avatar
end

function Player:getAvatarFrame()
  return ed.analyzeAvatar(self:getAvatar()).avatarFrame
end

function Player:setAvatar(id)
  self:setNameCardParam("_avatar", id)
end

function Player:getUserSummary()
  local summary = {
    _avatar = self:getAvatar(),
    _name = self:getName(),
    _vip = self:getvip(),
    _level = self:getLevel(),
    _guild_name = self:getGuildName(),
    _medal = self:getMedal().wearInfo
  }
  return summary
end

function Player:getLevel()
  self:checkLevelMax()
  return self._level
end

function Player:checkLevelMax(level)
  local pm = ed.parameter
  local ml = pm.team_level_max
  if level then
    if level >= ml then
      return true
    end
  else
    level = self._level
    if level and ml and ml <= level then
      self._level = ml
      self._exp = 0
      return true
    end
  end
  return false
end

function Player:levelup(source)
  if self:checkLevelMax() then
    return
  end
  local vr = ed.lookupDataTable("PlayerLevel", "Vitality Reward", self._level)
  self:addVitality(vr)
  self._level = self._level + 1
end

function Player:getNewLevel(babelLv, lv)
  if babelLv and 0 < babelLv then
    return babelLv, true
  elseif lv then
    return lv or 1, false
  end
  if 0 < ed.player:getBabelLevel() then
    return ed.player:getBabelLevel(), true
  else
    return ed.player:getLevel(), false
  end
end

function Player:getBabelLevel()
  return self._babel_level
end

function Player:babelLevelup()
  self._babel_level = self._babel_level + 1
end

function Player:getExp()
  self:checkLevelMax()
  return self._exp
end

function Player:getMaxExp()
  if self:checkLevelMax() then
    return 0
  else
    return ed.lookupDataTable("PlayerLevel", "Exp", self:getLevel())
  end
end

function Player:addExp(exp, source)
  if self:checkLevelMax() then
    self.teamAlreadyMaxLevel = true
    return
  end
  source = source or "else"
  local oexp = self._exp
  local olevel = self._level
  self._exp = self._exp + exp
  local levelup_exp
  local level = self._level
  while true do
    levelup_exp = math.floor(ed.lookupDataTable("PlayerLevel", "Exp", self._level))
    if levelup_exp == 0 then
      return
    end
    if levelup_exp <= self._exp then
      self._exp = self._exp - levelup_exp
      self:levelup(source)
    else
      break
    end
  end
  FireEvent("PlayerExpChanged", self._exp)
  if level < self._level then
    FireEvent("PlayerLevelUp", self._level, level)
  end
  print(string.format("%s\t exp +%i (%i/%i). Lv%i%s.", "*P*", exp, self._exp, levelup_exp, olevel, olevel == self._level and "" or " -> Lv" .. self._level))
end

function Player:getvip()
  local rsum = 0
  return ed.getVipLevel(rsum)
end

function Player:checkvipGiftValid(vip)
  local vgr = self._vip_gifts_draw or {}
  local cv = self:getvip()
  if vip > cv then
    return false
  end
  for i = 1, #vgr do
    if vip == vgr[i] then
      return false
    end
  end
  return true
end

function Player:refreshvipGiftRecord(vip)
  local vgr = self._vip_gifts_draw or {}
  for i = 1, #vgr do
    if vip == vgr[i] then
      return
    end
  end
  self._vip_gifts_draw = self._vip_gifts_draw or {}
  table.insert(self._vip_gifts_draw, vip)
end

function Player:getvipGift(vip)
  if not vip then
    return
  end
  local row = ed.lookupDataTable("VIPGift", nil, vip)
  if not row then
    return
  end
  local gt = {}
  local index = 1
  local giftType, giftId, giftAmount
  while true do
    giftType = string.format("Gift Type %d", index)
    giftId = string.format("Gift ID %d", index)
    giftAmount = string.format("Gift Amount %d", index)
    if not row[giftType] then
      break
    end
    gt[index] = {
      type = row[giftType],
      id = row[giftId],
      amount = row[giftAmount]
    }
    index = index + 1
  end
  return gt
end

function Player:addvipGift(vip)
  local gt = self:getvipGift(vip) or {}
  for i = 1, #gt do
    local g = gt[i]
    local type = g.type
    local id = g.id
    local amount = g.amount or 1
    if ed.isElementInTable(type, {"Item", "Hero"}) and id then
      local t = ed.itemType(id)
      if t == "hero" then
        self:addHero(id)
      elseif t == "equip" then
        self:addEquip(id, amount)
      end
    elseif type == "Gold" then
      self:addMoney(amount)
    end
  end
  self:refreshvipGiftRecord(vip)
end

function Player:addVipExp(amount)
  amount = amount or 0
  local previp = self:getvip()
  self._vip_exp = self._vip_exp + amount
  local vip = self:getvip()
  if previp < vip then
    local lsr = ed.ui.baselsr.create("base")
    lsr:report("vipLevelup", {previp = previp})
  end
  FireEvent("VipExpChange")
end

function Player:addMoney(money, silent)
  money = money or 0
  self._money = math.max(self._money + money, 0)
  self.addMoneySilent = silent
  FireEvent("PlayerMoneyChange", self._money)
  FireEvent("ResourceNumChange", "gold")
end

function Player:setMoney(money)
  self._money = money
  FireEvent("ResourceNumChange", "gold")
end

function Player:getDiamondAmount()
  return self._rmb
end

function Player:subrmb(rmb)
  rmb = rmb or 0
  if self.freeRMBFirst then
    if rmb <= self._rmb_free then
      self._rmb_free = self._rmb_free - rmb
    else
      self._rmb_pay = self._rmb_pay + self._rmb_free - rmb
      self._rmb_free = 0
    end
  elseif rmb <= self._rmb_pay then
    self._rmb_pay = self._rmb_pay - rmb
  else
    self._rmb_free = self._rmb_free + self._rmb_pay - rmb
    self._rmb_pay = 0
  end
  self:resetrmb()
  FireEvent("ResourceNumChange", "diamond")
end

function Player:addrmb(rmb)
  rmb = rmb or 0
  if rmb < 0 then
    self:subrmb(-rmb)
    return
  end
  self._rmb_free = self._rmb_free + rmb
  self:resetrmb()
  FireEvent("ResourceNumChange", "diamond")
end

function Player:addPayrmb(rmb)
  rmb = rmb or 0
  if rmb < 0 then
    self:subrmb(-rmb)
    return
  end
  self._rmb_pay = self._rmb_pay + rmb
  self:resetrmb()
  FireEvent("ResourceNumChange", "diamond")
end

function Player:setrmb(diamond)
  self._rmb_free = diamond._free_diamond or 0
  self._rmb_pay = diamond._pay_diamond or 0
  self._rmb_debt = diamond._debt_diamond or 0
  self:resetrmb()
  FireEvent("ResourceNumChange", "diamond")
end

function Player:resetrmb()
  local _rmb_free = self._rmb_free or 0
  local _rmb_pay = self._rmb_pay or 0
  local _rmb_debt = self._rmb_debt or 0
  self._rmb = _rmb_free + _rmb_pay - _rmb_debt
end

local repay_point_key = {
  arenapoint = true,
  dreampoint = true,
  legend_point = true
}

function Player:getPoint(name)
  name = string.lower(name)
  if name == "gold" then
    return self._money
  elseif name == "diamond" then
    return self._rmb
  end
  for k, v in pairs(self._points) do
    if v._type == name then
      return v._value
    end
  end
  return 0
end

local coin_type = {
  "gold",
  "diamond",
  "crusadepoint",
  "arenapoint",
  "guildpoint",
  "honourpoint",
  "gvgpoint",
  "dreampoint",
  "gcwpoint",
  "wood",
  "iron",
  "crystal",
  "bookexp",
  "sun",
  "moon",
  "star",
  "legend_point",
  "star_point",
  "tarot_point",
  "blue_pet_point",
  "purple_pet_point",
  "raid_point"
}

function Player:addPoint(name, amount)
  amount = amount or 0
  local ca = self:getPoint(name)
  local maxAmount = ed.player:getPointMaxAmount(name)
  local da = ca + amount - maxAmount
  if 0 < da then
    print(name .. "\232\182\133\228\184\138\233\153\144\239\188\129!!!!!!!!")
    amount = math.max(maxAmount - ca, 0)
  end
  if not ed.isElementInTable(name, coin_type) then
    print("Invalid coin type : " .. (name or "nil"))
  end
  if name == "gold" then
    self:addMoney(amount)
  elseif name == "diamond" then
    self:addrmb(amount)
  elseif name == "pay_diamond" then
    self:addPayrmb(amount)
  elseif name == "bookexp" then
    self:addReadingHouseExp(amount)
  else
    for k, v in pairs(self._points) do
      if v._type == name then
        if ed.isElementInTable(name, {
          "sun",
          "moon",
          "star"
        }) then
          if v._value + amount > ed.runeMaxPoint then
            local nameType = {
              sun = "\229\164\170\233\152\179\231\178\190\229\141\142",
              moon = "\230\150\176\230\156\136\231\178\190\229\141\142",
              star = "\230\153\168\230\152\159\231\178\190\229\141\142"
            }
            ed.showToast(nameType[name] .. "\229\183\178\232\182\133\229\135\186\228\184\138\233\153\144")
            v._value = ed.runeMaxPoint
          else
            v._value = v._value + amount
          end
        else
          v._value = v._value + amount
        end
      end
    end
    FireEvent("ResourceNumChange", name)
  end
end

function Player:subPoint(name, amount)
  if amount and amount < 0 then
    self:addPoint(name, amount)
  end
end

function Player:setPoint(name, amount)
  for k, v in pairs(self._points) do
    if v._type == name then
      v._value = amount
      break
    end
  end
  FireEvent("ResourceNumChange", name)
end

function Player:requestPoint(userPointType)
  if type(userPointType) == "string" then
    userPointType = {userPointType}
  end
  local msg = ed.upmsg.point_sync_req()
  msg._type = userPointType
  ed.send(msg, "point_sync")
end

function Player:pointSync(pointSyncReply)
  local showAnnounceType = {
    "tavern_point"
  }
  local showToken = {}
  for index, userPoint in ipairs(pointSyncReply._points) do
    local type = userPoint._type
    local newValue = userPoint._value
    local oldValue = self:getPoint(type)
    local changeAmount = newValue - oldValue
    self:setPoint(userPoint._type, userPoint._value)
    if ed.isElementInTable(type, showAnnounceType) and 0 < changeAmount then
      table.insert(showToken, {type = type, amount = changeAmount})
    end
  end
  if 0 < #showToken then
    ed.announce({
      type = "getProp",
      param = {
        title = T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
        items = showToken,
        closeWhenClickOut = true
      }
    })
  end
end

function Player:addCrusadeMoney(amount)
  amount = amount or 0
  self:addPoint("crusadepoint", amount)
end

function Player:addPvpMoney(amount)
  amount = amount or 0
  local num = ed.player:getPoint("arenapoint")
  local maxAmount = ed.player:getPointMaxAmount("arenapoint")
  if maxAmount < num + amount then
    amount = maxAmount - num
  end
  self:addPoint("arenapoint", amount)
end

function Player:addTopPvpMoney(amount)
  amount = amount or 0
  self:addPoint("honourpoint", amount)
end

function Player:addGuildMoney(amount)
  amount = amount or 0
  self:addPoint("guildpoint", amount)
end

function Player:addLegendPoint(amount)
  amount = amount or 0
  self:addPoint("legend_point", amount)
end

function Player:addStarPoint(amount)
  amount = amount or 0
  self:addPoint("star_point", amount)
end

function Player:addBluePetPoint(amount)
  amount = amount or 0
  self:addPoint("blue_pet_point", amount)
end

function Player:addPurplePetPoint(amount)
  amount = amount or 0
  self:addPoint("purple_pet_point", amount)
end

function Player:addTarotPoint(amount)
  amount = amount or 0
  self:addPoint("tarot_point", amount)
end

function Player:getCrusadeMoney()
  return self:getPoint("crusadepoint")
end

function Player:getPvpMoney()
  return self:getPoint("arenapoint")
end

function Player:getTopPvpMoney()
  return self:getPoint("honourpoint")
end

function Player:getGuildMoney()
  return self:getPoint("guildpoint")
end

function Player:getDreamlandMoney()
  return self:getPoint("dreampoint")
end

function Player:getGCWMoney()
  return self:getPoint("gcwpoint")
end

function Player:getWood()
  return self:getPoint("wood")
end

function Player:getIron()
  return self:getPoint("iron")
end

function Player:getCrystal()
  return self:getPoint("crystal")
end

function Player:getLegendPoint()
  return self:getPoint("legend_point")
end

function Player:getStarPoint()
  return self:getPoint("star_point")
end

function Player:getBluePetPoint()
  return self:getPoint("blue_pet_point")
end

function Player:getPurplePetPoint()
  return self:getPoint("purple_pet_point")
end

function Player:getTarotPoint()
  return self:getPoint("tarot_point")
end

function Player:checkVitalityFull()
  return ed.player._vitality._current >= ed.parameter.max_vitality_stock
end

function Player:addVitality(vit, timeAdd)
  vit = vit or 1
  local param = ed.parameter
  local vitality = self._vitality
  self._consume_vitality = self._consume_vitality or {}
  self._consume_vitality._consume = self._consume_vitality._consume or 0
  self:checkConsumeTimeStamp()
  self:refreshVitalityTime()
  if 0 < vit then
    if not timeAdd or vitality._current < ed.playerlimit.maxVitality() then
      vitality._current = vitality._current + vit
    end
  else
    vitality._current = vitality._current + vit
    self._consume_vitality._consume = self._consume_vitality._consume - vit
  end
  if 0 > vitality._current then
    print("vitality less than zero . it's a bug!")
    vitality._current = 0
  end
  self:refreshVitalityTime(timeAdd)
  FireEvent("ResourceNumChange", "vitality")
end

function Player:checkConsumeTimeStamp()
  if self._consume_vitality._timestamp then
    local y1, mon1, d1, h1, m, s = ed.time2YMDHMS(self._consume_vitality._timestamp)
    local y2, mon2, d2, h2, m, s = ed.time2YMDHMS(ed.getServerTime())
    if (tonumber(d1) < tonumber(d2) or tonumber(h1) < 5) and tonumber(h2) >= 5 then
      self._consume_vitality._timestamp = ed.getServerTime()
      self._consume_vitality._consume = 0
    end
  end
end

function Player:getConsumeVitality()
  self._consume_vitality = self._consume_vitality or {}
  self._consume_vitality._consume = self._consume_vitality._consume or 0
  self:checkConsumeTimeStamp()
  return self._consume_vitality._consume
end

function Player:getVitality()
  local vitality = self._vitality
  return vitality._current
end

function Player:checkVitalityLimit()
  local vitality = self._vitality
  local param = ed.parameter
  local vit = vitality._current
  if vit >= ed.playerlimit.maxVitality() then
    return true
  end
  return false
end

function Player:refreshVitalityTime(timeAdd)
  local vitality = self._vitality
  if timeAdd then
    local param = ed.parameter
    local gap = param.sync_vitality_gap
    local lt = vitality._lastchange
    vitality._lastchange = lt + gap
  end
  if self:checkVitalityLimit() then
    vitality._lastchange = ed.getServerTime()
  end
end

function Player:getVitalityBuyTimes()
  self:resetVitalityBuyTimes()
  local vitality = self._vitality
  return vitality._todaybuy
end

function Player:getBuyVitalityCost()
  local t = self:getVitalityBuyTimes()
  local isVitDiscount, count = ed.GobackManager:isInBuyVitDiscount()
  if isVitDiscount and t < count then
    local cost = ed.lookupDataTable("GradientPrice", "Vitality", t + 1)
    return cost * 0.5
  end
  return ed.lookupDataTable("GradientPrice", "Vitality", t + 1)
end

function Player:canBuyVitality()
  local t = self:getVitalityBuyTimes()
  local tlimit = ed.lookupDataTable("VIP", "Buy Vit Max", (self:getvip()))
  if t >= tlimit then
    return false
  end
  return true
end

local vitality_last_login

function Player:resetVitalityBuyTimes()
  local vitality = self._vitality
  local lt = vitality._lastbuy
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    vitality._todaybuy = 0
  end
end

function Player:refreshVitality()
  local param = ed.parameter
  local gap = param.sync_vitality_gap
  local vitality = self._vitality
  local ltime = vitality._lastchange
  local stime = ed.getServerTime()
  local dt = gap - (stime - ltime)
  while dt <= 0 do
    dt = dt + gap
    self:addVitality(1, true)
  end
end

function Player:getVitalityNextUpdate()
  local param = ed.parameter
  local gap = param.sync_vitality_gap
  local vitality = self._vitality
  local ltime = vitality._lastchange
  local stime = ed.getServerTime()
  local dt = gap - (stime - ltime)
  return dt
end

function Player:getSkillLvupChance()
  local slu = self._skill_level_up
  local chance = slu._skill_levelup_chance
  local isOverfull
  if chance >= self:getMaxSkillChance() then
    slu._skill_levelup_cd = ed.getServerTime()
    isOverfull = true
  end
  local time = slu._skill_levelup_cd
  local cd = ed.parameter.skill_level_up_chance_cd
  local nt = ed.getServerTime()
  local dt = nt - time
  dt = math.max(dt, 0)
  local addChance = math.floor(dt / cd)
  local last_refresh_time = slu._skill_levelup_cd
  if not isOverfull then
    slu._skill_levelup_chance = math.min(chance + addChance, self:getMaxSkillChance())
  end
  if self:checkSkillChanceMax() then
    last_refresh_time = ed.getServerTime()
    slu._skill_levelup_cd = last_refresh_time
  else
    last_refresh_time = nt - dt % cd
    slu._skill_levelup_cd = last_refresh_time
  end
  return slu._skill_levelup_chance, last_refresh_time
end

function Player:getSkillLvupNextCount()
  local chance, lrt = self:getSkillLvupChance()
  local slu = self._skill_level_up
  local time = lrt
  local cd = ed.parameter.skill_level_up_chance_cd
  local nt = ed.getServerTime()
  return cd - (nt - time)
end

function Player:strenHeroSkill(id, slot, add)
  add = add or 1
  local hero = self.heroes[id]
  hero._skill_levels[slot] = hero._skill_levels[slot] + add
end

function Player:getMaxSkillChance()
  local max = ed.lookupDataTable("VIP", "Max Skill Points", (self:getvip()))
  return max
end

function Player:checkSkillChanceMax()
  local amount = self._skill_level_up._skill_levelup_chance
  local max = self:getMaxSkillChance()
  if amount >= max then
    return true
  else
    return false
  end
end

function Player:resetSkillData()
  local sd = self._skill_level_up
  local lt = sd._last_reset_date
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    sd._reset_times = 0
  end
end

function Player:getSkillResetTimes()
  self:resetSkillData()
  local sd = self._skill_level_up
  return sd._reset_times
end

function Player:addSkillbook(tid)
  self:addItem(self.skillbook_qunty, self._skillbooks, tid)
  EDLog("Got book: " .. tid)
end

function Player:setGuildId(id)
  self._user_guild = self._user_guild or {}
  self._user_guild._id = id
end

function Player:getGuildId()
  if self._user_guild then
    return self._user_guild._id
  end
  return 0
end

function Player:setGuildName(name)
  self._user_guild = self._user_guild or {}
  self._user_guild._name = name
end

function Player:getGuildName()
  if self._user_guild then
    return self._user_guild._name
  end
  return nil
end

function Player:setGuildJob(job)
  self._user_guild = self._user_guild or {}
  self._user_guild._job = job
end

function Player:getGuildJob()
  if self._user_guild then
    return self._user_guild._job
  end
  return nil
end

function Player:setGuild(guild)
  self._user_guild = guild
end

function Player:setFriendsList(data)
  self._query_invitation_data_reply = data or {}
end

function Player:getFriendsList()
  return self._query_invitation_data_reply or {}
end

function Player:setCallBackFriends(data)
  self._user_list = data or {}
end

function Player:getCallBackFriends()
  return self._user_list or {}
end

function Player:isMercenaryHero(tid)
  if ed.player.heroes[tid] and ed.player.heroes[tid]._state == "hire" then
    return true
  end
  return false
end

function Player:cancelMercenary(tid)
  if self.heroes[tid] and self.heroes[tid]._state == "hire" then
    self.heroes[tid]._state = "idle"
  end
end

function Player:cancelAllMercenary()
  if not self.heroes then
    return
  end
  for i, v in pairs(self.heroes) do
    if v then
      self:cancelMercenary(self, v._tid)
    end
  end
end

function Player:tomd5(heroIds)
  local msg = ed.downmsg.important_data()
  msg._money = self._money
  msg._rmb = self._rmb
  msg._heroes = {}
  for i, id in ipairs(heroIds) do
    local hero = self:getHero(id)
    if hero then
      table.insert(msg._heroes, hero.data)
    end
  end
  table.sort(msg._heroes, function(a, b)
    return a._tid < b._tid
  end)
  local sum = md5.sum(msg:Serialize())
  local upMsg = ed.upmsg.md5_request()
  upMsg._md5 = string.gsub(sum, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
  upMsg._heroids = heroIds
  return upMsg
end

function ed.unitType(id)
  if 100000 < id then
    return "pet"
  elseif id < 100 or 10000 < id then
    return "hero"
  elseif id <= 10000 and 100 < id then
    return "monster"
  end
end

function Player:getHero(id)
  return self.heroes[id]
end

function Player:getAllHero()
  return self.heroes
end

function Player:getHeroCount()
  local heroes = self.heroes
  local hero_count = 0
  for k, v in pairs(heroes) do
    hero_count = hero_count + 1
  end
  return hero_count
end

function Player:getHeroRune(id)
  local hero = self.heroes[id]
  return hero._hero_rune
end

function Player:getHeroRuneArr(id, hero)
  if not id then
    return nil
  end
  local hero = hero or self.heroes[id]
  if not hero then
    return nil
  end
  local hero_rune = hero._hero_rune or {}
  local sun = hero_rune._sun or 0
  local moon = hero_rune._moon or 0
  local star = hero_rune._star or 0
  return {
    sun,
    moon,
    star
  }
end

function Player:addHero(tid)
  local info = ed.lookupDataTable("Unit", nil, tid)
  if self.heroes[tid] then
    print("Got duplicated hero: " .. info.Name)
    return
  end
  local hero = ed.commonmsg.hero()
  hero._tid = tid
  hero._level = 1
  hero._rank = ed.lookupDataTable("Unit", "Initial Rank", tid)
  hero._exp = 0
  hero._gs = 5
  hero._stars = ed.getDataTable("Unit")[tid]["Initial Stars"]
  hero._skill_levels = {}
  hero._items = {}
  hero._state = "idle"
  for i = 1, 6 do
    local item = ed.commonmsg.hero_equip()
    item._index = i
    item._item_id = 0
    item._exp = 0
    table.insert(hero._items, item)
  end
  hero._skill_levels = ed.getInitSkillLevels(tid)
  table.insert(self._heroes, hero)
  table.sort(self._heroes, function(h1, h2)
    return h1._tid < h2._tid
  end)
  self.heroes[tid] = ed.HeroCreate()
  self.heroes[tid]:setup(hero)
  local msg = ed.upmsg.pull_hero_info_req()
  msg._hero_ids = {tid}
  ed.send(msg, "pull_hero_info")
  return
end

function Player:resetHero(ht)
  if ht then
    if not self.heroes[ht._tid] then
      self:addHero(ht._tid)
    end
    local hero = self.heroes[ht._tid]
    if hero then
      hero:setup(ht)
    end
    local star = 0
    for i, h in ipairs(self._heroes) do
      if h._tid == ht._tid then
        star = self._heroes[i]._stars
        self._heroes[i] = ht
      end
    end
  end
end

function Player:resetHeroGs(heroid, newGs)
  if self.heroes == nil then
    return
  end
  if not self.heroes[heroid] then
    return
  end
  self.heroes[heroid]:resetgs(newGs)
  print("setGsSuccess:" .. heroid)
end

function Player:resetHeros()
  if self.heroes == nil then
    self.heroes = {}
  end
  if self._heroes then
    for k, v in pairs(self._heroes) do
      if self.heroes[v._tid] == nil then
        self.heroes[v._tid] = ed.HeroCreate()
      end
      self.heroes[v._tid]:setup(v)
    end
  else
    self.data._heroes = {}
  end
  self:computeHeroBondRedStatus()
end

function Player:deleteHero(tid)
  self.heroes[tid] = nil
  self:delCollect({tid})
  self:deleteHeroInPresent(tid)
end

function Player:deleteHeroInPresent(tid)
  local deleteList = {}
  for i, v in ipairs(self.preset) do
    for hi, hid in ipairs(v.heroes) do
      if hid == tid then
        table.remove(v.heroes, hi)
        break
      end
    end
    if 0 == #v.heroes then
      table.insert(deleteList, i)
    end
  end
  for i, teamIndex in ipairs(deleteList) do
    table.remove(self.preset, teamIndex)
  end
end

function Player:createPackageItem(id, amount, insid, expireTime)
  local category = ed.readequip.value(id, "Category")
  local fragmentTable = ed.getDataTable("fragment")
  local makeid = id
  if category == T("\231\162\142\231\137\135") then
    for k, v in pairs(fragmentTable) do
      if v["Fragment ID"] == id then
        makeid = k
        break
      end
    end
  end
  local key = id
  if insid then
    key = id .. "_" .. insid
  end
  if amount > ed.player:getItemMaxAmount(id) then
    amount = ed.player:getItemMaxAmount(id)
  end
  local item = {
    id = id,
    amount = amount,
    insid = insid,
    expireTime = expireTime,
    makeId = makeid,
    order = tonumber(ed.readequip.value(id, "Order")),
    category = category,
    key = key
  }
  return item
end

function Player:isItemOverfull(v)
  local ca, maxAmount
  if v.id and v.id ~= 0 then
    ca = ed.player.equip_qunty[v.id] or 0
    maxAmount = ed.player:getItemMaxAmount(v.id)
  else
    ca = ed.player:getPoint(v.type)
    maxAmount = ed.player:getItemMaxAmount(nil, v.type)
  end
  local da = ca + v.amount - maxAmount
  return 0 < da
end

function Player:getTableByItemID(id)
  local category = ed.readequip.value(id, "Category")
  local subTag = ed.readequip.value(id, "Sub Tab")
  local tb
  if category == T("\231\162\142\231\137\135") then
    tb = {
      self.packageGoods.fragment.all
    }
  elseif category == T("\231\129\181\233\173\130\231\159\179") then
    tb = {
      self.packageGoods.stone.all
    }
  elseif category == T("\229\144\136\230\136\144\229\147\129") then
    tb = {
      self.packageGoods.equip.all,
      self.packageGoods.equip.Composite
    }
  elseif category == T("\229\141\183\232\189\180") then
    tb = {
      self.packageGoods.equip.all,
      self.packageGoods.equip.Reel
    }
  elseif category == T("\233\155\182\228\187\182") then
    tb = {
      self.packageGoods.equip.all,
      self.packageGoods.equip.Spare
    }
  elseif subTag == "Activity" then
    tb = {
      self.packageGoods.package.all,
      self.packageGoods.package.Activity
    }
  elseif subTag == "Treasure" then
    tb = {
      self.packageGoods.package.all,
      self.packageGoods.package.Treasure
    }
  elseif subTag == "Develop" then
    tb = {
      self.packageGoods.package.all,
      self.packageGoods.package.Develop
    }
  elseif subTag == "Ugc" then
    tb = {
      self.packageGoods.package.all,
      self.packageGoods.package.Ugc
    }
  else
    tb = {
      self.packageGoods.package.all,
      self.packageGoods.package.Normal
    }
  end
  return tb
end

function Player:getExpireTimeByInsid(id, insid)
  local tb = self:getTableByItemID(id)[1]
  for k, v in ipairs(tb) do
    if insid == v.insid then
      return v.expireTime
    end
  end
end

function Player:consumeItemInPackage(id, amount, insid)
  local tbs = self:getTableByItemID(id)
  for i, tb in ipairs(tbs) do
    for k, v in ipairs(tb) do
      if insid then
        if insid == v.insid then
          v.amount = v.amount - amount
          if v.amount < 0 then
            ed.showToast(T("\230\149\176\230\141\174\233\148\153\232\175\175"))
            break
          end
          if v.amount == 0 then
            table.remove(tb, k)
          end
          break
        end
      elseif v.insid == nil and id == v.id then
        v.amount = v.amount - amount
        if v.amount < 0 then
          ed.showToast(T("\230\149\176\230\141\174\233\148\153\232\175\175"))
          break
        end
        if v.amount == 0 then
          table.remove(tb, k)
        end
        break
      end
    end
  end
end

function Player:getNewEquipAmount(id, insid)
  local tbs = self:getTableByItemID(id)
  for i, tb in ipairs(tbs) do
    for k, v in ipairs(tb) do
      if insid then
        if insid == v.insid then
          return v.amount
        end
      elseif v.insid == nil and id == v.id then
        return v.amount
      end
    end
  end
end

function Player:addItemInPackage(id, amount, insid, expireTime)
  local tbs = self:getTableByItemID(id)
  if expireTime and expireTime > ed.getServerTime() then
    for i, tb in ipairs(tbs) do
      local isExist = false
      local pos = 1
      for k, v in ipairs(tb) do
        if v.insid then
          if insid == v.insid then
            v.amount = v.amount + amount
            if v.amount > ed.player:getItemMaxAmount(id) then
              v.amount = ed.player:getItemMaxAmount(id)
              ed.showToast(T("\231\137\169\229\147\129\229\183\178\232\182\133\228\184\138\233\153\144"))
              isExist = true
            end
            break
          elseif expireTime > v.expireTime then
            pos = k + 1
          end
        end
      end
      if isExist == false then
        local item = self:createPackageItem(id, amount, insid, expireTime)
        table.insert(tb, pos, item)
      end
    end
  elseif not expireTime then
    for i, tb in ipairs(tbs) do
      local isExist = false
      local pos = 1
      local index, value
      for k, v in ipairs(tb) do
        if not v.insid and id == v.id then
          v.amount = v.amount + amount
          if v.amount > ed.player:getItemMaxAmount(id) then
            v.amount = ed.player:getItemMaxAmount(id)
            ed.showToast(T("\231\137\169\229\147\129\229\183\178\232\182\133\228\184\138\233\153\144"))
          end
          isExist = true
          index = k
          value = v
          break
        elseif v.insid then
          pos = k + 1
        end
      end
      if isExist then
        table.remove(tb, index)
        table.insert(tb, pos, value)
      else
        local item = self:createPackageItem(id, amount, insid, expireTime)
        table.insert(tb, pos, item)
      end
    end
  end
end

function Player:initPackage()
  if self._timely_items then
    local timelyTb = ed.getDataTable("TimelyItem")
    for k, v in pairs(self._timely_items) do
      local expireTime = v._expire_time
      if expireTime > ed.getServerTime() then
        local id = timelyTb[v._timely_id]["Item ID"]
        self:addItemInPackage(id, v._amount, v._insid, expireTime)
      end
    end
  end
  if self._items then
    for k, item in pairs(self._items) do
      if ed.getDataTable("equip")[item._id] and not ed.getDataTable("equip")[item._id].Invisible then
        self:addItemInPackage(item._id, item._amount)
      end
      self.equip_qunty[item._id] = item._amount
    end
  end
end

function Player:setup(data, nobackup)
  self.initialized = true
  self.data = data
  local _reg_ip_region = data._reg_ip_region or ""
  if _reg_ip_region == "JP" then
    self.freeRMBFirst = true
  end
  self:setrmb(data._diamond)
  self.skillbook_qunty = {}
  self.equip_order = {}
  self.equip_qunty = {}
  self.packageGoods = {
    package = {
      all = {},
      Normal = {},
      Activity = {},
      Treasure = {},
      Develop = {},
      Ugc = {}
    },
    stone = {
      all = {}
    },
    equip = {
      all = {},
      Composite = {},
      Spare = {},
      Reel = {}
    },
    fragment = {
      all = {}
    }
  }
  self:initPackage()
  if self._items then
    for k, v in pairs(self._items) do
      local item = self:getItemAt(k)
      table.insert(self.equip_order, item._id)
      self.equip_qunty[item._id] = item._amount
    end
  else
    self.data._items = {}
  end
  self:resetHeros()
  self:resetPets()
  self:setUUID(data._uuid)
  self:setCreateRoleTime(data._create_time)
  if self._astrolabe_infos then
    ed.heroDetailManager:initAstrolabe(self._astrolabe_infos)
  end
  if self._legend_equips then
    ed.legendEquipMgr.getInstance():initLegendEquip(self._legend_equips)
  end
  self:loadStageStars(self._userstage)
  self.stage_limit = {}
  self.stage_reset_times = {}
  self.stage_limit_back_key = {}
  if self._userstage._elite_daily_record then
    for k, v in pairs(self._userstage._elite_daily_record) do
      local limit = self:getStageLimitAt(k)
      self.stage_limit_back_key[limit._id] = k
      self.stage_limit[limit._id] = limit._count
      self.stage_reset_times[limit._id] = limit._reset
    end
  else
    self._userstage._elite_daily_record = {}
  end
  self:initNativeTimeDiff(self._last_login)
  self:setItemsExpire(data._expired_item_history)
  ed.localnotify.init()
  self.gender = data._gender
  self:initCollect(data._favorite)
  ed.hothero.manager:initHotHero(data._herohot)
  self:initGmSwitch(data._is_gm)
  self:addExp(data._exp - self._exp)
  ed.guide.data:initGuideRecords(data._tutorial)
  ed.passDataMgr:initPassData(data._pass_list)
  if data._sevenday_assist then
    ed.SevenDayManager:setOpen(data._sevenday_assist._is_open == 1)
  end
  if data._preset_lineups then
    ed.presetData.setPreseInitInfo(data._preset_lineups)
  end
  if data._hint_records then
    ed.activityHints:createHints(data._hint_records)
  end
end

function Player:setUUID(uuid)
  self.uuid = uuid
end

function Player:getUUID()
  return self.uuid
end

function Player:setCreateRoleTime(time)
  self.createTime = time
end

function Player:getCreateRoleTime()
  return self.createTime or 0
end

function Player:initCollect(collect)
  self.collectList = collect or {}
end

function Player:getCollectList()
  return self.collectList
end

function Player:addCollect(heroids)
  for _, heroid in ipairs(heroids) do
    table.insert(self.collectList, heroid)
  end
end

function Player:isHeroCollect(hid)
  for _, heroid in ipairs(self.collectList) do
    if hid == heroid then
      return true
    end
  end
  return false
end

function Player:delCollect(heroids)
  local newCollectList = {}
  for _, heroid in ipairs(self.collectList) do
    local del = false
    for _, delid in ipairs(heroids) do
      if delid == heroid then
        del = true
        break
      end
    end
    if not del then
      newCollectList[#newCollectList + 1] = heroid
    end
  end
  self.collectList = newCollectList
end

function Player:getAwakeAttrState(id)
  local arousal = self:getHero(id)._arousal
  local herodetail = {
    STR = arousal._str,
    INT = arousal._int,
    AGI = arousal._agi
  }
  local awakeAttrTbl = {}
  local haa = ed.getDataTable("AwakeAttribute")[id]
  for i = 1, 3 do
    local state = herodetail[haa[string.format("Attribute%d Limit Type", i)]] >= haa[string.format("Attribute%d Limit Value", i)]
    table.insert(awakeAttrTbl, state)
  end
  return awakeAttrTbl
end

function Player:setHeroCrusadeData(data)
  if nil == data then
    return
  end
  local hero = self.heroes[data._tid]
  if nil == hero then
    return
  end
  local heroData = {}
  heroData._hp_perc = data._dyna._hp_perc
  heroData._mp_perc = data._dyna._mp_perc
  heroData._custom_data = data._dyna._custom_data
  hero:setCrusade(heroData)
end

function Player:collectCrusadeData(heros)
  local datas = {}
  for i, hero in pairs(heros) do
    if hero.crusadeData then
      datas[hero._tid] = hero.crusadeData
    end
  end
  return datas
end

function Player:clearAllCrusadeData(setZero)
  if not setZero then
    for i, hero in pairs(self.heroes) do
      hero:setCrusade(nil)
    end
  else
    for i, hero in pairs(self.heroes) do
      if hero.crusadeData then
        hero.crusadeData._hp_perc = 0
        hero.crusadeData._mp_perc = 0
      end
    end
  end
end

function Player:clearSomeCrusadeData(herosId)
  for j, id in pairs(herosId) do
    local hero = self.heroes[id]
    if nil == hero then
      return
    end
    if hero.crusadeData then
      hero.crusadeData._hp_perc = 0
      hero.crusadeData._mp_perc = 0
    end
  end
end

function Player:setHeroThroneTowerData(data)
  if nil == data then
    return
  end
  local hero = self.heroes[data._tid]
  if nil == hero then
    return
  end
  hero:setThroneTower(data._dyna)
end

function Player:collectThroneTowerData(heroes)
  local data = {}
  for i, hero in pairs(heroes) do
    if hero.throneTowerData then
      data[hero._tid] = hero.throneTowerData
    end
  end
  return data
end

function Player:clearAllThroneTowerData(setZero)
  if setZero then
    for i, hero in pairs(self.heroes) do
      hero:setThroneTower({_hp_perc = 0, _mp_perc = 0})
    end
  else
    for i, hero in pairs(self.heroes) do
      hero:setThroneTower(nil)
    end
  end
end

function Player:setHeroAssassinateData(data)
  if nil == data then
    return
  end
  local hero = self.heroes[data._tid]
  if nil == hero then
    return
  end
  local heroData = {}
  heroData._hp_perc = data._dyna._hp_perc
  heroData._mp_perc = data._dyna._mp_perc
  heroData._custom_data = data._dyna._custom_data
  hero:setAssassinate(heroData)
end

function Player:collectAssassinateData(heroes)
  local datas = {}
  for i, hero in pairs(heroes) do
    if hero.assassinateData then
      datas[hero._tid] = hero.assassinateData
    end
  end
  return datas
end

function Player:clearAllAssassinateData()
  for i, hero in pairs(self.heroes) do
    hero:setAssassinate(nil)
  end
end

function Player:setHeroMultistageData(data)
  if nil == data then
    return
  end
  local hero = self.heroes[data._tid]
  if nil == hero then
    return
  end
  local heroData = {}
  heroData._hp_perc = data._dyna._hp_perc
  heroData._mp_perc = data._dyna._mp_perc
  heroData._custom_data = data._dyna._custom_data
  hero:setMultistage(heroData)
end

function Player:clearAllMultistageData()
  for i, hero in pairs(self.heroes) do
    hero:setMultistage(nil)
  end
end

function Player:setHerosBond(data)
  if nil == data then
    return
  end
  for _, hero in ipairs(data._active._heroes) do
    self:resetHero(hero)
  end
  self:updateBondRedStatus(data._active._bond_id, true)
end

function Player:isPlayerHas5StarHero()
  local heroes = self.heroes
  for k, v in pairs(heroes) do
    if v.data._stars == 5 then
      return true
    end
  end
  return false
end

function Player:isPlayerHasCurHero(id)
  local mercenaryHeros = ed.GuildManager.mercenaryHeros
  for index, hero in ipairs(mercenaryHeros) do
    if hero._tid == id then
      return true
    end
  end
  if self.heroes[id] == nil then
    return false
  else
    return true
  end
end

function Player:getHeroAmount()
  local amount = 0
  for k, v in pairs(self.heroes) do
    amount = amount + 1
  end
  return amount
end

function Player:getAwakeHeroAmount()
  local amount = 0
  for k, v in pairs(self.heroes) do
    if v.data._arousal._status == 1 then
      amount = amount + 1
    end
  end
  return amount
end

function Player:releaseHeroes(heroes)
  for i, v in ipairs(heroes or {}) do
    if self.heroes[v] then
      self.heroes[v]._state = "idle"
    end
  end
end

function Player:sendHeroesMining(heroes)
  self:setHeroesState(heroes, "mining")
end

function Player:sendHeroesQuest(heroes)
  self:setHeroesState(heroes, "quest")
end

function Player:setHeroesState(heroes, state)
  for _, hid in ipairs(heroes or {}) do
    self.heroes[hid]._state = state
  end
end

function Player:getHeroAmount()
  local amount = 0
  for k, v in pairs(self.heroes) do
    amount = amount + 1
  end
  return amount
end

function Player:getAwakeHeroAmount()
  local amount = 0
  for k, v in pairs(self.heroes) do
    if v.data._arousal._status == 1 then
      amount = amount + 1
    end
  end
  return amount
end

function Player:isHeroAwake(hid)
  return false
end

function Player:setGlobalConfig(config)
  self.global_config = config or {}
  self:initModuleSwitch()
end

function Player:getAwakeHeros()
  return self.global_config._awake_hero or {}
end

function Player:setSplitableHeroesTag(tag)
  if tag then
    self.hasSplitableHero = true
  end
end

function Player:resetSplitableHeroesTag()
  self.hasSplitableHero = nil
end

function Player:setOriginalSuperTaskEquip(heroId)
  local hero = ed.player.heroes[heroId]
  local item = hero:getItem(1)
  hero.originalSuperTaskEquip = {
    _index = 1,
    _item_id = item._item_id,
    _exp = item._exp
  }
end

function Player:clearSuperTaskEquip()
  local superAwakeTask = ed.player:withHeroSuperTask("working")
  if not superAwakeTask or superAwakeTask._id ~= 1 then
    return
  end
  local ttb = ed.getDataTable("HeroTask")
  local hid = ttb[superAwakeTask._line][1]["Hero ID"]
  local item = self.heroes[hid]:getItem(1)
  local eid = item._item_id
  local hasAwakeEquip = self:isHeroAwakeEquipId(hid, eid)
  if hasAwakeEquip then
    ed.player:setOriginalSuperTaskEquip(hid)
    item._item_id = 0
    item._exp = 0
  end
end

function Player:recoverSuperTaskEquip(hid)
  if not hid then
    local superAwakeTask = self:withHeroSuperTask("working")
    if not superAwakeTask or superAwakeTask._id ~= 1 then
      return
    end
    local ttb = ed.getDataTable("HeroTask")
    hid = ttb[superAwakeTask._line][1]["Hero ID"]
  end
  local msg = ed.upmsg.query_data()
  msg._type = {"hero"}
  msg._query_heroes = {hid}
  ed.send(msg, "query_data")
end

function Player:isMyHero(hero)
  local hid = hero._tid
  local myHero = self.heroes[hid]
  return myHero == hero
end

function Player:equipSort()
  local function sort(a, b)
    local a_o = ed.readequip.value(a, "Order") or 0
    
    local b_o = ed.readequip.value(b, "Order") or 0
    return a_o > b_o
  end
  
  table.sort(self.equip_order, sort)
end

function Player:equipNewSort()
  local list = {}
  self.newAddEquipList = self.newAddEquipList or {}
  for i, v in ipairs(self.newAddEquipList) do
    if self:getEquipAmount(v) > 0 then
      table.insert(list, v)
    end
  end
  self.newAddEquipList = {}
  local isAdd = true
  for _, v1 in ipairs(self.equip_order) do
    isAdd = true
    for _, v2 in ipairs(list) do
      if v1 == v2 then
        isAdd = false
      end
    end
    if isAdd then
      table.insert(list, v1)
    end
  end
  self.equip_order = list
end

function Player:addMeal(meal)
  table.insert(self.meals, meal)
end

function Player:removeMeal(id)
  local list = {}
  for i, v in ipairs(self.meals) do
    if v._id ~= id then
      table.insert(list, v)
    end
  end
  self.meals = list
end

function Player:getMeals()
  return self.meals
end

function Player:setMeals(objs)
  self.meals = objs or {}
end

function Player:initCustomPhoto(data)
  self.customPhoto = self.customPhoto or {}
  if data and data._photo then
    self.customPhoto.photoId = data._photo._photo
    self.customPhoto.frameId = data._photo._frame_id
    self.customPhoto.isOpen = data._open == 1
  end
end

function Player:setCustomPhoto(photoId, frameId, isOpen)
  self.customPhoto = {}
  self.customPhoto.photoId = photoId
  self.customPhoto.frameId = frameId
  self.customPhoto.isOpen = isOpen
end

function Player:getCustomPhoto()
  return self.customPhoto or {}
end

function Player:setCustomPhotoSwitch(switch)
  self.customPhotoSwitch = switch
end

function Player:getCustomPhotoSwitch()
  return self.customPhotoSwitch == 1
end

function Player:initGmSwitch(GMSwitch)
  self.GMSwitch = GMSwitch
end

function Player:isGM()
  return self.GMSwitch == 1
end

function Player:setAntiAddictionData(data)
  self.lastAntiAdditionData = self.antiAdditionData
  self.antiAdditionData = data
end

function Player:getAntiAddictionData()
  return self.antiAdditionData or {}
end

function Player:getLastAntiAddictionData()
  return self.lastAntiAdditionData
end

function Player:resetPets()
  if self.pets == nil then
    self.pets = {}
  end
  if self._pets then
    for k, v in pairs(self._pets) do
      if self.pets[v._id] == nil then
        self.pets[v._id] = ed.PetCreate()
      end
      self.pets[v._id]:setup(v)
    end
  else
    self.data._pets = {}
  end
end

function Player:getPets()
  return self.pets
end

function Player:setPets(newPets)
  self.pets = newPets or {}
end

function Player:getUnEquipedPetsNum()
  local count = 0
  for id, pet in pairs(self.pets) do
    if pet:getCarriedHeroId() == nil then
      count = count + 1
    end
  end
  return count
end

function Player:getPet(id)
  return self.pets[id]
end

function Player:addPet(info)
  if self.pets[info._id] then
    print("Got duplicated pet: " .. info._id)
    return
  end
  self.pets[info._id] = ed.PetCreate()
  self.pets[info._id]:setup(info)
  table.insert(self._pets, info)
end

function Player:deletePet(id)
  self.pets[id] = nil
end

local function getBondInfo(id)
  return ed.getDataTable("HeroBond")[id]
end

local bondsMap

function Player:loadHerosBondList()
  if not bondsMap then
    bondsMap = {}
    local heroBonds = ed.getDataTable("HeroBond")
    for _, bond in pairs(heroBonds) do
      if type(bond) == "table" then
        local id = bond["Hero 1 ID"]
        if not bondsMap[id] then
          bondsMap[id] = {}
        end
        table.insert(bondsMap[id], bond)
        id = bond["Hero 2 ID"]
        if not bondsMap[id] then
          bondsMap[id] = {}
        end
        table.insert(bondsMap[id], bond)
      end
    end
  end
  return bondsMap
end

function Player:getHeroBondsList(tid)
  return self:loadHerosBondList()[tid] or {}
end

function Player:getHeroBondsRedStat(tid)
  if ed.TitanManager.isShieldBond() then
    return false
  end
  local status = self.heroBondsRedStatus[tid]
  if not status then
    return false
  end
  local stat = false
  for bondId, bet in pairs(status) do
    stat = stat or bet
    if stat then
      return true
    end
  end
  return false
end

function Player:checkHeroBondRedStat()
  local stat = false
  for id, _ in pairs(self.heroBondsRedStatus) do
    stat = stat or self:getHeroBondsRedStat(id)
    if stat then
      return true
    end
  end
  return false
end

function Player:getBondRedStat(bondId)
  local bond = getBondInfo(bondId)
  return self.heroBondsRedStatus[bond["Hero 1 ID"]][bondId]
end

function Player:updateBondRedStatus(bondId, isNotify)
  local isRed = not self:isActived(bondId) and self:isCanActive(bondId)
  local bond = getBondInfo(bondId)
  local heroId1 = bond["Hero 1 ID"]
  local heroId2 = bond["Hero 2 ID"]
  if not self.heroBondsRedStatus[heroId1] then
    self.heroBondsRedStatus[heroId1] = {}
  end
  if not self.heroBondsRedStatus[heroId2] then
    self.heroBondsRedStatus[heroId2] = {}
  end
  local oldIsRed = self.heroBondsRedStatus[heroId1][bondId] or false
  self.heroBondsRedStatus[heroId1][bondId] = isRed
  self.heroBondsRedStatus[heroId2][bondId] = isRed
  if isNotify and oldIsRed ~= isRed then
    FireEvent("hero_bond_red_change", {
      bondId = bondId,
      heroId1 = heroId1,
      heroId2 = heroId2
    })
  end
end

function Player:updateHeroBondRedStatus(tid)
  local list = self:getHeroBondsList(tid)
  for _, bond in ipairs(list) do
    self:updateBondRedStatus(bond.ID, true)
  end
end

function Player:computeHeroBondRedStatus()
  local bonds = self:loadHerosBondList()
  for id, list in pairs(bonds) do
    for _, bond in ipairs(list) do
      self:updateBondRedStatus(bond.ID, false)
    end
  end
end

function Player:isCanActive(bondId)
  local bond = getBondInfo(bondId)
  local hero1 = ed.player:getHero(bond["Hero 1 ID"])
  local hero2 = ed.player:getHero(bond["Hero 2 ID"])
  if hero1 and hero2 then
    return hero1._stars >= bond["Hero 1 Star"] and hero2._stars >= bond["Hero 2 Star"]
  end
  return false
end

function Player:isActived(bondId)
  local bond = getBondInfo(bondId)
  local hero = self:getHero(bond["Hero 1 ID"])
  if not hero then
    return false
  end
  local list = hero:getActivedBondIdsList()
  if not list or #list == 0 then
    return false
  end
  for _, value in ipairs(list) do
    if value == bondId then
      return true
    end
  end
  return false
end
