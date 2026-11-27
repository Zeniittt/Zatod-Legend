function ed.getSoloUnitScript(tid)
  local tb = ed.getDataTable("SoloUnit")
  
  return ed.recoverColum(tb[tid].Script)
end

function ed.getSoloDisplyName(tid)
  local tb = ed.getDataTable("SoloUnit")
  return ed.recoverColum(tb[tid]["Display Name"])
end

function ed.getSoloUnitPortrait(tid)
  local tb = ed.getDataTable("SoloUnit")
  if tb[tid] and tb[tid].Portrait then
    return ed.recoverColum(tb[tid].Portrait)
  end
  return nil
end

function ed.getSoloUnitFaction(tid)
  local tb = ed.getDataTable("SoloUnit")
  return tb[tid]["Recommended Faction"]
end
