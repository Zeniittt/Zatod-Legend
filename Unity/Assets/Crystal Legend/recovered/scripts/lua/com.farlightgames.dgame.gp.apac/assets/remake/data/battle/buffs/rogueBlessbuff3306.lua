local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(3)
  if ed.engine.rogueSkillMgr:getBless(3306) then
    local bless3306 = ed.engine.rogueSkillMgr.rogueBlessList[3306]
    buff:setAttribute("HP", amount * (bless3306.isReinforced and bless3306.info["Script Arg5"] or bless3306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
