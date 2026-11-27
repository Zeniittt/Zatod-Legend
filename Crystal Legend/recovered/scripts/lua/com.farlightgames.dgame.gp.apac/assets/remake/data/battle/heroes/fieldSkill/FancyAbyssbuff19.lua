module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff19 = {}

function FancyAbyssbuff19.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, FancyAbyssbuff19.Buff_update)
  local waveId = ed.engine.wave_id or 1
  if waveId == 1 then
    owner.f19effect1 = true
    owner.f19effect2 = true
    owner.f19effect3 = true
    owner.f19effect4 = true
    owner.f19effect5 = true
    owner.fancy19count = 0
  end
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff19.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.fancy19count >= 5 and owner.f19effect1 == true then
    local bid1 = 6211
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, owner, caster)
    buff1.unremoveable = true
    owner:addBuff(buff1, caster)
    owner.f19effect1 = false
    owner.f19enhance = 1.2
  end
  if owner.fancy19count >= 10 and owner.f19effect2 == true then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6211 then
        tbuff.timer = -1
      end
    end
    local bid2 = 6212
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, owner, caster)
    buff2.unremoveable = true
    owner:addBuff(buff2, caster)
    owner.f19effect2 = false
    owner.f19enhance = 1.4
  end
  if owner.fancy19count >= 15 and owner.f19effect3 == true then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6212 then
        tbuff.timer = -1
      end
    end
    local bid3 = 6213
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    local buff3 = ed.BuffCreate(binfo3, owner, caster)
    buff3.unremoveable = true
    owner:addBuff(buff3, caster)
    owner.f19effect3 = false
    owner.f19enhance = 1.6
  end
  if owner.fancy19count >= 20 and owner.f19effect4 == true then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6213 then
        tbuff.timer = -1
      end
    end
    local bid4 = 6214
    local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
    local buff4 = ed.BuffCreate(binfo4, owner, caster)
    buff4.unremoveable = true
    owner:addBuff(buff4, caster)
    owner.f19effect4 = false
    owner.f19enhance = 1.8
  end
  if owner.fancy19count >= 25 and owner.f19effect5 == true then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6214 then
        tbuff.timer = -1
      end
    end
    local bid5 = 6215
    local binfo5 = ed.lookupDataTable("Buff", nil, bid5)
    local buff5 = ed.BuffCreate(binfo5, owner, caster)
    buff5.unremoveable = true
    owner:addBuff(buff5, caster)
    owner.f19effect5 = false
    owner.f19enhance = 2
  end
end

function FancyAbyssbuff19.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff19.createBuff)
  return skill
end

return FancyAbyssbuff19.init_fieldSkill
