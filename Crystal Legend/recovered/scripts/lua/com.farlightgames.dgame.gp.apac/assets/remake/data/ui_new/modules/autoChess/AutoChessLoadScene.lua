local base = ed.ui.commonscene
local AutoChessLoadScene = newclass(base.mt)
ed.ui.AutoChessLoadScene = AutoChessLoadScene
require("battle/AutoChessBattleEngine")
require("battle/AutoChessBattleScene")
local TIPS = {
  T("3\228\184\1701\230\152\159\232\139\177\233\155\132\229\143\175\228\187\165\229\144\136\230\136\1442\230\152\159\227\128\130"),
  T("3\230\152\159\232\139\177\233\155\132\229\143\170\233\156\128\232\166\1292\228\184\1702\230\152\159\229\144\136\230\136\144\227\128\130"),
  T("\229\149\134\229\186\151\231\149\140\233\157\162\229\186\149\233\131\168\230\156\137\229\189\147\229\137\141\229\144\132\231\167\141\230\163\139\229\173\144\229\136\183\230\150\176\230\166\130\231\142\135\227\128\130"),
  T("\229\164\154\228\184\170\229\144\140\231\167\141\230\151\143\230\160\135\232\175\134\232\139\177\233\155\132\228\184\138\233\152\181\229\176\134\230\139\165\230\156\137\230\150\176\230\138\128\232\131\189\227\128\130"),
  T("\232\191\158\232\131\156\230\136\150\232\128\133\232\191\158\232\180\165\233\131\189\232\131\189\230\139\191\229\136\176\233\162\157\229\164\150\231\154\132\233\135\145\229\184\129\229\165\150\229\138\177\227\128\130")
}

function AutoChessLoadScene:initData()
  self.progressNode = {}
end

function AutoChessLoadScene:initLabels()
  self.ui.img_enter_tip:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.img_enter_tip, ed.toccc3(14122777), 2)
end

function AutoChessLoadScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.node_player_1, {left = 0})
  ed.layout.layoutWithMagin(self.ui.node_player_2, {left = 130})
  ed.layout.layoutWithMagin(self.ui.node_player_3, {right = 0})
  ed.layout.layoutWithMagin(self.ui.node_player_4, {right = 130})
end

function AutoChessLoadScene:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.AutoChessLoadPanel)
  self.mainLayer:addChild(self.container)
  self:setBackground("UI/alpha/1080P/chess/loading/bg_chess_loading.jpg")
  self:initLabels()
  self:adaptUI()
end

function AutoChessLoadScene:createPlayerUI(data, index)
  if not data then
    self.ui["node_player_" .. index]:setVisible(false)
    return
  end
  local summary = data._user_summary
  local head = ed.getTeamHead({
    id = summary._avatar
  })
  head:setScale(0.95)
  ed.UITool.replaceUINew(self.ui, "icon_" .. index, head)
  self.ui["label_name_" .. index]:setString(summary._name)
  ed.setLabelStroke(self.ui["label_name_" .. index], ccc3(0, 0, 0), 1.5)
  ed.setLabelStroke(self.ui["label_progress_" .. index], ccc3(0, 0, 0), 1.5)
  if index == 1 then
    self.ui["label_progress_" .. index]:setString("0%")
    self.ui["img_progress_" .. index]:setTextureRect(CCRectMake(0, 0, 0, 18.5))
  else
    local userKey = data._user_key
    local keyStr = userKey._server_id .. "_" .. userKey._user_id
    self.progressNode[keyStr] = {
      label = self.ui["label_progress_" .. index],
      bar = self.ui["img_progress_" .. index]
    }
    local progress = ed.AutoChessTeachManager:isGuideFlag() and 100 or 0
    self.ui["label_progress_" .. index]:setString(progress .. "%")
    self.ui["img_progress_" .. index]:setTextureRect(CCRectMake(0, 0, progress * 0.885, 18.5))
    self.ui["label_name_" .. index]:setString(summary._name)
  end
end

function AutoChessLoadScene:initPlayerPanel()
  local playerList = ed.AutoChessModel:getPlayerList()
  local playerData = {}
  for k, player in ipairs(playerList) do
    local data = {
      _user_summary = player:getUserSummary(),
      _user_key = player:getUserKey()
    }
    if player:isMySelf() then
      table.insert(playerData, 1, data)
    else
      table.insert(playerData, data)
    end
  end
  for k, data in ipairs(playerData) do
    self:createPlayerUI(data, k)
  end
  local limitWidth = self.ui.node_player_4:getPositionX() - self.ui.node_player_2:getPositionX() - self.ui.node_player_2:getContentSize().width - 10
  local delayAction = CCDelayTime:create(4)
  local callback = CCCallFunc:create(function(...)
    local index = math.random(1, #TIPS)
    local tipStr = TIPS[index]
    ed.setString(self.ui.label_tip, tipStr)
    self.ui.label_tip:limitWidthByScale(limitWidth)
  end)
  local seqAction = CCSequence:create(ccArrayMake(delayAction, callback))
  local final = CCRepeatForever:create(seqAction)
  self.ui.label_tip:runAction(final)
end

function AutoChessLoadScene:registerEvents(...)
  self:listenEvent("EventChessRoundStart", function()
    if not ed.chess_debug_mode and not ed.AutoChessTeachManager:isGuideFlag() then
      self:listenTimer(Timer:Once(0.01), function()
        self:enterBattleScene()
      end)
    end
  end)
  self:listenEvent("EventChessLoadNotify", function()
    self:updateLoadingUI()
  end)
  self:listenEvent("EventChessOverNotify", function()
    ed.popScene()
  end)
end

function AutoChessLoadScene:startLoading()
  if ed.chess_debug_mode then
    self:enterBattleScene()
  else
    self:registerUpdateHandler("updateLoadingFrame", self:onUpdateLoading())
  end
end

function AutoChessLoadScene:enterBattleScene()
  local stage = ed.lookupDataTable("Stage", nil, 100001)
  local battle = ed.lookupDataTable("Battle", nil, 100001, 1)
  ed.engine = ed.AutoChessBattleEngine
  ed.AutoChessBattleEngine:enterAutoChess({stageId = 100001})
  local scene = ed.AutoChessBattleScene.create(stage, battle, {autoChessMode = true})
  ed.replaceScene(scene)
end

function AutoChessLoadScene:updateLoadingUI()
  for k, node in pairs(self.progressNode) do
    if tolua.isnull(node.label) or tolua.isnull(node.bar) then
      return
    end
    local loadData = ed.AutoChessManager:getLoadingDataByUser(k)
    node.label:setString(loadData.progress .. "%")
    local percent = loadData.progress / 100
    node.bar:setTextureRect(CCRectMake(0, 0, 88.5 * percent, 18.5))
  end
end

function AutoChessLoadScene:onUpdateLoading()
  local count = 0
  local index = 1
  local step = "loadUnit"
  local list = ed.AutoChessManager:getPreLoadUnitList()
  index = 1
  
  local function handler(dt)
    count = count + dt
    xpcall(function()
      local userKey = ed.ChessPlayer.getMyUserKey()
      if step == "loadUnit" then
        if index > #list then
          step = "loadUnitEnd"
        else
          if 0.5 < count then
            local progress = math.floor(index / #list * 99)
            self.ui.label_progress_1:setString(progress .. "%")
            self.ui.img_progress_1:setTextureRect(CCRectMake(0, 0, progress * 0.885, 18.5))
            if not ed.chess_debug_mode and not ed.AutoChessTeachManager:isGuideFlag() then
              ed.AutoChessNetwork:sendChessLoading(progress, 0)
            end
          end
          local tid = list[index]
          if type(tid) == "number" then
            ed.asyncload.preloadFcaByChessUnitID(tid)
          end
          index = index + 1
        end
      end
      if step == "loadUnitEnd" then
        step = "over"
        if ed.chess_debug_mode or ed.AutoChessTeachManager:isGuideFlag() then
          self:enterBattleScene()
        else
          self.ui.label_progress_1:setString("100%")
          self.ui.img_progress_1:setTextureRect(CCRectMake(0, 0, 88.5, 18.5))
          ed.AutoChessNetwork:sendChessLoading(99, 0)
          self:enterBattleScene()
        end
      end
      if 0.5 < count then
        count = 0
      end
    end, EDDebug)
  end
  
  return handler
end

function AutoChessLoadScene:onEnter()
  base.onEnter(self)
  ed.openMemeryGC = false
  self:initPlayerPanel()
  self:registerEvents()
  self:startLoading()
end

function AutoChessLoadScene:destroy()
  self:removeUpdateHandler("updateLoadingFrame")
end

function AutoChessLoadScene:onExit(...)
  base.onExit(self)
  self:destroy()
end

function AutoChessLoadScene.create()
  local self = base.create("AutoChessLoadScene", {noBottomButton = true})
  setmetatable(self, AutoChessLoadScene.mt)
  self:initData()
  self:initUI()
  return self
end
