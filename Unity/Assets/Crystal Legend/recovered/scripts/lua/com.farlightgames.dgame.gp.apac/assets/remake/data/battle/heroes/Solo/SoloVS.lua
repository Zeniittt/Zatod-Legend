module("ed.battlehero", package.seeall)
local ed = ed
SoloVS = {}

function SoloVS.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  local skillpasv = caster.skills.Bone_pasv
  if target and dmg and 0 < dmg then
    target:addDrug(caster.attribs.AD, {type = 2, id = 1}, caster)
  end
  return isHit, dmg
end

function SoloVS.hero_reset(basefunc, hero)
  basefunc(hero)
  local hero_loseTime = 0
  if hero_loseTime then
    local bid = 100000017
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local VS_Buff = ed.BuffCreate(binfo, hero, hero)
    VS_Buff:setAttribute("AD", 5 * hero_loseTime)
    hero:addBuff(VS_Buff)
  end
end

function SoloVS.hero_true_init(hero)
  local skillult = hero.skills.VS_ult
  local skillpasv = hero.skills.VS_pasv
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, SoloVS.skillult_takeEffectOn)
  end
  hero.reset = override(hero.reset, SoloVS.hero_reset)
  return hero
end

function SoloVS.init_hero(hero)
  SoloVS.hero_true_init(hero)
  return hero
end

return SoloVS.init_hero
