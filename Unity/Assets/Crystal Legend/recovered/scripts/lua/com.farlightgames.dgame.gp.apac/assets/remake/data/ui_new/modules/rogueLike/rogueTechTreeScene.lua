local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueTechTreeScene = class
ed.UITool.registViewOpenFunc("rogueTechTreeScene", function(param)
  local scene = ed.ui.rogueTechTreeScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueTechTreeScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.chapterId = param.chapterId or 1
  local rogueChapterCfg = ed.getDataTable("RogueChapter")[self.chapterId]
  local rogueBookCfg = ed.getDataTable("RogueBook")[self.chapterId]
  local techTreeId = rogueChapterCfg[1]["Tech Tree ID"]
  if 0 < techTreeId then
    self.techTreeId = techTreeId
  else
    self.techTreeId = 1
  end
  self.techPointIconPath = rogueBookCfg["Tech Point Icon"]
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.techData = self.rogueLikeMgr:getTechData(self.chapterId)
  self.rogueTechCfg = ed.getDataTable("RogueTech")[self.techTreeId]
  self.techIconList = {}
  self.selectTechId = 1
  self:initTreeStruct()
  self:initView()
  self:refreshTechTree()
  self:refreshTechDetail()
  self:refreshBtnLearn()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueTechTreeScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  self:initLabels()
  self:adaptUI()
  self:initDragList()
  self:refreshTechPoint()
  self:refreshGs()
  if self.techPointIconPath then
    ed.setTexture(self.ui.tech_point_icon, self.techPointIconPath)
    ed.setTexture(self.ui.cost_point_icon, self.techPointIconPath)
  end
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tech_point_amount, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_cost_point_amount, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_name, ed.toccc3(8726472), 1)
  ed.setLabelFontName(self.ui.label_name, ed.fontBold)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_learn, ed.toccc3(6643048), 1.5)
  ed.setLabelFontName(self.ui.label_learned, ed.fontBold)
  ed.setLabelStroke(self.ui.label_learned, ed.toccc3(10101944), 1.5)
  ed.setLabelFontName(self.ui.label_gs_tips, ed.fontBold)
  ed.setLabelStroke(self.ui.label_gs_tips, ed.toccc3(8726472), 1)
end

function class:initTreeStruct()
  local curLayerTech = {}
  local treeConfig = {}
  for techId, techCfg in ipairs(self.rogueTechCfg) do
    local requireTech = techCfg["Require Tech"] or {}
    treeConfig[techId] = {
      preTech = requireTech,
      nextTech = {}
    }
    if #requireTech == 0 then
      table.insert(curLayerTech, techId)
    end
    for _, requireTechId in ipairs(requireTech) do
      if treeConfig[requireTechId] then
        local nextTech = treeConfig[requireTechId].nextTech
        if not ed.isElementInTable(techId, nextTech) then
          table.insert(nextTech, techId)
        end
      end
    end
  end
  self.treeConfig = treeConfig
  self.curLayerTech = curLayerTech
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_tech_tree, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
end

function class:getPressInHandler()
  local function handler(x, y)
    for index, data in ipairs(self.techIconList) do
      local icon = data.techIcon
      
      if ed.containsPoint(icon, x, y) then
        icon:setScale(0.85)
        return data
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, data)
    self:onClickTechIcon(data)
  end
  
  return handler
end

function class:getCancelPressInHandler()
  local function handler(x, y, data)
    local icon = data.techIcon
    
    icon:setScale(0.9)
  end
  
  return handler
end

function class:refreshTechDetail()
  local techCfg = self.rogueTechCfg[self.selectTechId]
  local iconPath = string.format("UI/alpha/1080P/rogue/techtree/icon/%s.png", techCfg.Icon)
  ed.setTexture(self.ui.image_icon, iconPath)
  ed.setLabelString(self.ui.label_name, techCfg.Name)
  local cost = techCfg["Tech Point Cost"] or 0
  local techPoint = self.techData.techPoint or 0
  ed.setLabelString(self.ui.label_cost_point_amount, cost)
  ed.setLabelColor(self.ui.label_cost_point_amount, cost <= techPoint and ed.toccc3(4294966503) or ccc3(255, 113, 69))
  self.ui.panel_desc:removeAllChildrenWithCleanup(true)
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = techCfg.Description,
    fontSize = 15,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    maxWidth = panelSize.width
  })
  self.ui.panel_desc:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(panelSize.width / 2 - w / 2, panelSize.height - 7.5))
end

function class:refreshTechTree(isHoldPos)
  local panelSize = self.ui.panel_tech_tree:getContentSize()
  local listX, listY = self.dragList:getListPos()
  self.dragList:clearList()
  local curLayerTech = self.curLayerTech
  local height, gapY = 0, 135
  local targetY, targetTechId
  while 0 < #curLayerTech do
    local len = #curLayerTech
    local nextLayerTech = {}
    for index, techId in ipairs(curLayerTech) do
      local nextTech = self.treeConfig[techId].nextTech
      for _, nextTechId in ipairs(nextTech) do
        if not ed.isElementInTable(nextTechId, nextLayerTech) then
          table.insert(nextLayerTech, nextTechId)
        end
      end
      local techIcon, ui, isLearn, isUnlock = self:createTechTreeIcon(techId)
      self.dragList:addItem(techIcon)
      techIcon:setZOrder(2)
      local iconSize = techIcon:getContentSize()
      local posX = 0
      if len == 1 then
        posX = (panelSize.width - iconSize.width) / 2 + iconSize.width / 2
      else
        posX = (panelSize.width - iconSize.width) / (len - 1) * (index - 1) + iconSize.width / 2
      end
      techIcon:setPosition(ccp(posX, panelSize.height - height - iconSize.height / 2))
      self.techIconList[techId] = {
        techIcon = techIcon,
        techId = techId,
        ui = ui,
        isLearn = isLearn,
        isUnlock = isUnlock
      }
      self:createLine(techId)
      if not isLearn and isUnlock then
        targetTechId = techId
        targetY = techIcon:getPositionY()
      end
    end
    height = height + gapY
    curLayerTech = nextLayerTech
  end
  local totalHeight = height + 30
  self.dragList:initListHeight(totalHeight)
  if isHoldPos then
    self.dragList:setListPos(ccp(listX, listY))
  elseif targetY then
    local posY = panelSize.height - targetY - panelSize.height / 2
    posY = math.min(posY, totalHeight - panelSize.height)
    posY = math.max(posY, 0)
    self.dragList:setListPos(ccp(listX, posY))
    if targetTechId ~= self.selectTechId then
      self:onClickTechIcon(self.techIconList[targetTechId])
    end
  end
end

function class:createTechTreeIcon(techId)
  local container = ed.createSprite()
  local _, ui = ed.editorui(ed.uieditor.rogueTechTreeIcon, {container = container})
  local lightTechList = self.techData.lightTechList or {}
  local isLearn = ed.isElementInTable(techId, lightTechList)
  local techCfg = self.rogueTechCfg[techId]
  local iconPath = string.format("UI/alpha/1080P/rogue/techtree/icon/%s.png", techCfg.Icon)
  ed.setTexture(ui.image_icon, iconPath)
  ui.image_activated_light:setVisible(isLearn)
  ui.image_lock:setVisible(not isLearn)
  ui.image_select:setVisible(techId == self.selectTechId)
  local preTech = self.treeConfig[techId].preTech or {}
  local isUnlock = true
  for index, preTechId in ipairs(preTech) do
    if not ed.isElementInTable(preTechId, lightTechList) then
      isUnlock = false
      break
    end
  end
  if isUnlock and not isLearn then
    ui.image_activated_light:setVisible(true)
  else
    ui.image_activated_light:setVisible(false)
  end
  if isLearn then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/techtree/techtree_icon_bg1.png")
    ui.image_icon:setOpacity(255)
  else
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/techtree/techtree_icon_bg2.png")
    ui.image_icon:setOpacity(178.5)
  end
  local size = ui.image_select:getContentSize()
  container:setContentSize(size)
  ui.image_bg:setPosition(ccp(size.width / 2, size.height / 2))
  container:setScale(0.9)
  return container, ui, isLearn, isUnlock
end

function class:createLine(techId)
  local preTech = {}
  if self.treeConfig[techId] then
    preTech = self.treeConfig[techId].preTech
  end
  if not preTech or #preTech == 0 then
    return
  end
  local curNode = self.techIconList[techId].techIcon
  for index, preTechId in ipairs(preTech) do
    local preIconCfg = self.techIconList[preTechId] or {}
    local preNode = preIconCfg.techIcon
    if preNode then
      local isLearn = preIconCfg.isLearn
      local line
      if isLearn then
        line = ed.createScale9Sprite("UI/alpha/1080P/rogue/techtree/techtree_slide_1.png")
      else
        line = ed.createScale9Sprite("UI/alpha/1080P/rogue/techtree/techtree_slide_2.png")
      end
      local curPosX, curPosY = curNode:getPosition()
      local prePosX, prePosY = preNode:getPosition()
      local pos = ccp((curPosX + prePosX) / 2, (curPosY + prePosY) / 2)
      local rotation = math.atan((prePosX - curPosX) / (prePosY - curPosY)) * 57.3
      local distance = math.sqrt((prePosX - curPosX) ^ 2 + (prePosY - curPosY) ^ 2) - 92
      line:setPosition(pos)
      line:setRotation(rotation)
      line:setContentSize(CCSizeMake(line:getContentSize().width, distance))
      self.dragList:addItem(line)
      line:setZOrder(1)
    end
  end
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_tech_point_bg, {right = 10, top = 20}, false, true)
end

function class:refreshTechPoint()
  ed.setLabelString(self.ui.label_tech_point_amount, self.techData.techPoint or 0)
end

function class:refreshGs()
  local techGs = math.floor(self.rogueLikeMgr:getTechGs(self.chapterId))
  if self.gsNode then
    self.gsNode:removeFromParentAndCleanup(true)
  end
  local gsNode = ed.getNumberNodeEx({
    text = techGs or 0,
    folder = "hero_gs"
  }).node
  self.gsNode = gsNode
  self.gsNode:setScale(1.1)
  self.ui.image_total_gs_bg:addChild(gsNode)
  gsNode:setPositionX(self.ui.label_gs_tips:getContentSize().width + self.ui.label_gs_tips:getPositionX() + self.gsNode:getContentSize().width / 2)
  gsNode:setPositionY(self.ui.label_gs_tips:getPositionY())
end

function class:refreshBtnLearn()
  local curTechIconData = self.techIconList[self.selectTechId]
  local isLearn = curTechIconData.isLearn
  local isUnlock = curTechIconData.isUnlock
  if isLearn then
    self.ui.image_learned:setVisible(true)
    self.ui.btn_learn:setVisible(false)
    self.ui.image_cost_point_bg:setVisible(false)
  else
    self.ui.image_learned:setVisible(false)
    self.ui.btn_learn:setVisible(true)
    self.ui.image_cost_point_bg:setVisible(true)
    if not isUnlock then
      ed.updateSpriteStone(self.ui.btn_learn, true)
    else
      ed.updateSpriteStone(self.ui.btn_learn, false)
    end
  end
end

function class:onClickTechIcon(data)
  local techId = data.techId
  local ui = data.ui
  if techId == self.selectTechId then
    return
  end
  local curTechIconData = self.techIconList[self.selectTechId]
  if curTechIconData then
    curTechIconData.ui.image_select:setVisible(false)
  end
  self.selectTechId = techId
  ui.image_select:setVisible(true)
  self:refreshTechDetail()
  self:refreshBtnLearn()
end

function class:onClickBtnLearn()
  local techCfg = self.rogueTechCfg[self.selectTechId]
  local curTechIconData = self.techIconList[self.selectTechId]
  local isLearn = curTechIconData.isLearn
  local isUnlock = curTechIconData.isUnlock
  local cost = techCfg["Tech Point Cost"] or 0
  local techPoint = self.techData.techPoint or 0
  if isLearn then
    ed.showToast(T("\229\164\169\232\181\139\229\183\178\233\162\134\230\130\159"))
    return
  end
  if not isUnlock then
    ed.showToast(T("\233\156\128\230\191\128\230\180\187\229\137\141\231\189\174\232\138\130\231\130\185"))
    return
  end
  if cost > techPoint then
    ed.showToast(T("\229\164\169\232\181\139\231\130\185\228\184\141\232\182\179"))
    return
  end
  ed.rogueLikeNet.sendBuyTech(self.chapterId, self.selectTechId)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_learn", function()
    self:onClickBtnLearn()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("rogueBuyTech", function()
    self.techData = self.rogueLikeMgr:getTechData(self.chapterId)
    self:refreshTechPoint()
    self:refreshTechTree(true)
    self:refreshBtnLearn()
    self:refreshGs()
  end)
end
