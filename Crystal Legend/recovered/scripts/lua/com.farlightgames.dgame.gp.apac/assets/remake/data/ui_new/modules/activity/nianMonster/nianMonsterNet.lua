local class = {}
ed.nianMonsterNet = class

function class.sendOpenPanel()
  local msg = ed.upmsg.nian_monster_req()
  msg._open_panel = {}
  ed.send(msg, "nian_monster")
end

function class.sendBuyItem(itemId, itemCnt)
  local msg = ed.upmsg.nian_monster_req()
  msg._buy_item = {}
  msg._buy_item._item_id = itemId
  msg._buy_item._item_cnt = itemCnt
  ed.send(msg, "nian_monster")
end

function class.dispatch(netReply)
  if netReply._open_panel then
    class.openPanelReply(netReply._open_panel)
  elseif netReply._buy_item then
    class.buyItemReply(netReply._buy_item)
  end
end

function class.notify(netReply)
  local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
  nianMonsterMgr:handleNotify(netReply)
end

function class.openPanelReply(_open_panel)
  local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
  nianMonsterMgr:handleOpenPanel(_open_panel)
end

function class.buyItemReply(_buy_item)
  local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
  nianMonsterMgr:handleBuyItem(_buy_item)
end
