local class = newclass("g")
ed.rogueBless3315 = class

function class.sheep_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit:isAlive() then
    local timer = unit.attack_timer - dt
    local walktimer = unit.walktimer - dt
    while timer <= 0 do
      timer = timer + 1
      local havebless3315buff
      for target in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
        local bless = ed.engine.rogueSkillMgr.rogueBlessList[3315]
        for i, tbuff in ipairs(target.buff_list) do
          if tbuff.info.ID == 60003315 then
            havebless3315buff = true
          end
        end
        if not havebless3315buff then
          local buffInfo = ed.getDataTable("Buff")[60003315]
          local buff = ed.BuffCreate(buffInfo, target, unit)
          if bless.isReinforced then
            buff:setAttribute("ADDP", -bless.info["Script Arg7"])
            buff:setAttribute("APDP", -bless.info["Script Arg7"])
            buff.info["Actor Scale"] = {0.7, 0.7}
          end
          target:addBuff(buff, unit)
        end
      end
    end
    unit.state = ed.emUnitState_Walk
    unit:setAction("Move", true)
    while walktimer <= 0 do
      walktimer = walktimer + 2
      unit.bless3315time = unit.bless3315time + 1
      unit.bless3315p = math.max(0.5, ed.rand() * 2)
    end
    local v
    if unit.bless3315time % 2 == 0 then
      v = 100 * (unit.bless3315p or 1)
    elseif unit.bless3315time % 2 == 1 then
      v = -100 * (unit.bless3315p or 1)
    end
    unit.walk_v = {v, 0}
    unit.attack_timer = timer
    unit.walktimer = walktimer
  end
end

function class.sheep_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred, damageinfo)
  local lost = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred, damageinfo)
  local amount = struct_table
  local skillTags
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
    skillTags = struct_table.skillTags
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  if not self:isAlive() then
    return 0
  end
  if ed.engine.rogueSkillMgr:getBless(3201) then
    local bless3201 = ed.engine.rogueSkillMgr.rogueBlessList[3201]
    if lost and 0 < lost then
      for player in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
        if player.rogueBless3201count then
          player.rogueBless3201count = math.min(player.rogueBless3201maxCount, player.rogueBless3201count + 1)
        end
      end
    end
  end
  if ed.engine.rogueSkillMgr:getBless(3203) then
    local bless3203 = ed.engine.rogueSkillMgr.rogueBlessList[3203]
    local bless3315 = ed.engine.rogueSkillMgr.rogueBlessList[3315]
    if lost and 0 < lost then
      local rogueBless3203dmg = (bless3315.isReinforced and bless3315.info["Script Arg8"] or bless3315.info["Script Arg3"]) / 100 * self.attribs.HP
      if source and source.camp ~= self.camp then
        source:takeDamage(rogueBless3203dmg, "Holy", "hp", self, 1, 1, true)
      end
    end
  end
  return lost
end

function class.initBless(bless)
  local sheepid = 501
  if bless.isReinforced then
    sheepid = 502
  end
  local proto = {
    _tid = sheepid,
    _level = 1,
    _stars = 5,
    _rank = 11
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = 1
  }
  local sheep = ed.UnitCreate(proto, 1, config)
  sheep:setDeathWithEffectOrNot(true)
  sheep.direction = 1
  local location = {500, 0}
  ed.engine:summonUnit(sheep, location, ed.engine.rogueSkillMgr.magicCaster)
  local totalhp = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    local hp = unit.attribs.HP
    totalhp = totalhp + hp
  end
  local buffInfo = ed.getDataTable("Buff")[60023315]
  local buff = ed.BuffCreate(buffInfo, sheep, sheep)
  buff:setAttribute("HP", totalhp * (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]) / 100)
  buff:setAttribute("ARM", bless.isReinforced and bless.info["Script Arg6"] or bless.info["Script Arg2"])
  buff:setAttribute("MR", bless.isReinforced and bless.info["Script Arg6"] or bless.info["Script Arg2"])
  sheep:addBuff(buff, sheep)
  sheep:takeHeal(sheep.attribs.HP, "hp")
  sheep.attack_timer = 0
  sheep.walktimer = 0
  sheep.bless3315time = 0
  sheep.update = override(sheep.update, class.sheep_update)
  sheep.takeDamage = override(sheep.takeDamage, class.sheep_takeDamage)
  return bless
end

return class.initBless
