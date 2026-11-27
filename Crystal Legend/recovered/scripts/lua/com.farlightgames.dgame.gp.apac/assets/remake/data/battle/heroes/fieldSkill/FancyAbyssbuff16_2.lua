module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff16_2 = {}

function FancyAbyssbuff16_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local waveId = ed.engine.wave_id or 1
  if waveId == 1 then
    owner.fancy16count = 0
  end
  owner.needfancy16buff1 = true
  buff.update = override(buff.update, FancyAbyssbuff16_2.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff16_2.Buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  if owner.fancy16count >= 15 and owner.needfancy16buff1 then
    local bid1 = 6196
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, owner, caster)
    buff1.unremoveable = true
    owner:addBuff(buff1, caster)
    owner.needfancy16buff1 = false
    owner.needfancy16buff2 = true
  end
  if owner.fancy16count >= 30 and owner.needfancy16buff2 then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6196 then
        tbuff.timer = -1
      end
    end
    local bid2 = 6197
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, owner, caster)
    buff2.unremoveable = true
    owner:addBuff(buff2, caster)
    owner.needfancy16buff2 = false
    owner.needfancy16buff3 = true
  end
  if owner.fancy16count >= 45 and owner.needfancy16buff3 then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6197 then
        tbuff.timer = -1
      end
    end
    local bid3 = 6198
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    local buff3 = ed.BuffCreate(binfo3, owner, caster)
    buff3.unremoveable = true
    owner:addBuff(buff3, caster)
    owner.needfancy16buff3 = false
    owner.needfancy16buff4 = true
  end
  if owner.fancy16count >= 60 and owner.needfancy16buff4 then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6198 then
        tbuff.timer = -1
      end
    end
    local bid4 = 6199
    local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
    local buff4 = ed.BuffCreate(binfo4, owner, caster)
    buff4.unremoveable = true
    owner:addBuff(buff4, caster)
    owner.needfancy16buff4 = false
    owner.needfancy16buff5 = true
  end
  if owner.fancy16count >= 75 and owner.needfancy16buff5 then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6199 then
        tbuff.timer = -1
      end
    end
    local bid5 = 6200
    local binfo5 = ed.lookupDataTable("Buff", nil, bid5)
    local buff5 = ed.BuffCreate(binfo5, owner, caster)
    buff5.unremoveable = true
    owner:addBuff(buff5, caster)
    owner.needfancy16buff5 = false
  end
end

function FancyAbyssbuff16_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff16_2.createBuff)
  return skill
end

return FancyAbyssbuff16_2.init_fieldSkill
