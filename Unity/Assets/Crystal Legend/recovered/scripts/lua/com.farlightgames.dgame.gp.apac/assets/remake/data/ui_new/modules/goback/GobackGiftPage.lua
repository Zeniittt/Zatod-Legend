local GiftPage = newclass("g")
local GobackMainScene = ed.ui.GobackMainScene
GobackMainScene.gift = GiftPage

function GiftPage:initData(param)
  self.scene = param.scene
  self.giftList = ed.GobackManager:getGiftRewads()
end

function GiftPage:refreshData(hero)
end

function GiftPage:createItem(v)
  local container, ui = ed.editorui(ed.uieditor.GobackGiftItem)
  ui.name:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(8010508), 1)
  ed.setLabelStroke(ui.price, ed.toccc3(214803), 1)
  ed.setString(ui.name, v.name)
  ui.name:limitWidthByScale(130)
  for i = 1, 4 do
    if v.rewards[i] then
      local icon = ed.createItemIcon(v.rewards[i])
      icon:setScale(0.9)
      ed.UITool.replaceUI(ui, "bg", "icon" .. i, icon)
    else
      ui["icon" .. i]:setVisible(false)
    end
  end
  if v.price == 0 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/goback/goods/goback_goods_card_1.png")
    ed.setString(ui.price, 0 < v.buyTime and T("\229\183\178\229\148\174\231\189\132") or T("\229\133\141\232\180\185"))
    if v.buyTime == 0 then
      local redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
      ui.bg:addChild(redLight)
      redLight:setPosition(135, 42)
    end
  elseif 0 < v.buyTime then
    ed.setString(ui.price, T("\229\183\178\229\148\174\231\189\132"))
  else
    local price = ed.ui.autoText.new()
    price:initParam({
      context = "<sprite src=UI/alpha/1080P/icon/diamond.png scale=1>" .. v.price,
      color = ed.toccc3(16776423),
      strokeColor = ed.toccc3(7554835),
      strokeSize = 1,
      fontSize = 24
    })
    local width, height = price:getCurContentSize()
    ed.UITool.replaceUI(ui, "bg", "price", price.node)
    ed.UITool.setPositionBy(ui.price, ccp(-width / 2, 0))
  end
  ui.mask:setVisible(0 < v.buyTime)
  return container, ui
end

function GiftPage:refreshDraglist(oldPos)
  local posX, posY = 0, 0
  if oldPos then
    posX, posY = self.draglist:getListPos()
  end
  self.uiList = {}
  self.draglist:clearList()
  local dx, dy = 200, 267
  local ox, oy = -dx / 2 - 2, self.ui.layer_item:getContentSize().height / 2
  for k, v in ipairs(self.giftList) do
    local container, ui = self:createItem(v)
    ui.data = v
    table.insert(self.uiList, ui)
    container:setPosition(ccp(dx * k - dx / 2, oy - 10))
    self.draglist:addItem(container)
  end
  self.draglist:initListWidth(dx * #self.giftList + 12)
  if oldPos then
    self.draglist:setListPos(ccp(posX, posY))
  end
end

function GiftPage:doPressInList()
  local function handler(x, y)
    if self.scene.tabIndex ~= 4 then
      return
    end
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GiftPage:cancelPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
    end
    return nil
  end
  
  return handler
end

function GiftPage:doClickInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      for i = 1, 4 do
        if ed.containsPoint(v["icon" .. i], x, y) then
          ed.ui.packageDetailWin.create(v.data.rewards[i]):popWindow()
        end
      end
      if ed.containsPoint(v.btn_go, x, y) then
        if v.data.buyTime > 0 then
          ed.showToast(T("\229\183\178\229\148\174\231\189\132"))
          return
        end
        if ed.player._rmb < v.data.price then
          ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179!!!"))
          return
        end
        if 0 < v.data.price then
          ed.showConfirmDialog({
            text = T("\230\152\175\229\144\166\232\180\173\228\185\176\232\175\165\232\161\165\231\187\153\229\140\133?"),
            rightText = T("\231\161\174\229\174\154"),
            skipDestroyAnim = true,
            rightHandler = function()
              ed.GobackNetwork:sendBuyGift(v.data.id)
            end
          })
        else
          ed.GobackNetwork:sendBuyGift(v.data.id)
        end
      end
    end
    return nil
  end
  
  return handler
end

function GiftPage:initUI()
  local container, ui = ed.editorui(ed.uieditor.GobackGiftPage)
  self.mainLayer = container
  self.ui = ui
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(8010508), 1)
  if ed.GobackManager.endTime > ed.getServerTime() then
    local endTimeStr = ed.time2dhmsV2(ed.GobackManager.endTime - ed.getServerTime())
    ed.setString(self.ui.label_time, string.format(T("\229\137\169\228\189\153%s"), endTimeStr))
  else
    ed.setString(self.ui.label_time, T("\229\183\178\231\187\147\230\157\159"))
  end
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -1
  })
  self:refreshDraglist()
end

function GiftPage:refreshUI()
  if ed.GobackManager.endTime > ed.getServerTime() then
    local endTimeStr = ed.time2dhmsV2(ed.GobackManager.endTime - ed.getServerTime())
    ed.setString(self.ui.label_time, string.format(T("\229\137\169\228\189\153%s"), endTimeStr))
  else
    ed.setString(self.ui.label_time, T("\229\183\178\231\187\147\230\157\159"))
  end
  self:refreshDraglist()
end

function GiftPage:registerTouchHandlers()
end

function GiftPage:buyGiftSuccess()
  self.giftList = ed.GobackManager:getGiftRewads()
  self:refreshDraglist(true)
end

function GiftPage:registerEvents()
  self.scene:listenEvent("GobackBuyGiftSuccess", function()
    self:buyGiftSuccess()
  end)
end

function GiftPage.create(param)
  local self = {}
  setmetatable(self, {__index = GiftPage})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
