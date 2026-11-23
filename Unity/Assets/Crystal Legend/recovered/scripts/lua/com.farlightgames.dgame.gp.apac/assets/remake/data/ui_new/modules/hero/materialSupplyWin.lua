local MaterialSupplyWin = newclass("g")
ed.ui.MaterialSupplyWin = MaterialSupplyWin

function MaterialSupplyWin:initData(param)
  self.controller = param.controller
  self.pos = param.pos
end

function MaterialSupplyWin:isPressButton()
  return self.isPressAdd or self.isPressMinus or self.isPressUse or self.isPressIcon
end

function MaterialSupplyWin:setUseAmount(cfg, amount)
  local chestItemId = cfg.chestInfo["Item Id"]
  cfg.currentAmount = self.currentAmounts and self.currentAmounts[chestItemId] or 0
  if amount then
    cfg.currentAmount = math.max(0, math.min(cfg.useAmountLimit, amount))
  end
  cfg.currentAmount = math.floor(cfg.currentAmount)
  self.currentAmounts[chestItemId] = cfg.currentAmount
  ed.setString(cfg.ui.use_amount, cfg.currentAmount)
end

function MaterialSupplyWin:getPressInHandler()
  local function acceleratePressHandler(eventName, add, cfg)
    local count = 0
    
    local acceleration = 7
    local speed = 5
    local maxSpeed = 100
    local threshold = 0.5
    self.controller:registerUpdateHandler(eventName, function(dt)
      local chestItemId = cfg.chestInfo["Item Id"]
      cfg.currentAmount = self.currentAmounts and self.currentAmounts[chestItemId] or 0
      count = count + dt
      if count > threshold then
        speed = speed + acceleration * (count - threshold)
        speed = math.max(speed, maxSpeed)
        if add then
          cfg.currentAmount = cfg.currentAmount + speed * dt
        else
          cfg.currentAmount = cfg.currentAmount - speed * dt
        end
        self:setUseAmount(cfg, cfg.currentAmount)
        if self.isPressAdd and cfg.callBack then
          cfg.callBack()
        end
      end
    end)
  end
  
  local function handler(x, y)
    for _, cfg in ipairs(self.uiList or {}) do
      local ui = cfg.ui
      local chestId = 0
      if cfg.chestInfo then
        chestId = cfg.chestInfo["ChestCombination ID"]
      end
      local bgVisible = ui.bg_box_detail:isVisible() and self.mainLayer:isVisible()
      if bgVisible and ed.containsPoint(ui.minus_button, x, y) then
        ui.minus_button:setScale(0.95)
        acceleratePressHandler(string.format("materialSupplyWin_minus_%d", chestId), false, cfg)
        self.isPressMinus = true
        return cfg
      elseif bgVisible and ed.containsPoint(ui.add_button, x, y) then
        ui.add_button:setScale(0.95)
        acceleratePressHandler(string.format("materialSupplyWin_add_%d", chestId), true, cfg)
        self.isPressAdd = true
        return cfg
      elseif bgVisible and ed.containsPoint(ui.use_button, x, y) then
        ui.use_button:setScale(0.95)
        self.isPressUse = true
        return cfg
      elseif bgVisible and ed.containsPoint(ui.itemIcon, x, y) then
        self.isPressIcon = true
        return cfg
      end
    end
  end
  
  return handler
end

function MaterialSupplyWin:getClickInHandler()
  local function handler(x, y, cfg)
    if cfg then
      local ui = cfg.ui
      
      local chestItemId = cfg.chestInfo["Item Id"]
      cfg.currentAmount = self.currentAmounts and self.currentAmounts[chestItemId] or 0
      if ed.containsPoint(ui.minus_button, x, y) then
        ed.playEffect(ed.sound.deo.common_back)
        self:setUseAmount(cfg, cfg.currentAmount - 1)
        if cfg.callBack then
          cfg.callBack()
        end
      elseif ed.containsPoint(ui.add_button, x, y) then
        ed.playEffect(ed.sound.deo.common_back)
        self:setUseAmount(cfg, cfg.currentAmount + 1)
        if cfg.callBack then
          cfg.callBack()
        end
      elseif ed.containsPoint(ui.use_button, x, y) then
        ed.playEffect(ed.sound.deo.common_back)
        if 0 >= cfg.useAmountLimit then
          ed.showToast(T("\230\137\128\233\128\137\233\129\147\229\133\183\230\149\176\233\135\143\228\184\141\232\182\179"))
        elseif cfg.currentAmount <= 0 then
          ed.showToast(T("\230\156\170\233\128\137\230\139\169\230\149\176\233\135\143"))
        else
          local overfull = {}
          local itemAmount = self:getItemAddCountByItemId(cfg.needItemId)
          if ed.player:isItemOverfull({
            id = cfg.needItemId,
            amount = itemAmount
          }) then
            table.insert(overfull, {
              id = cfg.needItemId,
              amount = itemAmount
            })
          end
          if 0 < #overfull then
            local panel = ed.ui.maillocalbox.create({
              type = "deleItem",
              tag = 2,
              btnStr = T("\229\143\150\230\182\136"),
              str = T("\233\128\137\230\139\169\231\154\132\231\137\169\229\147\129\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\230\140\129\230\156\137\228\184\138\233\153\144\239\188\140\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=mailRed>\230\184\133\233\153\164</lable>\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\233\128\137\230\139\169\239\188\159<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
              item = overfull,
              clickGeft = function()
                self:sendUseChooseBox(cfg)
              end,
              clickBack = function()
              end
            }):popWindow()
          else
            self:sendUseChooseBox(cfg)
          end
        end
      elseif ed.containsPoint(ui.itemIcon, x, y) then
        ed.playEffect(ed.sound.deo.common_back)
        ed.ui.packageDetailWin.create({id = chestItemId}):popWindow()
      end
    end
  end
  
  return handler
end

function MaterialSupplyWin:sendUseChooseBox(cfg)
  local chestItemId = cfg.chestInfo["Item Id"]
  
  function ed.netreply.openSimpleChestReply(data)
    cfg.currentAmount = self.currentAmounts and self.currentAmounts[chestItemId] or 0
    ed.player:consumeEquip(chestItemId, cfg.currentAmount)
    ed.record:useItemCount(chestItemId, cfg.currentAmount)
    self.currentAmounts[chestItemId] = 0
    self:handleRewards(data._rewards or {})
    if cfg.callBack then
      cfg.callBack()
    end
    cfg = self:getCfgByChestItemId(chestItemId)
    if cfg then
      cfg.useAmountLimit = ed.player:getEquipAmount(chestItemId) or 0
      self:setChestInfo(cfg)
    end
  end
  
  local itemInfo = ed.packItem(chestItemId, self.currentAmounts[chestItemId])
  local msg = ed.upmsg.consume_item()
  msg._consume_item_extra_info = ed.upmsg.consume_item_extra_info()
  msg._consume_item_extra_info._type = 2
  msg._consume_item_extra_info._id = cfg.needItemId
  msg._item = itemInfo
  ed.send(msg, "consume_item")
end

function MaterialSupplyWin:handleRewards(rewards)
  ed.player:addRewards(rewards)
  local items = {}
  for k, v in ipairs(rewards) do
    table.insert(items, {
      type = v._type,
      id = v._id,
      amount = v._amount
    })
  end
  ed.ui.maillocalbox.create({type = "addItem", item = items}):popWindow()
end

function MaterialSupplyWin:getCancelPressIn()
  local function handler(x, y, cfg)
    local ui = cfg and cfg.ui
    
    local chestId = 0
    if cfg.chestInfo then
      chestId = cfg.chestInfo["ChestCombination ID"]
    end
    if ui then
      self.isPressMinus = false
      self.isPressAdd = false
      self.isPressUse = false
      self.isPressIcon = false
      self.controller:removeUpdateHandler(string.format("materialSupplyWin_minus_%d", chestId))
      self.controller:removeUpdateHandler(string.format("materialSupplyWin_add_%d", chestId))
      ui.minus_button:setScale(1)
      ui.add_button:setScale(1)
      ui.use_button:setScale(1)
    end
  end
  
  return handler
end

function MaterialSupplyWin:initList()
  self.dragList = ed.UITool.createDraglist(self.ui.mid_layer, {
    doPressIn = self:getPressInHandler(),
    cancelPressIn = self:getCancelPressIn(),
    doClickIn = self:getClickInHandler(),
    priority = -300
  })
  self.currentAmounts = {}
  self:refreshDragList({})
end

function MaterialSupplyWin:refreshDragList(chestList, clearAmount)
  if not self.dragList then
    return
  end
  if not self.currentAmounts or clearAmount then
    self.currentAmounts = {}
  end
  self.dragList:clearList()
  self.uiList = {}
  local width = 0
  local boxSize = CCSizeMake(0, 0)
  local length = #chestList
  for i = 1, length do
    local cfg = chestList[i]
    local itemContainer, itemUI = ed.editorui(ed.uieditor.materialSupplyItem)
    self.dragList:addItem(itemContainer)
    boxSize = itemUI.bg_box_detail:getContentSize()
    itemContainer:setPosition(ccp(width + boxSize.width / 2, boxSize.height / 2))
    itemContainer.ui = itemUI
    cfg.ui = itemUI
    if i == length then
      width = width + boxSize.width
    else
      width = width + boxSize.width * 1.05
    end
    ed.setLabelStroke(itemUI.use_amount, ed.toccc3(2565412), 1)
    table.insert(self.uiList, cfg)
    self:setChestInfo(cfg)
  end
  self.dragList:initListWidth(10)
  local layerSize = self.ui.bg_detail:getContentSize()
  local layerPosX = self.ui.bg_detail:getPositionX()
  local titleSize = self.ui.layer_title:getContentSize()
  local newLayerWidth = math.max(width + boxSize.width * 0.15, titleSize.width)
  self.ui.bg_detail:setPositionX(layerPosX + (layerSize.width - newLayerWidth) / 2)
  self.ui.bg_detail:setContentSize(CCSizeMake(newLayerWidth, layerSize.height))
  self.ui.layer_title:setPositionX(newLayerWidth / 2 - titleSize.width / 2)
  self.ui.mid_layer:setPositionX(newLayerWidth / 2 - width / 2)
end

function MaterialSupplyWin:setChestInfo(cfg)
  local itemId = cfg.chestInfo["Item Id"]
  local equipInfo = ed.getDataTable("equip")[itemId]
  local chestIcon = ed.readequip.createIcon(itemId)
  ed.UITool.replaceUI(cfg.ui, "bg_box_detail", "itemIcon", chestIcon)
  ed.setString(cfg.ui.Label_name, equipInfo.Name)
  ed.adaptLabel(cfg.ui.Label_name, {
    maxWidth = 185,
    minScale = 0.6,
    singleLine = true
  })
  ed.setString(cfg.ui.use_amount_limit, string.format("/%d", cfg.useAmountLimit))
  if self.currentAmounts then
    self:setUseAmount(cfg, self.currentAmounts[itemId])
  end
end

function MaterialSupplyWin:getItemAddCountByItemId(itemId)
  local count = 0
  for index, cfg in ipairs(self.uiList or {}) do
    if cfg.needItemId == itemId then
      local itemId = cfg.chestInfo["Item Id"]
      local amount = self.currentAmounts and self.currentAmounts[itemId] or 0
      count = count + cfg.itemOpenCount * amount
    end
  end
  return count
end

function MaterialSupplyWin:getCfgByChestItemId(itemId)
  for index, cfg in ipairs(self.uiList or {}) do
    local chestItemId = cfg.chestInfo["Item Id"]
    if chestItemId == itemId then
      return cfg
    end
  end
  return nil
end

function MaterialSupplyWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.material_supply_win, {
    ui = self.controller.ui
  })
  self.mainLayer = container
  self.ui = ui
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(2565412), 1)
  self:initList()
end

function MaterialSupplyWin:registerTouchHandlers(level)
end

function MaterialSupplyWin.create(param)
  local self = {}
  setmetatable(self, {__index = MaterialSupplyWin})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  return self
end
