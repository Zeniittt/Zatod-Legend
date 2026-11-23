module("ed.videoplayer", package.seeall)
panel = {}
panel.__index = panel
local base = ed.ui.basetouchnode
setmetatable(panel, base.mt)

function panel.create(scene)
  local object = {}
  setmetatable(object, panel)
  object:initData(scene)
  object:initAppearence()
  object:registerToucher()
  return object
end

function panel:initData(scene)
  self.scene = scene
  self.name = "videoplayer_panel"
end

function panel:initAppearence()
  self.container, self.ui = ed.editorui(ed.uieditor.videplayer_barrage)
  self.scene.ui_layer:addChild(self.container, 50)
  self:initPauseBtn()
  self:initEditBox()
  self:initDanmu()
  local isGM = ed.player:isGM()
  self.ui.btn_manage:setVisible(isGM)
end

function panel:initPauseBtn()
  self.ui.img_play:setVisible(false)
end

function panel:initEditBox()
  local info = {
    config = {
      editSize = self.ui.img_input:getContentSize(),
      maxLength = 30,
      fontColor = ccc3(0, 0, 0),
      fontSize = 20,
      position = ccp(10, 0)
    }
  }
  local editbox = editBox:new(info)
  editbox.edit:setAnchorPoint(ccp(0, 0))
  editbox.edit:setPosition(ccp(0, 0))
  self.ui.img_input:addChild(editbox.edit)
  self.editbox = editbox
end

function panel:resetEditBox()
  if self.editbox then
    self.editbox:setString(" ")
  end
end

function panel:getEditBoxString()
  local str = self.editbox:getString()
  if str == " " then
    str = ""
  end
  return str
end

function panel:initDanmu()
  self.ui.img_closedanmu:setVisible(false)
end

function panel:registerToucher()
  self.scene:addMianLayerTouchHandler(self:btGetMainTouchHandler())
  self:btRegisterButtonClick({
    button = self.ui.img_pause,
    pressScale = 1,
    key = "btn_play",
    clickHandler = function()
      self:doPause()
    end,
    mcpMode = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.img_play,
    pressScale = 1,
    key = "btn_pause",
    clickHandler = function()
      self:doPlay()
    end,
    mcpMode = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.img_opendanmu,
    pressScale = 1,
    key = "btn_closedanmu",
    clickHandler = function()
      self:doCloseDanmu()
    end,
    mcpMode = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.img_closedanmu,
    pressScale = 1,
    key = "btn_openDanmu",
    clickHandler = function()
      self:doOpenDanmu()
    end,
    mcpMode = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_send,
    press = self.ui.btn_send_press,
    key = "btn_send",
    clickHandler = function()
      if self:checkSend() then
        self:doSend()
      end
    end,
    mcpMode = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_manage,
    press = self.ui.btn_manage_press,
    key = "btn_manage",
    clickHandler = function()
      local panel = VideoPlayerBarrage.create(self.scene.barrageArray)
      panel:popWindow()
    end,
    mcpMode = true,
    clickInterval = 0.5
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.editbox:touch(event, x, y)
    end,
    key = "editbox"
  })
end

function panel:doPlay()
  self.scene:resumeBattle("pauseButton")
  self.ui.img_pause:setVisible(true)
  self.ui.img_play:setVisible(false)
end

function panel:doPause()
  self.ui.img_pause:setVisible(false)
  self.ui.img_play:setVisible(true)
  ed.playSound(ed.sound.battle.clickReturn)
  ed.scene:createPauseLayer()
  self:initPauseHandler()
end

function panel:initPauseHandler()
  function self.scene.pauseLayerButtonHandler.resume()
    xpcall(function()
      ed.resetMusicVolume()
      
      local s = CCScaleTo:create(0.2, 0)
      s = CCEaseBackIn:create(s)
      local func = CCCallFunc:create(function()
        xpcall(function()
          ed.playEffect(ed.sound.deo.common_click_feedback)
          self.scene:resumeBattle("pauseButton")
          self.ui.img_pause:setVisible(true)
          self.ui.img_play:setVisible(false)
          self.scene.pauseLayer:removeFromParentAndCleanup(true)
          self.scene.pauseLayer = nil
          if self.scene.nextwaveAction then
            ed.scene.scene:runAction(self.scene.nextwaveAction)
          end
        end, EDDebug)
      end)
      local sequence = CCSequence:createWithTwoActions(s, func)
      self.scene.pauseContainer:runAction(sequence)
    end, EDDebug)
  end
end

function panel:doCloseDanmu()
  self.scene:closeBarrage()
  self.ui.img_opendanmu:setVisible(false)
  self.ui.img_closedanmu:setVisible(true)
end

function panel:doOpenDanmu()
  self.scene.openBarrage = true
  self.ui.img_opendanmu:setVisible(true)
  self.ui.img_closedanmu:setVisible(false)
end

function panel:doSend()
  local sendText = self:getEditBoxString()
  self:resetEditBox()
  local videoid = manager:getCurrentVideoId()
  local colorflag = self:getBarrageColorflag()
  if sendText ~= "" and videoid then
    local tick = ed.engine.ticks
    local info = {
      videoid = videoid,
      tick = tick,
      color = colorflag,
      content = sendText
    }
    network:sendBarrage(info)
    if ed.videoplayer.battleEnd then
      ed.videoplayer.battleEnd:addBarrage(info)
    end
    manager:addMyBarrage(sendText, colorflag)
  end
end

function panel:checkSend()
  local sendText = self:getEditBoxString()
  if 60 < #sendText then
    ed.showToast(T("\229\143\145\233\128\129\229\188\185\229\185\149\229\164\170\233\149\191"))
    return false
  end
  return true
end

function panel:getBarrageColorflag()
  if manager:isMyVideo() then
    return 1
  else
    return 0
  end
end
