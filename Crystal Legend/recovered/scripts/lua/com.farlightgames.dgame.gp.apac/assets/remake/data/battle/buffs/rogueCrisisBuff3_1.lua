local function roguecrisisbuff31_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == 1 then
    local owner = buff.owner
    local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
    if crisisDiff then
      local stage_type = ed.engine.stage_info["Stage Type"]
      local RogueChapter = ed.engine.stage_info["RogueChapter ID"]
      if RogueChapter and RogueChapter == 3 then
        if stage_type and stage_type == "NormalBattle" then
          buff:setAttribute("HP", 0.1 * crisisDiff * owner.attribs.HP / owner.config.hp_mod)
        elseif stage_type and stage_type ~= "NormalBattle" then
          buff:setAttribute("AD", 0.1 * crisisDiff * owner.attribs.AD)
          buff:setAttribute("AP", 0.1 * crisisDiff * owner.attribs.AP)
          buff:setAttribute("HP", 0.2 * crisisDiff * owner.attribs.HP / owner.config.hp_mod)
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

local function initBuff(buff)
  buff.update = override(buff.update, roguecrisisbuff31_update)
  buff.unremoveable = true
  return buff
end

return initBuff
