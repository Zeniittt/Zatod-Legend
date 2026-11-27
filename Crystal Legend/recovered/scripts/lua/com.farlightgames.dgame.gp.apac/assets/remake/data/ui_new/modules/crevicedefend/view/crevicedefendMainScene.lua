local base = ed.ui.basescene
local CreviceDefendMainScene = newclass(base.mt)
ed.ui.CreviceDefendMainScene = CreviceDefendMainScene
ed.UITool.registViewOpenFunc("creviceDefendMainScene", function()
  local scene = ed.ui.CreviceDefendMainScene.create()
  ed.pushScene(scene)
end)
local actorPos = {
  [1] = 40,
  [2] = 120,
  [3] = 200,
  [4] = 280,
  [5] = 370
}
CreviceDefendMainScene.REWARD_STATE_UNCOMPLETED = "reward_state_uncompleted"
CreviceDefendMainScene.REWARD_STATE_AVAILABLE = "reward_state_available"
CreviceDefendMainScene.REWARD_STATE_COMPLETED = "reward_state_completed"
local tipsContent = T("\229\164\167\229\156\176\229\156\168\229\147\128\229\154\142\239\188\129\231\129\188\231\131\173\231\154\132\232\163\130\233\154\153\229\166\130\229\144\140\231\139\176\231\139\158\231\154\132\228\188\164\229\143\163\239\188\140\230\146\149\229\188\128\228\186\134\232\191\156\229\190\129\229\164\167\233\153\134\227\128\130<br/>") .. T("\230\157\165\232\135\170\229\188\130\231\149\140\231\154\132\230\129\144\230\128\150\229\173\152\229\156\168\239\188\140\230\144\186\229\184\166\231\157\128\230\175\129\231\129\173\231\154\132\230\156\172\230\186\144\228\185\139\229\138\155\230\132\143\229\155\190\229\176\134\230\136\145\228\187\172\231\154\132\228\184\150\231\149\140\229\140\150\228\184\186\228\187\150\228\187\172\229\173\149\232\130\178\233\130\170\230\129\182\231\154\132\230\184\169\229\186\138\227\128\130<br/>") .. T("\230\180\187\229\138\168\232\167\132\229\136\153\239\188\154<br/>") .. T("\239\188\1361\239\188\137\230\140\145\230\136\152<br/>") .. T("i.\232\163\130\233\154\153\230\136\141\229\141\171\228\184\186\232\181\155\229\140\186\229\136\182\228\184\170\228\186\186\230\140\145\230\136\152\231\142\169\230\179\149\239\188\140\233\152\159\233\149\191\230\187\161\232\182\17970\231\186\167\228\184\14830\228\184\170\232\139\177\233\155\132\229\136\176\232\190\190\231\180\171+1\233\152\182\229\141\179\229\143\175\230\140\145\230\136\152\227\128\130<br/>") .. T("ii.\230\180\187\229\138\168\229\188\128\229\167\139\230\151\182\239\188\140\231\179\187\231\187\159\228\188\154\228\190\157\230\141\174\230\180\187\232\183\131\228\186\186\230\149\176\239\188\140\229\176\134\231\155\184\233\130\187\231\154\132\229\135\160\228\184\170\230\156\141\229\138\161\229\153\168\229\136\146\229\136\134\232\191\155\228\184\128\228\184\170\232\181\155\229\140\186\227\128\130<br/>") .. T("iii.\230\180\187\229\138\168\230\136\152\230\150\151\228\184\186\228\186\148\233\152\159\229\133\168\232\135\170\229\138\168\230\136\152\230\150\151\239\188\140\228\184\148\228\186\148\233\152\159\231\154\134\233\156\128\228\184\138\230\187\161\232\139\177\233\155\132\239\188\140\232\191\155\229\133\165\230\136\152\230\150\151\229\144\142\228\190\191\228\188\154\230\137\163\233\153\164\230\172\161\230\149\176\228\184\148\230\151\160\230\179\149\233\128\128\229\135\186\230\136\152\230\150\151\227\128\130<br/>") .. T("iv.\232\175\165\231\142\169\230\179\149\230\151\160\230\179\149\228\189\191\231\148\168\229\133\172\228\188\154\228\189\163\229\133\181\227\128\130<br/>") .. T("v.\230\175\143\230\151\165\229\176\134\229\162\158\229\138\1605\230\172\161\229\133\141\232\180\185\230\140\145\230\136\152\230\172\161\230\149\176\239\188\140\230\156\128\229\164\154\229\143\175\229\173\15210\230\172\161\239\188\140\229\144\142\231\187\173\229\143\175\228\189\191\231\148\168\233\146\187\231\159\179\232\180\173\228\185\176\230\140\145\230\136\152\230\172\161\230\149\176\227\128\130<br/>") .. T("\239\188\1362\239\188\137\229\165\150\229\138\177<br/>") .. T("i.\230\140\145\230\136\152\230\172\161\230\149\176\229\165\150\229\138\177\239\188\154\233\152\159\233\149\191\233\128\154\232\191\135\231\180\175\232\174\161\230\140\145\230\136\152\230\172\161\230\149\176\239\188\140\229\143\175\233\162\134\229\143\150\230\140\145\230\136\152\229\165\150\229\138\177\227\128\130<br/>") .. T("ii.\231\187\147\231\174\151\229\165\150\229\138\177\239\188\154\230\180\187\229\138\168\229\128\146\232\174\161\230\151\182\231\187\147\230\157\159\229\144\142\239\188\140\233\128\154\232\191\135\233\152\159\233\149\191\229\141\149\230\172\161\230\140\145\230\136\152\231\154\132\230\156\128\233\171\152\230\128\187\228\188\164\229\174\179\232\191\155\232\161\140\230\142\146\229\144\141\239\188\140\230\140\137\231\133\167\230\142\146\229\144\141\230\131\133\229\134\181\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\232\191\155\232\161\140\229\143\145\229\165\150<br/>")

function CreviceDefendMainScene.create(data)
  local self = base.create("CreviceDefendMainScene")
  setmetatable(self, CreviceDefendMainScene.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:addArrowAction()
  return self
end

function CreviceDefendMainScene:initData()
  self.enemy_index = 1
  self.enemy_index_old = 1
  self.enemy_CountMax = 5
  self.asyncLoadFca = {}
  self.skillIcons = {}
  self:initConfig()
  self:initTaskReward()
end

function CreviceDefendMainScene:registerBtn(btn, func, params)
  local config = {
    button = btn,
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function CreviceDefendMainScene:registerTouchEvents()
  self:registerBtn(self.baseui.btn_rule, function()
    self:onRuleEvent()
  end, {pressScale = 0.95})
  self:registerBtn(self.baseui.btn_left, function()
    self:onClickArrow(false)
  end, {normalScale = -0.9, pressScale = -0.81})
  self:registerBtn(self.baseui.btn_right, function()
    self:onClickArrow(true)
  end, {normalScale = 0.9, pressScale = 0.81})
  for index = 1, 5 do
    self:registerBtn(self.baseui["stage" .. index], function()
      self:onClickState(index)
    end, {pressScale = 0.95})
  end
  self:registerBtn(self.baseui.btn_attack, function()
    self:onClickChallenge()
  end, {pressScale = 0.95})
  self:registerBtn(self.baseui.btn_ranklist, function()
    self:onClickRankList()
  end, {normalScale = 0.9, pressScale = 0.81})
  self:registerBtn(self.baseui.btn_record, function()
    self:onClickRecord()
  end, {normalScale = 0.9, pressScale = 0.81})
  self:registerBtn(self.baseui.btn_reward, function()
    self:onClickReward()
  end, {normalScale = 0.9, pressScale = 0.81})
  self:registerBtn(self.baseui.btn_getreward, function()
    self:onClickTaskReward()
  end, {normalScale = 1, pressScale = 1})
  self:registerBtn(self.baseui.btn_reward_line, function()
    self:onClickTaskRewardLine()
  end, {normalScale = 0.9, pressScale = 0.81})
  self:registerBtn(self.baseui.btn_reward_line_2, function()
    self:onClickTaskRewardLine()
  end, {normalScale = 0.9, pressScale = 0.81})
  self:registerBtn(self.baseui.chance_add_btn, function()
    self:BuyChance()
  end, {normalScale = 0.9, pressScale = 0.81})
  self:btRegisterButtonClick({
    button = self.baseui.btn_tips,
    key = "btn_tips",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      ed.ui.commonRulePop.create({
        title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
        txt = T(tipsContent or "")
      }):popWindow()
    end
  })
end

function CreviceDefendMainScene:addArrowAction()
  local action1 = CCFadeTo:create(1, 100)
  local action2 = CCFadeTo:create(1, 255)
  local breathAction = CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2)))
  self.baseui.btn_left:runAction(breathAction)
  self.baseui.btn_right:runAction(tolua.cast(breathAction:copy():autorelease(), "CCAction"))
  local y = self.baseui.image_boss_tag:getPositionY()
  self.baseui.image_boss_tag:setPositionY(y + 20)
  local moveDown = CCMoveBy:create(0.5, ccp(0, -20))
  local moveUp = CCMoveBy:create(0.5, ccp(0, 20))
  local sequence = CCSequence:createWithTwoActions(moveDown, moveUp)
  local action = CCRepeatForever:create(sequence)
  self.baseui.image_boss_tag:runAction(action)
end

function CreviceDefendMainScene:registerEvents()
  self:listenEvent("RefreshCreviceDefendTaskView", function()
    self:refreshCreviceDefendTaskView()
  end)
  self:listenEvent("UpdateCreviceDefendChallengeCount", function()
    self:refreshRightView()
  end)
  self:listenEvent("EventCreviceDefendStageEnd", function()
    ed.CreviceDefendNetWork:sendOpenPanel()
  end)
  self:listenEvent("EventCreviceDefendUpdateRedPoint", function()
    self:updateRedPoint()
  end)
  self:listenEvent("EventCreviceDefendUpdateView", function()
    self:refreshCreviceDefendTaskView()
    self:refreshLeftView()
    self:refreshRightView()
    self:refreshTaskView()
    self:updateRedPoint()
  end)
end

function CreviceDefendMainScene:handleChallengeOppo(data)
  ed.ui.CreviceDefendBattleResultWin.create({
    selfCamp = data.attackTeams
  })
  ed.CreviceDefendNetWork:sendStartChallenge(data.attackTeams)
  ed.loadEnd()
  ed.openMemeryGC = false
end

function CreviceDefendMainScene:initUI()
  self:initView()
  self:initLabel()
  self:adaptUI()
  self:setBackground("UI/alpha/1080P/crevicedefend/main_bg.jpg")
  self.isSeasonOpen = self:refreshSeasonTime()
  self:initLoadTask()
  self:refreshLeftView()
  self:refreshRightView()
  self:refreshTaskView()
end

function CreviceDefendMainScene:initLabel()
  ed.setLabelColor(self.baseui.label_arena_rank, ccc3(255, 250, 109))
  ed.setLabelStroke(self.baseui.label_arena_rank, ed.toccc3(11357460), 1)
  ed.setLabelColor(self.baseui.label_activities_des_content, ccc3(255, 252, 231))
  ed.setLabelStroke(self.baseui.label_activities_des_content, ed.toccc3(990737), 1)
  local x = self.baseui.label_activities_des_content:getPositionX()
  self.baseui.label_activities_des_content:setPositionX(x - 5)
  self.baseui.label_activities_des:setFontName(ed.fontBold)
  ed.setLabelColor(self.baseui.label_activities_des, ccc3(255, 162, 157))
  ed.setLabelStroke(self.baseui.label_activities_des, ed.toccc3(6553603), 1)
  self.baseui.label_boss_des:setFontName(ed.fontBold)
  ed.setLabelColor(self.baseui.label_boss_des, ccc3(255, 162, 157))
  ed.setLabelStroke(self.baseui.label_boss_des, ed.toccc3(6553603), 1)
  local attackLabel = ed.ui.gradientLabel.create({
    text = T("\231\171\139\229\141\179\230\140\145\230\136\152"),
    fontSize = 22,
    startColor = ed.toccc3(16764009),
    endColor = ed.toccc3(16773322),
    strokeSize = 1,
    strokeColor = ed.toccc3(7014945)
  })
  ed.UITool.replaceUI(self.baseui, "btn_attack", "Label_attack", attackLabel.node)
  ed.setLabelColor(self.baseui.Label_attack, ccc3(242, 240, 214))
  local title1 = ed.ui.gradientLabel.create({
    text = T("\229\189\147\229\137\141BOSS\228\188\164\229\174\179"),
    fontSize = 17,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(8003366)
  })
  ed.UITool.replaceUI(self.baseui, "image_total_damage", "label_total_damage_des", title1.node)
  local title2 = ed.ui.gradientLabel.create({
    text = T("\230\128\187\228\188\164\229\174\179"),
    fontSize = 17,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(8003366)
  })
  ed.UITool.replaceUI(self.baseui, "image_current_damage", "label_current_damage_des", title2.node)
end

function CreviceDefendMainScene:adaptUI()
  ed.layout.layoutWithMagin(self.baseui.bg_title, {left = 60, top = 18})
  local localDesignScale = 2.1666666666666665
  local localFixedWidth = ed.display.designSize.height * localDesignScale - ed.display.designSize.width
  local adaptRatio = math.min(ed.display.halfFixedWidth * 2 / localFixedWidth, 1)
  ed.layout.layoutWithMagin(self.baseui.panel_left, {
    left = -1 + ed.display.halfFixedWidth
  })
  ed.layout.layoutWithMagin(self.baseui.panel_right, {
    right = -1 + ed.display.halfFixedWidth
  })
  ed.layout.layoutWithMagin(self.baseui.panel_button, {left = -1})
  ed.layout.layoutWithMagin(self.baseui.panel_reward, {right = -1})
end

function CreviceDefendMainScene:initView()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendMainScene, {
    container = self.mainLayer
  })
  self.baseContainer = container
  self.baseui = ui
  self:setBackButton(function()
    ed.CreviceDefendManager:resetOpenPanel()
    ed.playEffect(ed.sound.common.back)
  end)
  local titleBg, titleTxt = ed.UITool.createSceneTitle(T("\232\163\130\233\154\153\230\136\141\229\141\171"), self.baseui.bg_title, {
    position = ccp(20, 18)
  })
  local posX = titleTxt:getPositionX() + titleBg:getContentSize().width * 0.5 + 20
  self.baseui.titleBg = titleBg
  self.baseui.titleTxt = titleTxt
  local ruleWidth = self.baseui.btn_tips:getContentSize().width
  self.baseui.btn_tips:setPositionX(posX + ruleWidth * 0.5)
  posX = posX + ruleWidth + 10
  local zoomLabel = ed.ui.gradientLabel.create({
    text = T("\231\172\172%s\232\181\155\229\140\186", ed.CreviceDefendManager:getZoneId()),
    fontSize = 15,
    fontName = ed.font,
    startColor = ed.toccc3(16773995),
    endColor = ed.toccc3(16776911),
    strokeSize = 1,
    strokeColor = ed.toccc3(8803621)
  }).node
  self.baseui.bg_title:addChild(zoomLabel)
  zoomLabel:setAnchorPoint(ccp(0, 0.5))
  zoomLabel:setPosition(ccp(posX, 18))
  posX = posX + zoomLabel:getContentSize().width + 25
  self.baseui.bg_title:setContentSize(CCSizeMake(posX, 35.5))
  self.baseui.zoomLabel = zoomLabel
  local battleFca = ed.createFcaNode("eff_UI_CreviceDefend_particle")
  self:addFcaOnce(battleFca)
  self.baseui.layer_Effect:addChild(battleFca, 1)
  battleFca:setPosition(ccp(ed.display.designSize.width / 2, ed.display.designSize.height / 2))
  battleFca:setAction("Start")
end

function CreviceDefendMainScene:initConfig()
  local seasonId = ed.CreviceDefendManager:getSeasonId()
  local seasonConfig = ed.getDataTable("CreviceDefendSeason")[seasonId]
  local needStageMap = seasonConfig["Stage ID"]
  local checkMap = {}
  for i, v in ipairs(needStageMap) do
    checkMap[v] = i
  end
  self.indexMap = {}
  self.stageMap = {}
  self.enemyTeamData = {}
  self.bossSizeMap = {}
  self.bossDesMap = {}
  self.stageIdMap = {}
  local config = ed.getDataTable("CreviceDefendBattle")
  for k, v in pairs(config) do
    if nil ~= checkMap[k] then
      self.stageMap[k] = {}
      table.insert(self.indexMap, checkMap[k], k)
      local bossId = 0
      local bossIndex = v[1]["Boss Position"]
      local bossSize = v[1]["BOSS SIZE"]
      for i = 1, 5 do
        if i ~= bossIndex then
          local monsterId = v[1]["Monster " .. i .. " ID"]
          table.insert(self.stageMap[k], monsterId)
        else
          bossId = v[1]["Monster " .. i .. " ID"]
        end
      end
      table.insert(self.stageMap[k], 3, bossId)
    end
  end
  for k, v in ipairs(self.indexMap) do
    table.insert(self.enemyTeamData, self.stageMap[v])
  end
  local bossConfig = ed.getDataTable("CreviceDefendBoss")
  for k, v in ipairs(self.indexMap) do
    local stageId = v
    local bossItemConfig = bossConfig[stageId]
    local bossID = bossItemConfig["Boss ID"]
    local bossSize = bossItemConfig.UISize
    local bossDes = bossItemConfig["Boss Description"]
    local bossName = bossItemConfig["Boss Name"]
    self.bossSizeMap[bossID[1]] = bossSize
    table.insert(self.stageIdMap, stageId)
    table.insert(self.bossDesMap, {bossName = bossName, bossDes = bossDes})
  end
end

function CreviceDefendMainScene:refreshLeftView()
  self:refreshBossTeam()
  local mgr = ed.CreviceDefendManager
  local attackLabel = ed.ui.gradientLabel.create({
    text = ed.formatDamage(mgr:getTotalDamage()),
    fontSize = 29,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(8003366)
  })
  ed.UITool.replaceUI(self.baseui, "image_current_damage", "label_total_damage", attackLabel.node)
  local rank = mgr:getSeasonRank()
  self.baseui.image_current_rank:setVisible(0 < rank)
  if 0 < rank then
    self.baseui.label_arena_rank:setString(T("\232\181\155\229\140\186\230\142\146\229\144\141:"))
    self.baseui.layer_arena_Rank:removeAllChildrenWithCleanup(true)
    local rankNode = ed.getNumberNode({text = rank, folder = "big_pvp"})
    self.baseui.layer_arena_Rank:addChild(rankNode.node)
    rankNode.node:setPositionX(-12)
    rankNode.node:setAnchorPoint(ccp(0, 0.5))
    rankNode.node:setScale(0.8)
  end
  local damage = mgr:getCurrentDamage(self.enemy_index)
  local attackLabel = ed.ui.gradientLabel.create({
    text = ed.formatDamage(damage),
    fontSize = 29,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16775386),
    endColor = ed.toccc3(16764526),
    strokeSize = 1,
    strokeColor = ed.toccc3(8003366)
  })
  ed.UITool.replaceUI(self.baseui, "image_total_damage", "label_current_damage", attackLabel.node)
  local targetRank = mgr:getTargetRank()
  local targetDamage = mgr:getTargetDamage()
  if 1 < rank then
    self.baseui.label_across_rank:setVisible(true)
    local titleAutoText2 = ed.ui.autoText.new()
    local param = {
      context = T("<lable color=ccc3(231,200,168) fontSize=f18 >\230\128\187\228\188\164\229\174\179\232\191\152\233\156\128</lable><lable color=ccc3(253,48,47) fontSize=f18> %s </lable><lable color=ccc3(231,200,168) fontSize=f15>\228\188\164\229\174\179\232\182\133\232\182\138\231\172\172</lable><lable color=ccc3(91,250,28) fontSize=f18> %s </lable><lable color=ccc3(231,200,168) fontSize=f15>\229\144\141</lable>", targetDamage - mgr:getTotalDamage() + 1, targetRank),
      maxWidth = 400
    }
    titleAutoText2:initParam(param)
    local width, height = titleAutoText2:getCurContentSize()
    ed.UITool.replaceUI(self.baseui, "image_boss_bg", "label_across_rank", titleAutoText2.node)
    titleAutoText2.node:setPositionX(width * 0.5 + 40)
    self.baseui.image_dps:setContentSize(CCSizeMake(width, height))
    local pos = ccp(titleAutoText2.node:getPosition())
    self.baseui.image_dps:setPosition(pos.x + width * 0.5, pos.y)
  else
    self.baseui.label_across_rank:setVisible(false)
    self.baseui.image_dps:setVisible(false)
  end
  self.baseui.btn_left:setVisible(self.enemy_index ~= 1)
  self.baseui.btn_right:setVisible(self.enemy_index ~= self.enemy_CountMax)
end

function CreviceDefendMainScene:hideBossTeamFca()
  if self.asyncLoadFca[self.enemy_index_old] then
    for k, v in ipairs(self.asyncLoadFca[self.enemy_index_old]) do
      v:setVisible(false)
    end
  end
end

function CreviceDefendMainScene:refreshBossTeam()
  for i = 1, 5 do
    self.baseui["stage" .. i .. "_light"]:setVisible(i == self.enemy_index)
  end
  local task = self:getTargetIndex(self.enemy_index)
  if nil ~= task and task.state == 2 then
    for k, v in ipairs(self.asyncLoadFca[self.enemy_index]) do
      v:setVisible(true)
    end
  else
    self:addAsyncTask(self.enemy_index)
  end
end

function CreviceDefendMainScene:onAddBossEffect(puppet, priority)
  local bossSpine = ed.createSpine("effect/eff_UI_CreviceDefend_bossfx/eff_UI_CreviceDefend_bossfx", 0.5)
  bossSpine:setAnimation(0, "Idle", true)
  puppet:addChild(bossSpine, priority)
end

function CreviceDefendMainScene:onAsyncLoadUnit(unit_id, index)
  local puppet, _ = ed.readhero.getActor(unit_id, "Idle", true, false)
  local priorityDefault = 99
  if index == 3 then
    puppet:setScale(self.bossSizeMap[unit_id])
    priorityDefault = priorityDefault + 1
    self:onAddBossEffect(puppet, priorityDefault)
  else
    puppet:setScale(0.6)
  end
  self.baseui.layer_boss:addChild(puppet, priorityDefault)
  puppet:setPosition(actorPos[index], 0)
  self:addFca(puppet)
  table.insert(self.asyncLoadFca[self.enemy_index], puppet)
end

function CreviceDefendMainScene:refreshSeasonTime()
  local seasonId = ed.CreviceDefendManager:getSeasonId()
  local seasonConfig = ed.getDataTable("CreviceDefendSeason")[seasonId]
  local endTimeStamp = ed.dateStringToTime(seasonConfig["End Battle Time"])
  self.closeTimeStamp = ed.dateStringToTime(seasonConfig["End Battle Time"])
  self.TimeStamp = ed.dateStringToTime(seasonConfig["End Time"])
  local currentTime = ed.getServerTime()
  if endTimeStamp < currentTime then
    return false
  end
  return true
end

function CreviceDefendMainScene:refreshRightView()
  self:updateRedPoint()
  if self.isSeasonOpen then
    local time = ed.CreviceDefendManager:getEndTime()
    local passSecond = self.closeTimeStamp - ed.getServerTime()
    local titleAutoText = ed.ui.autoText.new()
    local param = {
      context = T("<lable color=ccc3(255,241,209) strokeColor=creviceMainStrokeColor strokeSize=1>\230\180\187\229\138\168\229\128\146\232\174\161\230\151\182: </lable><lable color=ccc3(112,255,84) strokeColor=creviceMainTitleStrokeColor strokeSize=1>%s</lable>", ed.time2dhmsV2(passSecond)),
      fontSize = 17,
      maxWidth = 400
    }
    titleAutoText:initParam(param)
    ed.UITool.replaceUI(self.baseui, "image_boss_des", "label_extra_time", titleAutoText.node)
    local remindCount = ed.CreviceDefendManager:getChallengeCount()
    self.baseui.chance_add_btn:setVisible(remindCount == 0)
    local countAutoText = ed.ui.autoText.new()
    local countParam
    countParam = {
      context = T("<lable color=ccc3(237,166,69) fontSize=f15>\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176 (</lable><lable color=ccc3(77,237,69) fontSize=f17>%s</lable><lable color=ccc3(237,166,69) fontSize=f15>/</lable><lable color=ccc3(237,166,69) fontSize=f17>10</lable><lable color=ccc3(237,166,69) fontSize=f15>)</lable>", remindCount)
    }
    countAutoText:initParam(countParam)
    ed.UITool.replaceUI(self.baseui, "layer_season_open", "label_extra_num", countAutoText.node)
    local width, height = countAutoText:getCurContentSize()
    countAutoText.node:setPositionX(-31)
    local btn_attack_node = ed.ui.gradientLabel.create({
      text = T("\231\171\139\229\136\187\230\140\145\230\136\152"),
      fontSize = 22,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16764009),
      endColor = ed.toccc3(16773322),
      strokeSize = 1,
      strokeColor = ed.toccc3(7014945)
    })
    ed.UITool.replaceUI(self.baseui, "btn_attack", "Label_attack", btn_attack_node.node)
  else
    local gradient_node = ed.ui.gradientLabel.create({
      text = T("\230\180\187\229\138\168\229\183\178\231\187\143\231\187\147\230\157\159"),
      fontSize = 24,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16777215),
      endColor = ed.toccc3(15838123),
      strokeSize = 1,
      strokeColor = ed.toccc3(9568260)
    })
    ed.UITool.replaceUI(self.baseui, "image_boss_des", "label_extra_time", gradient_node.node)
    gradient_node.node:setPositionX(240)
    ed.setLabelColor(self.baseui.label_season, ccc3(210, 196, 196))
    self.baseui.label_season:setString(T("\229\176\134\229\156\168%s\229\133\179\233\151\173", ed.getMDHTime(self.TimeStamp)))
  end
  local totalCount = ed.CreviceDefendManager:getTotalCount()
  local maxCount = 0
  for i, v in ipairs(self.rewardArr) do
    if totalCount < v.requireCount then
      maxCount = v.requireCount
      break
    end
  end
  if maxCount == 0 then
    maxCount = self.rewardArr[#self.rewardArr].requireCount
  end
  self.baseui.label_getreward_num:setString(T("%s/%s\230\172\161", totalCount, maxCount))
  self.baseui.layer_season_open:setVisible(self.isSeasonOpen)
  self.baseui.layer_season_close:setVisible(not self.isSeasonOpen)
  self:refreshBossRightView()
end

function CreviceDefendMainScene:refreshBossRightView()
  local config = self.bossDesMap[self.enemy_index]
  self.baseui.label_activities_des:setString(config.bossName)
  self.baseui.label_activities_des_content:setString(config.bossDes)
  self:adaptBossName()
  self:RefreshBossSkill()
end

function CreviceDefendMainScene:adaptBossName()
  local con = self.baseui.label_activities_des:getContentSize()
  local X = self.baseui.root_activities_des:getPositionX()
  local minWidth = con.width + 50
  self.baseui.root_activities_des:setContentSize(CCSizeMake(minWidth, 20))
end

function CreviceDefendMainScene:RefreshBossSkill()
  local bossId = self.enemyTeamData[self.enemy_index][3]
  local posMap = {
    48,
    127,
    208.5,
    288.5
  }
  for index = 1, 4 do
    local icon, bg = ed.readhero.createSkillIcon(bossId, index)
    icon:setScale(0.8)
    ed.UITool.replaceUI(self.baseui, "root_boss_activities_des", "skill" .. index, icon)
    icon:setPosition(ccp(posMap[index], -40))
    self:btRegisterButtonClick({
      button = icon,
      key = "btn_check" .. index,
      clickHandler = function(event, x, y)
        local parent = bg:getParent()
        local pos = parent:convertToWorldSpace(ccp(icon:getPosition()))
        self:onClickSkillIcon(bossId, index, pos.x, pos.y)
      end,
      pressScale = 0.7,
      normalScale = 0.8,
      force = true
    })
  end
end

function CreviceDefendMainScene:CanBuyChance()
  local count = ed.CreviceDefendManager:getChallengeCount()
  if 0 < count then
    return false
  end
  return true
end

function CreviceDefendMainScene:BuyChance()
  if self:CanBuyChance() then
    local priceTable = ed.getDataTable("CreviceDefendBuyChallengeCount")
    local currentCount = ed.CreviceDefendManager:getBuyCount()
    local count = 0
    for i, v in pairs(priceTable) do
      count = count + 1
    end
    if count >= currentCount + 1 then
      local cost = priceTable[currentCount + 1].Price or 200
      local info = {
        autoText = string.format(T("\232\138\177\232\180\185<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=headlineOrange>%d</lable>\233\146\187\231\159\179\232\180\173\228\185\1765\230\172\161\230\136\152\230\150\151\230\172\161\230\149\176\239\188\159     \230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"), cost),
        leftText = T("\229\143\150\230\182\136"),
        rightHandler = function()
          if ed.player._rmb < cost then
            ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\232\175\183\229\133\133\229\128\188"))
          else
            ed.CreviceDefendNetWork:sendBuyChallengeTimes()
          end
        end,
        rightText = T("\231\161\174\229\174\154"),
        mode = "simple",
        fontSize = 17
      }
      ed.showConfirmDialog(info)
    else
      ed.showToast(T("\228\187\138\230\151\165\232\180\173\228\185\176\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140!"))
    end
  else
    local count = ed.CreviceDefendManager:getChallengeCount()
    if 0 < count then
      ed.showToast(string.format(T("\229\137\169\228\189\153\229\133\141\232\180\185\230\172\161\230\149\176%s\230\172\161"), count))
    else
      ed.showToast(T("\228\187\138\230\151\165\229\183\178\232\190\190\230\140\145\230\136\152\230\172\161\230\149\176\228\184\138\233\153\144"))
    end
  end
end

function CreviceDefendMainScene:onClickSkillIcon(bossId, Slot, x, y)
  local skillGroupConfig = ed.getDataTable("SkillGroup")[bossId][Slot]
  local skillGroupId = skillGroupConfig["Skill Group ID"]
  local skillName = skillGroupConfig["Display Name"]
  local skillConfig = ed.getDataTable("Skill")[skillGroupId][0]
  local skillDesc = skillConfig.Description
  ed.UITool.openView("OpenCreviceSkillDictInfo", {
    index = Slot,
    x = x,
    y = y,
    name = skillName,
    desc = skillDesc
  })
end

function CreviceDefendMainScene:onClickArrow(byAdd)
  self.enemy_index_old = self.enemy_index
  if byAdd then
    if self.enemy_index < self.enemy_CountMax then
      self.enemy_index = self.enemy_index + 1
    else
      return
    end
  elseif self.enemy_index > 1 then
    self.enemy_index = self.enemy_index - 1
  else
    self.baseui.btn_left:setVisible(false)
    return
  end
  self.baseui.btn_left:setVisible(not (self.enemy_index <= 1))
  self.baseui.btn_right:setVisible(not (self.enemy_index >= self.enemy_CountMax))
  self:hideBossTeamFca()
  self:refreshBossTeam()
  self:refreshBossRightView()
  self:refreshLeftView()
end

function CreviceDefendMainScene:onClickState(index)
  self.enemy_index_old = self.enemy_index
  self.enemy_index = index
  self.baseui.btn_left:setVisible(not (self.enemy_index <= 1))
  self.baseui.btn_right:setVisible(not (self.enemy_index >= self.enemy_CountMax))
  self:hideBossTeamFca()
  self:refreshBossTeam()
  self:refreshBossRightView()
  self:refreshLeftView()
end

function CreviceDefendMainScene:onClickChallenge()
  local remindCount = ed.CreviceDefendManager:getChallengeCount()
  if 0 < remindCount then
    ed.asyncload.unregistLoadingListener()
    local scene = ed.ui.CreviceDefendBattlePrepareScene.create({
      mode = "attack",
      oppoTeams = self.enemyTeamData,
      stageIdMap = self.stageIdMap,
      teamCount = 5,
      challengeCount = remindCount
    })
    ed.pushScene(scene)
  else
    ed.showToast(T("\230\172\161\230\149\176\228\184\141\232\182\179"))
  end
end

function CreviceDefendMainScene:onClickReward()
  ed.ui.CreviceDefendRewardWin.create()
end

function CreviceDefendMainScene:onClickRankList()
  ed.CreviceDefendNetWork:sendOpenRankPanel()
end

function CreviceDefendMainScene:onClickRecord()
  ed.CreviceDefendNetWork:sendSearchRecord()
end

function CreviceDefendMainScene:onClickTaskReward()
  self.baseui.bg_reward_line:setVisible(true)
  self.baseui.btn_getreward:setVisible(false)
end

function CreviceDefendMainScene:onClickTaskRewardLine()
  self.baseui.btn_getreward:setVisible(true)
  self.baseui.bg_reward_line:setVisible(false)
end

function CreviceDefendMainScene:initTaskReward()
  self.rewardArr = {}
  self.creviceDefendTaskRewardConfig = ed.getDataTable("CreviceDefendTaskReward")
  for i, v in pairs(self.creviceDefendTaskRewardConfig) do
    self.rewardArr[v.ID] = v
  end
  self:initRewardList(self.rewardArr)
end

function CreviceDefendMainScene:initRewardList(rewardArr)
  for id, rewardConfig in ipairs(rewardArr) do
    local config = self.creviceDefendTaskRewardConfig[id]
    local rewardId = config["Reward ID " .. 1]
    local rewardType = config["Reward Type " .. 1]
    local rewardAmount = config["Reward Amount " .. 1]
    local requireCount = config["Require Count"]
    rewardArr[rewardConfig.ID] = {
      type = rewardType,
      taskID = id,
      requireCount = requireCount,
      id = rewardId,
      amount = rewardAmount,
      rewardState = self:onTaskRewardState(id, requireCount)
    }
  end
end

function CreviceDefendMainScene:onTaskRewardState(id, requireCount)
  for i, v in pairs(ed.CreviceDefendManager:getTasks()) do
    if v == id then
      return self.REWARD_STATE_COMPLETED
    end
  end
  local totalCount = ed.CreviceDefendManager:getTotalCount()
  if requireCount <= totalCount then
    return self.REWARD_STATE_AVAILABLE
  end
  return self.REWARD_STATE_UNCOMPLETED
end

function CreviceDefendMainScene:refreshCreviceDefendTaskView()
  for id, v in ipairs(self.rewardArr) do
    v.rewardState = self:onTaskRewardState(v.taskID, v.requireCount)
  end
  self:refreshTaskView()
end

function CreviceDefendMainScene:refreshTaskView()
  self.baseui.layer_boss_reward:removeAllChildrenWithCleanup(true)
  local itemList = {}
  local rewardDragList = ed.UITool.createDraglist(self.baseui.layer_boss_reward, {
    doPressIn = function(x, y)
      for k, v in pairs(itemList) do
        if ed.containsPoint(v.icon, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, v)
      local itemData = v.itemData
      if not ed.containsPoint(self.baseui.layer_boss_reward, x, y) then
        return
      end
      if itemData.rewardState == self.REWARD_STATE_AVAILABLE then
        ed.CreviceDefendNetWork:sendGetTaskRewards(itemData.taskID)
      else
        ed.ui.packageDetailWin.create({
          id = itemData.id,
          count = itemData.amount,
          type = itemData.type
        }):popWindow()
      end
    end,
    priority = -300
  })
  local containerHeight = self.baseui.layer_boss_reward:getContentSize().height
  local size = 90
  local offsetX = -15
  local posY = containerHeight - size * #self.rewardArr + 30
  local gapY = -12
  for i, itemData in ipairs(self.rewardArr) do
    local icon = self:createItemIcon(itemData)
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    local targetPos = iconSize.height + posY
    icon:setPosition(ccp(iconSize.width / 2 + offsetX, targetPos))
    posY = posY + iconSize.height + gapY
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  local realContentHeight = #self.rewardArr * size - 12 * #self.rewardArr + 20
  rewardDragList:initListHeight(realContentHeight)
  local expandHeight = realContentHeight - containerHeight
  if containerHeight < realContentHeight then
    local reward_index = self:getStateAvailable()
    local offset = expandHeight - reward_index * (size - 5) + 90
    if -10 <= offset then
      rewardDragList:setListPos(ccp(0, offset))
    else
      rewardDragList:setListPos(ccp(0, 2))
    end
  end
end

function CreviceDefendMainScene:getStateAvailable()
  local count = #self.rewardArr
  for index, itemData in ipairs(self.rewardArr) do
    if itemData.rewardState == self.REWARD_STATE_AVAILABLE or itemData.rewardState == self.REWARD_STATE_UNCOMPLETED then
      if index == count then
        index = count - 2
      end
      if index == count - 1 then
        index = count - 1
      end
      return index
    end
  end
  return 1
end

function CreviceDefendMainScene:createItemIcon(itemData)
  local id = itemData.id
  local itemType = itemData.type
  local amount = itemData.amount
  local rewardState = itemData.rewardState
  local requireCount = itemData.requireCount
  local icon = ed.createItemIcon({
    id = id,
    type = itemType,
    amount = 1
  })
  if rewardState == self.REWARD_STATE_COMPLETED then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == self.REWARD_STATE_AVAILABLE then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  end
  local numberLabel = ed.createLabelTTF(tostring(amount), 20)
  icon:addChild(numberLabel, 1)
  numberLabel:setAnchorPoint(ccp(1, 0.5))
  numberLabel:setPosition(ccp(78, 20))
  ed.setLabelStroke(numberLabel, ed.toccc3(10240554), 1)
  local requireLabel = ed.createLabelTTF(tostring(requireCount), 24)
  icon:addChild(requireLabel, 2)
  requireLabel:setPosition(ccp(45, -10))
  if rewardState == self.REWARD_STATE_COMPLETED then
    local numberBg = ed.createSprite("UI/alpha/1080P/crevicedefend/rewardnum_bg1.png")
    numberBg:setScale(1.5)
    icon:addChild(numberBg, 2)
    numberBg:setPosition(ccp(45, -10))
    ed.setLabelColor(requireLabel, ccc3(182, 154, 184))
  else
    local numberBg = ed.createSprite("UI/alpha/1080P/crevicedefend/rewardnum_bg.png")
    numberBg:setScale(1.5)
    icon:addChild(numberBg, 1)
    numberBg:setPosition(ccp(45, -10))
  end
  return icon
end

function CreviceDefendMainScene:updateRedPoint()
  local state = false
  for id, v in ipairs(self.rewardArr) do
    local config = self.creviceDefendTaskRewardConfig[id]
    local requireCount = config["Require Count"]
    local stateTask = self:onTaskRewardState(id, requireCount)
    if stateTask == self.REWARD_STATE_AVAILABLE then
      state = true
      break
    end
  end
  if state then
    ed.CreviceDefendManager:setOpenTaskRewards(1)
  else
    ed.CreviceDefendManager:setOpenTaskRewards(0)
  end
  self.baseui.image_redpoint:setVisible(state)
end

function CreviceDefendMainScene:taskPush(value)
  for i, v in pairs(self.LoadQueue) do
    if v.taskIndex == value.taskIndex then
      return
    end
  end
  table.insert(self.LoadQueue, value)
end

function CreviceDefendMainScene:taskPop()
  return table.remove(self.LoadQueue)
end

function CreviceDefendMainScene:taskTop()
  return self.LoadQueue[#self.LoadQueue]
end

function CreviceDefendMainScene:taskIsEmpty()
  return #self.LoadQueue == 0
end

function CreviceDefendMainScene:getTargetIndex(index)
  for i, v in pairs(self.LoadQueue) do
    if v.taskIndex == index then
      return v
    end
  end
  return nil
end

function CreviceDefendMainScene:initLoadTask()
  self.LoadQueue = {}
  self:addAsyncTask(self.enemy_index)
end

function CreviceDefendMainScene:addAsyncTask(index)
  if not self:taskIsEmpty() then
    local task = self:taskTop()
    if task and task.state ~= 2 then
      self:taskPop()
    end
  end
  self:taskPush({taskIndex = index, state = 0})
end

function CreviceDefendMainScene:update(dt)
  self:updateFcaByList(dt, self.fcaList)
  if not self:taskIsEmpty() then
    local task = self:taskTop()
    if task then
      if task.state == 0 then
        self:LoadTaskFca(task)
      end
      local targetIndex = task.taskIndex + 1
      if task.state == 2 and targetIndex < 6 then
        self:addAsyncTask(targetIndex)
      end
    end
  end
end

function CreviceDefendMainScene:LoadTaskFca(taskInfo)
  local loadTeamIndex = taskInfo.taskIndex
  taskInfo.state = 1
  ed.asyncload.unregistLoadingListener()
  for teamIndex, v in pairs(self.enemyTeamData) do
    if teamIndex == loadTeamIndex then
      for index, unitID in ipairs(v) do
        ed.asyncload.preloadFcaByUnitID(unitID)
      end
    end
  end
  ed.asyncload.registLoadingListener(function()
    taskInfo.state = 2
    for index, unitID in ipairs(self.enemyTeamData[loadTeamIndex]) do
      local puppet, _ = ed.readhero.getActor(unitID, "Idle", true, false)
      local priorityDefault = 99
      if index == 3 then
        priorityDefault = priorityDefault + 1
        puppet:setScale(self.bossSizeMap[unitID])
        self:onAddBossEffect(puppet, priorityDefault)
      else
        puppet:setScale(0.6)
      end
      self.baseui.layer_boss:addChild(puppet, priorityDefault)
      puppet:setPosition(actorPos[index], 0)
      self:addFca(puppet)
      if nil == self.asyncLoadFca[loadTeamIndex] then
        self.asyncLoadFca[loadTeamIndex] = {}
      end
      table.insert(self.asyncLoadFca[loadTeamIndex], puppet)
      if loadTeamIndex ~= self.enemy_index then
        puppet:setVisible(false)
      end
    end
  end)
end
