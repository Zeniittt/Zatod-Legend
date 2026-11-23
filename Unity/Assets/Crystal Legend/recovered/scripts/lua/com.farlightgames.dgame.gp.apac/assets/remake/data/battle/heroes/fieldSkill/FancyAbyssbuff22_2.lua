module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff22_2 = {}

function FancyAbyssbuff22_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, FancyAbyssbuff22_2.Buff_update)
  local waveId = ed.engine.wave_id or 1
  if waveId == 1 then
    owner.fancy22effect = false
    owner.fancy22time = 0
    owner.fancy22ratio = 1
  end
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff22_2.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.fancy22time and owner.fancy22time < 6 then
    owner.fancy22time = owner.fancy22time + dt
    owner.fancy22ratio = 1 + owner.fancy22time / 10
  end
  if owner.fancy22time >= 6 then
    owner.fancy22ratio = 2
    if owner.fancy22effect == false then
      local bid = 6224
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, owner, caster)
      owner:addBuff(buff, caster)
      owner.fancy22effect = true
      buff.unremoveable = true
    end
  end
end

function FancyAbyssbuff22_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff22_2.createBuff)
  return skill
end

return FancyAbyssbuff22_2.init_fieldSkill
