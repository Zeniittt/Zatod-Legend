local moduleList = {
  "ui_new/modules/crevicedefend/controller/crevicedefendNetWork",
  "ui_new/modules/crevicedefend/controller/crevicedefendManager",
  "ui_new/modules/crevicedefend/controller/crevicedefendBattleManager",
  "ui_new/modules/crevicedefend/view/crevicedefendMainScene",
  "ui_new/modules/crevicedefend/view/crevicedefendBattlePrepareScene",
  "ui_new/modules/crevicedefend/view/crevicedefendStatisticWin",
  "ui_new/modules/crevicedefend/view/crevicedefendReCommendWin",
  "ui_new/modules/crevicedefend/view/crevicedefendRankWin",
  "ui_new/modules/crevicedefend/view/crevicedefendBattleWin",
  "ui_new/modules/crevicedefend/view/CreviceDefendBattleResultNewWin",
  "ui_new/modules/crevicedefend/view/creviceSkillDictInfo",
  "ui_new/modules/crevicedefend/view/crevicedefendRewardWin",
  "ui_new/modules/crevicedefend/view/crevicedefendRecordWin",
  "ui_new/modules/crevicedefend/view/crevicedefendRecordDetailWin",
  "ui_new/modules/crevicedefend/view/crevicedefendRecordWin"
}

local function formatDamage(num)
  if ed.getCurArea() == "en" then
    if num < 100000000 then
      return num
    end
    return string.format("%d" .. T("\228\184\135"), num / 1000)
  else
    if num < 100000000 then
      return num
    end
    return string.format("%d", num / 10000) .. T("\228\184\135")
  end
end

ed.formatDamage = formatDamage
for i, v in ipairs(moduleList) do
  package.loaded[v] = nil
end
for i, v in ipairs(moduleList) do
  require(v)
end
