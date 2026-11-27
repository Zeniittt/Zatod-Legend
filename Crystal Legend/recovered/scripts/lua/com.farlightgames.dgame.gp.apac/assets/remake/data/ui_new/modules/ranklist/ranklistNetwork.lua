local network, runMode = {}, ""
ed.rank_network = network

function network:sendLadderRank(mode, param)
  runMode = mode
  if mode == "pvp" or mode == "pvp_r" then
    local type = ""
    if mode == "pvp" then
      type = "static"
    elseif mode == "pvp_r" then
      type = "dynamic"
    end
    self.sendPvpRank(type)
  else
    self.sendRanklist(mode, param)
  end
end

function network.sendPvpRank(type)
  local msg = ed.upmsg.ladder()
  msg._query_rankboard = ed.upmsg.query_rankboard()
  msg._query_rankboard._type = type
  ed.send(msg, "ladder")
end

function network.sendRanklist(mode, param)
  local msg = ed.upmsg.query_ranklist()
  msg._rank_type = param.type
  msg._board_type = param.board
  msg._custom_data = param.custom
  ed.send(msg, "query_ranklist")
end

function network.sendLookCollectionReq(role_id, rank)
  network.rank = rank
  local msg = ed.upmsg.collection_point_req()
  msg._role_info = ed.upmsg.collection_point_role_info()
  msg._role_info._role_id = role_id
  ed.send(msg, "collection_point")
end

function network.sendSetCollectionHeroReq(hero_id)
  local msg = ed.upmsg.collection_point_req()
  msg._set_show = ed.upmsg.collection_point_set_show()
  msg._set_show._hero_id = hero_id
  ed.send(msg, "collection_point")
end
