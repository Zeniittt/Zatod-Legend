function ed.getEquipRow(id)
  local tb = ed.getDataTable("equip")
  
  return tb[id]
end

function ed.getEquipColumn(row, column)
  local tb = ed.getDataTable("equip")
  if tb[row] then
    return tb[row][column]
  end
  return nil
end

function ed.getEquipNameWithId(id)
  local row = ed.getEquipRow(id)
  if row then
    return row.Name
  end
  return nil
end
