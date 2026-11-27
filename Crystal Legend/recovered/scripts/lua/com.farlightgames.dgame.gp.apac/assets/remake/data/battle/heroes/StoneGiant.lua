module("ed.battlehero", package.seeall)
local ed = ed
StoneGiant = {}

function StoneGiant.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster and target and isHit then
    target:hurt()
    if ed.run_with_scene then
      ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
    end
  end
  return isHit, dmg, Crit, lfs_amount
end

function StoneGiant.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  if not self.shieldTime then
    self.shieldTime = 0
  else
    self.shieldTime = self.shieldTime + dt
  end
  if self.shieldTime and self.shieldTime >= 10 then
    local skillatk3 = self.skills.StoneGaint_atk3
    if skillatk3 then
      skillatk3:takeEffectOn(self)
    end
    self.shieldTime = 0
  end
end

function StoneGiant.init_hero(hero)
  local skillatk2 = hero.skills.StoneGaint_atk2
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, StoneGiant.skillatk2_takeEffectOn)
  end
  hero.update = override(hero.update, StoneGiant.hero_update)
  return hero
end

return StoneGiant.init_hero
