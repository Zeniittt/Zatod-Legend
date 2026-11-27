module("ed.battlehero", package.seeall)
local ed = ed
ChessHuskar = {}
ChessHuskar.timegap = 0.25
ChessHuskar.collidedis = 30
ChessHuskar.hastbuff_interval = 1

function ChessHuskar.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local d = ed.edpSub(skill.target.position, caster.position)
    if d[1] == 0 and d[2] == 0 then
      caster.walk_v = {0, 0}
    else
      local d2 = ed.edpSub(d, ed.edpMult(ed.edpNormalize(d), ChessHuskar.collidedis))
      caster.walk_v = {
        d2[1] / ChessHuskar.timegap,
        d2[2] / ChessHuskar.timegap
      }
    end
  else
    local bid = 65
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo = ed.wraptable(binfo, {
      AD = skill.info["Script Arg2"]
    })
    local buff = caster:addBuff(binfo, caster)
    caster.walk_v = {0, 0}
    basefunc(skill, target, source)
  end
end

function ChessHuskar.init_hero(hero)
  local skillult = hero.skills.Huskar_ult
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessHuskar.skillult_takeEffectOn)
  end
  return hero
end

return ChessHuskar.init_hero
