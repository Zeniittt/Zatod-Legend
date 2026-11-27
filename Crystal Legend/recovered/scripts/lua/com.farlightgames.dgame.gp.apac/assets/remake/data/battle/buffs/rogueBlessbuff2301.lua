local function rogueBless2301update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  if owner.lastbasicskill ~= owner.basic_skill then
    owner.lastbasicskill = owner.basic_skill
    if ed.engine.rogueSkillMgr:getBless(2301) then
      local bless2301 = ed.engine.rogueSkillMgr.rogueBlessList[2301]
      local adratio = owner.basic_skill.info["Plus Ratio"]
      owner.basic_skill.info = ed.wraptable(owner.basic_skill.info, {
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Plus Ratio"] = bless2301.isReinforced and bless2301.info["Script Arg5"] or bless2301.info["Script Arg1"]
      })
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.lastbasicskill = owner.basic_skill
  buff.update = override(buff.update, rogueBless2301update)
  return buff
end

return initBuff
