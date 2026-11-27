local files = {
  "rogueSkill",
  "rogueSkillIcon",
  "rogueSkillMgr",
  "rogueBlessBase",
  "rogueCharmBase",
  "rogueTechBase",
  "rogueBless/rogueBless1101",
  "rogueRevelation/rogueRevelation1"
}
for _, file in ipairs(files) do
  require("battle.rogueDestiny." .. file)
end
