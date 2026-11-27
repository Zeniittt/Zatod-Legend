module("ed.battlehero", package.seeall)
local ed = ed
SoloSniper = {}
SoloSniper.ult_point_effect = "eff_point_Sniper_ult.cha"

function SoloSniper.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.Sniper_ultEffect = false
  if skill.target then
    local effect_name = SoloSniper.ult_point_effect
    local target = skill.target
    local position = target.position
    local height = target.height
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(effect_name, position, nil, height, 1)
    end
  end
end

function SoloSniper.skillatk_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit = basefunc(skill, target)
  local skillpasv = skill.caster.skills.Sniper_pasv
  if Crit and skill.target then
    local bid = 100000006
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, skill.caster)
    target:addBuff(buff, skill.caster)
  end
  return isHit, dmg, Crit
end

function SoloSniper.hero_true_init(hero)
  local skillult = hero.skills.Sniper_ult
  if skillult then
    skillult.start = override(skillult.start, SoloSniper.skillult_start)
  end
  local skillatk = hero.skills.Sniper_atk
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloSniper.skillatk_takeEffectOn)
  end
  return hero
end

function SoloSniper.init_hero(hero)
  SoloSniper.hero_true_init(hero)
  return hero
end

return SoloSniper.init_hero
