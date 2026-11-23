local base = ed.ui.popwindow
local activityAllStarGiveFlower = newclass(base.mt)
ed.UITool.registViewOpenFunc("activityAllStarGiveFlower", function(param)
  activityAllStarGiveFlower.create(param or {}):popWindow()
end)
ed.ui.activityAllStarGiveFlower = activityAllStarGiveFlower

function activityAllStarGiveFlower.create(param)
  return setmetatable(base.create("activityAllStarGiveFlower"), activityAllStarGiveFlower.mt):init(param or {})
end

function activityAllStarGiveFlower:init(param)
  self.param = param
  self.dragonBoatStatus = param.dragonBoatStatus
  self:uiCreate()
  self:uiRefresh()
  self:registerBtnEvents()
  self:show({skipAnim = false})
  return self
end

function activityAllStarGiveFlower:uiCreate()
  self.frame, self.ui = ed.editorui(ed.uieditor.buyPassLvBoxWindow)
  self.container:addChild(self.frame)
  self.frame:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  ed.setLabelStroke(self.ui.title_text, ccc3(ed.colorToStr("#2e161a")), 1)
  ed.setLabelStroke(self.ui.input_label, ccc3(ed.colorToStr("#2e161a")), 1)
  ed.setLabelStroke(self.ui.cost_value, ccc3(ed.colorToStr("#2e161a")), 1)
  self.ui.line:getParent():setScale(0.5)
  self.ui.line:setScaleX(-1)
  self.ui.cost_icon:setVisible(false)
  self.ui.conent_bg:setVisible(false)
  self.ui.title_text:setString(self.dragonBoatStatus and T("\232\181\160\233\128\129\231\145\158\231\178\189") or T("\232\181\160\233\128\129\229\135\176\231\190\189"))
  local text = T("\229\135\176\231\190\189\229\143\175\231\148\168\228\186\142\232\181\160\233\128\129\228\187\150\228\186\186\239\188\140\228\185\159\229\143\175\232\181\160\233\128\129\232\135\170\229\183\177")
  if self.dragonBoatStatus then
    text = T("\231\145\158\231\178\189\229\143\175\231\148\168\228\186\142\232\181\160\233\128\129\228\187\150\228\186\186\239\188\140\228\185\159\229\143\175\232\181\160\233\128\129\232\135\170\229\183\177")
  end
  self.ui.str_text:setString(text)
  self.ui.str_text:setScale(0.8)
  local id = self.dragonBoatStatus and ed.getDataTable("DragonBoat")[1]["Item ID"] or ed.getDataTable("AllStar")[1]["Star ID"]
  self.itemId = id
  local icon = ed.createItemIcon({id = id, amount = 1})
  self.ui.btn_buy:getParent():addChild(icon)
  icon:setPosition(self.ui.btn_buy:getPositionX(), 324)
  icon:setScale(1)
  local btn_buy = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_big.png",
    parent = self.ui.btn_buy:getParent(),
    pos = ccp(self.ui.btn_buy:getPosition())
  })
  ed.createLabelTools({
    txt = T("\232\181\160\233\128\129"),
    size = 20,
    pos = ccp(62.25, 25.25),
    color = ccc3(250, 242, 165),
    parent = btn_buy
  })
  self.ui.btn_buy:removeFromParentAndCleanup(true)
  self.ui.btn_buy = btn_buy
  self.countMax = ed.player.equip_qunty[id] or 0
  self.count = 1
  self.ui.item_count_label = ed.createLabelTools({
    txt = T("\230\140\129\230\156\137\233\135\143:%d", self.countMax),
    size = 13,
    pos = ccp(45, -5),
    color = ccc3(1, 1, 1),
    parent = icon
  })
  local editLayer = ed.createCCLayer({
    pos = ccp(20, 0),
    sizeMake = CCSizeMake(100, 50),
    parent = self.ui.input_bg
  })
  self.ui.input_bg = editLayer
  local info = {
    config = {
      editSize = self.ui.input_bg:getContentSize(),
      maxLength = 4,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18,
      inputMode = kEditBoxInputModeNumeric
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setVisible(false)
  edit_box:setEnabled(true)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.ui.input_bg:addChild(edit_box.edit)
  self.ui.edit_box = edit_box
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
  self:registerUpdateHandler("long_click_button_down", function()
    local num = tonumber(self.ui.edit_box:getString())
    if not num then
      return
    end
    if self.count ~= num then
      self.count = num
      self:uiRefresh()
    end
  end)
end

function activityAllStarGiveFlower:uiRefresh()
  self.ui.edit_box:setString(self.count)
  ed.setLabelString(self.ui.input_label, self.count, true)
end

function activityAllStarGiveFlower:onClickBtnAdd()
  local id = self.itemId
  if (ed.player.equip_qunty[id] or 0) < 1 then
    ed.showToast(T("%s\230\149\176\233\135\143\228\184\141\232\182\179", ed.getEquipNameWithId(id)))
    return
  end
  self.count = ed.clamp(self.count + 1, 1, self.countMax)
  self:uiRefresh()
end

function activityAllStarGiveFlower:onClickBtnReduce()
  local id = self.itemId
  if (ed.player.equip_qunty[id] or 0) < 1 then
    return
  end
  self.count = ed.clamp(self.count - 1, 1, self.countMax)
  self:uiRefresh()
end

function activityAllStarGiveFlower:onClickBtnMax()
  local id = self.itemId
  if (ed.player.equip_qunty[id] or 0) < 1 then
    ed.showToast(T("%s\230\149\176\233\135\143\228\184\141\232\182\179", ed.getEquipNameWithId(id)))
    return
  end
  self.count = self.countMax
  self:uiRefresh()
end

function activityAllStarGiveFlower:registerBtnEvents()
  local function changeNumFunc(_, key)
    if key == "btn_add" then
      self:onClickBtnAdd()
    elseif key == "btn_reduce" then
      self:onClickBtnReduce()
    end
  end
  
  self:btRegisterChangeNumButtonClick(self.ui.btn_add, "btn_add", changeNumFunc)
  self:btRegisterChangeNumButtonClick(self.ui.btn_reduce, "btn_reduce", changeNumFunc)
  local index = 1
  
  local function func(node, click, press, normal, pressHandler, cancelPressHandler)
    self:btRegisterButtonClick({
      button = node,
      key = "activityAllStarGiveFlower_" .. index,
      clickHandler = click,
      clickInterval = 0.1,
      pressScale = press or 0.9,
      normalScale = normal or 1,
      pressHandler = pressHandler,
      cancelPressHandler = cancelPressHandler
    })
    index = index + 1
  end
  
  func(self.ui.btn_buy, function()
    local id = self.itemId
    if (ed.player.equip_qunty[id] or 0) < 1 then
      ed.showToast(T("%s\230\149\176\233\135\143\228\184\141\232\182\179", ed.getEquipNameWithId(id)))
      return
    end
    if self.dragonBoatStatus then
      if self.dragonBoatStatus == "dragon_boat_give_num_not_enough" then
        ed.showToast(T("\232\181\160\228\186\136\232\135\170\229\183\177\230\149\176\233\135\143\228\184\141\232\182\179400"))
      elseif self.dragonBoatStatus == "dragon_boat_item_not_enough" then
        ed.showToast(T("\233\129\147\229\133\183\228\184\141\232\182\179"))
      else
        ed.ActivityNetwork.starCount = self.count
        ed.dragonBoatNet:sendGive(self.param.roleId, self.count)
      end
    else
      ed.ActivityNetwork.sendAllStarRankGiveMsg(self.param.roleId, self.count)
    end
  end)
  func(self.ui.btn_max, function()
    self:onClickBtnMax()
  end)
  func(self.ui.btn_close, function()
    self:removeUpdateHandler("long_click_button_down")
    self:destroy({skipAnim = false})
  end, 0.85, 0.9)
  self:btRegisterOutClick({
    area = self.ui.ImageView_286,
    key = "out_click",
    clickHandler = function()
      self:removeUpdateHandler("long_click_button_down")
      self:destroy({skipAnim = false})
    end
  })
  self:listenEvent("ResourceNumChange", function(resType, id)
    if id == self.itemId then
      self.countMax = ed.player.equip_qunty[id] or 0
      self.ui.item_count_label:setString(T("\230\140\129\230\156\137\233\135\143:%d", self.countMax))
    end
  end)
  self:listenEvent("allStarReply", function(info)
    info = ed.copyProto(info)
    if info._give and info._give._result == "success" then
      ed.player:consumeEquip(ed.getDataTable("AllStar")[1]["Star ID"], ed.ActivityNetwork.starCount)
      ed.showToast(T("\232\181\160\233\128\129\230\136\144\229\138\159"))
      self:removeUpdateHandler("long_click_button_down")
      self:destroy({skipAnim = false})
    end
  end)
  self:listenEvent("dragonBoatGiveReply", function(info)
    info = ed.copyProto(info)
    if info._result and info._result == "success" then
      ed.player:consumeEquip(self.itemId, ed.ActivityNetwork.starCount)
      ed.showToast(T("\232\181\160\233\128\129\230\136\144\229\138\159"))
      self:removeUpdateHandler("long_click_button_down")
      self:destroy({skipAnim = false})
    end
  end)
end
