local lsr = ed.ui.frameworklsr.create()

local function getPetNum(name)
  if name == "gold_pet" then
    local petsInfo = ed.player:getPets()
    local cnt = 0
    for _, pet in pairs(petsInfo) do
      if pet:getColor() == 4 then
        cnt = cnt + 1
      end
    end
    return cnt
  elseif name == "purple_pet" then
    local petsInfo = ed.player:getPets()
    local cnt = 0
    for _, pet in pairs(petsInfo) do
      if pet:getColor() == 3 then
        cnt = cnt + 1
      end
    end
    return cnt
  elseif name == "blue_pet" then
    local petsInfo = ed.player:getPets()
    local cnt = 0
    for _, pet in pairs(petsInfo) do
      if pet:getColor() == 2 then
        cnt = cnt + 1
      end
    end
    return cnt
  end
end

local function getPointNum(name)
  return ed.player:getPoint(name) or 0
end

local function getItemNum(id)
  return ed.player:getEquipAmount(id) or 0
end

require("ui_new.modules.summon.summonManager")
local getResType = ed.ui.configs.resType.getResType
local bars = {
  diamond = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/diamond.png",
    scale = 1,
    initValue = getPointNum,
    doAccess = function()
      lsr:report("clickrmb")
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      elseif ed.getCurrentScene().identity == "RechargeScene" then
        if ed.open_third_pay or EDFLAGWIN32 then
          ed.third_pay:goPay()
        end
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "Diamonds"}))
      end
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {type = "diamond"})
    end
  },
  gold = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/gold.png",
    scale = 1,
    initValue = getPointNum,
    doAccess = function()
      lsr:report("clickMoney")
      local cpl = ed.playerlimit.getAreaUnlockPrompt("Midas")
      if cpl then
        ed.showToast(cpl)
        return
      end
      ed.ui.midasWin.create()
    end,
    getRedPointStatus = function()
      local freeTimes = ed.getDataTable("MonthCard").Payed["Free Midas Times"]
      if freeTimes > ed.player:getMidasTimes() and ed.player:isMonthCardValid("payed") then
        return true
      end
      return false
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {type = "gold"})
    end
  },
  vitality = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/vitality.png",
    scale = 1,
    initValue = function()
      return ed.player:getVitality()
    end,
    upperLimit = function()
      return ed.playerlimit.maxVitality()
    end,
    doAccess = function()
      lsr:report("clickVitality")
      if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
        ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167"))
      else
        ed.ui.buyVitalityBox.create()
      end
    end
  },
  crusadepoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/money_crusadepoint_new.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        type = "crusadepoint"
      })
    end
  },
  arenapoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/money_arenatoken_big.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {type = "arenapoint"})
    end
  },
  guildpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/money_guildtoken_new.png",
    scale = 1,
    initValue = getPointNum
  },
  raid_point = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/money_guildtoken_new.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {type = "raid_point"})
    end
  },
  dreampoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/money_dreampoint_new.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {type = "dreampoint"})
    end
  },
  wood = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/wood.png",
    scale = 1,
    initValue = getPointNum
  },
  iron = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/iron.png",
    scale = 1,
    initValue = getPointNum
  },
  crystal = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/crystal.png",
    scale = 1,
    initValue = getPointNum
  },
  gcwpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/gcwpoint.png",
    scale = 1,
    initValue = getPointNum
  },
  summonpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/soulchest_ticket.png",
    scale = 1,
    itemId = ed.summonMgr:getNormalCfgConstant("Use Ticket"),
    initValue = getItemNum,
    doAccess = function()
      local ticketId = ed.summonMgr:getNormalCfgConstant("Use Ticket")
      local ticketCost = ed.summonMgr:getNormalCfgConstant("Ticket Value")
      local buyResourceBox = ed.ui.buyResourceBox.create({
        defaultBuyNum = 10,
        goodsResType = getResType("item"),
        goodsId = ticketId,
        costResType = getResType("diamond"),
        price = ticketCost,
        buyAction = function(num)
          ed.summonNet:send("buy_ticket", {_ticket_amount = num, _type = "normal"})
        end
      })
      buyResourceBox.ui.text_buy_num_limit:setVisible(false)
      buyResourceBox:popWindow()
    end
  },
  destinyticket = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/destiny_ticket.png",
    scale = 1,
    itemId = ed.getDataTable("SummonDestinyConfig")["Use Ticket"].Value,
    initValue = getItemNum,
    doAccess = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "Gift"}))
      end
    end
  },
  timelysummonpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/summontimely_ticket.png",
    scale = 1,
    itemId = ed.getDataTable("SummonCircleConfig")["Timely Ticket"].Value,
    initValue = getItemNum,
    doAccess = function()
      local ticketId = ed.getDataTable("SummonCircleConfig")["Timely Ticket"].Value
      local ticketCost = ed.getDataTable("SummonCircleConfig")["Timely Ticket Value"].Value
      local buyResourceBox = ed.ui.buyResourceBox.create({
        defaultBuyNum = 10,
        goodsResType = getResType("item"),
        goodsId = ticketId,
        costResType = getResType("diamond"),
        price = ticketCost,
        buyAction = function(num)
          ed.summonNet:send("buy_ticket", {_ticket_amount = num, _type = "timely"})
        end
      })
      buyResourceBox.ui.text_buy_num_limit:setVisible(false)
      buyResourceBox:popWindow()
    end
  },
  legendpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/legend_pvp_coin.png",
    scale = 1,
    initValue = getPointNum
  },
  adventurepoint = {
    icon = nil,
    smallIcon = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return ed.adventureDefine.getAdventureTokenSmallRes(actAdventureMgr:getOpenActId())
    end,
    scale = 1,
    initValue = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return actAdventureMgr:getAdventureToken(actAdventureMgr:getOpenActId()) or 0
    end
  },
  adventurevitality = {
    icon = nil,
    smallIcon = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return ed.adventureDefine.getAdventureVitalitySmallRes(actAdventureMgr:getOpenActId())
    end,
    scale = 1,
    initValue = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return actAdventureMgr:getAdventureVitality(actAdventureMgr:getOpenActId()) or 0
    end,
    upperLimit = function()
      return ed.adventureDefine.VITALITY_UPPER_LIMIT
    end,
    doAccess = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      local actId = actAdventureMgr:getOpenActId()
      local actAdventureCfg = ed.getDataTable("ActivityAdventure")[actId]
      local vitalityId = actAdventureCfg["Vitality ID"]
      local price = actAdventureCfg["Vitality Price"]
      local buyLimit = actAdventureCfg["Vitality Buy Times"]
      local currentBuyTimes = actAdventureMgr:getVitalityBuyTimes(actId)
      local buyResourceBox = ed.ui.buyResourceBox.create({
        buyLimitNum = math.max(buyLimit - currentBuyTimes, 0),
        defaultBuyNum = 1,
        goodsResType = getResType("item"),
        goodsId = vitalityId,
        costResType = getResType("diamond"),
        price = price,
        buyAction = function(num)
          if num > math.max(buyLimit - currentBuyTimes, 0) then
            ed.showToast(T("\232\182\133\229\135\186\232\180\173\228\185\176\230\172\161\230\149\176\228\184\138\233\153\144"))
            return
          end
          ed.actiAdventureNet.buyVitality(actId, num)
          ed.actiAdventureNet.openPanel()
        end
      })
      buyResourceBox:setOwnLabelVisible(false)
      buyResourceBox:popWindow()
    end
  },
  awakestagevitality = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/dungeon_energy.png",
    bgRes = "UI/alpha/1080P/dungeon/dungeon_energy_bg.png",
    scale = 1,
    initValue = function()
      local dungeonMgr = ed.awakeDungeonMgr.getInstance()
      return dungeonMgr:getCurVitality()
    end,
    upperLimit = function()
      local dungeonMgr = ed.awakeDungeonMgr.getInstance()
      return dungeonMgr:getMaxVitality()
    end,
    doAccess = function()
      ed.UITool.openView("awakeDungeonBuyEnergy")
    end
  },
  shard_point = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/shard.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {type = "ShardPoint"})
    end
  },
  peakarenapoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/peakshop.png",
    scale = 1,
    initValue = function()
      return ed.PeakArenaManager.coins
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        type = "peakarenapoint"
      })
    end
  },
  guildclashpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/guildclash_coin_new.png",
    scale = 1,
    itemId = function()
      if ed.GuildClashManager then
        return ed.GuildClashManager:getSeasonShopCoinID()
      end
    end,
    initValue = getItemNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        id = ed.GuildClashManager:getSeasonShopCoinID(),
        type = "item"
      })
    end
  },
  purple_pet_point = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/pet/pet_purple_token.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        type = "PurplePetPoint"
      })
    end
  },
  blue_pet_point = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/pet/pet_blue_token.png",
    scale = 1,
    initValue = getPointNum,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        type = "BluePetPoint"
      })
    end
  },
  gold_pet = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/pet/pet_count_gold.png",
    scale = 1,
    initValue = getPetNum
  },
  purple_pet = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/pet/pet_count_purple.png",
    scale = 1,
    initValue = getPetNum
  },
  blue_pet = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/pet/pet_count_blue.png",
    scale = 1,
    initValue = getPetNum
  },
  guildmountpoint = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/icon/guildmount_coin_new.png",
    scale = 1,
    initValue = function()
      return ed.GuildMountManager.coins
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        type = "guildmountpoint"
      })
    end
  },
  cosmeticcurrencyorange = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png",
    scale = 1,
    itemId = 20269,
    initValue = function()
      return ed.player:getEquipAmount(20269) or 0
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {id = 20269, type = "item"})
    end,
    doAccess = function()
      ed.pushScene(ed.ui.RechargeScene.create({page = "Gift", giftItemId = 20269}))
    end
  },
  cosmeticcurrencyblue = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png",
    scale = 1,
    itemId = 20270,
    initValue = function()
      return ed.player:getEquipAmount(20270) or 0
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {id = 20270, type = "item"})
    end
  },
  timecorridortoken = {
    icon = nil,
    smallIcon = function()
      return ed.timeCorridorMgr:getTokenSmallIconRes()
    end,
    scale = 1,
    itemId = function()
      return ed.timeCorridorMgr.tokenId
    end,
    initValue = function()
      return ed.player:getEquipAmount(ed.timeCorridorMgr.tokenId) or 0
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        id = ed.timeCorridorMgr.tokenId,
        type = "item"
      })
    end
  },
  tavern_point = {
    icon = nil,
    smallIcon = "UI/alpha/1080P/tavern/tavern_token.png",
    scale = 1,
    initValue = function()
      return ed.player:getPoint("tavern_point")
    end,
    showDetail = function()
      ed.UITool.openView("packageDetail", {
        type = "TavernPoint"
      })
    end
  },
  legendequippoint = {
    icon = nil,
    bgRes = "UI/alpha/1080P/fireforge/resource_board.png",
    smallIcon = function()
      return "UI/alpha/1080P/fireforge/art3.png"
    end,
    scale = 1,
    itemId = function()
      return ed.getDataTable("LegendEquipForgeParam")["Forge Produce"]["Param Content 1"]
    end,
    initValue = function()
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Produce"]["Param Content 1"]
      return ed.player:getEquipAmount(itemId) or 0
    end,
    showDetail = function()
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Produce"]["Param Content 1"]
      ed.UITool.openView("packageDetail", {id = itemId})
    end,
    doAccess = function()
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Produce"]["Param Content 1"]
      ed.UITool.openView("packageDetail", {id = itemId})
    end
  },
  legend_equip_forge_item = {
    icon = nil,
    bgRes = "UI/alpha/1080P/fireforge/resource_board.png",
    smallIcon = function()
      return "UI/alpha/1080P/fireforge/art1.png"
    end,
    scale = 1,
    itemId = function()
      return ed.getDataTable("LegendEquipForgeParam")["Forge Need"]["Param Content 1"]
    end,
    initValue = function()
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Need"]["Param Content 1"]
      return ed.player:getEquipAmount(itemId) or 0
    end,
    showDetail = function()
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Need"]["Param Content 1"]
      ed.UITool.openView("packageDetail", {id = itemId})
    end,
    doAccess = function()
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Need"]["Param Content 1"]
      ed.UITool.openView("packageDetail", {id = itemId})
    end
  }
}
local common = {"diamond", "gold"}
local sceneBars = {
  common = common,
  mainScene = {
    "diamond",
    "gold",
    "vitality"
  },
  summonScene = {
    "diamond",
    "summonpoint",
    "destinyticket",
    "timelysummonpoint"
  },
  package = {
    "diamond",
    "gold",
    "vitality"
  },
  heroPackage = {
    "diamond",
    "gold",
    "vitality"
  },
  crusade = {"gold"},
  taskScene = {"gold", "diamond"},
  stageselect = {"diamond", "vitality"},
  equipStrengthen = common,
  pvp = common,
  debuglogin = common,
  GuildMainScene = common,
  GuildJoinScene = common,
  shopGold = {"diamond", "gold"},
  shopArena = {"arenapoint"},
  shopDream = {"dreampoint"},
  shopLegend = {
    "legendpoint"
  },
  shopGuild = {"raid_point"},
  shopShard = {
    "shard_point"
  },
  shopCrusade = {
    "crusadepoint"
  },
  shopTavern = {
    "tavern_point"
  },
  heroDetailScene = {"gold"},
  GuildRaidMainScene = {"diamond", "vitality"},
  RechargeScene = {"diamond"},
  adventureStageScene = {
    "adventurePoint",
    "adventureVitality"
  },
  awakeDungeonScene = {
    "awakestagevitality"
  },
  awakeDungeonGridMapScene = {
    "awakestagevitality"
  },
  PeakArenaShopScene = {
    "peakarenapoint"
  },
  fireworkShopScene = {"gold"},
  guildClashShopScene = {
    "guildClashPoint"
  },
  PetMainScene = {
    "gold_pet",
    "purple_pet",
    "blue_pet"
  },
  GuildMountShopScene = {
    "guildMountPoint"
  },
  shopCosmetic = {
    "cosmeticcurrencyorange",
    "cosmeticcurrencyblue"
  },
  timeCorridorShopScene = {
    "timeCorridorToken",
    "diamond"
  },
  legendEquipShopScene = {
    "diamond",
    "legendEquipPoint"
  },
  fireForgeMainScene = {
    "legendEquipPoint",
    "legend_equip_forge_item"
  },
  pirateshopScene = {"diamond"}
}
local config = {
  getResBarConfig = function(name)
    return bars[string.lower(name)]
  end,
  getSceneBarsConfig = function(identity)
    return sceneBars[identity]
  end,
  getResBarConfigItem = function(name, key)
    if nil == name then
      return nil
    end
    local config = bars[string.lower(name)]
    if nil == config then
      return nil
    end
    local val = config[key]
    if nil == val then
      return nil
    end
    if type(val) == "function" then
      return val()
    else
      return val
    end
  end
}
return config
