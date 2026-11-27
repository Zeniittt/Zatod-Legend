module("ed.battlehero", package.seeall)
local ed = ed
ChessTB = {}
ChessTB.ultstartbuff = 10004704
ChessTB.TB_range_interval = 150
ChessTB.TBult_atk_cd = 1.2
ChessTB.heroName = "TB"

function ChessTB.update(basefunc, unit, dt)
  basefunc(unit, dt)
end

function ChessTB.skillult_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk = buff.owner.skills.TB_atk
  if skillatk then
    skillatk.info = skillatk.originfo
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = 1
    owner.attack_range = owner.attack_range - ChessTB.TB_range_interval
  end
  owner.ultBuff_TB = nil
  basefunc(buff)
  if owner.name == "TB" then
    owner:hurt()
    owner:setAction("Birth", false, true)
  end
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel and owner.name == "TB" then
      panel:setPortrait("UI/DOTA-HERO/TB.png")
    end
    ed.scene:playEffectOnScene("eff_point_TB_ult.cha", {
      buff.owner.position[1],
      buff.owner.position[2] - 1
    }, {
      buff.owner.direction,
      1
    }, nil, 0)
  end
end

function ChessTB.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.ultBuff_TB or hero.mp < 1000 and hero.name == "TB" or hero.manually_casting or hero.isdemon_TB == true then
    return false
  end
  return true
end

function ChessTB.skillult_start(basefunc, skill, target)
  local bid = ChessTB.ultstartbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
  caster.isdemon_TB = true
  basefunc(skill, target)
end

function ChessTB.skillult_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local skillinfo = skill.info
  local buff = basefunc(skill, target)
  skillinfo.buff_info.Puppet = "TBult.cha"
  if caster.name ~= "TB" then
    skillinfo.buff_info.Puppet = false
  end
  buff.onRemoved = override(buff.onRemoved, ChessTB.skillult_buffOnRemoved)
  local skillatk = caster.skills.TB_atk
  if skillatk then
    skillatk.originfo = skillatk.info
    skillatk.info = ed.wraptable(skillatk.originfo, {
      ["Max Range"] = skillatk.info["Max Range"] + ChessTB.TB_range_interval,
      CD = ChessTB.TBult_atk_cd,
      ["Global CD"] = ChessTB.TBult_atk_cd,
      ["Gain MP"] = 80,
      ["Track Type"] = "projectile",
      ["AOE Origin"] = false,
      ["Plus Ratio"] = 1.25,
      ["Impact Effect"] = "eff_impact_TB_atk.cha"
    })
    skillatk.max_range_sq = skillatk.info["Max Range"] ^ 2
    skillatk.cd_remaining = ChessTB.TBult_atk_cd
    buff.owner.attack_range = buff.owner.attack_range + ChessTB.TB_range_interval
    buff.owner.global_cd = ChessTB.TBult_atk_cd
  end
  caster.ultBuff_TB = 1
  if ed.run_with_scene then
    local panel = buff.caster.heroPanel
    if panel and buff.owner.name == "TB" then
      panel:setPortrait("UI/DOTA-HERO/TBult.png")
    end
  end
  return buff
end

function ChessTB.skillult_takeEffectOn(basefunc, skill, target)
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

function ChessTB.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local position1 = caster.position[1] - caster.direction * 127
  if position1 < 800 and 0 < position1 then
    caster.position[1] = position1
  end
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == ChessTB.ultstartbuff then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  caster.isdemon_TB = false
end

function ChessTB.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.isdemon_TB = false
  local skillatk = hero.skills.TB_atk
  hero.attack_range = skillatk.info["Max Range"] - 5
end

function ChessTB.skillatk_onAttackFrame(basefunc, skill)
  local skill_counter = skill.attack_counter
  local caster = skill.caster
  if caster.ultBuff_TB then
    basefunc(skill)
  elseif skill.attack_counter == 1 then
    basefunc(skill)
  else
    skill.attack_counter = skill.attack_counter + 1
  end
end

function ChessTB.init_hero(hero)
  hero.reset = override(hero.reset, ChessTB.hero_reset)
  hero.update = override(hero.update, ChessTB.update)
  local skillult = hero.skills.TB_ult
  local skillatk = hero.skills.TB_atk
  hero:preloadEffect("eff_point_TB_ult.cha")
  hero:preloadEffect("eff_impact_TB_atk.cha")
  hero:preloadEffect("eff_point_TB_ult3.cha")
  if skillatk then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, ChessTB.skillatk_onAttackFrame)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessTB.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ChessTB.skillult_canCastWithTarget)
    skillult.finish = override(skillult.finish, ChessTB.skillult_finish)
    skillult.start = override(skillult.start, ChessTB.skillult_start)
    skillult.takeEffectOn = override(skillult.takeEffectOn, ChessTB.skillult_takeEffectOn)
  end
  ed.PreloadPuppetRcs("TBult")
  return hero
end

return ChessTB.init_hero
