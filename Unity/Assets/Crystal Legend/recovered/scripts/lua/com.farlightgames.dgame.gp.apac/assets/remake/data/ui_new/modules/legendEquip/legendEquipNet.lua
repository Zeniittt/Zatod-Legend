local class = newclass("g")
ed.legendEquipNet = class
class.debug = false

function class.dispatch(reply)
  if class.debug then
    print("-------------legendEquipNet:replyReq--------------")
    ed.pt(reply)
  end
  local mgr = ed.legendEquipMgr.getInstance()
  if reply._equip then
    mgr:handleEquip(reply._equip)
  elseif reply._unequip then
    mgr:handleUnEquip(reply._unequip)
  elseif reply._starup then
    mgr:handleStarUp(reply._starup)
  elseif reply._rankup then
    mgr:handleRankUp(reply._rankup)
  elseif reply._recycle then
    mgr:handleRecycle(reply._recycle)
  elseif reply._forge_equip then
    mgr:handleForgeEquip(reply._forge_equip)
  elseif reply._unlock_queue then
    mgr:handleUnlockQueue(reply._unlock_queue, class.unlockQueueCostDiamond)
    class.unlockQueueCostDiamond = nil
  elseif reply._unlock_pos then
    mgr:handleUnlockPos(reply._unlock_pos, class.unlockPosCostInfo)
    class.unlockPosCostInfo = nil
  elseif reply._forge_panel then
    mgr:handleForgePanel(reply._forge_panel)
  elseif reply._lottery then
    mgr:handleLottery(reply._lottery)
  elseif reply._accelerate then
    mgr:handleAccelerate(reply._accelerate)
  elseif reply._one_key_forge then
    mgr:handleOneKeyForge(reply._one_key_forge)
  elseif reply._one_key_lottery then
    mgr:handleOneKeyLottery(reply._one_key_lottery)
  elseif reply._one_key_accelerate then
    mgr:handleOneKeyAccelerate(reply._one_key_accelerate)
  elseif reply._discard then
    mgr:handleDiscard(reply._discard)
  elseif reply._open_shop then
    mgr:openShop(reply._open_shop)
  elseif reply._buy_goods then
    FireEvent("legendEquipBuyGoods", reply._buy_goods)
    ed.player:addRewards(reply._buy_goods._rewards)
    local costType = ed.legendEquipNet.addGoods.costType
    local price = ed.legendEquipNet.addGoods.price
    local count = ed.legendEquipNet.addGoods.count
    local item = ed.legendEquipNet.addGoods.item
    if item._type == "legend_equip" then
      local equipCount = count
      local spCount = 0
      for i, v in ipairs(reply._buy_goods._rewards) do
        if v._type == "legend_equip" then
          equipCount = equipCount - v._amount
        else
          spCount = spCount + v._amount
        end
      end
      if equipCount ~= count and 0 < spCount then
        ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159\239\188\140\229\164\154\228\189\153\230\149\180\232\163\133\229\183\178\232\189\172\228\184\186\231\162\142\231\137\135"))
      elseif 0 < spCount then
        ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159\239\188\140\229\164\154\228\189\153\230\149\180\232\163\133\229\183\178\232\189\172\228\184\186\231\162\142\231\137\135"))
      else
        ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
      end
    else
      ed.showToast(T("\232\180\173\228\185\176\230\136\144\229\138\159"))
    end
    if costType == "Item" then
      local itemId = ed.getDataTable("LegendEquipForgeParam")["Forge Produce"]["Param Content 1"]
      ed.player:consumeEquip(itemId, price * count)
    elseif costType == "Diamond" then
      ed.player:addrmb(-price * count)
    elseif costType == "Gold" then
      ed.player:addMoney(-price * count)
    end
  elseif reply._synthesize then
    mgr:handleFragmentCompose(reply._synthesize)
  elseif reply._submit_task then
    mgr:handleSubmitTask(reply._submit_task)
  elseif reply._set_wish then
    mgr:handleSetWish(reply._set_wish)
  elseif reply._sell_fragement then
    mgr:handleSellFragment(reply._sell_fragement)
  elseif reply._query_task then
    mgr:handleQueryTask(reply._query_task)
  elseif reply._handbook then
    mgr:handleHandBook(reply._handbook)
  elseif reply._query_records then
    mgr:handleQueryRecords(reply._query_records)
  elseif reply._reset then
    mgr:handleEquipReset(reply._reset)
  elseif reply._buy_reset_times then
    mgr:handleBuyResetTimes(reply._buy_reset_times)
  end
end

function class.itemNotify(_legend_equip_item_notify)
  local mgr = ed.legendEquipMgr.getInstance()
  mgr:handleItemNotify(_legend_equip_item_notify)
end

function class.notify(_legend_equip_notify)
  local mgr = ed.legendEquipMgr.getInstance()
  mgr:handleNotify(_legend_equip_notify)
end

function class.createReq()
  local req = ed.upmsg.legend_equip_req()
  return req
end

function class.sendReq(req)
  if class.debug then
    print("-------------legendEquipNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "legend_equip")
end

function class.sendEquip(heroId, equipId)
  local req = class.createReq()
  req._equip = ed.upmsg.legend_equip_equip()
  req._equip._hero_id = heroId
  req._equip._id = equipId
  class.sendReq(req)
end

function class.sendUnEquip(heroId)
  local req = class.createReq()
  req._unequip = ed.upmsg.legend_equip_unequip()
  req._unequip._hero_id = heroId
  class.sendReq(req)
end

function class.sendStarUp(equipId)
  local req = class.createReq()
  req._starup = ed.upmsg.legend_equip_starup()
  req._starup._id = equipId
  class.sendReq(req)
end

function class.sendRankUp(equipId)
  local req = class.createReq()
  req._rankup = ed.upmsg.legend_equip_rankup()
  req._rankup._id = equipId
  class.sendReq(req)
end

function class.sendEquipRecycle(legendEquipIdList)
  local req = class.createReq()
  req._recycle = ed.upmsg.legend_equip_recycle()
  req._recycle._id = legendEquipIdList
  class.sendReq(req)
end

function class.sendEquipReset(equipId)
  local req = class.createReq()
  req._reset = ed.upmsg.legend_equip_reset()
  req._reset._id = equipId
  class.sendReq(req)
end

function class.sendBuyResetTimes()
  local req = class.createReq()
  req._buy_reset_times = ed.upmsg.legend_equip_buy_reset_times()
  class.sendReq(req)
end

function class.sendForgeEquip(queueId)
  local req = class.createReq()
  req._forge_equip = ed.upmsg.legend_equip_forge_equip()
  req._forge_equip._queue_id = queueId
  class.sendReq(req)
end

function class.sendUnlockQueue(queueId, costDiamond)
  local req = class.createReq()
  req._unlock_queue = ed.upmsg.legend_equip_unlock_queue()
  req._unlock_queue._queue_id = queueId
  class.unlockQueueCostDiamond = costDiamond
  class.sendReq(req)
end

function class.sendUnlockPos(queueId, pos, unlockPosCostInfo)
  local req = class.createReq()
  req._unlock_pos = ed.upmsg.legend_equip_unlock_pos()
  req._unlock_pos._queue_id = queueId
  req._unlock_pos._pos = pos
  class.unlockPosCostInfo = unlockPosCostInfo
  class.sendReq(req)
end

function class.sendForgePanel()
  local req = class.createReq()
  req._forge_panel = ed.upmsg.legend_equip_forge_panel()
  class.sendReq(req)
end

function class.sendLottery(queueId)
  local req = class.createReq()
  req._lottery = ed.upmsg.legend_equip_lottery()
  req._lottery._queue_id = queueId
  class.sendReq(req)
end

function class.sendAccelerate(queueId, items)
  local req = class.createReq()
  req._accelerate = ed.upmsg.legend_equip_accelerate()
  req._accelerate._queue_id = queueId
  req._accelerate._consume_items = items
  class.sendReq(req)
end

function class.sendOneKeyForge()
  local req = class.createReq()
  req._one_key_forge = ed.upmsg.legend_equip_one_key_forge()
  class.sendReq(req)
end

function class.sendOneKeyLottery()
  local req = class.createReq()
  req._one_key_open = ed.upmsg.legend_equip_one_key_lottery()
  class.sendReq(req)
end

function class.sendOneKeyAccelerate(queueId, items)
  local req = class.createReq()
  req._one_key_accelerate = ed.upmsg.legend_equip_one_key_accelerate()
  req._one_key_accelerate._queue_id = queueId
  req._one_key_accelerate._consume_items = items
  class.sendReq(req)
end

function class.sendDiscard(id, isDiscard)
  local req = class.createReq()
  req._discard = ed.upmsg.legend_equip_discard()
  req._discard._id = id
  req._discard._is_discard = isDiscard
  class.sendReq(req)
end

function class.sendOpenShop()
  local req = class.createReq()
  req._open_shop = ed.upmsg.legend_equip_open_shop()
  class.sendReq(req)
end

function class.sendBuyGoods(id, index, amount, addGoods)
  local req = class.createReq()
  req._buy_goods = ed.upmsg.legend_equip_buy_goods()
  req._buy_goods._group_id = id
  req._buy_goods._index = index
  req._buy_goods._amount = amount or 1
  class.sendReq(req)
  ed.legendEquipNet.addGoods = addGoods
end

function class.sendFragmentCompose(items)
  local req = class.createReq()
  req._synthesize = ed.upmsg.legend_equip_synthesize()
  req._synthesize._items = items
  class.sendReq(req)
end

function class.sendSubmitTask(taskId)
  local req = class.createReq()
  req._submit_task = ed.upmsg.legend_equip_submit_task()
  req._submit_task._task_id = taskId
  class.sendReq(req)
end

function class.sendSetWish(wishType, wishList)
  local req = class.createReq()
  req._set_wish = ed.upmsg.legend_equip_set_wish()
  req._set_wish._wish_type = wishType
  req._set_wish._wish_list = wishList
  class.sendReq(req)
end

function class.sendSellFragment(items)
  local req = class.createReq()
  req._sell_fragement = ed.upmsg.legend_equip_sell_fragement()
  req._sell_fragement._items = items
  class.sendReq(req)
end

function class.sendQueryTask()
  local req = class.createReq()
  req._query_task = ed.upmsg.legend_equip_query_task()
  class.sendReq(req)
end

function class.sendHandBook()
  local req = class.createReq()
  req._handbook = ed.upmsg.legend_equip_handbook()
  class.sendReq(req)
end

function class.sendQueryRecord()
  local req = class.createReq()
  req._query_records = ed.upmsg.legend_equip_query_records()
  class.sendReq(req)
end
