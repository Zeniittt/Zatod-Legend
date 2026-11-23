module("ed.battlehero", package.seeall)
local ed = ed
MagicStoneNPC = {}
MagicStoneNPC.name = "MagicStoneNPC"
MagicStoneNPC.test = false
MagicStoneNPC.testStage = 90010
MagicStoneNPC.testWave = 1
MagicStoneNPC.testField = 22
MagicStoneNPC.fieldBasicBuffId = 1071
MagicStoneNPC.requireLuaSuffixList = {
  "chaosField",
  "extraKael",
  "randomAerolite",
  "lovers",
  "loversPVE",
  "blackHole",
  "crazyUltimate2",
  "arenaTestUse",
  "godHand",
  "extraDuckboy",
  "ArcanaTrial"
}
MagicStoneNPC.minX = ed.engine.stage_rect.minX
MagicStoneNPC.minY = ed.engine.stage_rect.minY
MagicStoneNPC.maxX = ed.engine.stage_rect.maxX
MagicStoneNPC.maxY = ed.engine.stage_rect.maxY

function MagicStoneNPC.setStageSkillId(field, stageSkillId)
  field.setSpecialStageSkillId = stageSkillId
end

function MagicStoneNPC.reset(basefunc, field)
  basefunc(field)
  local activeSkillIdList, activeSkillNameList = MagicStoneNPC.getSkillList(ed, field)
  for _, skill in ipairs(field.skill_list) do
    skill:pause()
  end
  if activeSkillNameList then
    for _, skillName in ipairs(activeSkillNameList) do
      local skill = field.skills[skillName]
      if skill then
        skill:resume()
      end
    end
  end
  field.position = {
    (MagicStoneNPC.minX + MagicStoneNPC.maxX) / 2,
    0
  }
  for _, suffix in ipairs(MagicStoneNPC.requireLuaSuffixList) do
    local iniSkill = MagicStoneNPC.checkSkill(field, suffix)
    if iniSkill then
      local init_func = require("battle/heroes/fieldSkill/" .. suffix)
      iniSkill = init_func(iniSkill)
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, MagicStoneNPC.fieldBasicBuffId)
  local buff = field:addBuff(binfo, field)
end

function MagicStoneNPC.update(basefunc, field, dt)
  basefunc(field, dt)
  field.timeCount = field.timeCount + dt
end

function MagicStoneNPC.init_hero(hero)
  hero.setStageSkillId = MagicStoneNPC.setStageSkillId
  hero.reset = override(hero.reset, MagicStoneNPC.reset)
  hero.update = override(hero.update, MagicStoneNPC.update)
  return hero
end

return MagicStoneNPC.init_hero
