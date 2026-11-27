module("ed.battlehero", package.seeall)
local ed = ed
Footman = {}

function Footman.skill2_buffOnRemoved(basefunc, buff)
  local caster = buff.caster
  local skill = caster.skills.Footman_atk2
  for i, buf in ipairs(caster.buff_list) do
    if buf.info.Name ~= "Footman_atk2" then
      for j, effect in ipairs(buf.info["Control Effects"]) do
        if string.find(effect, "stun") or string.find(effect, "frozen") or string.find(effect, "icefrozen") then
          skill:interrupt()
          return basefunc(buff)
        end
      end
    end
  end
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Affected Camp"] = -1,
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "halfcircle",
    ["Shape Arg1"] = 150,
    ["Damage Type"] = "AP",
    ["Buff ID"] = 0,
    ["Point Effect"] = "eff_point_DR_atk3.cha",
    ["Impact Effect"] = "eff_impact_LOA_atk2.cha"
  })
  buff.caster.global_cd = 3
  skill:takeEffectAt(buff.owner.position)
  skill.info = originfo
  return basefunc(buff)
end

function Footman.skill2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, Footman.skill2_buffOnRemoved)
  return buff
end

function Footman.init_hero(hero)
  local skill = hero.skills.Footman_atk2
  if skill then
    skill.createBuff = override(skill.createBuff, Footman.skill2_createBuff)
  end
  return hero
end

return Footman.init_hero
