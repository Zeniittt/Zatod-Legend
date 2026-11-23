module("ed.battlehero", package.seeall)
local ed = ed
Scorpion = {}

function Scorpion.skillatk3_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  if skill.attack_counter % 2 == 0 then
    basefunc(skill, location, source)
  end
  if skill.attack_counter == 1 then
    local caster = skill.caster
    local bid = 821
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster.ScorpionStealthBuff = caster:addBuff(binfo, caster)
  end
  if skill.attack_counter == 8 then
    if caster.ScorpionStealthBuff then
      caster:removeBuff(caster.ScorpionStealthBuff)
      caster.ScorpionStealthBuff = nil
    end
    return
  end
end

function Scorpion.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.ScorpionStealthBuff then
    caster:removeBuff(caster.ScorpionStealthBuff)
    caster.ScorpionStealthBuff = nil
  end
end

function Scorpion.init_hero(hero)
  local skillatk3 = hero.skills.Scorpion_atk3
  if skillatk3 then
    skillatk3.takeEffectAt = override(skillatk3.takeEffectAt, Scorpion.skillatk3_takeEffectAt)
  end
  return hero
end

return Scorpion.init_hero
