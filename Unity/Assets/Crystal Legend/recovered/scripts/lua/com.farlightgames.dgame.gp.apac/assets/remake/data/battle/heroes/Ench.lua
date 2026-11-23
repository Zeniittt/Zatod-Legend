module("ed.battlehero", package.seeall)
local ed = ed
Ench = {}
Ench.ultEvobuff = 10004502
Ench.damagePercentCast = 0.25
Ench.skillFashionId = 451

function Ench.skillatk3_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  if target.basic_skill.cd_remaining < 90 then
    target.basic_skill.cd_remaining = 0
    target.global_cd = 0
  end
end

function Ench.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Ench.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillevo = caster.skills.Ench_evo
  local heal = caster.attribs.HEAL or 0
  local power, coefficient = skill:power(source, target, "HP")
  local power = power * (1 + heal / 100)
  local amount = power * (math.max((target.attribs.HealRatio or 0) / 100, -1) + 1)
  local havebuff = false
  local buff
  for i, tbuff in ipairs(target.buff_list) do
    if tbuff.info.ID == Ench.ultEvobuff then
      havebuff = true
      buff = tbuff
    end
  end
  if skillevo and target and target.hp + amount >= target.attribs.HP and not target.buff_effects.unheal then
    local ShieldIncrease = 0
    local ShieldWeak = 0
    if target.attribs.ShieldIncrease then
      ShieldIncrease = target.attribs.ShieldIncrease
    end
    if target.attribs.ShieldWeak then
      ShieldWeak = target.attribs.ShieldWeak
    end
    local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
    local max = skillevo.info["Script Arg2"] * (caster.config.hp_mod or 1)
    if havebuff then
      buff.shield = buff.shield + amount * shieldratio
      if max < buff.shield then
        buff.shield = max
      end
    else
      if not target.buff_effects.invulnerable then
        local bid = Ench.ultEvobuff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
      end
      if buff then
        buff.shield = (target.hp + amount - target.attribs.HP) * shieldratio
        if max < buff.shield then
          buff.shield = max
        end
      end
    end
  end
  basefunc(skill, target)
end

function Ench.skillatk_onAttackFrame(basefunc, self)
  local originInfo = self.info
  local caster = self.caster
  if Ench.skillFashionId and Ench.skillFashionId == caster.fashion_id then
    self.info = ed.wraptable(originInfo, {
      ["Tile Art"] = "eff_tile_Ench_atk__fashion_cake.cha"
    })
    basefunc(self)
  else
    basefunc(self)
  end
  self.info = originInfo
end

function Ench.skillatk2_onAttackFrame(basefunc, self)
  local originInfo = self.info
  local caster = self.caster
  if Ench.skillFashionId and Ench.skillFashionId == caster.fashion_id then
    self.info = ed.wraptable(originInfo, {
      ["Tile Art"] = "eff_tile_Ench_atk2__fashion_cake.cha"
    })
    basefunc(self)
  else
    basefunc(self)
  end
  self.info = originInfo
end

function Ench.init_hero(hero)
  hero.DamageCount_Ench = 0
  local skillult = hero.skills.Ench_ult
  local skillatk = hero.skills.Ench_atk
  local skillatk2 = hero.skills.Ench_atk2
  local skillatk3 = hero.skills.Ench_atk3
  local skillpasv = hero.passive_skill_list[1]
  local skillfashion_cake = hero.skills.Ench_fashion_cake
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.takeEffectOn = override(skillult.takeEffectOn, Ench.skillult_takeEffectOn)
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
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
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Ench.skillatk3_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, Ench.skillatk3_createBuff)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  if Ench.skillFashionId and Ench.skillFashionId == hero.fashion_id and skillfashion_cake and skillatk and skillatk2 then
    skillatk.onAttackFrame = override(skillatk.onAttackFrame, Ench.skillatk_onAttackFrame)
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Ench.skillatk2_onAttackFrame)
  end
  return hero
end

return Ench.init_hero
