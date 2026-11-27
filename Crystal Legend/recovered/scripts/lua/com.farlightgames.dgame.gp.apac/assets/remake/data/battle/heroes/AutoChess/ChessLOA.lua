module("ed.battlehero", package.seeall)
local ed = ed
ChessLOA = {}

function ChessLOA.skillult_buff_OnRemoved(basefunc, buff)
  if buff.timer >= 0 and 0 < buff.shield then
    return basefunc(buff)
  end
  local buff_power = math.abs(buff.LOA_origShield - math.max(0, buff.shield))
  local skillultb = buff.caster.skills.LOA_ultb
  skillultb.info = ed.wraptable(skillultb.info, {
    ["Basic Num"] = buff_power
  })
  skillultb:takeEffectAt(buff.owner.position)
  return basefunc(buff)
end

function ChessLOA.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.LOA_origShield = buff.shield
  buff.onRemoved = override(buff.onRemoved, ChessLOA.skillult_buff_OnRemoved)
  return buff
end

function ChessLOA.init_hero(hero)
  local skillult = hero.skills.LOA_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessLOA.skillult_createBuff)
  end
  return hero
end

return ChessLOA.init_hero
