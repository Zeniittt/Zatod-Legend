local oldFunc = ed.getDataTable

function ed.getDataTable(table_name)
  local ret = oldFunc(table_name)
  return ret
end
