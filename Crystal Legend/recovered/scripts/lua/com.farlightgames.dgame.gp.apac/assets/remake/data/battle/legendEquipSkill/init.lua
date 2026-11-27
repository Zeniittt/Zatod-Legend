local files = {
  "legendEquipBase",
  "legendEquipSkillBase",
  "EquipSkill_1"
}
for _, file in ipairs(files) do
  require("battle/legendEquipSkill/" .. file)
end
