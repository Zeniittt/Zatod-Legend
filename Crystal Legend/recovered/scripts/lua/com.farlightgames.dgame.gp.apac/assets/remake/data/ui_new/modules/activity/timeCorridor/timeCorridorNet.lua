local timeCorridorNet = {}
timeCorridorNet.__index = timeCorridorNet
local printData = false
local instance

function timeCorridorNet.getInstance()
  if not instance then
    instance = timeCorridorNet.create()
  end
  return instance
end

function timeCorridorNet.create()
  local net = {}
  setmetatable(net, timeCorridorNet)
  return net
end

function timeCorridorNet:dispatch(data)
  if printData then
    print("----------------timeCorridorNet:dispatch-------------------")
    ed.pt(data)
  end
  if data._open_panel then
    ed.timeCorridorMgr:handleOpenPanel(data._open_panel)
  elseif data._summon then
    ed.timeCorridorMgr:handleSummonReply(data._summon)
  elseif data._buy_goods then
    ed.timeCorridorMgr:handleBuyGoodReply(data._buy_goods)
  elseif data._query_records then
    ed.timeCorridorMgr:handleRecordsReply(data._query_records)
  end
end

function timeCorridorNet:notify(data)
  if printData then
    print("----------------timeCorridorNet:notify-------------------")
    ed.pt(data)
  end
  ed.timeCorridorMgr:handleNotify(data)
end

function timeCorridorNet:createReq()
  local req = ed.upmsg.time_corridor_req()
  return req
end

function timeCorridorNet:doReq(req)
  if printData then
    print("-------------timeCorridorNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "time_corridor")
end

function timeCorridorNet:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = ed.upmsg.time_corridor_open_panel()
  self:doReq(req)
end

function timeCorridorNet:sendSummon(summonType)
  local req = self:createReq()
  req._summon = ed.upmsg.time_corridor_summon()
  req._summon._type = summonType
  self:doReq(req)
end

function timeCorridorNet:sendBuyGoods(index, amount)
  local good = ed.timeCorridorMgr:getGood(index)
  local needToken = good.tokenAmount * amount
  local token = 0
  local tokenName = ""
  if good.tokenType == "Item" then
    token = ed.player:getEquipAmount(ed.timeCorridorMgr.tokenId)
    tokenName = ed.getEquipNameWithId(ed.timeCorridorMgr.tokenId)
  elseif good.tokenType == "Diamond" then
    token = ed.player._rmb
    tokenName = T("\233\146\187\231\159\179")
  else
    token = ed.player:getPoint(item.tokenType) or 0
    tokenName = ed.getEquipNameWithId(ed.timeCorridorMgr.tokenId)
  end
  if needToken > token then
    return ed.showToast(T("%s\228\184\141\232\182\179", tokenName))
  end
  local req = self:createReq()
  req._buy_goods = ed.upmsg.time_corridor_buy_goods()
  req._buy_goods._index = index
  req._buy_goods._amount = amount
  self:doReq(req)
end

function timeCorridorNet:sendQueryRecords()
  local req = self:createReq()
  req._query_records = ed.upmsg.time_corridor_query_records()
  self:doReq(req)
end

ed.timeCorridorNet = timeCorridorNet.getInstance()
