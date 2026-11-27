local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(5)
  if ed.engine.rogueSkillMgr:getBless(5306) then
    local bless5306 = ed.engine.rogueSkillMgr.rogueBlessList[5306]
    buff:setAttribute("TEN", amount * (bless5306.isReinforced and bless5306.info["Script Arg5"] or bless5306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
