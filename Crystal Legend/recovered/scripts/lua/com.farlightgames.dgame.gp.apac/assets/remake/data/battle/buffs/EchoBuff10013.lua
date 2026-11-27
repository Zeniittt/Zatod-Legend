local function Echobuff10013_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local target = buff.owner
  local caster = buff.caster
  if not buff.haseffect then
    buff.haseffect = true
    local hp = target.attribs.HP * 0.1
    local reduce = 0
    if target.name == "HeatBossQOP" then
      reduce = 0.2
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.info.ID == 20050121 then
          reduce = 0.25
        end
        if tbuff.info.ID == 20050122 then
          reduce = 0.3
        end
        if tbuff.info.ID == 20050123 then
          reduce = 0.35
        end
        if tbuff.info.ID == 20050124 then
          reduce = 0.4
        end
      end
    end
    target:takeDamage(hp / (1 - reduce), "Holy", "hp", caster)
    buff.timer = -1
  end
end

local function initBuff(buff)
  local caster = buff.caster
  buff.haseffect = false
  buff.update = override(buff.update, Echobuff10013_update)
  return buff
end

return initBuff
