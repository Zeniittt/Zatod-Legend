local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(6)
  if ed.engine.rogueSkillMgr:getBless(6306) then
    local bless6306 = ed.engine.rogueSkillMgr.rogueBlessList[6306]
    buff:setAttribute("DOTRES", amount * (bless6306.isReinforced and bless6306.info["Script Arg5"] or bless6306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
