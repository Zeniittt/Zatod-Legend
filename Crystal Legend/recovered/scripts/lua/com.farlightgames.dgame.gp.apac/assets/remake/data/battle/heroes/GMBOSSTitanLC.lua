module("ed.battlehero", package.seeall)
local ed = ed
GMBOSSTitanLC = {}

function GMBOSSTitanLC.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillatk2 = caster.skills.GMBOSSTitanLC_atk2
  if caster and skillatk2 then
    buff.update = override(buff.update, GMBOSSTitanLC.skillatk2_buffUpdate)
  end
  return buff
end

function GMBOSSTitanLC.skillatk2_buffUpdate(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk2 = caster.skills.GMBOSSTitanLC_atk2
  local skillatk2s = caster.skills.GMBOSSTitanLC_atk2s
  if caster.atk2s_hurt_time and not buff.GMBOSSTitanLC_atk2sCast then
    caster.atk2s_hurt_time = caster.atk2s_hurt_time + dt
  end
  if skillatk2 and caster and owner then
    local atk2s_CD = 4.5 - skillatk2.info["Script Arg2"]
    if not buff.lastposition then
      buff.lastposition = {
        owner.position[1],
        owner.position[2]
      }
    end
    if atk2s_CD <= caster.atk2s_hurt_time and (buff.lastposition[1] ~= owner.position[1] or buff.lastposition[2] ~= owner.position[2]) then
      caster.atk2s_hurt_time = 0
      skillatk2s:takeEffectOn(owner)
      buff.lastposition = {
        owner.position[1],
        owner.position[2]
      }
    end
  end
  basefunc(buff, dt)
end

function GMBOSSTitanLC.DOP_in_battlefield(caster, radius, camp)
  local position = {400, 0}
  local count = 0
  local maxcount = 0
  local distance = 0
  local mindistance = 999
  for x = 0, 800, 25 do
    for y = -100, 100, 25 do
      for unit in ed.engine:foreachAliveUnit(camp) do
        local unitdistance = ed.edpDistanceSQ({x, y}, unit.position)
        if unit.buffManager.invisible and unit.camp ~= caster.camp then
        elseif unitdistance <= radius * radius then
          count = count + 1
          distance = distance + unitdistance
        end
      end
      if maxcount < count then
        maxcount = count
        mindistance = distance
        position = {x, y}
      end
      if count == maxcount and distance < mindistance then
        mindistance = distance
        position = {x, y}
      end
      count = 0
      distance = 0
    end
  end
  if 0 < maxcount then
    return position
  else
    return {400, 0}
  end
end

function GMBOSSTitanLC.skillatk3_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk3 = caster.skills.GMBOSSTitanLC_atk3
  local attack_counter = skill.attack_counter
  if caster and skillatk3 and attack_counter == 0 then
    local SkillPosition = GMBOSSTitanLC.DOP_in_battlefield(caster, 325, caster.foecamp)
    skillatk3:takeEffectAt(SkillPosition, caster)
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLC_atk3.cha"
      local effect = ed.scene:playEffectOnScene(effect_name, SkillPosition, {
        caster.direction,
        1
      }, nil, -1)
    end
    skill.attack_counter = skill.attack_counter + 1
  end
end

function GMBOSSTitanLC.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  local skillult = caster.skills.GMBOSSTitanLC_ult
  local skillults = caster.skills.GMBOSSTitanLC_ults
  local attack_counter = skill.attack_counter
  if caster and skillult then
    if attack_counter == 0 then
      local SkillPosition = target.position
      caster:setPosition(SkillPosition)
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      basefunc(skill)
      for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
        if unit ~= target then
          skillults:takeEffectOn(unit)
        end
      end
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function GMBOSSTitanLC.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.GMBOSSTitanLC_ult
  if caster and caster.GMBOSSTitanLC_hasArcana and caster.GMBOSSTitanLC_hasArcana > 3 and caster and skillult then
    buff.update = override(buff.update, GMBOSSTitanLC.skillatk2_buffUpdate)
  end
  return buff
end

function GMBOSSTitanLC.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.GMBOSSTitanLC_hasArcana and hero.GMBOSSTitanLC_hasArcana > 1 and hero.holy_count <= 0 then
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info.Union == "Holy" then
        hero.holy_count = hero.holy_count + 1
      end
    end
  end
end

function GMBOSSTitanLC.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.holy_count = 0
  hero.atk2s_hurt_time = 0
end

function GMBOSSTitanLC.init_hero(hero)
  hero.reset = override(hero.reset, GMBOSSTitanLC.hero_reset)
  hero.update = override(hero.update, GMBOSSTitanLC.hero_update)
  local skillatk2 = hero.skills.GMBOSSTitanLC_atk2
  local skillatk2s = hero.skills.GMBOSSTitanLC_atk2s
  local skillatk3 = hero.skills.GMBOSSTitanLC_atk3
  local skillults = hero.skills.GMBOSSTitanLC_ults
  hero.GMBOSSTitanLC_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, GMBOSSTitanLC.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, GMBOSSTitanLC.skillatk3_onAttackFrame)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, GMBOSSTitanLC.skillults_createBuff)
  end
  return hero
end

return GMBOSSTitanLC.init_hero
