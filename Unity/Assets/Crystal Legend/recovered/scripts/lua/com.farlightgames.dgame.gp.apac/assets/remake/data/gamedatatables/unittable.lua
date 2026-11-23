function ed.getUnitName(tid)
  local tb = ed.getDataTable("Unit")
  
  return ed.recoverColum(tb[tid].Name)
end

function ed.getUnitPuppet(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid].Puppet)
end

function ed.getPuppetResource(tid)
  local tb = ed.getDataTable("Puppet")
  return ed.recoverColum(tb[tid].Resource)
end

function ed.getUnitType(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Unit Type"])
end

function ed.getChessUnitType(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Unit Type"])
end

function ed.getUnitScript(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid].Script)
end

function ed.getUnitIconName(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Icon Name"])
end

function ed.getDisplyName(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Display Name"])
end

function ed.getUnitPortrait(tid)
  local tb = ed.getDataTable("Unit")
  if tb[tid] and tb[tid].Portrait then
    return ed.recoverColum(tb[tid].Portrait)
  end
  return nil
end

function ed.getUnitArt(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid].Art)
end

function ed.getUnitArtName(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Art Name"])
end

function ed.getUnitVoiceReady(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Voice Ready"])
end

function ed.getTitanArt(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Titan Art Switch"]), ed.recoverColum(tb[tid]["Titan Art Plist"]), tb[tid]["Titan Art Fca"]
end

function ed.getUnitVoiceMove(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Voice Move"])
end

function ed.getUnitVoiceatk(value)
  return ed.recoverColum(value)
end

function ed.getUnitVoiceUpgrade(tid, fashion)
  if fashion then
    local row = ed.getDataTable("Fashion")[fashion]
    if row then
      return ed.recoverColum(row["Voice Upgrade"])
    else
      local tb = ed.getDataTable("Unit")
      return ed.recoverColum(tb[tid]["Voice Upgrade"])
    end
  else
    local tb = ed.getDataTable("Unit")
    return ed.recoverColum(tb[tid]["Voice Upgrade"])
  end
end

function ed.getUnitPortraitSwitch2(tid)
  local tb = ed.getDataTable("Unit")
  if tb[tid] and tb[tid]["Portrait Switch2"] then
    return ed.recoverColum(tb[tid]["Portrait Switch2"])
  end
  return nil
end

function ed.getUnitPortraitSwitch(tid)
  local tb = ed.getDataTable("Unit")
  if tb[tid] and tb[tid]["Portrait Switch"] then
    return ed.recoverColum(tb[tid]["Portrait Switch"])
  end
  return nil
end

function ed.getUnitArtSwitch(tid)
  local tb = ed.getDataTable("Unit")
  return ed.recoverColum(tb[tid]["Art Switch"])
end

function ed.getUnitHeroTags(tid)
  local tb = ed.getDataTable("Unit")
  return tb[tid]["Hero Tags"]
end

function ed.getUnitHeroAwakeTags(tid)
  local tb = ed.getDataTable("Unit")
  return tb[tid]["Hero Awake Tags"]
end
