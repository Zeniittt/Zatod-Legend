local class = newclass("g")
ed.readhero = class
local OFFSET_SPECIAL_ID = 1000000
local OFFSET_FREE_HERO_ID = OFFSET_SPECIAL_ID * 1

function convertToOriginID(tid)
  if tid > OFFSET_SPECIAL_ID then
    return tid % OFFSET_SPECIAL_ID
  else
    return tid
  end
end

class.convertToOriginID = convertToOriginID

function convertToFreeHeroID(tid)
  return tid + OFFSET_FREE_HERO_ID
end

class.convertToOriginID = convertToOriginID

function isSpecialFreeHeroID(tid)
  return tid > OFFSET_FREE_HERO_ID
end

class.convertToOriginID = convertToOriginID
local maxStar = 5

local function isHeroOpen(id, serverTime)
  if type(id) ~= "number" then
    return false
  end
  local banList = (ed.player.global_config._module_switch or {})._ban_hero or {}
  if ed.isElementInTable(id, banList) then
    return false
  end
  local timeStr = ed.getDataTable("Unit")[id]["Online Time"]
  if timeStr then
    local onlineTime = ed.getTimeByYMDHMS(timeStr)
    if onlineTime > (serverTime or ed.getServerTime()) then
      return false
    end
  else
    return false
  end
  return true
end

class.isHeroOpen = isHeroOpen

local function checkOccupy(hid)
  return ed.player.heroes[hid]._state == "hire"
end

class.checkOccupy = checkOccupy

local function getEquipIdFromTb(hid, slot, rank)
  local rank = rank or ed.player.heroes[hid]._rank
  local slotStr = string.format("Equip%d ID", slot)
  return ed.getDataTable("hero_equip")[hid][rank][slotStr]
end

local function getHero(hid)
  return ed.player.heroes[hid]
end

class.getHero = getHero

local function getHeroRank(hid)
  local hero = class.getHero(hid)
  if hero then
    return hero._rank
  end
end

class.getHeroRank = getHeroRank
ed.getHeroRank = getHeroRank

local function getHeroAttByHero(hero)
  if nil == hero then
    return
  end
  local attInfo = {}
  local unit = ed.UnitCreate(hero)
  local att = unit.attribs
  local oriAtt = unit.orig_attribs or {}
  for k, v in pairs(att) do
    if v ~= 0 then
      local base = math.floor((oriAtt[k] or 0) + 0.5)
      local add = math.floor(v + 0.5) - base
      attInfo[k] = {
        base = base,
        add = add,
        all = v
      }
    end
  end
  local waratt = unit.warattribs
  return attInfo, waratt
end

class.getHeroAttByHero = getHeroAttByHero

function class:addDotUnitPicInfo(id)
  local icon
  if not id then
    icon = CCSprite:create()
    icon:setContentSize(ed.DGSizeMake(104, 104))
    icon:setCascadeOpacityEnabled(true)
    local cm = CCLayerColor:create(ccc4(0, 0, 0, 255))
    cm:setContentSize(ed.DGSizeMake(104, 104))
    cm:setCascadeOpacityEnabled(true)
    icon:addChild(cm)
    local cm = CCSprite:create()
    cm:setContentSize(ed.DGSizeMake(104, 104))
    cm:setColor(ccc3(0, 0, 0))
    cm:setPosition(ed.getCenterPos(icon))
    icon:addChild(cm)
    local qm = ed.createSprite("UI/alpha/1080P/toparena/toparena_invisible.png")
    qm:setPosition(ed.getCenterPos(icon))
    icon:addChild(qm)
  else
    local portrait_res = ed.getSoloUnitPortrait(id)
    portrait_res = portrait_res or "UI/alpha/1080P/toparena/toparena_invisible.png"
    icon = ed.createSprite(portrait_res)
  end
  icon:setCascadeOpacityEnabled(true)
  return icon
end

function class:addChessPictureInfo(id)
  local icon
  if not id then
    icon = CCSprite:create()
    icon:setContentSize(ed.DGSizeMake(104, 104))
    icon:setCascadeOpacityEnabled(true)
    local cm = CCLayerColor:create(ccc4(0, 0, 0, 255))
    cm:setContentSize(ed.DGSizeMake(104, 104))
    cm:setCascadeOpacityEnabled(true)
    icon:addChild(cm)
    local cm = CCSprite:create()
    cm:setContentSize(ed.DGSizeMake(104, 104))
    cm:setColor(ccc3(0, 0, 0))
    cm:setPosition(ed.getCenterPos(icon))
    icon:addChild(cm)
    local qm = ed.createSprite("UI/alpha/1080P/toparena/toparena_invisible.png")
    qm:setPosition(ed.getCenterPos(icon))
    icon:addChild(qm)
  else
    local portrait_res = ed.getChessUnitPortrait(id)
    portrait_res = portrait_res or "UI/alpha/1080P/toparena/toparena_invisible.png"
    icon = ed.createSprite(portrait_res)
  end
  icon:setCascadeOpacityEnabled(true)
  return icon
end

function class.createSoloUnitSkillIcon(hid, slot)
  local sgt = ed.getDataTable("SoloSkillGroup")[hid]
  local res = sgt[slot].Icon
  local fres = "UI/alpha/1080P/common/frame/equip_frame_white.png"
  local icon = ed.createSprite(res)
  local bg = ed.createSprite(fres)
  bg:setPosition(ccp(34, 35))
  icon:addChild(bg)
  icon:setCascadeOpacityEnabled(true)
  return icon, bg
end

local function createChessSkillIcon(hid, slot)
  local sgt = ed.getDataTable("ChessSkillGroup")[hid]
  local res = sgt[slot].none.Icon
  local fres = "UI/alpha/1080P/common/frame/equip_frame_white.png"
  local icon = ed.createSprite(res)
  local bg = ed.createSprite(fres)
  bg:setPosition(ccp(34, 35))
  icon:addChild(bg)
  icon:setCascadeOpacityEnabled(true)
  return icon, bg
end

class.createChessSkillIcon = createChessSkillIcon

function class:addPetInfo(petInfo)
  if not petInfo and self.info.summary and self.info.summary._pet then
    petInfo = self.info.summary._pet
  end
  if not petInfo then
    return
  end
  local typeid = petInfo._type_id
  local imagePetMark = ed.PetManager:createPetMark(typeid)
  imagePetMark:setScale(0.8)
  if imagePetMark then
    self.icon:addChild(imagePetMark)
    local contentSize = self.icon:getContentSize()
    imagePetMark:setPosition(ccp(7, contentSize.height - 9))
  end
end

function class.getSoloActor(unit_id, action_name, action_loop)
  local unit_row = ed.getDataTable("SoloUnit")[unit_id]
  local cha_name = unit_row.Puppet
  local puppet_id = unit_row.Puppet
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local actor = ed.createFcaActor(info.Resource, 1)
  local comps = info["Change Components"]
  if comps then
    for i = 1, #comps, 2 do
      actor:setComponent(comps[i], comps[i + 1])
    end
  end
  local usePlists = info.Plist
  local elements = info.Element
  if usePlists and elements then
    local SourcePositions = info["Source Position"]
    local PositionTypes = info["Position Type"]
    local EmissionRates = info["Emission Rate"]
    local enumPositionTypes = {
      Free = kCCPositionTypeFree,
      Relative = kCCPositionTypeRelative,
      Grouped = kCCPositionTypeGrouped
    }
    for i = 1, #usePlists do
      local particle = CCParticleSystemQuad:create("UI/particle/" .. usePlists[i] .. ".plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      local element = elements[i]
      actor:addNodeToComponent(particle, element, 1, t, true, true)
      if #SourcePositions ~= 0 and #PositionTypes ~= 0 and #EmissionRates ~= 0 then
        local px, py = tonumber(SourcePositions[i * 2 - 1]), tonumber(SourcePositions[i * 2])
        particle:setSourcePosition(ccp(px, py))
        particle:setPositionType(enumPositionTypes[PositionTypes[i]])
        local emissionRate = tonumber(EmissionRates[i])
        particle:setEmissionRate(emissionRate)
      end
    end
  end
  actor:setAction(action_name or "Idle")
  if action_loop == nil then
    action_loop = true
  end
  actor:setLoop(action_loop)
  return actor, cha_name
end

local function getChessActor(unit_id, action_name, action_loop)
  local unit_row = ed.getDataTable("ChessUnit")[unit_id]
  local cha_name = unit_row.Puppet
  local puppet_id = unit_row.Puppet
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local actor = ed.createFcaActor(info.Resource, 1)
  local comps = info["Change Components"]
  if comps then
    for i = 1, #comps, 2 do
      actor:setComponent(comps[i], comps[i + 1])
    end
  end
  local usePlists = info.Plist
  local elements = info.Element
  if usePlists and elements then
    local SourcePositions = info["Source Position"]
    local PositionTypes = info["Position Type"]
    local EmissionRates = info["Emission Rate"]
    local enumPositionTypes = {
      Free = kCCPositionTypeFree,
      Relative = kCCPositionTypeRelative,
      Grouped = kCCPositionTypeGrouped
    }
    for i = 1, #usePlists do
      local particle = CCParticleSystemQuad:create("UI/particle/" .. usePlists[i] .. ".plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      local element = elements[i]
      actor:addNodeToComponent(particle, element, 1, t, true, true)
      if #SourcePositions ~= 0 and #PositionTypes ~= 0 and #EmissionRates ~= 0 then
        local px, py = tonumber(SourcePositions[i * 2 - 1]), tonumber(SourcePositions[i * 2])
        particle:setSourcePosition(ccp(px, py))
        particle:setPositionType(enumPositionTypes[PositionTypes[i]])
        local emissionRate = tonumber(EmissionRates[i])
        particle:setEmissionRate(emissionRate)
      end
    end
  end
  actor:setAction(action_name or "Idle")
  if action_loop == nil then
    action_loop = true
  end
  actor:setLoop(action_loop)
  return actor, cha_name
end

class.getChessActor = getChessActor

function class.createChessIcon(info)
  local obj = {}
  setmetatable(obj, class.mt)
  info = info or {}
  obj.info = info
  obj.icon = obj:addChessPictureInfo(info.id)
  info.stars = ed.getChessUnitStar(info.id)
  local initHeroId = math.floor(info.id / 10) * 10 + 1
  local price = ed.getDataTable("ChessUnit")[initHeroId]["Buy Price"]
  info.id = initHeroId
  local RankMap = {
    price_1 = 1,
    price_2 = 2,
    price_3 = 4,
    price_4 = 7,
    price_5 = 12
  }
  info.rank = RankMap["price_" .. price]
  if info.isAIS or info.isNoLevelStar then
    info.level = false
    info.stars = false
  end
  if obj.icon ~= nil then
    obj:addFrameInfo(info.rank, info.runeState, info.runeWords, info.mealMode, true)
    obj:addStarsInfo(info.stars, info.tempStar)
  end
  return obj
end

function class.createSoloUnitIcon(info)
  local obj = {}
  setmetatable(obj, class.mt)
  info = info or {}
  obj.info = info
  obj.icon = obj:addDotUnitPicInfo(info.id)
  info.stars = false
  if obj.icon ~= nil then
    obj:addFrameInfo(12, nil, nil, nil, true)
  end
  return obj
end

local function getHeroAtt(hid)
  local hero = getHero(hid)
  return getHeroAttByHero(hero)
end

class.getHeroAtt = getHeroAtt

local function createIconByServer(hero)
  local icon = ed.readhero.createIcon({
    id = hero._tid,
    rank = hero._rank,
    level = hero._level,
    stars = hero._stars,
    state = hero._state,
    fashion_id = hero._fashion,
    shard = hero._shard,
    pet = hero._pet,
    legendEquip = hero._legend_equip and hero._legend_equip._equip,
    summary = hero
  })
  return icon
end

class.createIconByServer = createIconByServer

local function getHeroInitStars(hid)
  local row = ed.getDataTable("Unit")[hid] or {}
  local stars = row["Initial Stars"] or 0
  return stars
end

class.getHeroInitStars = getHeroInitStars

local function getHeroEquipgs(hid)
  local hero = getHero(hid)
  local equips = hero._items
  local gs = 0
  for i = 1, #equips do
    local equip = equips[i]
    local slot = equip._index
    local id = equip._item_id
    local row = ed.getDataTable("equip")[id]
    if row then
      gs = gs + (row["+GS"] or 0) * ed.readequip.getEquipLevel(hid, slot)
    end
  end
  return gs
end

class.getHeroEquipgs = getHeroEquipgs

local function getHeroEquiphp(hid)
  local hero = getHero(hid)
  local equips = hero._items
  local hp = 0
  local ratio = ed.parameter.stren_health_ratio
  for i = 1, #equips do
    local equip = equips[i]
    local slot = equip._index
    local id = equip._item_id
    local row = ed.getDataTable("equip")[id]
    local level = ed.readequip.getEquipLevel(hid, slot)
    if row then
      local sa = row["+STR"]
      local ha = row["+HP"]
      hp = hp + ratio * sa * level + ha * level
    end
  end
  return hp
end

class.getHeroEquiphp = getHeroEquiphp

local function getHeroUpgradeInfo(hid)
  local hero = ed.readhero.getHero(hid)
  local unit = ed.UnitCreate(hero)
  local gsAdded = ed.readhero.getHeroEquipgs(hid)
  local hpAdded = ed.readhero.getHeroEquiphp(hid)
  gsAdded = math.floor(gsAdded)
  hpAdded = math.floor(hpAdded)
  local rank = hero._rank
  local gs = hero._gs - gsAdded
  local hp = unit.attribs.HP - hpAdded
  gs = math.floor(gs)
  hp = math.floor(hp)
  return {
    rank = rank,
    gs = gs,
    hp = hp,
    gsAdded = 0,
    hpAdded = 0,
    unit = unit
  }
end

class.getHeroUpgradeInfo = getHeroUpgradeInfo

local function getGrowthByHero(hero, star)
  if nil == hero then
    return {}
  end
  if not hero then
    return {}
  end
  local row = ed.getDataTable("Unit")[hero._tid]
  if not star then
    star = hero._stars
  elseif star < 0 then
    star = hero._stars + star
  end
  if star <= 0 then
    return {}
  end
  local growth = {}
  local keys = {
    STR = "+STR",
    AGI = "+AGI",
    INT = "+INT"
  }
  for k, v in pairs(keys) do
    v = v .. (star or 1)
    growth[k] = string.format("%.01f", row[v])
  end
  return growth
end

class.getGrowthByHero = getGrowthByHero

local function getGrowth(hid, star)
  local hero = ed.player.heroes[hid]
  return getGrowthByHero(hero, star)
end

class.getGrowth = getGrowth

function class.getGrowthRatioByHero(hero, param)
  local growthRatio = {}
  if param then
    hero = class.copyHero(hero)
    for key, value in pairs(param) do
      hero[key] = value
    end
  end
  local unit = ed.UnitCreate(hero)
  local attribs = unit.attribs
  growthRatio["+STR%"] = attribs["+STR%"] or 0
  growthRatio["+INT%"] = attribs["+INT%"] or 0
  growthRatio["+AGI%"] = attribs["+AGI%"] or 0
  return growthRatio
end

function class.copyHero(copyHero)
  local hero = ed.copyProto(copyHero.data)
  local newHero = ed.HeroCreate()
  newHero:setup(hero)
  return newHero
end

local function addMonsterBossInfo(self)
  local tag = ed.createSprite("UI/alpha/1080P/campaign/campaign_detail_boss.png")
  tag:setPosition(ccp(65, 68))
  self.icon:addChild(tag, 3)
end

class.addMonsterBossInfo = addMonsterBossInfo

local function addMonsterHpInfo(self, info)
  if nil == info then
    return
  end
  local icon = self.icon
  if nil ~= info.hp then
    local hpNode = CCNode:create()
    local size = icon:getContentSize()
    if info.hp <= 0 then
      local die = ed.createttf(T("\229\183\178\233\152\181\228\186\161"), 21)
      die:limitWidthByScale(size.width * 0.9)
      ed.setLabelColor(die, ed.toccc3(16741231))
      ed.setLabelStroke(die, ed.toccc3(0), 2)
      die:setPosition(ccp(size.width / 2, size.height - 10))
      hpNode:addChild(die, 10)
      local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
      shade:setContentSize(size)
      hpNode:addChild(shade)
    else
      local hpbg = ed.createSprite("UI/alpha/1080P/common/guildraid_stagedetail_enemy_hp_bg.png")
      local hp = ed.createSprite("UI/alpha/1080P/common/guildraid_stagedetail_enemy_hp.png")
      hpbg:setAnchorPoint(ccp(0, 0.5))
      hp:setAnchorPoint(ccp(0, 0.5))
      local pos = ccp((size.width - hpbg:getContentSize().width) / 2, size.height - 10)
      hpbg:setPosition(pos)
      hp:setPosition(pos)
      hpNode:addChild(hpbg)
      hpNode:addChild(hp)
      local pecent = info.hp / 10000
      hp:setScaleX(pecent)
      local textLabel = ed.createLabelTTF(string.format("%.1d%%", pecent * 100), 16)
      textLabel:setAnchorPoint(ccp(0.5, 0.5))
      ed.setLabelStroke(textLabel, ed.toccc3(2565412), 1)
      textLabel:setPosition(ccp(size.width / 2, size.height - 10))
      hpNode:addChild(textLabel)
      self.hpLabel = textLabel
    end
    icon:addChild(hpNode)
    self.hpNode = hpNode
  end
end

class.addMonsterHpInfo = addMonsterHpInfo
local arenaTeamLabelConfig = {
  [1] = {
    color = ed.toccc3(16775585),
    strokeColor = ed.toccc3(13398038),
    colorStr = "ccc3(255,249,161)",
    strokeColorStr = "topArenaTeamStrokeColor1"
  },
  [2] = {
    color = ed.toccc3(11270134),
    strokeColor = ed.toccc3(3890862),
    colorStr = "ccc3(171,247,246)",
    strokeColorStr = "topArenaTeamStrokeColor2"
  },
  [3] = {
    color = ed.toccc3(16766650),
    strokeColor = ed.toccc3(12074795),
    colorStr = "ccc3(255,214,186)",
    strokeColorStr = "topArenaTeamStrokeColor3"
  },
  [4] = {
    color = ed.toccc3(16771233),
    strokeColor = ed.toccc3(11423755),
    colorStr = "ccc3(255,232,161)",
    strokeColorStr = "0xae500b"
  },
  [5] = {
    color = ed.toccc3(15460863),
    strokeColor = ed.toccc3(5330343),
    colorStr = "ccc3(235,233,255)",
    strokeColorStr = "0x5155a7"
  },
  [6] = {
    color = ed.toccc3(15326975),
    strokeColor = ed.toccc3(7092657),
    colorStr = "ccc3(233,222,255)",
    strokeColorStr = "0x6c39b1"
  },
  [7] = {
    color = ed.toccc3(16514997),
    strokeColor = ed.toccc3(8621085),
    colorStr = "ccc3(251,255,181)",
    strokeColorStr = "0x838c1d"
  }
}
local peakArenaLabelConfig = setmetatable({
  [4] = {
    color = ed.toccc3(15381503),
    strokeColor = ed.toccc3(6098306),
    colorStr = "ccc3(233,179,255)",
    strokeColorStr = "0x5d0d82"
  },
  [5] = {
    color = ed.toccc3(10221792),
    strokeColor = ed.toccc3(1921631),
    colorStr = "ccc3(155,247,224)",
    strokeColorStr = "0x1d525f"
  }
}, {__index = arenaTeamLabelConfig})

local function addLegendArenaTeamInfo(self, info)
  if nil == info then
    return
  end
  self:removeShade()
  if self.team_info_node and not tolua.isnull(self.team_info_node) then
    self.team_info_node:removeFromParentAndCleanup(true)
    self.team_info_node = nil
  end
  local icon = self.icon
  if info.team_index then
    self:addShade()
    local team_info_node = CCNode:create()
    local resIndex = info.team_index
    resIndex = info.peakArena and (resIndex == 4 and 8 or resIndex == 5 and 9) or resIndex
    local team_index_bg = ed.createSprite("UI/alpha/1080P/toparena/toparena_team_" .. resIndex .. "_tf.png")
    team_index_bg:setAnchorPoint(ccp(0.5, 0.5))
    team_index_bg:setPosition(70, 65)
    local conf = arenaTeamLabelConfig[info.team_index]
    if info.peakArena then
      conf = peakArenaLabelConfig[info.team_index]
    end
    local teamLabel = ed.ui.autoText.new()
    teamLabel:initParam({
      color = conf.color,
      strokeColor = conf.strokeColor,
      strokeSize = 1,
      context = string.format(T("<lable fontSize=f16 color=%s strokeColor=%s strokeSize=1>%d</lable>\233\152\159"), conf.colorStr, conf.strokeColorStr, info.team_index),
      fontSize = 13,
      fontName = ed.fontBold
    })
    local atSize = teamLabel.node:getContentSize()
    local atWid, atHei = teamLabel:getCurContentSize()
    local scale = math.min(1, team_index_bg:getContentSize().width / atWid)
    teamLabel.node:setScale(scale)
    atWid = atWid * scale
    local bgSize = team_index_bg:getContentSize()
    teamLabel.node:setPosition(ccp(bgSize.width * 0.5 - atWid * 0.5, bgSize.height * 0.5))
    team_index_bg:addChild(teamLabel.node)
    team_info_node:addChild(team_index_bg, 10)
    icon:addChild(team_info_node, 15)
    self.team_info_node = team_info_node
  end
end

class.addLegendArenaTeamInfo = addLegendArenaTeamInfo

local function addPeakArenaBanTag(self)
  local icon = self.icon
  if self.peakArenaBanMask and not tolua.isnull(self.peakArenaBanMask) then
    self.peakArenaBanMask:setVisible(true)
  else
    local banMask = CCLayerColor:create(ccc4(0, 0, 0, 150))
    banMask:setContentSize(CCSizeMake(77, 77))
    banMask:setPosition(ccp(-3, -4))
    icon:addChild(banMask, 8)
    self.peakArenaBanMask = banMask
    local banTag = ed.createSprite("UI/alpha/1080P/toparena/toparena_ban_symbol_1.png")
    banMask:addChild(banTag)
    ed.layout.centerInParent(banTag)
  end
end

class.addPeakArenaBanTag = addPeakArenaBanTag

local function RemoveTeamInfo(self)
  if self.team_info_node and not tolua.isnull(self.team_info_node) then
    self.team_info_node:removeFromParentAndCleanup(true)
  end
end

class.RemoveTeamInfo = RemoveTeamInfo

function class.createIcon(info)
  local obj = {}
  setmetatable(obj, class.mt)
  info = info or {}
  obj.info = info
  obj.icon = obj:addPictureInfo(info.id, info.fashion_id)
  if info.isNoLevelStar then
    info.level = false
    info.stars = false
  end
  if obj.icon ~= nil then
    obj.bg = ed.createSprite("UI/alpha/1080P/common/frame/hero_icon_bg.png")
    local bgsize = obj.icon:getContentSize()
    obj.bg:setPosition(bgsize.width / 2, bgsize.height / 2)
    obj.icon:addChild(obj.bg, -1)
    obj:getMercenaryHirePos(info.karlElement, info.legendEquip)
    obj:addMercenaryInfo(info.mercenary, info.karlElement, info.legendEquip)
    obj:addKarlElement(info.karlElement)
    obj:addLegendEquip(info.legendEquip)
    obj:addLevelInfo(info.level)
    obj:addFrameInfo(info.rank, info.runeState, info.runeWords, info.mealMode)
    obj:needHideFrame(info.isHideFrame)
    obj:addTextInfo(info.text, info.textColor)
    obj:addStarsInfo(info.stars, info.tempStar)
    obj:addStateInfo(info.state)
    if info.shade then
      info.hp = nil
      if info.withShade == nil then
        info.withShade = true
      end
    end
    obj:addPreferInfo(info.isPrefer, info.preferRes)
    obj:addShadeInfo(info.withShade)
    obj:addHpMpInfo(info.hp, info.mp, info.gcwRecover)
    obj:addForbiddenInfo(info.forbidden)
    obj:addLengthInfo(info.length)
    obj:addAdventureAddition(info.id, info.actAdventureId)
    obj:addShardLogo(info.shard)
    obj:addPvpActivityInfo(info.pvpActivityMask, info.isShowPvpActivityMask)
    if isSpecialFreeHeroID(info.id) then
      obj:addTimelyFreeTag()
    end
    if info.showParagonLv then
      obj:addParagonLv()
    end
    obj:addPetInfo(info.petInfo)
  end
  return obj
end

function class:addShardLogo(shard)
  local icon = self.icon
  if not icon or not shard then
    return
  end
  local size = icon:getContentSize()
  local shardLogo = ed.createSprite("UI/alpha/1080P/shard/shard_logo.png")
  shardLogo:setPosition(size.width / 2, size.height - 1.5)
  icon:addChild(shardLogo)
end

function class:addParagonLv()
  local icon = self.icon
  self.dungeonMgr = ed.awakeDungeonMgr:getInstance()
  local level = self.dungeonMgr:getParagonLevel()
  if not icon or not level then
    return
  end
  local levelBg = ed.createSprite("UI/alpha/1080P/dungeon/dungeon_battle_level.png")
  levelBg:setAnchorPoint(ccp(0, 0))
  levelBg:setPosition(ccp(0, 27))
  icon:addChild(levelBg, 20)
  local levelLabel = ed.createttf(level or 0, 14)
  levelLabel:setAnchorPoint(ccp(0.5, 0.5))
  levelLabel:setPosition(ccp(8, 34.5))
  icon:addChild(levelLabel, 25)
end

function class:addPvpActivityInfo(pvpActivityMask, isShowPvpActivityMask)
  if not pvpActivityMask or not isShowPvpActivityMask then
    return
  end
  local mask = ed.createSprite(pvpActivityMask)
  self.icon:addChild(mask)
  mask:setPosition(ccp(67, 63))
end

function class:addKarlElement(unitElement)
  self.elementTag = 100000
  if nil == unitElement then
    return
  end
  local element = ed.createSprite(unitElement)
  self.icon:addChild(element, 18, self.elementTag)
  local icon = self.icon
  local size = icon:getContentSize()
  element:setPosition(ccp(size.width - 7.5, 20))
  element:setScale(0.5)
  element:setVisible(false)
end

function class:getMercenaryHirePos(karlElement, legendEquip)
  self.mercenaryHirePos = ccp(4, 75)
  if karlElement ~= nil or legendEquip ~= nil then
    self.mercenaryHirePos = ccp(-6, 18)
  end
end

function class:showKarlElement(state)
  local element = self.icon:getChildByTag(self.elementTag)
  if element then
    element:setVisible(state)
  end
end

local function getLegendEquipIdByIcon(legendEquipId)
  local config = ed.getDataTable("LegendEquip")[legendEquipId]
  if nil == config then
    return nil
  end
  return config["Special Icon"]
end

function class:addLegendEquip(legendInfo)
  self.elementTag3 = 100003
  if nil == legendInfo then
    return
  end
  local imagePath = getLegendEquipIdByIcon(legendInfo._type_id)
  local element = ed.createSprite("UI/alpha/1080P/legendequip/hero_head.png")
  self.icon:addChild(element, 21, self.elementTag3)
  local icon = self.icon
  local size = icon:getContentSize()
  element:setPosition(ccp(8, size.height - 8))
  if not ed.openLegendEquip() then
    element:setVisible(false)
  else
    element:setVisible(not ed.off_legendEquipOp)
  end
  local labelBg = ed.createClippingNode(imagePath, "UI/alpha/1080P/legendequip/hero_cover.png", nil, CCSizeMake(-10, -6), {})
  local element_size = element:getContentSize()
  labelBg:setPosition(ccp(14, element_size.height - 14))
  element:addChild(labelBg)
end

function class:showLegendEquip(state)
  local element = self.icon:getChildByTag(self.elementTag3)
  if element then
    element:setVisible(not state)
  end
end

function class.createPureIcon(info)
  local obj = {}
  setmetatable(obj, class.mt)
  info = info or {}
  obj.info = info
  obj.icon = obj:addPictureInfo(info.id)
  obj:addFrameInfo(info.rank)
  obj:addStarsInfo(getHeroInitStars(info.id))
  return obj
end

function class:addPictureInfo(id, fashion_id)
  local icon
  if not id then
    icon = CCSprite:create()
    icon:setContentSize(ed.DGSizeMake(104, 104))
    icon:setCascadeOpacityEnabled(true)
    local cm = CCLayerColor:create(ccc4(0, 0, 0, 255))
    cm:setContentSize(ed.DGSizeMake(104, 104))
    cm:setCascadeOpacityEnabled(true)
    icon:addChild(cm)
    local cm = CCSprite:create()
    cm:setContentSize(ed.DGSizeMake(104, 104))
    cm:setColor(ccc3(0, 0, 0))
    cm:setPosition(ed.getCenterPos(icon))
    icon:addChild(cm)
    local qm = ed.createSprite("UI/alpha/1080P/common/hero_icon_unknow.png")
    qm:setPosition(ed.getCenterPos(icon))
    icon:addChild(qm)
  else
    local portrait_res = ed.getUnitPortrait(convertToOriginID(id))
    if fashion_id and fashion_id ~= 0 then
      portrait_res = ed.lookupDataTable("Fashion", "Portrait Switch", fashion_id)
    else
      portrait_res = portrait_res or "UI/alpha/1080P/common/hero_icon_unknow.png"
    end
    icon = ed.createSprite(portrait_res)
  end
  icon:setCascadeOpacityEnabled(true)
  return icon
end

local function isGuildheroMercenary(param)
  return 0 == param.uid
end

class.isGuildheroMercenary = isGuildheroMercenary

local function getGuildheroHireCountLimit()
  local default = 20
  local tbl = ed.getDataTable("GuildHeroHire")
  if tbl then
    return #tbl
  else
    return default
  end
end

class.getGuildheroHireCountLimit = getGuildheroHireCountLimit

function class:addMercenaryInfo(mercenaryInfo, unitElement)
  local icon = self.icon
  if not icon or not mercenaryInfo then
    return
  end
  local iconsize = icon:getContentSize()
  self.elementTag = 100000
  self.elementTag2 = 100001
  local mercenaryIcon = ed.createSprite("UI/alpha/1080P/common/heroselect_tag_hire.png")
  mercenaryIcon:setPosition(self.mercenaryHirePos)
  icon:addChild(mercenaryIcon, 18, self.elementTag2)
  local element = ed.createSprite(unitElement)
  icon:addChild(element, 19, self.elementTag)
  element:setPosition(ccp(iconsize.width - 7.5, 20))
  element:setScale(0.5)
  element:setVisible(false)
  if mercenaryInfo.owner then
    local bg = ed.createSprite("UI/alpha/1080P/crusade/mercenary_bg.png")
    bg:setPosition(ccp(iconsize.width / 2, iconsize.height / 2))
    icon:addChild(bg, -1)
    local nameLabel = ed.createttf(mercenaryInfo.owner, 16)
    nameLabel:setColor(ccc3(ed.colorToStr("#fffce7")))
    nameLabel:setPosition(ccp(iconsize.width / 2, iconsize.height + 50 / ed.display.scaleFactor))
    icon:addChild(nameLabel)
  end
  if mercenaryInfo.cost then
    if mercenaryInfo.cost > 0 then
      local goldIcon = ed.createSprite("UI/alpha/1080P/main/goldicon_small.png")
      goldIcon:setPosition(ccp(-20 / ed.display.scaleFactor, -50 / ed.display.scaleFactor))
      goldIcon:setScale(0.8)
      icon:addChild(goldIcon)
      local costLabel = ed.createttf(mercenaryInfo.cost, 16)
      costLabel:setColor(ccc3(ed.colorToStr("#ffa531")))
      costLabel:setStroke(ccc3(ed.colorToStr("#000000")), 2)
      costLabel:setPosition(ccp(iconsize.width / 2, -50 / ed.display.scaleFactor))
      icon:addChild(costLabel)
      self.costLabel = costLabel
    else
      local costLabel = ed.createttf(T("\229\133\141\232\180\185"), 16)
      costLabel:setColor(ccc3(ed.colorToStr("#ffa531")))
      costLabel:setStroke(ccc3(ed.colorToStr("#000000")), 2)
      costLabel:setPosition(ccp(iconsize.width / 2, -50 / ed.display.scaleFactor))
      icon:addChild(costLabel)
      self.costLabel = costLabel
    end
    local searchIcon = ed.createSprite("UI/alpha/1080P/shard/view_bg.png")
    searchIcon:setPosition(ccp(iconsize.width + 10, 7))
    icon:addChild(searchIcon, 999)
    searchIcon:setScale(0.8)
    local search = ed.createSprite("UI/alpha/1080P/guild/search.png")
    search:setPosition(ccp(17, 17))
    searchIcon:addChild(search)
    search:setScale(0.65)
    self.searchIcon = searchIcon
  end
  if mercenaryInfo.sort == "bLevel" or mercenaryInfo.sort == "bHired" or mercenaryInfo.sort == "gHired" then
    local limit_times = getGuildheroHireCountLimit()
    local forbidden = mercenaryInfo.sort ~= "gHired" or mercenaryInfo.sort == "gHired" and mercenaryInfo.hire_times == limit_times
    if forbidden then
      local unMercenaryLab = ed.createLabelTTF(T("\230\151\160\230\179\149\233\155\135\228\189\163"), 11)
      ed.setLabelColor(unMercenaryLab, ed.toccc3(16675699))
      ed.setLabelStroke(unMercenaryLab, ed.toccc3(2434341), 1.5)
      unMercenaryLab:setPosition(ccp(iconsize.width / 2, iconsize.height))
      icon:addChild(unMercenaryLab, 20)
      local shade1 = CCLayerColor:create(ccc4(0, 0, 0, 150))
      local size = icon:getContentSize()
      shade1:setContentSize(CCSizeMake(size.width + 8, size.height + 8))
      shade1:setPosition(-4, -4)
      icon:addChild(shade1, 3)
    end
  end
end

function class:addLevelInfo(level)
  local icon = self.icon
  if not icon or not level then
    return
  end
  local levelBg = ed.createSprite("UI/alpha/1080P/common/heropackage_level_bg.png")
  levelBg:setAnchorPoint(ccp(0, 0))
  levelBg:setPosition(ccp(0, 10))
  icon:addChild(levelBg, 20)
  self.levelBg = levelBg
  local levelLabel = ed.createttf(level or 1, 14)
  levelLabel:setAnchorPoint(ccp(0.5, 0.5))
  levelLabel:setPosition(ccp(8, 16.5))
  icon:addChild(levelLabel, 25)
  self.levelLabel = levelLabel
end

function class:addFrameInfo(rank, runeState, runeWords, mealMode, isChess)
  local icon = self.icon
  if not icon then
    return
  end
  local frame = ed.createSprite(ed.Hero.getIconFrameByRank(rank or 1))
  local size = icon:getContentSize()
  frame:setPosition(size.width / 2, size.height / 2)
  icon:addChild(frame)
  self.frame = frame
end

function class:needHideFrame(needHideFrame)
  if needHideFrame and self.frame then
    self.frame:setVisible(false)
  end
end

function class:addTextInfo(text, textColor)
  local icon = self.icon
  if not icon or not text then
    return
  end
  local size = icon:getContentSize()
  local textLabel = ed.createttf(text, 24)
  textLabel:setAnchorPoint(ccp(0.5, 0))
  textLabel:setPosition(ccp(size.width * 0.5, size.height * 0.12))
  ed.setLabelColor(textLabel, textColor or ccc3(240, 220, 188))
  ed.setLabelStroke(textLabel, ccc3(0, 0, 0), 2)
  icon:addChild(textLabel)
  self.textLabel = textLabel
end

function class:addStarsInfo(stars, tempStar)
  local icon = self.icon
  if not icon or tempStar == nil and stars == nil then
    return
  end
  if self.info.noStar then
    return
  end
  local iconSize = icon:getContentSize()
  local starIconPath = {
    yellow = "UI/alpha/1080P/hero/hero_star_1.png",
    blue = "UI/alpha/1080P/hero/hero_star_1.png"
  }
  tempStar = tempStar or 0
  stars = stars or 0
  if stars + tempStar > maxStar then
    tempStar = maxStar - stars
  end
  self.stars = {}
  local count = stars + tempStar
  if count <= 0 then
    return
  end
  local node = CCSprite:create()
  node:setCascadeOpacityEnabled(true)
  node:setAnchorPoint(ccp(0, 0))
  icon:addChild(node)
  for i = count, 1, -1 do
    local path
    if stars >= i then
      path = starIconPath.yellow
    else
      path = starIconPath.blue
    end
    local pict = ed.createSprite(path)
    pict:setScale(0.5)
    node:addChild(pict, 5)
    self.stars[i] = pict
  end
  local gs = CCSizeMake(13, 13)
  local ps = CCSizeMake(gs.width * count, 13)
  ed.layout.layoutChildrenWithSize(node, ps, ed.layoutType.Grid, {gridSize = gs})
  node:setPosition((iconSize.width - ps.width) / 2, -2)
end

function class:addStateInfo(state)
  local stateRes = {
    hire = {
      text = T("\229\174\136\232\144\165\228\184\173")
    },
    banned = {
      res = "UI/alpha/1080P/common/nightmare_herostate_ban.png",
      pos = ccp(60, 70)
    },
    maxequip = {
      text = T("\230\187\161\233\153\132\233\173\148"),
      color = ccc3(73, 194, 46),
      strokeColor = ccc3(3, 29, 13),
      strokeSize = 1
    },
    employ = {
      text = T("\229\183\178\233\155\135\228\189\163"),
      color = ccc3(181, 251, 0)
    },
    dispatch = {
      text = T("\229\183\178\230\180\190\233\129\163"),
      color = ccc3(181, 251, 0)
    },
    disable = {
      text = T("\229\183\178\231\166\129\231\148\168"),
      color = ccc3(146, 0, 9)
    },
    select = {
      text = T("\229\183\178\233\128\137\230\139\169"),
      color = ccc3(181, 251, 0)
    },
    noOwn = {
      text = T("\230\156\170\230\139\165\230\156\137"),
      color = ed.toccc3(16754091),
      strokeColor = ed.toccc3(5309187),
      strikeSize = 1
    },
    redTag = {
      res = "UI/alpha/HVGA/main_deal_tag.png",
      pos = ccp(70, 70)
    }
  }
  local defaultPos = ccp(36, 61)
  local defaultSize = 14
  local defaultColor = ccc3(255, 234, 198)
  local defaultStrokeSize = 2
  local defaultStrokeColor = ccc3(30, 30, 30)
  local res = stateRes[state]
  if not res then
    return false
  end
  local stateLabel
  if res.text then
    stateLabel = ed.createttf(res.text, res.size or defaultSize)
    ed.setLabelColor(stateLabel, res.color or defaultColor)
    ed.setLabelStroke(stateLabel, res.strokeColor or defaultStrokeColor, res.strokeSize or defaultStrokeSize)
  elseif res.res then
    stateLabel = ed.createSprite(res.res)
  end
  stateLabel:setPosition(res.pos or defaultPos)
  self.icon:addChild(stateLabel, 2)
  self.stateLabel = stateLabel
  return true
end

function class:addStateTag(state)
  if self:addStateInfo(state) then
    self:addShade()
    return true
  end
  return false
end

function class:addPreferInfo(isPrefer, preferRes)
  local icon = self.icon
  if not icon or not isPrefer then
    return
  end
  local res = "UI/alpha/1080P/common/school_questboard_preferred_title.png"
  if preferRes then
    res = preferRes
  end
  local pict = ed.createSprite(res)
  icon:addChild(pict)
  if preferRes then
    local size = icon:getContentSize()
    local scale = 1
    local pictSize = pict:getContentSize()
    pict:setPosition(ccp(size.width - pictSize.width / 2 * scale, pictSize.height / 2 * scale))
  elseif not tolua.isnull(self.levelBg) then
    pict:setAnchorPoint(ccp(0, 0))
    local size = icon:getContentSize()
    pict:setPosition(ccp(size.width - 23, size.height - 37))
  else
    local size = icon:getContentSize()
    pict:setPosition(ccp(size.width - 23, size.height - 37))
  end
end

function class:addShadeInfo(withShade)
  if withShade then
    self:addShade()
  end
end

function class:addHpMpInfo(hp, mp)
  local icon = self.icon
  if not icon or not hp then
    return
  end
  local size = icon:getContentSize()
  local hpNode = CCSprite:create()
  hpNode:setAnchorPoint(ccp(0, 0))
  hpNode:setCascadeOpacityEnabled(true)
  if hp <= 0 then
    local die
    if self.info.hmMode and self.info.hmMode == "crusade" then
      local num = ed.player:getEquipAmount(2548)
      if 0 < num then
        die = ed.createSprite("UI/alpha/1080P/common/crusade_respawn.png")
        local labelRespawn = ed.createttf(T("\229\143\175\229\164\141\230\180\187"), 11)
        ed.setLabelColor(labelRespawn, ed.toccc3(16762624))
        ed.setLabelStroke(labelRespawn, ed.toccc3(0), 1)
        die:addChild(labelRespawn)
        ed.layout.centerInParent(labelRespawn)
      else
        die = ed.createttf(T("\229\183\178\233\152\181\228\186\161"), 21)
        die:limitWidthByScale(size.width * 0.9)
        ed.setLabelColor(die, ed.toccc3(16741231))
        ed.setLabelStroke(die, ed.toccc3(0), 2)
      end
    else
      die = ed.createttf(T("\229\183\178\233\152\181\228\186\161"), 21)
      die:limitWidthByScale(size.width * 0.9)
      ed.setLabelColor(die, ed.toccc3(16741231))
      ed.setLabelStroke(die, ed.toccc3(0), 2)
    end
    die:setPosition(size.width / 2, size.height - 13)
    hpNode:addChild(die, 10)
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(icon:getContentSize())
    hpNode:addChild(shade)
  else
    local hpbg = ed.createSprite("UI/alpha/1080P/common/crusade_hp_bar_bg.png")
    hpbg:setAnchorPoint(ccp(0, 0.5))
    hpbg:setPosition(size.width / 2 - hpbg:getContentSize().width / 2, size.height - 5)
    hpNode:addChild(hpbg)
    local hpn = ed.createSprite("UI/alpha/1080P/common/crusade_hp_bar.png")
    hpn:setAnchorPoint(ccp(0, 0.5))
    hpn:setPosition(size.width / 2 - hpn:getContentSize().width / 2, size.height - 5)
    hpNode:addChild(hpn)
    hpn:setScaleX(hp / 10000)
    hpbg:setOpacity(150)
    hpn:setOpacity(150)
    if mp then
      local mpbg = ed.createSprite("UI/alpha/1080P/common/crusade_mp_bar_bg.png")
      mpbg:setAnchorPoint(ccp(0, 0.5))
      mpbg:setPosition(size.width / 2 - mpbg:getContentSize().width / 2, size.height - 13)
      hpNode:addChild(mpbg)
      local mpn = ed.createSprite("UI/alpha/1080P/common/crusade_mp_bar.png")
      mpn:setAnchorPoint(ccp(0, 0.5))
      mpn:setPosition(11, 64)
      mpn:setPosition(size.width / 2 - mpn:getContentSize().width / 2, size.height - 13)
      hpNode:addChild(mpn)
      mpn:setScaleX(mp / 10000)
      mpbg:setOpacity(150)
      mpn:setOpacity(150)
    end
  end
  icon:addChild(hpNode)
  self.hpNode = hpNode
end

function class:refreshHpMpInfo(hp, mp, gcwRecover)
  if self.hpNode then
    self.hpNode:removeFromParentAndCleanup(true)
  end
  self:addHpMpInfo(hp, mp, gcwRecover)
end

function class:addForbiddenInfo(forbidden)
  local icon = self.icon
  if not icon or not forbidden then
    return
  end
  local forbiddenNode = CCNode:create()
  local forbiddenTxt = ed.createttf(T("\228\184\141\229\143\175\231\148\168"), 12)
  ed.setLabelColor(forbiddenTxt, ed.toccc3(16741231))
  ed.setLabelStroke(forbiddenTxt, ed.toccc3(461585), 1.5)
  forbiddenTxt:setPosition(44, 65)
  forbiddenNode:addChild(forbidden, 10)
  local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
  shade:setContentSize(icon:getContentSize())
  forbiddenNode:addChild(shade)
  icon:addChild(forbiddenNode)
  self.forbiddenNode = forbiddenNode
end

function class:addLengthInfo(length)
  local icon = self.icon
  if not icon or not length then
    return
  end
  local size = icon:getContentSize()
  icon:setScale(length / size.width)
end

function class:addAdventureAddition(heroId, actAdventureId)
  if not actAdventureId or actAdventureId == 0 then
    return
  end
  local actAdventureMgr = ed.actiAdventureMgr.getInstance()
  local heroAddition = actAdventureMgr:getHeroAddition(actAdventureId, heroId)
  if not heroAddition or heroAddition == 0 then
    return
  end
  local tokenPath = ed.adventureDefine.getAdventureTokenSmallRes(actAdventureId)
  local tokenSpr = ed.createSprite(tokenPath)
  local label = ed.createLabelTTF(string.format("+%s%%", heroAddition / 100), 15)
  ed.setLabelColor(label, ed.toccc3(7405396))
  ed.setLabelStroke(label, ed.toccc3(1519903), 1)
  local bgSpr = ed.createSprite("UI/alpha/1080P/activityadventure/adventure_herohead_bonus.png")
  bgSpr:addChild(tokenSpr)
  bgSpr:addChild(label)
  ed.layout.centerYInParent(tokenSpr)
  tokenSpr:setPositionX(20)
  tokenSpr:setScale(0.8)
  ed.layout.centerYInParent(label)
  label:setPositionX(tokenSpr:getPositionX() + tokenSpr:getContentSize().width + 2)
  self.icon:addChild(bgSpr, 1)
  ed.layout.centerXInParent(bgSpr)
  bgSpr:setPositionY(self.icon:getContentSize().height - 5)
end

function class:removeStateTag()
  removeNode(self.stateShade)
  removeNode(self.stateLabel)
end

function class:addShade()
  if self.stateShade then
    return
  end
  local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
  shade:setContentSize(CCSizeMake(77, 77))
  shade:setPosition(ccp(-3, -4))
  self.icon:addChild(shade, 8)
  self.stateShade = shade
end

function class:addPetIcon(petId)
  if not petId then
    return
  end
  local petIcon = ed.readpet.createIconById(petId, {noLevel = true}).icon
  petIcon:setScale(0.4)
  petIcon:setPosition(ccp(56, 13))
  self.icon:addChild(petIcon, 9)
end

function class:addTimelyFreeTag()
  local timelyFreeTag = ed.createSprite("UI/alpha/1080P/newkingspvp/main/free_logo.png")
  self.timelyFreeTag = timelyFreeTag
  timelyFreeTag:setPosition(ccp(53, 65))
  self.icon:addChild(timelyFreeTag, 10)
end

function class:removeShade()
  removeNode(self.stateShade)
  self.stateShade = nil
end

function class:setIconGray()
  ed.setSpriteGray(self.icon)
  ed.setSpriteGray(self.frame)
end

function class:resetIconShader()
  ed.resetSpriteShader(self.icon)
  ed.resetSpriteShader(self.frame)
end

function class:setLevelVisible(isVisible)
  if isVisible == nil then
    isVisible = true
  end
  if not tolua.isnull(self.levelBg) then
    self.levelBg:setVisible(isVisible)
  end
  if not tolua.isnull(self.levelLabel) then
    self.levelLabel:setVisible(isVisible)
  end
end

function class:setStarsVisible(visible)
  for k, star in pairs(self.stars) do
    star:setVisible(visible)
  end
end

function class:setStateVisible(visible)
  self.stateShade:setVisible(visible)
  self.stateLabel:setVisible(visible)
end

function class:changeIconState(state)
  if not state then
    return
  end
  if self.stateLabel then
    removeNode(self.stateLabel)
    removeNode(self.stateShade)
    self.stateLabel = nil
    self.stateShade = nil
  end
  if state ~= "idle" then
    local needUseHpAndShade = self:addStateInfo(state)
    if needUseHpAndShade then
      self:addShade()
    end
  end
end

function class.getIcon(info)
  local obj = class.createIcon(info)
  return obj.icon, obj
end

function class.getHeroMaxRange(hid)
  local basicSkill = ed.getDataTable("Unit")[convertToOriginID(hid)]["Basic Skill"]
  local maxRange = ed.getDataTable("Skill")[basicSkill][0]["Max Range"]
  return maxRange
end

local function getHeroState(id, state, stateIgnoreList)
  local state = state
  if ed.isElementInTable(id, stateIgnoreList) then
    state = "idle"
  end
  return state
end

function class.getHeroElement(hid)
  local element = ed.getDataTable("Unit")[convertToOriginID(hid)].Element
  if nil == element then
    return nil
  else
    return string.format("UI/alpha/1080P/tag/Kael_%s.png", element)
  end
end

function class.createIconByHero(hero, addition)
  if nil == hero then
    EDLog("ERROR: ed.readhero.createIconByHero() - hero data is nil!")
    return
  end
  addition = addition or {}
  local hmMode = addition.hmMode
  local state = getHeroState(hero._tid, addition.state, addition.stateIgnoreList)
  local addStar = addition.addStar or 0
  local limitRank = addition.limitRank or hero._rank
  local heroRank = hero._rank
  if addition.limitRank and 0 < addition.limitRank then
    heroRank = math.min(heroRank, addition.limitRank)
  end
  local _legendEquip
  if addition.isShowLegendEquip then
    if nil == hero._legend_equip then
      local owner = ed.player:getHero(hero._tid)
      _legendEquip = owner and owner:getCurrentEquip()
    else
      _legendEquip = hero._legend_equip and hero._legend_equip._equip
    end
  end
  local icon = class.createIcon({
    id = hero._tid,
    hmMode = hmMode,
    hp = hero:hp_perc(hmMode),
    mp = hero:mp_perc(hmMode),
    rank = heroRank,
    level = hero._level,
    stars = hero._stars + addStar,
    state = state or hero._state,
    length = addition.length,
    isHideFrame = addition.isHideFrame,
    withShade = addition.withShade,
    text = addition.text,
    textColor = addition.textColor,
    mercenary = addition.mercenary,
    isPrefer = addition.isPrefer,
    preferRes = addition.preferRes,
    forbidden = addition.forbidden,
    tempStar = addition.tempStar,
    maxRange = class.getHeroMaxRange(hero._tid),
    isNoLevelStar = addition.isNoLevelStar,
    actAdventureId = addition.actAdventureId,
    fashion_id = hero._fashion,
    summary = hero,
    shard = hero._shard,
    showParagonLv = addition.showParagonLv,
    pvpActivityMask = addition.pvpActivityMask,
    isShowPvpActivityMask = addition.isShowPvpActivityMask,
    karlElement = class.getHeroElement(hero._tid),
    legendEquip = _legendEquip
  })
  return icon
end

function class.createIconByID(id, addition)
  local hero = ed.player.heroes[id]
  addition = addition or {}
  if hero == nil then
    return class.createIcon({
      id = id,
      rank = 1,
      withShade = true,
      length = addition.length,
      state = addition.state,
      karlElement = class.getHeroElement(id),
      legendEquip = nil
    })
  end
  return class.createIconByHero(hero, addition)
end

local function showBanTag(self)
  self.isBan = true
  self:removeShade()
  if self.ban and not tolua.isnull(self.ban) then
    self.ban:removeFromParentAndCleanup(true)
    self.ban = nil
  end
  self:addShade()
  local ban = ed.createSprite("UI/alpha/1080P/common/pvp_ban.png")
  ban:setAnchorPoint(ccp(1, 0))
  ban:setPosition(ccp(self.icon:getContentSize().width, 0))
  self.icon:addChild(ban, 12)
  self.ban = ban
end

class.showBanTag = showBanTag

local function deleteBanTag(self)
  self.isBan = false
  self:removeShade()
  if self.ban and not tolua.isnull(self.ban) then
    self.ban:removeFromParentAndCleanup(true)
    self.ban = nil
  end
end

class.deleteBanTag = deleteBanTag

local function showSelectTag(self)
  self.isSelected = true
  if self.tag and not tolua.isnull(self.tag) then
    self.tag:removeFromParentAndCleanup(true)
  end
  self:addShade()
  local tag = ed.createSprite("UI/alpha/1080P/package/selected.png")
  tag:setAnchorPoint(ccp(1, 0))
  tag:setPosition(ccp(self.icon:getContentSize().width, 0))
  tag:setScale(0.6)
  self.icon:addChild(tag, 12)
  self.tag = tag
end

class.showSelectTag = showSelectTag

local function showAddTag(self, id)
  if self.addTag and not tolua.isnull(self.addTag) then
    self.addTag:removeFromParentAndCleanup(true)
  end
  local hid, eid = self.info.id, id
  local sr = "UI/alpha/1080P/hero/equip/equip_add_1.png"
  if not ed.canWearEquip(hid, eid) then
    sr = "UI/alpha/1080P/hero/equip/equip_add_2.png"
  end
  local add = ed.createSprite(sr)
  local size = self.icon:getContentSize()
  local pos = ccp(size.width - 15, size.height - 15)
  add:setPosition(pos)
  self.icon:addChild(add)
  self.addTag = add
end

class.showAddTag = showAddTag

local function removeAddTag(self)
  if self.addTag and not tolua.isnull(self.addTag) then
    self.addTag:removeFromParentAndCleanup(true)
  end
  self.addTag = nil
end

class.removeAddTag = removeAddTag

local function deleteSelectTag(self)
  self.isSelected = false
  self:removeShade()
  if self.tag and not tolua.isnull(self.tag) then
    self.tag:removeFromParentAndCleanup(true)
    self.tag = nil
  end
end

class.deleteSelectTag = deleteSelectTag

local function refreshLevel(self, level)
  ed.setString(self.levelLabel, level)
end

class.refreshLevel = refreshLevel

local function hide(self)
  self.icon:stopAllActions()
  self.icon:setVisible(false)
end

class.hide = hide

local function show(self, opacity)
  opacity = opacity or 255
  self.icon:setVisible(true)
  self.icon:setOpacity(opacity)
  if self.stateShade then
    self.stateShade:setOpacity(150 * opacity / 255)
  end
end

class.show = show

local function fadeOut(self, gap)
  gap = gap or 0.2
  local fade = CCFadeOut:create(gap)
  self.icon:runAction(fade)
  if self.stateShade then
    fade = CCFadeTo:create(gap, 0)
    self.stateShade:runAction(fade)
  end
end

class.fadeOut = fadeOut

local function fadeIn(self, gap)
  gap = gap or 0.2
  self.icon:setOpacity(0)
  local fade = CCFadeIn:create(gap)
  self.icon:runAction(fade)
  if self.stateShade then
    self.stateShade:setOpacity(0)
    fade = CCFadeTo:create(gap, 150)
    self.stateShade:runAction(fade)
  end
end

class.fadeIn = fadeIn

local function fadeTo(self, gap, opacity)
  gap = gap or 0.2
  opacity = opacity or 255
  local fade = CCFadeTo:create(gap, opacity)
  self.icon:runAction(fade)
  if self.stateShade then
    self.stateShade:runAction(CCFadeTo:create(gap, ed.clamp(opacity, 0, 150)))
  end
  if self.stars then
    for i, v in ipairs(self.stars) do
      v:setOpacity(opacity)
    end
  end
end

class.fadeTo = fadeTo

local function getMakeid(stoneid)
  local id = stoneid
  local ft = ed.getDataTable("fragment")
  for k, v in pairs(ft) do
    if type(k) == "number" and v["Fragment ID"] == id then
      return k
    end
  end
  return nil
end

class.getMakeid = getMakeid

local function getStoneid(hid)
  local ft = ed.getDataTable("fragment")
  local fid = (ft[hid] or {})["Fragment ID"]
  fid = fid or 335
  return fid
end

class.getStoneid = getStoneid

local function getStoneAmount(id)
  local sid = getStoneid(id)
  return ed.player:getEquipAmount(sid) or 0
end

class.getStoneAmount = getStoneAmount

local function getStoneNeed(id)
  local sa
  if not ed.player.heroes[id] then
    local initStar = ed.getDataTable("Unit")[id]["Initial Stars"]
    sa = ed.getDataTable("HeroStars")[initStar]["Summon Fragments"]
  else
    local hero = ed.player.heroes[id]
    local s = hero._stars + 1
    local row = ed.getDataTable("HeroStars")[s]
    if not row then
      return
    else
      sa = row["Upgrade Fragments"]
    end
  end
  return sa
end

class.getStoneNeed = getStoneNeed

local function getStoneLack(id)
  local need = getStoneNeed(id)
  local amount = getStoneAmount(id)
  return math.max(need - amount, 0)
end

class.getStoneLack = getStoneLack

local function getSummonCost(id)
  local initStar = ed.getDataTable("Unit")[id]["Initial Stars"]
  local cost = ed.getDataTable("HeroStars")[initStar]["Summon Price"]
  return cost
end

class.getSummonCost = getSummonCost

local function checkStoneEnough(id)
  local sa = getStoneAmount(id)
  local sn = getStoneNeed(id)
  if not sn then
    return false
  end
  if sa >= sn then
    return true
  else
    return false
  end
end

class.checkStoneEnough = checkStoneEnough

local function getMissList()
  local list = {}
  local ht = ed.getDataTable("Unit")
  for k, v in pairs(ht) do
    if type(k) == "number" and ed.unitType(k) == "hero" and isHeroOpen(k) and not ed.player.heroes[k] and (v.Enable or 0 < (ed.player.equip_qunty[getStoneid(k)] or 0)) and v["Can Summon By Stone"] then
      table.insert(list, k)
    end
  end
  for i = 1, #list do
    for j = i, 2, -1 do
      if list[j] < list[j - 1] then
        local t = list[j]
        list[j] = list[j - 1]
        list[j - 1] = t
      end
    end
  end
  return list
end

class.getMissList = getMissList

local function orderMissListByLack(list)
  for i = 1, #list do
    for j = i, 2, -1 do
      local id = list[j]
      local pid = list[j - 1]
      local pc = getStoneAmount(id) / getStoneNeed(id)
      local ppc = getStoneAmount(pid) / getStoneNeed(pid)
      if pc > ppc then
        local temp = list[j]
        list[j] = list[j - 1]
        list[j - 1] = temp
      end
    end
  end
end

class.orderMissListByLack = orderMissListByLack

local function checkEquipableProp(list)
  for k, v in pairs(list or ed.player.heroes) do
    local id = v._tid
    local rank = v._rank
    for i = 1, 6 do
      local eid = getEquipIdFromTb(id, i, rank)
      if not v:hasEquipment(i) and ed.isEquipCraftable(eid) and ed.canWearEquip(id, eid) then
        return true
      end
    end
  end
  return false
end

class.checkEquipableProp = checkEquipableProp

local function getFarmableProp(list)
  for k, v in pairs(list or ed.player.heroes) do
    local id = v._tid
    local rank = v._rank
    for i = 1, 6 do
      local eid = ed.getDataTable("hero_equip")[id][rank]["Equip" .. i .. " ID"]
      if not v:hasEquipment(i) and not ed.isEquipCraftable(eid) and ed.canWearEquip(id, eid) then
        local dropInfo = ed.getDataTable("equip")[eid].Drop
        for i, stageId in ipairs(dropInfo) do
          if ed.player:getStageStar(stageId) > 0 then
            return id, eid, stageId
          end
        end
      end
    end
  end
  return nil
end

class.getFarmableProp = getFarmableProp

local function canSummonHero()
  local ml = getMissList()
  for i = 1, #ml do
    if checkStoneEnough(ml[i]) then
      return true
    end
  end
end

class.canSummonHero = canSummonHero

local function canEvolve(id)
  local amount = class.getStoneAmount(id)
  local hst = ed.getDataTable("HeroStars")
  local hero = ed.player.heroes[id]
  local s = hero._stars
  local row = hst[s + 1]
  if s == 5 then
    return false
  end
  local need
  if not row then
    need = 1000
  else
    need = row["Upgrade Fragments"]
  end
  return amount >= need
end

class.canEvolve = canEvolve

local function canHeroEvolve()
  for k, v in pairs(ed.player.heroes) do
    local id = v._tid
    if canEvolve(id) then
      return true
    end
  end
end

class.canHeroEvolve = canHeroEvolve

local function getOriginalEquips(self)
  local original_equips = {}
  local equip_req_max_level = 0
  for i = 1, 6 do
    local need_equip_id = getEquipIdFromTb(self.hid, i, self.hero._rank)
    local current_equip_id = ed.player.heroes[self.hid]:getEquipid(i)
    if need_equip_id ~= 0 and current_equip_id == 0 then
      equip_req_max_level = math.max(equip_req_max_level, ed.lookupDataTable("equip", "Level Requirement", need_equip_id))
      table.insert(original_equips, need_equip_id)
    end
  end
  return original_equips, equip_req_max_level
end

class.getOriginalEquips = getOriginalEquips

local function getUpgradeExpectItems(self, original_equips)
  local total_consume = {}
  local temp_cost = {}
  local total_exp = 0
  
  local function judgeCraft(id)
    local exp, totalconsume, sy_items = ed.equipCraftNeedItems(id, temp_cost)
    total_exp = total_exp + (exp or 0)
    for id, amount in pairs(sy_items or {}) do
      temp_cost[id] = (temp_cost[id] or 0) + amount
    end
    for id, amount in pairs(totalconsume) do
      total_consume[id] = (total_consume[id] or 0) + (amount or 0)
    end
  end
  
  for k, id in pairs(original_equips) do
    local ect = ed.getDataTable("equipcraft")
    local row = ect[id]
    if row then
      if 0 < (ed.player.equip_qunty[id] or 0) - (temp_cost[id] or 0) then
        temp_cost[id] = (temp_cost[id] or 0) + 1
        total_consume[id] = (total_consume[id] or 0) + 1
      else
        judgeCraft(id)
      end
    else
      total_consume[id] = (total_consume[id] or 0) + 1
    end
  end
  return total_consume, total_exp
end

class.getUpgradeExpectItems = getUpgradeExpectItems

local function getExperienceEquips(self, equip_req_max_level)
  local total_consume = {}
  if equip_req_max_level > self.hero._level then
    local lack_levelup_exp = self.hero:lackExpToLevel(equip_req_max_level)
    if 0 < lack_levelup_exp then
      local player_exp_equips = ed.player:getPlayerExpEquips()
      local player_total_exp = 0
      table.sort(player_exp_equips, function(a, b)
        return a.Exp < b.Exp
      end)
      local cost_equip_exp = 0
      for k, equip_row in pairs(player_exp_equips) do
        local eid = equip_row.Item_ID
        for num = 1, ed.player:getEquipAmount(eid) do
          cost_equip_exp = cost_equip_exp + equip_row.Exp
          if lack_levelup_exp <= cost_equip_exp then
            total_consume[eid] = (total_consume[eid] or 0) + num
            break
          elseif num == ed.player:getEquipAmount(equip_row.Item_ID) then
            total_consume[eid] = (total_consume[eid] or 0) + num
          end
        end
        if lack_levelup_exp <= cost_equip_exp then
          break
        end
      end
      if lack_levelup_exp > cost_equip_exp then
        return total_consume, false, "expLack"
      end
    end
  end
  return total_consume, true
end

class.getExperienceEquips = getExperienceEquips

local function checkOneTimeUpgradeCondition(self)
  if not ed.playerlimit.checkAreaUnlock("RankFastUpgrade") then
    return false, {}
  end
  local self = self
  local canUpgrade = true
  local original_equips = {}
  local equip_req_max_level = 0
  local total_consume = {}
  local total_exp = 0
  local lackEquips = {}
  local unUpgradeType = ""
  original_equips, equip_req_max_level = class.getOriginalEquips(self)
  if #original_equips == 0 then
    return true, "notOneTimeUpgrade", {}
  end
  total_consume, total_exp = class.getUpgradeExpectItems(self, original_equips)
  local exp_items = {}
  exp_items, canUpgrade, unUpgradeType = class.getExperienceEquips(self, equip_req_max_level)
  for id, amount in pairs(exp_items) do
    total_consume[id] = amount
  end
  if equip_req_max_level > ed.player:getLevel() then
    canUpgrade = false
    unUpgradeType = "levelLower"
  end
  if total_exp > ed.player._money then
    canUpgrade = false
    unUpgradeType = "moneyLack"
  end
  for id, amount in pairs(total_consume) do
    local lackAmount = amount - (ed.player.equip_qunty[id] or 0)
    if 0 < lackAmount then
      canUpgrade = false
      unUpgradeType = "equipLack"
      lackEquips[id] = lackAmount
    end
  end
  return canUpgrade, "oneTimeUpgrade", {
    exp = total_exp,
    consume = total_consume,
    type = unUpgradeType,
    lackequips = lackEquips
  }
end

class.checkOneTimeUpgradeCondition = checkOneTimeUpgradeCondition

local function canUpgradeHeroWithId(id, hero)
  local self = {}
  self.hid = id
  self.hero = hero or ed.player.heroes[self.hid]
  if self.hero._rank >= ed.parameter.unit_max_rank then
    return false
  end
  local canUpgrade = true
  for i = 1, 6 do
    local ceid = ed.player.heroes[id]:getEquipid(i) or 0
    if ceid == 0 and getEquipIdFromTb(self.hid, i, self.hero._rank) ~= 0 then
      canUpgrade = false
      break
    end
  end
  return canUpgrade
end

class.canUpgradeHeroWithId = canUpgradeHeroWithId

local function canUpgradeHero()
  for k, v in pairs(ed.player.heroes) do
    if canUpgradeHeroWithId(k) then
      return true
    end
  end
end

class.canUpgradeHero = canUpgradeHero

local function canUpgradeHeroWithRecordCheck()
  for k, v in pairs(ed.player.heroes) do
    if canUpgradeHeroWithId(k) then
      local key = string.format("hero_deal_tag_%s_%s_%d_%d", game_server_id, ed.getUserid(), v._tid, v._rank)
      if true == ed.storage.getBool(key) then
      else
        return true
      end
    end
  end
end

class.canUpgradeHeroWithRecordCheck = canUpgradeHeroWithRecordCheck

local function canHeroSkillLevelup()
  if not ed.playerlimit.checkAreaUnlock("SkillUpgrade") then
    return false
  end
  for k, v in pairs(ed.player.heroes) do
    local sl = v._skill_levels
    local len = 4
    for i = 1, len do
      if sl[i] < v._level and i ~= 5 then
        return true
      end
    end
  end
  return false
end

class.canHeroSkillLevelup = canHeroSkillLevelup

local function canHeroWearEquip(list)
  return checkEquipableProp(list)
end

class.canHeroWearEquip = canHeroWearEquip

local function canAdvanceEquip(list)
  list = list or ed.player.heroes
  local hList = {}
  for i, v in pairs(list) do
    if v then
      table.insert(hList, v)
    end
  end
  table.sort(hList, function(a, b)
    if a._level > b._level then
      return true
    end
    return false
  end)
  if ed.readhero.getFarmableProp(hList) then
    return true
  end
  return false
end

class.canAdvanceEquip = canAdvanceEquip

local function canHeroEnhanceEquip(list)
  local list = list or ed.player.heroes
  for i = 1, #list do
    local hero = list[i] or {}
    local id = hero._tid
    if ed.readequip.canHeroItemsEnhance(id) then
      return true
    end
  end
  return false
end

class.canHeroEnhanceEquip = canHeroEnhanceEquip

local function getAllList(noSort)
  local listAll = {}
  local all = ed.orderHeroes(nil, noSort)
  for i = 1, #all do
    listAll[i] = all[i]
  end
  return listAll
end

class.getAllList = getAllList

local function getAllListWithMiss(noSort)
  local al = getAllList(noSort)
  local ml = getMissList()
  class.orderMissListByLack(ml)
  local index = 1
  for i = 1, #ml do
    local id = ml[i]
    local h = {_tid = id}
    if checkStoneEnough(id) then
      table.insert(al, index, h)
      index = index + 1
    else
      table.insert(al, h)
    end
  end
  return al
end

class.getAllListWithMiss = getAllListWithMiss

local function getAllListForPrepare(noSort)
  local listAll = {}
  local all = ed.orderHeroes(nil, noSort)
  for i = 1, #all do
    listAll[i] = all[i]
    listAll[i].maxRange = class.getHeroMaxRange(all[i]._tid)
  end
  return listAll
end

class.getAllListForPrepare = getAllListForPrepare

local function getAllListWithLimit(limit, heros)
  limit = limit or {}
  local limit_type = limit.type
  local detail = limit.detail
  local list = {}
  local all = heros and ed.orderHeroFunction(heros) or ed.orderHeroes()
  for i = 1, #all do
    local unit = ed.getDataTable("Unit")
    local tl = unit[all[i]._tid][limit_type]
    local isLimitTitan = limit_type == "HeroIsTitan" and detail == "True" and ed.isTitanById(all[i]._tid)
    if tl == detail or limit_type == "level" and detail <= all[i]._level or limit_type == "rank" and detail <= all[i]._rank or isLimitTitan then
      list[#list + 1] = all[i]
      all[i].maxRange = class.getHeroMaxRange(all[i]._tid)
    end
  end
  return list
end

class.getAllListWithLimit = getAllListWithLimit

function class.getAllListForRealarena()
  local restrictedHero = ed.getDataTable("KingsPVPConfig")["Hero Restricted"].Value or {}
  local heroList = {}
  local tabUnit = ed.getDataTable("Unit")
  for k, v in pairs(tabUnit) do
    local hid = v.ID
    if v["Unit Type"] == "Hero" and not ed.isElementInTable(hid, restrictedHero) then
      heroList[hid] = hid
    end
  end
  return heroList
end

local function classifyByPos(all)
  local front = {}
  local middle = {}
  local back = {}
  local titan = {}
  local unit = ed.getDataTable("Unit")
  for i = 1, #all do
    local unitTableItem = unit[convertToOriginID(all[i]._tid)]
    local pos = unitTableItem["Position Type"]
    local isTitan = unitTableItem.IsTitan
    if pos == T("\229\137\141\230\142\146") then
      table.insert(front, all[i])
    elseif pos == T("\228\184\173\230\142\146") then
      table.insert(middle, all[i])
    elseif pos == T("\229\144\142\230\142\146") then
      table.insert(back, all[i])
    end
  end
  return all, front, middle, back, {}
end

class.classifyByPos = classifyByPos

local function classifyByType(all)
  local str = {}
  local agi = {}
  local int = {}
  local unit = ed.getDataTable("Unit")
  for i = 1, #all do
    local type = unit[convertToOriginID(all[i]._tid)]["Hero Type"]
    if type == T("\229\138\155\233\135\143") then
      table.insert(str, all[i])
    elseif type == T("\230\149\143\230\141\183") then
      table.insert(agi, all[i])
    elseif type == T("\230\153\186\229\138\155") then
      table.insert(int, all[i])
    end
  end
  return all, str, agi, int
end

class.classifyByType = classifyByType

local function classify(target, mode, addition, allprovide, noSort)
  local all
  if allprovide then
    if target == "recommend" then
      all = getAllListWithLimit(addition.limit, allprovide)
    else
      all = allprovide
    end
  elseif target == "prepare" and addition and addition.limit then
    all = getAllListWithLimit(addition.limit)
  elseif target == "prepare" then
    all = getAllListForPrepare(noSort)
  elseif target == "all" then
    all = getAllListWithMiss(noSort)
  else
    all = getAllList(noSort)
  end
  mode = mode or "type"
  if mode == "type" then
    return classifyByType(all)
  elseif mode == "position" then
    return classifyByPos(all)
  end
end

class.classify = classify

local function createHeroNameByInfo(info)
  local name = info.name
  local rank = info.rank
  local nameColor = info.nameColor
  local tid = info.tid or 1
  local w, h
  local sprite = CCSprite:create()
  local name = ed.createttf(name, 20)
  name:setColor(ed.toccc3(16776423))
  name:setAnchorPoint(ccp(0, 0.5))
  local ns = name:getContentSize()
  local nw, nh = ns.width, ns.height
  name:setPosition(ccp(0, 0))
  ed.setLabelStroke(name, ccc3(0, 0, 0), 1)
  if nameColor then
    ed.setLabelColor(name, nameColor)
  end
  sprite:addChild(name)
  w = nw
  h = nh
  local heroStar = ed.Hero.getHeroStarByRank(rank) or 0
  if 0 < heroStar and not ed.Hero.isTitanById(tid) then
    heroStar = "+" .. heroStar
    local suffix = ed.createttf(heroStar, 20)
    suffix:setAnchorPoint(ccp(0, 0.5))
    suffix:setPosition(ccp(nw + (resource_config.heroname_seperate and 3 or 0), 0))
    sprite:addChild(suffix)
    local color = ed.Hero.getHeroNameColorByRank(rank)
    ed.setLabelColor(suffix, color)
    ed.setLabelStroke(suffix, ccc3(0, 0, 0), 1)
    local ss = suffix:getContentSize()
    local sw, sh = ss.width, ss.height
    w = w + sw
    h = math.max(h, sh)
  end
  sprite:setContentSize(CCSizeMake(w, h))
  sprite:setAnchorPoint(ccp(0, 0))
  return sprite, w, h
end

class.createHeroNameByInfo = createHeroNameByInfo

local function createHeroName(tid)
  local name = ed.getDataTable("Unit")[tid]["Display Name"]
  local rank = ed.player.heroes[tid]._rank
  return createHeroNameByInfo({
    name = name,
    rank = rank,
    tid = tid
  })
end

class.createHeroName = createHeroName
local card_type_icon = {
  STR = "UI/alpha/1080P/card/card_att_str_big.png",
  AGI = "UI/alpha/1080P/card/card_att_agi_big.png",
  INT = "UI/alpha/1080P/card/card_att_int_big.png"
}
local card_frame = {
  "UI/alpha/1080P/card/card_bg_white.png",
  "UI/alpha/1080P/card/card_bg_green.png",
  "UI/alpha/1080P/card/card_bg_green.png",
  "UI/alpha/1080P/card/card_bg_blue.png",
  "UI/alpha/1080P/card/card_bg_blue.png",
  "UI/alpha/1080P/card/card_bg_blue.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_orange.png",
  "UI/alpha/1080P/card/card_bg_orange.png",
  "UI/alpha/1080P/card/card_bg_orange.png",
  "UI/alpha/1080P/card/card_bg_red.png",
  "UI/alpha/1080P/card/card_bg_red.png"
}
local titan_card_frame = {
  "UI/alpha/HVGA/Resource_for_titan/card_bg_titan.png"
}

local function createSkillIcon(hid, slot, hero, addition)
  local sgt = ed.getDataTable("SkillGroup")[hid]
  local res = sgt[slot].Icon
  addition = addition or {}
  local fres = addition.fres or "UI/alpha/1080P/common/frame/equip_frame_white.png"
  local icon = ed.createSprite(res)
  local bg = ed.createSprite(fres)
  local size = icon:getContentSize()
  bg:setPosition(size.width / 2, size.height / 2)
  icon:addChild(bg)
  icon:setCascadeOpacityEnabled(true)
  return icon, bg
end

class.createSkillIcon = createSkillIcon

local function getHeroCardByHero(hero, addition)
  if not hero then
    return
  end
  addition = addition or {}
  local tid = hero._tid
  local disableSwap = addition.disableswap ~= nil and addition.disableswap or false
  local rank = addition.rank or hero._rank or 1
  local star = addition.stars or hero._stars or getHeroInitStars(tid)
  local fashion_id = addition.fashion_id or hero._fashion
  local starType = addition.starType
  if starType == "init" then
    star = addition.stars or getHeroInitStars(tid)
    rank = 1
  end
  local unit = ed.getDataTable("Unit")
  local type1 = unit[tid]["Main Attrib"]
  local typeres = card_type_icon[type1]
  local frameres = card_frame[rank]
  local nameres
  nameres = ed.getUnitArtName(tid)
  local namestr = ed.getDisplyName(tid)
  if fashion_id and 0 < fashion_id then
    frameres = ed.getFashionFrameRes(fashion_id, "Frame")
  end
  local ui = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local cardSize = CCSizeMake(242, 480)
  if not addition.OriSize then
    container:setContentSize(CCSizeMake(242, ed.display.winSize.height - 60))
  end
  ui.container = container
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = frameres,
        z = 1,
        capInsets = CCRectMake(20, 20, 36.5, 310)
      },
      layout = {
        position = ccp(cardSize.width / 2, cardSize.height / 2 + 15)
      },
      config = {
        scaleSize = CCSizeMake(280, 497)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "frame_cdll",
        parent = "frame",
        res = "UI/alpha/1080P/card/card_line.png",
        z = 1
      },
      layout = {
        position = ccp(135, 70)
      },
      config = {
        fix_scale = {x = 0.9, y = 0.9}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "type",
        parent = "frame",
        res = typeres,
        z = 1
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(15, 45)
      },
      config = {
        fix_size = CCSizeMake(47, 42)
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        parent = "frame",
        text = namestr,
        size = 31,
        z = 1
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(65, 45)
      },
      config = {fix_height = 35}
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  ui.frame:setCascadeOpacityEnabled(true)
  local cardres, card, ci, height
  ui.card_fashion = {}
  ui.card_fashion_effect = {}
  ui.card_fashion_plist = {}
  local label_name = ed.ui.gradientLabel.create({
    text = namestr,
    fontSize = 31,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16053236),
    endColor = ed.toccc3(16180130),
    strokeSize = 2,
    strokeColor = ed.toccc3(1118481)
  }).node
  label_name:setAnchorPoint(ccp(0, 0.5))
  label_name:setPosition(ccp(65, 45))
  ed.UITool.replaceUINew(ui, "name", label_name)
  ui.name:setScale(math.min(180 / label_name:getContentSize().width, 1))
  if fashion_id and 0 < fashion_id and not addition.disable_fashion then
    cardres = ed.lookupDataTable("Fashion", "Art Switch", fashion_id)
    card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/common/art_mask.png", nil, CCSizeMake(-20, -8))
    card:setPosition(ui.frame:getPosition())
    height = ci:getContentSize().height
    card:setScale(cardSize.height / height)
    container:addChild(card)
    ui.card_fashion[fashion_id] = card
    local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashion_id)
    local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashion_id)
    if fashion_effect_res and fashion_id == 13 and not ed.isAreaZhCn() then
      fashion_effect_res = fashion_effect_res .. "_globe"
    end
    if fashion_spine_res and ed.isSupportSpine() then
      local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, height / 928)
      spine:setAnimation(0, "Idle", true)
      local size = ci:getContentSize()
      spine:setPosition(-size.width / 2, -size.height / 2)
      card:addChild(spine)
      ui.card_fashion_spine = spine
    elseif fashion_effect_res then
      local effect_fca = ed.createFcaActor(fashion_effect_res)
      effect_fca:setLoop(true)
      effect_fca:setAction("Loop")
      card:addChild(effect_fca, 5)
      ui.card_fashion_effect[fashion_id] = effect_fca
    end
    local fashion_plist_res = ed.lookupDataTable("Fashion", "Plist", fashion_id)
    if fashion_plist_res then
      local particle = CCParticleSystemQuad:create("UI/particle/" .. fashion_plist_res)
      card:addChild(particle, 6)
      ui.card_fashion_plist[fashion_id] = particle
    end
  else
    cardres = ed.getUnitArt(tid)
    card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/common/art_mask.png", nil, CCSizeMake(-10, -8))
    height = ci:getContentSize().height
    card:setPosition(ui.frame:getPosition())
    card:setScale(cardSize.height / height)
    container:addChild(card)
    ui.card = card
  end
  ed.setNodeAnchor(ui.frame, ccp(0.5, 0.5))
  if not addition.hide_line then
    local lineres
    local width = ui.name:getContentSize().width
    if 120 < width then
      lineres = "UI/alpha/1080P/card/card_name_bg_short.png"
    else
      lineres = "UI/alpha/1080P/card/card_name_bg_long.png"
    end
    ui.line = ed.createSprite(lineres)
    ui.line:setAnchorPoint(ccp(1, 0.5))
    ui.line:setPosition(ccp(242, 60))
    container:addChild(ui.line)
  end
  if not addition.hide_star then
    ui.stars = {}
    local starRes = "UI/alpha/1080P/card/card_star_big.png"
    local starScale = 1
    local sx, sy = 22, 25
    local dx = 20 * ((addition.star_scale or starScale) / starScale)
    local starContainer = CCLayer:create()
    local starsSize = CCSizeMake(dx * star, 25)
    starContainer:setContentSize(starsSize)
    local starX, starY = ui.frame_cdll:getPosition()
    starX = starX - starsSize.width / 2 + 5
    starY = starY + 5
    starContainer:setPosition(starX, starY)
    ui.frame:addChild(starContainer, 1)
    for i = 1, star do
      local s = ed.createSprite(starRes)
      s:setPosition(ccp(10 + dx * (i - 1), 12))
      starContainer:addChild(s, 6 - i)
      s:setScale(addition.star_scale or starScale)
      ui.stars[i] = s
    end
  end
  return ui
end

class.getHeroCardByHero = getHeroCardByHero

local function getHeroCardByNormal(tid)
  if not tid then
    return
  end
  local ui = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local cardSize = CCSizeMake(242, 480)
  local frameres = card_frame[1]
  local nameres
  nameres = ed.getUnitArtName(tid)
  local namestr = ed.getDisplyName(tid)
  ui.container = container
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = frameres,
        z = 1,
        capInsets = CCRectMake(20, 20, 36.5, 310)
      },
      layout = {
        position = ccp(cardSize.width / 2, cardSize.height / 2 + 15)
      },
      config = {
        scaleSize = CCSizeMake(280, 497)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "frame_cdll",
        parent = "frame",
        res = "UI/alpha/1080P/card/card_line.png",
        z = 1
      },
      layout = {
        position = ccp(135, 70)
      },
      config = {
        fix_scale = {x = 0.9, y = 0.9}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "type",
        parent = "frame",
        res = typeres,
        z = 1
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(15, 45)
      },
      config = {
        fix_size = CCSizeMake(47, 42)
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        parent = "frame",
        text = namestr,
        size = 31,
        z = 1
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(65, 45)
      },
      config = {fix_height = 35}
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  ui.frame:setCascadeOpacityEnabled(true)
  local cardres, card, ci, height
  ui.card_fashion = {}
  ui.card_fashion_effect = {}
  ui.card_fashion_plist = {}
  cardres = ed.getUnitArt(tid)
  card, ci = ed.createClippingNode(cardres, "UI/alpha/1080P/common/art_mask.png", nil, CCSizeMake(-10, -8))
  height = ci:getContentSize().height
  card:setPosition(ui.frame:getPosition())
  card:setScale(cardSize.height / height)
  container:addChild(card)
  ui.card = card
  return ui
end

class.getHeroCardByNormal = getHeroCardByNormal

local function getHeroCard(tid, addition, hero)
  if not tid then
    return
  end
  local hero = hero or getHero(tid) or {}
  return getHeroCardByHero(hero, addition)
end

class.getHeroCard = getHeroCard

local function refreshHeroCard(ui, tid, addition)
  if not ui then
    return
  end
  addition = addition or {}
  if not tid then
    return
  end
  local hero = getHero(tid) or {}
  local rank = addition.rank or hero._rank or 1
  local star = addition.stars or hero._stars or (ed.getDataTable("Unit")[tid] or {})["Initial Stars"] or 0
  ui.frame:removeFromParentAndCleanup(true)
  local res = card_frame[rank]
  if hero:isTitan() then
    res = titan_card_frame[1]
  end
  local frame = ed.createSprite(res)
  frame:setAnchorPoint(ccp(0, 0))
  frame:setPosition(ccp(0, 0))
  ui.frame = frame
  ui.container:addChild(frame)
  ui.stars = ui.stars or {}
  local sx, sy = 22, 25
  local dx = 14
  local starRes = "UI/alpha/1080P/card/card_star_big.png"
  local starScale = 0.5
  for i = 1, star do
    if tolua.isnull(ui.stars[i]) then
      local s = ed.createSprite(starRes)
      s:setPosition(ccp(sx + dx * (i - 1), sy))
      ui.container:addChild(s, 6 - i)
      s:setScale(starScale)
      ui.stars[i] = s
    end
  end
end

class.refreshHeroCard = refreshHeroCard

local function getActor(unit_id, action_name, action_loop, awake, fashion_id, superAwake)
  local unit_row = ed.getDataTable("Unit")[unit_id]
  local cha_name = unit_row.Puppet
  local puppet_id = unit_row.Puppet
  if fashion_id and fashion_id ~= 0 then
    puppet_id = ed.getDataTable("Fashion")[fashion_id].Puppet
  end
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local cha_res = info.Resource
  local actor = ed.createFcaActor(cha_res, 1.5)
  local comps = info["Change Components"]
  if comps then
    for i = 1, #comps, 2 do
      actor:setComponent(comps[i], comps[i + 1])
    end
  end
  local usePlists = info.Plist
  local elements = info.Element
  if usePlists and elements then
    local SourcePositions = info["Source Position"]
    local PositionTypes = info["Position Type"]
    local EmissionRates = info["Emission Rate"]
    local enumPositionTypes = {
      Free = kCCPositionTypeFree,
      Relative = kCCPositionTypeRelative,
      Grouped = kCCPositionTypeGrouped
    }
    for i = 1, #usePlists do
      local particle = CCParticleSystemQuad:create("UI/particle/" .. usePlists[i] .. ".plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      local element = elements[i]
      actor:addNodeToComponent(particle, element, 1, t, true, true)
      if #SourcePositions ~= 0 and #PositionTypes ~= 0 and #EmissionRates ~= 0 then
        local px, py = tonumber(SourcePositions[i * 2 - 1]), tonumber(SourcePositions[i * 2])
        particle:setSourcePosition(ccp(px, py))
        particle:setPositionType(enumPositionTypes[PositionTypes[i]])
        local emissionRate = tonumber(EmissionRates[i])
        particle:setEmissionRate(emissionRate)
      end
    end
  end
  actor:setAction(action_name or "Idle")
  if action_loop == nil then
    action_loop = true
  end
  actor:setLoop(action_loop)
  actor:update(0)
  if not string.match(cha_res, "%.sp$") then
    cha_res = cha_res .. ".cha"
  end
  return actor, puppet_id, cha_res
end

class.getActor = getActor

local function getActorNew(unit_id, fashion_id, action_name, action_loop)
  local unit_row = ed.getDataTable("Unit")[unit_id]
  local cha_name = unit_row.Puppet
  local puppet_id = unit_row.Puppet
  if fashion_id and fashion_id ~= 0 then
    puppet_id = ed.getDataTable("Fashion")[fashion_id].Puppet
  end
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local actor = ed.createFcaActor(info.Resource, info.Scale)
  local comps = info["Change Components"]
  if comps then
    for i = 1, #comps, 2 do
      actor:setComponent(comps[i], comps[i + 1])
    end
  end
  local usePlists = info.Plist
  local elements = info.Element
  if usePlists and elements then
    local SourcePositions = info["Source Position"]
    local PositionTypes = info["Position Type"]
    local EmissionRates = info["Emission Rate"]
    local enumPositionTypes = {
      Free = kCCPositionTypeFree,
      Relative = kCCPositionTypeRelative,
      Grouped = kCCPositionTypeGrouped
    }
    for i = 1, #usePlists do
      local particle = CCParticleSystemQuad:create("UI/particle/" .. usePlists[i] .. ".plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      local element = elements[i]
      actor:addNodeToComponent(particle, element, 1, t, true, true)
      if #SourcePositions ~= 0 and #PositionTypes ~= 0 and #EmissionRates ~= 0 then
        local px, py = tonumber(SourcePositions[i * 2 - 1]), tonumber(SourcePositions[i * 2])
        particle:setSourcePosition(ccp(px, py))
        particle:setPositionType(enumPositionTypes[PositionTypes[i]])
        local emissionRate = tonumber(EmissionRates[i])
        particle:setEmissionRate(emissionRate)
      end
    end
  end
  actor:setAction(action_name or "Idle")
  if action_loop == nil then
    action_loop = true
  end
  actor:setLoop(action_loop)
  actor:update(0)
  return actor, cha_name
end

class.getActorNew = getActorNew

function class.getSkillIconRes(hid, slot, hero)
  local sgt = ed.getDataTable("SkillGroup")[hid]
  local res = sgt[slot].Icon
  return res
end

function class.getSkills(hid, slot)
  local sgt = ed.getDataTable("SkillGroup")[hid]
  local skid = sgt[slot]["Skill Group ID"]
  local tags = sgt[slot]["Skill Tags"]
  local sk = ed.getDataTable("Skill")[skid]
  local desc = sk[0].Description
  return {desc = desc, tags = tags}
end

function class:showDamageUpItem(ratio)
  if not tolua.isnull(self.damageUpNode) then
    self.damageUpNode:removeFromParentAndCleanup(true)
    self.damageUpNode = nil
  end
  local container, ui = ed.editorui(ed.uieditor.CampBossDamageUpItem)
  ui.bg:setPosition(ccp(0, 0))
  ui.bg:setScale(0.8)
  self.damageUpNode = container
  local size = self.icon:getContentSize()
  container:setPosition(ccp(size.width - 25, size.height - 5))
  self.icon:addChild(container, 12)
end

function class:showUsedTag()
  self.isUsed = true
  if self.ban and not tolua.isnull(self.ban) then
    self.ban:removeFromParentAndCleanup(true)
    self.ban = nil
  end
  self:addShade()
  local usedTag = ed.createttf(T("\228\184\141\229\143\175\231\148\168"), 12)
  usedTag:setAnchorPoint(ccp(0.5, 1))
  ed.setLabelColor(usedTag, ed.toccc3(16741231))
  ed.setLabelStroke(usedTag, ed.toccc3(461585), 1.5)
  local iconSize = self.icon:getContentSize()
  usedTag:setPosition(ccp(iconSize.width / 2, iconSize.height - 7))
  self.icon:addChild(usedTag, 12)
  self.usedTag = usedTag
end

function class:showPracticeUsedTag()
  local iconSize = self.icon:getContentSize()
  ed.createLabelTools({
    txt = T("\229\183\178\231\148\168"),
    size = 15,
    pos = ccp(iconSize.width - 14, iconSize.height - 8),
    color = ed.toccc3(16771375),
    stroke = {
      ed.toccc3(2565412),
      1.5
    },
    parent = self.icon,
    z = 12,
    font = ed.fontBold
  })
end

function class:deleteUsedTag()
  self.isUsed = false
  self:removeShade()
  if self.usedTag and not tolua.isnull(self.usedTag) then
    self.usedTag:removeFromParentAndCleanup(true)
    self.usedTag = nil
  end
end

class.deleteBanTag = deleteBanTag

function class.checkHeroMaxStar(hid)
  local hero = getHero(hid)
  if hero and hero._stars then
    return hero._stars == 5
  end
  return false
end

function class.getTypeRes(hid)
  local type = ed.getDataTable("Unit")[hid]["Hero Type"]
  if type == T("\229\138\155\233\135\143") then
    return "UI/alpha/1080P/herolist/icon_str.png"
  elseif type == T("\230\149\143\230\141\183") then
    return "UI/alpha/1080P/herolist/icon_agi.png"
  elseif type == T("\230\153\186\229\138\155") then
    return "UI/alpha/1080P/herolist/icon_int.png"
  end
end

function class.sortIDByRange(list, getIDfunc)
  local function attackRange(hid)
    local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
    
    return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0) or 0
  end
  
  table.sort(list, function(a, b)
    if nil ~= getIDfunc then
      return attackRange(getIDfunc(a)) < attackRange(getIDfunc(b))
    else
      return attackRange(a) < attackRange(b)
    end
  end)
  return list
end
