local base = ed.ui.commonscene
local SoloLoadScene = newclass(base.mt)
ed.ui.SoloLoadScene = SoloLoadScene
require("battle/SoloBattleEngine")
require("battle/SoloBattleScene")
local TIPS = {
  T("\232\191\158\232\131\156\230\136\150\232\128\133\232\191\158\232\180\165\233\131\189\232\131\189\230\139\191\229\136\176\233\162\157\229\164\150\231\154\132\233\135\145\229\184\129\229\165\150\229\138\177\227\128\130")
}

function SoloLoadScene:initData()
  self.progressNode = {}
end

function SoloLoadScene:initLabels()
  self.ui.img_enter_tip:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.img_enter_tip, ed.toccc3(14122777), 2)
end

function SoloLoadScene:adaptUI()
  self.ui.ImageView_205:setScale(ed.display.winSize.width / 1170)
end

function SoloLoadScene:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.SoloLoadPanel)
  self.mainLayer:addChild(self.container)
  self:setBackground("UI/alpha/1080P/chess/loading/bg_chess_loading.jpg")
  self:initLabels()
  self:adaptUI()
end

function SoloLoadScene:createPlayerUI(data, index)
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
  local userKey = data._user_key
  local keyStr = userKey._server_id .. "_" .. userKey._user_id
  self.progressNode[keyStr] = {
    label = self.ui["label_progress_" .. index],
    bar = self.ui["img_progress_" .. index]
  }
  local progress = 0
  self.ui["label_progress_" .. index]:setString(progress .. "%")
  self.ui["img_progress_" .. index]:setTextureRect(CCRectMake(0, 0, progress * 0.885, 18.5))
  self.ui["label_name_" .. index]:setString(summary._name)
end

function SoloLoadScene:initPlayerPanel()
  local playerList = ed.SoloModel:getPlayerList()
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
  local delayAction = CCDelayTime:create(4)
  local callback = CCCallFunc:create(function(...)
    local index = math.random(1, #TIPS)
    local tipStr = TIPS[index]
    ed.setString(self.ui.label_tip, tipStr)
  end)
  local seqAction = CCSequence:create(ccArrayMake(delayAction, callback))
  local final = CCRepeatForever:create(seqAction)
  self.ui.label_tip:runAction(final)
end

function SoloLoadScene:registerEvents(...)
  self:listenEvent("SoloLoadNotify", function()
    self:updateLoadingUI()
  end)
  self:listenEvent("SoloWaitChoose", function()
    self:enterBattleScene()
  end)
  self:listenEvent("SoloRoundStart", function()
    self:enterBattleScene()
  end)
  local percent = 0
  self:listenTimer(Timer:Times(0.5, 5), function()
    percent = percent + 20
    local isFinish = 100 <= percent and 1 or 0
    ed.SoloNetwork:sendChessLoading(percent, isFinish)
  end)
end

function SoloLoadScene:enterBattleScene()
  print(debug.traceback())
  ed.engine = ed.SoloBattleEngine
  ed.tmpPopupCreate = ed.PopupCreate
  ed.PopupCreate = ed.SoloPopupCreate
  ed.SoloBattleEngine:enterSolo()
  local scene = ed.SoloBattleScene.create()
  ed.replaceScene(scene)
end

function SoloLoadScene:updateLoadingUI()
  local allFinished = true
  for k, node in pairs(self.progressNode) do
    if tolua.isnull(node.label) or tolua.isnull(node.bar) then
      return
    end
    local loadData = ed.SoloManager:getLoadingDataByUser(k)
    node.label:setString(loadData.progress .. "%")
    local percent = loadData.progress / 100
    allFinished = allFinished and loadData.isFinish == 1
    node.bar:setTextureRect(CCRectMake(0, 0, 88.5 * percent, 18.5))
  end
  if allFinished then
    self:enterBattleScene()
  end
end

function SoloLoadScene:onEnter()
  base.onEnter(self)
  ed.openMemeryGC = false
  self:initPlayerPanel()
  self:registerEvents()
end

function SoloLoadScene:destroy()
end

function SoloLoadScene:onExit(...)
  base.onExit(self)
  self:destroy()
end

function SoloLoadScene.create()
  local self = base.create("SoloLoadScene", {noBottomButton = true})
  setmetatable(self, SoloLoadScene.mt)
  self:initData()
  self:initUI()
  return self
end
