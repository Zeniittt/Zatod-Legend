module("ed.battlehero", package.seeall)
local ed = ed
Lich = {}
Lich.ultEvobuff = 10003502
Lich.atk3Evobuff = 10003503
Lich.Fashion_ID_1 = 351

function Lich.projectile_hit(basefunc, tile, target)
  local skillult = tile.skill
  if skillult then
    local origin_info = skillult.info
    local caster = tile.caster
    local jumpSum = 5 - tile.jumps
    local addNumtime = skillult.evo_rank3["Script Arg1"] + skillult.evo_rank3["Script Arg2"] * caster.attribs.AP
    local addNum = addNumtime * jumpSum
    local basicNum = skillult.info["Basic Num"]
    skillult.info = ed.wraptable(skillult.info, {
      ["Basic Num"] = basicNum + addNum
    })
    basefunc(tile, target)
    skillult.info = origin_info
  end
end

function Lich.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(5)
  if skill.evo_rank and skill.evo_rank >= 3 then
    projectile.hit = override(projectile.hit, Lich.projectile_hit)
  end
  projectile:enableTrack(skill.target)
  
  function projectile:findNextTaeget()
    local min = math.huge
    local ret
    for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
      if unit == self.source then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= skill.caster.camp then
      else
        local distanceSQ = ed.edpDistanceSQ(unit.position, self.source.position)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
    return ret
  end
  
  return projectile
end

function Lich.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  if isHit and target:isAlive() then
    local caster = skill.caster
    local ultEvobuff = ed.lookupDataTable("Buff", nil, Lich.ultEvobuff)
    target:addBuff(ultEvobuff, caster)
  end
  return isHit, dmg
end

function Lich.atk3buff_onDamaged(basefunc, buff, damage, damage_type, source)
  local buffDamage = basefunc(buff, damage, damage_type, source)
  local buffowner = buff.owner
  if buffDamage and source then
    local atk3debuff = ed.lookupDataTable("Buff", nil, Lich.atk3Evobuff)
    source:addBuff(atk3debuff, buffowner)
  end
  return buffDamage
end

function Lich.skillatk3_createBuff(basefunc, skill, target)
  local atk3buff = basefunc(skill, target)
  local arm = atk3buff.info.ARM
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 1 then
    atk3buff:setAttribute("HPR", (skill.evo_rank1["Script Arg1"] + skill.evo_rank1["Script Arg2"] * caster.attribs.AP) * (1 + caster.attribs.HEAL / 100))
    atk3buff.onDamaged = override(atk3buff.onDamaged, Lich.atk3buff_onDamaged)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    atk3buff:setAttribute("ARM", arm + skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    atk3buff:setAttribute("ARM", arm + skill.evo_rank2["Script Arg1"] + skill.evo_rank3["Script Arg1"])
  end
  return atk3buff
end

function Lich.init_hero(hero)
  local skillult = hero.skills.Lich_ult
  local skillatk2 = hero.skills.Lich_atk2
  local skillatk3 = hero.skills.Lich_atk3
  local skillemaura = hero.effect_enemy_aura_skill_list[1]
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
      skillult.takeEffectOn = override(skillult.takeEffectOn, Lich.skillult_takeEffectOn)
    end
    if Lich.Fashion_ID_1 and Lich.Fashion_ID_1 == hero.fashion_id then
      skillult.info = ed.wraptable(skillult.info, {
        ["Tile Art"] = "eff_tile_Lich_fashion_1_ult.cha"
      })
    end
    skillult.createProjectile = override(skillult.createProjectile, Lich.skillult_createProjectile)
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, Lich.skillatk3_createBuff)
  end
  if skillemaura then
    local aname = skillemaura["Passive Attr"]
    local num = skillemaura["Basic Num"]
    if skillemaura.evo_rank and 1 <= skillemaura.evo_rank then
      skillemaura["Basic Num"] = skillemaura["Basic Num"] - skillemaura.evo_rank1["Script Arg1"]
    end
    if skillemaura.evo_rank and skillemaura.evo_rank >= 2 then
      skillemaura["Basic Num"] = skillemaura["Basic Num"] - skillemaura.evo_rank2["Script Arg1"]
    end
    if skillemaura.evo_rank and skillemaura.evo_rank >= 3 then
      skillemaura["Basic Num"] = skillemaura["Basic Num"] - skillemaura.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return Lich.init_hero
