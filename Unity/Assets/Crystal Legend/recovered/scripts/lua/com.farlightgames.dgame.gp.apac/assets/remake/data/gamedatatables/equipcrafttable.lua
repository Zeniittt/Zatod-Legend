function ed.getEquipCraftRow(id)
  local tb = ed.getDataTable("equipcraft")
  
  return tb[id]
end

function ed.getEquipCraftColumn(row, column)
  local tb = ed.getDataTable("equipcraft")
  if tb[row] then
    return tb[row][column]
  end
  return nil
end
