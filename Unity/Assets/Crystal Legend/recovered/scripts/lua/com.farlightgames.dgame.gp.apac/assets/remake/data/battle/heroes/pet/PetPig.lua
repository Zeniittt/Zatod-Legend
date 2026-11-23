module("ed.battlehero", package.seeall)
local ed = ed
PetPig = {}
PetPig.PetPig_startBuffID = 1349

function PetPig.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  local master = pet.owner
  if not pet.PetPig_buffadded then
    local bid = PetPig.PetPig_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetPig_buffadded = true
  end
  if not pet.PetPig_firsttick then
    pet.PetPig_firsttick = ed.engine.ticks
  end
  if master.hp <= master.attribs.HP * 0.3 and not pet.PetPig_skillpasv_casted then
    local skillpasv = pet.skills.PetPig_pasv
    if skillpasv then
      local newTarget = skillpasv:selectTarget(nil)
      if newTarget then
        local newDir = master.position[1] > newTarget.position[1] and -1 or 1
        pet.direction = newDir
        skillpasv:takeEffectOn(newTarget, pet)
      end
      pet.PetPig_skillpasv_casted = true
    end
  end
  if not pet.PetPig_skillatk1_started and master.current_skill and master.current_skill.info.Manual then
    pet.PetPig_skillatk1_started = true
    pet:setPosition({
      master.position[1] - master.direction * 80,
      master.position[2] - 45
    })
    pet.direction = master.direction
    pet:setAction("Idle")
    if ed.run_with_scene then
      local effect_name = "eff_point_Pet_born.cha"
      ed.scene:playEffectOnScene(effect_name, {
        pet.position[1],
        pet.position[2] - 1
      }, {1, 1}, nil, 1)
    end
  end
  if pet.PetPig_skillatk1_started and not pet.PetPig_skillatk1_casted then
    if not pet.PetPig_skillatk1_countdown then
      pet.PetPig_skillatk1_countdown = 0
    end
    pet.PetPig_skillatk1_countdown = pet.PetPig_skillatk1_countdown + dt
    if pet.PetPig_skillatk1_countdown > 0.2 and pet.actor then
      pet.actor.node:setVisible(true)
    end
    if pet.PetPig_skillatk1_countdown > 0.4 then
      local skillatk1 = pet.skills.PetPig_atk1
      if skillatk1 then
        local list = master.buff_list
        local debuff_list = {}
        local my_camp = master.camp
        for i = 1, #list do
          local buff = list[i]
          if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
            debuff_list[#debuff_list + 1] = buff
          end
        end
        for i = 1, #debuff_list do
          master:removeBuff(debuff_list[i])
        end
        pet:castSkill(skillatk1, pet)
        local skillatk1sub = pet.skills.PetPig_atk1_1
        local power, coefficient = skillatk1sub:power(pet, master, "Heal")
        if pet.buff_effects.fury and master.camp == pet.foecamp * skillatk1.info["Affected Camp"] then
          power = power * (pet.friendly_damage_discount or 1)
        end
        local heal = pet.attribs.HEAL or 0
        power = power * (1 + heal / 100)
        if do_battle_log then
          btlog("%s: %s ++> %s (+%d)", skillatk1sub:display(), pet:display(), master:display(), power)
        end
        pet.battledata:addTakeHeal(power)
        master:takeHeal(power, "hp", pet)
      end
      pet.PetPig_skillatk1_casted = true
    end
  end
  if pet.actor and pet.PetPig_skillatk1_casted and (pet.action_name == "Idle" or pet.action_name == "Move") and not pet.PetPig_skillatk1_invisible then
    pet.actor.node:setVisible(false)
    pet.PetPig_skillatk1_invisible = true
    local effect_name = "eff_point_mirror_die.cha"
    ed.scene:playEffectOnScene(effect_name, {
      pet.position[1],
      pet.position[2] - 1
    }, {0.6, 0.6}, nil, 1)
  end
end

function PetPig.skillatk1sub_takeEffectOn(basefunc, self, target, source, shift)
  local caster = self.caster
  local lfs_amount
  source = source or caster
  if not target:isAlive() or target.buff_effects.invulnerable or target.manually_casting and source.camp ~= target.camp then
    return false
  end
  local info = self.info
  local damage_type = info["Damage Type"]
  local affect_field = info["Affect MP"] and "mp" or "hp"
  local dmg = 0
  local Crit
  if damage_type then
    local power, coefficient = self:power(source, target, damage_type)
    if self.caster.buff_effects.fury and target.camp == self.caster.foecamp * self.info["Affected Camp"] then
      power = power * (self.caster.friendly_damage_discount or 1)
    end
    if damage_type == "Heal" then
      local heal = affect_field == "hp" and caster.attribs.HEAL or 0
      local power = power * (1 + heal / 100)
      if do_battle_log then
        btlog("%s: %s ++> %s (+%d)", self:display(), caster:display(), target:display(), power)
      end
      caster.battledata:addTakeHeal(power)
      target:takeHeal(power, affect_field, caster)
    else
      if damage_type == "AD" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.DODG - caster.attribs.HIT)
        local prob = dodg / (100 + dodg)
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          target:onHitMiss(self)
          if do_battle_log then
            btlog("%s: %s --> %s (Miss!)", self:display(), caster:display(), target:display())
          end
          local color = target.camp == ed.emCampEnemy and "red" or "blue"
          if target.actor then
            ed.PopupCreate("dodge", color, target.actor, nil, "text")
          end
          return false
        end
      elseif damage_type == "AP" and not info["No Dodge"] then
        local dodg = math.max(0, target.attribs.MDODG)
        local prob = dodg / 100
        local dice = ed.rand()
        local hit = prob <= dice
        if not hit then
          target:onHitMiss(self)
          if do_battle_log then
            btlog("%s: %s --> %s (Miss!)", self:display(), caster:display(), target:display())
          end
          local color = target.camp == ed.emCampEnemy and "red" or "blue"
          if target.actor then
            ed.PopupCreate("dodge", color, target.actor, nil, "text")
          end
          return false
        end
      end
      if do_battle_log then
        btlog("%s: %s --> %s (-%d)", self:display(), caster:display(), target:display(), power)
      end
      dmg, Crit = self:getDamage(target, power, damage_type, affect_field, caster, info["CRIT%"] / 100)
      if target.buffImpactEffect and target.actor then
        local name = target.buffImpactEffect.value.ImpactEffect
        local effect_z = target.buffImpactEffect.value.ImpactEffectZorder
        if self.isEffectAt then
          self.curSkillCount = self.curSkillCount + 1
          if self.curSkillCount <= class.maxShowSkillCount then
            target.actor:addEffect(name, effect_z)
          end
        else
          target.actor:addEffect(name, effect_z)
        end
      end
      if dmg == 0 then
        return false
      end
      if 0 < info["LFS%"] then
        local LFSRatio = caster.attribs.LFSRatio
        local lfs = caster.attribs.LFS
        local heal = dmg * lfs / (100 + lfs + target.level) * info["LFS%"] * 0.01
        if ed.engine.autoChessMode then
          heal = dmg * lfs * 0.01 * info["LFS%"] * 0.01
        end
        LFSRatio = math.max(0, LFSRatio)
        local heal = heal * (1 + LFSRatio * 0.01)
        if 1 < heal or heal < 0 then
          local amount = caster:takeHeal(heal, affect_field)
          if amount then
            if do_battle_log then
              btlog("  %s leeches %d %s form %s", caster:display(), amount, affect_field, target:display())
            end
            caster.battledata:addTakeHeal(amount)
            lfs_amount = amount
          else
            if do_battle_log then
              btlog("  %s leeches %d %s form %s", caster:display(), heal, affect_field, target:display())
            end
            caster.battledata:addTakeHeal(heal)
            lfs_amount = heal
          end
        end
      end
    end
  end
  local buff_miss = false
  if target:isAlive() and 0 < info["Buff ID"] then
    local bSucess, reason = ed.Buff.checkAddBuff(info.buff_info, self.level, target, caster)
    if bSucess then
      target:addBuff(self:createBuff(target))
    else
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local text = reason == "resist" and "resist" or "miss"
      if target.actor then
        ed.PopupCreate(text, color, target.actor, nil, "text")
      end
      buff_miss = true
    end
  end
  local KRES = target.attribs.KnockRES
  local time = info["Knock Up"]
  local distance = info["Knock Back"]
  if KRES < 1 and 0 <= KRES then
    time = time * math.sqrt(KRES)
    distance = distance * KRES
  end
  if not buff_miss and (0 < time or 0 < distance) then
    local direction = {1, 0}
    if target.position[1] == caster.position[1] then
      direction = ed.edpNormalize({
        caster.direction,
        0
      })
    else
      direction = ed.edpNormalize(ed.edpCompMult({1, 0}, ed.edpSub(target.position, caster.position)))
    end
    target:knockup(time, ed.edpMult(direction, distance), shift)
  end
  local name = info["Impact Effect"]
  if name and target.actor then
    local effect_z = info["Impact Zorder"]
    if self.isEffectAt then
      self.curSkillCount = self.curSkillCount + 1
      if self.curSkillCount <= class.maxShowSkillCount then
        target.actor:addEffect(name, effect_z)
      end
    else
      target.actor:addEffect(name, effect_z)
    end
  end
  ed.engine:collectSkillHit(self.caster, self, target)
  return true, dmg, Crit, lfs_amount
end

function PetPig.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetPig_buffadded = nil
  pet.PetPig_skillpasv_casted = nil
  pet.PetPig_firsttick = nil
  pet.PetPig_skillatk1_countdown = nil
  pet.PetPig_skillatk1_started = nil
  pet.PetPig_skillatk1_casted = nil
  pet.PetPig_skillatk1_invisible = nil
end

function PetPig.init_hero(hero)
  hero.update = override(hero.update, PetPig.hero_update)
  hero.reset = override(hero.reset, PetPig.hero_reset)
  local skillatk1sub = hero.skills.PetPig_atk1_1
  return hero
end

return PetPig.init_hero
