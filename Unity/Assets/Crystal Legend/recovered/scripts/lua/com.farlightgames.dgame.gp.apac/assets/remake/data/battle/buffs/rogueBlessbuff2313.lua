local function rogueBless2313update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    local perc = owner.hp / owner.attribs.HP
    perc = math.floor(perc * 100) * 0.01
    if ed.engine.rogueSkillMgr:getBless(2313) then
      local bless2313 = ed.engine.rogueSkillMgr.rogueBlessList[2313]
      local hpp = (bless2313.isReinforced and bless2313.info["Script Arg5"] or bless2313.info["Script Arg1"]) / 100
      if perc < hpp then
        buff.lastPerc = perc
        buff:setAttribute("MIMU", bless2313.isReinforced and bless2313.info["Script Arg6"] or bless2313.info["Script Arg2"])
        owner:rebuild()
      else
        buff:setAttribute("MIMU", 0)
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
  buff.update = override(buff.update, rogueBless2313update)
  return buff
end

return initBuff
