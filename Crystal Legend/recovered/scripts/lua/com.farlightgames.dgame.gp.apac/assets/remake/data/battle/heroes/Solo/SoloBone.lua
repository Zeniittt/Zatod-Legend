module("ed.battlehero", package.seeall)
local ed = ed
SoloBone = {}

function SoloBone.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillpasv = caster.skills.Bone_pasv
  if target and dmg and 0 < dmg and caster and 0 < caster.attribs.DODG then
    local damage = 2 * caster.attribs.DODG
    target:takeDamage({
      amount = damage,
      damage_type = "AP",
      field = "hp",
      source = caster,
      coefficient = 1,
      soloParams = {
        type = 2,
        id = skillpasv.info.Slot
      }
    })
  end
  return isHit, dmg
end

function SoloBone.hero_true_init(hero)
  local skillatk = hero.skills.Bone_atk
  local skillpasv = hero.skills.Bone_pasv
  if skillatk and skillpasv then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, SoloBone.skillatk_takeEffectOn)
  end
  return hero
end

function SoloBone.init_hero(hero)
  SoloBone.hero_true_init(hero)
  return hero
end

return SoloBone.init_hero
