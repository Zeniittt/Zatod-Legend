module("ed.battlehero", package.seeall)
local ed = ed
ChessTS = {}
ChessTS.ult_interval = 0.9166

function ChessTS.skillult_buffUpdate(basefunc, buff, dt)
  local originLFS = buff.caster.attribs.LFS
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + ChessTS.ult_interval
    local skillult2 = buff.caster.skills.TS_ult2
    local target = skillult2:selectTarget()
    if target then
      local owner = skillult2.caster
      skillult2:takeEffectAt(owner.position)
      buff.total_times = buff.total_times + 1
    end
  end
  buff.attack_timer = timer
  if buff.owner.mp == 0 then
    buff.owner.removeBuff(buff.owner, buff)
  end
  basefunc(buff, dt)
  buff.caster.attribs.LFS = originLFS
end

function ChessTS.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff_TS or hero.mp < 500 then
    return false
  end
  return true
end

function ChessTS.skillult_buffOnRemoved(basefunc, buff)
  basefunc(buff)
  local skillatk = buff.owner.skills.TS_atk
  if skillatk then
    skillatk.info = skillatk.originfo
  end
  local owner = buff.caster
  local basic_skill = buff.caster.skills.TS_atk
  if basic_skill then
    owner.attack_range = basic_skill.info["Max Range"] - 5
  end
  owner.ultBuff_TS = nil
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(false)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/mp_rage.png"))
    end
  end
end

function ChessTS.skillult_createBuff(basefunc, skill, target)
  local owner = skill.caster
  owner.attack_range = 100
  local buff = basefunc(skill, target)
  buff.attack_timer = 0.01
  buff.total_dmg = 0
  buff.total_times = 0
  buff.update = override(buff.update, ChessTS.skillult_buffUpdate)
  buff.onRemoved = override(buff.onRemoved, ChessTS.skillult_buffOnRemoved)
  buff.owner.ultBuff_TS = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel.mp_bar.star:setVisible(true)
      panel.mp_bar.foreground:setDisplayFrame(ed.getSpriteFrame("UI/alpha/HVGA/mp_rage_2.png"))
    end
  end
  local skillatk = buff.owner.skills.TS_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Max Range"] = 100,
      ["Target Type"] = "farthest"
    })
  end
  return buff
end

function ChessTS.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    local effect_moon = "eff_point_TS_ult.cha"
    local casterorigin = skill.caster.position
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {
      skill.caster.direction,
      1
    }, nil, 0)
  end
end

function ChessTS.init_hero(hero)
  local skillult = hero.skills.TS_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessTS.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ChessTS.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessTS.skillult_onAttackFrame)
  end
  return hero
end

return ChessTS.init_hero
