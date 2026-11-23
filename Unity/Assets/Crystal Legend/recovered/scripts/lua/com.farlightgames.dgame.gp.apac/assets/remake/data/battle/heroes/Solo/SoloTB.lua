module("ed.battlehero", package.seeall)
local ed = ed
SoloTB = {}

function SoloTB.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.pasv_cd then
    hero.pasv_cd = 0
  end
  if hero.pasv_cd then
    hero.pasv_cd = hero.pasv_cd + dt
  end
  if hero.pasv_cd >= 1 then
    hero.pasv_cd = 0
    local skillatk = hero.skills.TB_atk
    local skillpasv = hero.skills.TB_pasv
    local target = skillatk:selectTarget()
    if target then
      local damage = target.attribs.HP * 0.005
      target:takeDamage({
        amount = damage,
        damage_type = "Holy",
        field = "hp",
        source = hero,
        coefficient = 1,
        soloParams = {
          type = 2,
          id = skillpasv.info.Slot
        }
      })
      hero:takeHeal(damage, "hp", hero, nil, {
        type = 2,
        id = skillpasv.info.Slot
      })
    end
  end
end

function SoloTB.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  owner.ultBuff_TB = nil
  basefunc(buff)
  owner:hurt()
  owner:setAction("Birth", false, true)
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel then
      panel:setPortrait("UI/DOTA-HERO/TB.png")
    end
    ed.scene:playEffectOnScene("eff_point_TB_ult.cha", {
      owner.position[1],
      owner.position[2] - 1
    }, {
      owner.direction,
      1
    }, nil, 0)
  end
end

function SoloTB.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff_TB then
    return false
  end
  return true
end

function SoloTB.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, SoloTB.skillult_buffOnRemoved)
  caster.ultBuff_TB = 1
  if ed.run_with_scene then
    local panel = caster.heroPanel
    if panel then
      panel:setPortrait("UI/DOTA-HERO/TBult.png")
    end
  end
  return buff
end

function SoloTB.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if skill.attack_counter == 1 then
    local origin = {
      caster.position[1],
      caster.position[2]
    }
    if ed.run_with_scene then
      local effect_name = "eff_point_TB_ult3.cha"
      if effect_name then
        skill:selectTarget(caster)
        if not effect_name then
          return
        end
        ed.scene:playEffectOnScene(effect_name, origin, {
          caster.direction * 0.85,
          0.85
        }, nil, 1)
      end
    end
  else
    basefunc(skill, target)
  end
end

function SoloTB.hero_reset(basefunc, hero)
  basefunc(hero)
end

function SoloTB.skillatk_onAttackFrame(basefunc, skill)
  local skill_counter = skill.attack_counter
  local caster = skill.caster
  if skill_counter == 0 then
    basefunc(skill)
  end
end

function SoloTB.skillatk_launchPoint(basefunc, skill)
  local caster = skill.caster
  local dir = caster.direction
  return {
    caster.position[1] + dir * 60,
    caster.position[2]
  }, 40
end

function SoloTB.init_hero(hero)
  hero.reset = override(hero.reset, SoloTB.hero_reset)
  hero.update = override(hero.update, SoloTB.update)
  local skillult = hero.skills.TB_ult
  local skillatk = hero.skills.TB_atk
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, SoloTB.skillatk_onAttackFrame)
    skillatk.launchPoint = override(skillatk.launchPoint, SoloTB.skillatk_launchPoint)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, SoloTB.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, SoloTB.skillult_canCastWithTarget)
    skillult.takeEffectOn = override(skillult.takeEffectOn, SoloTB.skillult_takeEffectOn)
  end
  ed.PreloadPuppetRcs("TBult")
  return hero
end

return SoloTB.init_hero
