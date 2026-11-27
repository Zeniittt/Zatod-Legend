local base = ed.ui.commonscene
local SoloArenaScene = newclass(base.mt)
ed.ui.SoloArenaScene = SoloArenaScene
ed.UITool.registViewOpenFunc("SoloArenaScene", function(param)
  ReloadModule("ui_new/modules/solo/SoloModuleList")
  ed.SoloNetwork:sendChessOpenPanel()
end)

function SoloArenaScene:initData()
end

function SoloArenaScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 50, top = 18})
end

function SoloArenaScene:initLabels()
  ed.setLabelStroke(self.ui.label_compendium, ed.toccc3(8278061), 1)
  ed.setLabelStroke(self.ui.label_rank, ed.toccc3(8278061), 1)
  ed.setLabelStroke(self.ui.label_team, ed.toccc3(8278061), 2)
  ed.setLabelStroke(self.ui.label_history, ed.toccc3(8278061), 1)
  ed.setLabelStroke(self.ui.label_score, ccc3(52, 33, 19), 1)
  ed.setLabelStroke(self.ui.label_match, ed.toccc3(8278061), 2)
  ed.setLabelStroke(self.ui.label_robot, ed.toccc3(8278061), 2)
  ed.setLabelStroke(self.ui.label_leisure, ed.toccc3(8278061), 2)
  ed.setLabelFontName(self.ui.label_match, ed.fontBold)
  ed.setLabelFontName(self.ui.label_team, ed.fontBold)
  ed.setLabelFontName(self.ui.label_robot, ed.fontBold)
  ed.setLabelFontName(self.ui.label_leisure, ed.fontBold)
  ed.setLabelStroke(self.ui.label_free_time, ed.toccc3(7883025), 1)
  ed.setLabelStroke(self.ui.Label_grade, ed.toccc3(8278061), 1)
  self.ui.label_free:setVisible(false)
  local label_free = ed.ui.gradientLabel.create({
    text = T("\230\156\172\229\145\168\233\153\144\229\133\141"),
    fontSize = 17,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16775806),
    strokeSize = 2,
    strokeColor = ed.toccc3(5717535)
  })
  label_free.node:setPosition(self.ui.label_free:getPosition())
  self.ui.bg_free:addChild(label_free.node)
  local score = ed.SoloManager:getScore()
  local data = ed.copyTable(ed.getDataTable("SoloSeasonGrade"))
  table.sort(data, function(a, b)
    return a["Current Grade Score"] > b["Current Grade Score"]
  end)
  for i, v in ipairs(data) do
    if score >= v["Current Grade Score"] then
      self.ui.Label_grade:setString(v.Name)
      self.ui.gradeIcon = ed.createSpriteTools({
        res = v.Icon,
        pos = ccp(0, 50),
        parent = self.ui.rank,
        scale = 0.6
      })
      break
    end
  end
  self.ui.label_score:setString(T("\231\167\175\229\136\134:%d", score))
end

function SoloArenaScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.SoloArenaScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackButton()
  self:setBackground("UI/alpha/1080P/chesscard/bg.jpg")
  self.ui.title:setVisible(false)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\230\150\151\232\155\144\232\155\144"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 5
  })
  self:adaptUI()
  self:initLabels()
  local actor = ed.readhero.getSoloActor(ed.SoloManager.lastHeroId, "Idle")
  actor:setScale(1.4)
  self.ui.layer_hero:addChild(actor, 5)
  self:addFca(actor)
  self.ui.bg_free:setVisible(false)
end

function SoloArenaScene:onPopScene()
  if ed.SoloManager.isMatching then
    ed.SoloManager:setMatching(false)
    ed.SoloNetwork:sendChessMatchCancel()
  end
  base.onPopScene(self)
end

function SoloArenaScene:onTeamJoin(reply, teamId)
  ed.SoloManager:setTeamId(teamId)
  ed.ui.SoloRoomPrepare.create({teamId = teamId}):popWindow()
  ed.SoloNetwork:createTeamHeartBeat()
end

function SoloArenaScene:registerEvents()
  self:listenEvent("SoloLoadNotify", function()
    if ed.getCurrentScene().identity == "SoloArenaScene" then
      ed.pushScene(ed.ui.SoloLoadScene.create())
    end
  end)
  self:listenEvent("applicationDidEnterBackground", function()
    FireEvent("SoloMatchWinClose")
  end)
  self:listenEvent("SoloMatchStart", function(data)
    ed.ui.SoloMatchWin.create(data._expect_wait_time):popWindow()
  end)
  self:listenEvent("SoloTeamJoin", function(join, teamId)
    self:onTeamJoin(join, teamId)
  end)
end

function SoloArenaScene:onClickRobot()
  if ed.SoloManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local version = ed.storage.getString("current-version")
  ed.SoloNetwork:sendChessMatchStart(version, "robot")
end

function SoloArenaScene:onClickLeisure()
  if ed.SoloManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local version = ed.storage.getString("current-version")
  ed.SoloNetwork:sendChessMatchStart(version, "casual")
end

function SoloArenaScene:onClickMatch()
  if ed.SoloManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local version = ed.storage.getString("current-version")
  ed.SoloNetwork:sendChessMatchStart(version, "normal")
end

function SoloArenaScene:onClickedTeamBtn()
  if ed.SoloManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local version = ed.storage.getString("current-version")
  ed.SoloNetwork:sendChessMatchStart(version, "normal")
end

function SoloArenaScene:onClickTeam()
  if ed.SoloManager:getMatching() then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  ed.ui.SoloRoomSwitch.create():popWindow()
end

function SoloArenaScene:onClickBookBtn()
  ReloadModule("ui_new/modules/solo/SoloBookWin")
  ed.ui.SoloBookWin.create():popWindow()
end

function SoloArenaScene:onClickRanklistBtn()
  if ed.SoloManager:getMatching() then
    ed.showToast(T("\229\140\185\233\133\141\228\184\173\230\151\160\230\179\149\230\159\165\231\156\139"))
    return
  end
  ed.UITool.openView("ranklist", {index = 4, index2 = 4})
end

function SoloArenaScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.SoloArenaRule.create():popWindow()
  end)
  ed.UITool.registerBtn(self, "btn_match", function()
    self:onClickMatch()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_robot", function()
    self:onClickRobot()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_leisure", function()
    self:onClickLeisure()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_team", function()
    self:onClickTeam()
  end, {pressScale = 0.8, normalScale = 0.85})
  ed.UITool.registerBtn(self, "btn_book", function()
    self:onClickBookBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rank", function()
    self:onClickRanklistBtn()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_history", function()
    ed.SoloNetwork:sendSoloQueryRecords()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "gradeIcon", function()
    ed.ui.soloGradeRewardPop.create({})
  end, {pressScale = 0.55, normalScale = 0.6})
end

function SoloArenaScene.create()
  local self = base.create("SoloArenaScene", {noBottomButton = true})
  setmetatable(self, SoloArenaScene.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:registerTouchEvents()
  self:registerOnEnterHandler("onEnter", function(type)
    ed.playMusic(ed.music.solo)
  end)
  self:registerOnPopSceneHandler("onPopScene", function(type)
    ed.stopMusic()
  end)
  local key = ed.getRoleKey("cricketFirstRed")
  ed.storage.setValue(key, true)
  FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.Tavern)
  ed.SoloNetwork:sendTeamOpenPanel()
  return self
end
