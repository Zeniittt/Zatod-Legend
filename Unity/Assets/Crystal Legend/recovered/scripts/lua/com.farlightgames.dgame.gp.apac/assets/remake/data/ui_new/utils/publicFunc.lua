local icon_res = {
  playerexp = "UI/alpha/1080P/icon/team_exp.png",
  diamond = "UI/alpha/1080P/icon/diamond_icon.png",
  rmb = "UI/alpha/1080P/icon/diamond_icon.png",
  gold = "UI/alpha/1080P/icon/gold_icon.png",
  money = "UI/alpha/1080P/icon/gold_icon.png",
  actpoint = "UI/alpha/1080P/icon/battlepass_exp.png",
  arenapoint = "UI/alpha/1080P/icon/pvppoint_icon.jpg",
  pvpmoney = "UI/alpha/1080P/icon/money_arenatoken_big.png",
  coin = "UI/alpha/1080P/icon/gold_icon.png",
  vitality = "UI/alpha/1080P/icon/vitality_icon.png",
  guildcoin = "UI/alpha/HVGA/money_guildtoken_small.png",
  monthlycardperiod = "UI/alpha/HVGA/recharge_monthlycard_1.png",
  crusadepoint = "UI/alpha/1080P/icon/money_crusadepoint_icon.png",
  honourpoint = "UI/alpha/HVGA/money_top_pvp_small.png",
  dreampoint = "UI/alpha/1080P/icon/money_dreampoint_icon.png",
  legendpoint = "UI/alpha/HVGA/legend_pvp/legend_pvp_coin.png",
  energybean = "UI/alpha/1080P/crusade/energbean_icon.png",
  freemonthcard = "UI/alpha/1080P/icon/freemonthcard.png",
  free_monthcard = "UI/alpha/1080P/icon/freemonthcard.png",
  achievement = "UI/alpha/1080P/icon/achievement.png",
  raidpoint = "UI/alpha/1080P/icon/money_guildtoken_icon.png",
  raid_point = "UI/alpha/1080P/icon/money_guildtoken_icon.png",
  adventurepoint = function()
    local actAdventureMgr = ed.actiAdventureMgr.getInstance()
    return ed.adventureDefine.getAdventureTokenInfo(actAdventureMgr:getOpenActId()).tokenIconPath
  end,
  taskcount = "UI/alpha/1080P/activity/seven_day/seven_day_point_1.png",
  strawberry = "UI/alpha/1080P/activity/sweet_party/sweet_party_strawberry_item.png",
  guildenergy = "UI/alpha/HVGA/guild/guild_loot_coin.png",
  energy = "UI/alpha/HVGA/GuildHero/guildhero_energy.png",
  exp = "UI/alpha/HVGA/task_exp_icon_2.png",
  crusademoney = "UI/alpha/HVGA/money_dragonscale_big.png",
  topPvpmoney = "UI/alpha/HVGA/money_top_pvp_big.png",
  guildmoney = "UI/alpha/HVGA/money_guildtoken_big.png",
  skillpoint = "UI/alpha/HVGA/herodetail_skill_upgrade_button_1.png",
  vipexp = "UI/alpha/HVGA/task_vip_exp_icon.png",
  dreamlandmoney = "UI/alpha/HVGA/money_dreampoint_big.png",
  starpoint = "UI/alpha/HVGA/stargate/money_stargate.png",
  peakmedal = "UI/alpha/1080P/toparena/peakarena_medal.png",
  medal = function(id)
    local cfg
    for _, v in pairs(ed.getDataTable("Medal")) do
      if id == v.MedalID then
        cfg = v
        break
      end
    end
    return cfg.IconPicture
  end,
  shardpoint = "UI/alpha/1080P/icon/shard_icon.jpg",
  shardpointdaily = "UI/alpha/1080P/icon/shard_icon.jpg",
  shard_point = "UI/alpha/1080P/icon/shard_icon.jpg",
  peakarenapoint = "UI/alpha/1080P/icon/peakshop_icon.jpg",
  guildmountpoint = "UI/alpha/1080P/icon/guildmount_coin_icon.jpg",
  pearl = "UI/alpha/1080P/icon/pearl_icon.jpg",
  tavern_point = "UI/alpha/1080P/tavern/tavern_token_icon.jpg",
  guildavataframe = function(id)
    local cfg = {}
    for _, v in pairs(ed.getDataTable("GuildAvatarFrame")) do
      if id == v.ID then
        cfg = v
        break
      end
    end
    if cfg and cfg.Icon then
      return cfg.Icon
    else
      print(" cfg is nil id=", id)
      ed.pt(cfg)
    end
    return ""
  end,
  legendpoint = "UI/alpha/1080P/fireforge/DayAwards/point_icon.jpg",
  simple_pass_exp = function(simplePassId)
    local simplePassExpId = ed.getDataTable("SimplePass")[simplePassId].SimplePassExp
    return ed.getDataTable("SimplePassExp")[simplePassExpId].Icon
  end
}
ed.pointRes = icon_res
local typeConvert = {
  purple_pet_point = "PurplePetPoint",
  purplepetpoint = "PurplePetPoint",
  blue_pet_point = "BluePetPoint",
  bluepetpoint = "BluePetPoint",
  tavern_point = "TavernPointRaw",
  tavernpointraw = "TavernPointRaw"
}
ed.typeConvert = typeConvert
local resToIconId = {
  diamond = 20049,
  gold = 20050,
  crusadepoint = 20051,
  guildcoin = 20052,
  arenapoint = 20053,
  dreampoint = 20054,
  playerexp = 20055,
  actpoint = 20056
}
ed.resToIconId = resToIconId
local frame_res = {
  "white",
  "green",
  "blue",
  "purple",
  "purple",
  "orange",
  "red",
  "pink",
  "prismatic"
}
local quality = {
  playerexp = 1,
  diamond = 4,
  rmb = 4,
  gold = 2,
  actpoint = 1,
  coin = 2,
  vitality = 1,
  guildcoin = 1,
  monthlycardperiod = 1,
  crusadepoint = 1,
  honourpoint = 1,
  dreampoint = 1,
  legendpoint = 1,
  arenapoint = 1,
  pvpmoney = 1,
  energybean = 5,
  money = 1,
  freemonthcard = 6,
  achievement = 1,
  raidpoint = 1,
  raid_point = 1,
  taskcount = 1,
  strawberry = 1,
  adventurepoint = 1,
  peakmedal = 1,
  medal = 6,
  shardpoint = 4,
  shardpointdaily = 4,
  shard_point = 4,
  peakarenapoint = 4,
  guildmountpoint = 4,
  pearl = 4,
  TavernPointRaw = 4,
  guildavataframe = function(id)
    local cfg
    for _, v in pairs(ed.getDataTable("GuildAvatarFrame")) do
      if id == v.ID then
        cfg = v
        break
      end
    end
    if cfg and cfg.Quality then
      return cfg.Quality
    else
      print(" cfg is nil id=", id)
      ed.pt(cfg)
    end
    return 1
  end,
  legendpoint = 1,
  simple_pass_exp = 1
}
ed.toKenQuality = quality
local virtual_name = {
  playerexp = T("\230\136\152\233\152\159\231\187\143\233\170\140"),
  diamond = T("\233\146\187\231\159\179"),
  rmb = T("\233\146\187\231\159\179"),
  gold = T("\233\135\145\229\184\129"),
  actpoint = T("\230\136\152\232\175\129\231\187\143\233\170\140"),
  coin = T("\231\161\172\229\184\129"),
  vitality = T("\228\189\147\229\138\155"),
  guildcoin = T("\229\133\172\228\188\154\229\184\129"),
  monthlycardperiod = T("\230\156\136\229\141\161"),
  crusadepoint = T("\231\186\162\233\190\153\233\128\134\233\179\158"),
  honourpoint = T("\232\141\163\232\170\137\231\130\185"),
  dreampoint = T("\230\162\166\228\185\139\230\150\176\229\143\182"),
  legendpoint = T("\229\155\190\228\190\139\231\130\185"),
  guildpoint = T("\229\133\172\228\188\154\229\184\129"),
  arenapoint = T("\231\171\158\230\138\128\229\156\186\229\184\129"),
  pvpmoney = T("\231\171\158\230\138\128\229\184\129"),
  energybean = T("\232\131\189\233\135\143\232\175\149\229\137\130"),
  raid_point = T("\229\133\172\228\188\154\229\184\129"),
  freemonthcard = T("\230\176\184\228\185\133\230\156\136\229\141\161"),
  free_monthcard = T("\230\176\184\228\185\133\230\156\136\229\141\161"),
  raidpoint = T("\229\133\172\228\188\154\229\184\129"),
  money = T("\233\135\145\229\184\129"),
  achievement = T("\230\136\144\229\176\177\231\130\185"),
  adventurepoint = function()
    local actAdventureMgr = ed.actiAdventureMgr.getInstance()
    return ed.adventureDefine.getAdventureTokenInfo(actAdventureMgr:getOpenActId()).tokenName
  end,
  taskcount = T("\228\187\187\229\138\161\231\130\185"),
  strawberry = T("\229\165\182\230\178\185\232\141\137\232\142\147"),
  peakmedal = T("\229\183\133\229\179\176\229\139\139\231\171\160"),
  medal = function(id)
    local cfg
    for _, v in pairs(ed.getDataTable("Medal")) do
      if id == v.MedalID then
        cfg = v
        break
      end
    end
    if cfg and cfg.Name then
      return cfg.Name
    else
      print(" cfg is nil id=", id)
      ed.pt(cfg)
    end
    return ""
  end,
  shard_point = "\232\167\137\233\134\146\229\184\129",
  shardpointdaily = "\232\167\137\233\134\146\229\184\129",
  shardpoint = "\232\167\137\233\134\146\229\184\129",
  peakarenapoint = T("\229\183\133\229\179\176\233\147\182\229\184\129"),
  guildmountpoint = T("\232\174\168\228\188\144\229\139\139\231\171\160"),
  guildClashPoint = T("\229\133\172\228\188\154\230\136\152\229\184\129"),
  tavern_point = T("\233\133\146\233\166\134\229\165\150\229\136\184"),
  pearl = T("\231\143\141\231\143\160"),
  guildavataframe = function(id)
    local cfg
    for _, v in pairs(ed.getDataTable("GuildAvatarFrame")) do
      if id == v.ID then
        cfg = v
        break
      end
    end
    if cfg and cfg.Name then
      return cfg.Name
    else
      print(" cfg is nil id=", id)
      ed.pt(cfg)
    end
    return ""
  end,
  legendpoint = T("\228\188\160\229\165\135\229\144\175\231\168\139\231\130\185"),
  simple_pass_exp = function(simplePassId)
    local simplePassExpId = ed.getDataTable("SimplePass")[simplePassId].SimplePassExp
    return ed.getDataTable("SimplePassExp")[simplePassExpId]["Token Name"]
  end
}
ed.virtualName = virtual_name

local function getVirtualName(key, id)
  local tb = ed.getDataTable("Token")
  if tb[typeConvert[key]] then
    return tb[typeConvert[key]]["Token Name"]
  end
  if type(ed.virtualName[key]) == "function" then
    return ed.virtualName[key](id)
  else
    return ed.virtualName[key]
  end
end

ed.getVirtualName = getVirtualName

local function getIconRes(key, id)
  local tb = ed.getDataTable("Token")
  if tb[typeConvert[key]] then
    return tb[typeConvert[key]].Icon
  end
  if type(icon_res[key]) == "function" then
    return icon_res[key](id)
  else
    return icon_res[key]
  end
end

ed.getIconRes = getIconRes

local function createIconDefaultBgWithPath(path)
  local bg = ed.createSprite(path)
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  return bg
end

local function createItemIcon(data, nameTab, scale)
  local item = {
    type = data.type or "item",
    id = data.id,
    amount = data.amount or data.count or 1
  }
  local icon, equip, amountLabel
  local typeLwr = string.lower(item.type)
  if typeLwr == "item" or typeLwr == "equip" or typeLwr == "hero" and item.id then
    icon, equip, amountLabel = ed.readequip.createIconWithAmount(item.id, 60, item.amount)
    if typeLwr == "hero" then
      equip:setScale(0.95)
    end
  elseif typeLwr == "legend_equip" or typeLwr == "legendequip" then
    icon, equip, amountLabel = ed.readequip.createBasicLegendEquipIcon(item.id, item.amount)
    local iconSize = icon:getContentSize()
    icon:setScale(60 / iconSize.width)
  elseif typeLwr == "risestarpoint" then
    icon, equip, amountLabel = ed.readequip.createIconWithAmount(item.id, 60, item.amount)
    local iconSize = icon:getContentSize()
    icon:setScale(60 / iconSize.width)
    equip:setPositionY(equip:getPositionY() - 1)
    equip:setScale(0.98)
  elseif ed.getIconRes(typeLwr, item.id) then
    if resToIconId[typeLwr] then
      icon, equip, amountLabel = ed.readequip.createIconWithAmount(resToIconId[typeLwr], 60, item.amount)
      if typeLwr == "hero" then
        equip:setScale(0.98)
      end
    else
      icon = ed.createSprite(ed.getIconRes(typeLwr, item.id))
      local qualityId = 1
      local tb = ed.getDataTable("Token")
      if tb[typeConvert[typeLwr]] then
        qualityId = tb[typeConvert[typeLwr]].Quality or 1
      else
        qualityId = quality[typeLwr]
        if qualityId and type(qualityId) == "function" then
          qualityId = qualityId(data.id)
        end
      end
      qualityId = 0 < qualityId and qualityId or 1
      if qualityId and frame_res[qualityId] then
        local equip = createIconDefaultBgWithPath("UI/alpha/1080P/common/frame/equip_frame_" .. frame_res[qualityId] .. ".png")
        local bgsize = equip:getContentSize()
        icon:setPosition(bgsize.width / 2, bgsize.height / 2)
        equip:addChild(icon, -1)
        icon = equip
      end
      icon:setScale(0.67)
      if item.amount > 1 then
        local bgsize = icon:getContentSize()
        amountLabel = ed.createttf(item.amount, 16)
        amountLabel:setAnchorPoint(ccp(1, 0))
        ed.setLabelColor(amountLabel, ccc3(255, 251, 231))
        ed.setLabelStroke(amountLabel, ccc3(39, 37, 36), 2)
        amountLabel:setPosition(bgsize.width - 10, 10)
        amountLabel:setScale(1 / icon:getScale())
        icon:addChild(amountLabel)
      end
    end
  else
    print("icon_res no res : " .. typeLwr)
  end
  if amountLabel then
    icon.amountLabel = amountLabel
  end
  if nameTab then
    nameTab = type(nameTab) == "table" and nameTab or {}
    local nameStr = ed.readequip.value(item.id, "Name") or typeLwr
    if typeLwr == "hero" then
      if ed.getDataTable("Unit")[item.id] then
        nameStr = ed.getDataTable("Unit")[item.id]["Display Name"] or nameStr
      end
    elseif typeLwr == "legend_equip" or typeLwr == "legendequip" then
      nameStr = ed.getDataTable("LegendEquip")[item.id]["Equip Name"]
    elseif typeLwr == "risestarpoint" then
      nameStr = T("\230\181\129\229\133\137\229\190\174\231\178\146")
    end
    local name = nameTab.name or ed.getVirtualName(typeLwr, item.id) or nameStr
    local label = ed.createttf(name, nameTab.size or 16)
    label:setPosition(nameTab.pos or ccp(45, -6))
    label:setColor(nameTab.color or ccc3(249, 210, 102))
    icon:addChild(label)
    return icon, label
  end
  if scale then
    icon:setScale(scale)
  end
  return icon or ed.createSprite()
end

ed.createItemIcon = createItemIcon

local function overlapping(data)
  local newTbas = {}
  local newItem = {}
  local i = 1
  for k, v in pairs(data or {}) do
    local key = v.id and v.id > 0 and v.id or v.type
    if newTbas[key] then
      newItem[newTbas[key]].amount = newItem[newTbas[key]].amount + v.amount
    else
      newItem[i] = {
        id = v.id,
        type = v.type,
        amount = v.amount,
        toMax = v.toMax or false
      }
      newTbas[key] = i
      i = i + 1
    end
  end
  return newItem
end

ed.overlapping = overlapping

local function overrun(data)
  data = ed.copyTable(data or {})
  local itemIdKeyToNum = {}
  
  local function toMaxAmount(v)
    local key = v.id and v.id > 0 and v.id or v.type
    itemIdKeyToNum[key] = itemIdKeyToNum[key] or 0
    local new, maxAmount
    if v.id and v.id > 0 then
      maxAmount = ed.player:getItemMaxAmount(v.id)
      new = (ed.player.equip_qunty[v.id] or 0) + itemIdKeyToNum[key]
    elseif v.type and v.type ~= "hero" then
      maxAmount = ed.player:getItemMaxAmount(nil, v.type)
      new = ed.player:getPoint(v.type) + itemIdKeyToNum[key]
    end
    local ca = new + v.amount - maxAmount
    if ca <= 0 then
      itemIdKeyToNum[key] = itemIdKeyToNum[key] + v.amount
      return v.amount, 0
    end
    itemIdKeyToNum[key] = itemIdKeyToNum[key] + (maxAmount - new)
    return maxAmount - new, ca
  end
  
  local geftItem = {}
  local exceedItem = {}
  for i, v in ipairs(data or {}) do
    v.amount = v.amount or v.count
    local giveNum, noGiveNum = toMaxAmount(v)
    if noGiveNum == 0 then
      table.insert(geftItem, v)
    elseif giveNum == 0 then
      v.toMax = true
      table.insert(exceedItem, v)
    else
      table.insert(geftItem, {
        id = v.id,
        type = v.type,
        amount = giveNum
      })
      table.insert(exceedItem, {
        id = v.id,
        type = v.type,
        amount = noGiveNum,
        toMax = true
      })
    end
  end
  geftItem = overlapping(geftItem)
  exceedItem = overlapping(exceedItem)
  local giveItemAll = setmetatable({}, {
    __add = function(mytab, newtab)
      for i, v in ipairs(newtab) do
        table.insert(mytab, v)
      end
      return mytab
    end
  })
  giveItemAll = giveItemAll + geftItem
  giveItemAll = giveItemAll + exceedItem
  return geftItem, exceedItem, giveItemAll
end

ed.itemExceeds = overrun
local itemType = {raid_point = "RaidPoint", shard_point = "ShardPoint"}

local function mailItemTidy(item)
  item = item and ed.copyTable(item) or {}
  for i, v in ipairs(item) do
    v.type = itemType[v.type] or v.type
  end
  return item
end

ed.mailItemTidy = mailItemTidy

function ed.numberFormat(num, limit)
  if num == nil or type(num) ~= "number" then
    return 0
  end
  if num < 10000 then
    return num
  elseif EDCurLanguage == "en" or EDCurLanguage == "es" then
    return string.format("%sK", num / 10000 * 10)
  else
    return T("%s\228\184\135", num / 10000)
  end
end

function ed.createSpriteTools(params)
  local sprite
  if params.rectMake then
    sprite = ed.createScale9Sprite(params.res or "", params.rectMake)
    if params.sizeMake then
      sprite:setContentSize(params.sizeMake)
    end
  else
    sprite = ed.createSprite(params.res or "")
  end
  if params.pos then
    sprite:setPosition(params.pos)
  end
  if params.scale then
    sprite:setScale(params.scale)
  end
  if params.parent then
    if params.z then
      params.parent:addChild(sprite, params.z)
    else
      params.parent:addChild(sprite)
    end
  end
  if params.anchor then
    sprite:setAnchorPoint(params.anchor)
  end
  if params.notShow then
    sprite:setVisible(false)
  end
  if params.opacity then
    sprite:setOpacity(params.opacity)
  end
  return sprite
end

function ed.createLabelTools(params)
  local label = ed.createttf(T(params.txt or ""), params.size or 15, params.font or ed.font)
  if params.anchor then
    label:setAnchorPoint(params.anchor)
  end
  if params.pos then
    label:setPosition(params.pos)
  end
  if params.color then
    label:setColor(params.color)
  end
  if params.shadow then
    label:setShadow(params.shadow[1], params.shadow[2] or ccp(0, 2))
  end
  if params.stroke then
    label:setStroke(params.stroke[1], params.stroke[2] or 1)
  end
  if params.scale then
    label:setScale(params.scale)
  end
  if params.parent then
    if params.z then
      params.parent:addChild(label, params.z)
    else
      params.parent:addChild(label)
    end
  end
  if params.notShow then
    label:setVisible(false)
  end
  if not params.condition or params.condition.horizontal then
  end
  return label
end

function ed.createCCLayer(params)
  local layer = params.color and CCLayerColor:create(params.color) or CCLayer:create()
  if params.anchor then
    layer:setAnchorPoint(params.anchor)
  end
  if params.pos then
    layer:setPosition(params.pos)
  end
  if params.scale then
    layer:setScale(params.scale)
  end
  if params.sizeMake then
    layer:setContentSize(params.sizeMake)
  end
  if params.parent then
    if params.z then
      params.parent:addChild(layer, params.z)
    else
      params.parent:addChild(layer)
    end
  end
  if params.notShow then
    layer:setVisible(false)
  end
  return layer
end

local fashion_frame_color = {
  "white",
  "green",
  "blue",
  "purple",
  "purple",
  "orange",
  "red",
  "pink",
  "prismatic"
}
local fashion_frame_color_globe = {
  "",
  "",
  "R",
  "SR",
  "SR",
  "SSR",
  "SP",
  "SSP",
  "UR"
}
ed.fashionQualityName = {
  "",
  "",
  T("\231\168\128\230\156\137"),
  T("\229\143\178\232\175\151"),
  T("\229\143\178\232\175\151"),
  T("\228\188\160\232\175\180"),
  "\228\184\141\230\156\189",
  T("\231\165\158\232\175\157"),
  T("\229\133\184\232\151\143")
}

function ed.getFashionFrameRes(fashionId, type)
  local fasQuality = ed.lookupDataTable("Fashion", "Quality", fashionId)
  local color = fashion_frame_color[fasQuality] or fashion_frame_color[1]
  if type == "Frame" then
    return string.format("UI/alpha/1080P/skin/skin_frame_%s.png", color)
  elseif type == "nameFrame" then
    return string.format("UI/alpha/1080P/skin/skin_name_frame_%s.png", color)
  elseif type == "qualityBg" then
    return string.format("UI/alpha/1080P/skin/skin_quality_bg_%s.png", color)
  elseif type == "FrameMini" then
    return string.format("UI/alpha/1080P/skin/skin_small_frame_%s.png", color)
  elseif type == "fashionNameBg" then
    return string.format("UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_name_bg_%s.png", color)
  elseif type == "show" then
    return ed.lookupDataTable("Fashion", "Show Icon", fashionId)
  elseif type == "fashionShopItemBg" then
    return string.format("UI/alpha/1080P/shop/cosmetic/shop_cosmetic_skin_bg_%s.png", color)
  elseif type == "fashionNameBg_Globe" then
    return string.format("UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_name_bg_%s.png", fashion_frame_color_globe[fasQuality] or fashion_frame_color_globe[3])
  end
end

function ed.getFashionFrameResByQuality(Quality, type)
  local color = fashion_frame_color[Quality] or fashion_frame_color[1]
  if type == "Frame" then
    return string.format("UI/alpha/1080P/skin/skin_frame_%s.png", color)
  elseif type == "nameFrame" then
    return string.format("UI/alpha/1080P/skin/skin_name_frame_%s.png", color)
  elseif type == "avatarFrame" then
    return string.format("UI/alpha/1080P/common/frame/equip_frame_%s.png", color)
  elseif type == "qualityBg" then
    return string.format("UI/alpha/1080P/skin/skin_quality_bg_%s.png", color)
  elseif type == "FrameMini" then
    return string.format("UI/alpha/1080P/skin/skin_small_frame_%s.png", color)
  elseif type == "fashionNameBg" then
    return string.format("UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_name_bg_%s.png", color)
  elseif type == "fashionShopItemBg" then
    return string.format("UI/alpha/1080P/shop/cosmetic/shop_cosmetic_skin_bg_%s.png", color)
  elseif type == "fashionNameBg_Globe" then
    return string.format("UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_name_bg_%s.png", fashion_frame_color_globe[Quality] or fashion_frame_color_globe[3])
  elseif type == "fashionRewardItemBg" then
    if Quality < 3 then
      color = fashion_frame_color[3]
    end
    if color == "orange" then
      color = "golden"
    end
    return string.format("UI/alpha/1080P/summon/hero_%s_bg.png", color)
  elseif type == "fashionRewardCardBg" then
    if Quality < 2 then
      color = fashion_frame_color[2]
    end
    if color == "orange" then
      color = "golden"
    end
    return string.format("UI/alpha/1080P/summon/tavern_get_hero_bg_%s.png", color)
  end
end

ed.fashionFrameNameFun = {
  [3] = function(parent, pos, size)
    return ed.createLabelTools({
      txt = ed.isAreaZh() and "\231\168\128\230\156\137" or "R",
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#4552d6")),
        1
      },
      parent = parent
    })
  end,
  [4] = function(parent, pos, size)
    return ed.createLabelTools({
      txt = ed.isAreaZh() and "\229\143\178\232\175\151" or "SR",
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#7b0bd1")),
        1
      },
      parent = parent
    })
  end,
  [6] = function(parent, pos, size)
    return ed.createLabelTools({
      txt = ed.isAreaZh() and "\228\188\160\232\175\180" or "SSR",
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#d1680b")),
        1
      },
      parent = parent
    })
  end,
  [7] = function(parent, pos, size)
    return ed.createLabelTools({
      txt = ed.isAreaZh() and "\228\184\141\230\156\189" or "SP",
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#d1680b")),
        1
      },
      parent = parent
    })
  end,
  [8] = function(parent, pos, size)
    return ed.createLabelTools({
      txt = ed.isAreaZh() and "\231\165\158\232\175\157" or "SSP",
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#c14bd3")),
        1
      },
      parent = parent
    })
  end,
  [9] = function(parent, pos, size)
    return ed.createLabelTools({
      txt = ed.isAreaZh() and "\229\133\184\232\151\143" or "UR",
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#d34b95")),
        1
      },
      parent = parent
    })
  end
}

function ed.createFashionFrameName(quality)
  return ed.fashionFrameNameFun[quality] or function(parent, pos, size)
    return ed.createLabelTools({
      txt = T("\231\154\174\232\130\164"),
      size = size or 22,
      font = ed.fontBold,
      anchor = ccp(0.5, 0.5),
      pos = pos or ccp(20, 20),
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#d1680b")),
        1
      },
      parent = parent
    })
  end
end
