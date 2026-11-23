local base = ed.ui.popwindow
local psssPageBuyLevel = newclass(base.mt)
ed.UITool.registViewOpenFunc("psssPageBuyLevel", function(param)
  param = {diamond = 50, level = 1}
  psssPageBuyLevel.create(param or {}):popWindow()
end)

function psssPageBuyLevel.create(param)
  return setmetatable(base.create("psssPageBuyLevel"), psssPageBuyLevel.mt):init(param or {})
end

function psssPageBuyLevel:init(param)
  self.dataObj = ed.taskData:getPageDataObj("pass")
  self.param = param
  self.param.levelMax = self.dataObj:getMaxLevel() - self.dataObj.passData.level
  self:uiCreate()
  self:uiRefresh()
  self:registerBtnEvents()
  self:show({skipAnim = false})
  return self
end

function psssPageBuyLevel:uiCreate()
  self.frame, self.ui = ed.editorui(ed.uieditor.buyPassLvBoxWindow)
  self.container:addChild(self.frame)
  self.frame:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  ed.setLabelStroke(self.ui.title_text, ccc3(ed.colorToStr("#2e161a")), 1)
  ed.setLabelStroke(self.ui.input_label, ccc3(ed.colorToStr("#2e161a")), 1)
  ed.setLabelStroke(self.ui.cost_value, ccc3(ed.colorToStr("#2e161a")), 1)
  self.ui.line:getParent():setScale(0.5)
  self.ui.line:setScaleX(-1)
  self.thisCon = self.ui.conent_bg:getContentSize()
  local info = {
    cliprect = CCRectMake(3, 0, self.thisCon.width - 6, self.thisCon.height),
    container = self.ui.conent_bg,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return x
    end,
    cancelPressIn = function(x, y, oldx)
      self.touch = math.abs(oldx - x) < 50
    end
  }
  self.draglist = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
end

function psssPageBuyLevel:uiRefresh()
  self.ui.input_label:setString(self.param.level)
  self.ui.cost_value:setString(self.param.level * self.param.diamond)
  self.canBuy = self.param.level * self.param.diamond <= ed.player:getPoint("diamond")
  self.ui.cost_value:setColor(ed.toccc3(self.canBuy and 16776423 or 16712202))
  if not self.oldlv or self.oldlv ~= self.param.level then
    local list = self.draglist:getList()
    local listPosx, listPosy = list:getPosition()
    self.draglist:clearList()
    local items = self.dataObj:getReceiveAllItems(self.dataObj.passData.level + self.param.level)
    local itemWidth = 70
    for i, v in ipairs(ed.overlapping(items)) do
      self.draglist:addItem(self:registerBtnEventsItems(ed.createItemIcon(v, false, 0.8), "psssPageBuyLevel_item_" .. i, v, self.ui.conent_bg), ccp(i * itemWidth - itemWidth / 2 + 3, self.thisCon.height / 2))
    end
    self.draglist:initListWidth(#self.draglist.listItems * itemWidth + 6)
    if self.draglist.listWidth + 35 >= self.thisCon.width then
      self.draglist:setListPos(ccp(listPosx, listPosy))
      self.draglist.listLayer:stopAllActions()
      self.draglist.listLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.5), CCEaseExponentialOut:create(CCMoveTo:create(2, ccp((self.draglist.listWidth - self.thisCon.width + 10) * -1, self.draglist.listLayer:getPositionY()))))))
      self.ui.conent_bg:setContentSize(CCSizeMake(450, 87))
    else
      self.draglist.listLayer:setPositionX(45)
      self.ui.conent_bg:setContentSize(CCSizeMake(#self.draglist.listItems * itemWidth + 100, 87))
    end
  end
  self.oldlv = self.param.level
end

function psssPageBuyLevel:registerBtnEventsItems(node, key, param, list_node)
  self:btRemoveMainTouchHandler({key = key})
  self:btRegisterButtonClick({
    button = node,
    key = key,
    param = param,
    clickHandler = function(param, x, y)
      if not ed.containsPoint(list_node, x, y) then
        return
      end
      if self.touch then
        ed.ui.packageDetailWin.create(param):popWindow()
      end
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  return node
end

function psssPageBuyLevel:registerBtnEvents()
  local index = 1
  
  local function func(node, click, press, normal)
    self:btRegisterButtonClick({
      button = node,
      key = "psssPageBuyLevel_" .. index,
      clickHandler = click,
      force = true,
      clickInterval = 0.1,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_buy, function()
    if not self.canBuy then
      ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\129"))
      return
    end
    local taskBu = {
      {
        can = ed.getServerTime() >= self.dataObj.passData.exp_end_time,
        str = T("\232\175\165\230\156\159\230\136\152\232\175\129\229\183\178\231\187\147\230\157\159\239\188\140\230\151\160\230\179\149\233\128\154\232\191\135\230\151\165\229\184\184\228\187\187\229\138\161\232\142\183\229\143\150\230\136\152\232\175\129\231\187\143\233\170\140\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\232\180\173\228\185\176\239\188\159")
      },
      {
        can = true,
        str = T("\228\189\160\229\176\134\232\180\173\228\185\176%d\231\186\167\230\136\152\232\175\129\231\173\137\231\186\167\239\188\140\232\175\183\230\179\168\230\132\143\230\187\161\231\186\167\229\144\142\230\186\162\229\135\186\231\154\132\231\187\143\233\170\140\229\185\182\230\151\160\233\162\157\229\164\150\230\148\182\231\155\138\227\128\130", self.param.level)
      }
    }
    
    local function openfunc(bu)
      if taskBu[bu] then
        if taskBu[bu].can then
          ed.showConfirmDialog({
            text = T(taskBu[bu].str),
            rightHandler = function()
              openfunc(bu + 1)
            end
          })
        else
          openfunc(bu + 1)
        end
      elseif self.dataObj:getMaxLevel() <= self.dataObj.passData.level then
        ed.showToast(T("\229\189\147\229\137\141\230\136\152\232\175\129\229\183\178\230\187\161\231\186\167\239\188\129"))
      else
        self:listenTimer(Timer:Once(0.5), function()
          self:destroy({skipAnim = false})
          ed.taskNetwork:sendDailyPassBuyLevel(self.param.level)
        end)
      end
    end
    
    openfunc(1)
  end)
  func(self.ui.btn_add, function()
    self.param.level = ed.clamp(self.param.level + 1, 1, self.param.levelMax)
    self:uiRefresh()
  end)
  func(self.ui.btn_reduce, function()
    self.param.level = ed.clamp(self.param.level - 1, 1, self.param.levelMax)
    self:uiRefresh()
  end)
  func(self.ui.btn_max, function()
    self.param.level = self.param.levelMax
    self:uiRefresh()
  end)
  func(self.ui.btn_close, function()
    self:destroy({skipAnim = false})
  end, 0.85, 0.9)
  self:btRegisterOutClick({
    area = self.ui.ImageView_286,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end
