module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff3 = {}

function FancyAbyssbuff3.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.Extra_Shield = 0
  buff.update = override(buff.update, FancyAbyssbuff3.update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff3.update(basefunc, buff, dt)
  buff.ticks = (buff.ticks or 0) + 1
  local owner = buff.owner
  local caster = buff.caster
  if buff.ticks == 1 then
    owner:setHP(owner.attribs.HP * 0.2)
    local bid = 6160
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    buff.onRemoved = override(buff.onRemoved, FancyAbyssbuff3.onBuffRemove)
    buff.shield = owner.attribs.HP * 0.8
    buff.unremoveable = true
    owner.shieldbuff = owner:addBuff(buff, caster)
  end
  if owner.hp > owner.attribs.HP * 0.2 then
    owner.Extra_Shield = 1.3 * (owner.hp - owner.attribs.HP * 0.2)
    owner.hp = owner.attribs.HP * 0.2
  else
    owner.Extra_Shield = 0
  end
  if 0 < owner.Extra_Shield then
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 6160 then
        owner.haveshield = true
      end
    end
    if not owner.haveshield then
      local bid = 6160
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, owner, caster)
      buff.onRemoved = override(buff.onRemoved, FancyAbyssbuff3.onBuffRemove)
      buff.shield = owner.Extra_Shield
      buff.unremoveable = true
      owner.shieldbuff = owner:addBuff(buff, caster)
    else
      local buff = owner.shieldbuff
      if buff then
        local shield = buff.shield
        if shield then
          buff.shield = buff.shield + owner.Extra_Shield
        end
      end
    end
  end
end

function FancyAbyssbuff3.onBuffRemove(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.haveshield = false
end

function FancyAbyssbuff3.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff3.createBuff)
  return skill
end

return FancyAbyssbuff3.init_fieldSkill
