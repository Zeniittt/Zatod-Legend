local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonFirstBloodWin = class

function class.create(param)
  local self = base.create("awakeDungeonFirstBloodWin", {notBlurBg = true, noShade = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.stageId = param.stageId
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonFirstBloodWin)
  self.container:addChild(container)
  self.ui = ui
  local stageRecord = self.dungeonMgr:getStageRecord(self.stageId)
  if not stageRecord then
    return
  end
  local user_summary = stageRecord.userSummary
  local param = {
    id = user_summary._avatar,
    scale = 0.6,
    level = user_summary._level,
    lvoffset = {x = -47, y = -25},
    levelScale = 0.8
  }
  local head = ed.getWholeHeadIcon(param)
  self.ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(user_summary._name, user_summary._medal, {
    anchorPoint = ccp(0, 0.5),
    medalScale = 0.13,
    fontSize = 14
  })
  self.ui.panel_name:addChild(name)
  name:setPosition(ccp(2, 12))
  ed.setLabelString(self.ui.label_guild, user_summary._guild_name or "")
  local breakTime = stageRecord.breakTime
  local y, m, d, h, min, s = ed.time2YMDHMS(ed.time2Server(breakTime))
  ed.setLabelString(self.ui.label_pass_time, string.format("%s-%s-%s  %s:%s:%s" .. ed.getUTCLabel(), y, m, d, h, min, s))
  local lineIndex = 0
  local heroes = stageRecord.heroes or {}
  self.ui.panel_hero_list:removeAllChildrenWithCleanup(true)
  local panelSize = self.ui.panel_hero_list:getContentSize()
  for index, heroSummary in ipairs(heroes) do
    if 1 == index % 5 then
      lineIndex = lineIndex + 1
    end
    local heroIcon = ed.readhero.createIcon({
      id = heroSummary._tid,
      rank = heroSummary._rank,
      fashion_id = heroSummary._fashion,
      petInfo = heroSummary._pet
    }).icon
    heroIcon:setScale(0.6)
    self.ui.panel_hero_list:addChild(heroIcon)
    local posX = (index - 1) % 5 * 52 + 35
    local posY = panelSize.height * 0.5 - (lineIndex - 1) * 52
    heroIcon:setPosition(ccp(posX, posY))
  end
  local addHeight = (lineIndex - 1) * 52
  local bgSize = self.ui.image_bg:getContentSize()
  bgSize.height = bgSize.height + addHeight
  self.ui.image_bg:setContentSize(bgSize)
  self.ui.panel_name:setPositionY(self.ui.panel_name:getPositionY() + addHeight)
  self.ui.panel_head:setPositionY(self.ui.panel_head:getPositionY() + addHeight)
  self.ui.label_guild:setPositionY(self.ui.label_guild:getPositionY() + addHeight)
  self.ui.Label_23500:setPositionY(self.ui.Label_23500:getPositionY() + addHeight)
  self.ui.label_pass_time:setPositionY(self.ui.label_pass_time:getPositionY() + addHeight)
  self.ui.panel_hero_list:setPositionY(self.ui.panel_hero_list:getPositionY() + addHeight)
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
