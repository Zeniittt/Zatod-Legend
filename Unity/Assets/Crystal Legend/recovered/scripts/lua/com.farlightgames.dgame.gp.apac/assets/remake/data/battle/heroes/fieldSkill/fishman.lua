module("ed.battlehero", package.seeall)
local ed = ed
fishman = {}
fishman.Fishman_buffID = 6174

function fishman.buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if (owner.info.ID == 14 or owner.info.ID == 10012) and not owner.buff_if then
    local Info = ed.lookupDataTable("Buff", nil, fishman.Fishman_buffID)
    local FishmanBuff = ed.BuffCreate(Info, owner, owner)
    FishmanBuff.shield = owner.attribs.HP * 3
    owner:addBuff(FishmanBuff, owner)
  end
  owner.buff_if = true
  basefunc(buff, dt)
end

function fishman.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, fishman.buff_update)
  return buff
end

function fishman.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, fishman.createBuff)
  return skill
end

return fishman.init_fieldSkill
