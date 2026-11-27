local function rogueBless4314update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    local perc = 1 - owner.hp / owner.attribs.HP
    perc = math.floor(perc * 100) * 0.01
    if ed.engine.rogueSkillMgr:getBless(4314) then
      local bless4314 = ed.engine.rogueSkillMgr.rogueBlessList[4314]
      local hpp = (bless4314.isReinforced and bless4314.info["Script Arg5"] or bless4314.info["Script Arg1"]) / 100
      if perc < hpp then
        buff.lastPerc = perc
        buff:setAttribute("ADDP", bless4314.isReinforced and bless4314.info["Script Arg6"] or bless4314.info["Script Arg2"])
        buff:setAttribute("APDP", bless4314.isReinforced and bless4314.info["Script Arg6"] or bless4314.info["Script Arg2"])
        owner:rebuild()
      else
        buff:setAttribute("ADDP", 0)
        buff:setAttribute("APDP", 0)
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
  buff.update = override(buff.update, rogueBless4314update)
  return buff
end

return initBuff
