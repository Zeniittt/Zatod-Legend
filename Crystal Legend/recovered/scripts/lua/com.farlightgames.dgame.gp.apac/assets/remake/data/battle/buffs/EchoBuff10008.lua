local function Echobuff10008_projectileHit(basefunc, self, target)
  local skill = self.skill
  
  local caster = self.caster
  local target = self.target
  if caster and target then
    local AP = caster.attribs.AP
    target:takeDamage(AP, "AP", "hp", caster)
  end
  self:terminate()
  if ed.run_with_scene then
    local effect_name = "eff_impact_TitanBW_atk2.cha"
    local effect_z = 1
    ed.scene:playEffectOnScene(effect_name, target.position, {
      target.direction * 0.6,
      0.6
    }, nil, effect_z)
  end
end

local function Echobuff10008_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner then
    local basic_skill = owner.basic_skill
    if owner.current_skill and owner.current_skill ~= basic_skill and owner.last_skill ~= owner.current_skill then
      owner.last_skill = owner.current_skill
      local skill_MoLiHua = caster.echoSkillList.Magic_arrow_sub
      if skill_MoLiHua then
        for unit in ed.engine:foreachAliveUnit(owner.foecamp) do
          skill_MoLiHua.target = unit
        end
        local projectile = skill_MoLiHua:createProjectile()
        projectile.target = skill_MoLiHua.target
        projectile.position = {
          owner.position[1],
          owner.position[2] + 20
        }
        projectile.height = 20
        projectile.caster = owner
        local d = {
          projectile.target.position[1] - projectile.position[1],
          projectile.target.position[2] - projectile.position[2]
        }
        projectile.zSpeed = (projectile.target.position[2] - projectile.height) / math.abs((projectile.target.position[1] - projectile.position[1]) / skill_MoLiHua.info["Tile XY Speed"])
        projectile.velocity = ed.edpMult(ed.edpNormalize(d), skill_MoLiHua.info["Tile XY Speed"])
        projectile.hit = override(projectile.hit, Echobuff10008_projectileHit)
        ed.engine:addProjectile(projectile)
      end
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, Echobuff10008_update)
  return buff
end

return initBuff
