local base = ed.ui.popwindow
local packageDetailWin = newclass(base.mt)
ed.ui.packageDetailWin = packageDetailWin
local tokenAmountFunc = {
  diamond = function()
    return ed.player:getPoint("diamond")
  end,
  gold = function()
    return ed.player:getPoint("gold")
  end,
  crusadepoint = function()
    return ed.player:getPoint("crusadepoint")
  end,
  arenapoint = function()
    return ed.player:getPoint("arenapoint")
  end,
  guildpoint = function()
    return ed.player:getPoint("guildpoint")
  end,
  dreampoint = function()
    return ed.player:getPoint("dreampoint")
  end,
  playerexp = function()
    return ed.player:getExp()
  end,
  actpoint = function()
    return ed.taskData:getPageDataObj("pass").passData.total_exp or 0
  end
}
packageDetailWin.tokenAmountFunc = tokenAmountFunc
local extraToken = {
  adventurepoint = {
    tokenName = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return ed.adventureDefine.getAdventureTokenInfo(actAdventureMgr:getOpenActId()).tokenName
    end,
    describe1 = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return ed.adventureDefine.getAdventureTokenInfo(actAdventureMgr:getOpenActId()).tokenDesc
    end,
    icon = function()
      local actAdventureMgr = ed.actiAdventureMgr.getInstance()
      return ed.adventureDefine.getAdventureTokenInfo(actAdventureMgr:getOpenActId()).tokenIconPath
    end
  },
  simple_pass_exp = {
    tokenName = function(simplePassId)
      local simplePassExpId = ed.getDataTable("SimplePass")[simplePassId].SimplePassExp
      return ed.getDataTable("SimplePassExp")[simplePassExpId]["Token Name"]
    end,
    describe1 = function(simplePassId)
      local simplePassExpId = ed.getDataTable("SimplePass")[simplePassId].SimplePassExp
      return ed.getDataTable("SimplePassExp")[simplePassExpId]["Describe 1"]
    end,
    icon = function(simplePassId)
      local simplePassExpId = ed.getDataTable("SimplePass")[simplePassId].SimplePassExp
      return ed.getDataTable("SimplePassExp")[simplePassExpId].Icon
    end
  }
}
packageDetailWin.extraToken = extraToken
local tokenTblLower = {}
local tokenTbl = ed.getDataTable("Token")
for key, value in pairs(tokenTbl) do
  local lowerKey = string.lower(key)
  tokenTblLower[lowerKey] = value
end
ed.tokenTblLower = tokenTblLower

local function createTokenIcon(tokenTpye, id)
  local itemConfig = tokenTblLower[tokenTpye]
  local iconRes
  if extraToken[tokenTpye] then
    iconRes = extraToken[tokenTpye].icon(id)
  else
    iconRes = itemConfig.Icon
  end
  local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_white.png")
  local iconImage = ed.createSprite(iconRes)
  local bg = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
  bg:addChild(iconImage, 1)
  bg:addChild(frame, 2)
  ed.layout.centerInParent(iconImage)
  ed.layout.centerInParent(frame)
  return bg
end

ed.UITool.registViewOpenFunc("packageDetail", function(itemData)
  if itemData.type ~= "hero" then
    packageDetailWin.create(itemData):popWindow()
  end
end)

function packageDetailWin.create(itemData)
  if itemData.type == "LegendEquip" or itemData.type == "legend_equip" then
    local self = ed.ui.legendEquipTip.create({
      typeId = itemData.id
    })
    return self
  else
    local self = base.create("packageDetailWin")
    setmetatable(self, packageDetailWin.mt)
    self:init(itemData)
    return self
  end
end

function packageDetailWin:init(itemData)
  self.itemData = itemData
  self.id = itemData.id or nil
  self.type = itemData.type or nil
  self.type = ed.typeConvert[self.type] or self.type
  self.count = itemData.count or 1
  self.clickOutSide = false
  self:initView()
  self:addEventListener()
end

function packageDetailWin:initView()
  local container, ui = ed.editorui(ed.uieditor.package_detail)
  self.container:addChild(container)
  self.ui = ui
  self:initDragList()
  self.refreshCliprectConfig = {
    draglist = self.attrDragList
  }
  self:show()
  self:refreshItemInfo()
end

function packageDetailWin:initDragList()
  self.attrDragList = ed.UITool.createDraglist(self.ui.layer_attr, {
    priority = -999,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList()
  })
end

function packageDetailWin:doPressInList()
  local function handler(x, y)
    for k, item in pairs(self.getWayItemList or {}) do
      local ui = item.ui
      
      local container = ui.container
      local data = item.data
      if data.state == "Normal" and ed.containsPoint(ui.bg, x, y) then
        container:setScale(0.95)
        return item
      end
    end
  end
  
  return handler
end

function packageDetailWin:doClickInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    local container = item.container
    local data = item.data
    local ui = item.ui
    if ed.containsPoint(ui.bg, x, y) then
      self:clickGetWay(data)
    end
  end
  
  return handler
end

function packageDetailWin:cancelPressInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    local container = item.container
    if container then
      container:setScale(1)
    end
  end
  
  return handler
end

function packageDetailWin:refreshItemInfo()
  local icon, desStr, commentStr, amount, name
  if type(self.type) == "string" then
    self.type = string.lower(self.type)
  end
  if self.type and tokenTblLower[self.type] or extraToken[self.type] then
    local tblConfig = tokenTblLower[self.type]
    local extraCfg = extraToken[self.type]
    icon = createTokenIcon(self.type, self.id)
    desStr = extraCfg and extraCfg.describe1(self.id) or tblConfig["Describe 1"]
    commentStr = tblConfig and tblConfig["Describe 2"] or ""
    local getAmountFunc = tokenAmountFunc[self.type]
    amount = getAmountFunc and getAmountFunc() or 0
    name = extraCfg and extraCfg.tokenName(self.id) or tblConfig["Token Name"] or ""
    self.ui.amount:setVisible(false)
  elseif self.type and self.type == "medal" then
    local cfg
    for _, v in pairs(ed.getDataTable("Medal")) do
      if self.id == v.MedalID then
        cfg = v
        break
      end
    end
    icon = ed.createItemIcon({
      type = "Medal",
      id = self.id,
      amount = 1
    })
    name = cfg.Name
    desStr = cfg.Description
    commentStr = ""
    amount = 1
    icon:setScale(1)
    self.ui.amount:setVisible(false)
  elseif self.type and self.type == "guildavataframe" then
    local cfg
    for _, v in pairs(ed.getDataTable("GuildAvatarFrame")) do
      if self.id == v.ID then
        cfg = v
        break
      end
    end
    icon = ed.createItemIcon({
      type = "guildAvataFrame",
      id = self.id,
      amount = 1
    })
    name = cfg.Name
    desStr = cfg["Unlock Description"]
    commentStr = ""
    amount = 1
    icon:setScale(1)
    self.ui.amount:setVisible(false)
  elseif self.type and self.type == "risestarpoint" then
    local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_purple.png")
    local iconImage = ed.createSprite("UI/alpha/1080P/risestar/itemicon1.jpg")
    local bg = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
    bg:addChild(iconImage, 1)
    bg:addChild(frame, 2)
    ed.layout.centerInParent(iconImage)
    ed.layout.centerInParent(frame)
    icon = bg
    name = T("\230\181\129\229\133\137\229\190\174\231\178\146")
    desStr = T("\231\148\168\228\186\142\230\152\159\232\190\137\229\149\134\229\186\151\228\184\173\232\191\155\232\161\140\229\133\145\230\141\162\229\165\150\229\138\177")
    icon:setScale(1)
    amount = ed.riseStarMgr:getItemPoint() or 0
  elseif self.id then
    icon = ed.readequip.createIcon(self.id)
    desStr = ed.readequip.value(self.id, "Description")
    commentStr = ed.readequip.value(self.id, "Comment")
    amount = ed.player:getEquipAmount(self.id)
    name = ed.readequip.value(self.id, "Name") or ""
    self.ui.amount:setVisible(true)
  else
    ed.showToast(string.format(T("\231\188\186\229\176\145%s\233\133\141\231\189\174,\232\175\183\230\163\128\230\159\165Token\232\161\168"), self.type))
    return
  end
  self.ui.icon_item:addChild(icon)
  ed.layout.centerInParent(icon)
  self.ui.label_name:setColor(ed.toccc3(4010020))
  self.ui.label_name:setZOrder(10)
  self.ui.label_name:setString(name)
  self.ui.label_name:limitWidthByScale(160)
  local amountStr = T(T("<lable color=ccc3(107,97,81)>\230\140\129\230\156\137\239\188\154</lable><lable color=ccc3(44,82,167)>%d</lable>"), amount)
  if ed.readequip.value(self.id, "Category") == T("\231\129\181\233\173\130\231\159\179") then
    local heroId = ed.readhero.getMakeid(self.id)
    local hero = ed.player.heroes[heroId]
    if not hero or hero and hero._stars < 5 then
      local stoneNeed = ed.readhero.getStoneNeed(heroId) or 9999999
      amountStr = T("<lable color=ccc3(107,97,81)>\230\140\129\230\156\137\239\188\154</lable><lable color=ccc3(44,82,167)>%d/%d</lable>", amount, stoneNeed)
    end
  end
  local autoTextLabel = ed.ui.autoText.new()
  autoTextLabel:initParam({
    context = amountStr,
    fontSize = 14,
    align = "CENTER",
    maxWidth = self.ui.amount:getContentSize().width
  })
  self.ui.amount:addChild(autoTextLabel.node)
  autoTextLabel.node:setPositionY(self.ui.amount:getContentSize().height / 2)
  self.attrDragList:clearList()
  local desc = ed.readequip.getDescriptionNew(self.id)
  local dragListSize = self.ui.layer_attr:getContentSize()
  for index = 1, #desc do
    local container = CCNode:create()
    local ui = {}
    ui.container = container
    local readnode = ed.readnode.create(container, ui)
    readnode:addNode(ed.uieditor.attr_item)
    ui.bg:setContentSize(CCSizeMake(dragListSize.width, ui.bg:getContentSize().height))
    ui.bg:setPositionX(dragListSize.width / 2 - 9)
    ui.label_num:setPositionX(dragListSize.width - 20)
    ed.setString(ui.label_attr, desc[index][1])
    ed.setString(ui.label_num, desc[index][2] or "")
    ui.bg:setVisible(index % 2 == 0)
    container:setPosition(ccp(15, dragListSize.height - 25 * index + 12.5))
    self.attrDragList:addItem(container)
  end
  local posY = #desc * 25 + 10
  if desStr and commentStr then
    local desLabel = ed.createLabelTTF(desStr, 15)
    desLabel:setAnchorPoint(ccp(0, 0.5))
    desLabel:setColor(ccc3(61, 48, 36))
    desLabel:setDimensions(CCSizeMake(210, 0))
    desLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = desLabel:getContentSize().height
    local width = desLabel:getContentSize().width
    desLabel:setPosition(ccp(7, dragListSize.height - (posY + height / 2)))
    self.attrDragList:addItem(desLabel)
    posY = posY + height + 4
    local commentLabel = ed.createLabelTTF(commentStr, 15)
    commentLabel:setColor(ccc3(108, 92, 77))
    commentLabel:setDimensions(CCSizeMake(210, 0))
    commentLabel:setAnchorPoint(ccp(0, 0.5))
    commentLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    height = commentLabel:getContentSize().height
    commentLabel:setPosition(ccp(7, dragListSize.height - (posY + height / 2)))
    self.attrDragList:addItem(commentLabel)
    posY = posY + height + 4
  elseif desStr then
    local desLabel = ed.createLabelTTF(desStr, 15)
    desLabel:setColor(ccc3(61, 48, 36))
    desLabel:setAnchorPoint(ccp(0, 0.5))
    desLabel:setDimensions(CCSizeMake(210, 0))
    desLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = desLabel:getContentSize().height
    desLabel:setPosition(ccp(7, dragListSize.height - (posY + height / 2)))
    self.attrDragList:addItem(desLabel)
    posY = posY + height + 4
  elseif commentStr then
    local commentLabel = ed.createLabelTTF(commentStr, 15)
    commentLabel:setColor(ccc3(61, 48, 36))
    commentLabel:setAnchorPoint(ccp(0, 0.5))
    commentLabel:setDimensions(CCSizeMake(210, 0))
    commentLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = commentLabel:getContentSize().height
    commentLabel:setPosition(ccp(7, dragListSize.height - (posY + height / 2)))
    self.attrDragList:addItem(commentLabel)
    posY = posY + height + 4
  end
  self.attrDragList:initListHeight(posY)
  if ed.getCurrentScene().identity == "battle" then
    return
  end
  local getWay = ed.packageGetWay(self.id)
  table.sort(getWay, function(a, b)
    if a.state == b.state then
      return a.id < b.id
    elseif a.state == "Normal" and b.state ~= "Normal" then
      return true
    else
      return false
    end
  end)
  self.getWayItemList = {}
  if 0 < #getWay then
    posY = posY + 10
    local equipSource = ed.createSprite("UI/alpha/1080P/package/new/equip_source.png")
    local equipSourceLabel = ed.createLabelTTF(T("\232\142\183\229\143\150\233\128\148\229\190\132"), 15)
    local width = equipSourceLabel:getContentSize().width
    local height = equipSourceLabel:getContentSize().height
    equipSourceLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    equipSourceLabel:setColor(ccc3(61, 48, 36))
    equipSourceLabel:setPosition(ccp(30 + width / 2, dragListSize.height - (posY + height / 2)))
    equipSource:setPosition(ccp(20, dragListSize.height - (posY + height / 2)))
    self.attrDragList:addItem(equipSource)
    self.attrDragList:addItem(equipSourceLabel)
    posY = posY + height + 4
  end
  for index, data in ipairs(getWay or {}) do
    local container, ui = self:createGetWayItem(data)
    local width = container:getContentSize().width
    local height = container:getContentSize().height
    container:setPosition(ccp(dragListSize.width / 2, dragListSize.height - (posY + height / 2)))
    self.attrDragList:addItem(container)
    posY = posY + height + 1
    table.insert(self.getWayItemList, {
      container = container,
      ui = ui,
      data = data
    })
  end
  self.attrDragList:initListHeight(posY)
end

function packageDetailWin:createGetWayItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "Normal" then
    readnode:addNode(ed.uieditor.accessNormalItem)
    ui.btn_go:setPositionX(200)
  elseif data.state == "Special" then
    readnode:addNode(ed.uieditor.accessSpecialItem)
  else
    readnode:addNode(ed.uieditor.accessLockItem)
    ui.label_lock:setPositionX(200)
    ui.label_lock:setHorizontalAlignment(kCCTextAlignmentCenter)
    ed.adaptLabel(ui.label_lock, {
      maxWidth = 50,
      minScale = 0.7,
      maxHeight = 60
    })
  end
  ui.bg:setContentSize(CCSizeMake(227, 46))
  container:setContentSize(ui.bg:getContentSize())
  ed.setString(ui.label_info, data.name)
  ed.setLabelStroke(self.ui.label_info, ccc3(255, 252, 231), 1)
  ed.adaptLabel(ui.label_info, {maxWidth = 160, minScale = 0.7})
  return container, ui
end

function packageDetailWin:clickGetWay(data)
  if data.type == "stage" then
    ed.ui.stagedetail.create(data.id):popWindow()
    ed.stageSelectParam = nil
  elseif data.type == "summon" then
    ed.summonMgr.noBottomButton = true
    ed.UITool.openView("summonScene")
  elseif data.type == "skillTower" then
    local curScene = ed.getCurrentScene()
    if curScene.identity == "SkillTowerStageScene" then
      return
    end
    ed.UITool.openView("SkillTowerStageScene", data.id)
  elseif data.type == "shop" then
    local page = data.id
    local shopVisible = ed.shopData:getShopVis(page)
    if shopVisible then
      ed.UITool.openView("shopMain", {
        page = page,
        itemId = self.id
      })
    else
      ed.showToast(T("\229\149\134\229\186\151\230\156\170\229\188\128\230\148\190"))
    end
  elseif data.type == "heroExercise" then
    ed.exerciseManager:openExerciseMainScene()
  elseif data.type == "task" then
    local panel = ed.getPopWindow("taskScene")
    if panel then
      panel:destroy()
    end
    ed.UITool.openView("taskScene", {})
    panel = ed.getPopWindow("maillocalbox")
    if panel then
      panel:destroy()
    end
  elseif data.type == "awakeDungeon" then
    ed.UITool.openView("awakeDungeonScene")
  elseif data.type == "nianMonster" then
    ed.UITool.openView("nianMonsterMainScene")
  elseif data.type == "chat" then
    ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.world_channel)
  elseif data.type == "NewYearDaysLogin" then
    local actId
    if ed.activityHints.data:getActivityIsOpenById(85) then
      actId = 85
    elseif ed.activityHints.data:getActivityIsOpenById(94) then
      actId = 94
    end
    ed.UITool.openView("activityScene", {actId = actId})
  elseif data.type == "CDKey" then
    if not ed.getPopWindow("playerInfoWindow") then
      ed.ui.playerInfoWindow.create():popWindow()
    end
  elseif data.type == "growPlan" then
    ed.UITool.openView("activityScene", {openActType = "grow_plan"})
  elseif data.type == "RechargeScene" then
    if self.id == ed.getDataTable("DragonBoat")[1]["Item ID"] then
      ed.pushScene(ed.ui.RechargeScene.create({
        page = "FestivalGift"
      }))
    else
      ed.pushScene(ed.ui.RechargeScene.create({
        page = "Gift",
        giftItemId = self.id
      }))
    end
  elseif data.type == "rogueMainScene" then
    ed.UITool.openView("rogueMainScene")
  elseif data.type == "fireForgeMainScene" then
    ed.UITool.openView("fireForgeMainScene")
  elseif data.type == "latestStageScene" then
    ed.UITool.openView("stageSelect")
  elseif data.type == "skillTowerMainScene" then
    ed.UITool.openView("SkillTowerScene", data.id)
  elseif data.type == "legendEquipShopScene" then
    ed.UITool.openView("legendEquipShopScene")
  elseif data.type == "dayAwardsScene" then
    ed.UITool.openView("dayAwardsScene", {})
  end
  self:destroy({skipAnim = true})
end

function packageDetailWin:addEventListener()
  self:btRegisterHandler({
    key = "close",
    handler = function(event, x, y)
      if event == "began" then
        if not ed.containsPoint(self.ui.bg_detail, x, y) then
          self.clickOutSide = true
        else
          self.clickOutSide = false
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.bg_detail, x, y) and self.clickOutSide then
        self:close()
        return false
      end
      return false
    end
  })
end

function packageDetailWin:close()
  self:destroy()
end
