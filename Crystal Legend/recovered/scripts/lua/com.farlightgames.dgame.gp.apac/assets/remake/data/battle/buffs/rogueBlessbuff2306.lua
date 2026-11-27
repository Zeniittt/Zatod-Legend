local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(2)
  if ed.engine.rogueSkillMgr:getBless(2306) then
    local bless2306 = ed.engine.rogueSkillMgr.rogueBlessList[2306]
    buff:setAttribute("AP", amount * (bless2306.isReinforced and bless2306.info["Script Arg5"] or bless2306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
