local function initBuff(buff)
  local caster = buff.caster
  
  local owner = buff.owner
  if ed.engine.rogueSkillMgr:getBless(5311) then
    local bless5311 = ed.engine.rogueSkillMgr.rogueBlessList[5311]
    buff:setAttribute("MSPD", bless5311.isReinforced and bless5311.info["Script Arg5"] or bless5311.info["Script Arg1"])
    buff.timer = bless5311.isReinforced and bless5311.info["Script Arg6"] or bless5311.info["Script Arg2"]
  end
  return buff
end

return initBuff
