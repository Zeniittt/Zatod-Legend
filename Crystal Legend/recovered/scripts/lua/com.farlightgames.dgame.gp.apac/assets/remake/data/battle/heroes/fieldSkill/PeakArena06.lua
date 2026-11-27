module("ed.battlehero", package.seeall)
local ed = ed
PeakArena06 = {}

function PeakArena06.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 31 or owner.info.ID == 2 or owner.info.ID == 35 or owner.info.ID == 21 or owner.info.ID == 39 then
    local bid = 80000009
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    buff2.shield = owner.attribs.HP * 0.3
    owner:addBuff(buff2, caster)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena06.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena06.createBuff)
  return skill
end

return PeakArena06.init_fieldSkill
