local base = ed.ui.popwindow
local PetChooseHatchWin = newclass(base.mt)
ed.ui.PetChooseHatchWin = PetChooseHatchWin

function PetChooseHatchWin.create(param)
  local self = base.create("PetChooseHatchWin")
  setmetatable(self, PetChooseHatchWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function PetChooseHatchWin:getEggItemList()
  local list = {}
  local eggTab = ed.getDataTable("PetEgg")
  for i, k in pairs(eggTab) do
    local cnt = ed.player:getEquipAmount(i)
    if 0 < cnt then
      local gainPet = {}
      for ind = 1, #k["Loot Display"] do
        gainPet[ind] = k["Loot Display"][ind]
      end
      table.insert(list, {
        id = i,
        amount = cnt,
        gainPet = gainPet
      })
    end
  end
  table.sort(list, ed.cmpSort({
    {
      getValue = function(item)
        return ed.readequip.quality(item.id)
      end,
      reverse = true
    },
    {
      getValue = function(item)
        return item.id
      end
    }
  }))
  return list
end

function PetChooseHatchWin:initData(param)
  self.eggId = 0
  self.index = param.index
  self.eggItems = self:getEggItemList()
end

function PetChooseHatchWin:initLabels()
  ed.setLabelStroke(self.ui.name, ed.toccc3(3088141), 1)
  ed.setLabelStroke(self.ui.amount1, ed.toccc3(3088141), 1)
  ed.setLabelStroke(self.ui.amount2, ed.toccc3(3088141), 1)
  ed.setLabelStroke(self.ui.may, ed.toccc3(3088141), 1)
  ed.setLabelStroke(self.ui.tip, ed.toccc3(3088141), 1.5)
  ed.setLabelShadow(self.ui.Label_5052, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelStroke(self.ui.no_egg_label, ccc3(0, 0, 0), 1)
end

function PetChooseHatchWin:refreshPetDraglist()
  self.petDraglist:clearList()
  
  local function getPos(i)
    local row = math.ceil(i / 4)
    local col = (i - 1) % 4 + 1
    local ox, oy = -20, 135
    local dx, dy = 55, 55
    return ccp(ox + dx * col, oy - dy * row)
  end
  
  for k, v in ipairs(self.petList) do
    local item = ed.readpet.createIcon({type = v, showTag = true}).icon
    item:setScale(0.65)
    item:setPosition(getPos(k))
    self:btRegisterButtonClick({
      button = item,
      key = "button" .. k,
      pressHandler = function()
        local map = {
          1,
          4,
          7,
          12,
          12
        }
        if self.petInfoPanel and not tolua.isnull(self.petInfoPanel) then
          return
        end
        local panel = ed.rogueLikeTool.showPetDetail(v)
        local pos = ed.getWorldPos(item, ccp(110, 80))
        panel:setPosition(pos)
        self.mainLayer:addChild(panel)
        self.petInfoPanel = panel
      end,
      cancelPressHandler = function()
        if self.petInfoPanel and not tolua.isnull(self.petInfoPanel) then
          self.petInfoPanel:removeFromParentAndCleanup(true)
        end
      end,
      force = true
    })
    self.petDraglist:addItem(item)
  end
  self.petDraglist:initListWidth(55 * math.ceil(#self.petList / 4))
end

function PetChooseHatchWin:refreshEggDraglist()
  self.eggDraglist:clearList()
  
  local function getPos(i)
    local row = math.ceil(i / 4)
    local col = (i - 1) % 4 + 1
    local ox, oy = -38, 390
    local dx, dy = 95, 95
    return ccp(ox + dx * col, oy - dy * row)
  end
  
  self.uiList = {}
  for k, v in ipairs(self.eggItems) do
    local icon = ed.createItemIcon(v)
    icon:setScale(1.04)
    icon:setPosition(getPos(k))
    self.eggDraglist:addItem(icon)
    table.insert(self.uiList, {data = v, icon = icon})
  end
  self.eggDraglist:initListHeight(95 * math.ceil(#self.eggItems / 4))
end

function PetChooseHatchWin:doClickInList()
  local function handler(x, y, k)
    self:refreshCurSelect(k)
    
    return k
  end
  
  return handler
end

function PetChooseHatchWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon, x, y) then
        return k
      end
    end
    return nil
  end
  
  return handler
end

function PetChooseHatchWin:initUI()
  ed.editorui(ed.uieditor.PetChooseHatchWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  if not ed.PetModel:checkEggStatus() then
    self.ui.Panel_314:setVisible(false)
    self.ui.no_egg_bg:setVisible(true)
    self.ui.prob_info_btn:setVisible(false)
    return
  end
  self.petDraglist = ed.UITool.createDraglist(self.ui.layer_pet, {})
  self.eggDraglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList()
  })
  self.refreshCliprectConfig = {
    draglist = self.eggDraglist
  }
  self:refreshEggDraglist()
  if not self.selectedUI then
    self.selectedUI = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_selected.png")
    self.selectedUI:setScale(1.04)
    self.eggDraglist:addItem(self.selectedUI)
  end
  self:refreshCurSelect(1)
end

function PetChooseHatchWin:refreshCurSelect(index)
  local data = self.uiList[index].data
  self.eggId = data.id
  local icon = ed.readequip.createIcon(self.eggId)
  icon:setScale(1.26)
  ed.UITool.replaceUINew(self.ui, "icon", icon)
  ed.setString(self.ui.name, ed.readequip.value(self.eggId, "Name"))
  ed.setString(self.ui.amount2, data.amount)
  self.petList = data.gainPet
  self:refreshPetDraglist()
  local pos = ccp(self.uiList[index].icon:getPosition())
  self.selectedUI:setPosition(pos)
end

function PetChooseHatchWin:registerEvents()
  self:listenEvent("PetStartHatchSuccess", function()
    self:destroy()
  end)
end

function PetChooseHatchWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.7, pressScale = 0.65})
  ed.UITool.registerBtn(self, "btn_ok", function()
    ed.PetNetwork:startHatchEgg(self.index, self.eggId)
  end, {normalScale = 1, pressScale = 0.9})
  ed.UITool.registerBtn(self, "prob_info_btn", function()
    ed.ui.petEggProbWin.create({
      petEggId = self.eggId
    })
  end, {normalScale = 1, pressScale = 0.9})
end
