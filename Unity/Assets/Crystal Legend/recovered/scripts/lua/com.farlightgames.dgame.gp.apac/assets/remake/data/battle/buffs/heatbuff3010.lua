local function heatbuff3010update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  local buffid = buff.info.ID
  local level = buffid - 20030100
  if buff.dt == 1 then
    buff.dt = 0
    for unit in ed.engine:foreachAliveUnit(-owner.camp) do
      unit.heatbuff3010 = false
      for i, tbuff in ipairs(unit.buff_list) do
        if tbuff.info.ID == 20030106 then
          unit.heatbuff3010 = true
        end
      end
      if not unit.heatbuff3010 then
        local bid = 20030106
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, unit, caster)
        buff:setAttribute("HPR", -150 * level)
        unit:addBuff(buff, caster)
      end
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, heatbuff3010update)
  return buff
end

return initBuff
