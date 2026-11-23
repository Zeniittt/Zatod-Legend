local class = ed.ui.market
local config = ed.ui.marketconfig
setfenv(1, class)

function dealRefresh(reply)
  if not reply then
    return
  end
  if reply._user_shop_list then
    ed.ShopMgr.getInstance():refreshMultiShopData(reply._user_shop_list)
    return
  end
  local handler, data = ed.getNetReply("refresh_shop")
  if data then
    local sid = data.id
    if data.type == 2 then
      local cost = ed.player:getShopRefreshCost(reply._user_shop._id)
      local ct = config.getRefreshCoinType(reply._user_shop._id)
      ed.player:addPoint(ct, -cost)
    end
  end
  ed.player:refreshShopData(reply._user_shop)
  if handler then
    handler(reply._can_switch, data.firstRefresh)
  end
end

function dealConsume(reply)
  if not reply then
    return
  end
  local result = reply._result == "success"
  local handler, data = ed.getNetReply("shop_consume")
  if data and data.shop then
    ed.player:increaseDailyjobCount({
      type = "ChooseShopToBuy",
      pid = data.shop,
      add = 1
    })
  end
  ed.player:increaseDailyjobCount({type = "ShopUse", add = 1})
  if handler then
    handler(result, data)
  end
end

function dealSimpleConsume(reply)
  if not reply then
    return
  end
  local result = reply._error_code == nil
  local handler, data = ed.getNetReply("simple_shop_reply")
  if data and data.shop then
    ed.player:increaseDailyjobCount({
      type = "ChooseShopToBuy",
      pid = data.shop,
      add = 1
    })
  end
  ed.player:increaseDailyjobCount({type = "ShopUse", add = 1})
  if handler then
    handler(result, data)
  end
end
