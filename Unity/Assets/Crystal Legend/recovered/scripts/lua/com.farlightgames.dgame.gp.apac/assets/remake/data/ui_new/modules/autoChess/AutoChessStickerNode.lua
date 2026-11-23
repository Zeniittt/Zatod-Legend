module("ed.ui", package.seeall)
local base = ed.ui.popwindow
local class = newclass(base.mt)
AutoChessStickerNode = class
local SendChatCD = 5

function class:initData()
  self.allStickers = {}
  self.lastSendChatTime = 0
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessStickerNode, {
    container = self.container,
    ui = self.ui
  })
  self.ui.bg_item:setVisible(false)
end

function class:loadSticker(index)
  if index < 1 then
    return
  end
  if index > #self.allStickers then
    return
  end
  local stickerData = self.allStickers[index]
  local stickerSprite = ed.createSprite(stickerData.res)
  stickerSprite:setScale(0.75)
  return stickerSprite, stickerData
end

function class:getTableDelegate()
  local delegate = {}
  
  function delegate.numberOfCells()
    return #self.allStickers
  end
  
  function delegate.cellSizeFromIndex(idx)
    return CCSizeMake(56.25, 56.25)
  end
  
  function delegate.createCell(idx)
    return self:loadSticker(idx)
  end
  
  function delegate.syncCell(cell, idx)
    return self:loadSticker(idx)
  end
  
  function delegate.doClickIn(cell)
    if self.ui.bg_item:isVisible() then
      local idx = cell.idx
      local data = cell.data
      self:onStickerItemEvent(idx, data)
    end
  end
  
  return delegate
end

function class:createTableView()
  self.delegate = self:getTableDelegate()
  local tagSize = self.ui.layer_item:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 0, tagSize.width, tagSize.height),
    dragMode = 1,
    colNum = 4,
    zorder = 999,
    touchpriority = -300
  }
  self.stickerTableview = Tableview.create(param)
end

function class:setListVisible(isVisible)
  self.ui.bg_item:setVisible(isVisible)
  self.ui.icon_close:setVisible(not isVisible)
  self.ui.icon_open:setVisible(isVisible)
end

function class:registerBtnEvents()
  self:btRegisterButtonClick({
    button = self.ui.btn_op,
    key = "chess_sticker_click",
    clickHandler = function()
      FireEvent("AutoChessClickStickerPanel")
      self:setListVisible(not self.ui.bg_item:isVisible())
    end,
    force = true,
    mcpMode = true
  })
end

function class:registerNetEvents()
  self:listenEvent("AutoChessClickDamage", function()
    self:setListVisible(false)
  end)
  self:listenEvent("AutoChessClickTagPanel", function()
    self:setListVisible(false)
  end)
  self:listenEvent("EventDestroyStickerPanel", function()
    self:destroy()
  end)
end

function class:registerEvents()
  self:registerBtnEvents()
  self:registerNetEvents()
end

function class:onEnter()
  self:registerEvents()
  self:createTableView()
  self:updateStickerList()
end

function class:onStickerItemEvent(index, data)
  local now = ed.getServerTime()
  local cd = SendChatCD - (now - self.lastSendChatTime)
  if 0 <= cd then
    ed.showToast(T("\229\143\145\232\168\128\233\162\145\231\142\135\232\191\135\233\171\152\239\188\140\232\175\183%d\231\167\146\229\144\142\229\134\141\232\175\149\227\128\130", cd + 1))
    return
  end
  self:setListVisible(false)
  self.lastSendChatTime = now
  ed.AutoChessNetwork:sendChatContent(string.format("<sticker|%s|0.8>", data.id))
end

function class.create()
  local self = base.create("AutoChessStickerNode", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerOnEnterHandler("auto_chess_sticker", function()
    self:onEnter()
  end)
  return self
end

function class:updateStickerList()
  self.allStickers = ed.chatManager:getStickerInfoList()
  if self.stickerTableview then
    self.stickerTableview:reloadData()
  end
end

function class:destroy(param)
  self:removeOnEnterHandler("auto_chess_sticker")
  base.destroy(self, param)
end
