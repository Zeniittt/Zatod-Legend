module("ed.ui", package.seeall)
AutoChessResultScene = {}
AutoChessResultScene.__index = AutoChessResultScene
local AutoChessResultScope = {}

function AutoChessResultScene:destroy()
  if self.usedTimer then
    EnqueueDelayProcess(function()
      CloseTimer(self.usedTimer.Name)
      self.usedTimer = nil
    end)
  end
  CloseScope(AutoChessResultScope)
  ed.popScene()
end

function AutoChessResultScene.create(data)
  local base = ed.ui.basescene
  setmetatable(AutoChessResultScene, base.mt)
  local self = base.create("AutoChessResultScene")
  setmetatable(self, AutoChessResultScene)
  self:initData(data)
  self:registerOnEnterHandler("AutoChessResultSceneEnter", function()
    self:onEnter()
  end)
  return self
end

function AutoChessResultScene:initData(data)
  self.rankData = data
end

function AutoChessResultScene:onEnter()
  ed.playEffect(ed.sound.deo.battle_win)
  self:initUI()
  self:registerTouchEvents()
end

function AutoChessResultScene:startTimer()
  self.used_time = 5
  ed.setLabelString(self.ui.label_leave_tip, self.used_time .. T("s \229\144\142\232\191\148\229\155\158\228\184\187\231\149\140\233\157\162"))
  if not self.usedTimer then
    self.usedTimer = ListenTimer(Timer:Always(1), function()
      self.used_time = self.used_time - 1
      ed.setLabelString(self.ui.label_leave_tip, self.used_time .. T("s \229\144\142\232\191\148\229\155\158\228\184\187\231\149\140\233\157\162"))
      if self.used_time <= 0 then
        self:destroy()
      end
    end, AutoChessResultScene)
  end
end

function AutoChessResultScene:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.icon_result:getPosition()
  node:setPosition(ccp(x, y))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 44))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 44))
  self.ui.bg:addChild(node)
end

function AutoChessResultScene:initUI()
  ed.editorui(ed.uieditor.AutoChessResultPanel, {
    container = self.mainLayer,
    ui = self.ui
  })
  self:setBackground("UI/alpha/1080P/battle_bg/bbg_chess.jpg")
  self.ui.label_leave_tip:setVisible(false)
  self:initPlayerPanel()
  self:initLabelParam()
  self:playLightAnim()
end

function AutoChessResultScene:initLabelParam(...)
end

function AutoChessResultScene:initPlayerPanel()
  if type(self.rankData) == "table" then
    for index = 1, #self.rankData do
      local data = self.rankData[index]
      self:createPlayerUI(data)
    end
  end
end

local RankMap = {
  price_1 = 1,
  price_2 = 2,
  price_3 = 4,
  price_4 = 7,
  price_5 = 12
}

function AutoChessResultScene:createPlayerUI(data)
  if not data then
    return
  end
  local summary = data._user_summary
  local user_summary = summary._user_summary
  local user_key = summary._user_key
  local rank = data._rank
  local is_win = data._is_win
  local base_score = data._base_score
  local extra_score = data._extra_score
  local victory_cnt = data._victory_cnt
  local defeat_cnt = data._defeat_cnt
  local team_data = data._team
  local powers = data._hero_powers
  local isMySelf = user_key._user_id == ed.getUserid() and user_key._server_id == tonumber(game_server_id)
  if data._rank and data._rank == 1 and isMySelf then
    self:showExtraEffect()
  end
  local head = ed.getTeamHead({
    id = user_summary._avatar,
    length = 56
  })
  local node = self.ui["node_head_" .. rank]
  head:setPosition(ccp(0, 0))
  node:addChild(head, 0)
  ed.setLabelString(self.ui["label_name_" .. rank], user_summary._name)
  ed.setLabelStroke(self.ui["label_name_" .. rank], ccc3(34, 21, 5), 1)
  local myUserKey = ed.ChessPlayer.getMyUserKey()
  if ed.ChessPlayer.isUserKeyEqual(myUserKey, user_key) then
    ed.setLabelColor(self.ui["label_name_" .. rank], ccc3(159, 247, 115))
  end
  ed.setLabelString(self.ui["label_score_" .. rank], base_score)
  ed.setLabelStroke(self.ui["label_score_" .. rank], ed.toccc3(6109193), 1)
  ed.setLabelStroke(self.ui["label_score1_" .. rank], ed.toccc3(6109193), 1)
  ed.setLabelStroke(self.ui["label_vd1_" .. rank], ed.toccc3(6109193), 1)
  ed.setLabelStroke(self.ui["label_vd_" .. rank], ed.toccc3(6109193), 1)
  local nodeHero = self.ui["node_hero_" .. rank]
  local heros = type(team_data) == "table" and team_data._heroes or nil
  local offsetX = 0
  if type(heros) == "table" then
    for i = 1, #heros do
      local hero = heros[i]
      local initHeroId = math.floor(hero._hid / 10) * 10 + 1
      local rank = ed.getChessUnitStar(hero._hid)
      local price = ed.getDataTable("ChessUnit")[initHeroId]["Buy Price"]
      local param = {
        id = hero._hid,
        stars = rank,
        level = false,
        rank = RankMap["price_" .. price]
      }
      local heroIcon = ed.readhero.createChessIcon(param)
      heroIcon.icon:setScale(0.65)
      heroIcon.icon:setPosition(ccp(offsetX, 0))
      nodeHero:addChild(heroIcon.icon)
      offsetX = offsetX + 53
    end
    local nodeHeroPosX = nodeHero:getPositionX()
    nodeHero:setPositionX(nodeHeroPosX)
  end
  ed.setString(self.ui["label_vd_" .. rank], victory_cnt .. "-" .. defeat_cnt)
  if powers and powers[1] then
    local powerId = powers[1]._id
    local frame = ed.createChessPowerIcon(powerId)
    ed.UITool.replaceUINew(self.ui, "img_xxx_" .. rank, frame)
  end
end

function AutoChessResultScene:showExtraEffect()
  local rankEffect = ed.createFcaNode("eff_UI_Chess_refresh")
  rankEffect:setPosition(ccp(20, 20))
  self.ui.img_player_bg_1:addChild(rankEffect)
  ed.getCurrentScene():addFca(rankEffect)
end

function AutoChessResultScene:getMyScoreDiff()
  for i = 1, #self.rankData do
    local data = self.rankData[i]
    local summary = data._user_summary
    local user_key = summary._user_key
    local base_score = data._base_score
    local extra_score = data._extra_score
    local isMySelf = user_key._user_id == ed.getUserid() and user_key._server_id == tonumber(game_server_id)
    if isMySelf then
      return base_score
    end
  end
  return 0
end

function AutoChessResultScene:hasMyWeeklyRewardProgressDiff()
  for i = 1, #self.rankData do
    local data = self.rankData[i]
    local summary = data._user_summary
    local user_key = summary._user_key
    local rank = data._rank
    local isMySelf = user_key._user_id == ed.getUserid() and user_key._server_id == tonumber(game_server_id)
    if isMySelf and rank <= 2 then
      return true
    end
  end
  return false
end

function AutoChessResultScene:registerTouchEvents()
  self:btRegisterButtonClick({
    button = self.ui.btn_leave,
    press = self.ui.btn_leave_press,
    key = "btn_leave",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_back)
      self:destroy()
      local scoreDiff = self:getMyScoreDiff()
      ed.AutoChessRankManager:setScoreDiff(scoreDiff)
      local score = ed.AutoChessRankManager:getNewRankScore(ed.AutoChessRankManager:getMyRankScore(), ed.AutoChessRankManager:getScoreDiff())
      ed.AutoChessRankManager:setMyRankScore(score)
      local scene = ed.ui.AutoChessArenaScene.create()
      ed.pushScene(scene)
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    pressScale = 1,
    priority = 10
  })
end
