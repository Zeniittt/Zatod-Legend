local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  local amount = ed.engine.rogueSkillMgr:getBlessAmount(1)
  if ed.engine.rogueSkillMgr:getBless(1306) then
    local bless1306 = ed.engine.rogueSkillMgr.rogueBlessList[1306]
    buff:setAttribute("AD", amount * (bless1306.isReinforced and bless1306.info["Script Arg5"] or bless1306.info["Script Arg1"]))
  end
  return buff
end

return initBuff
