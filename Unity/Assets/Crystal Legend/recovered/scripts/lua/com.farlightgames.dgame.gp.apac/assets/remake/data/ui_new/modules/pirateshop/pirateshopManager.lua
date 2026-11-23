local class = newclass("g")
ed.pirateshopManager = class
ed.UITool.registViewOpenFunc("pirateshopScene", function()
  local ds = ed.playerlimit.getAreaUnlockPrompt("PirateShop")
  if ds then
    ed.showToast(ds)
    return
  end
  if ReloadModule then
    ReloadModule("ui_new/modules/pirateshop/pirateshopScene")
  end
  ed.pirateshopNetwork.sendOpenPanel()
end)
class.ruleTxt = T("<br/><sprite src=UI/alpha/1080P/common/rivet_big.png>\232\190\190\229\136\17650\231\186\167\231\154\132\233\152\159\233\149\191\229\176\134\230\156\137\232\181\132\230\160\188\229\136\176\232\174\191\230\181\183\231\155\151\229\174\157\229\186\147\239\188\140\229\144\145\230\181\183\231\155\151\232\180\173\228\185\176\231\137\169\229\147\129\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\230\151\165\231\180\175\231\167\175\230\182\136\232\128\151720\231\130\185\228\189\147\229\138\155\229\143\175\228\187\165\232\142\183\229\190\151\228\184\128\229\188\160\232\151\143\229\174\157\229\155\190\239\188\140\230\182\136\232\128\151\228\184\128\229\188\160\232\151\143\229\174\157\229\155\190\229\143\175\228\187\165\229\136\183\230\150\176\229\174\157\229\186\147\228\184\173\231\154\132\231\137\169\229\147\129\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\189\147\233\152\159\233\149\191\230\139\165\230\156\1375\229\188\160\230\136\150\228\187\165\228\184\138\231\154\132\232\151\143\229\174\157\229\155\190\230\151\182\239\188\140\233\156\128\232\166\129\229\133\136\230\182\136\232\128\151\232\135\1795\229\188\160\228\187\165\228\184\139\230\137\141\229\143\175\228\187\165\229\156\168\229\174\157\229\186\147\228\184\173\233\162\134\229\143\150\230\150\176\231\154\132\232\151\143\229\174\157\229\155\190\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\181\183\231\155\151\229\174\157\229\186\147\229\136\183\230\150\176\229\135\186\231\154\132\231\137\169\229\147\129\239\188\140\228\184\142\233\152\159\233\149\191\229\189\147\229\137\141\231\154\132\229\133\187\230\136\144\232\191\155\229\186\166\231\155\184\229\133\179\227\128\130")

function class.tidyGoods(goods)
  local cfg = ed.getDataTable("PirateShopGoods")
  local newGoods = {}
  for i, v in ipairs(goods) do
    if cfg[v._group] and cfg[v._group][v._group_index] then
      table.insert(newGoods, {
        index = v._index,
        group = v._group,
        group_index = v._group_index,
        discount = v._discount,
        status = v._status,
        price_type = v._price_type,
        price_value = v._price_value,
        amount = cfg[v._group][v._group_index]["Item Amount"],
        price = cfg[v._group][v._group_index].Price,
        weight = cfg[v._group][v._group_index].Weight,
        priceType = cfg[v._group][v._group_index]["Price Type"],
        itemID = cfg[v._group][v._group_index]["Item ID"],
        red = class.getHeroRed(cfg[v._group][v._group_index]["Item ID"])
      })
    else
      print(" cfg no v._group : ", v._group)
      print(" cfg no v._group_index : ", v._group_index)
    end
  end
  return newGoods
end

function class:shopGoods(data)
  return {
    goods = class.tidyGoods(data._goods),
    reward_flag = data._reward_flag,
    vit_use = data._vit_use
  }
end

function class.getEquipIdFromTb(hid, slot, rank)
  local slotStr = string.format("Equip%d ID", slot)
  return ed.getDataTable("hero_equip")[hid][rank][slotStr]
end

function class.getHeroNeedEquipId(heroId, itemId, rank)
  for i = 1, 6 do
    if ed.player.heroes[heroId]:getEquipid(i) ~= 0 then
    else
      local targetId = class.getEquipIdFromTb(heroId, i, rank)
      if targetId == itemId then
        return true
      end
      local row = ed.getDataTable("equipcraft")[targetId]
      if row then
        for ii = 1, row.Components do
          local id = row["Component" .. ii]
          if id == itemId then
            return true
          end
        end
      end
    end
  end
end

function class.getHeros()
  return ed.player:getAllHero()
end

function class.getHeroRed(itemId)
  local serverTime = ed.getServerTime()
  for _, hero in pairs(ed.player:getAllHero()) do
    if ed.getDataTable("Unit")[hero._tid] and ed.readhero.isHeroOpen(hero._tid, serverTime) and class.getHeroNeedEquipId(hero._tid, itemId, hero._rank) then
      return true
    end
  end
  return false
end

function class.tidyHeros(itemId)
  local serverTime = ed.getServerTime()
  local heroes = {}
  for _, hero in pairs(ed.player:getAllHero()) do
    if ed.getDataTable("Unit")[hero._tid] and ed.readhero.isHeroOpen(hero._tid, serverTime) and class.getHeroNeedEquipId(hero._tid, itemId, hero._rank) then
      table.insert(heroes, hero)
    end
  end
  table.sort(heroes, ed.cmpSort({
    {
      getValue = function(hero)
        return ed.heroDetailManager:getLegendEquipUnlock(hero._tid) and 0 or 1
      end
    },
    {
      getValue = function(hero)
        return ed.player:isHeroCollect(hero._tid) and 0 or 1
      end
    },
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {
      getValue = function(hero)
        return ed.getDataTable("Unit")[hero._tid]["Initial Stars"]
      end,
      reverse = true
    },
    {key = "_gs", reverse = true},
    {key = "_tid"}
  }))
  local heros = {}
  for i, v in ipairs(heroes) do
    table.insert(heros, v._tid)
  end
  return heros
end

function class.npcRed(show)
  ed.pirateshopManager.redShow = show and show == 1
  local cfg = ed.getDataTable("PirateShopConfig")
  local itemId = cfg["Refresh Item"].Value[1]
  local free = cfg["Max free map"].Value[1]
  local count = ed.player:getEquipAmount(itemId) or 0
  if 5 <= count then
    ed.pirateshopManager.redShow = false
  end
  FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.PirateShop)
end
