local function roguecrisisbuff51_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == 1 then
    local owner = buff.owner
    local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
    if crisisDiff then
      local stage_type = ed.engine.stage_info["Stage Type"]
      local RogueChapter = ed.engine.stage_info["RogueChapter ID"]
      if RogueChapter and RogueChapter == 5 then
        if stage_type and stage_type == "NormalBattle" then
          buff:setAttribute("HP", 0.1 * crisisDiff * owner.attribs.HP / owner.config.hp_mod)
        elseif stage_type and stage_type ~= "NormalBattle" then
          if crisisDiff <= 2 then
            local ARM = owner.attribs.ARM * 0.1 * crisisDiff
            local MR = owner.attribs.MR * 0.1 * crisisDiff
            buff:setAttribute("ARM", ARM)
            buff:setAttribute("MR", MR)
            buff:setAttribute("HP", 0.2 * crisisDiff * owner.attribs.HP / owner.config.hp_mod)
          elseif 2 < crisisDiff then
            local ARM = owner.attribs.ARM * 0.1 * crisisDiff
            local MR = owner.attribs.MR * 0.1 * crisisDiff
            buff:setAttribute("ARM", ARM)
            buff:setAttribute("MR", MR)
            buff:setAttribute("HP", (0.4 + 0.4 * (crisisDiff - 2)) * owner.attribs.HP / owner.config.hp_mod)
          end
        end
        if stage_type and stage_type == "BossBattle" then
          buff:setAttribute("HAST", 5 * crisisDiff)
          buff:setAttribute("MSPD", 5 * crisisDiff)
        end
      end
      owner:rebuild()
      owner:setHP(owner.attribs.HP)
    end
  end
end

local function roguecrisisbuff51_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
  if crisisDiff and 2 < crisisDiff and not bCrit and damage and 0 < damage then
    if crisisDiff == 3 then
      owner:takeHeal(15, "mp", owner)
    end
    if crisisDiff == 4 then
      owner:takeHeal(30, "mp", owner)
    end
  end
  return damage
end

local function initBuff(buff)
  buff.update = override(buff.update, roguecrisisbuff51_update)
  buff.onDamaged = override(buff.onDamaged, roguecrisisbuff51_onDamaged)
  buff.unremoveable = true
  return buff
end

return initBuff
