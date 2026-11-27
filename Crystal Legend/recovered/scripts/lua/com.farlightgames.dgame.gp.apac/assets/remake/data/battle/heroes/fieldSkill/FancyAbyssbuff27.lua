module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff27 = {}

function FancyAbyssbuff27.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.boomcd = 0
  buff.owner.canboom = true
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff27.Buff_onDamaged)
  buff.update = override(buff.update, FancyAbyssbuff27.update)
  return buff
end

function FancyAbyssbuff27.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  local owner = buff.owner
  local boomskill = caster.skills.FieldNPC_FancyAbyssbuff27_2
  if skill and damage_type == "AD" and skill.info["Knock Up"] > 0 and buff.owner.canboom == true then
    boomskill.info = ed.wraptable(boomskill.info, {
      ["Basic Num"] = dmg
    })
    boomskill:takeEffectAt(owner.position)
    buff.owner.boomcd = 1
    buff.owner.canboom = false
    if skill.caster then
      skill.caster.battledata:addDamage(dmg, "Holy")
    end
  end
  return dmg
end

function FancyAbyssbuff27.update(basefunc, buff, dt)
  if buff.owner.boomcd > 0 then
    buff.owner.boomcd = buff.owner.boomcd - dt
  else
    buff.owner.canboom = true
  end
end

function FancyAbyssbuff27.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff27.createBuff)
  return skill
end

return FancyAbyssbuff27.init_fieldSkill
