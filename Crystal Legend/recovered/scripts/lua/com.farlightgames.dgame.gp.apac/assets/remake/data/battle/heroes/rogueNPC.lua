module("ed.battlehero", package.seeall)
local ed = ed
rogueNPC = {}
rogueNPC.name = "rogueNPC"

function rogueNPC.collectSkillStart(basefunc, self, caster, skill, target)
  basefunc(self, caster, skill, target)
  if ed.engine.rogue_mode then
    if ed.engine.rogueSkillMgr:getBless(1310) and caster.camp == 1 and not caster.config.is_summoned then
      local bless1310 = ed.engine.rogueSkillMgr.rogueBlessList[1310]
      if skill.info.Manual == true and skill.info["Plus Attr"] == "AD" then
        for unit in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
          if not unit.buff_effects.invulnerable then
            local buffInfo = ed.getDataTable("Buff")[60001310]
            local buff = ed.BuffCreate(buffInfo, unit, caster)
            buff.timer = bless1310.isReinforced and bless1310.info["Script Arg6"] or bless1310.info["Script Arg2"]
            buff:setAttribute("ARM", -(unit.attribs.ARM * (bless1310.isReinforced and bless1310.info["Script Arg5"] or bless1310.info["Script Arg1"]) / 100))
            unit:addBuff(buff, caster)
          end
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(2201) and caster.camp == 1 and not caster.config.is_summoned then
      local bless2201 = ed.engine.rogueSkillMgr.rogueBlessList[2201]
      local basicskill = caster.basic_skill
      local manualskill = caster.manual_skill
      local bless2201buff
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 60002201 then
          bless2201buff = tbuff
        end
      end
      if bless2201buff and skill ~= basicskill and skill ~= manualskill then
        if ed.engine.rogueSkillMgr:getBless(2203) then
          local bless2203 = ed.engine.rogueSkillMgr.rogueBlessList[2203]
          local p = (bless2203.isReinforced and bless2203.info["Script Arg5"] or bless2203.info["Script Arg1"]) / 100
          if p >= ed.rand() then
            caster.rogueBless2201count = caster.rogueBless2201count + (bless2203.isReinforced and bless2203.info["Script Arg6"] or bless2203.info["Script Arg2"])
          else
            caster.rogueBless2201count = caster.rogueBless2201count + (bless2201.isReinforced and bless2201.info["Script Arg5"] or bless2201.info["Script Arg1"])
          end
        else
          caster.rogueBless2201count = caster.rogueBless2201count + (bless2201.isReinforced and bless2201.info["Script Arg5"] or bless2201.info["Script Arg1"])
        end
        if caster.rogueBless2201count >= caster.rogueBless2201maxcount then
          caster.rogueBless2201count = caster.rogueBless2201maxcount
        end
        bless2201buff:setAttribute("APDP", (bless2201.isReinforced and bless2201.info["Script Arg6"] or bless2201.info["Script Arg2"]) * caster.rogueBless2201count)
        if ed.engine.rogueSkillMgr:getBless(2401) then
          local bless2401 = ed.engine.rogueSkillMgr.rogueBlessList[2401]
          bless2201buff:setAttribute("ARM", bless2401.info["Script Arg1"] * caster.rogueBless2201count)
          bless2201buff:setAttribute("MR", bless2401.info["Script Arg2"] * caster.rogueBless2201count)
        end
        if ed.engine.rogueSkillMgr:getBless(2402) then
          local bless2402 = ed.engine.rogueSkillMgr.rogueBlessList[2402]
          bless2201buff:setAttribute("CON", bless2402.info["Script Arg1"] * caster.rogueBless2201count)
        end
        if ed.engine.rogueSkillMgr:getBless(2403) then
          local bless2403 = ed.engine.rogueSkillMgr.rogueBlessList[2403]
          bless2201buff:setAttribute("DotDRatio", bless2403.info["Script Arg1"] * caster.rogueBless2201count)
        end
        if ed.engine.rogueSkillMgr:getBless(2404) then
          local bless2404 = ed.engine.rogueSkillMgr.rogueBlessList[2404]
          bless2201buff:setAttribute("ShieldIncrease", bless2404.info["Script Arg1"] * caster.rogueBless2201count)
        end
        if ed.engine.rogueSkillMgr:getBless(2205) then
          local bless2205 = ed.engine.rogueSkillMgr.rogueBlessList[2205]
          bless2201buff:setAttribute("LFS", (bless2205.isReinforced and bless2205.info["Script Arg6"] or bless2205.info["Script Arg2"]) * caster.rogueBless2201count)
        end
        caster:rebuild()
        if ed.run_with_scene and caster.actor then
          if not caster.bless2201effect then
            caster.bless2201effectlast = 1
            caster.bless2201effectFirstTime = true
          end
          caster.bless2201effect = caster.rogueBless2201count
          if caster.bless2201effect >= caster.rogueBless2201maxcount then
            caster.bless2201effect = caster.rogueBless2201maxcount
          end
          if caster.bless2201effectFirstTime or caster.bless2201effect ~= caster.bless2201effectlast then
            local effect_name = bless2201buff.bless2201EffectList[caster.bless2201effect]
            local effect_id = caster.actor:addEffect(effect_name, 1)
            local actor = caster.actor
            local direction = caster.direction
            local effect = actor:getEffectById(effect_id)
            if effect then
              local scaleX = effect:getScaleX()
              effect:setScaleX(direction)
            end
            if caster.bless2201preEffectID then
              caster.actor.puppet:removeEffectWithID(caster.bless2201preEffectID)
            end
            caster.bless2201preEffectID = effect_id
            caster.bless2201effectFirstTime = false
            caster.bless2201effectlast = caster.bless2201effect
          end
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(2204) and caster.camp == 1 and not caster.config.is_summoned then
      local bless2204 = ed.engine.rogueSkillMgr.rogueBlessList[2204]
      if skill == caster.manual_skill and caster.rogueBless2204count == 0 then
        caster.rogueBless2204count = 1
        local mp = caster.rogueBless2201count * (bless2204.isReinforced and bless2204.info["Script Arg5"] or bless2204.info["Script Arg1"])
        caster:takeHeal(mp, "mp", caster)
      end
    end
    if ed.engine.rogueSkillMgr:getBless(2315) and caster.camp == 1 and not caster.config.is_summoned then
      local bless2315 = ed.engine.rogueSkillMgr.rogueBlessList[2315]
      local basicskill = caster.basic_skill
      local manualskill = caster.manual_skill
      if skill.info["Damage Type"] and skill.info["Plus Attr"] == "AP" and skill ~= basicskill and skill ~= manualskill then
        local p = (bless2315.isReinforced and bless2315.info["Script Arg5"] or bless2315.info["Script Arg1"]) / 100
        if skill.info.CD < 90 and 90 > skill.info["Init CD"] and p >= ed.rand() then
          skill.cd_remaining = 0
          if ed.run_with_scene then
            local effect_name = "eff_point_FV_fashion.cha"
            ed.scene:playEffectOnScene(effect_name, caster.position, {
              caster.direction,
              1
            }, nil, 1)
          end
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(3310) and caster.camp == 1 and not caster.config.is_summoned then
      local bless3310 = ed.engine.rogueSkillMgr.rogueBlessList[3310]
      if skill.info.Manual == true and caster.rogueBless3310count == 0 then
        caster.rogueBless3310count = 1
        local buffInfo = ed.getDataTable("Buff")[60003310]
        local buff = ed.BuffCreate(buffInfo, caster, caster)
        buff:setAttribute("HP", caster.attribs.HP * (bless3310.isReinforced and bless3310.info["Script Arg5"] or bless3310.info["Script Arg1"]) / 100)
        caster:addBuff(buff, caster)
      end
    end
    if ed.engine.rogueSkillMgr:getBless(4307) and caster.camp == 1 and not caster.config.is_summoned then
      local bless4307 = ed.engine.rogueSkillMgr.rogueBlessList[4307]
      if skill.info["Damage Type"] == "Heal" then
        local p = (bless4307.isReinforced and bless4307.info["Script Arg5"] or bless4307.info["Script Arg1"]) / 100
        if p >= ed.rand() then
          caster:takeHeal(bless4307.isReinforced and bless4307.info["Script Arg6"] or bless4307.info["Script Arg2"], "hp", caster)
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(4310) and caster.camp == 1 and not caster.config.is_summoned then
      local bless4310 = ed.engine.rogueSkillMgr.rogueBlessList[4310]
      if skill.info.Manual == true then
        caster:takeHeal(caster.attribs.HP * (bless4310.isReinforced and bless4310.info["Script Arg5"] or bless4310.info["Script Arg1"]) / 100, "hp", caster)
      end
    end
    if ed.engine.rogueSkillMgr:getBless(5310) and caster.camp == 1 and not caster.config.is_summoned then
      local bless5310 = ed.engine.rogueSkillMgr.rogueBlessList[5310]
      if skill.info.Manual == true then
        local buffInfo = ed.getDataTable("Buff")[60005310]
        local buff = ed.BuffCreate(buffInfo, caster, caster)
        buff.timer = bless5310.isReinforced and bless5310.info["Script Arg5"] or bless5310.info["Script Arg1"]
        caster:addBuff(buff, caster)
      end
    end
    if ed.engine.rogueSkillMgr:getBless(6310) and caster.camp == 1 and not caster.config.is_summoned then
      local bless6310 = ed.engine.rogueSkillMgr.rogueBlessList[6310]
      if skill.info.Manual == true then
        for unit in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
          if not unit.buff_effects.invulnerable then
            local bless6310bid = 60016310
            local bless6310binfo = ed.lookupDataTable("Buff", nil, bless6310bid)
            local bless6310buff = ed.BuffCreate(bless6310binfo, unit, caster)
            bless6310buff:setAttribute("HPR", (bless6310.isReinforced and bless6310.info["Script Arg5"] or bless6310.info["Script Arg1"]) * caster.attribs.AD)
            bless6310buff.timer = bless6310.isReinforced and bless6310.info["Script Arg6"] or bless6310.info["Script Arg2"]
            unit:addBuff(bless6310buff, caster)
          end
        end
      end
    end
  end
end

function rogueNPC.collectHPchange(basefunc, self, config)
  local unit = config.unit
  local hp = config.hp
  local hpchange = config.hp_change
  local reason = config.reason
  local attribshp = unit.attribs.HP
  if ed.engine.rogue_mode then
    if unit.camp == -1 and hpchange < 0 and reason == "AD" then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 1 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
    if unit.camp == -1 and hpchange < 0 and reason == "AP" then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 2 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
    if unit.camp == 1 and not unit.config.is_summoned and hpchange < 0 and reason and reason ~= "hprdamage" and reason ~= "bless7315" then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 3 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
    if unit.camp == 1 and not unit.config.is_summoned and (reason == "heal" or reason == "LFS") and 0 < hpchange then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 4 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
    if unit.camp == -1 and hpchange < 0 and reason == "hprdamage" then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 6 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
    if ed.engine.rogueSkillMgr:getBless(4201) then
      local bless4201 = ed.engine.rogueSkillMgr.rogueBlessList[4201]
      local charge = self.bless4201charge
      if charge and self.bless4201chargechange then
        if unit.camp == 1 and not unit.config.is_summoned and (reason == "heal" or reason == "LFS" or reason == "hprheal") and hp > attribshp then
          self.bless4201chargechange = self.bless4201chargechange + (hp - attribshp)
          if do_battle_log then
            btlog("rogueBless4201 chargechange --> %s", self.bless4201chargechange)
          end
        end
        if ed.engine.rogueSkillMgr:getBless(4401) then
          local bless4401 = ed.engine.rogueSkillMgr.rogueBlessList[4401]
          if unit.camp == -1 and hpchange < 0 and reason == "AD" then
            self.bless4201chargechange = self.bless4201chargechange + -hpchange * bless4401.info["Script Arg1"] / 100
            if do_battle_log then
              btlog("rogueBless4201 chargechange --> %s", self.bless4201chargechange)
            end
          end
        end
        if ed.engine.rogueSkillMgr:getBless(4402) then
          local bless4402 = ed.engine.rogueSkillMgr.rogueBlessList[4402]
          if unit.camp == -1 and hpchange < 0 and reason == "AP" then
            self.bless4201chargechange = self.bless4201chargechange + -hpchange * bless4402.info["Script Arg1"] / 100
            if do_battle_log then
              btlog("rogueBless4201 chargechange --> %s", self.bless4201chargechange)
            end
          end
        end
        if self.bless4201chargechange and charge and charge <= self.bless4201chargechange then
          self.bless4201chargechange = 0
          if do_battle_log then
            btlog("rogueBless4201 chargechange --> %s", self.bless4201chargechange)
          end
          for enemy in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
            local belss4201damage = charge * bless4201.info["Script Arg2"]
            if bless4201.isReinforced then
              belss4201damage = charge * bless4201.info["Script Arg6"]
            end
            if do_battle_log then
              btlog("rogueBless4201 takeDamage --> %s", belss4201damage)
            end
            enemy:takeDamage(belss4201damage, "Holy", "hp", self, 1, 1, true)
            if ed.engine.rogueSkillMgr:getBless(4203) then
              local bless4203 = ed.engine.rogueSkillMgr.rogueBlessList[4203]
              local list = enemy.buff_list
              local buff_list = {}
              local myenemycamp = -1
              for i = 1, #list do
                local buff = list[i]
                if buff and (not buff.caster or buff.caster.camp == myenemycamp) and buff.info.Dispel == "YES" then
                  buff_list[#buff_list + 1] = buff
                end
              end
              for i = 1, #buff_list do
                enemy:removeBuff(buff_list[i])
              end
              if bless4203.isReinforced and not enemy.buff_effects.invulnerable then
                local bless4203bid = 60004203
                local bless4203binfo = ed.lookupDataTable("Buff", nil, bless4203bid)
                local bless4203buff = ed.BuffCreate(bless4203binfo, enemy, self)
                bless4203buff:setAttribute("HealRatio", bless4203.info["Script Arg5"])
                bless4203buff.timer = ed.engine.rogueSkillMgr.rogueBlessList[4203].info["Script Arg6"]
                enemy:addBuff(bless4203buff, self)
              end
            end
          end
          for player in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
            if ed.engine.rogueSkillMgr:getBless(4204) then
              local bless4204 = ed.engine.rogueSkillMgr.rogueBlessList[4204]
              local heal = (bless4204.isReinforced and bless4204.info["Script Arg5"] or bless4204.info["Script Arg1"]) / 100 * charge
              local maxheal = bless4204.isReinforced and bless4204.info["Script Arg6"] or bless4204.info["Script Arg2"]
              player:takeHeal(math.min(heal, maxheal), "hp", self, "bless4204")
            end
            if ed.engine.rogueSkillMgr:getBless(4205) then
              local bless4205 = ed.engine.rogueSkillMgr.rogueBlessList[4205]
              local bless4205bid = 60004205
              local bless4205binfo = ed.lookupDataTable("Buff", nil, bless4205bid)
              local bless4205buff = ed.BuffCreate(bless4205binfo, player, self)
              bless4205buff.timer = bless4205.isReinforced and bless4205.info["Script Arg5"] or bless4205.info["Script Arg1"]
              player:addBuff(bless4205buff, self)
            end
            if ed.engine.rogueSkillMgr:getBless(4403) then
              local bless4403 = ed.engine.rogueSkillMgr.rogueBlessList[4403]
              local ShieldIncrease = 0
              local ShieldWeak = 0
              if player.attribs.ShieldIncrease then
                ShieldIncrease = player.attribs.ShieldIncrease
              end
              if player.attribs.ShieldWeak then
                ShieldWeak = player.attribs.ShieldWeak
              end
              local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
              local shieldnum = charge * bless4403.info["Script Arg1"] / 100 * shieldratio
              local have4403buff = false
              for i, tbuff in ipairs(player.buff_list) do
                if tbuff.info.ID == 60017000 then
                  tbuff.shield = tbuff.shield + shieldnum
                  have4403buff = true
                end
              end
              if not have4403buff then
                local bless4403bid = 60017000
                local bless4403binfo = ed.lookupDataTable("Buff", nil, bless4403bid)
                local bless4403buff = ed.BuffCreate(bless4403binfo, player, player)
                bless4403buff.shield = shieldnum
                player:addBuff(bless4403buff, player)
              end
            end
            if ed.engine.rogueSkillMgr:getBless(4404) then
              local bless4404 = ed.engine.rogueSkillMgr.rogueBlessList[4404]
              local bless4404bid = 60004404
              local bless4404binfo = ed.lookupDataTable("Buff", nil, bless4404bid)
              local bless4404buff = ed.BuffCreate(bless4404binfo, player, self)
              bless4404buff:setAttribute("CRIT", 9999)
              bless4404buff:setAttribute("MCRIT", 9999)
              bless4404buff.timer = bless4404.info["Script Arg1"]
              player:addBuff(bless4404buff, self)
            end
          end
          if ed.run_with_scene then
            local effect_name = "eff_UI_rogue4201_boom.cha"
            if effect_name then
              ed.scene:playEffectOnScene(effect_name, {400, 120}, {1, 1}, nil, 1)
            end
          end
        end
        if ed.run_with_scene then
          local percent = self.bless4201chargechange / charge
          if bless4201.clipLayer and bless4201.eff_charging then
            bless4201.clipLayer:setClipRect(CCRectMake(0, 0, bless4201.size.width * bless4201.scale, bless4201.size.height * bless4201.scale * percent))
            bless4201.eff_charging:setPosition(ccp(0, -34 + 68 * percent))
          end
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(4312) then
      local bless4312 = ed.engine.rogueSkillMgr.rogueBlessList[4312]
      if unit.camp == 1 and not unit.config.is_summoned and (reason == "heal" or reason == "LFS") and 0 < hpchange then
        local p = (bless4312.isReinforced and bless4312.info["Script Arg5"] or bless4312.info["Script Arg1"]) / 100
        if p >= ed.rand() then
          local max = -math.huge
          local chosen
          for target in ed.engine:foreachAliveUnit(-1) do
            if target.buff_effects.untargetable then
            elseif target.buffManager.invisible and target.camp ~= unit.camp then
            else
              local v = ed.rand()
              if max < v then
                max = v
                chosen = target
              end
            end
          end
          local bless4312damage = unit.attribs.AP * (bless4312.isReinforced and bless4312.info["Script Arg6"] or bless4312.info["Script Arg2"])
          if chosen then
            chosen:takeDamage(bless4312damage, "AP", "hp", unit, 1, 1, true)
            if ed.run_with_scene then
              local effect_name = "eff_impact_TS_ult.cha"
              if effect_name then
                ed.scene:playEffectOnScene(effect_name, chosen.position, {
                  chosen.direction,
                  1
                }, nil, 1)
              end
            end
          end
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(4313) then
      local bless4313 = ed.engine.rogueSkillMgr.rogueBlessList[4313]
      if unit.camp == 1 and not unit.config.is_summoned and (reason == "heal" or reason == "LFS") and 0 < hpchange then
        local p = (bless4313.isReinforced and bless4313.info["Script Arg5"] or bless4313.info["Script Arg1"]) / 100
        if p >= ed.rand() then
          local list = unit.buff_list
          local debuff_list = {}
          local my_camp = unit.camp
          for i = 1, #list do
            local buff = list[i]
            if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
              debuff_list[#debuff_list + 1] = buff
            end
          end
          for i = 1, #debuff_list do
            unit:removeBuff(debuff_list[i])
          end
        end
      end
    end
    if ed.engine.rogueSkillMgr:getBless(4315) then
      local bless4315 = ed.engine.rogueSkillMgr.rogueBlessList[4315]
      if unit.camp == 1 and not unit.config.is_summoned and (reason == "heal" or reason == "LFS") and 0 < hpchange then
        local p = (bless4315.isReinforced and bless4315.info["Script Arg5"] or bless4315.info["Script Arg1"]) / 100
        unit:takeHeal(hpchange * p, "mp", self)
      end
    end
    if ed.engine.rogueSkillMgr:getBless(7312) then
      local bless7312 = ed.engine.rogueSkillMgr.rogueBlessList[7312]
      if unit.camp == 1 and not unit.config.is_summoned and hpchange < 0 and reason ~= "bless7315" then
        local bless7312p = (bless7312.isReinforced and bless7312.info["Script Arg5"] or bless7312.info["Script Arg1"]) / 100
        local bless7312shield = -hpchange * bless7312p
        local ShieldIncrease = 0
        local ShieldWeak = 0
        if unit.attribs.ShieldIncrease then
          ShieldIncrease = unit.attribs.ShieldIncrease
        end
        if unit.attribs.ShieldWeak then
          ShieldWeak = unit.attribs.ShieldWeak
        end
        local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
        local shieldnum = bless7312shield * shieldratio
        local have7312buff = false
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == 60017000 then
            tbuff.shield = tbuff.shield + shieldnum
            have7312buff = true
          end
        end
        if not have7312buff then
          local bless7312bid = 60017000
          local bless7312binfo = ed.lookupDataTable("Buff", nil, bless7312bid)
          local bless7312buff = ed.BuffCreate(bless7312binfo, unit, unit)
          bless7312buff.shield = shieldnum
          unit:addBuff(bless7312buff, unit)
        end
      end
    end
    if not ed.engine.rogueSkillMgr:getBless(8401) and unit.camp == 1 and not unit.config.is_summoned and hpchange < 0 and reason and reason ~= "hprdamage" and reason ~= "bless7315" and unit.rogueBless8201count then
      unit.rogueBless8201count = math.max(unit.rogueBless8201count - 1, 0)
    end
  end
end

function rogueNPC.takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred, damageinfo)
end

function rogueNPC.collectBuff(basefunc, self, config)
  local buff = config.buff
  local caster = buff.caster
  local owner = buff.owner
  local control_effects = {
    stun = true,
    frozen = true,
    icefrozen = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    doom = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true
  }
  
  local function isCrlEftConflictWithControl(buff)
    local isRet = false
    local info = buff.info
    for i, effect in ipairs(info["Control Effects"]) do
      if control_effects[effect] then
        isRet = true
        break
      end
    end
    return isRet
  end
  
  if ed.engine.rogue_mode then
    if owner and owner.camp == 1 and not owner.config.is_summoned and buff.shield and buff.shield > 0 then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 7 then
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
    end
    if caster and caster.camp == 1 and not caster.config.is_summoned and owner.camp == -1 and isCrlEftConflictWithControl(buff) then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation.destinyId == 5 and owner.roguebuff5000_controlcd and buff.info.ID ~= 60005000 then
        owner.roguebuff5000_controlcd = false
        revelation:addEnergy(revelation.info.EnergyAdd)
      end
      if ed.engine.rogueSkillMgr:getBless(5313) and caster.roguebuff5313_controlcd then
        caster.roguebuff5313_controlcd = false
        local bless5313 = ed.engine.rogueSkillMgr.rogueBlessList[5313]
        local mpbless5313 = bless5313.isReinforced and bless5313.info["Script Arg5"] or bless5313.info["Script Arg1"]
        caster:takeHeal(mpbless5313, "mp", self)
      end
      if ed.engine.rogueSkillMgr:getBless(5402) and caster.roguebuff5402_controlcd then
        caster.roguebuff5402_controlcd = false
        local bless5402 = ed.engine.rogueSkillMgr.rogueBlessList[5402]
        local hpbless5402 = bless5402.isReinforced and bless5402.info["Script Arg5"] or bless5402.info["Script Arg1"]
        caster:takeHeal(hpbless5402, "hp", self)
      end
      if ed.engine.rogueSkillMgr:getBless(7403) and caster.roguebuff7403_controlcd then
        caster.roguebuff7403_controlcd = false
        local bless7403 = ed.engine.rogueSkillMgr.rogueBlessList[7403]
        local shieldbless7403 = bless7403.info["Script Arg1"]
        local ShieldIncrease = 0
        local ShieldWeak = 0
        if caster.attribs.ShieldIncrease then
          ShieldIncrease = caster.attribs.ShieldIncrease
        end
        if caster.attribs.ShieldWeak then
          ShieldWeak = caster.attribs.ShieldWeak
        end
        local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
        local shieldnum = shieldbless7403 * shieldratio
        local have7403buff = false
        for i, tbuff in ipairs(caster.buff_list) do
          if tbuff.info.ID == 60017000 then
            tbuff.shield = tbuff.shield + shieldnum
            have7403buff = true
          end
        end
        if not have7403buff then
          local bless7403bid = 60017000
          local bless7403binfo = ed.lookupDataTable("Buff", nil, bless7403bid)
          local bless7403buff = ed.BuffCreate(bless7403binfo, caster, caster)
          bless7403buff.shield = shieldnum
          caster:addBuff(bless7403buff, caster)
        end
      end
    end
  end
end

function rogueNPC.update(basefunc, self, dt)
  basefunc(self, dt)
  local timer = self.attack_timer - dt
  self.dt = self.dt and self.dt + dt or dt
  if self.dt == 1 and ed.engine.rogueSkillMgr:getBless(4308) then
    local bless4308 = ed.engine.rogueSkillMgr.rogueBlessList[4308]
    for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
      unit:takeHeal((bless4308.isReinforced and bless4308.info["Script Arg5"] or bless4308.info["Script Arg1"]) / 100 * unit.attribs.HP, "hp", self)
    end
  end
  if ed.engine.rogueSkillMgr:getBless(4201) then
    local bless4201 = ed.engine.rogueSkillMgr.rogueBlessList[4201]
    if self.bless4201fristtime then
      self.bless4201fristtime = false
      if ed.run_with_scene and self.bless4201charge and self.bless4201chargechange then
        local building = ed.scene:playSpriteOnScene("UI/alpha/1080P/rogue/bless/eff_point_rogue4201_building.png", {400, 50}, {0.8, 0.8}, nil, -1)
        local node = ed.scene:playSpriteOnScene("UI/alpha/1080P/rogue/bless/eff_point_rogue4201_back.png", {400, 120}, {1, 1}, nil, 0)
        local front = ed.createSprite("UI/alpha/1080P/rogue/bless/eff_point_rogue4201_front.png")
        local clipLayer = CCLayer:create()
        node:addChild(clipLayer)
        local scale = node:getScale()
        local size = node:getContentSize()
        clipLayer:setContentSize(size)
        clipLayer:addChild(front)
        front:setPosition(ccp(size.width / 2, size.height / 2))
        local eff_charging = ed.createFcaNode("eff_UI_rogue_echo_charging")
        local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/rogue/bless/eff_point_rogue4201_front.png")
        clippingNode:addChild(eff_charging)
        node:addChild(clippingNode, 1)
        clippingNode:setPosition(ccp(size.width / 2, size.height / 2))
        ed.scene:addFca(eff_charging)
        eff_charging:setAction("Loop")
        eff_charging:setLoop(true)
        bless4201.eff_charging = eff_charging
        bless4201.clipLayer = clipLayer
        bless4201.scale = scale
        bless4201.size = size
        local percent = self.bless4201chargechange / self.bless4201charge
        bless4201.clipLayer:setClipRect(CCRectMake(0, 0, bless4201.size.width * bless4201.scale, bless4201.size.height * bless4201.scale * percent))
        bless4201.eff_charging:setPosition(ccp(0, -34 + 68 * percent))
      end
    end
  end
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(6403) then
      local bless6403 = ed.engine.rogueSkillMgr.rogueBlessList[6403]
      local totalhprdmg = 0
      local bless6403p = bless6403.info["Script Arg1"] / 100
      for enemy in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
        for i, tbuff in ipairs(enemy.buff_list) do
          if tbuff.info.HPR and 0 > tbuff.info.HPR then
            local buff = tbuff
            local info = buff.info
            local hpr = info.HPR
            local x = info["HPR" .. ".x"]
            if x then
              local a = info["HPR" .. ".a"]
              hpr = hpr + (buff.caster.attribs[x] or 0) * a
            end
            totalhprdmg = totalhprdmg + hpr
          end
        end
      end
      if totalhprdmg < 0 then
        totalhprdmg = -totalhprdmg
      end
      for player in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
        player:takeHeal(totalhprdmg * bless6403p, "hp", self)
      end
    end
  end
  self.attack_timer = timer
end

function rogueNPC.init_hero(hero)
  hero.attack_timer = 1
  hero.bless4201fristtime = true
  hero.collectSkillStart = override(hero.collectSkillStart, rogueNPC.collectSkillStart)
  hero.collectHPchange = override(hero.collectHPchange, rogueNPC.collectHPchange)
  hero.takeDamage = override(hero.takeDamage, rogueNPC.takeDamage)
  hero.update = override(hero.update, rogueNPC.update)
  hero.collectBuff = override(hero.collectBuff, rogueNPC.collectBuff)
  return hero
end

return rogueNPC.init_hero
