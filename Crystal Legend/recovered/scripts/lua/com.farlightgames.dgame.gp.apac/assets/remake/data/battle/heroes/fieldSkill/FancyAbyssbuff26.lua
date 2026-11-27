module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff26 = {}

function FancyAbyssbuff26.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, FancyAbyssbuff26.buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff26.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local caster = buff.caster
  owner.f26summoncount = 0
  for unit in ed.engine:foreachAliveUnit(owner.camp) do
    if unit.config.is_summoned and unit.config.summoner and unit.info.ID ~= 224 and unit.info.ID ~= 210 and unit.config.summoner == owner then
      owner.f26summoncount = owner.f26summoncount + 1
    end
  end
  if owner.f26summoncount >= 1 and not owner.havef26buff then
    local f26ad = 0
    local f26addp = 0
    if owner.attribs.HP < 40000 then
      f26ad = owner.attribs.HP * 0.05
      f26addp = 20
    end
    if owner.attribs.HP >= 40000 then
      f26ad = owner.attribs.HP * 0.15
      f26addp = 50
    end
    local bid = 6234
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    buff:setAttribute("AD", f26ad)
    buff:setAttribute("ADDP", f26addp)
    buff.unremoveable = true
    owner:addBuff(buff, caster)
    owner.havef26buff = true
  end
  if owner.f26summoncount < 1 and owner.havef26buff then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6234 then
        tbuff.timer = -1
      end
    end
    owner.havef26buff = false
  end
end

function FancyAbyssbuff26.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff26.createBuff)
  return skill
end

return FancyAbyssbuff26.init_fieldSkill
