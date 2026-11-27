module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossSG = {}

function AwakeBossSG.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  return buff
end

function AwakeBossSG.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.AwakeBossSG_atk2
  local skillult = caster.skills.AwakeBossSG_ult
  local skillatk = caster.skills.AwakeBossSG_atk
  if target and target:isAlive() then
    local arm = target.attribs.ARM
    buff:setAttribute("ARM", -0.5 * arm)
  end
  return buff
end

function AwakeBossSG.init_hero(hero)
  local skillult = hero.skills.AwakeBossSG_ult
  local skillatk3 = hero.skills.AwakeBossSG_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.createBuff = override(skillult.createBuff, AwakeBossSG.skillult_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossSG.skillatk3_createBuff)
  end
  return hero
end

return AwakeBossSG.init_hero
