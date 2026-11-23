local base = ed.ui.popwindow
local EquipcraftOpenChest = {}
EquipcraftOpenChest.__index = EquipcraftOpenChest
setmetatable(EquipcraftOpenChest, base.mt)
local EquipcraftOpenChestScope = {}
ed.ui.EquipcraftOpenChest = EquipcraftOpenChest

function EquipcraftOpenChest.create(params)
  local self = base.create("equipcraftopenchest")
  setmetatable(self, EquipcraftOpenChest)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  return self
end

function EquipcraftOpenChest:initData(params)
  self.equipId = params.equipId
  self.state = params.state
  self.needNum = params.needNum
  self.config = params.config
  self.useNum = 0
  self.chestList = {}
  self.parent = params.parent
  self.selectIndex = 1
  self.numOfChest = #params.chests
  for i = 1, self.numOfChest do
    self.chestList[i] = {}
    if params.chests[i] then
      self.chestList[i].total = ed.player.equip_qunty[params.chests[i]] or 0
      self.chestList[i].chestId = params.chests[i]
      self.chestList[i].use = 0
    else
      self.chestList[i].total = 0
      self.chestList[i].chestId = 0
      self.chestList[i].use = 0
    end
  end
  for k, chestId in ipairs(params.chests) do
    if self.state == 1 then
      if k == 1 then
        self.chestList[k].use = 1
        self.useNum = self.useNum + 1
      else
        self.chestList[k].use = 0
      end
    elseif self.useNum < self.needNum then
      if self.needNum - self.useNum <= self.chestList[k].total then
        self.chestList[k].use = self.needNum - self.useNum
        self.useNum = self.needNum
      else
        self.chestList[k].use = self.chestList[k].total
        self.useNum = self.useNum + self.chestList[k].total
      end
    else
      self.chestList[k].use = 0
    end
  end
end

function EquipcraftOpenChest:initUI()
  local container, ui = ed.editorui(ed.uieditor.quickChooseBox)
  self.ui = ui
  self.container:addChild(container)
  self:initDraglist()
  self:refreshDraglist()
  self:refreshUI()
end

function EquipcraftOpenChest:quickGetEquip()
  if self.useNum == 0 then
    self:destroy()
    return
  end
  ListenEventOnce("equipcraftUseChestSuccess", function(result)
    if result == "success" then
      self:destroy()
      ed.player:addEquip(self.equipId, self.useNum)
      for k, v in ipairs(self.chestList) do
        if v.use and v.use > 0 then
          ed.player:consumeEquip(v.chestId, v.use)
        end
      end
      local rewards = {}
      table.insert(rewards, {
        type = "item",
        id = self.equipId,
        amount = self.useNum
      })
      ed.announce({
        type = "getProp",
        param = {
          title = T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
          items = rewards
        }
      })
      self.parent:destroy()
      local craftLayer = ed.ui.equipcraft.create(self.config)
      ed.getCurrentScene():ccScene():addChild(craftLayer.mainLayer, 300)
    else
      ed.showToast(T("\229\188\128\229\144\175\229\164\177\232\180\165"))
    end
  end, EquipcraftOpenChestScope)
  local req = ed.upmsg.fast_equip_chest_req()
  req._use = ed.upmsg.fast_equip_chest_use()
  local items = {}
  for k, v in ipairs(self.chestList) do
    if k == self.selectIndex then
      local chest = ed.upmsg.equip_chest()
      chest._chest_id = v.chestId
      chest._chest_num = 1
      chest._equip_id = self.equipId
      table.insert(items, chest)
    end
  end
  req._use._item_id = items
  ed.send(req, "fast_equip_chest_use")
end

function EquipcraftOpenChest:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:quickGetEquip()
  end, {pressScale = 0.9})
end

function EquipcraftOpenChest:destroy()
  CloseScope(EquipcraftOpenChestScope)
  base.destroy(self)
end

function EquipcraftOpenChest:initDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {priority = -101})
end

function EquipcraftOpenChest:refreshUI()
  for k, v in ipairs(self.uiList or {}) do
    v.mask:setVisible(k == self.selectIndex)
  end
end

function EquipcraftOpenChest:createChest(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.chooseBoxItem)
  ed.setString(ui.name, ed.getDataTable("equip")[data.chestId].Name)
  ed.setString(ui.num, data.total)
  local icon = ed.readequip.createIcon(data.chestId)
  icon:setScale(0.8)
  local x, y = ui.mask:getPosition()
  icon:setPosition(ccp(x, y))
  ui.bg:addChild(icon)
  return container, ui
end

function EquipcraftOpenChest:refreshDraglist()
  self.draglist:clearList()
  
  local function getPos(index)
    local row = math.floor((index + 1) / 2)
    local col = (index + 1) % 2 + 1
    local x = 0
    if col == 1 then
      x = 67
    else
      x = 206
    end
    local y = 322 - row * 153
    return ccp(0, 0)
  end
  
  local uiList = {}
  if #self.chestList == 1 then
    local container, ui = self:createChest(self.chestList[1])
    container:setPosition(ccp(136.5, 121))
    self.draglist:addItem(container)
    table.insert(uiList, ui)
  else
    for k, v in ipairs(self.chestList) do
      local container, ui = self:createChest(self.chestList[1])
      ui.index = k
      container:setPosition(getPos(k))
      self.draglist:addItem(container)
      table.insert(uiList, ui)
    end
  end
end

function EquipcraftOpenChest:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.bg, x, y) then
        return item
      end
    end
  end
  
  return handler
end

function EquipcraftOpenChest:getClickInHandler()
  local function handler(x, y, item)
    self.selectIndex = item.index
    
    self:refreshUI()
  end
  
  return handler
end
