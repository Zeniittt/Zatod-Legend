module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff9_2 = {}

function FancyAbyssbuff9_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.update = override(buff.update, FancyAbyssbuff9_2.update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff9_2.update(basefunc, buff, dt)
  buff.ticks = (buff.ticks or 0) + 1
  local owner = buff.owner
  if buff.ticks == 1 and not owner.inibuff then
    owner.fancy9dmgcount = 0
    owner.initarm = owner.attribs.ARM
    local bid = 6172
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff:setAttribute("ARM", owner.initarm * 1.5)
    buff.unremoveable = true
    owner:addBuff(buff, owner)
    local bid = 6173
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff:setAttribute("AD", owner.attribs.ARM * 1.5)
    buff.unremoveable = true
    owner.inibuff = true
    owner:addBuff(buff, owner)
    owner.oldarm = owner.attribs.ARM
  end
  owner.currentarm = owner.attribs.ARM
  if owner.inibuff and owner.currentarm ~= owner.oldarm then
    local armdif = owner.currentarm - owner.oldarm
    local bid = 6173
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff:setAttribute("AD", armdif * 1.5)
    buff.unremoveable = true
    owner:addBuff(buff, owner)
  end
  owner.oldarm = owner.attribs.ARM
end

function FancyAbyssbuff9_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff9_2.createBuff)
  return skill
end

return FancyAbyssbuff9_2.init_fieldSkill
