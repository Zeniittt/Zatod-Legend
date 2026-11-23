module("ed.battlehero", package.seeall)
local ed = ed
Dungeon9 = {}

function Dungeon9.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 9 then
    buff:setAttribute("ALLIMU", 90)
    buff:setAttribute("DOTRES", 90)
    owner:rebuild()
  end
  buff.unremoveable = true
  return buff
end

function Dungeon9.Buff_update(basefunc, buff, dt)
end

function Dungeon9.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, Dungeon9.createBuff)
  return skill
end

return Dungeon9.init_fieldSkill
