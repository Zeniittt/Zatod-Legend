module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossCW = {}
AwakeBossCW.AwakeBossCWBuffAwakeID = 414
AwakeBossCW.skillFashionId = 501

function AwakeBossCW.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  caster.position[1] = 400 - 450 * caster:getInitDir()
  caster.walk_v = {
    250 * caster:getInitDir(),
    0
  }
end

function AwakeBossCW.skillatk3_onAttackFrame(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  skill.attack_counter = skill.attack_counter + 1
  if skill.attack_counter == 2 then
    basefunc(skill)
  end
end

function AwakeBossCW.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.shield = buff.shield + caster.attribs.STR
  return buff
end

function AwakeBossCW.skillult_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local AwakeBossCWmaxhp = caster.attribs.HP
  if target and target:isAlive() and power then
    local dmgratio = AwakeBossCWmaxhp * (skill.evo_rank3["Script Arg1"] / 100)
    power = power + math.min(dmgratio, skill.evo_rank3["Script Arg2"])
  end
  return power, i
end

function AwakeBossCW.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillatk3 = caster.skills.AwakeBossCW_atk3
  skillatk3:takeEffectOn(caster)
end

function AwakeBossCW.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  return buff
end

function AwakeBossCW.init_hero(hero)
  local skillult = hero.skills.AwakeBossCW_ult
  local skillatk2 = hero.skills.AwakeBossCW_atk2
  local skillatk3 = hero.skills.AwakeBossCW_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.start = override(skillult.start, AwakeBossCW.skillult_start)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossCW.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, AwakeBossCW.skillatk3_start)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, AwakeBossCW.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossCW.skillatk3_createBuff)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    hero:rebuild()
  end
  return hero
end

return AwakeBossCW.init_hero
