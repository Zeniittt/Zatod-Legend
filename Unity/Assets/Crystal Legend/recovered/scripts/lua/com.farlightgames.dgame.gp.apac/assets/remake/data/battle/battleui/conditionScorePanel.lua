local class = newclass("g")
ed.ui.conditionScorePanel = class

function class.create(condition)
  local self = setmetatable({}, {__index = class})
  self:init(condition)
  return self
end

function class:init(condition)
  self.condition = condition
  self:initView()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.condition_score_panel)
  container:setContentSize(ui.image_bg:getContentSize())
  self.ui = ui
  self.container = container
  self:adaptUI()
  self:initEffect()
  self:initLabels()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title_left, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_title_right, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_score_left, ed.toccc3(4325633), 1.5)
  ed.setLabelShadow(self.ui.label_score_left, ccc3(0, 0, 0), ccp(0, 2.5))
  ed.setLabelStroke(self.ui.label_score_right, ed.toccc3(0), 1.5)
  ed.setLabelShadow(self.ui.label_score_right, ccc3(34, 21, 17), ccp(0, 2.5))
  ed.setLabelStroke(self.ui.label_time, ccc3(0, 0, 0), 1.5)
  ed.setLabelFontName(self.ui.label_score_left, ed.fontBold)
  ed.setLabelFontName(self.ui.label_score_right, ed.fontBold)
end

function class:initEffect()
  local hourglass = ed.createSpine("effect/eff_UI_Dungeon_hourglass/eff_UI_Dungeon_hourglass", 0.2)
  self.ui.image_bg:addChild(hourglass)
  hourglass:setAnimation(0, "Idle", true)
  hourglass:setPositionX(self.ui.label_time:getPositionX() - 45)
  hourglass:setPositionY(self.ui.label_time:getPositionY())
  local killFlameLeft = ed.createSpine("effect/eff_UI_Dungeon_killflame/eff_UI_Dungeon_killflame", 0.5)
  self.ui.panel_left:addChild(killFlameLeft)
  killFlameLeft:setPosition(-10, -27)
  killFlameLeft:setVisible(false)
  self.killFlameLeft = killFlameLeft
  self.ui.image_bg_left:setVisible(true)
  local killFlameRight = ed.createSpine("effect/eff_UI_Dungeon_killflame_b/eff_UI_Dungeon_killflame_b", 0.5)
  killFlameRight:setScaleX(-1)
  self.ui.panel_right:addChild(killFlameRight)
  killFlameRight:setPosition(10, -27)
  killFlameRight:setVisible(false)
  self.killFlameRight = killFlameRight
  self.ui.image_bg_right:setVisible(true)
end

function class:adaptUI()
end

function class:update(dt)
  self:refreshUI()
end

function class:refreshUI()
  self:refreshTime()
  local showData = self.condition:getShowData() or {}
  self.ui.label_title:setString(showData.title or "")
  self.ui.label_title_left:setString(showData.leftTitle or "")
  self.ui.label_title_right:setString(showData.rightTitle or "")
  self.ui.label_score_left:setString(showData.leftScore or "")
  self.ui.label_score_right:setString(showData.rightScore or "")
  if showData.leftEffect and self.killFlameLeft then
    self.ui.image_bg_left:setVisible(false)
    self.killFlameLeft:setVisible(true)
    self.killFlameLeft:setAnimation(0, "Idle", false)
    self.killFlameLeft:unregisterScriptSpineHandler()
    self.killFlameLeft:registerScriptSpineHandler(function(event)
      if event == "end" then
        self.killFlameLeft:setVisible(false)
        self.ui.image_bg_left:setVisible(true)
      end
    end)
  end
  if showData.rightEffect and self.killFlameRight then
    self.ui.image_bg_right:setVisible(false)
    self.killFlameRight:setVisible(true)
    self.killFlameRight:setAnimation(0, "Idle", false)
    self.killFlameRight:unregisterScriptSpineHandler()
    self.killFlameRight:registerScriptSpineHandler(function(event)
      if event == "end" then
        self.killFlameRight:setVisible(false)
        self.ui.image_bg_right:setVisible(true)
      end
    end)
  end
end

function class:refreshTime()
  local seconds = math.ceil(ed.engine.time_limit)
  local str = string.format("%02i:%02i", seconds / 60, seconds % 60)
  self.ui.label_time:setString(str)
end
