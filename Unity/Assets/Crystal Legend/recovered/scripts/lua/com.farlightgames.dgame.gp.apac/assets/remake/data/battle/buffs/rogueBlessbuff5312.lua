local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  if ed.engine.rogueSkillMgr:getBless(5312) then
    local bless5312 = ed.engine.rogueSkillMgr.rogueBlessList[5312]
    buff:setAttribute("HAST", bless5312.isReinforced and bless5312.info["Script Arg5"] or bless5312.info["Script Arg1"])
    buff.timer = bless5312.isReinforced and bless5312.info["Script Arg6"] or bless5312.info["Script Arg2"]
  end
  return buff
end

return initBuff
