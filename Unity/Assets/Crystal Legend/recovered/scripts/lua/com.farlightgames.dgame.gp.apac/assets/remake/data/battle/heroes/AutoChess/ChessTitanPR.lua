module("ed.battlehero", package.seeall)
local ed = ed
ChessTitanPR = {}
ChessTitanPR.chess_Damage_lower = {
  65,
  125,
  185
}
ChessTitanPR.chess_Damage_higher = {
  250,
  375,
  500
}

function ChessTitanPR.skillult_power(basefunc, skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  local multiplier = info["Plus Ratio"]
  local base_attrib = info["Plus Attr"] and skill.caster.attribs[info["Plus Attr"]] or 0
  local bpower = info["Basic Num"] + math.abs((info["Script Arg3"] - info["Basic Num"]) * ed.rand())
  local power = multiplier * base_attrib + bpower
  local ratio1 = 0
  local ratio2 = 0
  if damage_type and damage_type ~= "Heal" then
    if target then
      for i, tbuff in ipairs(target.buff_list) do
        if tbuff.name == "ExtraDamageBuff_damaged" and tbuff:checkExtraDamageCondition(source, damage_type, power) and tbuff.extraDamageValue and ratio1 <= 1 then
          ratio1 = ratio1 + tbuff.extraDamageValue
        end
      end
    end
    if skill.extraDamageRatio then
      ratio2 = ratio2 + skill.extraDamageRatio
    end
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.name == "ExtraDamageBuff_attack" and tbuff.extraDamageValue and 0 < tbuff.timer and ratio2 <= 1 then
        ratio2 = ratio2 + tbuff.extraDamageValue
        tbuff.timer = 0
      end
    end
    skill.extraDamageRatio = ratio2
  end
  return power * (1 + ratio1 + ratio2), 1
end

function ChessTitanPR.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timer = (ed.rand() * 0.75 + 0.25) * skill.info["Script Arg2"]
  return buff
end

function ChessTitanPR.init_hero(hero)
  local skillult = hero.skills.TitanPR_ult
  if skillult then
    skillult.power = override(skillult.power, ChessTitanPR.skillult_power)
    skillult.createBuff = override(skillult.createBuff, ChessTitanPR.skillult_createBuff)
  end
  return hero
end

return ChessTitanPR.init_hero
