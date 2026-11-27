local function rogueBless1301update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  if owner.lastbasicskill ~= owner.basic_skill then
    owner.lastbasicskill = owner.basic_skill
    if ed.engine.rogueSkillMgr:getBless(1301) then
      local bless1301 = ed.engine.rogueSkillMgr.rogueBlessList[1301]
      local adratio = owner.basic_skill.info["Plus Ratio"]
      owner.basic_skill.info = ed.wraptable(owner.basic_skill.info, {
        ["Plus Ratio"] = adratio + (bless1301.isReinforced and bless1301.info["Script Arg5"] or bless1301.info["Script Arg1"])
      })
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.lastbasicskill = owner.basic_skill
  buff.update = override(buff.update, rogueBless1301update)
  return buff
end

return initBuff
