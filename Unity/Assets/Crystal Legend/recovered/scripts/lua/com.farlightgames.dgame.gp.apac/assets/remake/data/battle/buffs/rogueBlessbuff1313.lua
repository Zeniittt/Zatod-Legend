local function rogueBless1313update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    local perc = owner.hp / owner.attribs.HP
    perc = math.floor(perc * 100) * 0.01
    if ed.engine.rogueSkillMgr:getBless(1313) then
      local bless1313 = ed.engine.rogueSkillMgr.rogueBlessList[1313]
      local hpp = (bless1313.isReinforced and bless1313.info["Script Arg5"] or bless1313.info["Script Arg1"]) / 100
      if perc < hpp then
        buff.lastPerc = perc
        buff:setAttribute("ADDP", bless1313.isReinforced and bless1313.info["Script Arg6"] or bless1313.info["Script Arg2"])
        owner:rebuild()
      else
        buff:setAttribute("ADDP", 0)
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
  buff.update = override(buff.update, rogueBless1313update)
  return buff
end

return initBuff
