local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueCharmShowWindow = class
local CardScale = 0.8
local CardWidth = 106 * CardScale
local CardHeight = 141.5 * CardScale
local CardSpaceX = 16.5
local CardSpaceY = 13
local TopPadding = 2
local threshold = 0.001
ed.UITool.registViewOpenFunc("rogueCharmShowWindow", function()
  ed.ui.rogueCharmShowWindow.create():popWindow()
end)

function class.create()
  local self = base.create("rogueCharmShowWindow")
  setmetatable(self, class.mt)
  self:init()
  self:show()
  return self
end

function class:init()
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.curSelectedIndex = 1
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.charmHeartImgArr = {}
  self.charmHeartSpaceArr = {}
  for i = 1, 999 do
    local img = self.ui["img_charm_heart_" .. i]
    if nil == img then
      break
    end
    table.insert(self.charmHeartImgArr, img)
    table.insert(self.charmHeartSpaceArr, 5)
  end
  local curChapter = self.rogueLikeMgr:getCurChapter()
  self.charmList = curChapter._charm_list or {}
  self.curWeightVal = 0
  self.maxWeightVal = curChapter._max_weight
  local isEmpty = 0 == #self.charmList
  if not isEmpty then
    self:refreshCharmList()
    self:refreshCharmInfo()
  end
  self.ui.panel_charm:setVisible(not isEmpty)
  self.ui.img_empty:setVisible(isEmpty)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCharmShowWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_charm_name, ed.toccc3(4267185), 1)
  ed.setLabelFontName(self.ui.label_charm_name, ed.fontBold)
  ed.setLabelStroke(self.ui.label_charm_weight, ed.toccc3(263719), 1)
  ed.setLabelFontName(self.ui.label_empty, ed.fontBold)
  ed.setLabelStroke(self.ui.label_empty, ed.toccc3(3350142), 1)
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function class:addEventListener()
end

function class:getCharmListItemPos(i)
  local size = self.ui.panel_charm_list:getContentSize()
  local ox = (size.width - ((CardWidth + CardSpaceX) * 4 - CardSpaceX)) * 0.5
  local oy = size.height
  local columnIndex = (i - 1) % 4 + 1
  local rowIndex = math.ceil(i / 4 - threshold)
  local dx = ox + (columnIndex - 0.5) * CardWidth + (columnIndex - 1) * CardSpaceX
  local dy = oy - (rowIndex - 0.5) * CardHeight - (rowIndex - 1) * CardSpaceY - TopPadding
  return ccp(dx, dy)
end

function class:getCharmListHeight(num)
  local rowNum = math.ceil(num / 4 - threshold)
  return (CardHeight + CardSpaceY) * rowNum - CardSpaceY + TopPadding
end

function class:createCharmItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.rogueCharmBagCardItem)
  ui.bg:setScale(0.8)
  ui.img_mask:setVisible(false)
  ed.setTexture(ui.bg, "UI/alpha/1080P/rogue/charm/charm_normal_bg.png")
  ed.setLabelStroke(ui.label_weight, ed.toccc3(263719), 1)
  ui.heartImgArr = {}
  ui.heartSpaceArr = {}
  for i = 1, 999 do
    local img = ui["img_heart_" .. i]
    if nil == img then
      break
    end
    table.insert(ui.heartImgArr, img)
    table.insert(ui.heartSpaceArr, 5)
  end
  ui.img_selected = ed.createSprite("UI/alpha/1080P/rogue/charm/charm_light_frame.png")
  ui.bg:addChild(ui.img_selected)
  local bgSize = ui.bg:getContentSize()
  ui.img_selected:setPosition(bgSize.width * 0.5, bgSize.height * 0.5)
  self:refreshCharmItem(ui, data)
  return container, ui
end

function class:refreshCharmItem(ui, data)
  local charmTableItem = ed.getDataTable("RogueCharm")[data._id]
  ed.setTexture(ui.img_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  ed.setLabelString(ui.label_weight, charmTableItem.Weight)
  local starNum = self.rogueLikeMgr:getCharmStarNum(data._exp, charmTableItem)
  for i, v in ipairs(ui.heartImgArr) do
    v:setVisible(i <= starNum)
  end
  ed.layout.horizontalSortNode(ui.heartImgArr, ui.heartSpaceArr, ui.bg:getContentSize().width * 0.5)
  self.curWeightVal = self.curWeightVal + charmTableItem.Weight
end

function class:getPressInHandler()
  local function handler(x, y)
    for k, v in ipairs(self.charmUIArr) do
      if not tolua.isnull(v.bg) and ed.containsPoint(v.bg, x, y) then
        v.bg:setScale(0.95 * CardScale)
        
        return v, k
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, ui, index)
    if self.curSelectedIndex == index then
      return
    end
    self.curSelectedIndex = index
    self:refreshCharmInfo()
  end
  
  return handler
end

function class:getCancelPressInHandler()
  local function handler(x, y, ui)
    if ui and not tolua.isnull(ui.bg) then
      ui.bg:setScale(1 * CardScale)
    end
  end
  
  return handler
end

function class:refreshCharmList()
  if nil == self.charmDraglist then
    local contentSize = self.ui.panel_charm_list:getContentSize()
    self.charmDraglist = ed.UITool.createDraglist(self.ui.panel_charm_list, {
      priority = -300,
      doPressIn = self:getPressInHandler(),
      doClickIn = self:getClickInHandler(),
      cancelPressIn = self:getCancelPressInHandler(),
      bar = {
        bglen = contentSize.height - 100,
        bgpos = ccp(contentSize.width + 20, contentSize.height / 2 + 50),
        barres = "UI/alpha/1080P/rogue/charm/charm_slide_1.png",
        bgres = "UI/alpha/1080P/rogue/charm/charm_slide_2.png"
      }
    })
    self.refreshCliprectConfig = {
      draglist = self.charmDraglist
    }
  else
    self.charmDraglist:clearList()
  end
  self.charmUIArr = {}
  for k, v in pairs(self.charmList) do
    local itemContainer, itemUI = self:createCharmItem(k, v)
    self.charmDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getCharmListItemPos(k))
    table.insert(self.charmUIArr, itemUI)
  end
  self.charmDraglist:initListHeight(self:getCharmListHeight(#self.charmUIArr))
  if nil == self.bagWeightDesLabel then
    self.bagWeightDesLabel = ed.ui.autoText.new()
    self.ui.panel_weight:addChild(self.bagWeightDesLabel.node)
  end
  local weightStr = T("<lable color=ccc3(255,231,170) strokeSize=1 strokeColor=0x040627>\232\180\159\233\135\141</lable><lable color=ccc3(255,252,231) strokeSize=1 strokeColor=0x3f2389>%d/</lable><lable color=ccc3(255,231,170) strokeSize=1 strokeColor=0x040627>%d</lable>", self.curWeightVal, self.maxWeightVal)
  local weightPanelSize = self.ui.panel_weight:getContentSize()
  self.bagWeightDesLabel:initParam({
    context = weightStr,
    maxWidth = weightPanelSize.width,
    fontSize = 12
  })
  local desWidth, desHeight = self.bagWeightDesLabel:getCurContentSize()
  self.bagWeightDesLabel.node:setPosition(ccp((weightPanelSize.width - desWidth) * 0.5, (weightPanelSize.height + desHeight - self.bagWeightDesLabel:getFirstLineHeight()) * 0.5))
end

function class:refreshCharmInfo()
  local charmData = self.charmList[self.curSelectedIndex]
  local charmTableItem = ed.getDataTable("RogueCharm")[charmData._id]
  ed.setLabelString(self.ui.label_charm_name, charmTableItem["Charm Name"])
  ed.setLabelString(self.ui.label_charm_weight, T("\233\135\141\233\135\143\239\188\154%s", charmTableItem.Weight))
  ed.setTexture(self.ui.img_charm_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  local starNum = self.rogueLikeMgr:getCharmStarNum(charmData._exp, charmTableItem)
  for i, v in ipairs(self.charmHeartImgArr) do
    v:setVisible(i <= starNum)
  end
  ed.layout.horizontalSortNode(self.charmHeartImgArr, self.charmHeartSpaceArr, self.ui.img_charm_icon:getPositionX())
  if nil == self.charmDesLabel then
    self.charmDesLabel = ed.ui.autoText.new()
    if nil == self.charmDesDraglist then
      self.charmDesDraglist = ed.UITool.createDraglist(self.ui.panel_charm_des, {})
    end
    self.charmDesDraglist:addItem(self.charmDesLabel.node)
  end
  local charmDesStr = charmTableItem["Description " .. starNum] or ""
  local desBgSize = self.ui.panel_charm_des:getContentSize()
  self.charmDesLabel:initParam({
    context = charmDesStr,
    fontSize = 15,
    color = ccc3(249, 249, 235),
    maxWidth = desBgSize.width
  })
  local desWidth, desHeight = self.charmDesLabel:getCurContentSize()
  self.charmDesLabel.node:setPosition(ccp((desBgSize.width - desWidth) * 0.5, desBgSize.height - self.charmDesLabel:getFirstLineHeight() * 0.5))
  self.charmDesDraglist:initListHeight(desHeight)
  for i, v in ipairs(self.charmUIArr) do
    v.img_selected:setVisible(i == self.curSelectedIndex)
  end
end
