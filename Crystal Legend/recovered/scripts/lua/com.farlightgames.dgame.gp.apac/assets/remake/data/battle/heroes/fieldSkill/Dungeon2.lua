module("ed.battlehero", package.seeall)
local ed = ed
Dungeon2 = {}

function Dungeon2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 61 then
    buff:setAttribute("ALLIMU", 90)
    buff:setAttribute("DOTRES", 90)
    owner:rebuild()
  end
  buff.unremoveable = true
  return buff
end

function Dungeon2.Buff_update(basefunc, buff, dt)
end

function Dungeon2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, Dungeon2.createBuff)
  return skill
end

return Dungeon2.init_fieldSkill
