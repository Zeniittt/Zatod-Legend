module("ed.battlehero", package.seeall)
local ed = ed
Dungeon5 = {}

function Dungeon5.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 24 then
    buff:setAttribute("ALLIMU", 90)
    buff:setAttribute("DOTRES", 90)
    owner:rebuild()
  end
  buff.unremoveable = true
  return buff
end

function Dungeon5.Buff_update(basefunc, buff, dt)
end

function Dungeon5.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, Dungeon5.createBuff)
  return skill
end

return Dungeon5.init_fieldSkill
