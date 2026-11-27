local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloBookWin = class

function class.create(param)
  local self = base.create("SoloBookWin")
  setmetatable(self, class.mt)
  self:initData(param or {})
  self:initUI()
  self:refreshPage()
  self:registerEvents()
  return self
end

function class:initData(param)
  self.index = param.index or 1
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloBookWin, {
    container = self.container,
    ui = self.ui
  })
  self:initPage1()
  self:initPage2()
  self:initPage3()
  self.ui["btn_page_selected_" .. self.index]:setVisible(true)
end

function class:refreshPage()
  for i = 1, 3 do
    self.ui["Panel_page_" .. i]:setVisible(self.index == i)
    self["pageDraglist" .. i]:setVisible(self.index == i)
  end
  self["refreshPage" .. self.index](self)
  self.refreshCliprectConfig = {
    draglist = self["pageDraglist" .. self.index]
  }
end

function class:registerEvents()
  for i = 1, 3 do
    self:btRegisterButtonClick({
      button = self.ui["btn_page_" .. i],
      selected = self.ui["btn_page_selected_" .. i],
      key = "btn_page_selected_group_" .. i,
      radioGroupName = "btn_page_selected_group",
      clickHandler = function(param, x, y)
        self.index = i
        self:refreshPage()
      end
    })
  end
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.95})
end

function class:initPage1()
  self.type = 1
  self.star = 1
  ed.UITool.registerBtn(self, "ImageView_568", function()
    self.ui.switch_bg:setVisible(not self.ui.switch_bg:isVisible())
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_lower", function()
    self.star = math.max(1, self.star - 1)
    self:refreshPage1()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_increase", function()
    self.star = math.min(5, self.star + 1)
    self:refreshPage1()
  end, {pressScale = 0.95})
  self.pageDraglist1 = ed.UITool.createDraglist(self.ui.Panel_item_1)
  local selected = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/solobook/selectbox_1.png",
    pos = ccp(0, 0),
    parent = self.ui.switch_bg
  })
  local data = {}
  for i, v in ipairs(ed.getDataTable("SoloCardTag")) do
    if v.Online then
      table.insert(data, v)
    end
  end
  local width, heigh = 100, 36
  local posY = 133
  local lan = math.ceil(#data / 2)
  if 4 < lan then
    lan = lan - 4
    lan = lan * heigh
    self.ui.switch_bg:setContentSize(CCSizeMake(210.5, 156.5 + lan))
    self.ui.switch_bg:setPositionY(107.5 - lan / 2)
    posY = posY + lan
  end
  self.openId = {
    [0] = true
  }
  for i, v in ipairs(data) do
    local posX = (i % 2 == 0 and 2 or i % 2) * width - width / 2
    ed.createSpriteTools({
      res = v["Tag Icon"],
      pos = ccp(posX - 25, posY),
      parent = self.ui.switch_bg,
      scale = 0.42
    })
    self.ui["btn_SoloCardTag_" .. i] = ed.createLabelTools({
      txt = v.Name,
      size = 14,
      pos = ccp(posX - 5, posY),
      color = ccc3(ed.colorToStr("#fffce7")),
      parent = self.ui.switch_bg,
      anchor = ccp(0, 0.5),
      stroke = {
        ccc3(ed.colorToStr("#2c1e06")),
        1.3
      }
    })
    posY = i % 2 == 0 and posY - heigh or posY
    ed.UITool.registerBtn(self, "btn_SoloCardTag_" .. i, function()
      self.type = v.ID
      local x, y = self.ui["btn_SoloCardTag_" .. i]:getPosition()
      selected:setPosition(x + 8, y)
      self:refreshPage1()
    end, {pressScale = 0.95})
    self.openId[v.ID] = true
  end
  local x, y = self.ui["btn_SoloCardTag_" .. self.type]:getPosition()
  selected:setPosition(x + 8, y)
end

function class.getFactionAutoText(str, attr)
  local att
  for i, v in ipairs(attr) do
    if att then
      att = att .. "\227\128\129" .. v
    else
      att = v
    end
  end
  str = string.gsub(str, "%%CardTag&Star Bonus 1%%", att)
  str = string.gsub(str, "#p#", "%%")
  return T("\230\181\129\230\180\190\230\152\159\231\186\167\229\138\160\230\136\144\239\188\154%s", str)
end

function class:refreshPage1()
  self.ui.switch_bg:setVisible(false)
  local cardTb = ed.getDataTable("SoloCardTag")[self.type]
  ed.setTexture(self.ui.ImageView_570, cardTb["Tag Icon"])
  self.ui.Label_select:setString(cardTb.Name)
  self.ui.Label_575:setString(T("%s\230\152\159", self.star))
  self.pageDraglist1:clearList()
  local Description = self.getFactionAutoText(cardTb.Description, cardTb["Star Bonus 1"])
  local cardTb = ed.getDataTable("SoloCardSkill")
  local cardList = {}
  for k, v in ipairs(cardTb) do
    if (v.Tag1 == self.type or v.Tag2 == self.type) and self.openId[v.Tag1] and self.openId[v.Tag2] then
      table.insert(cardList, v)
    end
  end
  table.sort(cardList, function(a, b)
    return a.Quality > b.Quality
  end)
  local thisCon = self.ui.Panel_item_1:getContentSize()
  local width, heigh = 153, 210
  local posY = thisCon.height
  for i, v in ipairs(cardList) do
    local posX = (i % 5 == 0 and 5 or i % 5) * width - width / 2
    local level = ed.clamp(self.star, 1, v["Max Level"])
    local container, ui = ed.ui.SoloUITool.createCardItem(v.ID, level, false)
    ui.bg:setScale(0.73)
    container:setPosition(ccp(posX, posY - heigh / 2))
    self.pageDraglist1:addItem(container)
    posY = i % 5 == 0 and posY - heigh or posY
  end
  self.pageDraglist1:initListHeight(math.ceil(#cardList / 5) * heigh + 10, false)
  if self.detaillabel then
    self.detaillabel.node:removeFromParentAndCleanup(true)
  end
  local detaillabel = ed.ui.autoText.new()
  detaillabel:initParam({
    context = Description,
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = 390,
    color = ed.toccc3(16776423)
  })
  self.ui.Panel_page_1:addChild(detaillabel.node, 99)
  local w, h = detaillabel:getCurContentSize()
  detaillabel.node:setPosition(-60, h / 2 - 12 + 215)
  self.detaillabel = detaillabel
end

function class:initPage2()
  self.pageDraglist2 = ed.UITool.createDraglist(self.ui.Panel_item_2, {
    doPressIn = function(x, y)
      for _, item in ipairs(self.heroUIList or {}) do
        if ed.containsPoint(item.icon, x, y) then
          return item
        end
      end
    end,
    doClickIn = function(x, y, item)
      self.hid = item.id
      self.heroSelect:setPosition(item.icon:getPosition())
      self:refreshCard2()
    end
  })
  self:btRegisterRectClick({
    rect = CCRectMake(129, 150, 100, 100),
    key = "head_rect",
    parent = self.ui.Panel_card_1,
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      if self.index == 2 and self.unlockId[self.hid] > 0 and 0 >= ed.player:getEquipAmount(self.unlockId[self.hid]) then
        ed.UITool.openView("packageDetail", {
          id = self.unlockId[self.hid],
          type = "item"
        })
      end
    end
  })
end

function class:refreshPage2()
  local unitTb = ed.getDataTable("SoloUnit")
  local hidList = {}
  local hidLockList = {}
  local curSeasonId = 1
  self.unlockId = {}
  for k, v in pairs(unitTb) do
    if v["Hero Pay Type"] == "Free" or v["Hero Pay Type"] == "Unlock" then
      if v["Hero Pay Type"] == "Unlock" then
        table.insert(hidLockList, v["Hero ID"])
      else
        table.insert(hidList, v["Hero ID"])
      end
      self.unlockId[v["Hero ID"]] = v["Unlock Item ID"]
    end
  end
  if #hidList == 0 then
    return
  end
  table.sort(hidList, function(a, b)
    return a < b
  end)
  table.sort(hidLockList, function(a, b)
    return a < b
  end)
  for i, v in ipairs(hidLockList) do
    table.insert(hidList, v)
  end
  self.pageDraglist2:clearList()
  local thisCon = self.ui.Panel_item_2:getContentSize()
  local width, heigh = 78, 78
  local posY = thisCon.height
  self.heroUIList = {}
  local pos
  for i, v in ipairs(hidList) do
    local posX = (i % 5 == 0 and 5 or i % 5) * width - width / 2
    local icon = ed.readhero.createSoloUnitIcon({id = v}).icon
    icon:setScale(0.9)
    self.pageDraglist2:addItem(icon)
    icon:setPosition(posX, posY - heigh / 2 - 10)
    table.insert(self.heroUIList, {icon = icon, id = v})
    if not pos and self.hid and self.hid == v then
      pos = ccp(posX, posY - heigh / 2 - 10)
    end
    posY = i % 5 == 0 and posY - heigh or posY
    if self.unlockId[v] > 0 and 0 >= ed.player:getEquipAmount(self.unlockId[v]) then
      local mask = ed.createSpriteTools({
        res = "UI/alpha/1080P/common/frame/hero_mask.png",
        pos = ccp(34, 35),
        parent = icon,
        scale = 1
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/rogue/instance/instance_echo_lock.png",
        pos = ccp(45, 45),
        parent = mask,
        scale = 0.6
      })
    end
  end
  self.pageDraglist2:initListHeight(math.ceil(#hidList / 5) * heigh + 20)
  self.hid = self.hid or hidList[1]
  self.heroSelect = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/solobook/page_hero.png",
    pos = pos or ccp(39, 397.5),
    parent = self.pageDraglist2.listLayer
  })
  self.heroSelect:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCScaleTo:create(0.4, 1.05), CCScaleTo:create(0.6, 0.95))))
  self:refreshCard2()
end

function class:refreshCard2()
  local heroId = self.hid
  self.ui.Panel_card_1:removeAllChildrenWithCleanup(true)
  ed.createLabelTools({
    txt = ed.getSoloDisplyName(heroId),
    size = 17,
    pos = ccp(159, 371),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = self.ui.Panel_card_1,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#2c1e06")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = T("\230\181\129\230\180\190\230\142\168\232\141\144\239\188\154"),
    size = 15,
    pos = ccp(119, 342),
    color = ccc3(255, 243, 212),
    parent = self.ui.Panel_card_1,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#684512")),
      1.3
    }
  })
  local factions = ed.getSoloUnitFaction(heroId)
  for i = 1, 2 do
    if factions[i] then
      local factionData = ed.getDataTable("SoloCardTag")[factions[i]]
      ed.createSpriteTools({
        res = factionData["Tag Icon"],
        pos = ccp(159 + i * 30 - 20, 342),
        parent = self.ui.Panel_card_1,
        scale = 0.4
      })
    end
  end
  local actor = ed.readhero.getSoloActor(heroId, "Idle")
  actor:setPosition(154, 180)
  self.ui.Panel_card_1:addChild(actor, 10)
  actor:setScale(1)
  self:addFca(actor)
  if self.unlockId[self.hid] > 0 and 0 >= ed.player:getEquipAmount(self.unlockId[self.hid]) then
    local lock = ed.createSpriteTools({
      res = "UI/alpha/1080P/rogue/instance/instance_echo_lock.png",
      pos = ccp(159, 220),
      parent = self.ui.Panel_card_1,
      scale = 0.6,
      z = 99
    })
    lock:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(0.5),
      CCRotateTo:create(0.3, -15),
      CCRotateTo:create(0.5, 15),
      CCRotateTo:create(0.5, -15),
      CCRotateTo:create(0.5, 15),
      CCRotateTo:create(0.3, 0),
      CCDelayTime:create(1.5)
    })))))
  end
  local skillGroupInfo = ed.lookupDataTable("SoloSkillGroup", nil, heroId)
  local slot = {1, 2}
  for i = 1, 2 do
    local skillIcon = ed.readhero.createSoloUnitSkillIcon(heroId, slot[i])
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/skill_2.png")
    clipNode:setScale(1.36)
    clipNode:addChild(skillIcon)
    self.ui.Panel_card_1:addChild(clipNode)
    clipNode:setPosition(159 + (i == 1 and -65.7 or 63), 130)
    local label = ed.ui.gradientLabel.create({
      text = i == 1 and T("\229\164\167\230\139\155") or T("\229\164\169\232\181\139"),
      fontName = ed.fontBold,
      fontSize = 12,
      startColor = ed.toccc3(i == 1 and 16770192 or 12182271),
      endColor = ed.toccc3(i == 1 and 16756584 or 6147583),
      strokeColor = ed.toccc3(i == 1 and 6960409 or 1193866),
      strokeSize = 1.5
    })
    label.node:setPosition(159 + (i == 1 and -65.7 or 63), 94)
    self.ui.Panel_card_1:addChild(label.node)
    local txt = ed.ui.gradientLabel.create({
      text = skillGroupInfo[i]["Display Name"],
      fontSize = 12,
      startColor = ed.toccc3(i == 1 and 16770192 or 12182271),
      endColor = ed.toccc3(i == 1 and 16756584 or 6147583),
      strokeColor = ed.toccc3(i == 1 and 6960409 or 1193866),
      strokeSize = 1.5
    })
    txt.node:setPosition(159 + (i == 1 and -65.7 or 63), 167)
    self.ui.Panel_card_1:addChild(txt.node)
    self:btRegisterButtonClick({
      button = skillIcon,
      pressScale = 0.95,
      key = "skillIcon" .. i,
      force = true,
      clickHandler = function()
        local skillPanel = ed.ui.SoloSkillPop.create({
          heroId = heroId,
          slot = slot[i],
          hero = {
            _hid = heroId,
            _powers = {_id = 1}
          }
        })
        ed.layout.relateLayout(skillIcon, skillPanel.ui.bg, {top = -80, left = 217.5}, true)
      end
    })
  end
  local data = ed.getDataTable("SoloUnit")[heroId]
  local uinfo = ed.lookupDataTable("SoloUnit", nil, heroId)
  local resourceName = ed.lookupDataTable("Puppet", "Resource", uinfo.Puppet) .. ".cha"
  local nPerSecond = string.format("%.1f", 1 / ed.lookupDataTable("AnimDuration", "Duration", resourceName, "atk"))
  local cfg = {
    {
      ccp = ccp(61, 61),
      str = uinfo.AD
    },
    {
      ccp = ccp(145, 61),
      str = uinfo.CRIT
    },
    {
      ccp = ccp(225, 61),
      str = 0
    },
    {
      ccp = ccp(61, 33),
      str = 0
    },
    {
      ccp = ccp(145, 33),
      str = nPerSecond or 0
    },
    {
      ccp = ccp(225, 33),
      str = uinfo.DODG
    }
  }
  for i, v in ipairs(cfg) do
    ed.createSpriteTools({
      res = "UI/alpha/1080P/chesscard/" .. i .. ".png",
      pos = v.ccp,
      parent = self.ui.Panel_card_1
    })
    ed.createLabelTools({
      txt = v.str,
      size = 14,
      pos = ccpAdd(v.ccp, ccp(9, -0.5)),
      color = ccc3(255, 252, 231),
      parent = self.ui.Panel_card_1,
      anchor = ccp(0, 0.5),
      stroke = {
        ccc3(ed.colorToStr("#1f1f1e")),
        1.3
      }
    })
  end
end

function class:initPage3()
  self.pageDraglist3 = ed.UITool.createDraglist(self.ui.Panel_item_3, {
    doPressIn = function(x, y)
      for _, item in ipairs(self.itemUIList or {}) do
        if ed.containsPoint(item.icon, x, y) then
          return item
        end
      end
    end,
    doClickIn = function(x, y, item)
      self.powerIndex = item.id
      self.itemSelect:setPosition(item.icon:getPosition())
      self.step = 1
      self:refreshCard3()
    end
  })
  local powerList = {}
  local powerTb = ed.getDataTable("SoloPower")
  for k, v in pairs(powerTb) do
    local isExist = false
    if 10000 < k and v.ID < 20000 then
      for _, power in ipairs(powerList) do
        if power.group == v["Power Group"] then
          isExist = true
          table.insert(power.powerSteps, v)
        end
      end
      if not isExist then
        local powerInfo = {}
        powerInfo.group = v["Power Group"]
        powerInfo.powerSteps = {}
        table.insert(powerInfo.powerSteps, v)
        table.insert(powerList, powerInfo)
      end
    end
  end
  table.sort(powerList, function(a, b)
    return a.group < b.group
  end)
  self.powerList = powerList
  self.ui.btn_right:setScaleX(-1)
  ed.UITool.registerBtn(self, "btn_left", function()
    self.step = math.max(1, self.step - 1)
    self:refreshCard3()
  end)
  ed.UITool.registerBtn(self, "btn_right", function()
    self.step = math.min(3, self.step + 1)
    self:refreshCard3()
  end)
end

function class:refreshPage3()
  self.pageDraglist3:clearList()
  local thisCon = self.ui.Panel_item_3:getContentSize()
  local width, heigh = 78, 78
  local posY = thisCon.height
  self.itemUIList = {}
  local pos
  for i, v in ipairs(self.powerList) do
    local posX = (i % 5 == 0 and 5 or i % 5) * width - width / 2
    local icon = ed.createSprite(v.powerSteps[1].Icon)
    icon:setScale(0.9)
    local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_orange.png")
    icon:addChild(frame)
    frame:setPosition(ccp(34, 35))
    self.pageDraglist3:addItem(icon)
    icon:setPosition(posX, posY - heigh / 2 - 10)
    table.insert(self.itemUIList, {icon = icon, id = i})
    if 0 < v.powerSteps[1]["Unlock Item ID"] and 0 >= ed.player:getEquipAmount(v.powerSteps[1]["Unlock Item ID"]) then
      local mask = ed.createSpriteTools({
        res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
        pos = ccp(34, 35),
        parent = icon,
        scale = 1
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/rogue/instance/instance_echo_lock.png",
        pos = ccp(45, 45),
        parent = mask,
        scale = 0.6
      })
    end
    if not pos and self.powerIndex and self.powerIndex == i then
      pos = ccp(posX, posY - heigh / 2 - 10)
    end
    posY = i % 5 == 0 and posY - heigh or posY
  end
  self.pageDraglist3:initListHeight(math.ceil(#self.powerList / 5) * heigh + 20)
  self.powerIndex = self.powerIndex or 1
  self.itemSelect = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/solobook/page_hero.png",
    pos = pos or ccp(38, 397.5),
    parent = self.pageDraglist3.listLayer
  })
  self.itemSelect:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCScaleTo:create(0.4, 1.05), CCScaleTo:create(0.6, 0.95))))
  self:refreshCard3()
end

function class:refreshCard3()
  local powerIndex = self.powerIndex
  local data = ed.copyTable(self.powerList[powerIndex])
  local powerInfo
  for k, v in ipairs(data.powerSteps) do
    if v.Phase == self.step then
      powerInfo = v
    end
  end
  if not powerInfo then
    powerInfo = data.powerSteps[1]
    self.step = powerInfo.Phase
  end
  ed.setString(self.ui.Label_item_name, powerInfo["HeroPower Name"])
  if self.itemIcon then
    self.itemIcon:removeFromParentAndCleanup(true)
  end
  local icon = ed.createSprite(powerInfo.Icon)
  local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_orange.png")
  icon:addChild(frame)
  frame:setPosition(ccp(34, 35))
  self.ui.Panel_card_2:addChild(icon, 10)
  icon:setScale(1.2)
  icon:setPosition(161, 226)
  self.itemIcon = icon
  self:btRemoveMainTouchHandler({
    key = "soloPowerItemIcon"
  })
  if powerInfo["Unlock Item ID"] > 0 and 0 >= ed.player:getEquipAmount(powerInfo["Unlock Item ID"]) then
    local mask = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
      pos = ccp(34, 35),
      parent = icon,
      scale = 1
    })
    local lock = ed.createSpriteTools({
      res = "UI/alpha/1080P/rogue/instance/instance_echo_lock.png",
      pos = ccp(45, 45),
      parent = mask,
      scale = 0.6
    })
    lock:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(0.5),
      CCRotateTo:create(0.3, -15),
      CCRotateTo:create(0.5, 15),
      CCRotateTo:create(0.5, -15),
      CCRotateTo:create(0.5, 15),
      CCRotateTo:create(0.3, 0),
      CCDelayTime:create(1.5)
    })))))
    self:btRegisterButtonClick({
      button = icon,
      key = "soloPowerItemIcon",
      clickHandler = function()
        ed.UITool.openView("packageDetail", {
          id = powerInfo["Unlock Item ID"],
          type = "item"
        })
      end,
      force = true,
      pressScale = 1.15,
      normalScale = 1.2
    })
  end
  self.ui.Label_level:setString(T("\231\172\172%s\233\152\182\230\174\181", self.step))
  if self.itemSkillTxt then
    self.itemSkillTxt:removeFromParentAndCleanup(true)
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = powerInfo.Description,
    fontSize = 15,
    lineSpacing = 2,
    maxWidth = 260,
    color = ccc3(255, 252, 231),
    strokeColor = ccc3(1, 1, 1),
    strokeSize = 2
  })
  autoText.node:setPosition(30, 55)
  self.ui.Panel_card_2:addChild(autoText.node)
  self.itemSkillTxt = autoText.node
end
