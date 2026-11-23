local function rogueBless7301update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local caster = buff.caster
  local owner = buff.owner
  if owner.lastbasicskill ~= owner.basic_skill then
    owner.lastbasicskill = owner.basic_skill
    if ed.engine.rogueSkillMgr:getBless(7301) then
      local bless7301 = ed.engine.rogueSkillMgr.rogueBlessList[7301]
      owner.basic_skill.info["Ignore Shield"] = true
      local adratio = owner.basic_skill.info["Plus Ratio"]
      if bless7301.isReinforced then
        owner.basic_skill.info = ed.wraptable(owner.basic_skill.info, {
          ["Plus Ratio"] = adratio + bless7301.info["Script Arg5"]
        })
      end
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.lastbasicskill = owner.basic_skill
  buff.update = override(buff.update, rogueBless7301update)
  return buff
end

return initBuff
