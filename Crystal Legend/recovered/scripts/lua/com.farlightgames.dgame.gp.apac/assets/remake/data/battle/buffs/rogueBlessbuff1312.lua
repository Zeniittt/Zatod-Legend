local function rogueBless1312update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    local perc = 1 - owner.hp / owner.attribs.HP
    perc = math.floor(perc * 100) * 0.01
    if perc ~= buff.lastPerc then
      buff.lastPerc = perc
      if ed.engine.rogueSkillMgr:getBless(1312) then
        local bless1312 = ed.engine.rogueSkillMgr.rogueBlessList[1312]
        local ad = buff.oriad * (bless1312.isReinforced and bless1312.info["Script Arg5"] or bless1312.info["Script Arg1"]) / 100 * 100 * perc
        buff:setAttribute("AD", ad)
        owner:rebuild()
      end
    end
  end
  buff.attack_timer = timer
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.attack_timer = 1
  buff.lastPerc = 0
  buff.oriad = owner.attribs.AD
  buff.update = override(buff.update, rogueBless1312update)
  return buff
end

return initBuff
