local class = {}
class.__index = class
ed.ui.dragonBoatPassReward = class

function class.create(params)
  local self = {}
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:registerEvents()
end

function class:initData(params)
  self.controller = params.controller
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.rewardTbl = ed.getDataTable("SimplePassReward")[self.mgr.passId] or {}
  self:refreshPassData()
  self.cellSize = CCSizeMake(76, 275)
  self.imgType = {
    NOT_REACHED = 0,
    LOCK = 0,
    AVAILABLE = 1,
    RECEIVED = 2
  }
  self.maxRank = 1
  self.items = {}
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.DragonBoatPassReward)
  self.container = container
  self.ui = ui
  local layerSize = self.ui.layer_pass_item:getContentSize()
  self.ui.layer_pass_item:setContentSize(CCSizeMake(layerSize.width * 0.95, layerSize.height))
  ed.setLabelFontName(self.ui.label_pass_title_normal, ed.fontBold)
  ed.setLabelFontName(self.ui.label_pass_title_pay, ed.fontBold)
  self:initDraglist()
end

function class:initDraglist()
  local layerSize = self.ui.layer_pass_item:getContentSize()
  local dl = ed.UITool.createDraglist(self.ui.layer_pass_item, {
    priority = -300,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList()
  })
  self.rewardList = dl
  self.controller.refreshCliprectConfig = {
    draglist = self.rewardList
  }
end

function class:refreshPage()
  local function getPos(ind)
    return ccp(self.cellSize.width * (ind - 0.5), self.ui.layer_pass_item:getContentSize().height * 0.5)
  end
  
  self.rewardList:clearList()
  self:refreshPassData()
  self:refreshBtnUnlock()
  local nextExp = self:getNextLevelExp()
  if nextExp == "max" then
    nextExp = self.exp
  end
  if not self.progressBox then
    self.progressBox = ed.taskProModule.new(self.controller.ui.progress_bar, 15)
    self.progressBox:setPro(self.exp / nextExp)
  else
    if self.level == 30 then
      self.progressBox:addPro(1)
    end
    if self.exp == 0 and self.level ~= tonumber(self.controller.ui.label_level_num:getString()) then
      self.progressBox:addPro(self.exp / nextExp, true)
    elseif self.exp ~= 0 then
      self.progressBox:addPro(self.exp / nextExp, true)
    end
  end
  ed.setLabelString(self.controller.ui.label_level_num, self.level)
  ed.setLabelString(self.controller.ui.label_exp_num, self.level == 30 and "max" or self.exp)
  ed.setLabelString(self.controller.ui.label_exp_base, "/" .. (self.level == 30 and "max" or nextExp))
  ed.right2(self.controller.ui.label_exp_num, self.controller.ui.label_exp_title, 0)
  ed.right2(self.controller.ui.label_exp_base, self.controller.ui.label_exp_num, 0)
  local setListPosX
  if self.moveIdx then
    setListPosX = self.rewardList.listLayer:getPositionX()
  end
  self.moveIdx = nil
  local rewardInfo = ed.passDataMgr:getPassRewardList(self.mgr.passId)
  local cnt = 0
  self.item = {}
  for level, rewards in pairs(self.rewardTbl) do
    local levelReward = self:createLevelRewardItem(level, rewards, rewardInfo[level])
    self.rewardList:addItem(levelReward)
    levelReward:setPosition(getPos(level))
    cnt = cnt + 1
  end
  self.rewardList:initListWidth(self.cellSize.width * cnt - 30)
  self.moveIdx = self.moveIdx and self.moveIdx ~= 0 and self.moveIdx or self.level
  self.rewardList.listLayer:stopAllActions()
  if setListPosX then
    self.rewardList.listLayer:setPositionX(setListPosX)
  elseif self.moveIdx and self.moveIdx ~= 0 and self.moveIdx <= 26 and self.moveIdx >= 5 then
    local width = self.ui.layer_pass_item:getContentSize().width
    local movex = getPos(self.moveIdx).x * -1 + width / 2
    if self.moveIdx > 10 then
      self.rewardList.listLayer:setPositionX(movex + self.cellSize.width * 5)
    end
    self.rewardList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(1.2, ccp(movex, 0))))
  elseif self.moveIdx > 26 then
    local movex = self.rewardList.listWidth * -1 + self.ui.layer_pass_item:getContentSize().width
    self.rewardList.listLayer:setPositionX(movex + self.cellSize.width * 5)
    self.rewardList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(1.2, ccp(movex, 0))))
  end
end

function class:refreshPassData()
  self.passData = ed.passDataMgr.allPassData[self.mgr.passId]
  self.rank = self.passData.rank
  self.level = self.passData.level
  self.exp = self.passData.extend._pass_exp or 0
end

function class:createLevelRewardItem(level, rewardsTbl, rewardInfo)
  local container, ui = ed.editorui(ed.uieditor.DragonBoatPassRewardItem)
  ed.setLabelString(ui.label_level, T("%s\231\186\167", level))
  ed.setLabelFontName(ui.label_level, ed.fontBold)
  ed.setLabelStroke(ui.label_level, ed.toccc3(5277696), 1.5)
  local activated = false
  for i = 1, #rewardInfo do
    local info = rewardInfo[i]
    local status = self.imgType[info.rewardState]
    local item = ed.taskItemModule.new(self, {
      id = info.rewardId,
      type = info.rewardType,
      amount = info.rewardAmount,
      info = info
    }, nil, info.rewardPos, false, false, false)
    ui["icon_" .. i]:addChild(item.icon, 9)
    item:refresh(status)
    self.items[info.rewardPos] = item
    if status == 1 then
      activated = true
    end
  end
  if activated then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/dragonboat/db_pass/db_bg_reward_activated.png",
      pos = ccp(38, 137.75),
      parent = ui.bg
    })
  end
  self.moveIdx = self.moveIdx and self.moveIdx ~= 0 and self.moveIdx or activated and level or 0
  return container, ui
end

function class:registerEvents()
end

function class:getNextLevelExp()
  return ed.lookupDataTable("SimplePass", "Level" .. self.level + 1, self.mgr.passId) or "max"
end

function class:refreshBtnUnlock()
  if self.rank == 1 or not self.container:isVisible() then
    self.controller.ui.btn_pass_unlock:setVisible(false)
  else
    self.controller.ui.btn_pass_unlock:setVisible(true)
  end
end

function class:doPressInList()
  local function handler(x, y)
    for rewardPos, v in pairs(self.items) do
      if ed.containsPoint(v.icon, x, y) then
        v.icon:setScale(0.75)
        
        return {
          icon = v.icon,
          fun = function(this)
            if this.param.state == 1 then
              local info = this.param.info
              ed.passNetWork:simplePassReq({
                passId = self.mgr.passId,
                isAllReward = false,
                rewardPos = info.rewardPos,
                rewardIndex = info.rewardIndex
              })
            else
              ed.UITool.openView("packageDetail", {
                id = this.param.id,
                type = "item"
              })
            end
          end,
          param = v,
          normalScale = 0.8
        }
      end
    end
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
