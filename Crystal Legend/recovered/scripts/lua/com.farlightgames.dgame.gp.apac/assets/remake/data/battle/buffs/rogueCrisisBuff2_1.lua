local function roguechapterbuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == 1 then
    local owner = buff.owner
    local shieldvalue = 0
    local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
    if crisisDiff then
      for i, tbuff in ipairs(owner.buff_list) do
        if tbuff.info.ID == 62000004 then
          tbuff.shield = tbuff.shield * (1 + 0.05 * crisisDiff)
        end
      end
      local stage_type = ed.engine.stage_info["Stage Type"]
      local RogueChapter = ed.engine.stage_info["RogueChapter ID"]
      if RogueChapter and RogueChapter == 2 then
        if stage_type and stage_type == "NormalBattle" then
          buff:setAttribute("HP", 0.1 * crisisDiff * owner.attribs.HP / owner.config.hp_mod)
        elseif stage_type and stage_type ~= "NormalBattle" then
          buff:setAttribute("HAST", 5 * crisisDiff)
          buff:setAttribute("MSPD", 5 * crisisDiff)
          buff:setAttribute("ARM", 0.1 * crisisDiff * owner.attribs.ARM)
          buff:setAttribute("MR", 0.1 * crisisDiff * owner.attribs.MR)
          buff:setAttribute("HP", 0.2 * crisisDiff * owner.attribs.HP / owner.config.hp_mod)
        end
      end
      owner:rebuild()
      owner:setHP(owner.attribs.HP)
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, roguechapterbuff2_update)
  buff.unremoveable = true
  return buff
end

return initBuff
