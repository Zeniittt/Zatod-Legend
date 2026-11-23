module("ed.battlehero", package.seeall)
local ed = ed
ChessSniper = {}
ChessSniper.ult_stun_buff_id = 5
ChessSniper.ult_point_effect = "eff_point_Sniper_ult.cha"

function ChessSniper.skillult_takeEffectOn(basefunc, skill, target, source)
  local ret, dmg = basefunc(skill, target, source)
  local binfo = ed.lookupDataTable("Buff", nil, ChessSniper.ult_stun_buff_id)
  local buff = target:addBuff(binfo, target)
  return ret, dmg
end

function ChessSniper.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.Sniper_ultEffect = false
  local caster = skill.caster
  if skill.target then
    local bid = 14
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, skill.target, caster)
    local addbuff = skill.target:addBuff(buff, caster)
    local effect_name = ChessSniper.ult_point_effect
    local target = skill.target
    local position = target.position
    local height = target.height
    if ed.run_with_scene then
      ed.scene:playEffectOnScene(effect_name, position, nil, height, 1)
    end
  end
end

function ChessSniper.init_hero(hero)
  local skillult = hero.skills.Sniper_ult
  if skillult then
    skillult.start = override(skillult.start, ChessSniper.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessSniper.skillult_takeEffectOn)
  end
  return hero
end

return ChessSniper.init_hero
