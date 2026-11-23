function ed.getChessUnitName(tid)
  local tb = ed.getDataTable("ChessUnit")
  
  return ed.recoverColum(tb[tid].Name)
end

function ed.getChessUnitPuppet(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid].Puppet)
end

function ed.getChessUnitType(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Unit Type"])
end

function ed.getChessUnitScript(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid].Script)
end

function ed.getChessUnitIconName(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Icon Name"])
end

function ed.getChestDisplyName(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Display Name"])
end

function ed.getChessUnitPortrait(tid)
  local tb = ed.getDataTable("ChessUnit")
  if tb[tid] and tb[tid].Portrait then
    return ed.recoverColum(tb[tid].Portrait)
  end
  return nil
end

function ed.getChessUnitArt(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid].Art)
end

function ed.getChessUnitArtName(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Art Name"])
end

function ed.getChessUnitVoiceReady(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Voice Ready"])
end

function ed.getChessUnitVoiceMove(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Voice Move"])
end

function ed.getChessUnitVoiceatk(value)
  return ed.recoverColum(value)
end

function ed.getChessUnitVoiceUpgrade(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Voice Upgrade"])
end

function ed.getChessUnitPortraitSwitch2(tid)
  local tb = ed.getDataTable("ChessUnit")
  if tb[tid] and tb[tid]["Portrait Switch2"] then
    return ed.recoverColum(tb[tid]["Portrait Switch2"])
  end
  return nil
end

function ed.getChessUnitPortraitSwitch(tid)
  local tb = ed.getDataTable("ChessUnit")
  if tb[tid] and tb[tid]["Portrait Switch"] then
    return ed.recoverColum(tb[tid]["Portrait Switch"])
  end
  return nil
end

function ed.getChessUnitArtSwitch(tid)
  local tb = ed.getDataTable("ChessUnit")
  return ed.recoverColum(tb[tid]["Art Switch"])
end

function ed.getChessUnitRaceTags(tid)
  local tb = ed.getDataTable("ChessUnit")
  return tb[tid]["Race Tag"]
end

function ed.getChessUnitAbilityTags(tid)
  local tb = ed.getDataTable("ChessUnit")
  return tb[tid]["Ability Tag"]
end

function ed.getChessUnitSellPrice(tid)
  local tb = ed.getDataTable("ChessUnit")
  return tb[tid]["Sell Price"]
end

function ed.getChessUnitBuyPrice(tid)
  local tb = ed.getDataTable("ChessUnit")
  return tb[tid]["Buy Price"]
end

function ed.getChessUnitStar(tid)
  local tb = ed.getDataTable("ChessUnit")
  return tb[tid]["Chess Stars"]
end
