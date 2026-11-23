module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff32 = {}

function FancyAbyssbuff32.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff32.Buff_onDamaged)
  buff.update = override(buff.update, FancyAbyssbuff32.update)
  return buff
end

function FancyAbyssbuff32.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  local owner = buff.owner
  local boomskill = caster.skills.FieldNPC_FancyAbyssbuff32_2
  if skill and source and source.info["Main Attrib"] == "STR" and damage_type == "AD" and skill.info["Knock Up"] > 0 then
    local power = source.attribs.STR * 5
    boomskill.info = ed.wraptable(boomskill.info, {
      ["Basic Num"] = power
    })
    boomskill:takeEffectAt(owner.position)
    if skill.caster then
      skill.caster.battledata:addDamage(power, "Holy")
    end
  end
  return dmg
end

function FancyAbyssbuff32.update(basefunc, buff, dt)
end

function FancyAbyssbuff32.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff32.createBuff)
  return skill
end

return FancyAbyssbuff32.init_fieldSkill
