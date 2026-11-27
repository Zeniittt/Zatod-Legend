local base = ed.ui.popwindow
local CupArenaTimelineWin = newclass(base.mt)
ed.ui.CupArenaTimelineWin = CupArenaTimelineWin

function CupArenaTimelineWin.create(data)
  local self = base.create("CupArenaTimelineWin")
  setmetatable(self, CupArenaTimelineWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:playShowAction()
  return self
end

function CupArenaTimelineWin:initData(data)
  self.timestamps = data._timestamps or {}
end

function CupArenaTimelineWin:initUI()
  ed.editorui(ed.uieditor.CupArenaTimelineWin, {
    container = self.container,
    ui = self.ui
  })
  if nil == self.ui.titleLabel then
    local titleLabel = ed.ui.gradientLabel.create({
      text = T("\230\151\182\233\151\180\232\161\168"),
      fontSize = 30,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16763750),
      endColor = ed.toccc3(16646006),
      strokeSize = 1.5,
      strokeColor = ed.toccc3(5850931)
    }).node
    self.ui.bg_des:addChild(titleLabel)
    self.ui.titleLabel = titleLabel
    local bgSize = self.ui.bg_des:getContentSize()
    titleLabel:setPosition(ccp(bgSize.width * 0.5, bgSize.height * 0.5))
  end
  local bottomLightFca = ed.createFcaNode("eff_UI_Main_Cuparena_vortex")
  self.ui.bg:addChild(bottomLightFca, 0)
  self:addFca(bottomLightFca)
  bottomLightFca:setPosition(ccp(468, 270))
  local hourFca = ed.createFcaNode("eff_UI_Main_Cuparena_hour")
  self.ui.bg:addChild(hourFca, 0)
  self:addFca(hourFca)
  hourFca:setPosition(ccp(168, 218))
  self.ui.panel_timeline:setZOrder(1)
end

function CupArenaTimelineWin:playShowAction()
  self.ui.bg:setScale(0.6)
  local scaleAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.1, 1.06), CCEaseOut:create(CCScaleTo:create(0.2, 1), 2))
  local fadeAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.05), CCCallFunc:create(function()
    self.ui.bg_des:setVisible(true)
    self:refreshDraglist()
  end))
  self.ui.bg:runAction(CCSpawn:create(ccArrayMake(scaleAction, fadeAction)))
  self.ui.btn_close:setOpacity(0)
  self.ui.btn_close:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.35), CCFadeIn:create(0.3)))
end

function CupArenaTimelineWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({
      callback = function()
        self:removeUpdateHandler("refresh_draglist")
      end
    })
  end, {pressScale = 0.95})
end

function CupArenaTimelineWin:registerEvents()
  self:registerUpdateHandler("refresh_draglist", function()
    if self.ui.timelineDraglist and self.ui.tipsDraglist then
      self.ui.tipsDraglist:setListPos(ccp(self.ui.timelineDraglist:getListPos()))
    end
  end)
end

function CupArenaTimelineWin:createTimelineItem(index, isCurrent, tableItem)
  local container, ui = ed.editorui(isCurrent and ed.uieditor.CupArenaTimelineCurItem or ed.uieditor.CupArenaTimelineItem)
  container:setContentSize(ui.bg:getContentSize())
  ed.setLabelStroke(ui.label_time, ed.toccc3(isCurrent and 5191198 or 2039345), 1)
  ed.setLabelStroke(ui.label_des, ed.toccc3(isCurrent and 5189395 or 2039345), 1)
  local ts = self.timestamps[index] or ed.getServerTime()
  local dateStr = os.date([[
%Y-%m-%d
%H:%M]], ed.time2China(ts))
  ed.setLabelString(ui.label_time, dateStr)
  ed.setLabelString(ui.label_des, tableItem.Name)
  return container, ui
end

function CupArenaTimelineWin:refreshDraglist()
  if nil == self.ui.timelineDraglist then
    self.ui.timelineDraglist = ed.UITool.createDraglist(self.ui.panel_timeline, {priority = -300, zorder = -1})
    self.ui.tipsDraglist = ed.UITool.createDraglist(self.ui.panel_timeline, {priority = -300, zorder = 999})
    self.ui.tipsDraglist:setTouchEnabled(false)
  else
    self.ui.timelineDraglist:clearList()
    self.ui.tipsDraglist:clearList()
  end
  local curIndex = 1
  local curTime = ed.getServerTime()
  for i = #self.timestamps, 1, -1 do
    if curTime >= self.timestamps[i] then
      curIndex = i
      break
    end
  end
  local totalHeight = 0
  local targetY = 0
  local spaceY = 2
  local contentSize = self.ui.panel_timeline:getContentSize()
  local scheduleTable = ed.getDataTable("CupArenaSchedule")
  local scheduleIndex = 1
  local actionUIArr = {}
  for i = 1, 9999 do
    local tableItem = scheduleTable[i]
    if nil == tableItem then
      break
    end
    if tableItem["Show To Player"] then
      local isCurrent = curIndex == scheduleIndex
      local container, ui = self:createTimelineItem(scheduleIndex, isCurrent, tableItem)
      self.ui.timelineDraglist:addItem(container)
      local itemHeight = container:getContentSize().height
      totalHeight = totalHeight + spaceY
      container:setPosition(ccp(contentSize.width * 0.5, contentSize.height - totalHeight - itemHeight * 0.5))
      if isCurrent then
        targetY = container:getPositionY()
      end
      totalHeight = totalHeight + itemHeight
      spaceY = 5
      scheduleIndex = scheduleIndex + 1
      local tipsImg = ui.img_tips
      ui.img_tips = nil
      local tipsPos = tipsImg:getParent():convertToWorldSpace(ccp(tipsImg:getPosition()))
      tipsImg:removeFromParentAndCleanup(false)
      self.ui.tipsDraglist:addItem(tipsImg)
      tipsImg:setPosition(tipsImg:getParent():convertToNodeSpace(tipsPos))
      table.insert(actionUIArr, {ui = ui, tipsImg = tipsImg})
    end
  end
  local removeNum = math.min(curIndex - 3, #actionUIArr - 5)
  for removeIndex = 1, removeNum do
    table.remove(actionUIArr, 1)
  end
  for i, v in ipairs(actionUIArr) do
    v.ui.bg:setCascadeOpacityEnabled(true)
    v.ui.bg:setOpacity(0)
    v.ui.bg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create((i - 1) * 0.07), CCFadeIn:create(0.25)))
    v.tipsImg:setOpacity(0)
    v.tipsImg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create((i - 1) * 0.07), CCFadeIn:create(0.25)))
  end
  self.ui.timelineDraglist:initListHeight(totalHeight)
  self.ui.tipsDraglist:initListHeight(totalHeight)
  if targetY then
    local listY = -targetY + contentSize.height / 2
    listY = math.max(listY, 0)
    listY = math.min(listY, totalHeight - contentSize.height)
    self.ui.timelineDraglist:setListPos(ccp(0, listY))
    self.ui.tipsDraglist:setListPos(ccp(0, listY))
  end
end
