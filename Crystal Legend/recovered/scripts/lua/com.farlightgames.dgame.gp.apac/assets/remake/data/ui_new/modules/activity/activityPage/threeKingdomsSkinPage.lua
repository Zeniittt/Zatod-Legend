local class = newclass("g")
ed.ui.threeKingdomsSkinPage = class

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.endTime = param._end_time
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.pageKey = pageKey
  self.isVisible = true
  local fashionIds = ed.getDataTable("Activity")[self.cfgId]["Extra AN"]
  self.data = {}
  for k, v in ipairs(fashionIds) do
    local tbData = ed.getDataTable("Fashion")[v]
    local itemData = {
      res = tbData["Art Switch"],
      name = tbData.Name,
      rankName = ed.fashionQualityName[tbData.Quality],
      itemId = tbData["Item ID"],
      fashionId = v
    }
    table.insert(self.data, itemData)
  end
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
end

function class:checkFashionState()
  for k, item in ipairs(self.uiList) do
    local got = ed.player:getEquipAmount(item.data.itemId) > 0
    item.ui.btn_get:setVisible(not got)
    item.ui.btn_got:setVisible(got)
  end
end

function class:refreshCountDown()
  if not self.endTime then
    return
  end
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_3_kindoms_skin_page)
  self.container = container
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  self.ui.time:setZOrder(10)
  ed.setLabelStroke(self.ui.time, ed.toccc3(1315346), 1)
  self:refreshCountDown()
  local tipLabel = ed.ui.gradientLabel.create({
    text = "\228\184\137\229\155\189\231\179\187\229\136\151\231\154\174\232\130\164\231\153\187\229\156\186",
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16772997),
    endColor = ed.toccc3(16645338),
    strokeColor = ed.toccc3(9916437),
    strokeSize = 1
  })
  self.ui.bg_title_sub:addChild(tipLabel.node)
  ed.layout.centerInParent(tipLabel.node)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    priority = -300
  })
  self:refreshDraglist()
end

local offsetY = {
  -30,
  -80,
  -105,
  -30
}

function class:createItem(data, k)
  local container, ui = ed.editorui(ed.uieditor.kindomSkinItem)
  ui.rank:setFontName(ed.fontBold)
  ui.name:setFontName(ed.fontBold)
  ui.name:setString(data.name)
  ui.rank:setString(data.rankName)
  ed.setLabelStroke(ui.rank, ed.toccc3(12667859), 1)
  ed.setLabelStroke(ui.name, ed.toccc3(12667859), 1)
  ed.setLabelDimensions(ui.name, CCSizeMake(18, 200))
  ui.label_get:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.name, ed.toccc3(12535050), 2)
  ui.label_got:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.name, ed.toccc3(14071163), 2)
  local icon = ed.createSprite(data.res)
  local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/activity/three_kingdom/three_kingdom_frame_shade.png")
  icon:setPositionY(offsetY[k])
  clippingNode:addChild(icon)
  ui.mask:addChild(clippingNode)
  ed.layout.centerInParent(clippingNode)
  ui.bg:setZOrder(1)
  return container, ui
end

function class:refreshDraglist()
  self.draglist:clearList()
  self.uiList = {}
  local dx, dy = 224, 190
  for k, v in ipairs(self.data) do
    local container, ui = self:createItem(v, k)
    table.insert(self.uiList, {
      container = container,
      ui = ui,
      data = v
    })
    container:setPosition(ccp((k - 0.5) * dx, dy))
    self.draglist:addItem(container)
  end
  self.draglist:initListWidth(dx * #self.data)
  self:checkFashionState()
end

function class:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.ui.btn_get:setScale(1)
  end
  
  return handler
end

function class:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.ui.btn_get, x, y) then
        v.ui.btn_get:setScale(0.95)
        
        return v
      end
      if ed.containsPoint(v.ui.mask, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function class:setVisibleCallBack(isVisible)
  self.draglist:setVisible(isVisible)
end

function class.callFunc(fashionId)
  ed.pt(fashionId)
  if fashionId == 101101 then
    FireEvent("jumpActivityPage", {273, 275})
  elseif fashionId == 722 then
    ed.UITool.openView("timeCorridorScene")
  elseif fashionId == 101102 then
    FireEvent("jumpActivityPage", {263, 284})
  elseif fashionId == 531 then
    ed.RechargeNetwork:sendOpenSecretBox()
  end
end

function class:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.ui.btn_get, x, y) and v.ui.btn_get:isVisible() then
      self.callFunc(v.data.fashionId)
    end
    if ed.containsPoint(v.ui.mask, x, y) then
      ed.ui.SkinDetailWin.create({
        fashionId = v.data.fashionId,
        clickCallBack = function()
          self.callFunc(v.data.fashionId)
        end
      })
      return v
    end
  end
  
  return handler
end

function class:initLabels()
end

function class:adaptUI()
  local winSize = ed.display.winSize
  local posX = self.ui.layer_item:getPositionX()
  self.ui.layer_item:setPositionX(posX + (1170 - winSize.width) / 4)
  local contentSize = self.ui.layer_item:getContentSize()
  self.ui.layer_item:setContentSize(CCSizeMake(contentSize.width - (1170 - winSize.width) / 2, contentSize.height))
  self.ui.title:setPositionX(self.ui.title:getPositionX() + (1170 - winSize.width) / 6)
  self.ui.right:setZOrder(999)
  self.ui.left:setZOrder(999)
  self.ui.right:setPositionX(contentSize.width - (1170 - winSize.width) / 2 - 20)
  self.rightInitPosX = self.ui.right:getPositionX()
end

function class:addTouchEvent()
  self:listenEvent("OpenSecretBox", function(data)
    if data._vault_id ~= 0 and ed.getCurrentScene().identity == "activityScene" then
      ed.pushScene(ed.ui.SecretBoxScene.create(data))
    end
  end)
  self:listenEvent("ResourceNumChange", function(resType, id)
    self:checkFashionState()
  end)
end

function class:addEventListener()
end
