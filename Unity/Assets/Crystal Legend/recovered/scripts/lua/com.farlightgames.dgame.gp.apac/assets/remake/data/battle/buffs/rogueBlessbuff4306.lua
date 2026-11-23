local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(4)
  if ed.engine.rogueSkillMgr:getBless(4306) then
    local bless4306 = ed.engine.rogueSkillMgr.rogueBlessList[4306]
    buff:setAttribute("HPR", amount * (bless4306.isReinforced and bless4306.info["Script Arg5"] or bless4306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
