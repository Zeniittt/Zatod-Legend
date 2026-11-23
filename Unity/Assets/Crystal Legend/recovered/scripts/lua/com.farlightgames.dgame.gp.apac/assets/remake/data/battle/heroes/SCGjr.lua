module("ed.battlehero", package.seeall)
local ed = ed
SCGjr = {}
SCGjr.interval = 0.7

function SCGjr.update(basefunc, buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + SCGjr.interval
    local skill = buff.caster.skills.SCGjr_atk2
    local originfo = skill.info
    local origtarget = skill.target
    skill.info = ed.wraptable(originfo, {
      ["Buff ID"] = 0,
      ["Damage Type"] = "AD",
      ["Target Camp"] = -1,
      ["Affected Camp"] = -1,
      ["Target Type"] = "random"
    })
    local target = skill:selectTarget()
    if target then
      skill:takeEffectOn(target, skill.caster)
      local bid = 813
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = target:addBuff(binfo, origtarget)
    end
    if ed.run_with_scene then
      local info = skill.info
      local direction = buff.caster.direction
      local location = buff.caster.position
      local origin = {
        location[1] + info["X Shift"] * direction,
        location[2]
      }
      local effect_name = "eff_buff_SCGjr_atk2_2"
      local effect_name1 = "eff_buff_SCGjr_atk2_1.cha"
      local effect_name2 = "eff_buff_SCGjr_atk2_3.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, origin, {
          buff.caster.direction,
          1
        }, nil, 0)
      end
      if effect_name2 and buff.caster and buff.caster.actor then
        buff.caster.actor:addEffect(effect_name2, 0)
      end
      if effect_name1 and target and target.actor then
        target.actor:addEffect(effect_name1, 0)
      end
    end
    skill.info = originfo
    skill.target = origtarget
  end
  buff.attack_timer = timer
  basefunc(buff, dt)
end

function SCGjr.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if buff.info.ID == 812 then
    buff.attack_timer = SCGjr.interval
    buff.update = override(buff.update, SCGjr.update)
    return buff
  end
end

function SCGjr.init_hero(hero)
  local skill = hero.skills.SCGjr_atk2
  if skill then
    skill.createBuff = override(skill.createBuff, SCGjr.createBuff)
  end
  return hero
end

return SCGjr.init_hero
