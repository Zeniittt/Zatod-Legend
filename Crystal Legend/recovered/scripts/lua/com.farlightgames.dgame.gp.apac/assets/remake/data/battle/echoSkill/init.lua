local files = {
  "echoSkillEffect",
  "echoSkillIcon",
  "echoSkillMgr"
}
for _, file in ipairs(files) do
  require("battle.echoSkill." .. file)
end
