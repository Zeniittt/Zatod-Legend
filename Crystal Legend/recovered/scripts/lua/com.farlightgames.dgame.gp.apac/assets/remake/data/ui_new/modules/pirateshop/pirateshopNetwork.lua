local class = newclass("g")
ed.pirateshopNetwork = class

function class.createReq()
  local req = ed.upmsg.pirate_shop_req()
  return req
end

function class.sendReq(req)
  ed.send(req, "pirate_shop")
end

function class.sendOpenPanel()
  local req = class.createReq()
  req._open_panel = ed.upmsg.pirate_shop_open_panel()
  class.sendReq(req)
end

function class.sendTakeMap()
  local req = class.createReq()
  req._take_map = ed.upmsg.pirate_shop_take_map()
  class.sendReq(req)
end

function class.sendRefreshShop()
  local req = class.createReq()
  req._refresh_shop = ed.upmsg.pirate_shop_refresh_shop()
  class.sendReq(req)
end

function class.sendBuyGoods(index, price, type)
  class.consumePrice = price
  class.consumeType = type
  local req = class.createReq()
  req._buy_goods = ed.upmsg.pirate_shop_buy_goods()
  req._buy_goods._index = index
  class.sendReq(req)
end

function class.dispatch(reply)
  if reply._open_panel then
    local data = ed.copyProto(reply._open_panel)
    data = ed.pirateshopManager:shopGoods(data)
    ed.pushScene(ed.ui.pirateshopScene.create(data))
  elseif reply._take_map then
    if reply._take_map._result == "success" then
      ed.player:addRewards(reply._take_map._rewards)
      ed.UITool.showRewardsFromServer(reply._take_map._rewards, nil, function()
        FireEvent("pirateshopSceneRefreshMap", {free = true})
        ed.pirateshopManager.npcRed(0)
      end)
    else
      ed.showToast(T("\233\162\134\229\143\150\229\164\177\232\180\165"))
    end
  elseif reply._refresh_shop then
    local cfg = ed.getDataTable("PirateShopConfig")
    local itemId = cfg["Refresh Item"].Value[1]
    ed.player:consumeEquip(itemId, 1)
    local data = ed.copyProto(reply._refresh_shop)
    data = ed.pirateshopManager.tidyGoods(data._goods)
    FireEvent("pirateshopSceneRefreshGoods", data)
    FireEvent("pirateshopSceneRefreshMap", {})
  elseif reply._buy_goods then
    ed.player:subPoint(class.consumeType, -1 * class.consumePrice)
    if reply._buy_goods._result == "success" then
      ed.player:addRewards(reply._buy_goods._rewards)
      ed.UITool.showRewardsFromServer(reply._buy_goods._rewards, nil, function()
        FireEvent("pirateshopSceneRefreshBuyGoods", reply._buy_goods)
      end)
    else
      ed.showToast(T("\232\180\173\228\185\176\229\164\177\232\180\165"))
    end
  end
end
