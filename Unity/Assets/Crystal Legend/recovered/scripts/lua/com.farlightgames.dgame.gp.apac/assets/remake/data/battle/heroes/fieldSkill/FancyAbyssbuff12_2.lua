module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff12_2 = {}

function FancyAbyssbuff12_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local waveId = ed.engine.wave_id or 1
  if waveId == 1 then
    owner.fancy12count = 0
  end
  owner.needfancy12eff = true
  if owner.attribs.HP < 30000 then
    owner.hpenhanceratio = math.max(1.5, 1.5 + (owner.attribs.HP - 20000) / 20000)
  end
  if owner.attribs.HP >= 30000 then
    owner.hpenhanceratio = math.max(2, 2 + (owner.attribs.HP - 30000) / 5000)
  end
  buff.update = override(buff.update, FancyAbyssbuff12_2.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff12_2.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.fancy12count >= 15 and owner.needfancy12eff then
    local bid = 6182
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    buff2.unremoveable = true
    owner:addBuff(buff2, caster)
    owner.needfancy12eff = false
  end
end

function FancyAbyssbuff12_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff12_2.createBuff)
  return skill
end

return FancyAbyssbuff12_2.init_fieldSkill
