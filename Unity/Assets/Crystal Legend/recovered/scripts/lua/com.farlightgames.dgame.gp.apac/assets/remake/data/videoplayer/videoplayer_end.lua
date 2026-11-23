module("ed.videoplayer", package.seeall)
endlayer = {}
endlayer.__index = endlayer
local base = ed.ui.popwindow
setmetatable(endlayer, base.mt)

function endlayer.create(param, info)
  local object = {}
  setmetatable(object, endlayer)
  object:initData(param, info)
  return object
end

function endlayer:initData(param, info)
  self.param = param
  self.info = info
end

function endlayer:setBarrage(barrageArray)
  self.barrageArray = barrageArray
end

function endlayer:addBarrage(info)
  local barrage = self:createNewBarrage(info)
  local tick = barrage._tick
  if not self.barrageArray[tick] then
    self.barrageArray[tick] = {}
  end
  table.insert(self.barrageArray[tick], barrage)
end

function endlayer:createNewBarrage(info)
  local barrage = ed.common.barrage()
  barrage._tick = info.tick
  barrage._color = info.color
  barrage._content = info.content
  return barrage
end

function endlayer:show()
  self:initAppearence()
  self:registerTouchHandler()
  local currentScene = ed.getCurrentScene()
  if currentScene and currentScene.identity == "battle" then
    currentScene.node:addChild(self.popwindow.mainLayer, 400)
  end
end

function endlayer:initAppearence()
  self.popwindow = base.create("videoplayer_endplayer")
  self.window = ed.createui("videoplayer_end", {
    mainLayer = self.popwindow.mainLayer,
    touch_node = self.popwindow
  })
  self:createUserSummary()
end

function endlayer:createUserSummary()
  local userLen = #self.info._video_user
  if userLen == 1 then
    local summary = self.info._video_user[1]._user_summary
    local head = self:createPlayerHead(summary)
    self.window.ui.player2_bg:addChild(head)
    self.window.ui.player1_bg:setVisible(false)
    self.window.ui.player3_bg:setVisible(false)
  elseif userLen == 3 then
    for i, user in ipairs(self.info._video_user) do
      local summary = user._user_summary
      local head = self:createPlayerHead(summary)
      self.window.ui["player" .. i .. "_bg"]:addChild(head)
    end
  end
end

function endlayer:createPlayerHead(summary)
  local name = summary._name == "NickName" and "" or summary._name
  local param = {
    id = summary._avatar,
    level = summary._level,
    name = name,
    vip = summary._vip > 0,
    scale = 1,
    offset = ccp(133, 60),
    lvoffset = ccp(40, 40),
    config = {nameposition = 13}
  }
  if summary._medal then
    param.medal = summary._medal
  end
  if summary._babel_level then
    param.babelLevel = summary._babel_level
  end
  local playerHead = ed.getWholeHeadIcon(param)
  playerHead:setPosition(ccp(-40, 50))
  return playerHead
end

function endlayer:registerTouchHandler()
  self.window:registerBtn("btn_reply", function()
    self:doReply()
  end)
  self.window:registerBtn("btn_data", function()
    self:doData()
  end)
  self.window:registerBtn("btn_exit", function()
    self:doExit()
  end)
end

function endlayer:doReply()
  ed.popScene()
  ed.srand(self.param.rseed)
  ed.engine:enterVideoPlayer(self.param)
  local stage = ed.lookupDataTable("Stage", nil, self.info._stage_id)
  local battle = ed.lookupDataTable("Battle", nil, self.info._stage_id, 1)
  ed.scene:reset(stage, battle, {
    videoplayer = {
      checkid = self.info._id,
      mode = self.info._battle_module
    }
  })
  if self.barrageArray then
    ed.scene:resetBarrage(self.barrageArray)
  end
  ed.pushScene(ed.scene)
end

function endlayer:doData()
  if ed.engine.unit_list then
    ed.ui.BattleStaticsWin:create(ed.engine.unit_list, "pvp")
  end
end

function endlayer:doExit()
  ed.popScene()
  ed.videoplayer.battleEnd = nil
end
