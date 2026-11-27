local class = newclass()
ed.ui.equipcraft = class
local lsr = ed.ui.equipcraftlsr.create()
ed.oneTimeCraftID = {}
local chestIdOfEquipId = {}

local function getChestIdOfEquipId()
  local chestcombinationtable = ed.getDataTable("ChestCombination")
  for chestId, chest in pairs(chestcombinationtable) do
    if chest.IsChooseBox then
      for k, equipId in ipairs(chest["Item Set"]) do
        if not chestIdOfEquipId[equipId] then
          chestIdOfEquipId[equipId] = {}
        end
        local isHave = false
        for i, v in ipairs(chestIdOfEquipId[equipId]) do
          if chest["Item Id"] and v == chest["Item Id"] then
            isHave = true
            break
          end
        end
        if not isHave and chest["Item Id"] and chest["Item Id"] > 0 then
          table.insert(chestIdOfEquipId[equipId], chest["Item Id"])
        end
      end
    end
  end
end

getChestIdOfEquipId()
ed.chestIdOfEquipId = chestIdOfEquipId

local function checkMoneyEnough(self)
  local cost = self.craftWindow.expense or 0
  local money = ed.player._money
  return cost <= money
end

class.checkMoneyEnough = checkMoneyEnough
local normalColor = ccc3(254, 241, 169)
local pressColor = ccc3(150, 150, 150)
local priorityBase = -299
local scope = {}

local function isShow(self)
  if self.mainLayer then
    return self.mainLayer:isVisible(), true
  else
    return false, false
  end
end

class.isShow = isShow

local function refreshCliprect(self)
  local function handler()
    if tolua.isnull(self.actionLayer) then
      self:endRefreshCliprect()
      
      return
    end
    if self.equipLayer.draglist then
      self.equipLayer.draglist:refreshClipRect(self.actionLayer:getScale())
    end
  end
  
  return handler
end

class.refreshCliprect = refreshCliprect

local function beginRefreshCliprect(self)
  ed.getCurrentScene():registerUpdateHandler("refreshCliprectBoard", self:refreshCliprect())
end

class.beginRefreshCliprect = beginRefreshCliprect

local function endRefreshCliprect(self)
  ed.getCurrentScene():removeUpdateHandler("refreshCliprectBoard")
end

class.endRefreshCliprect = endRefreshCliprect

local function show(self)
  lsr:report("createWindow")
  local frame = self.actionLayer
  frame:setScale(0)
  frame:runAction(CCEaseBackOut:create(CCScaleTo:create(0.2, 1)))
  self:beginRefreshCliprect()
end

class.show = show

local function destroy(self)
  lsr:report("closeWindow")
  local a = CCArray:create()
  local action = CCScaleTo:create(0.2, 0)
  action = CCEaseBackIn:create(action)
  local delay = CCDelayTime:create(0.1)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if self.m_parentScene then
        self.m_parentScene:destroyWindow(self)
      else
        self.mainLayer:removeFromParentAndCleanup(true)
        self.mainLayer = nil
      end
      if self.callback then
        if self.putonSuccessful then
          self.callback("equip")
        else
          self.callback("update")
        end
      end
    end, EDDebug)
  end)
  a:addObject(action)
  a:addObject(delay)
  a:addObject(func)
  local s = CCSequence:create(a)
  if not tolua.isnull(self.actionLayer) then
    self.actionLayer:runAction(s)
  end
  EnqueueDelayProcess(function()
    CloseScope(scope)
  end)
  if self.destroyHandler then
    self.destroyHandler()
  end
end

class.destroy = destroy

function class:doQuickOpenChestTouch()
  local isPress
  
  local function handler(event, x, y)
    local button = self.quickGetButton
    if not button then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(button, x, y) then
        self:quickGetEquip()
      end
      isPress = nil
    end
  end
  
  return handler
end

function class:doComposeButtonTouch()
  local isPress
  
  local function handler(event, x, y)
    local button = self.equipLayer.ui.icon_compose
    if not button then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(button, x, y) then
        if self.isOpen then
          self:closeCraftPanel()
          self.isCrafting = false
        elseif self.isOpenChest then
          self:closeChestPanel()
          self.isOpenChest = false
          self.isCrafting = false
        else
          if self.draglist and not tolua.isnull(self.draglist.layer) then
            self.draglist.mainLayer:removeAllChildrenWithCleanup(true)
            self.draglist = nil
          end
          self:openCraftPanel()
        end
        self.mainLayer:setTouchEnabled(false)
        ListenTimer(Timer:Once(0.5), function()
          if not tolua.isnull(self.mainLayer) then
            self.mainLayer:setTouchEnabled(true)
          end
        end)
      end
      isPress = nil
    end
  end
  
  return handler
end

local function doMainLayerTouch(self)
  local infoButtonTouch = self:doInfoButtonTouch()
  local outLayerTouch = self:doOutLayerTouch()
  local treeNodeTouch = self:doTreeNodeTouch()
  local craftButtonTouch = self:doCraftButtonTouch()
  local quickInfoButtonTouch = self:doQuickInfoButtonTouch()
  local quickOpenChestTouch = self:doQuickOpenChestTouch()
  local composeButtonTouch = self:doComposeButtonTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      for k, v in pairs(self.equipLayer.touchHandlers) do
        v(event, x, y)
      end
      infoButtonTouch(event, x, y)
      outLayerTouch(event, x, y)
      treeNodeTouch(event, x, y)
      craftButtonTouch(event, x, y)
      quickInfoButtonTouch(event, x, y)
      quickOpenChestTouch(event, x, y)
      if self.composeIcon then
        composeButtonTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function enterPVP(id)
  local scene = ed.ui.stageselect.createByStage(id)
  ed.pushScene(scene)
end

local function doGetWayTouch(self)
  self.stageid = nil
  local scale = 1
  local event = event
  
  local function handler(x, y)
    if not self.isOpen then
      return
    end
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    for i = 1, #buttons do
      local button = buttons[i]
      if ed.containsPoint(button, x, y) then
        self.stageid = i
        scale = button:getScale()
        button:setScale(scale * 0.95)
        break
      end
    end
    return self.stageid
  end
  
  return handler
end

class.doGetWayTouch = doGetWayTouch

local function doGetWayTouch2(self)
  local scale = 1
  local event = event
  
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    if self.stageid then
      buttons[self.stageid]:setScale(scale)
      if ed.containsPoint(buttons[self.stageid], x, y) then
        self:clickGetWay(self.getWayData[self.stageid])
      end
    end
    self.stageid = nil
  end
  
  return handler
end

class.doGetWayTouch2 = doGetWayTouch2

local function doOutLayerTouch(self)
  local isPress
  local rect1 = CCRectMake(ed.display.winSize.width / 2 - 118, ed.display.halfFixedHeight + 85, 230, 375)
  local rect2 = CCRectMake(ed.display.winSize.width / 2 - 300, ed.display.halfFixedHeight + 85, 550, 375)
  
  local function handler(event, x, y)
    local rect
    if self.isOpenChest then
      rect = rect2
    elseif not self.isOpen then
      rect = rect1
    else
      rect = rect2
    end
    if event == "began" then
      if not rect:containsPoint(ccp(x, y)) then
        if not self.quickGetMan or ed.containsPoint(self.quickGetMan, x, y) then
        end
        isPress = true
      end
    elseif event == "ended" then
      if isPress and not rect:containsPoint(ccp(x, y)) and not self.isCrafting then
        if self.quickGetMan and self.quickGetMan:isVisible() and ed.containsPoint(self.quickGetMan, x, y) then
          if self.isOpenChest then
            self.isOpenChest = false
            self.isOpen = true
            self.craftWindow.mainLayer:setVisible(true)
            self.quickChestWindow.mainLayer:setVisible(false)
            self.quickChestWindow.mainLayer:removeFromParentAndCleanup(true)
          else
            self.isOpen = false
            self.isOpenChest = true
            self.craftWindow.mainLayer:setVisible(false)
            self:openQuickChestPanel(true)
          end
          if self.isOpenChest then
            self.quickGetMan.icon:stopAllActions()
            self.quickGetMan.label:stopAllActions()
            self.quickGetMan.label:setOpacity(255)
            self.quickGetMan.icon:setOpacity(255)
            ed.setString(self.quickGetMan.label, T("\229\144\136\230\136\144"))
            ed.setTexture(self.quickGetMan.icon, "UI/alpha/1080P/hero/equip/equip_fragment_button.png")
            self.equipLayer:showItemRefresh(self.currentId)
          else
            self.equipLayer:showItemRefresh()
            ed.setString(self.quickGetMan.label, T("\233\128\137\230\139\169\231\174\177"))
            ed.setTexture(self.quickGetMan.icon, "UI/alpha/1080P/hero/equip/equip_chest_button.png")
          end
        else
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doOutLayerTouch = doOutLayerTouch

local function doClickInfoButton(self)
  if self.context == "guildhero" then
    self:destroy()
    return
  end
  if self:getAmount() > 0 and not self.isEquiped then
    if ed.getMillionTime() - (self.TPclickPuton or 0) > 0.5 then
      lsr:report("clickWearEquip")
      self.TPclickPuton = ed.getMillionTime()
      self:putonEquip()
    end
  elseif self:getAmount() == 0 and not self.isEquiped and not self.isOpen then
    lsr:report("clickOpenCraftLayer")
    self:openCraftPanel()
  elseif self.isEquiped then
    lsr:report("clickWearEquip")
    self:destroy()
  else
    lsr:report("clickWearEquip")
  end
end

class.doClickInfoButton = doClickInfoButton

local function doInfoButtonTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if self.isForbidInfoButton then
      return
    end
    local button = self.infoButton
    local press = self.infoButtonPress
    local label = self.infoButtonLabel
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
        ed.setLabelColor(label, pressColor)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        ed.setLabelColor(label, normalColor)
        if ed.containsPoint(self.infoButton, x, y) then
          self:doClickInfoButton()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doInfoButtonTouch = doInfoButtonTouch

local function doClickCraftButton(self)
  lsr:report("clickCraftButton")
  local components = self.components
  if components == 0 then
    self.craftWindow.mainLayer1:setVisible(false)
    if self.historyid > 1 then
      self:setHistory(self.historyid - 1)
    else
      self:closeCraftPanel()
      if 0 < self:getAmount() and self.context == "herodetail" then
        ed.setString(self.infoButtonLabel, T("\232\163\133\229\164\135"))
        ed.setLabelColor(self.infoButtonLabel, normalColor)
      else
        ed.setString(self.infoButtonLabel, T("\232\142\183\229\190\151\233\128\148\229\190\132"))
        ed.setLabelColor(self.infoButtonLabel, normalColor)
      end
    end
  else
    self.craftWindow.mainLayer1:setVisible(true)
    self:craftEquip()
  end
  self:showQuickGetManIcon()
end

class.doClickCraftButton = doClickCraftButton

local function doCraftButtonTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if not self.isOpen then
      return
    end
    if self.isForbidCraftButton then
      return
    end
    if not ed.containsPoint(self.tree.craftButton, x, y) then
      return
    end
    local ui = self.tree
    local button = ui.craftButton
    local shade = ui.craftButtonPress
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(0.9)
        shade:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        button:setScale(1)
        shade:setVisible(false)
        if ed.containsPoint(button, x, y) and not self.isCrafting then
          self:doClickCraftButton()
        end
      end
      isPress = false
    end
  end
  
  return handler
end

class.doCraftButtonTouch = doCraftButtonTouch

local function doTreeNodeTouch(self)
  local id
  
  local function handler(event, x, y)
    if self.isCrafting or not self.isOpen then
      return
    end
    local nodes = self.tree.children or {}
    if event == "began" then
      for i = 1, #nodes do
        if ed.containsPoint(nodes[i], x, y) and self.craftWindow.nodeAmount[i] < 10000 then
          id = i
          self.clickTreeElementScale = nodes[i]:getScale()
          nodes[i]:setScale(self.clickTreeElementScale * 0.95)
        end
      end
    elseif event == "ended" then
      self.craftWindow.nodeid = self.craftWindow.nodeid or {}
      if id then
        if ed.containsPoint(nodes[id], x, y) then
          lsr:report("clickTreeNode")
          if ed.player:needReqEnableStages() then
            local id_former = id
            ed.registerNetReply("query_act_stage_equipcraft", function(data)
              self.currentNodeAmount = self.craftWindow.nodeAmount[id_former]
              self.getWayItemNeed = self.craftWindow.nodeNeed[id_former]
              ed.player:setEnableStages(data)
              self:setHistory(0, self.craftWindow.nodeid[id_former])
              self:createCraftTree(self.craftWindow.nodeid[id_former])
              self.getWayItemId = self.craftWindow.nodeid[id_former]
            end)
            local entryStage = ed.ui.exerciseres.entry_stage
            local stageIds = {}
            for k, v in pairs(entryStage) do
              table.insert(stageIds, v)
            end
            local msg = ed.upmsg.query_act_stage()
            ed.send(msg, "query_act_stage")
          else
            self.currentNodeAmount = self.craftWindow.nodeAmount[id]
            self.getWayItemNeed = self.craftWindow.nodeNeed[id]
            self:setHistory(0, self.craftWindow.nodeid[id])
            self:createCraftTree(self.craftWindow.nodeid[id])
            self.getWayItemId = self.craftWindow.nodeid[id]
          end
        end
        if nodes[id] then
          nodes[id]:setScale(self.clickTreeElementScale)
        end
      end
      id = nil
    end
  end
  
  return handler
end

class.doTreeNodeTouch = doTreeNodeTouch

function class:doQuickInfoButtonTouch()
  local isPress
  
  local function handler(event, x, y)
    if self.isForbidInfoButton then
      return
    end
    local button = self.quickInfoButton
    local press = self.quickInfoButtonPress
    local label = self.quickInfoButtonLabel
    if event == "began" then
      if self.forbidQuickInfoButton then
        return
      end
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
        ed.setLabelColor(label, pressColor)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        ed.setLabelColor(label, normalColor)
      end
      isPress = nil
    end
  end
  
  return handler
end

function class:errorReply()
  local function handler()
    self.isCrafting = nil
    
    CloseScope(scope)
  end
  
  return handler
end

local function hasMaxAmount(id)
  return ed.player:hasMaxAmount(id)
end

local function upCraft(self)
  local cw = self.craftWindow
  if self.craftCategory == T("\231\162\142\231\137\135\229\144\136\230\136\144") then
    local fid = cw.nodeid[1]
    local famount = cw.nodeNeed[1]
    local makeid = ed.readequip.getComposedID(cw.nodeid[1])
    if hasMaxAmount(makeid) then
      ed.showToast(T("\231\137\169\229\147\129\229\183\178\232\190\190\230\156\128\229\164\167\230\149\176\233\135\143\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\227\128\130"))
      return
    end
    self.oneTimeCraft = false
    ListenEvent("NetworkError", self:errorReply(), scope)
    ed.netdata.fragmentCompose = {
      id = fid,
      fragmentAmount = famount,
      cost = cw.expense,
      makeId = makeid
    }
    ed.netreply.composeFragmentReply = self:craftReply()
    local msg = ed.upmsg.fragment_compose()
    msg._fragment = makeid
    msg._frag_amount = cw.nodeNeed[1]
    msg._compose_amount = 1
    ed.send(msg, "fragment_compose")
  elseif hasMaxAmount(self.craftid) then
    ed.showToast(T("\231\137\169\229\147\129\229\183\178\232\190\190\230\156\128\229\164\167\230\149\176\233\135\143\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\227\128\130"))
    return false
  else
    ListenEvent("NetworkError", self:errorReply(), scope)
    if self.craftCategory == T("\228\184\128\233\148\174\229\144\136\230\136\144") then
      local cs = self.oneTimeConsume
      local nodeid = {}
      local nodeNeed = {}
      local index = 1
      for k, v in pairs(cs) do
        nodeid[index] = k
        nodeNeed[index] = v
        index = index + 1
      end
      ed.netdata.equipCraft = {
        immediate = false,
        id = self.craftid,
        node = nodeid,
        consume = nodeNeed,
        expense = self.oneTimeExpense
      }
      ed.netreply.craftReply = self:oneTimeCraftReply()
    else
      self.oneTimeCraft = false
      ed.netdata.equipCraft = {
        immediate = true,
        id = self.craftid,
        node = cw.nodeid,
        consume = cw.nodeNeed,
        expense = cw.expense
      }
      ed.netreply.craftReply = self:craftReply()
    end
    local msg = ed.upmsg.equip_synthesis()
    msg._equip_id = self.craftid
    ed.send(msg, "equip_synthesis")
  end
  return true
end

class.upCraft = upCraft

function class:artifactRewardsReply()
  local function handler(items)
    local items = items or {}
    
    if type(items) == "table" and next(items) == nil then
      return
    end
    local itemtb = {}
    for i = 1, #items do
      local item = items[i]
      local itemInfo = ed.analyzeItem(item)
      local id = itemInfo.id
      local amount = itemInfo.amount
      ed.player:addEquip(id, amount)
      table.insert(itemtb, {
        id = id,
        type = "item",
        amount = amount
      })
    end
    ed.announce({
      type = "getProp",
      priority = -1,
      param = {
        title = T("\232\163\133\229\164\135\233\153\132\233\173\148\232\191\148\232\191\152"),
        items = itemtb
      }
    })
  end
  
  return handler
end

local function createNeedCraftPrompt(self)
  local cw = self.craftWindow
  local ui = self.tree
  local showNeed
  if not ed.isElementInTable(self.craftCategory, {
    T("\231\162\142\231\137\135\229\144\136\230\136\144")
  }) then
    for i = 1, #cw.nodeAmount do
      if cw.nodeAmount[i] < cw.nodeNeed[i] and ed.isEquipCraftable(cw.nodeid[i]) then
        if tolua.isnull(ui.prompt) then
          local promptBg = ed.createSprite("UI/alpha/1080P/common/craft_promt_bg.png")
          local x, y = ui.children[i]:getPosition()
          promptBg:setAnchorPoint(ccp(0.5, 0))
          promptBg:setPosition(ccp(x, y + 20))
          ui.prompt = promptBg
          ui.layer:addChild(promptBg, 10)
          promptBg:setCascadeOpacityEnabled(true)
          local promptLabel = ed.createttf(T("\233\156\128\232\166\129\229\133\136\229\144\136\230\136\144\232\191\153\228\187\182\232\163\133\229\164\135"), 17)
          local size = promptBg:getContentSize()
          local plSize = promptLabel:getContentSize()
          promptLabel:setPosition(ccp(size.width / 2, size.height / 2 + 5))
          promptBg:addChild(promptLabel)
          promptLabel:limitSizeByScale(size.width - 10, size.height)
          local a = CCArray:create()
          a:addObject(CCDelayTime:create(1))
          a:addObject(CCFadeOut:create(0.5))
          a:addObject(CCCallFunc:create(function()
            xpcall(function()
              if not tolua.isnull(ui.prompt) then
                ui.prompt:removeFromParentAndCleanup(true)
                ui.prompt = nil
              end
            end, EDDebug)
          end))
          local s = CCSequence:create(a)
          promptBg:runAction(s)
        end
        showNeed = true
        break
      end
    end
  end
  if not showNeed then
    ed.showToast(T("\230\178\161\230\156\137\229\144\136\233\128\130\231\154\132\230\157\144\230\150\153\239\188\140\229\142\187\230\148\182\233\155\134\228\184\128\228\186\155\229\134\141\230\157\165\229\144\167"), ccp(545, 280))
  end
end

class.createNeedCraftPrompt = createNeedCraftPrompt

local function craftEquip(self)
  local cw = self.craftWindow
  local ui = self.tree
  if self.lackOfComponent then
    self:createNeedCraftPrompt()
    lsr:report("clickCraftButtonDisenabled")
    return
  end
  if not self:checkMoneyEnough() then
    ed.showHandyDialog("useMidas", {
      refreshHandler = self:checkExpenseHandler(),
      priority = priorityBase - 1
    })
    lsr:report("clickCraftButtonDisenabled")
    return
  end
  lsr:report("clickCraftButton")
  if self.isCrafting then
    return
  end
  self.up = {}
  self.up.id = self.craftid
  self.up.nodeid = cw.nodeid
  local bCraft = self:upCraft()
  self.isCrafting = bCraft or false
end

class.craftEquip = craftEquip

local function oneTimeCraftReply(self)
  local function handler(reply)
    if not self then
      return
    end
    if reply then
      self.rootid = self.craftid
      self:forbidInfoButton(true)
      self:iterCraft()
    else
      lsr:report("craftFailed")
      ed.showToast(T("\229\144\136\230\136\144\229\164\177\232\180\165"), ccp(545, 280))
    end
  end
  
  return handler
end

class.oneTimeCraftReply = oneTimeCraftReply

local function iterCraft(self)
  local cw = self.craftWindow
  self.iterid = {}
  for i = 1, #cw.nodeAmount do
    if cw.nodeAmount[i] < cw.nodeNeed[i] then
      table.insert(self.iterid, cw.nodeid[i])
    end
  end
  local callid = self.iterid[1]
  if #self.iterid > 0 then
    local f = CCCallFunc:create(function()
      xpcall(function()
        self:setHistory(0, callid)
        self:createCraftTree(callid, nil, true)
        table.remove(self.iterid, 1)
      end, EDDebug)
    end)
    self.mainLayer:runAction(f)
  else
    local d = CCDelayTime:create(0.5)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self:playCraftEffect()
      end, EDDebug)
    end)
    self.mainLayer:runAction(CCSequence:createWithTwoActions(d, f))
    if self.rootid == self.craftid then
      ed.oneTimeCraftID = {}
      self:forbidInfoButton(false)
      self.isCrafting = false
      self.oneTimeCraft = false
      local data = ed.netdata.equipCraft
      if data then
        ed.player:addMoney(-data.expense)
        local na = data.consume
        for k, v in pairs(data.node) do
          ed.player:consumeEquip(v, na[k] or 1)
        end
        ed.player:addEquip(data.id)
        FireEvent("composeActivity")
      end
      self.equipLayer:refreshAmount()
    end
  end
end

class.iterCraft = iterCraft

local function updateOneTimeCraft(self)
  local cw = self.craftWindow
  local id = ed.oneTimeCraftID
  for i = 1, #cw.nodeid do
    id[cw.nodeid[i]] = (id[cw.nodeid[i]] or 0) - cw.nodeNeed[i]
  end
  id[self.craftid] = (id[self.craftid] or 0) + 1
  if self.rootid ~= self.craftid then
    self:setHistory(self.historyid - 1, nil, true)
  end
end

class.updateOneTimeCraft = updateOneTimeCraft

function class:createShopButton()
  local layer = CCLayer:create()
  local button = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/shop_assistant_boss.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310, 200)
    }
  }, layer)
  local press = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/shop_assistant_boss.png"
    },
    layout = {
      position = ed.getCenterPos(button)
    },
    config = {visible = false}
  }, button)
  local isPress
  layer:registerScriptTouchHandler(function(event, x, y)
    if tolua.isnull(button) or not self.isOpen then
      return
    end
    if event == "began" then
      isPress = nil
      if ed.checkVisible(button) and ed.containsPoint(button, x, y) then
        press:setVisible(true)
        isPress = true
        button:setScale(0.95)
        return true
      end
    elseif event == "ended" and isPress then
      press:setVisible(false)
      button:setScale(1)
      xpcall(function()
        if ed.containsPoint(button, x, y) and not self.isCrafting then
          self:doClickShopButton()
        end
      end, EDDebug)
      return true
    end
    return false
  end, false, -600, true)
  layer:setTouchEnabled(true)
  self.shopLayer = layer
  if not tolua.isnull(self.craftWindow.mainLayer) then
    self.craftWindow.mainLayer:addChild(layer)
  end
end

function class:doClickShopButton()
  local shopsSaleEquip = ed.ui.ShopsSaleEquip.create({
    ids = self.buyIds,
    callBack = function(item)
    end
  })
  ed.getCurrentScene():ccScene():addChild(shopsSaleEquip.mainLayer, 350)
end

local function craftReply(self)
  local function handler(reply)
    if not self then
      return
    end
    if reply then
      self:playCraftEffect()
    else
      lsr:report("craftFailed")
      ed.showToast(T("\229\144\136\230\136\144\229\164\177\232\180\165"), ccp(545, 280))
    end
  end
  
  return handler
end

class.craftReply = craftReply

local function playCraftEffect(self)
  self.setCallback = nil
  if self.tree == nil then
    return
  end
  local endPos = ccp(145, 248)
  for k, v in pairs(self.tree.children) do
    local amount = self.craftWindow.nodeNeed[k]
    local dt = 0
    for i = 1, math.min(amount, 5) do
      local element = ed.readequip.createSmallIcon(self.craftWindow.nodeid[k])
      element:setPosition(ccp(v:getPosition()))
      self.tree.layer:addChild(element, 5)
      local array = CCArray:create()
      dt = 0.05 * (i - 1)
      local delay = CCDelayTime:create(dt)
      local move = CCEaseOut:create(CCMoveTo:create(0.2, endPos), 2.5)
      local fade = CCFadeOut:create(0.1)
      local remove = CCCallFunc:create(function()
        xpcall(function()
          element:removeFromParentAndCleanup(true)
        end, EDDebug)
      end)
      array:addObject(delay)
      array:addObject(move)
      array:addObject(fade)
      if not self.setCallback then
        array:addObject(CCCallFunc:create(function()
          xpcall(function()
            self:refreshReplyData()
            local oneTimeCraft = self.oneTimeCraft
            self:createCraftTree(self.craftid, true)
            lsr:report("craftSuccess")
            if self.up.id == self.id then
              if self.context == "herodetail" and (not (self.context ~= "herodetail" or oneTimeCraft) or oneTimeCraft and self.rootid == self.craftid) then
                self:playPutonEffect()
                ed.showToast(T("\229\144\136\230\136\144\230\136\144\229\138\159"), ccp(545, 280))
              end
            else
              ed.showToast(T("\229\144\136\230\136\144\230\136\144\229\138\159"), ccp(545, 280))
              self.isCrafting = false
            end
            if oneTimeCraft == true then
              if self.historyid > 1 then
                self:updateOneTimeCraft()
              end
            elseif (self.context == "herodetail" or self.context == "petdetail") and self.historyid > 1 then
              self:setHistory(self.historyid - 1)
            end
            if not oneTimeCraft then
              self.isCrafting = false
            end
          end, EDDebug)
        end))
        self.setCallback = true
      end
      array:addObject(remove)
      local sequence = CCSequence:create(array)
      element:runAction(sequence)
    end
  end
  local rootPos = ccp(145, 248)
  local nodeAbove = ed.createFcaNode("eff_UI_craft_above")
  nodeAbove:setScale(1.75)
  local nodeBelow = ed.createFcaNode("eff_UI_craft_below")
  nodeBelow:setPosition(rootPos)
  nodeBelow:setScale(1.75)
  nodeAbove:setPosition(rootPos)
  local bs = ed.getCurrentScene()
  ed.getCurrentScene():addFcaOnce(nodeBelow)
  ed.getCurrentScene():addFcaOnce(nodeAbove)
  self.tree.layer:addChild(nodeBelow)
  self.tree.layer:addChild(nodeAbove, 5)
end

class.playCraftEffect = playCraftEffect

local function playPutonEffect(self)
  if self.hasPlayPutonEffect or self.isEquiped then
    return
  end
  local hlv, elv = self:getJudgeLevel()
  if hlv < elv then
    return
  end
  local node = ed.createSprite("UI/alpha/1080P/hero/equip/equip_button_light.png")
  node:setScale(0.6)
  node:setPosition(ccp(130, 50))
  self.equipLayer.ui.frame:addChild(node)
  local fo = CCFadeOut:create(1)
  local fi = CCFadeIn:create(1)
  local s = CCSequence:createWithTwoActions(fo, fi)
  s = CCRepeatForever:create(s)
  node:runAction(s)
  self.hasPlayPutonEffect = true
end

class.playPutonEffect = playPutonEffect

local function refreshReplyData(self)
  if self.up.id == self.id and self.context == "herodetail" then
    self.infoButtonRemark:setVisible(true)
    if not self.oneTimeCraft or self.oneTimeCraft and self.rootid == self.craftid then
      local hlv, elv = self:getJudgeLevel()
      if elv <= hlv then
        self:forbidInfoButton(false)
      end
    end
    self.equipLayer:refreshAmount()
  end
end

class.refreshReplyData = refreshReplyData

local function getJudgeLevel(self)
  local hid = self.hid
  local eid = self.id
  local canWear, hlv, elv = ed.canWearEquip(hid, eid, self.hero._level)
  return hlv, elv
end

class.getJudgeLevel = getJudgeLevel

local function putonEquip(self)
  local hlv, elv = self:getJudgeLevel()
  if hlv < elv then
    ed.showToast(T("\233\156\128\230\177\130\232\139\177\233\155\132\231\173\137\231\186\167\239\188\154%d", elv))
    return
  end
  ed.netdata.putonReply = {
    hid = self.hid,
    sid = {
      self.sid
    },
    eid = {
      self.id
    }
  }
  ed.netreply.putonReply = self:putonReply()
  ed.netreply.artifactRewardsReply = self:artifactRewardsReply()
  local msg = ed.upmsg.wear_equip()
  msg._hero_id = self.hid
  msg._item_pos = {
    self.sid
  }
  ed.send(msg, "wear_equip")
end

class.putonEquip = putonEquip

local function putonPetEquip(self)
  ed.PetNetwork:wearPetEquipment(self.hid, self.sid, self.id)
  ed.netreply.putonPetReply = self:putonReply()
end

class.putonPetEquip = putonPetEquip

local function putonReply(self)
  local function handler(isSuccessful)
    if not self then
      return
    end
    if isSuccessful then
      self.putonSuccessful = true
    end
    self:destroy()
  end
  
  return handler
end

class.putonReply = putonReply

local function openCraftPanel(self, isSkipAnim)
  self.isOpen = true
  local label = self.infoButtonLabel
  ed.setString(label, T("\232\163\133\229\164\135"))
  if self:getAmount() == 0 or self.isEquiped then
    ed.setLabelColor(label, pressColor)
    self:forbidInfoButton(true)
  end
  self:createCraftWindow(isSkipAnim)
  self:showQuickGetManIcon()
end

class.openCraftPanel = openCraftPanel

local function showQuickGetManIcon(self)
  if self:isNeedQuickGetMan(self.currentId) then
    if not self.quickGetMan then
      local bg = ed.createSprite("UI/alpha/1080P/hero/bg_btn1.png")
      local quickGetman = ed.createSprite("UI/alpha/1080P/hero/equip/equip_chest_button.png")
      local label = ed.createttf(T("\233\128\137\230\139\169\231\174\177"), 15)
      label:limitWidthByScale(75)
      ed.setLabelColor(label, ccc3(255, 252, 231))
      ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
      bg:addChild(quickGetman)
      bg:addChild(label)
      quickGetman:setPosition(ccp(26, 30))
      label:setPosition(ccp(26, 7))
      bg:setPosition(ed.display.winSize.width / 2 + 310, 140)
      self.actionLayer:addChild(bg, 1)
      self.quickGetMan = bg
      self.quickGetMan.icon = quickGetman
      self.quickGetMan.label = label
      self.quickGetMan:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
        CCCallFunc:create(function()
          if not self.isOpenChest then
            self.quickGetMan.icon:runAction(CCFadeTo:create(0.9, 255 - self.quickGetMan.icon:getOpacity()))
            self.quickGetMan.label:runAction(CCFadeTo:create(0.9, 255 - self.quickGetMan.label:getOpacity()))
          end
        end),
        CCDelayTime:create(1)
      })))))
    else
      self.quickGetMan:setVisible(true)
      ed.setTexture(self.quickGetMan.icon, "UI/alpha/1080P/hero/equip/equip_chest_button.png")
      ed.setString(self.quickGetMan.label, T("\233\128\137\230\139\169\231\174\177"))
    end
    self.equipLayer:showItemRefresh()
  elseif self.quickGetMan then
    self.equipLayer:showItemRefresh()
    self.quickGetMan:setVisible(false)
  end
end

class.showQuickGetManIcon = showQuickGetManIcon

local function openQuickChestPanel(self, isSkipAnim)
  self.isOpenChest = true
  local label = self.infoButtonLabel
  ed.setString(label, T("\232\163\133\229\164\135"))
  ed.setLabelColor(label, pressColor)
  self:forbidInfoButton(true)
  self:createQuickChestWindow(isSkipAnim)
end

class.openQuickChestPanel = openQuickChestPanel

local function closeCraftPanel(self)
  self:initHistory()
  self:initTree()
  self.isOpen = false
  if self.context == "herodetail" or self.context == "petdetail" then
    self:forbidInfoButton(false)
    local text = self:getButtonText()
    ed.setString(self.infoButtonLabel, text)
  end
  local ll = self.equipLayer.ui.frame
  local rl = self.craftWindow.mainLayer
  local mr = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  ll:runAction(CCEaseElasticOut:create(mr, 5))
  local ml = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2 + 20, ed.display.winSize.height / 2))
  local func = CCCallFunc:create(function()
    xpcall(function()
      rl:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  rl:setZOrder(0)
  local s = CCSequence:createWithTwoActions(CCEaseOut:create(ml, 5), func)
  rl:runAction(s)
  if self.quickGetMan then
    self.equipLayer:showItemRefresh()
    self.quickGetMan:setVisible(false)
  end
  CloseScope(self.scope)
end

class.closeCraftPanel = closeCraftPanel

local function closeChestPanel(self)
  self:initHistory()
  self:initTree()
  self.isOpen = false
  if self.context == "herodetail" or self.context == "petdetail" then
    self:forbidInfoButton(false)
    local text = self:getButtonText()
    ed.setString(self.infoButtonLabel, text)
  end
  local ll = self.equipLayer.ui.frame
  local rl = self.quickChestWindow.mainLayer
  local mr = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  ll:runAction(CCEaseElasticOut:create(mr, 5))
  local ml = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2 + 20, ed.display.winSize.height / 2))
  local func = CCCallFunc:create(function()
    xpcall(function()
      rl:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  rl:setZOrder(0)
  local s = CCSequence:createWithTwoActions(CCEaseOut:create(ml, 5), func)
  rl:runAction(s)
  if self.quickGetMan then
    self.equipLayer:showItemRefresh()
    self.quickGetMan:setVisible(false)
  end
  CloseScope(self.scope)
end

class.closeChestPanel = closeChestPanel

function class:getButtonText()
  local text = T("\232\163\133\229\164\135")
  if self.isEquiped then
    if ed.readequip.getMaxLevel(self.id) <= 1 or self.level == ed.readequip.getMaxLevel(self.id) then
      text = T("\231\161\174\229\174\154")
    else
      text = T("\231\161\174\229\174\154")
    end
    self.equipLayer:refreshAmount(true)
  elseif self:getAmount() == 0 then
    if not self.isOpen then
      if self:getComponents() == 0 then
        text = T("\232\142\183\229\190\151\233\128\148\229\190\132")
      else
        text = T("\229\144\136\230\136\144\229\133\172\229\188\143")
      end
    else
      text = T("\232\163\133\229\164\135")
    end
  end
  return text
end

local function createInfoButton(self, state)
  local text, rv
  self.equipLayer:refreshAmount()
  if self.context == "herodetail" then
    text = T("\232\163\133\229\164\135")
    rv = true
    if self.isEquiped then
      if ed.readequip.getMaxLevel(self.id) <= 1 or self.level == ed.readequip.getMaxLevel(self.id) then
        rv = true
        text = T("\231\161\174\229\174\154")
      else
        rv = true
        text = T("\231\161\174\229\174\154")
      end
      self.equipLayer:refreshAmount(true)
    elseif self:getAmount() == 0 then
      if not self.isOpen then
        if self:getComponents() == 0 then
          text = T("\232\142\183\229\190\151\233\128\148\229\190\132")
        else
          text = T("\229\144\136\230\136\144\229\133\172\229\188\143")
        end
      else
        text = T("\232\163\133\229\164\135")
        self:forbidInfoButton(true)
      end
    else
      self:forbidInfoButton(false)
    end
  end
  local remarkText = T("\232\163\133\229\164\135\229\144\142\228\188\154\228\184\142\232\175\165\232\139\177\233\155\132\231\187\145\229\174\154")
  local remarkColor = ed.toccc3(7037275)
  local labelPos = ccp(130, 48)
  local labelSize = 16
  if self.context == "herodetail" then
    local hlv, elv = self:getJudgeLevel()
    if hlv < elv then
      remarkText = T("\233\156\128\230\177\130\232\139\177\233\155\132\231\173\137\231\186\167\239\188\154%d", elv)
      remarkColor = ed.toccc3(16739436)
    end
    if self.isEquiped then
      remarkText = T("\233\156\128\230\177\130\232\139\177\233\155\132\231\173\137\231\186\167\239\188\154%d", elv)
    end
  end
  if not tolua.isnull(self.infoContainer) then
    self.infoContainer:removeFromParentAndCleanup(true)
    self.infoContainer = nil
  end
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(0, 0))
  self.infoContainer = container
  self.equipLayer.ui.frame:addChild(container)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "infoButtonRemark",
        text = remarkText,
        size = 14
      },
      layout = {
        position = ccp(130, 80)
      },
      config = {color = remarkColor, visible = rv}
    },
    {
      t = "Sprite",
      base = {
        name = "infoButton",
        res = "UI/alpha/1080P/common/buttion_big.png"
      },
      layout = {
        position = ccp(130, 48)
      },
      config = {
        scalexy = {x = 0.6, y = 0.6}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "infoButtonPress",
        res = "UI/alpha/1080P/common/buttion_big.png"
      },
      layout = {
        position = ccp(130, 48)
      },
      config = {
        visible = false,
        scalexy = {x = 0.6, y = 0.6}
      }
    },
    {
      t = "Label",
      base = {
        name = "infoButtonLabel",
        text = text,
        size = labelSize
      },
      layout = {position = labelPos},
      config = {
        color = ed.toccc3(16182231),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(1, 0)
        }
      }
    }
  }
  local readNode = ed.readnode.create(container, self)
  readNode:addNode(ui_info)
  ed.adaptLabel(self.infoButtonRemark, {maxWidth = 230, minScale = 0.8})
  if self.context == "herodetail" and self:getAmount() == 0 and self.isOpen then
    self:forbidInfoButton(true)
  end
end

class.createInfoButton = createInfoButton

local function initHistory(self)
  self.history = nil
  self.historyid = nil
end

class.initHistory = initHistory

local function doPressInHistory(self)
  local function handler(x, y)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    for i = 1, #(hst or {}) do
      local icon = hst[i].iconBg
      print(ed.checkVisible(icon))
      if ed.containsPoint(icon, x, y) then
        icon:setScale(osc * 0.95)
        return i
      end
    end
  end
  
  return handler
end

class.doPressInHistory = doPressInHistory

local function doClickInHistory(self)
  local function handler(x, y, id)
    if self.isCrafting or not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
    if ed.containsPoint(icon, x, y) then
      lsr:report("clickHistoryNode")
      local delay = CCDelayTime:create(0)
      local func = CCCallFunc:create(function()
        xpcall(function()
          self:setHistory(id)
        end, EDDebug)
      end)
      local s = CCSequence:createWithTwoActions(delay, func)
      self.mainLayer:runAction(s)
    end
  end
  
  return handler
end

class.doClickInHistory = doClickInHistory

local function cancelPressInHistory(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
  end
  
  return handler
end

class.cancelPressInHistory = cancelPressInHistory

local function cancelClickInHistory(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
  end
  
  return handler
end

class.cancelClickInHistory = cancelClickInHistory

local function createHistoryLayer(self)
  if self.draglist and not tolua.isnull(self.draglist.layer) then
    return self.draglist.listLayer
  end
  local config = {
    cliprect = CCRectMake(12, 300, 265, 80),
    container = self.craftWindow.mainLayer,
    zorder = 100,
    priority = priorityBase - 1,
    noshade = true,
    doClickIn = self:doClickInHistory(),
    cancelClickIn = self:cancelClickInHistory(),
    doPressIn = self:doPressInHistory(),
    cancelPressIn = self:cancelPressInHistory()
  }
  self.draglist = ed.draglist.create(config)
  return self.draglist.listLayer
end

class.createHistoryLayer = createHistoryLayer

local function setHistoryListWidth(self, width)
  local lw = 265
  local pw = self.draglist.listWidth
  local ll = self.draglist.listLayer
  local px, py = ll:getPosition()
  self.draglist:initListWidth(width)
  ll:setPosition(px, py)
  if width > lw then
    ll:stopAllActions()
    local move = CCMoveTo:create(0.2, ccp(lw - width, 0))
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  else
    ll:stopAllActions()
    local move = CCMoveTo:create(0.2, ccp(0, 0))
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  end
end

class.setHistoryListWidth = setHistoryListWidth

local function setHistory(self, index, id, oneTimeCraftInfo)
  self.history = self.history or {}
  index = index or 0
  local hst = self.history
  local cw = self.craftWindow
  local ori = ccp(55, 353)
  local offsetX = 66
  local len = #self.history
  local cursor
  local container = self:createHistoryLayer()
  if index == 0 or index > len then
    self.historyid = len + 1
    local iconBg, icon = ed.readequip.createIcon(id)
    iconBg:setScale(0.6)
    iconBg:setPosition(ori.x + offsetX * len, ori.y)
    self.hstIconScale = iconBg:getScale()
    local arrow
    if 0 < len then
      arrow = ed.createSprite("UI/alpha/1080P/hero/equip/equip_fragment_arrow.png")
      arrow:setPosition(ori.x + offsetX * (len - 0.5), ori.y)
    end
    local element = {
      id = id,
      iconBg = iconBg,
      icon = icon,
      arrow = arrow
    }
    hst[len + 1] = element
    if arrow then
      container:addChild(arrow)
    end
    container:addChild(iconBg)
    local action = CCFadeIn:create(0.5)
    iconBg:runAction(action)
    cursor = len + 1
    self:setHistoryListWidth(ori.x + offsetX * len + 30)
  elseif index <= len then
    self.historyid = index
    for i = index + 1, len do
      hst[i].iconBg:removeFromParentAndCleanup(true)
      if hst[i].arrow then
        hst[i].arrow:removeFromParentAndCleanup(true)
      end
      hst[i] = nil
    end
    self:createCraftTree(hst[index].id, nil, oneTimeCraftInfo)
    cursor = index
    local x = hst[index].iconBg:getPositionX()
    self:setHistoryListWidth(x + 30)
  end
  if tolua.isnull(self.historyCursor) then
    local tag = ed.createSprite("UI/alpha/1080P/hero/equip/equip_fragment_choose.png")
    self.historyCursor = tag
    container:addChild(tag, 10)
  end
  self.historyCursor:setPosition(ccp(ori.x + offsetX * (cursor - 1), ori.y - 4))
end

class.setHistory = setHistory

local function fadeTreeElement(self, element, isClear)
  if isClear then
    local fade = CCFadeOut:create(0.1)
    local func = CCCallFunc:create(function()
      xpcall(function()
        element:removeFromParentAndCleanup(true)
        self:fadeTreeLayer(false)
      end, EDDebug)
    end)
    local s = CCSequence:createWithTwoActions(fade, func)
    element:runAction(s)
  else
    local action = CCFadeIn:create(0.3)
    element:runAction(action)
  end
end

class.fadeTreeElement = fadeTreeElement

local function fadeTreeLayer(self, isClear)
  if not self.tree then
    return
  end
  local container = self.tree.layer
  self:fadeTreeElement(container, isClear)
  if isClear then
    self.tree = {}
  end
end

class.fadeTreeLayer = fadeTreeLayer

local function initTree(self, id)
  self.tree = nil
end

class.initTree = initTree
local lineres = {
  {
    res = "UI/alpha/HVGA/fragment_compose_arrow.png",
    rotation = -90
  },
  {
    res = "UI/alpha/HVGA/equip_craft_2.png"
  },
  {
    res = "UI/alpha/HVGA/equip_craft_3.png"
  },
  {
    res = "UI/alpha/HVGA/equip_craft_4.png"
  }
}
local tree_ui_info = {
  {
    t = "Label",
    base = {
      name = "name",
      text = "",
      size = 18
    },
    layout = {
      position = ccp(147, 311)
    },
    config = {
      color = ccc3(254, 211, 109)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "craftButton",
      res = "UI/alpha/1080P/common/button_com_mini.png"
    },
    layout = {
      position = ccp(147, 47)
    }
  },
  {
    t = "Sprite",
    base = {
      name = "craftButtonPress",
      res = "UI/alpha/1080P/common/button_com_mini.png"
    },
    layout = {
      position = ccp(147, 47)
    },
    config = {visible = false}
  }
}
local childrenPos = {
  {
    ccp(147, 135)
  },
  {
    ccp(127, 135),
    ccp(167, 135)
  },
  {
    ccp(107, 135),
    ccp(147, 135),
    ccp(187, 135)
  },
  {
    ccp(87, 135),
    ccp(127, 135),
    ccp(167, 135),
    ccp(207, 135)
  }
}

local function createCraftTree(self, id, skipAnim, isOneTimeCraft)
  self.currentId = id
  self:clearCraftTree(skipAnim)
  self:showQuickGetManIcon()
  local cw = self.craftWindow
  local layer = cw.mainLayer
  local components, row = self:initCraftTreeData(id)
  if self.tree.layer then
    self.tree.layer:removeAllChildrenWithCleanup(true)
  end
  local tree = CCSprite:create()
  self.tree.layer = tree
  tree:setCascadeOpacityEnabled(true)
  layer:addChild(tree)
  local labelOffset = -30
  local readNode = ed.readnode.create(tree, self.tree)
  readNode:addNode(tree_ui_info)
  local name = ed.getDataTable("equip")[id].Name
  self.tree.name:setString(name)
  local rootBg
  if components == 0 then
    rootBg = CCSprite:create()
    self.craftWindow.mainLayer1:setVisible(false)
  else
    self.craftWindow.mainLayer1:setVisible(true)
    rootBg = ed.readequip.createIcon(id)
    rootBg:setScale(0.8)
  end
  rootBg:setPosition(ccp(146, 251))
  self.tree.rootBg = rootBg
  tree:addChild(rootBg, 1)
  local expense
  local can, exp, onetime, totalconsume = ed.isEquipCraftable(id, true)
  local curIdCanOnetime = can and onetime
  if 0 < components then
    expense = self:createComponentsTree(id, row, lineres, childrenPos, isOneTimeCraft, readNode)
  else
    self:createUnComponentsTree(tree, rootBg, id)
  end
  self:createCraftLabel(components, tree, exp, totalconsume, curIdCanOnetime)
  if curIdCanOnetime then
    self.oneTimeCraft = true
  end
  if expense then
    if expense > ed.player._money then
      self:forbidCraftButton(false)
    end
    for i = 1, #cw.nodeAmount do
      if cw.nodeAmount[i] < cw.nodeNeed[i] and not curIdCanOnetime then
        self:forbidCraftButton(false)
        self.lackOfComponent = true
        break
      end
    end
  end
  if not skipAnim then
    tree:setOpacity(0)
  end
  if isOneTimeCraft then
    self.oneTimeCraft = isOneTimeCraft
    self:iterCraft()
  end
end

class.createCraftTree = createCraftTree

local function createComponentChild(self, components, row, isOneTimeCraft, childrenPos)
  local tree = self.tree.layer
  local cw = self.craftWindow
  for i = 1, components do
    local id = row["Component" .. i]
    if self.context ~= "petdetail" and (self.context == "superawaketask" or ed.player:withHeroSuperTask("working", self.hid)) and i == 1 and id == 0 then
      id = ed.getHeroTaskCsvEquipid(self.hid)
    end
    local need = math.max(row[string.format("Component%d Count", i)] or 1, 1)
    cw.nodeNeed[i] = need
    cw.nodeid[i] = id
    if i == 1 then
      cw.nodeRepeat[i] = 0
    end
    for j = 1, i - 1 do
      if cw.nodeid[j] == cw.nodeid[i] then
        cw.nodeRepeat[i] = (cw.nodeRepeat[i] or 0) + need
      else
        cw.nodeRepeat[i] = 0
      end
    end
    cw.nodeAmount[i] = ed.player.equip_qunty[cw.nodeid[i]] or 0
    if isOneTimeCraft then
      for k, v in pairs(ed.oneTimeCraftID) do
        if k == cw.nodeid[i] then
          cw.nodeAmount[i] = cw.nodeAmount[i] + v
          break
        end
      end
    end
    if 0 >= cw.nodeAmount[i] - cw.nodeRepeat[i] then
      cw.nodeAmount[i] = 0
    end
    local childBg = ed.readequip.createIcon(id)
    childBg:setScale(0.44)
    childBg:setPosition(childrenPos[i])
    self.tree.children[i] = childBg
    tree:addChild(childBg)
    local autoText = ed.ui.autoText.new()
    local text
    if cw.nodeAmount[i] < cw.nodeNeed[i] then
      text = string.format("<lable color=ccc3(255,108,108)>%d</lable>/%d", cw.nodeAmount[i], cw.nodeNeed[i])
    else
      text = string.format("%d/%d", cw.nodeAmount[i], cw.nodeNeed[i])
    end
    autoText:initParam({
      context = text,
      fontSize = 16,
      color = ccc3(255, 251, 231)
    })
    local width, height = autoText:getCurContentSize()
    autoText.node:setPosition(ccp(childrenPos[i].x - width / 2, childrenPos[i].y - 27))
    tree:addChild(autoText.node)
  end
end

class.createComponentChild = createComponentChild

local function createCompoentCost(self, row, curIdCanOnetime, exp)
  local expense
  local tree = self.tree.layer
  local cw = self.craftWindow
  local costBg = ed.createSprite("")
  costBg:setPosition(142, 86)
  self.tree.costBg = costBg
  tree:addChild(costBg)
  local costTitle
  if curIdCanOnetime then
    costTitle = ed.createttf(T(""), 18)
  else
    costTitle = ed.createttf(T(""), 18)
  end
  ed.setLabelColor(costTitle, ccc3(202, 108, 60))
  costTitle:setPosition(ccp(100, 85))
  self.tree.costTitle = costTitle
  tree:addChild(costTitle)
  if curIdCanOnetime then
    expense = exp
  else
    expense = row.Expense
  end
  expense = expense or 99999999
  local cost = ed.createttf("" .. expense, 16)
  print(expense, ed.player._money)
  if expense <= (ed.player._money or 0) then
    ed.setLabelColor(cost, ccc3(192, 117, 16))
  else
    ed.setLabelColor(cost, ccc3(255, 0, 0))
  end
  cost:setPosition(ccp(155, 78))
  cw.expense = expense
  self.tree.cost = cost
  tree:addChild(cost)
  local coinImg = ed.createSprite("UI/alpha/1080P/common/goldicon_small.png")
  self.tree.coinImg = coinImg
  ed.left2(coinImg, cost)
  tree:addChild(coinImg)
  return expense
end

class.createCompoentCost = createCompoentCost

local function createComponentsTree(self, id, row, lineres, childrenPos, isOneTimeCraft, readNode)
  local expense
  local cw = self.craftWindow
  local components = self.components
  local tree = self.tree.layer
  local can, exp, onetime, totalconsume = ed.isEquipCraftable(id, true)
  local curIdCanOnetime = can and onetime
  cw.nodeid = {}
  cw.nodeRepeat = {}
  cw.nodeAmount = {}
  cw.nodeNeed = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {name = "trunk", res = ""},
      layout = {
        position = ccp(142, 187)
      }
    }
  }
  readNode:addNode(ui_info)
  childrenPos = childrenPos[components]
  self.tree.children = {}
  self.tree.amountLabel = {}
  self:createComponentChild(components, row, isOneTimeCraft, childrenPos)
  expense = self:createCompoentCost(row, curIdCanOnetime, exp)
  self.lackOfComponent = false
  return expense
end

class.createComponentsTree = createComponentsTree

function class:clickGetWay(data)
  if data.state ~= "Normal" then
    return
  end
  if data.type == "stage" then
    ed.stageSelectParam = {noBottomButton = true}
    local panel = ed.ui.stagedetail.create(data.id, {
      getWayItemId = self.getWayItemId,
      getWayItemNeed = self.getWayItemNeed
    }):popWindow()
    ed.stageSelectParam = nil
  elseif data.type == "summon" then
    ed.summonMgr.noBottomButton = true
    ed.UITool.openView("summonScene")
  elseif data.type == "skillTower" then
    ed.UITool.openView("SkillTowerStageScene", data.id)
  elseif data.type == "shop" then
    ed.UITool.openView("shopMain", {
      page = data.id
    })
  elseif data.type == "heroExercise" then
    ed.exerciseManager:openExerciseMainScene()
  elseif data.type == "task" then
    ed.UITool.openView("taskScene", {})
  elseif data.type == "awakeDungeon" then
    ed.UITool.openView("awakeDungeonScene")
  end
end

function class:createGetWayItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "Normal" then
    readnode:addNode(ed.uieditor.accessNormalItem)
  elseif data.state == "Special" then
    readnode:addNode(ed.uieditor.accessSpecialItem)
  else
    readnode:addNode(ed.uieditor.accessLockItem)
    ui.label_lock:setHorizontalAlignment(kCCTextAlignmentCenter)
    ed.adaptLabel(ui.label_lock, {
      maxWidth = 50,
      minScale = 0.7,
      maxHeight = 60
    })
  end
  ed.setString(ui.label_info, data.name)
  ed.adaptLabel(ui.label_info, {maxWidth = 160, minScale = 0.7})
  return container, ui
end

function class:createEquipGetWay(getway)
  local tree = self.tree.layer
  self.specailGetWay = self.specailGetWay or {}
  local oy = 290
  local ox = 146
  local dy = 48
  
  local function getPos(i)
    return ccp(ox, oy - dy * i + 23)
  end
  
  for k, v in ipairs(getway or {}) do
    local container, ui = self:createGetWayItem(v)
    ui.data = v
    self.getWayButton[k] = ui.bg
    self.getWayData[k] = v
    self.draglistBG:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglistBG:initListHeight(dy * #getway)
end

function class:createDraglist(tree)
  local container = CCSprite:create()
  self.tree.container = container
  container:setCascadeOpacityEnabled(true)
  tree:addChild(container)
  local info = {
    cliprect = CCRectMake(10.5, 76, 274, 210),
    container = container,
    priority = priorityBase - 1,
    noshade = true,
    doPressIn = self:doGetWayTouch(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doGetWayTouch2(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglistBG = ed.draglist.create(info)
  self.draglistBG:setTouchEnabled(true)
  local layer = self.draglistBG:getList()
  self.draglistHeight = 0
end

function class:createUnComponentsTree(tree, rootBg, id)
  self:createDraglist(tree)
  local getway = ed.packageGetWay(id)
  self:createEquipGetWay(getway)
end

function class:clearCraftTree(skipAnim)
  if not skipAnim then
    self:fadeTreeLayer(true)
  elseif self.tree and not tolua.isnull(self.tree.layer) then
    self.tree.layer:removeFromParentAndCleanup(true)
  end
  self.tree = {}
  self.getWayButton = {}
  self.specailGetWay = {}
  self.si = 1
end

function class:initCraftTreeData(id)
  local components, category
  local row = ed.getDataTable("equipcraft")[id]
  if row then
    components = row.Components
    category = row.Category
  else
    components = 0
  end
  components = components or 0
  self.craftid = id
  self.components = components
  self.craftCategory = category
  return components, row
end

function class:createCraftLabel(components, tree, exp, totalconsume, curIdCanOnetime)
  local text = ""
  if components < 1 then
    text = T("\232\191\148\229\155\158")
  elseif curIdCanOnetime then
    text = T("\228\184\128\233\148\174\229\144\136\230\136\144")
    self.oneTimeExpense = exp
    self.oneTimeConsume = totalconsume
    self.craftCategory = text
    self.lackOfComponent = false
  else
    text = T("\229\144\136\230\136\144")
  end
  local craftLabel = ed.createttf(text, 16)
  craftLabel:setPosition(ccp(147, 47))
  ed.setLabelColor(craftLabel, normalColor)
  self.tree.craftLabel = craftLabel
  tree:addChild(craftLabel)
end

local function createStageDetailIcon(self, board, res, enable, fixheight)
  local stage = ed.createSprite(res)
  stage:setPosition(ccp(35, 25))
  if enable == false then
    ed.setSpriteGray(stage)
  end
  fixheight = fixheight or 58
  stage:setScale(fixheight / stage:getContentSize().height)
  board:addChild(stage)
  return stage
end

class.createStageDetailIcon = createStageDetailIcon

local function createStageDetailName(self, board, name, enable)
  local name = ed.createttf(name, 18)
  if enable == false then
    ed.setLabelColor(name, ccc3(173, 156, 131))
  else
    ed.setLabelColor(name, ccc3(182, 65, 21))
  end
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(ccp(68, 12))
  board:addChild(name)
  return name
end

class.createStageDetailName = createStageDetailName

local function createStageDetailTitle(self, board, title, enable)
  local title = ed.createttf(title, 18)
  if enable == false then
    ed.setLabelColor(title, ccc3(173, 156, 131))
  else
    ed.setLabelColor(title, ccc3(182, 65, 21))
  end
  title:setAnchorPoint(ccp(0, 1))
  title:setPosition(ccp(65, 44))
  board:addChild(title)
  return title
end

class.createStageDetailTitle = createStageDetailTitle

local function createEliteTitle(board, title)
  local elite = ed.createttf(T("\231\178\190\232\139\177"), 18)
  ed.setLabelColor(elite, ccc3(255, 0, 0))
  elite:setAnchorPoint(ccp(0, 0.5))
  elite:setPosition(ccp(75 + title:getContentSize().width, 35))
  board:addChild(elite)
  return elite
end

local function getStageName(id)
  local row = ed.getDataTable("Stage")[id]
  if id < 20000 then
    return T("\194\183\231\172\172%d\231\171\160", row["Chapter ID"])
  elseif 20000 < id and id < 30000 then
    return T("\194\183" .. row["Stage Name"])
  end
end

local function createStageDetail(self, board, stageinfo, iconRes)
  local difficultyRoman = {
    [0] = "I",
    [1] = "II",
    [2] = "III",
    [3] = "IV",
    [4] = "V",
    [5] = "VI",
    [6] = "VII",
    [7] = "VIII",
    [8] = "IX",
    [9] = "X"
  }
  local ui = {}
  local stageTable = ed.getDataTable("Stage")
  local id = stageinfo.wayid
  local row
  local isElite = 10000 < id and id < 20000
  if id < 10000 then
    row = stageTable[id]
  else
    local gid = stageTable[id]["Stage Group"]
    row = stageTable[gid]
  end
  if iconRes then
    ui.stage = self:createStageDetailIcon(board, iconRes, stageinfo.enable)
  end
  local title = getStageName(id)
  title = self:createStageDetailTitle(board, title, stageinfo.enable)
  ui.title = title
  if isElite then
    ui.elite = createEliteTitle(board, title)
  end
  local name = row["Stage Name"]
  if stageinfo.start_id then
    name = T("\233\154\190\229\186\166") .. difficultyRoman[stageinfo.start_id]
    if stageinfo.end_id then
      name = name .. T("-\233\154\190\229\186\166") .. difficultyRoman[stageinfo.end_id]
    end
  end
  ui.name = self:createStageDetailName(board, name, stageinfo.enable)
end

class.createStageDetail = createStageDetail

local function setListLayerHeight(self, lh, num)
  local ll = self.draglistBG:getList()
  local x, y = ll:getPosition()
  self.draglistBG:initListHeight(lh)
  y = 3 < num and (num - 3) * 50 or y
  local ep = ccp(x, y)
  ll:setPosition(ep)
end

class.setListLayerHeight = setListLayerHeight

local function doPressInList(self)
  local handler = self:doGetWayTouch()
  return handler
end

class.doPressInList = doPressInList

local function cancelPressInList(self)
  local scale = 1
  local event = event
  
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    if self.stageid then
      buttons[self.stageid]:setScale(scale)
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function cancelClickInList(self)
  local function handler(x, y, id)
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

local function checkExpenseHandler(self)
  local function handler()
    if self:checkMoneyEnough() then
      ed.setLabelColor(self.tree.cost, ccc3(192, 117, 16))
    else
      ed.setLabelColor(self.tree.cost, ccc3(255, 0, 0))
    end
  end
  
  return handler
end

class.checkExpenseHandler = checkExpenseHandler

function class:createChest(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.chooseBoxItem)
  ed.setString(ui.name, ed.getDataTable("equip")[data.chestId].Name)
  ed.setLabelStroke(ui.name, ed.toccc3(2565412), 1)
  local str = string.format("<lable color=ccc3(107,97,91)>" .. T("\230\140\129\230\156\137:") .. "</lable><lable color=ccc3(44,82,167)>%d</lable>", data.total)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({context = str, fontSize = 16})
  local width = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(64.5 - width / 2, 28.75))
  ui.bg:addChild(autoText.node)
  local icon = ed.readequip.createIcon(data.chestId)
  icon:setScale(0.8)
  local x, y = ui.mask:getPosition()
  icon:setPosition(ccp(x, y))
  ui.bg:addChild(icon)
  if not ed.isAreaZh() then
    ui.bg:setScale(1.4)
    ui.name:limitWidthByScale(ui.bg:getContentSize().width * 0.9)
  end
  return container, ui
end

local function refreshQuickBoxDraglist(self)
  self.quickBoxDraglist:clearList()
  
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
    return ccp(x, y)
  end
  
  local uiList = {}
  if #self.chestList == 1 then
    local container, ui = self:createChest(self.chestList[1])
    ui.index = 1
    container:setPosition(ccp(136.5, 121))
    self.quickBoxDraglist:addItem(container)
    table.insert(uiList, ui)
  else
    for k, v in ipairs(self.chestList) do
      local container, ui = self:createChest(self.chestList[k])
      ui.index = k
      container:setPosition(getPos(k))
      self.quickBoxDraglist:addItem(container)
      table.insert(uiList, ui)
    end
  end
  self.uiList = uiList
end

class.refreshQuickBoxDraglist = refreshQuickBoxDraglist

function class:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.bg, x, y) then
        return item
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, item)
    self.selectIndex = item.index
    
    for k, v in ipairs(self.uiList or {}) do
      v.mask:setVisible(k == self.selectIndex)
    end
  end
  
  return handler
end

function class:initData(params)
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

function class:quickGetEquip()
  if self.useNum == 0 then
    return
  end
  ListenEventOnce("equipcraftUseChestSuccess", function(result)
    if result == "success" then
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
      self.equipLayer:refreshAmount()
      self:forbidInfoButton(false)
      if self.isOpenChest then
        self.isOpenChest = false
        self.isOpen = true
        self.craftWindow.mainLayer:setVisible(true)
        self.quickChestWindow.mainLayer:setVisible(false)
        self.quickChestWindow.mainLayer:removeFromParentAndCleanup(true)
        self.quickChestWindow = nil
        if self.historyid > 1 then
          self:setHistory(self.historyid - 1)
        end
      end
      self:showQuickGetManIcon()
    else
      ed.showToast(T("\229\188\128\229\144\175\229\164\177\232\180\165"))
    end
  end, scope)
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

local function createQuickChestWindow(self, isSkipAnim)
  if not tolua.isnull(self.shopLayer) then
    self.shopLayer:setVisible(false)
  end
  local chests = {}
  local equipId = self.currentId
  for k, chestId in ipairs(chestIdOfEquipId[equipId] or {}) do
    if 0 < (ed.player.equip_qunty[chestId] or 0) then
      table.insert(chests, chestId)
    end
  end
  self:initData({
    equipId = equipId,
    chests = chests,
    state = 1,
    needNum = 1,
    config = self.config,
    parent = self
  })
  local container, ui = ed.editorui(ed.uieditor.quickChooseBox)
  if not ed.isAreaZh() then
    ui.left:setVisible(false)
    ui.right:setVisible(false)
  end
  self.quickBoxDraglist = ed.UITool.createDraglist(ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler()
  })
  self:refreshQuickBoxDraglist()
  for k, v in ipairs(self.uiList or {}) do
    v.mask:setVisible(k == self.selectIndex)
  end
  self.quickGetButton = ui.btn_ok
  self.quickChestWindow = {}
  self.quickChestWindow.mainLayer = container
  self.quickChestWindow.mainLayer:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  self.actionLayer:addChild(container)
  if isSkipAnim then
    self.equipLayer.ui.frame:setPosition(ccp(ed.display.winSize.width / 2 - 148, ed.display.winSize.height / 2))
    self.quickChestWindow.mainLayer:setPosition(ccp(ed.display.winSize.width / 2 + 128, ed.display.winSize.height / 2))
    self.quickChestWindow.mainLayer:setZOrder(2)
  else
    local ml = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2 - 148, ed.display.winSize.height / 2))
    ml = CCEaseElasticOut:create(ml, 5)
    local mr = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2 + 128, ed.display.winSize.height / 2))
    mr = CCEaseElasticOut:create(mr, 5)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.quickChestWindow.mainLayer:setZOrder(2)
      end, EDDebug)
    end)
    self.equipLayer.ui.frame:runAction(ml)
    self.quickChestWindow.mainLayer:runAction(CCSequence:createWithTwoActions(mr, func))
  end
end

class.createQuickChestWindow = createQuickChestWindow

local function createCraftWindow(self, isSkipAnim)
  if not tolua.isnull(self.shopLayer) then
    self.shopLayer:setVisible(false)
  end
  local equipId = self.id
  local components, row = self:initCraftTreeData(equipId)
  local bg, bg1
  bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_1.png", CCRectMake(25, 20, 50, 350))
  bg1 = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_2.png", CCRectMake(25, 20, 50, 350))
  bg1:setContentSize(CCSizeMake(294, 387))
  bg1:setPosition(147, 193.5)
  local deco = ed.createSprite("UI/alpha/1080P/hero/equip/equip_fragment_bg_1.png")
  deco:setPosition(ccp(146, 175))
  bg1:addChild(deco)
  bg:addChild(bg1)
  bg:setContentSize(CCSizeMake(294, 387))
  bg:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  local topbg = ed.createSprite("UI/alpha/1080P/hero/equip/equip_fragment_bg_2.png")
  topbg:setPosition(ccp(147, 338))
  bg:addChild(topbg)
  self.craftWindow = {}
  self.craftWindow.mainLayer = bg
  self.craftWindow.mainLayer1 = bg1
  self.actionLayer:addChild(bg)
  self:createCraftTree(equipId)
  self.tree.layer:setOpacity(255)
  self:setHistory(0, equipId)
  if isSkipAnim then
    self.equipLayer.ui.frame:setPosition(ccp(ed.display.winSize.width / 2 - 148, ed.display.winSize.height / 2))
    self.craftWindow.mainLayer:setPosition(ccp(ed.display.winSize.width / 2 + 128, ed.display.winSize.height / 2))
    self.craftWindow.mainLayer:setZOrder(2)
  else
    local ml = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2 - 148, ed.display.winSize.height / 2))
    ml = CCEaseElasticOut:create(ml, 5)
    local mr = CCMoveTo:create(0.2, ccp(ed.display.winSize.width / 2 + 128, ed.display.winSize.height / 2))
    mr = CCEaseElasticOut:create(mr, 5)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.craftWindow.mainLayer:setZOrder(2)
      end, EDDebug)
    end)
    self.equipLayer.ui.frame:runAction(ml)
    self.craftWindow.mainLayer:runAction(CCSequence:createWithTwoActions(mr, func))
  end
end

class.createCraftWindow = createCraftWindow

local function isNeedQuickGetMan(self, equipid)
  if self.context == "herodetail" then
    if equipid ~= self.id and self.currentNodeAmount and self.getWayItemNeed and self.currentNodeAmount >= self.getWayItemNeed then
      return false
    end
    if equipid == self.id and 0 < (ed.player.equip_qunty[equipid] or 0) then
      return false
    end
    if chestIdOfEquipId[equipid] then
      for k, chestId in ipairs(chestIdOfEquipId[equipid]) do
        if 0 < (ed.player.equip_qunty[chestId] or 0) then
          return true
        end
      end
    end
  end
  return false
end

class.isNeedQuickGetMan = isNeedQuickGetMan

local function createPanel(self, equipid, level)
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, self.priority or priorityBase, true)
  local actionLayer = CCLayer:create()
  self.actionLayer = actionLayer
  mainLayer:addChild(actionLayer)
  local equipLayer = ed.ui.equipboard.init("ofcraft", {
    id = equipid,
    hero = self.hero,
    level = level,
    sid = self.sid,
    context = self.context
  })
  self.equipLayer = equipLayer
  actionLayer:addChild(equipLayer.ui.frame, 1)
  mainLayer:registerScriptHandler(function(event)
    xpcall(function()
      if event == "enter" then
        self:createInfoButton()
        FireEvent(ed.guide.eventNames.OPEN_VIEW, self)
      elseif event == "cleanup" then
        FireEvent(ed.guide.eventNames.CLOSE_VIEW, self)
      end
    end, EDDebug)
  end)
  self:show()
  self.scope = {}
  ListenEvent("ResourceNumChange", function(resType, id)
    if resType == "item" and id == equipid then
      print("ResourceNumChange", resType, id)
      self.equipLayer:refreshAmount()
      self:forbidInfoButton(false)
    end
  end, self.scope)
end

class.createPanel = createPanel

local function create(config)
  local self = {}
  setmetatable(self, class.mt)
  config = config or {}
  self.config = config
  self.context = config.context
  self.identity = "equipboardofcraft"
  self.getWayData = {}
  self.priority = config.priority
  self.id = config.eid
  self.level = config.level
  self.isEquiped = config.isEquiped
  self.hid = config.hid
  self.sid = config.sid
  self.callback = config.callback
  self.composeIcon = config.composeIcon
  self.hero = config.hero or ed.player.heroes[self.hid]
  self.isOpen = false
  self:createPanel(self.id, self.level)
  if self.composeIcon then
    self.equipLayer.ui.icon_compose:setVisible(true)
  else
    self.equipLayer.ui.icon_compose:setVisible(false)
  end
  return self
end

class.create = create

local function getAmount(self)
  return ed.player.equip_qunty[self.id] or 0
end

class.getAmount = getAmount

local function getComponents(self)
  local row = ed.getDataTable("equipcraft")[self.id]
  if row then
    return row.Components
  else
    return 0
  end
end

class.getComponents = getComponents

local function forbidInfoButton(self, forbid)
  local label = self.infoButtonLabel
  if ed.player.equip_qunty[self.id] and ed.player.equip_qunty[self.id] > 0 then
    ed.setLabelColor(label, normalColor)
    ed.setTexture(self.infoButton, "UI/alpha/1080P/common/buttion_big.png")
    self.isForbidInfoButton = false
    return
  end
  if self.currentId and (forbid or self.currentId ~= self.id) or forbid and not self.currentId then
    ed.setLabelColor(label, pressColor)
    ed.setTexture(self.infoButton, "UI/alpha/1080P/common/button_big_grey.png")
    self.isForbidInfoButton = true
    return
  else
    if self.isEquiped and self.isOpen then
      return
    end
    ed.setLabelColor(label, normalColor)
    ed.setTexture(self.infoButton, "UI/alpha/1080P/common/buttion_big.png")
  end
  self.isForbidInfoButton = forbid
end

class.forbidInfoButton = forbidInfoButton

local function forbidCraftButton(self, forbid)
  local label = self.tree.craftLabel
  local button = self.tree.craftButton
  if forbid then
    ed.setLabelColor(label, pressColor)
    ed.setTexture(button, "UI/alpha/1080P/common/button_mini_grey.png")
  else
    ed.setLabelColor(label, normalColor)
    ed.setTexture(button, "UI/alpha/1080P/common/button_com_mini.png")
  end
  self.isForbidCraftButton = forbid
end

class.forbidCraftButton = forbidCraftButton

local function popWindow(self, z)
  z = z or 300
  ed.getCurrentScene():popWindow(self, z)
end

class.popWindow = popWindow

function class:onWinDestroy()
end

setimplements(class, ed.guide.interface)

function class:getGuideNode(nodeKey)
  return self[nodeKey]
end
