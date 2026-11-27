function ed.getChestRow(id)
  local tb = ed.getDataTable("ChestCombination")
  
  return tb[id]
end

function ed.getChestColumn(row, column)
  local tb = ed.getDataTable("ChestCombination")
  if tb[row] then
    return tb[row][column]
  end
end
