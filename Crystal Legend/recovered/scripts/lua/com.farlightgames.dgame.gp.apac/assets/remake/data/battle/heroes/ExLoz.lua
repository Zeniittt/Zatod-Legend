module("ed.battlehero", package.seeall)
local ed = ed
ExLoz = {}

function ExLoz.skillult_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  local projectile2 = basefunc(skill)
  local attack_counter = skill.attack_counter
  local position = skill.caster.position
  local direction = skill.caster.direction
  projectile2.position[1] = position[1] + 93.2715 * direction
  projectile2.height = 52.6295
  ed.engine:addProjectile(projectile2)
  if attack_counter == 1 or attack_counter == 4 or attack_counter == 8 then
    local skill4 = skill.caster.skills.ExLoz_atk4
    if skill4 then
      skill4:selectTarget(nil)
      local projectile3 = skill4:createProjectile()
      if skill4.target and skill4.target:isAlive() then
        projectile3:enableTrack(skill4.target)
        projectile3.mytarget = skill4.target
      end
      projectile3.position[1] = position[1] + -2.9767500000000098 * direction
      projectile3.height = 86.9535
      ed.engine:addProjectile(projectile3)
      skill4:selectTarget(nil)
      local projectile4 = skill.caster.skills.ExLoz_atk4:createProjectile()
      if skill4.target and skill4.target:isAlive() then
        projectile4:enableTrack(skill4.target)
        projectile4.mytarget = skill4.target
      end
      projectile4.position[1] = position[1] + 21.870000000000005 * direction
      projectile4.height = 85.27275
      ed.engine:addProjectile(projectile4)
    end
  end
  return projectile
end

function ExLoz.skill4_projectile_update(basefunc, projectile, dt)
  basefunc(projectile, dt)
  projectile.zSpeed = projectile.zSpeed - projectile.skill.info["Tile Gravity"] * dt
  local dv = 600 * dt
  local target = projectile.mytarget
  if not target then
    return
  end
  target = target.position
  local xySpeed = projectile.velocity
  local zSpeed = projectile.zSpeed
  local v = {
    xySpeed[1],
    xySpeed[2],
    zSpeed
  }
  local targetxyV = ed.edpSub(target, projectile.position)
  local targetzV = -projectile.height
  local u = (targetxyV[1] * targetxyV[1] + targetxyV[2] * targetxyV[2] + targetzV * targetzV) ^ (-0.5)
  local targetV = {
    u * targetxyV[1],
    u * targetxyV[2],
    u * targetzV
  }
  if zSpeed and dv < zSpeed then
    projectile.zSpeed = projectile.zSpeed - dv
    dv = 0
  elseif zSpeed and 0 < zSpeed then
    dv = dv - zSpeed
    projectile.zSpeed = 0
  end
  projectile.velocity[1] = projectile.velocity[1] + targetV[1] * dv * 8
  projectile.velocity[2] = projectile.velocity[2] + targetV[2] * dv * 8
  projectile.zSpeed = projectile.zSpeed + targetV[3] * dv * 8
end

function ExLoz.skill4_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  if skill.target and skill.target:isAlive() then
    projectile:enableTrack(skill.target)
    projectile.mytarget = skill.target
  end
  projectile.update = override(projectile.update, ExLoz.skill4_projectile_update)
  local position = skill.caster.position
  local direction = skill.caster.direction
  skill:selectTarget(nil)
  local projectile2 = basefunc(skill)
  projectile2.position[1] = position[1] + 13.283999999999992 * direction
  projectile2.height = 71.28
  if skill.target and skill.target:isAlive() then
    projectile2:enableTrack(skill.target)
    projectile2.mytarget = skill.target
  end
  ed.engine:addProjectile(projectile2)
  projectile2.update = override(projectile2.update, ExLoz.skill4_projectile_update)
  return projectile
end

function ExLoz.buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skill2 = caster.skills.ExLoz_atk2
  buff.hurtcounts = buff.hurtcounts + 1
  if buff.hurtcounts % 3 == 1 and not owner:isHasUncontrolBufEffect() then
    local damage = skill2.info["Basic Num"] + skill2.info["Plus Ratio"] * caster.attribs[skill2.info["Plus Attr"]] or 0
    owner:takeDamage(damage, "AP", "hp", owner)
    owner:hurt()
  end
  basefunc(buff, dt)
end

function ExLoz.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.total_dmg = 0
  buff.total_times = 0
  buff.update = override(buff.update, ExLoz.buff_update)
  local caster = skill.caster
  caster.skill2target = target
  caster.skill2buff = buff
  buff.hurtcounts = 0
  return buff
end

function ExLoz.chain_jump(basefunc, self)
  self.jumps_remaining = self.jumps_remaining - 1
  self.jump_timer = self.jump_timer + self.skill.info["Chain Gap"]
  self.affect_times[self.target] = (self.affect_times[self.target] or 0) + 1
  self.skill:takeEffectOn(self.target)
  if ed.run_with_scene and self.skill.info["Chain Effect"] then
    local effect = ed.ChainEffectCreate(self)
    ed.scene:addEffect(effect, -1)
  end
end

function ExLoz.skill2_createChain(basefunc, skill)
  local info = skill.info
  local self = ed.Entity.create()
  local class = {
    mt = {}
  }
  self.skill = skill
  self.source = skill.caster
  self.target = skill.target
  self.jumps_remaining = info["Chain Jumps"]
  self.jump_timer = 0
  self.affect_times = {}
  setmetatable(self, ed.Chain.mt)
  self.jump = override(self.jump, ExLoz.chain_jump)
  self:jump()
  return self
end

function ExLoz.skillatk2_onAttackFrame(basefunc, self)
  local attack_counter = self.attack_counter
  local caster = self.caster
  if attack_counter == 0 then
    basefunc(self)
  elseif caster.skill2target and caster.skill2buff then
    caster.skill2target:removeBuff(caster.skill2buff)
  end
end

function ExLoz.takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
  end
  field = field or "hp"
  if field == "hp" then
    if ed.run_with_scene then
      local str = "-0"
      local color = "orange"
      ed.PopupCreate(str, color, self.actor, false)
    end
    if self.hp <= 1 then
      self:setHP(0)
      self:die(source)
      return 1
    end
    return 0.01
  else
    return basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  end
end

function ExLoz.init_hero(hero)
  local skillult = hero.skills.ExLoz_ult
  skillult.createProjectile = override(skillult.createProjectile, ExLoz.skillult_createProjectile)
  local skillatk2 = hero.skills.ExLoz_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, ExLoz.skillatk2_createBuff)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, ExLoz.skillatk2_onAttackFrame)
    skillatk2.createChain = override(skillatk2.createChain, ExLoz.skill2_createChain)
  end
  local skillatk4 = hero.skills.ExLoz_atk4
  if skillatk4 then
    skillatk4.createProjectile = override(skillatk4.createProjectile, ExLoz.skill4_createProjectile)
  end
  hero.takeDamage = override(hero.takeDamage, ExLoz.takeDamage)
  return hero
end

return ExLoz.init_hero
