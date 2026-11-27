local class = {}
class.__index = class
ed.chatLadderFight = class
class.isPress = false
class.buttonConfigList = {}
class.pxy = ccp(0, 0)
class.clickConfig = nil
class.touchArea = nil

function class.create(param)
  local self = {}
  setmetatable(self, class)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.param = param
  self.width = 820 / ed.display.scaleFactor
  self.height = 170 / ed.display.scaleFactor
  self.totalGs = 0
  self.heroIconList = {}
  self.touchAreas = {}
  self:initView()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.chat_ladder_fight)
  self.container = container
  self.ui = ui
  ed.setLabelString(self.ui.label_gs, "xxx")
  ed.setLabelColor(self.ui.label_gs, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_gs, ed.toccc3(5586983), 1)
  local linkRichText = richText:new()
  local content = T("<text|chat_content|\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154><link|ladder_fight|>")
  linkRichText:setString(content)
  self.ui.panel_content:addChild(linkRichText.rootNode)
  ed.layout.centerYInParent(linkRichText.rootNode)
  self:refreshHeroList()
  table.insert(class.buttonConfigList, {
    touchAreas = {
      self.ui.panel_content,
      self.ui.panel_hero_list
    },
    data = {
      ladderFightData = self.param._summary._ladder_fight,
      summaryData = self.param._speaker_summary,
      totalGs = self.totalGs
    },
    handler = function(data)
      ed.pvpManager:showPvpReplay(data)
    end
  })
end

function class:refreshHeroList()
  self.heroIconList = {}
  self.ui.panel_hero_list:removeAllChildrenWithCleanup(true)
  local heroList = self.param._summary._ladder_fight._heroes
  local posX = 0
  local totalGs = 0
  local gapX = -8
  local width = self.ui.panel_hero_list:getContentSize().width
  heroList = heroList or {}
  for index = #heroList, 1, -1 do
    local heroData = heroList[index]
    local heroInfo = ed.readhero.createIconByServer(heroData)
    local heroIcon = heroInfo.icon
    heroInfo:showLegendEquip(not ed.openLegendEquip())
    heroIcon:setScale(0.75)
    totalGs = totalGs + heroData._gs
    if heroIcon then
      self.ui.panel_hero_list:addChild(heroIcon)
      ed.layout.centerYInParent(heroIcon)
      local iconWidth = heroIcon:getContentSize().width
      heroIcon:setPositionX(width - posX - 30)
      posX = posX + iconWidth + gapX
    end
  end
  self.totalGs = totalGs
  ed.setLabelString(self.ui.label_gs, string.format(T("\230\136\152\229\138\155:%s"), totalGs))
  ed.setLabelColor(self.ui.label_gs, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_gs, ed.toccc3(5586983), 1)
end

function class.touch(event, x, y)
  if event == "began" then
    class.isPress = false
    for index, buttonConfig in ipairs(class.buttonConfigList or {}) do
      for _, touchArea in ipairs(buttonConfig.touchAreas or {}) do
        if ed.containsPoint(touchArea, x, y) then
          class.isPress = true
          class.clickConfig = buttonConfig
          class.touchArea = touchArea
          break
        end
      end
    end
    if class.isPress then
      class.pxy = ccp(x, y)
    end
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), class.pxy)
    if 10 < dis then
      class.isPress = false
    end
  elseif event == "ended" and class.isPress and class.clickConfig then
    local handler = class.clickConfig.handler
    local data = class.clickConfig.data
    local touchArea = class.touchArea
    if touchArea and ed.containsPoint(touchArea, x, y) then
      handler(data)
      class.touchArea = nil
    end
  end
end

function class.clear()
  class.isPress = false
  class.buttonConfigList = {}
  class.pxy = ccp(0, 0)
  class.clickConfig = nil
end
