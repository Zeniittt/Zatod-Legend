local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  if owner.info["Main Attrib"] == "INT" and ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(13) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(13)
    local MPR = charmEffect.info["Script Arg" .. charmEffect.level]
    buff:setAttribute("MPR", MPR)
  end
  return buff
end

return initBuff
