local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.featurePreviewWindow = class

function class.create()
  return setmetatable(base.create("featurePreviewWindow"), class.mt):init()
end

function class:init()
  self:initUI()
  self:registerEvents()
  self:createList()
  self:refreshBtn()
  self:show()
  return self
end

function class:initUI()
  ed.editorui(ed.uieditor.featurePreviewWindow, {
    container = self.container,
    ui = self.ui
  })
  self.ui.Label_title:setShadow(ccc3(0, 0, 0), ccp(-2, 2))
  self.ui.ImageView_3259:setScaleX(-1)
  self.ui.Label_3259:setShadow(ccc3(64, 64, 61), ccp(1, 3))
end

function class:registerEvents()
  self:btRegisterOutClick({
    area = {
      self.ui.bg,
      self.ui.close
    },
    key = "btn_destroy",
    clickHandler = function()
      base.destroy(self)
    end
  })
  ed.UITool.registerBtn(self, "close", function()
    base.destroy(self)
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn", function()
    local ids = ed.featurePreviewManager:getAllRewardId()
    if #ids == 0 then
      return ed.showToast(ed.featurePreviewManager.receiving and T("\230\154\130\230\151\160\229\165\150\229\138\177\229\143\175\233\162\134\229\143\150") or T("\229\183\178\233\162\134\229\143\150\229\133\168\233\131\168\229\165\150\229\138\177"))
    end
    ed.featurePreviewNetwork.sendFeaturePreviewReward(ids)
  end, {pressScale = 0.96})
  self:listenEvent("featurePreviewWindowRefresh", function()
    self:refreshList()
    self:refreshBtn()
  end)
end

function class:refreshBtn()
  local isGray = #ed.featurePreviewManager:getAllRewardId() == 0
  ed.setTexture(self.ui.btn, string.format("UI/alpha/1080P/common/%s.png", isGray and "button_big_grey" or "button_big_common"))
  self.ui.Label_3259:setColor(ed.toccc3(isGray and 16776423 or 16708009))
  self.ui.Label_3259:setStroke(ed.toccc3(isGray and 3223857 or 9458959), 1)
end

function class:createList()
  local thisCon = self.ui.Panel_3256:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_3256,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:initList()
end

function class:initList()
  self.dragList:clearList()
  local thisCon = self.ui.Panel_3256:getContentSize()
  local posIdx
  self.items = {}
  local tasks = ed.featurePreviewManager:getTasks()
  for i, v in ipairs(tasks) do
    local item = self.itemModule.create(self, v, i)
    self.dragList:addItem(item.ui.Layer, ccp(thisCon.width / 2, thisCon.height - 85 * i + 42))
    self.items[v.id] = item
    if v.isNew and not posIdx and not ed.storage.getBool(ed.getRoleKey("featurePreviewNewShow_" .. v.id)) then
      posIdx = i
      item.ui.Layer:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.1, 1.03), CCScaleTo:create(0.4, 1)))
      ed.storage.setValue(ed.getRoleKey("featurePreviewNewShow_" .. v.id), true)
    end
  end
  self.dragList:initListHeight(#tasks * 85)
  if posIdx and 3 < posIdx then
    if posIdx > #tasks - 3 then
      posIdx = #tasks - 2
    end
    self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, posIdx * 85 - 42 - thisCon.height / 2))))
  end
end

function class:refreshList()
  local tasks = ed.featurePreviewManager:getTasks()
  local thisCon = self.ui.Panel_3256:getContentSize()
  local isTop = 0
  for i, v in ipairs(tasks) do
    if not self.items[v.id] then
      return self:initList()
    end
    if self.items[v.id].index ~= i then
      self.items[v.id].index = i
      self.items[v.id].ui.Layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(thisCon.width / 2, thisCon.height - 85 * i + 42))))
    end
    if v.status ~= self.items[v.id].param.status then
      self.items[v.id]:setStatus(v.status, i)
      isTop = isTop + 1
    end
  end
  if 1 < isTop then
    self.dragList.listLayer:setPositionY(0)
  end
end

local itemModule = {}

function itemModule.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemModule})
  this:init(param)
  return this
end

itemModule.color = {
  [0] = {
    color = ed.toccc3(16774096),
    stroke = ed.toccc3(4074535),
    color2 = ed.toccc3(7757380),
    color3 = ed.toccc3(4995108),
    color4 = ed.toccc3(8349510)
  },
  [1] = {
    color = ed.toccc3(16447719),
    stroke = ed.toccc3(4204293),
    color2 = ed.toccc3(10181154),
    color3 = ed.toccc3(10181154),
    color4 = ed.toccc3(10181154)
  },
  [2] = {
    color = ed.toccc3(15977395),
    stroke = ed.toccc3(5388586),
    color2 = ed.toccc3(5389101),
    color3 = ed.toccc3(5323309),
    color4 = ed.toccc3(6374966)
  }
}

function itemModule:init(param)
  local Layer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0)
  })
  local bg1 = ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_buttom_claimable.png",
    parent = Layer,
    pos = ccp(0, 0),
    rectMake = CCRectMake(80, 3, 120, 40),
    sizeMake = CCSizeMake(650, 81),
    notShow = param.status ~= 1
  })
  local lockBg1 = ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_buttom_unlocked.png",
    pos = ccp(585, 30),
    parent = bg1
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_icon_unlock.png",
    pos = ccp(17, 11),
    parent = lockBg1
  })
  ed.createLabelTools({
    txt = T("\229\183\178\229\188\128\229\144\175"),
    size = 15,
    pos = ccp(30, 11),
    color = self.color[param.status].color4,
    parent = lockBg1,
    anchor = ccp(0, 0.5),
    font = ed.fontBold
  })
  local bg2 = ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_bg_lock.png",
    parent = Layer,
    pos = ccp(0, 0),
    rectMake = CCRectMake(80, 3, 120, 40),
    sizeMake = CCSizeMake(650, 81),
    notShow = param.status ~= 0
  })
  local lockBg2 = ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_buttom_locked.png",
    pos = ccp(585, 30),
    parent = bg2
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_icon_lock.png",
    pos = ccp(17, 11),
    parent = lockBg2
  })
  ed.createLabelTools({
    txt = T("\230\156\170\229\188\128\229\144\175"),
    size = 15,
    pos = ccp(30, 11),
    color = self.color[param.status].color4,
    parent = lockBg2,
    anchor = ccp(0, 0.5),
    font = ed.fontBold
  })
  local bg3 = ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_bg_claimed.png",
    parent = Layer,
    pos = ccp(0, 0),
    rectMake = CCRectMake(80, 3, 120, 40),
    sizeMake = CCSizeMake(650, 81),
    notShow = param.status ~= 2
  })
  local lockBg3 = ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_buttom_claimed.png",
    pos = ccp(585, 30),
    parent = bg3
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_icon_claimed.png",
    pos = ccp(17, 11),
    parent = lockBg3
  })
  ed.createLabelTools({
    txt = T("\229\183\178\233\162\134\229\143\150"),
    size = 15,
    pos = ccp(30, 11),
    color = ed.toccc3(6374966),
    parent = lockBg3,
    anchor = ccp(0, 0.5),
    font = ed.fontBold
  })
  local icon = ed.createSpriteTools({
    res = param.res,
    pos = ccp(-274, 0),
    parent = Layer
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/featurepreview/fp_bg_line.png",
    parent = Layer,
    pos = ccp(-70, 5),
    rectMake = CCRectMake(15, 1, 1, 1),
    sizeMake = CCSizeMake(300, 1.5)
  })
  local name = ed.createLabelTools({
    txt = param.name,
    size = 18,
    pos = ccp(-220, 20),
    color = self.color[param.status].color,
    parent = Layer,
    stroke = {
      self.color[param.status].stroke,
      1.3
    },
    anchor = ccp(0, 0.5)
  })
  local str = ed.createLabelTools({
    txt = param.str,
    size = 14,
    pos = ccp(-220, -15),
    color = self.color[param.status].color2,
    parent = Layer,
    anchor = ccp(0, 0.5)
  })
  str:setHorizontalAlignment(kCCTextAlignmentLeft)
  ed.setLabelDimensions(str, CCSizeMake(300, 0))
  local reward = param.reward
  local item = ed.taskItemModule.new(self, {
    id = reward.id,
    type = reward.type,
    amount = reward.amount
  }, nil, param.id, false, false, true)
  item.icon:setPosition(140, 0)
  Layer:addChild(item.icon)
  item.icon:setScale(0.8)
  item:refresh(param.status)
  local level = ed.createLabelTools({
    txt = T("\232\190\190\229\136\176%d\231\186\167", param.level),
    size = 15,
    pos = ccp(250, 10),
    color = self.color[param.status].color3,
    parent = Layer,
    anchor = ccp(0.5, 0.5),
    font = ed.fontBold
  })
  local newIcon = ed.createSpriteTools({
    parent = Layer,
    pos = ccp(-310, 33),
    res = "UI/alpha/1080P/featurepreview/fp_new.png",
    scale = 1.5,
    notShow = not param.isNew or ed.storage.getBool(ed.getRoleKey("featurePreviewNewShow_" .. param.id))
  })
  if newIcon:isVisible() then
    newIcon:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCScaleTo:create(0.2, 1)))
  end
  local timeIcon = ed.createSpriteTools({
    parent = Layer,
    pos = ccp(305, 26),
    res = "UI/alpha/1080P/featurepreview/fp_time_limited.png",
    notShow = not param.limited
  })
  self.ui = {
    Layer = Layer,
    bg1 = bg1,
    bg2 = bg2,
    bg3 = bg3,
    name = name,
    str = str,
    item = item,
    level = level
  }
end

function itemModule:setStatus(status)
  self.param.status = status
  self.ui.bg1:setVisible(status == 1)
  self.ui.bg2:setVisible(status == 0)
  self.ui.bg3:setVisible(status == 2)
  self.ui.name:setColor(self.color[status].color)
  self.ui.name:setStroke(self.color[status].stroke, 1)
  self.ui.str:setColor(self.color[status].color2)
  self.ui.item:refresh(status)
  self.ui.level:setColor(self.color[status].color3)
end

class.itemModule = itemModule

function class:doPressInList()
  local function handler(x, y)
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.item.icon, x, y) then
        v.ui.item.icon:setScale(0.75)
        
        return {
          icon = v.ui.item.icon,
          fun = function(param)
            if param.status == 1 then
              ed.featurePreviewNetwork.sendFeaturePreviewReward({
                param.id
              })
            else
              ed.UITool.openView("packageDetail", {
                id = param.reward.id,
                type = param.reward.type,
                amount = param.reward.amount
              })
            end
          end,
          param = v.param,
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
