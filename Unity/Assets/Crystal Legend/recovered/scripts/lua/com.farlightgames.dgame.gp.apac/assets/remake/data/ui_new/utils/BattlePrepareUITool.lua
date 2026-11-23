ed.BattlePrepareUITool = {}
local ClassifyListUI = newclass()
ed.BattlePrepareUITool.ClassifyListUI = ClassifyListUI

function ClassifyListUI.create(uiDelegate, param)
  local self = {}
  setmetatable(self, ClassifyListUI.mt)
  self.uiDelegate = uiDelegate
  self.curIndex = param.curIndex
  self.classifyArr = param.classifyArr
  self.clickCallback = param.callback
  self.btnUIArr = {}
  self:init()
  return self
end

function ClassifyListUI:init()
  local classifyPanel = self.uiDelegate.ui.panel_classify
  local con = classifyPanel:getContentSize()
  for i, v in ipairs(self.classifyArr) do
    local button = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png")
    local press = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png")
    local label = ed.createLabelTTF(v[2], 18)
    ed.setLabelFontInfo(label, "dark_white_stroke")
    button:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    press:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    label:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    classifyPanel:addChild(button)
    classifyPanel:addChild(press)
    classifyPanel:addChild(label)
    press:setVisible(self.curIndex == i)
    table.insert(self.btnUIArr, {
      type = v[1],
      press = press,
      label = label,
      button = button
    })
    local touchKey = "TeamClassify_" .. i
    self.uiDelegate:btRemoveMainTouchHandler({key = touchKey})
    self.uiDelegate:btRegisterButtonClick({
      button = button,
      key = touchKey,
      param = {index = i},
      clickHandler = function(param)
        if self.curIndex ~= param.index then
          self:refresh(param.index)
          self.clickCallback(param.index, self.btnUIArr[param.index].type)
        end
      end,
      force = true,
      pressScale = 0.95,
      normalScale = 1
    })
  end
end

function ClassifyListUI:refresh(index)
  self.curIndex = index
  for i, v in ipairs(self.btnUIArr) do
    v.press:setVisible(self.curIndex == i)
  end
end

local TeamIdxListUI = newclass()
ed.BattlePrepareUITool.TeamIdxListUI = TeamIdxListUI

function TeamIdxListUI.create(uiDelegate, param)
  local self = {}
  setmetatable(self, TeamIdxListUI.mt)
  self.uiDelegate = uiDelegate
  self.curIndex = param.curIndex
  self.teamCount = param.teamCount
  self.createCallback = param.createCallback
  self.clickCallback = param.clickCallback
  self.btnUIArr = {}
  self:init()
  return self
end

function TeamIdxListUI:init()
  local teamPanel = self.uiDelegate.ui.panel_team
  local contentSize = teamPanel:getContentSize()
  local itemHeight
  local itemSpace = 4
  
  local function getPos(i)
    local ox = contentSize.width / 2
    local oy = contentSize.height
    local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
    return ccp(ox, dy)
  end
  
  local function getHeight(num)
    return (itemHeight + itemSpace) * num - itemSpace
  end
  
  self.draglist = ed.UITool.createDraglist(teamPanel, {priority = -300})
  local teamNum = 0
  for i = 1, self.teamCount do
    local itemContainer, itemUI = self.createCallback(i)
    itemHeight = itemContainer:getContentSize().height
    self.draglist:addItem(itemContainer)
    table.insert(self.btnUIArr, itemUI)
    itemContainer:setPosition(getPos(i))
    teamNum = teamNum + 1
    itemUI.press:setVisible(self.curIndex == i)
    local touchKey = "TeamIdx_" .. i
    self.uiDelegate:btRemoveMainTouchHandler({key = touchKey})
    self.uiDelegate:btRegisterButtonClick({
      button = itemUI.button,
      key = touchKey,
      param = {index = i},
      extraCheckHandler = function(x, y)
        return ed.containsPoint(teamPanel, x, y)
      end,
      clickHandler = function(param)
        if self.curIndex ~= param.index then
          self:refresh(param.index)
          self.clickCallback(param.index)
        end
      end,
      force = true,
      pressScale = 0.95,
      normalScale = 1
    })
  end
  self.draglist:initListHeight(getHeight(teamNum))
end

function TeamIdxListUI:refresh(index)
  self.curIndex = index
  local targetY, isTop
  local oldPosX, oldPosY = self.draglist:getListPos()
  for i, v in ipairs(self.btnUIArr) do
    if self.curIndex == i then
      v.press:setVisible(true)
      local posY = v.container:getPositionY()
      if oldPosY < -posY then
        isTop = false
        targetY = posY - v.container:getContentSize().height * 0.5
      elseif oldPosY - self.draglist.height > -posY then
        isTop = true
        targetY = posY + v.container:getContentSize().height * 0.5
      end
    else
      v.press:setVisible(false)
    end
  end
  if nil ~= targetY then
    local listY = -targetY + (isTop and self.draglist.height or 0)
    listY = math.max(listY, 0)
    listY = math.min(listY, self.draglist.listHeight - self.draglist.height)
    self.draglist:reset()
    self.draglist:setListPos(ccp(0, listY))
  end
end

local HeroListUI = newclass()
ed.BattlePrepareUITool.HeroListUI = HeroListUI

function HeroListUI.create(uiDelegate, param)
  local self = {}
  setmetatable(self, HeroListUI.mt)
  self.uiDelegate = uiDelegate
  self.heroArr = param.heroArr
  self.filterCallback = param.filterCallback
  self.refreshCallback = param.refreshCallback
  self.clickCallback = param.clickCallback
  self.heroUITab = {}
  self:init()
  return self
end

function HeroListUI:init()
  local heroPanel = self.uiDelegate.ui.panel_hero
  self.draglist = ed.UITool.createDraglist(heroPanel, {
    priority = -300,
    cancelClickIn = function(x, y, hero)
      if hero then
        hero.icon:setScale(1)
        self.iCancelClick = false
      end
    end,
    doPressIn = function(x, y)
      for _, v in pairs(self.heroUITab or {}) do
        if v.icon:isVisible() and ed.containsPoint(v.icon, x, y) then
          self.iCancelClick = true
          v.icon:setScale(0.95)
          return v
        end
      end
    end,
    cancelPressIn = function(x, y, hero)
      if hero and self.iCancelClick then
        hero.icon:setScale(1)
        if not self.touchDisable then
          self.touchDisable = true
          self.uiDelegate:listenTimer(Timer:Once(0.3), function()
            self.touchDisable = nil
          end)
          self.clickCallback(hero)
        end
      end
    end
  })
  self.listContainer = CCSprite:create()
  self.listContainer:setCascadeOpacityEnabled(true)
  self.listContainer:setAnchorPoint(ccp(0, 0))
  self.listContainer:setPosition(ccp(0, 0))
  self.draglist:addItem(self.listContainer)
  self:refreshHeroList()
end

function HeroListUI:refreshHeroList()
  local teamPanel = self.uiDelegate.ui.panel_hero
  local contentSize = teamPanel:getContentSize()
  local itemSize = 90
  local itemSpace = 0
  local columnNum = math.floor(contentSize.width / (itemSize + itemSpace))
  local startX = (contentSize.width - ((itemSize + itemSpace) * columnNum - itemSpace)) * 0.5
  local startY = contentSize.height
  local topMargin = 2
  local bottomMargin = 2
  
  local function getPos(i)
    local columnIndex = (i - 1) % columnNum + 1
    local rowIndex = math.floor((i - columnIndex) / columnNum + 0.5) + 1
    local dx = startX + (columnIndex - 0.5) * itemSize + (columnIndex - 1) * itemSpace
    local dy = startY - topMargin - (rowIndex - 0.5) * itemSize - (rowIndex - 1) * itemSpace
    return ccp(dx, dy)
  end
  
  local function getHeight(num)
    local rowNum = math.ceil(num / columnNum)
    return (itemSize + itemSpace) * rowNum - itemSpace + topMargin + bottomMargin
  end
  
  local tmpTab = {}
  for k, v in pairs(self.heroUITab) do
    tmpTab[k] = v
  end
  local itemIndex = 0
  for i, v in ipairs(self.heroArr) do
    if self.filterCallback(v) then
      local heroUI = tmpTab[i]
      tmpTab[i] = nil
      if nil == heroUI then
        heroUI = ed.readhero.createIconByID(v._tid, {
          state = "idle",
          isShowLegendEquip = ed.openLegendEquip()
        })
        self.listContainer:addChild(heroUI.icon)
        self.draglist:setFrameRect(heroUI.icon, heroUI.icon:getTextureRect())
        self.draglist:setParentClipNode(heroUI.icon, self.draglist.listLayer)
        self.heroUITab[i] = heroUI
      end
      heroUI.icon:setVisible(true)
      self.refreshCallback(heroUI)
      itemIndex = itemIndex + 1
      heroUI.icon:setPosition(getPos(itemIndex))
    end
  end
  self.draglist:initListHeight(getHeight(itemIndex))
  for _, heroUI in pairs(tmpTab) do
    heroUI.icon:setVisible(false)
  end
end

function HeroListUI:refreshHeroUI()
  for _, heroUI in pairs(self.heroUITab) do
    if heroUI.icon:isVisible() then
      self.refreshCallback(heroUI)
      heroUI:showLegendEquip(ed.off_legendEquipOp)
    end
  end
end

function HeroListUI:getHeroIconPos(id)
  for _, heroUI in pairs(self.heroUITab) do
    if heroUI.info.id == id then
      return heroUI.icon:getParent():convertToWorldSpace(ccp(heroUI.icon:getPosition()))
    end
  end
  return ccp(0, 0)
end
