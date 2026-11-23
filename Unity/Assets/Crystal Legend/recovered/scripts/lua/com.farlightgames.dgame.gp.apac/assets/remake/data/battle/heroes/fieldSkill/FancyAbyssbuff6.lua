module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff6 = {}

function FancyAbyssbuff6.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.boomcd = 0
  buff.owner.canboom = true
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff6.Buff_onDamaged)
  buff.update = override(buff.update, FancyAbyssbuff6.update)
  return buff
end

function FancyAbyssbuff6.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  local owner = buff.owner
  local boomskill = caster.skills.FieldNPC_FancyAbyssbuff6_2
  if skill and damage_type == "AD" and skill.info.Slot == 3 and buff.owner.canboom == true then
    boomskill.info = ed.wraptable(boomskill.info, {
      ["Basic Num"] = dmg
    })
    boomskill:takeEffectAt(owner.position)
    buff.owner.boomcd = 1
    buff.owner.canboom = false
  end
  return dmg
end

function FancyAbyssbuff6.update(basefunc, buff, dt)
  if buff.owner.boomcd > 0 then
    buff.owner.boomcd = buff.owner.boomcd - dt
  else
    buff.owner.canboom = true
  end
end

function FancyAbyssbuff6.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff6.createBuff)
  return skill
end

return FancyAbyssbuff6.init_fieldSkill
