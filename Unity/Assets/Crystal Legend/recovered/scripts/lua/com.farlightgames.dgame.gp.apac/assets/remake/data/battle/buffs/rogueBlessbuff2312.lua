local function rogueBless2312update(basefunc, buff, dt)
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
      if ed.engine.rogueSkillMgr:getBless(2312) then
        local bless2312 = ed.engine.rogueSkillMgr.rogueBlessList[2312]
        local ap = buff.oriap * (bless2312.isReinforced and bless2312.info["Script Arg5"] or bless2312.info["Script Arg1"]) / 100 * 100 * perc
        buff:setAttribute("AP", ap)
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
  buff.oriap = owner.attribs.AP
  buff.update = override(buff.update, rogueBless2312update)
  return buff
end

return initBuff
