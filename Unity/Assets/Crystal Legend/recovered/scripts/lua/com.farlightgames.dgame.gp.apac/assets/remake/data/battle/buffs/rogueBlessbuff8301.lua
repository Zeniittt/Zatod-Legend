local function rogueBless8301update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  if owner.lastbasicskill ~= owner.basic_skill then
    owner.lastbasicskill = owner.basic_skill
    if ed.engine.rogueSkillMgr:getBless(8301) then
      local bless8301 = ed.engine.rogueSkillMgr.rogueBlessList[8301]
      owner.basic_skill.info = ed.wraptable(owner.basic_skill.info, {
        ["CRIT%"] = 100 + (bless8301.isReinforced and bless8301.info["Script Arg5"] or bless8301.info["Script Arg1"])
      })
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.lastbasicskill = owner.basic_skill
  buff.update = override(buff.update, rogueBless8301update)
  return buff
end

return initBuff
