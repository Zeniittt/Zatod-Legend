local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(11) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(11)
    local Arg = charmEffect.info["Script Arg" .. charmEffect.level]
    local count = 0
    for unit in ed.engine:foreachAliveUnit(owner.camp) do
      if unit.info["Main Attrib"] == "INT" then
        count = count + 1
      end
    end
    buff:setAttribute("APDP", Arg * count)
  end
  return buff
end

return initBuff
