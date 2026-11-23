module("ed.battlehero", package.seeall)
local ed = ed
SoloHuskar = {}

function SoloHuskar.HPDiffBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local HP_Diff = owner.attribs.HP - owner.hp
  local HPDiffRank = math.ceil(HP_Diff / 100)
  if 0 < HPDiffRank then
    owner.HPDiffRank = HPDiffRank
  end
  if 0 < HPDiffRank and owner.HPDiffRank ~= owner.LastHPDiffRank then
    buff:setAttribute("AD", owner.HPDiffRank)
    owner:resetBuffApply(buff)
    owner.LastHPDiffRank = owner.HPDiffRank
    owner:rebuild()
  end
end

function SoloHuskar.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.LastHPDiffRank = 0
  hero.HPDiffRank = 0
  local HPDiffBid = 100000012
  local binfo = ed.lookupDataTable("Buff", nil, HPDiffBid)
  local HPAD_Buff = ed.BuffCreate(binfo, hero, hero)
  HPAD_Buff.update = override(HPAD_Buff.update, SoloHuskar.HPDiffBuff_update)
  hero:addBuff(HPAD_Buff)
end

function SoloHuskar.skillatk_launchPoint(basefunc, skill)
  local caster = skill.caster
  local dir = caster.direction
  return {
    caster.position[1] + dir * 25,
    caster.position[2]
  }, 50
end

function SoloHuskar.init_hero(hero)
  hero.reset = override(hero.reset, SoloHuskar.hero_reset)
  local skillatk = hero.skills.Huskar_atk
  if skillatk then
    skillatk.launchPoint = override(skillatk.launchPoint, SoloHuskar.skillatk_launchPoint)
  end
  return hero
end

return SoloHuskar.init_hero
