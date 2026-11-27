module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff13_2 = {}

function FancyAbyssbuff13_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local waveId = ed.engine.wave_id or 1
  if waveId == 1 then
    owner.f13stuncount = 0
  end
  if owner.info.ID == 86 then
    buff:setAttribute("MPGainRatio", 200)
    buff:setAttribute("MPRatio", 200)
  end
  owner.needfancy13buff1 = true
  owner.needfancy13buff2 = true
  buff.update = override(buff.update, FancyAbyssbuff13_2.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff13_2.Buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  if owner.f13stuncount > 5 and owner.needfancy13buff1 then
    local bid1 = 6185
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, owner, caster)
    buff1.unremoveable = true
    owner:addBuff(buff1, caster)
    owner.needfancy13buff1 = false
  end
  if owner.f13stuncount > 15 and owner.needfancy13buff2 then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6185 then
        tbuff.timer = -1
      end
    end
    local bid2 = 6186
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, owner, caster)
    buff2.unremoveable = true
    owner:addBuff(buff2, caster)
    owner.needfancy13buff2 = false
  end
end

function FancyAbyssbuff13_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff13_2.createBuff)
  return skill
end

return FancyAbyssbuff13_2.init_fieldSkill
