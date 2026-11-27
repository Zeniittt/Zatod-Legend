function ed.getVipLevel(rechargeSum)
  local tb = ed.getDataTable("VIP")
  
  local rsum = rechargeSum or 0
  local dv = 0
  local max = 0
  local index = 0
  while tb[index] do
    local vsum = tb[index].Recharge
    if rsum < vsum then
      dv = vsum - rsum
      max = vsum
      return index - 1, dv, max
    else
      index = index + 1
    end
  end
  index = index - 1
  local vsum = tb[index].Recharge
  return index, math.max(vsum - rsum, 0), vsum
end
