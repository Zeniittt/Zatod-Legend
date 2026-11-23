local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

class.ShardOpenConfig = {level = 70, rank = 7}
class.AstrolabeOpenConfig = {level = 75, rank = 9}

function class.create()
  local self = {}
  setmetatable(self, class)
  self:initData()
  return self
end

function class.isDebug()
  return false
end

function class:initData()
  self.astrolabes = {}
  self.redLights = {}
  ListenEvent("RefreshHeroRed", function(itemid)
    self:refreshRedLight(itemid)
  end)
  ListenEvent("activityCrossDays", function()
    local msg = ed.upmsg.astrolabe_req()
    msg._pull = ed.upmsg.astrolabe_pull()
    ed.send(msg, "astrolabe")
  end)
  self:initHeroToShardId()
end

function class:getHeroEvolveCost(hid)
  local hero = ed.player.heroes[hid]
  local row = ed.getDataTable("HeroStars")[hero._stars + 1] or {}
  local cost = row["Upgrade Price"]
  return cost
end

function class:refreshRedLights()
  local ml = ed.readhero.getMissList()
  for i = 1, #ml do
    if ed.readhero.checkStoneEnough(ml[i]) then
      self.redLights[ml[i]] = true
      FireEvent(ed.guide.eventNames.HERO_CAN_BE_SUMMONED)
    else
      self.redLights[ml[i]] = false
    end
  end
  for _, hero in pairs(ed.player.heroes or {}) do
    if ed.readhero.canEvolve(hero._tid) or ed.readhero.canUpgradeHeroWithId(hero._tid) or self:canShardUnlock(hero._tid) or self:canAstrolabeUnlock(hero._tid) then
      self.redLights[hero._tid] = true
    else
      self.redLights[hero._tid] = false
    end
  end
end

function class:refreshRedLight(itemid)
  local mainButtonCfg = ed.ui.configs.mainButton
  local ButtonType = mainButtonCfg.ButtonType
  local needRefreshRedLight = false
  local hid = itemid
  local haveShardUnlock, hids = false, {}
  if ed.readequip.value(itemid, "Category") == T("\231\129\181\233\173\130\231\159\179") then
    hid = ed.readhero.getMakeid(itemid)
  elseif self:getShardUnlockItems()[itemid] then
    for k, v in pairs(self:getShardUnlockItems()[itemid] or {}) do
      hids[k] = self:canShardUnlock(k)
      haveShardUnlock = haveShardUnlock or v
      hid = k
    end
  end
  local pre = self.redLights[hid]
  if haveShardUnlock then
    for k, v in pairs(hids) do
      needRefreshRedLight = needRefreshRedLight or self.redLights[k] ~= v
      self.redLights[k] = v or ed.readhero.canEvolve(k) or ed.readhero.canUpgradeHeroWithId(k)
    end
  elseif ed.player.heroes[hid] then
    if ed.readhero.canEvolve(hid) or ed.readhero.canUpgradeHeroWithId(hid) or self:canAstrolabeUnlock(hid) then
      self.redLights[hid] = true
    else
      self.redLights[hid] = false
    end
  elseif ed.getDataTable("Unit")[hid] then
    if ed.readhero.checkStoneEnough(hid) then
      self.redLights[hid] = true
      FireEvent(ed.guide.eventNames.HERO_CAN_BE_SUMMONED)
    else
      self.redLights[hid] = false
    end
  end
  if pre ~= self.redLights[hid] then
    needRefreshRedLight = true
  end
  if needRefreshRedLight then
    FireEvent("MainRedTagChange", ButtonType.HERO)
  end
end

function class:getRedLight(hid)
  return self.redLights[hid]
end

function class:getAllRedLight()
  if #self.redLights == 0 then
    self:refreshRedLights()
  end
  for k, v in pairs(self.redLights or {}) do
    if v then
      return true
    end
  end
  return false
end

function class:getSkillLvupAtt(hid, slot)
  local att = {}
  local row = ed.getDataTable("SkillGroup")[hid][slot]
  local gid = row["Skill Group ID"]
  local skill = ed.getDataTable("Skill")[gid][0]
  local index = 1
  
  local function integrationAtt(popupstr, value, multicof)
    local add = value * multicof
    add = math.floor(add * 1000) / 1000
    local element = string.gsub(popupstr, "#", add)
    table.insert(att, element)
  end
  
  while true do
    local field = row["Growth " .. index .. " Field"]
    if field then
      local popupstr = row["Growth " .. index .. " Popup"]
      local value = row["Growth " .. index .. " Value"]
      local multicof = row["Growth " .. index .. " Multiplier"]
      if popupstr then
        integrationAtt(popupstr, value, multicof)
        index = index + 1
      else
        break
      end
    else
      break
    end
  end
  if ed.Unit:unitWithSkill(hid, skill["Awake Richtext Skill Group ID"]) then
    index = 1
    while true do
      local field = row["Awake Growth " .. index .. " Field"]
      if field then
        local popupstr = row["Awake Growth " .. index .. " Popup"]
        local value = row["Awake Growth " .. index .. " Value"]
        local multicof = row["Awake Growth " .. index .. " Multiplier"]
        if popupstr then
          integrationAtt(popupstr, value, multicof)
          index = index + 1
        else
          break
        end
      else
        break
      end
    end
  end
  local skidx = 1
  while true do
    local idx = T("Skill Group ID %s", skidx)
    local skgid = skill[idx]
    if ed.Unit:unitWithSkill(hid, skgid) then
      index = 1
      while true do
        local key = T("Skill %s Growth %s Field", skidx, index)
        local field = row[key]
        if field then
          local popupstr = row[T("Skill %s Growth %s Popup", skidx, index)]
          local value = row[T("Skill %s Growth %s Value", skidx, index)]
          local multicof = row[T("Skill %s Growth %s Multiplier", skidx, index)]
          if popupstr then
            integrationAtt(popupstr, value, multicof)
            index = index + 1
          else
            break
          end
        else
          break
        end
      end
      skidx = skidx + 1
    else
      break
    end
  end
  return att, attChangeDetail
end

function class:dealSkillLevelup(reply)
  local result = reply._result == "success"
  local gs = reply._gs
  local handler, data = ed.getNetReply("skill_level_up")
  if data then
    local id = data.hid
    local order = data.order
    local point = data.point
    for k, v in pairs(order) do
      ed.player:strenHeroSkill(id, k, v)
    end
    if result then
      ed.player.heroes[id]:resetgs(gs)
    end
  end
  if handler then
    handler(result)
  end
  if result and data then
    local point = 0
    for i, v in ipairs(data.order or {}) do
      point = point + v
    end
    ed.record:refreshCommonRecord("skillUpgradeSuccess", point)
  end
end

function class:initAstrolabe(reply)
  self.astrolabes = {}
  for k, v in ipairs(reply) do
    self.astrolabes[v._hero_id] = v
  end
  local key = ed.getRoleKey("initAstrolabeLock")
  if not ed.storage.getBool(key) then
    ed.storage.setValue(key, true)
    for k, v in pairs(self.astrolabes) do
      for kk, vv in pairs(v._lock_index_list or {}) do
        ed.storage.setValue(ed.getRoleKey("astrolabeLock_" .. k .. "_" .. vv), true)
      end
    end
  end
end

function class:checkUnlockAstrolabe(hid)
  self.astrolabes = self.astrolabes or {}
  return self.astrolabes[hid] ~= nil
end

function class:isShowPageAstrolabe(hid, notUpmsg)
  local info = ed.getDataTable("Astrolabe")[hid]
  if info and ed.getTimeByYMDHMS(info["Online Time"]) <= ed.getServerTime() then
    local hero = ed.player:getHero(hid)
    local cfg = ed.heroDetailManager.AstrolabeOpenConfig
    if hero._rank >= cfg.rank and hero._level >= cfg.level and ed.getTimeByYMDHMS(info["Online Time"]) <= ed.getServerTime() and not notUpmsg and not self:checkUnlockAstrolabe(hid) then
      self.unlockAstroID = hid
      local msg = ed.upmsg.astrolabe_req()
      msg._pull = ed.upmsg.astrolabe_pull()
      ed.send(msg, "astrolabe")
    end
    return true
  end
end

function class:handleAstrolabe(reply)
  if reply._pray then
    local heroId = reply._pray._info._hero_id
    self.astrolabes[heroId] = reply._pray._info
    local materials = {}
    for k, v in ipairs(reply._pray._items or {}) do
      table.insert(materials, {
        id = v._id,
        amount = v._amount,
        type = "item"
      })
    end
    ed.player.heroes[heroId]._astrolabe = reply._pray._hero_astro
    ed.heroDetailManager.consumeMaterials(materials)
    ed.player:addMoney(-reply._pray._gold)
    ed.player.heroes[heroId]:resetgs(reply._pray._gs)
    FireEvent("AstrolabePray", reply._pray)
  elseif reply._confirm then
    self.astrolabes[reply._confirm._hero._tid]._replace_stars = nil
    ed.player:resetHero(reply._confirm._hero)
    FireEvent("AstrolabeConfirm", reply._confirm)
  elseif reply._clear_cache then
    local heroId = reply._clear_cache._info._hero_id
    self.astrolabes[heroId] = reply._clear_cache._info
    FireEvent("AstrolabeConfirm", reply._confirm)
  elseif reply._buy_times then
    self.astrolabes[reply._buy_times._info._hero_id] = reply._buy_times._info
    ed.player:setrmb({
      _free_diamond = reply._buy_times._left_diamond
    })
    FireEvent("AstrolabeBuyTime", reply._buy_times)
  elseif reply._buy_stone then
    ed.player:addRewards(reply._buy_stone._rewards)
    ed.UITool.showRewardsFromServer(reply._buy_stone._rewards)
    ed.player:setrmb({
      _free_diamond = reply._buy_stone._left_diamond
    })
    FireEvent("AstrolabeBuyStone", reply._buy_stone)
  elseif reply._unlock then
    if self.unlockAstroID then
      self.astrolabes[self.unlockAstroID] = reply._unlock._info
      ed.player.heroes[self.unlockAstroID]._astrolabe = reply._unlock._hero_astro
      ed.player.heroes[self.unlockAstroID]:resetgs(reply._unlock._gs)
      FireEvent("RefreshHeroRed", self.unlockAstroID)
    end
    FireEvent("AstrolabeUnlock")
  elseif reply._pull then
    self.astrolabes = self.astrolabes or {}
    for k, v in pairs(reply._pull._infos or {}) do
      self.astrolabes[v._hero_id] = v
    end
    FireEvent("AstrolabeConfirm", reply._confirm)
    if self.unlockAstroID then
      FireEvent("RefreshHeroRed", self.unlockAstroID)
      self.unlockAstroID = nil
    end
  end
end

function class:getDisPlayAwakeStageBonus(id, awakeStageBonus)
  local attrib_trans = {
    STR = {HP = 18, ARM = 0.15},
    INT = {AP = 2.4, MR = 0.1},
    AGI = {
      AD = 0.4,
      CRIT = 0.4,
      ARM = 0.08
    }
  }
  local attrs = {}
  local awakeStageBonus = awakeStageBonus or {}
  local level = awakeStageBonus.level
  local maxLevel = awakeStageBonus.maxLevel
  local groupId = awakeStageBonus.groupId
  if groupId and level and maxLevel then
    local tb = ed.getDataTable("LevelAttributes")[groupId][id]
    if not tb then
      return attrs
    end
    local paragonLevelCfg = ed.getDataTable("ParagonLevel")[groupId]
    local haveWeight = 0
    local totalWeight = 0
    for paragonLevel, levelCfg in ipairs(paragonLevelCfg or {}) do
      if paragonLevel <= level then
        haveWeight = haveWeight + levelCfg.Weight
      end
      totalWeight = totalWeight + levelCfg.Weight
    end
    for attrName, attrNum in pairs(tb or {}) do
      if totalWeight ~= 0 and 0 < attrNum then
        attrs[attrName] = attrNum * haveWeight / totalWeight
      end
    end
    for paragonLevel, paragonLevelCfg in ipairs(paragonLevelCfg or {}) do
      if paragonLevel > level then
        break
      end
      local extraAttrIDList = paragonLevelCfg.ExtraAttributes
      for index, extAttrID in ipairs(extraAttrIDList or {}) do
        local extAttrCfg = ed.getDataTable("ExtraAttributes")[extAttrID]
        if id == extAttrCfg.UnitID then
          for attrName, attrNum in pairs(extAttrCfg) do
            if attrName ~= "UnitID" and attrName ~= "ID" and 0 < attrNum then
              attrs[attrName] = (attrs[attrName] or 0) + attrNum
            end
          end
        end
      end
    end
  end
  for mainAttr, group in pairs(attrib_trans) do
    local unitMainAttrib = ed.getDataTable("Unit")[id]["Main Attrib"]
    for subAttr, ratio in pairs(group) do
      attrs[subAttr] = attrs[subAttr] + attrs[mainAttr] * ratio
    end
    if unitMainAttrib == mainAttr then
      attrs.AD = attrs.AD + attrs[mainAttr]
    end
  end
  return attrs
end

function class.getHeroIsShard(hid)
  local shardId = ed.heroDetailManager.shardList[hid] and (ed.heroDetailManager.shardList[hid][1] or 0) or 0
  if 0 < shardId and ed.heroDetailManager:isShardOnlineTime(shardId) then
    return ed.getDataTable("ShardToHero")[shardId]
  end
  return false
end

function class.getHeroShardIsOpen(hero)
  local info = ed.copyProto(hero)
  if info._shard and info._shard._level > 0 then
    return true
  end
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Shard")
  if cpl then
    return false, cpl, false
  end
  if ed.heroDetailManager.getHeroIsShard(info._tid) then
    local cfg = ed.heroDetailManager.ShardOpenConfig
    local rank_info = ed.heroDetailManager.resConfig.equip_rank_info[cfg.rank]
    if info._rank < cfg.rank then
      return false, T("\232\139\177\233\155\132\231\173\137\231\186\167%d\231\186\167\239\188\140%s\229\147\129\233\152\182\228\187\165\228\184\138\232\167\163\233\148\129", cfg.level, rank_info.name), true
    end
    if info._level < cfg.level then
      return false, T("\232\139\177\233\155\132\231\173\137\231\186\167%d\231\186\167\239\188\140%s\229\147\129\233\152\182\228\187\165\228\184\138\232\167\163\233\148\129", cfg.level, rank_info.name), true
    end
    return true
  end
  return false
end

function class:initHeroToShardId()
  local shardList = {}
  local tb = ed.getDataTable("ShardToHero")
  for k, v in pairs(tb) do
    if type(k) == "number" and 0 < k then
      local hid = v["Hero ID"]
      if not shardList[hid] then
        shardList[hid] = {}
      end
      table.insert(shardList[hid], k)
    end
  end
  self.shardList = shardList
end

function class:getShardStateByID(hid)
  if self.getHeroIsShard(hid) then
    local hero = ed.player:getHero(hid)
    if hero and hero._shard and hero._shard._level > 0 then
      if self:canShardLevelUp(hid) then
        return "CanLevelUp"
      else
        return "Equiped"
      end
    elseif hero and hero._rank >= self.ShardOpenConfig.rank and hero._level >= self.ShardOpenConfig.level then
      if self:canShardLevelUp(hid) then
        return "CanActive"
      else
        return "notActive"
      end
    else
      return "Locked"
    end
  else
    return "UnConfig"
  end
end

function class:canShardUnlock(hid)
  if self.getHeroIsShard(hid) then
    local hero = ed.player:getHero(hid)
    if hero and (hero._shard and hero._shard._level == 0 or not hero._shard) and hero._rank >= self.ShardOpenConfig.rank and hero._level >= self.ShardOpenConfig.level and self:canShardLevelUp(hid) then
      return true
    end
  end
  return false
end

function class:canAstrolabeUnlock(hid)
  if self:checkUnlockAstrolabe(hid) then
    if self.astrolabes[hid]._unlock and self.astrolabes[hid]._unlock == 1 then
      return false
    end
    local hero = ed.player:getHero(hid)
    local info = ed.getDataTable("Astrolabe")[hid]
    local cfg = ed.heroDetailManager.AstrolabeOpenConfig
    if hero and hero._rank >= cfg.rank and hero._level >= cfg.level and ed.getTimeByYMDHMS(info["Online Time"]) <= ed.getServerTime() then
      return true
    end
  end
  return false
end

function class:setAstrolabeUnlockStatus(hid, isUnlock)
  if self:checkUnlockAstrolabe(hid) then
    if self.astrolabes[hid]._unlock == isUnlock then
      return
    end
    self.astrolabes[hid]._unlock = isUnlock
    FireEvent("RefreshHeroRed", hid)
  end
end

function class:isShardOnlineTime(shardId)
  local tb = ed.getDataTable("ShardToHero")
  if tb[shardId] then
    local timeStr = tb[shardId]["Online Time"]
    local onlineTime = ed.getTimeByYMDHMS(timeStr)
    if onlineTime <= ed.getServerTime() then
      return true
    end
  end
  return false
end

function class:canShardLevelUp(hid)
  local hero = ed.player:getHero(hid)
  local shardId, shardLv
  if hero and hero._shard and hero._shard._id then
    shardId = hero._shard._id or 0
    shardLv = hero._shard._level or 0
  else
    shardId = self.shardList[hid] and (self.shardList[hid][1] or 0) or 0
    shardLv = 0
  end
  if 0 < shardId and self:isShardOnlineTime(shardId) then
    local cfg = ed.getDataTable("ShardAttribs")[shardId][shardLv + 1 or 1] or ed.getDataTable("ShardAttribs")[shardId][1]
    if ed.player._money < cfg.Gold then
      return false, T("\233\135\145\229\184\129\228\184\141\232\182\179")
    end
    local num = ed.player.equip_qunty[cfg["Item ID"]] or 0
    if num < cfg["Item Amount"] then
      return false, string.format(T("%s\230\182\147\229\182\136\229\134\187"), ed.getEquipNameWithId(cfg["Item ID"]))
    end
    if not ed.getDataTable("ShardAttribs")[shardId][shardLv + 1] then
      return false
    end
    return true
  end
  return false
end

function class:getShardUnlockItems()
  if not self.shardUnlockItems then
    local items = {}
    for k, v in pairs(ed.getDataTable("ShardAttribs")) do
      local heroId = ed.getDataTable("ShardToHero")[v[1]["Shard ID"]]["Hero ID"]
      items[v[1]["Item ID"]] = items[v[1]["Item ID"]] or {}
      if ed.player.heroes[heroId] and not items[v[1]["Item ID"]][heroId] then
        items[v[1]["Item ID"]][heroId] = true
      end
    end
    self.shardUnlockItems = items
  end
  return self.shardUnlockItems
end

function class:getLegendEquipUnlock(hid)
  local hero = ed.player:getHero(hid)
  if not hero then
    return false
  end
  local unlockConditions = ed.getDataTable("LegendEquipForgeParam")["Unlock Conditions"]
  local unlockLevel = unlockConditions["Param Content 1"]
  local unlockRank = unlockConditions["Param Content 2"]
  return unlockLevel <= hero._level and unlockRank <= hero._rank
end

function class:getUnlockLevel()
  local unlockConditions = ed.getDataTable("LegendEquipForgeParam")["Unlock Conditions"]
  return unlockConditions["Param Content 1"]
end

function class.checkMaterials(items)
  for k, v in ipairs(items or {}) do
    if v.type == "gold" or v.type == "Gold" then
      if ed.player._money < v.amount then
        return false
      end
    elseif v.type == "diamond" or v.type == "Diamond" then
      if ed.player._rmb < v.amount then
        return false
      end
    elseif (v.type == "item" or v.type == "Item") and ed.player:getEquipAmount(v.id) < v.amount then
      return false
    end
  end
  return true
end

function class.consumeMaterials(items)
  for k, v in ipairs(items or {}) do
    if v.type == "gold" or v.type == "Gold" then
      ed.player:addMoney(-v.amount)
    elseif v.type == "diamond" or v.type == "Diamond" then
      ed.player:subRmb(v.amount)
    elseif v.type == "item" or v.type == "Item" then
      ed.player:consumeEquip(v.id, v.amount)
    end
  end
end

function class.getSkillsInfo(id)
  local skills = {}
  local skillTb = ed.getDataTable("Skill")
  local skillGroups = ed.getSkillExpBase(id)
  for k, v in ipairs(skillGroups) do
    local tbInfo = skillTb[v["Skill Group ID"]][0]
    local skill = {
      name = v["Display Name"],
      skillName = v["Skill Name"],
      buffId = tbInfo["Buff ID"],
      res = v.Icon,
      rank = v.Unlock,
      groupID = v["Skill Group ID"],
      group = v,
      slot = v.Slot,
      description = tbInfo.Description or "",
      fullDescription = tbInfo["Full Description"],
      skillTags = v["Skill Tags"]
    }
    table.insert(skills, skill)
  end
  table.sort(skills, function(a, b)
    return a.slot < b.slot
  end)
  return skills
end

function class.getSkillAutoText(id, slot, level, isFull)
  local skillGroupItem = ed.getDataTable("SkillGroup")[id][slot]
  local skillGroupId = ed.getSkillExpBase(id)[slot]["Skill Group ID"]
  local skill = ed.getDataTable("Skill")[skillGroupId][0]
  local buffTb = ed.getDataTable("Buff")
  local dictTb = ed.getDataTable("Dictionary")
  local str = isFull and skill["Full Description"] or skill.Description
  local handlerName = isFull and "detail" or "simple"
  local tmpStr = str
  local args = {}
  
  local function insertTrueValue(value, paramName)
    for i = 1, 5 do
      if skillGroupItem["Growth " .. i .. " Field"] and skillGroupItem["Growth " .. i .. " Field"] == paramName then
        value = value + skillGroupItem["Growth " .. i .. " Value"] * (level - 1)
      end
    end
    value = math.abs(value)
    table.insert(args, value)
  end
  
  while true do
    local pos1, pos2 = string.find(tmpStr, "%%Skill&.-%%")
    local pos3, pos4 = string.find(tmpStr, "%%Buff&.-%%")
    local pos1 = pos1 or 9999999
    local pos3 = pos3 or 9999999
    if pos1 == 9999999 and pos3 == 9999999 then
      break
    elseif pos1 < pos3 then
      local paramName = string.sub(tmpStr, pos1 + 7, pos2 - 1)
      insertTrueValue(skill[paramName], paramName)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    else
      local paramName = string.sub(tmpStr, pos3 + 6, pos4 - 1)
      insertTrueValue(buffTb[skill["Buff ID"]][paramName], paramName)
      tmpStr = string.sub(tmpStr, pos4 + 1)
    end
  end
  str = string.gsub(str, "%%Skill&.-%%", "%%s")
  str = string.gsub(str, "%%Buff&.-%%", "%%s")
  if 0 < #args then
    str = string.format(str, unpack(args))
  end
  tmpStr = str
  args = {}
  while true do
    local pos1, pos2 = string.find(tmpStr, "<#%d+#.-#>")
    if not pos1 then
      break
    else
      local paramName = string.sub(tmpStr, pos1, pos2)
      local pos3, pos4 = string.find(paramName, "%d+")
      local paramIndex = string.sub(paramName, pos3, pos4)
      local paramValue = string.sub(paramName, pos4 + 2, -3)
      local value = string.format("<lable color=ccc3(255,251,231) clickhandler=%s data=%d>%s</lable>", handlerName, tonumber(paramIndex), paramValue)
      table.insert(args, value)
      tmpStr = string.sub(tmpStr, pos2 + 1)
    end
  end
  str = string.gsub(str, "<#%d+#.-#>", "%%s")
  if 0 < #args then
    str = string.format(str, unpack(args))
  end
  str = string.gsub(str, "#p#", "%%")
  return str
end

ed.heroDetailManager = class.getInstance()
return class
