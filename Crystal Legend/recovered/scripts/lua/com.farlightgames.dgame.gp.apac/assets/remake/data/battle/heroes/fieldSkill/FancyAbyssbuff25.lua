module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff25 = {}

function FancyAbyssbuff25.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info["Position Type"] == T("\229\144\142\230\142\146") and owner.info.Element == "lightning" then
    buff:setAttribute("Effect", "eff_buff_fancybuff4_shield1.cha")
    buff.update = override(buff.update, FancyAbyssbuff25.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff25.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    if owner.info.ID == 59 then
      buff:setAttribute("APDP", 200)
    else
      buff:setAttribute("APDP", 100)
    end
    owner:rebuild()
  end
end

function FancyAbyssbuff25.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff25.createBuff)
  return skill
end

return FancyAbyssbuff25.init_fieldSkill
