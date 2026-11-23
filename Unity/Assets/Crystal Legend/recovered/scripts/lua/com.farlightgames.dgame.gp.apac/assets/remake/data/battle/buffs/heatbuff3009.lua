local function heatbuff3009update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  if buff.dt >= 3 then
    buff.dt = 0
    local list = owner.buff_list
    local shiledbuff_list = {}
    local my_camp = caster.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and buff.caster and buff.caster.camp ~= my_camp and buff.info.Dispel == "YES" and buff.shield and 0 < buff.shield then
        shiledbuff_list[#shiledbuff_list + 1] = buff
      end
    end
    for i = 1, #shiledbuff_list do
      owner:removeBuff(shiledbuff_list[i])
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3009update)
  return buff
end

return initBuff
