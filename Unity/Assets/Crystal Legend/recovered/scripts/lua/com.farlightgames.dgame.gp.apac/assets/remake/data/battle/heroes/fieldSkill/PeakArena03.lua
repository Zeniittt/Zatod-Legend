module("ed.battlehero", package.seeall)
local ed = ed
PeakArena03 = {}

function PeakArena03.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 81 or owner.info.ID == 10022 or owner.info.ID == 61 or owner.info.ID == 67 or owner.info.ID == 86 then
    owner.peakarena03 = true
    buff.update = override(buff.update, PeakArena03.Buff_update)
    local bid = 80000005
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    buff2.unremoveable = true
    owner:addBuff(buff2, caster)
    buff.unremoveable = true
  end
  return buff
end

function PeakArena03.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local initpuppet = owner.info.Puppet
  initpuppet = owner.fashion_id and ed.lookupDataTable("Fashion", "Puppet", owner.fashion_id) or initpuppet
  if owner.puppet_stack[1] ~= initpuppet and owner.peakarena03 == true then
    local bid = 80000004
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = ed.BuffCreate(binfo, owner, caster)
    buff2:setAttribute("HP", owner.attribs.HP * 0.3 / owner.config.hp_mod)
    buff2.update = override(buff2.update, PeakArena03.Buff2_update)
    buff2.unremoveable = true
    owner:addBuff(buff2, caster)
    owner:takeHeal(owner.attribs.HP)
    owner.peakarena03 = false
  end
end

function PeakArena03.Buff2_update(basefunc, buff, dt)
end

function PeakArena03.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena03.createBuff)
  return skill
end

return PeakArena03.init_fieldSkill
