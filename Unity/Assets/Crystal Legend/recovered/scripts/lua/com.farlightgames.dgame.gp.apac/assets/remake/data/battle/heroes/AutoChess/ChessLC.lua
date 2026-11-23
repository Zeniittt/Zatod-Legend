module("ed.battlehero", package.seeall)
local ed = ed
ChessLC = {}

function ChessLC.basefunc1(basefunc, skill)
  if skill.caster.manually_casting and skill.attack_counter == 7 then
    ed.engine:unfreeze()
    skill.caster.manually_casting = false
  end
  skill.attack_counter = skill.attack_counter + 1
  if (skill.info["Target Type"] == "random" or skill.target == nil or not skill.target:isAlive()) and skill.attack_counter == 1 then
    skill:selectTarget(nil)
  end
  if not skill.target then
    return
  end
  local info = skill.info
  local caster = skill.caster
  local ttype = info["Track Type"]
  if ttype == "projectile" then
    local projectile = skill:createProjectile()
    ed.engine:addProjectile(projectile)
  elseif ttype == "chain" then
    local chain = skill:createChain()
    ed.engine:addChain(chain)
  elseif ttype == nil then
    skill:takeEffectAt(skill.target.position)
  else
    EDDebug("Unkonwn Track Type: '" .. ttype .. "'")
  end
  caster:setMP(caster.mp + info["Gain MP"] * ed.engine.mp_bonus)
  if info["Move Forward"] ~= 0 then
    caster.position[1] = caster.position[1] + info["Move Forward"] * caster.direction
  end
end

function ChessLC.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if skill.target then
    skill.target:unfreezeActor()
  end
end

function ChessLC.skillult_onAttackFrame(basefunc, skill)
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  if 2 <= attack_counter and attack_counter <= 5 and skill.caster.target1 == skill.target then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.25,
      ["Knock Back"] = 1
    })
    ChessLC.basefunc1(basefunc, skill)
    skill.info = originfo
  elseif attack_counter == 0 then
    local caster = skill.caster
    local target = skill.target
    if skill.target and not skill.target.buff_effects.stable then
      target.position = {
        caster.position[1] + caster.direction * 80,
        caster.position[2]
      }
    end
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.15,
      ["Knock Back"] = 20
    })
    skill.caster.target1 = skill.target
    ChessLC.basefunc1(basefunc, skill)
    skill.info = originfo
    local owner = skill.caster
    local bid = 7005
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = owner:addBuff(binfo, owner)
  elseif attack_counter == 6 and skill.caster.target1 == skill.target then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 1
    })
    ChessLC.basefunc1(basefunc, skill)
    skill.info = originfo
  elseif attack_counter == 7 and skill.caster.target1 == skill.target then
    local ratio = 1
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.7,
      ["Knock Back"] = 60,
      ["Plus Ratio"] = ratio
    })
    ChessLC.basefunc1(basefunc, skill)
    skill.info = originfo
    if ed.run_with_scene then
      local effect_moon = "eff_point_LC_ult2.cha"
      local origin = {400, 0}
      ed.scene:playEffectOnScene(effect_moon, origin, nil, nil, -1)
    end
    local caster = skill.caster
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  elseif attack_counter == 1 and skill.caster.target1 == skill.target then
    skill.info = ed.wraptable(originfo, {
      ["Shape Arg1"] = 351,
      ["Knock Up"] = 0.8,
      ["Knock Back"] = 1
    })
    ChessLC.basefunc1(basefunc, skill)
    skill.info = originfo
  end
end

function ChessLC.init_hero(hero)
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.LC_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessLC.skillult_onAttackFrame)
    skillult.start = override(skillult.start, ChessLC.skillult_start)
  end
  return hero
end

return ChessLC.init_hero
