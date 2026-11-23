local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getCharm(23) then
    local charmEffect = ed.engine.rogueSkillMgr:getCharm(23)
    local Arg = charmEffect.info["Script Arg" .. charmEffect.level] / 100
    local charm23count = 0
    for i = 1, 8 do
      local amount = ed.engine.rogueSkillMgr:getBlessAmount(i)
      if 0 < amount then
        charm23count = charm23count + 1
      end
    end
    local hppercent = owner.hp / owner.attribs.HP
    buff:setAttribute("HP", owner.attribs.HP * Arg * charm23count)
    buff:setAttribute("AD", owner.attribs.AD * Arg * charm23count)
    buff:setAttribute("AP", owner.attribs.AP * Arg * charm23count)
    buff:setAttribute("ARM", owner.attribs.ARM * Arg * charm23count)
    buff:setAttribute("MR", owner.attribs.MR * Arg * charm23count)
  end
  return buff
end

return initBuff
