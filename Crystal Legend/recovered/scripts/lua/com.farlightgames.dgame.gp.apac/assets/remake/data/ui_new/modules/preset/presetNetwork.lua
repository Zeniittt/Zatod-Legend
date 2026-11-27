local network = {}
ed.presetNetwork = network

function network.setLineupReq(idx, name, heros)
  local msg = ed.upmsg.preset_lineup_req()
  msg._set_lineup = ed.upmsg.preset_lineup_set_lineup()
  msg._set_lineup._id = idx
  msg._set_lineup._name = name
  msg._set_lineup._hero_ids = heros
  ed.presetNetwork.setLineupInfo = {
    idx = idx,
    name = name,
    heros = heros
  }
  ed.send(msg, "preset_lineup")
end

function network.deleteLineupReq(idx)
  local msg = ed.upmsg.preset_lineup_req()
  msg._delete_lineup = ed.upmsg.preset_lineup_delete_lineup()
  msg._delete_lineup._id = idx
  ed.presetNetwork.deleteLineupInfo = {idx = idx}
  ed.send(msg, "preset_lineup")
end

function network.switchLineupReq(idx1, idx2)
  local msg = ed.upmsg.preset_lineup_req()
  msg._switch_lineup = ed.upmsg.preset_lineup_switch_lineup()
  msg._switch_lineup._id1 = idx1
  msg._switch_lineup._id2 = idx2
  ed.presetNetwork.switchLineupInfo = {idx1 = idx1, idx2 = idx2}
  ed.send(msg, "preset_lineup")
end

function network.presetReply(info)
  local result, refreshIdx = true, 1
  if info._set_lineup and info._set_lineup._result == "success" then
    ed.presetData.refreshPreseInfo({
      setLineup = ed.presetNetwork.setLineupInfo
    })
    refreshIdx = ed.presetNetwork.setLineupInfo.idx
    ed.presetNetwork.setLineupInfo = nil
  elseif info._delete_lineup and info._delete_lineup._result == "success" then
    ed.presetData.refreshPreseInfo({
      deleteLineup = ed.presetNetwork.deleteLineupInfo
    })
    refreshIdx = ed.presetNetwork.deleteLineupInfo.idx
    ed.presetNetwork.deleteLineupInfo = nil
  elseif info._switch_lineup and info._switch_lineup._result == "success" then
    ed.presetData.refreshPreseInfo({
      switchLineup = ed.presetNetwork.switchLineupInfo
    })
    refreshIdx = ed.presetNetwork.switchLineupInfo.idx2
    ed.presetNetwork.switchLineupInfo = nil
  else
    ed.showToast("\232\174\190\231\189\174\229\164\177\232\180\165\239\188\129")
    result = false
  end
  if result then
    FireEvent("scene_preset_reply", {
      _set_lineup = info._set_lineup,
      _delete_lineup = info._delete_lineup,
      _switch_lineup = info._switch_lineup,
      refreshIdx = refreshIdx
    })
  end
end
