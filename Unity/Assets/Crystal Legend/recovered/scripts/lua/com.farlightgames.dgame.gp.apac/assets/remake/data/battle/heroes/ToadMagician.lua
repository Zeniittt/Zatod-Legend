module("ed.ToadMagician", package.seeall)
local ed = ed
ToadMagician = {}

function ToadMagician.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.update = override(buff.update, ToadMagician.skillatk2_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, ToadMagician.skillatk2_buffOnRemoved)
  caster.atk2buff = true
  return buff
end

function ToadMagician.skillatk2_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.time_index then
    buff.time_index = 0
  else
    buff.time_index = buff.time_index + 1
  end
  local owner = buff.owner
  if buff.time_index <= 8 and owner.height <= 56 then
    ToadMagician.setUnitHeight(owner, owner.height + 5 + (1 + 2 * ed.rand()))
  elseif buff.time_index > 8 or owner.height > 56 then
    ToadMagician.setUnitHeight(owner, owner.height + 1 - 2 * ed.rand())
  end
end

function ToadMagician.skillatk2_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  if ed.run_with_scene then
    local effect_name = "eff_impact_TitanFrog_atk.cha"
    local effect = ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
  end
  owner.height = 0
  if owner.actor then
    owner.actor.height = 0
  end
  basefunc(buff)
end

function ToadMagician.setUnitHeight(unit, height)
  unit.height = height
  if unit.actor then
    unit.actor.height = height
  end
end

function ToadMagician.init_hero(hero)
  local skillatk2 = hero.skills.ToadMagician_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, ToadMagician.skillatk2_createBuff)
  end
  return hero
end

return ToadMagician.init_hero
