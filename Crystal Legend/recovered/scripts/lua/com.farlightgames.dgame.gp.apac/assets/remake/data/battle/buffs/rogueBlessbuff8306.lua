local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(8)
  if ed.engine.rogueSkillMgr:getBless(8306) then
    local bless8306 = ed.engine.rogueSkillMgr.rogueBlessList[8306]
    buff:setAttribute("CSD", amount * (bless8306.isReinforced and bless8306.info["Script Arg5"] or bless8306.info["Script Arg1"]))
    buff:setAttribute("MCSD", amount * (bless8306.isReinforced and bless8306.info["Script Arg5"] or bless8306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
