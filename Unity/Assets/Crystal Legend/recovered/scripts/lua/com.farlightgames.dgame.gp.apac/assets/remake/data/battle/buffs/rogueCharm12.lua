local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local basichp = owner.attribs.HP
  local basicap = owner.attribs.AP
  local hp = owner.hp
  local hpper = hp / basichp
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(12) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(12)
    local APArg = charmEffect.info["Script Arg" .. charmEffect.level]
    local HPArg = charmEffect.info["Script Arg" .. charmEffect.level + 3]
    buff:setAttribute("AP", basichp * APArg)
    buff:setAttribute("HP", basicap * HPArg)
    owner:takeHeal(basichp * APArg * hpper, "hp", owner, "rogueCharm12")
  end
  return buff
end

return initBuff
