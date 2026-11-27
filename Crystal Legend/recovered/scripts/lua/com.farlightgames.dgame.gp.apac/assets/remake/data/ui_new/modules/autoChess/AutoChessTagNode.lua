module("ed.ui", package.seeall)
local base = ed.ui.popwindow
local class = newclass(base.mt)
AutoChessTagNode = class

function class:initData()
  self.teamTags = {}
  self.allTags = {}
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessTagNode, {
    container = self.container,
    ui = self.ui
  })
  self.ui.bg_item:setVisible(false)
end

function class:loadTag(index)
  if index < 1 then
    return
  end
  if index > #self.allTags then
    return
  end
  local tagData = self.allTags[index]
  local tag = tagData.tag
  local num = tagData.num
  local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
  local level = 0
  for i, config in ipairs(tagConfig) do
    if num >= config.min and num <= config.max then
      level = config.level
      break
    end
  end
  local target = #tagConfig
  local tagNode, ui = ed.ui.AutoChessUITool.createTagNode(tag, num, level, target)
  local data = {icon = tagNode, ui = ui}
  return tagNode, data
end

function class:setTagTableDelegate()
  local delegate = {}
  
  function delegate.numberOfCells()
    return #self.allTags
  end
  
  function delegate.cellSizeFromIndex(idx)
    return CCSizeMake(45, 50)
  end
  
  function delegate.createCell(idx)
    local node, data = self:loadTag(idx)
    return node, data
  end
  
  function delegate.syncCell(cell, idx)
    local node, data = self:loadTag(idx)
    return node, data
  end
  
  function delegate.doClickIn(cell)
    if self.ui.bg_item:isVisible() then
      local idx = cell.idx
      local data = cell.data
      self:handlerClickListTag(idx, data)
    end
  end
  
  return delegate
end

function class:createTagTableView()
  self.delegate = self:setTagTableDelegate()
  local tagSize = self.ui.layer_item:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 0, tagSize.width, tagSize.height),
    dragMode = 1,
    colNum = 5,
    zorder = 999,
    touchpriority = -300
  }
  self.tagListView = Tableview.create(param)
end

function class:handlerClickTeamTag(i)
  local teamTag = self.teamTags[i]
  if teamTag then
    local isGuideFlag, nextFlag = ed.AutoChessTeachManager:checkGuideStep({type = "tag", index = i})
    if isGuideFlag then
      if not nextFlag then
        return
      else
        ed.AutoChessTeachManager:updateStep(nextFlag)
        FireEvent("EventGuideStartTimer")
      end
    end
    self:removeTagDetail()
    self.tagDetail = ed.ui.AutoChessTagPanel.createDetailTagPanel(teamTag.tagIcon, teamTag.tagData, ccp(135, 2))
  end
end

function class:handlerClickListTagPanel()
  local tagVisible = self.ui.bg_item:isVisible()
  self.ui.Panel_tag_icon:setVisible(tagVisible)
  self.ui.bg_item:setVisible(not tagVisible)
  self.ui.icon_close:setVisible(tagVisible)
  self.ui.icon_open:setVisible(not tagVisible)
end

function class:registerBtnEvents()
  self:btRegisterHandler({
    key = "autochess_tag_touch_rect",
    handler = function(event, x, y)
      if event == "began" then
        if self.ui.Panel_tag_icon:isVisible() then
          for i, v in ipairs(self.teamTags) do
            if ed.containsPoint(v.ui.icon, x, y) then
              v.isPress = true
              return true
            end
          end
        end
      elseif event == "ended" then
        for i, v in ipairs(self.teamTags) do
          if ed.containsPoint(v.ui.icon, x, y) and v.isPress then
            self:handlerClickTeamTag(i)
            v.isPress = false
            break
          end
        end
      end
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_op,
    key = "chess_tag_click",
    clickHandler = function()
      FireEvent("AutoChessClickTagPanel")
      self:handlerClickListTagPanel()
    end,
    force = true,
    mcpMode = true
  })
end

function class:registerNetEvents()
  self:listenEvent("EventChessPlayerDead", function()
    self:updateTeamTag()
  end)
  self:listenEvent("EventChessUpdateTag", function()
    self:updateTeamTag()
  end)
  self:listenEvent("AutoChessTagPanelClose", function()
    self.tagDetail = nil
  end)
  self:listenEvent("AutoChessClickDamage", function()
    self.ui.Panel_tag_icon:setVisible(true)
    self.ui.bg_item:setVisible(false)
    self.ui.icon_close:setVisible(true)
    self.ui.icon_open:setVisible(false)
  end)
  self:listenEvent("AutoChessClickStickerPanel", function()
    self.ui.Panel_tag_icon:setVisible(true)
    self.ui.bg_item:setVisible(false)
    self.ui.icon_close:setVisible(true)
    self.ui.icon_open:setVisible(false)
  end)
  self:listenEvent("EventDestroyTagPanel", function()
    self:destroy()
  end)
end

function class:registerEvents()
  self:registerBtnEvents()
  self:registerNetEvents()
end

function class:onEnter()
  self:createTagTableView()
  self:registerEvents()
  self:updateTeamTag()
end

function class:handlerClickListTag(index, data)
  local tagItem = self.allTags[index]
  if tagItem then
    self:removeTagDetail()
    self.tagDetail = ed.ui.AutoChessTagPanel.createDetailTagPanel(data.icon, tagItem, ccp(135, 2))
  end
end

function class.create()
  local self = base.create("AutoChessTagNode", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerOnEnterHandler("auto_chess_tag", function()
    self:onEnter()
  end)
  return self
end

function class:updateTeamTag()
  self.ui.Panel_tag_icon:removeAllChildrenWithCleanup(true)
  self.teamTags = {}
  self.allTags = {}
  local tagData = ed.engine:getChessTagData(ed.emCampPlayer)
  local raceTags = tagData.race
  local offset = 0
  for tag, num in pairs(raceTags) do
    local level = 0
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    for i, config in ipairs(tagConfig) do
      if num >= config.min and num <= config.max then
        level = config.level
        break
      end
    end
    table.insert(self.allTags, {
      tag = tag,
      num = num,
      level = level
    })
    if 0 < level then
      local target = #tagConfig
      local tagNode, ui = ed.ui.AutoChessUITool.createTagNode(tag, num, level, target)
      tagNode:setPosition(offset, -15)
      self.ui.Panel_tag_icon:addChild(tagNode)
      table.insert(self.teamTags, {
        tagIcon = tagNode,
        ui = ui,
        tagData = {
          tag = tag,
          num = num,
          level = level,
          target = target
        }
      })
      offset = offset + 45
    end
  end
  local abilityTags = tagData.ability
  for tag, num in pairs(abilityTags) do
    local level = 0
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    for i, config in ipairs(tagConfig) do
      if num >= config.min and num <= config.max then
        level = config.level
        break
      end
    end
    table.insert(self.allTags, {
      tag = tag,
      num = num,
      level = level
    })
    if 0 < level then
      local target = #tagConfig
      local tagNode, ui = ed.ui.AutoChessUITool.createTagNode(tag, num, level, target)
      tagNode:setPosition(offset, -15)
      self.ui.Panel_tag_icon:addChild(tagNode)
      table.insert(self.teamTags, {
        tagIcon = tagNode,
        ui = ui,
        tagData = {
          tag = tag,
          num = num,
          level = level,
          target = target
        }
      })
      offset = offset + 45
    end
  end
  if self.tagListView then
    self.tagListView:staticSync()
    self.tagListView:setContentOffset()
  end
end

function class:removeTagDetail()
  if self.tagDetail then
    self.tagDetail:closeSelf()
  end
end

function class:destroy(param)
  self:removeOnEnterHandler("auto_chess_tag")
  base.destroy(self, param)
end
