local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local destinyInfo = ed.getDataTable("RogueDestiny")[6]
  buff.revelationratio = destinyInfo["Script Arg1"]
  if ed.engine.rogueSkillMgr:getBless(6314) then
    local bless6314 = ed.engine.rogueSkillMgr.rogueBlessList[6314]
    buff.timer = bless6314.isReinforced and bless6314.info["Script Arg5"] or bless6314.info["Script Arg1"]
  end
  local maxad = -math.huge
  local maxap = -math.huge
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if unit.config.is_summoned then
    else
      local ad = unit.attribs.AD
      if maxad < ad then
        maxad = ad
      end
      local ap = unit.attribs.AP
      if maxap < ap then
        maxap = ap
      end
    end
  end
  buff:setAttribute("HPR", (maxad + maxap) * buff.revelationratio)
  return buff
end

return initBuff
