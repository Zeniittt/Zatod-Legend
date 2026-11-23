module("ed.battlehero", package.seeall)
local ed = ed
Dungeon8 = {}

function Dungeon8.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.dungeon8healtime = 20
  buff.update = override(buff.update, Dungeon8.Buff_update)
  buff.unremoveable = true
  return buff
end

function Dungeon8.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if owner.dungeon8healtime then
    owner.dungeon8healtime = owner.dungeon8healtime - dt
    if owner.dungeon8healtime <= 0 then
      owner:takeHeal(owner.attribs.HP * 0.25, "hp", owner)
      owner.dungeon8healtime = 20
    end
  end
end

function Dungeon8.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, Dungeon8.createBuff)
  return skill
end

return Dungeon8.init_fieldSkill
