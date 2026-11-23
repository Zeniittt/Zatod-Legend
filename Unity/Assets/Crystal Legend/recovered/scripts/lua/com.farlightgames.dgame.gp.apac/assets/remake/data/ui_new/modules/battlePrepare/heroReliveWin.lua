local base = ed.ui.popwindow
local heroReliveWin = newclass(base.mt)
ed.ui.heroReliveWin = heroReliveWin

function heroReliveWin.create(heroId, heroInfo)
  local self = base.create("heroReliveWin")
  setmetatable(self, heroReliveWin.mt)
  self:initData(heroId, heroInfo)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function heroReliveWin:initData(heroId, heroInfo)
  self.heroId = heroId
  self.heroInfo = heroInfo
  self.eventScope = {}
end

function heroReliveWin:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.heroReliveWin)
  self.mainLayer:addChild(self.container)
  self.ui.bg:setPosition(ed.display.center)
  self:initLabel()
  self:initNum()
  self:initHeroIcon()
end

function heroReliveWin:initLabel()
end

function heroReliveWin:initNum()
  ed.setString(self.ui.num, 1)
end

function heroReliveWin:initHeroIcon()
  local heroIcon
  if self.heroInfo then
    local iconInfo = self.heroInfo
    heroIcon = ed.readhero.createIcon({
      id = iconInfo.id,
      rank = iconInfo.rank,
      level = iconInfo.level,
      stars = iconInfo.stars,
      maxRange = iconInfo.maxRange,
      fashion_id = iconInfo.fashion_id,
      summary = iconInfo.summary,
      mercenary = {},
      length = 65
    })
  else
    heroIcon = ed.readhero.createIconByID(self.heroId, {length = 65})
  end
  heroIcon.icon:setPosition(ccp(self.ui.bg:getContentSize().width / 2, self.ui.bg:getContentSize().height / 2))
  self.ui.bg:addChild(heroIcon.icon)
end

function heroReliveWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "cancel_btn", function()
    CloseScope(self.eventScope)
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "confirm_btn", function()
    local isHire = 0
    if self.heroInfo then
      isHire = 1
    end
    ed.CrusadeNetwork:reliveHero(self.heroId, isHire)
    CloseScope(self.eventScope)
    self:destroy()
  end, {pressScale = 0.9})
end
