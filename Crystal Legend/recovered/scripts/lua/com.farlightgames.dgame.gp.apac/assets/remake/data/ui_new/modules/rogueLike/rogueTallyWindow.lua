local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueTallyWindow = class
ed.UITool.registViewOpenFunc("rogueTallyWindow", function(param)
  ed.ui.rogueTallyWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueTallyWindow", {noShade = false})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.point = param.point or 0
  self.tech = param.tech or 0
  self.totalPearl = param.totalPearl or 0
  self.maxBossDamage = param.maxBossDamage or 0
  self.damageHero = param.damageHero or 0
  self.newCharms = param.newCharms or {}
  self.closeCallBack = param.closeCallBack
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.curChapter = self.rogueLikeMgr:getCurChapter()
  self.chapterId = self.curChapter._chapter_id
  self.diff = self.curChapter._difficulty
  self.charmCardUIArr = nil
  self.chapterCfg = ed.getDataTable("RogueChapter")[self.chapterId][self.diff]
  self:initView()
  self:adaptUI()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  
  function self.showCallback()
    self:listenTimer(Timer:Always(0.01), function()
      self:checkCharmUpEffect()
    end)
  end
  
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueTallyWindow)
  self.container:addChild(container)
  self.ui = ui
  self.ui.btn_back:setVisible(false)
  self:initLabels()
  self:initDragList()
  self:refreshDragList()
  local movingDistance = self.dragList.listHeight - self.ui.panel_list:getContentSize().height
  if 0 < movingDistance then
    local time = movingDistance / 180
    local delayAction = CCDelayTime:create(0.5)
    local actionMove = CCMoveBy:create(time, ccp(0, movingDistance))
    self.dragList.listLayer:runAction(CCSequence:create(ccArrayMake(delayAction, actionMove)))
  end
end

function class:initDragList()
  local panelSize = self.ui.panel_list:getContentSize()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(panelSize.width + 5, panelSize.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    }
  })
end

function class:refreshDragList()
  local panelSize = self.ui.panel_list:getContentSize()
  self.dragList:clearList()
  local height = 1
  local bg1, size1 = self:createChapterNameItem()
  self.dragList:addItem(bg1)
  bg1:setPosition(ccp(panelSize.width / 2, panelSize.height - height))
  height = height + size1.height + 6
  local bg2, size2 = self:createScoreItem()
  self.dragList:addItem(bg2)
  bg2:setPosition(ccp(panelSize.width / 2, panelSize.height - height))
  height = height + size2.height + 6
  local bg3, size3 = self:createTeamItem()
  self.dragList:addItem(bg3)
  bg3:setPosition(ccp(panelSize.width / 2, panelSize.height - height))
  height = height + size3.height + 6
  local bg7, size7 = self:createStatisticsItem()
  self.dragList:addItem(bg7)
  bg7:setPosition(ccp(panelSize.width / 2, panelSize.height - height))
  height = height + size7.height + 6
  local bg4, size4 = self:createBlessItem()
  self.dragList:addItem(bg4)
  bg4:setPosition(ccp(panelSize.width / 2, panelSize.height - height))
  height = height + size4.height + 6
  local line = ed.createScale9Sprite("UI/alpha/1080P/rogue/bless/destiny_info_line.png")
  self.dragList:addItem(line)
  line:setContentSize(CCSizeMake(523, 2.5))
  line:setPosition(ccp(panelSize.width / 2, panelSize.height - height))
  height = height + 2.5 + 6
  local bg5, size5 = self:createAllBlessItem()
  self.dragList:addItem(bg5)
  bg5:setPosition(ccp(panelSize.width / 2, panelSize.height - height - size5.height / 2))
  height = height + size5.height + 10
  if #self.newCharms > 0 then
    local bg6, size6 = self:createAllCharmItem()
    self.dragList:addItem(bg6)
    bg6:setPosition(ccp(panelSize.width / 2, panelSize.height - height - size6.height / 2))
    height = height + size6.height + 10
  end
  local bg7, size7 = self:createConfirmBtn()
  self.dragList:addItem(bg7)
  bg7:setPosition(ccp(panelSize.width / 2, panelSize.height - height - size7.height / 2))
  height = height + size7.height + 6
  self.dragList:initListHeight(height)
end

function class:createChapterNameItem()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_1.png")
  bg:setContentSize(CCSizeMake(523, 30.5))
  bg:setAnchorPoint(ccp(0.5, 1))
  local labelName = ed.createttf(self.chapterCfg.Name, 18)
  labelName:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelName, ed.toccc3(16776423))
  ed.setLabelStroke(labelName, ed.toccc3(2368548), 1)
  bg:addChild(labelName)
  labelName:setPosition(20, 16)
  local diffCfg = {
    "I",
    "II",
    "III",
    "IV"
  }
  local labelDiff = ed.createttf(string.format(T("\233\154\190\229\186\166%s"), diffCfg[self.diff] or ""), 18)
  labelDiff:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelDiff, ed.toccc3(16776423))
  ed.setLabelStroke(labelDiff, ed.toccc3(2368548), 1)
  bg:addChild(labelDiff)
  labelDiff:setPosition(ccp(labelName:getPositionX() + labelName:getContentSize().width + 5, 16))
  local labelProgressTips = ed.createttf(T("\229\174\140\230\136\144\232\191\155\229\186\166"), 18)
  labelProgressTips:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelProgressTips, ed.toccc3(16776423))
  ed.setLabelStroke(labelProgressTips, ed.toccc3(2368548), 1)
  bg:addChild(labelProgressTips)
  labelProgressTips:setPosition(ccp(320, 16))
  local curWave = self.curChapter._cur_wave
  local waves = self.curChapter._waves or {}
  local totalWave = waves[#waves]._wave_id or 0
  local labelProgress = ed.createttf(string.format("%s/%s", curWave, totalWave), 18)
  labelProgress:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelProgress, ed.toccc3(16753969))
  ed.setLabelStroke(labelProgress, ed.toccc3(2368548), 1)
  bg:addChild(labelProgress)
  labelProgress:setPosition(ccp(labelProgressTips:getPositionX() + labelProgressTips:getContentSize().width + 5, 16))
  return bg, bg:getContentSize()
end

function class:createScoreItem()
  local container = CCLayerColor:create(ccc4(0, 0, 0, 0))
  container:ignoreAnchorPointForPosition(false)
  container:setAnchorPoint(ccp(0.5, 1))
  local containerSize = CCSizeMake(523, 65)
  container:setContentSize(containerSize)
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_2.png")
  bg:setContentSize(CCSizeMake(523, 24.5))
  bg:setAnchorPoint(ccp(0.5, 1))
  bg:setPosition(ccp(261.5, containerSize.height - 2))
  local labelScoreTips = ed.createttf(T("\231\187\147\231\174\151\229\165\150\229\138\177"), 18)
  labelScoreTips:setAnchorPoint(ccp(0, 0.5))
  labelScoreTips:setPosition(20, 12.5)
  ed.setLabelColor(labelScoreTips, ed.toccc3(4290884095))
  ed.setLabelStroke(labelScoreTips, ed.toccc3(2368548), 1)
  bg:addChild(labelScoreTips)
  container:addChild(bg)
  local labelScoreName = ed.createttf(T("\230\153\186\230\133\167\231\129\171\232\138\177"), 18)
  labelScoreName:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelScoreName, ed.toccc3(16776423))
  ed.setLabelStroke(labelScoreName, ed.toccc3(2368548), 1)
  container:addChild(labelScoreName)
  labelScoreName:setPosition(ccp(20, 17))
  local scoreIcon = ed.createSprite("UI/alpha/1080P/rogue/main/rogue_exp.png")
  scoreIcon:setAnchorPoint(ccp(0, 0.5))
  container:addChild(scoreIcon)
  ed.right2(scoreIcon, labelScoreName)
  local labelScore = ed.createttf(self.point or 0, 18)
  labelScore:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelScore, ed.toccc3(16776423))
  ed.setLabelStroke(labelScore, ed.toccc3(2368548), 1)
  container:addChild(labelScore)
  ed.right2(labelScore, scoreIcon)
  if 0 < self.chapterCfg["Tech Tree ID"] then
    local bookCfg = ed.getDataTable("RogueBook")[self.chapterId]
    local techPointName = bookCfg["Tech Point Name"] or ""
    local techPointIcon = bookCfg["Tech Point Icon"]
    local labelTechName = ed.createttf(techPointName, 18)
    labelTechName:setAnchorPoint(ccp(0, 0.5))
    ed.setLabelColor(labelTechName, ed.toccc3(16776423))
    ed.setLabelStroke(labelTechName, ed.toccc3(2368548), 1)
    container:addChild(labelTechName)
    labelTechName:setPosition(ccp(180, 17))
    local icon = ed.createSprite(techPointIcon)
    container:addChild(icon)
    icon:setPosition(ccp(labelTechName:getPositionX() + labelTechName:getContentSize().width + 15, 17))
    local labelTechNum = ed.createttf(self.tech, 18)
    ed.setLabelColor(labelTechNum, ed.toccc3(16776423))
    ed.setLabelStroke(labelTechNum, ed.toccc3(2368548), 1)
    container:addChild(labelTechNum)
    labelTechNum:setPosition(ccp(icon:getPositionX() + icon:getContentSize().width, 17))
  end
  return container, container:getContentSize()
end

function class:createStatisticsItem()
  local container = CCLayerColor:create(ccc4(0, 0, 0, 0))
  container:ignoreAnchorPointForPosition(false)
  container:setAnchorPoint(ccp(0.5, 1))
  local containerSize = CCSizeMake(523, 83)
  container:setContentSize(containerSize)
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_2.png")
  bg:setContentSize(CCSizeMake(523, 24.5))
  bg:setAnchorPoint(ccp(0.5, 1))
  bg:setPosition(ccp(261.5, containerSize.height - 2))
  local labelScoreTips = ed.createttf(T("\230\149\176\230\141\174\231\187\159\232\174\161"), 18)
  labelScoreTips:setAnchorPoint(ccp(0, 0.5))
  labelScoreTips:setPosition(20, 12.5)
  ed.setLabelColor(labelScoreTips, ed.toccc3(4290884095))
  ed.setLabelStroke(labelScoreTips, ed.toccc3(2368548), 1)
  bg:addChild(labelScoreTips)
  container:addChild(bg)
  local labelDamege = ed.createttf(string.format(T("\229\141\149\229\156\186\230\156\128\233\171\152\232\190\147\229\135\186\239\188\154%s"), self.maxBossDamage), 18)
  labelDamege:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelDamege, ed.toccc3(16776423))
  ed.setLabelStroke(labelDamege, ed.toccc3(2368548), 1)
  container:addChild(labelDamege)
  labelDamege:setPosition(ccp(20, 37))
  if self.damageHero ~= 0 then
    local heroName = ed.getDataTable("Unit")[self.damageHero]["Display Name"]
    local labelName = ed.createttf(string.format(T("\233\128\160\230\136\144\232\128\133\239\188\154%s"), heroName), 18)
    labelName:setAnchorPoint(ccp(0, 0.5))
    ed.setLabelColor(labelName, ed.toccc3(16776423))
    ed.setLabelStroke(labelName, ed.toccc3(2368548), 1)
    container:addChild(labelName)
    labelName:setPosition(ccp(labelDamege:getPositionX() + labelDamege:getContentSize().width + 20, 37))
  end
  local labelPearl = ed.createttf(string.format(T("\231\180\175\231\167\175\232\142\183\229\190\151\231\143\141\231\143\160\239\188\154%s"), self.totalPearl), 18)
  labelPearl:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelPearl, ed.toccc3(16776423))
  ed.setLabelStroke(labelPearl, ed.toccc3(2368548), 1)
  container:addChild(labelPearl)
  labelPearl:setPosition(ccp(20, 15))
  return container, container:getContentSize()
end

function class:createTeamItem()
  local container = CCLayerColor:create(ccc4(0, 0, 0, 0))
  container:ignoreAnchorPointForPosition(false)
  container:setAnchorPoint(ccp(0.5, 1))
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_2.png")
  bg:setContentSize(CCSizeMake(523, 24.5))
  bg:setAnchorPoint(ccp(0.5, 1))
  local labelHeroTips = ed.createttf(T("\229\135\186\229\190\129\232\139\177\233\155\132"), 18)
  labelHeroTips:setAnchorPoint(ccp(0, 0.5))
  labelHeroTips:setPosition(20, 12.5)
  ed.setLabelColor(labelHeroTips, ed.toccc3(4290884095))
  ed.setLabelStroke(labelHeroTips, ed.toccc3(2368548), 1)
  bg:addChild(labelHeroTips)
  container:addChild(bg)
  local heroes = self.curChapter._heroes or {}
  local line = math.ceil(#heroes / 5)
  container:setContentSize(CCSizeMake(523, 25 + line * 90))
  bg:setPosition(ccp(261.5, container:getContentSize().height - 2))
  local posX = 0
  local offsetX = 15
  local col = 5
  for index, heroInfo in ipairs(heroes) do
    local curLine = math.ceil(index / col)
    local heroId = heroInfo._heroid
    local heroIcon = self:createHeroIcon(heroId)
    container:addChild(heroIcon)
    local posY = 90 * (line - curLine) + 45
    heroIcon:setPosition(ccp(posX + offsetX + 45, posY))
    posX = posX + 100
    if index % col == 0 then
      posX = 0
    end
  end
  return container, container:getContentSize()
end

function class:createHeroIcon(heroId)
  local hero = ed.player:getHero(heroId)
  local heroIcon = ed.readhero.createIconByServer(hero)
  return heroIcon.icon
end

function class:createBlessItem()
  local container = CCLayerColor:create(ccc4(0, 0, 0, 0))
  container:ignoreAnchorPointForPosition(false)
  container:setAnchorPoint(ccp(0.5, 1))
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_2.png")
  bg:setContentSize(CCSizeMake(523, 24.5))
  bg:setAnchorPoint(ccp(0.5, 1))
  local labelBlessTips = ed.createttf(T("\232\142\183\229\190\151\231\165\157\231\166\143"), 18)
  labelBlessTips:setAnchorPoint(ccp(0, 0.5))
  labelBlessTips:setPosition(20, 12.5)
  ed.setLabelColor(labelBlessTips, ed.toccc3(4290884095))
  ed.setLabelStroke(labelBlessTips, ed.toccc3(2368548), 1)
  bg:addChild(labelBlessTips)
  container:addChild(bg)
  local blessList = self.curChapter._bless_list or {}
  local newBlessList = {}
  local rogueBlessTB = ed.getDataTable("RogueBless")
  for index, rogueBless in ipairs(blessList) do
    local blessId = rogueBless._bless
    if rogueBlessTB[blessId]["Bless Type"] ~= "RevelationBless" then
      table.insert(newBlessList, rogueBless)
    end
  end
  blessList = newBlessList
  local blessAmount = ed.createttf(#blessList, 18)
  blessAmount:setAnchorPoint(ccp(0, 0.5))
  blessAmount:setPosition(labelBlessTips:getContentSize().width + labelBlessTips:getPositionX() + 5, 12.5)
  ed.setLabelColor(blessAmount, ed.toccc3(16776423))
  ed.setLabelStroke(blessAmount, ed.toccc3(2368548), 1)
  bg:addChild(blessAmount)
  local showDestinyList = {}
  local showAmount = 0
  for index, rogueBless in ipairs(blessList) do
    local blessId = rogueBless._bless
    local destinyId = ed.getDataTable("RogueBless")[blessId]["Destiny ID"]
    if showDestinyList[destinyId] then
      showDestinyList[destinyId] = showDestinyList[destinyId] + 1
    else
      showDestinyList[destinyId] = 1
      showAmount = showAmount + 1
    end
  end
  local col = 7
  local row = math.ceil(showAmount / col)
  container:setContentSize(CCSizeMake(523, 25 + row * 80))
  local posX = 0
  local offsetX = 0
  local index = 0
  for destinyId, amount in pairs(showDestinyList) do
    index = index + 1
    local curLine = math.ceil(index / col)
    local icon = self:createDestinyAmountIcon(destinyId, amount)
    local size = icon:getContentSize()
    container:addChild(icon)
    local posY = size.height * (row - curLine) + 0
    icon:setPosition(ccp(posX + offsetX, posY))
    posX = posX + 75
    if index % col == 0 then
      posX = 0
    end
  end
  bg:setPosition(ccp(261.5, container:getContentSize().height - 2))
  return container, container:getContentSize()
end

function class:createDestinyAmountIcon(destinyId, amount)
  local container = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_tally_info_light.png")
  local containerSize = container:getContentSize()
  container:setAnchorPoint(ccp(0, 0))
  local iconName = ed.getDataTable("RogueDestiny")[destinyId].Icon or "bless_the_devil"
  local icon = ed.createSprite(string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", iconName))
  icon:setScale(0.4)
  container:addChild(icon)
  icon:setPosition(ccp(containerSize.width / 2, 45))
  local amountBg = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_3.png")
  local labelAmount = ed.createttf(amount, 18)
  amountBg:addChild(labelAmount)
  ed.layout.centerInParent(labelAmount)
  container:addChild(amountBg)
  amountBg:setPosition(ccp(containerSize.width / 2, 8))
  return container
end

function class:createAllBlessItem()
  local container = ed.createSprite()
  local destinyId = self.curChapter._destiny
  local blessList = ed.copyProto(self.curChapter._bless_list or {})
  table.sort(blessList, ed.cmpSort({
    {
      getValue = function(rogueBless)
        local blessId = rogueBless._bless
        return ed.getDataTable("RogueBless")[blessId].Rarity or 0
      end,
      reverse = true
    },
    {
      getValue = function(rogueBless)
        local blessId = rogueBless._bless
        return blessId
      end
    }
  }))
  local dataList = {}
  if self.rogueLikeMgr:getRevelationEnable(destinyId) then
    table.insert(dataList, {destinyId = destinyId})
  end
  for _, rogueBless in ipairs(blessList) do
    table.insert(dataList, {
      blessId = rogueBless._bless
    })
  end
  local col = 5
  local row = math.ceil(#dataList / col)
  local posX, posY = 0, 0
  local gapX, gapY = 10, 10
  local offsetX = 0
  local size = CCSizeMake(138.5, 174.5)
  local scale = 0.63
  container:setContentSize(CCSizeMake(size.width * col * 0.63 + (col - 1) * gapX, size.height * row * 0.63 + (row - 1) * gapY))
  local panelSize = container:getContentSize()
  for index, data in ipairs(dataList) do
    local icon = self:createBlessCardItem(data.blessId, data.destinyId)
    size = icon:getContentSize()
    container:addChild(icon)
    icon:setPosition(ccp(posX + offsetX + size.width * scale / 2, panelSize.height - posY - size.height * scale / 2))
    posX = posX + size.width * scale + gapX
    if index % col == 0 then
      posX = 0
      posY = posY + size.height * scale + gapY
    end
  end
  return container, panelSize
end

function class:createBlessCardItem(blessId, destinyId)
  local container = ed.createSprite()
  local blessItem, ui = ed.editorui(ed.uieditor.rogueCollectDestinyItem, {container = container})
  ui.image_select:setVisible(false)
  container:setScale(0.63)
  container:setContentSize(ui.image_bg:getContentSize())
  local rarity, icon, iconShadow
  if blessId then
    local rogueBlessCfg = ed.getDataTable("RogueBless")[blessId]
    icon = ed.rogueLikeTool.createBlessIcon(blessId)
    icon:setScale(0.65)
    iconShadow = ed.rogueLikeTool.createBlessIcon(blessId)
    rarity = rogueBlessCfg.Rarity or 1
    local typeName = ed.rogueDefine.BLESS_TYPE_TO_NAME[rogueBlessCfg["Bless Type"]] or T("\231\165\157\231\166\143")
    ed.setString(ui.label_type, typeName)
    ed.setString(ui.label_name, rogueBlessCfg["Bless Name"])
  elseif destinyId then
    local destinyCfg = ed.getDataTable("RogueDestiny")[destinyId]
    icon = ed.rogueLikeTool.createRevelationSimpleIcon(destinyId)
    icon:setScale(0.65)
    iconShadow = ed.rogueLikeTool.createRevelationSimpleIcon(destinyId)
    rarity = 4
    ed.setString(ui.label_type, T("\229\144\175\231\164\186"))
    ed.setString(ui.label_name, destinyCfg["Revelation Name"])
  end
  iconShadow:setScaleX(0.65)
  iconShadow:setScaleY(-0.65)
  iconShadow:setOpacity(26)
  iconShadow:setPositionY(-5)
  ui.panel_icon:addChild(icon)
  ed.layout.centerInParent(icon)
  ui.panel_icon:addChild(iconShadow)
  ed.layout.centerXInParent(iconShadow)
  ui.image_star_left:setPositionX(ui.label_type:getPositionX() - ui.label_type:getContentSize().width / 2 - 9)
  ui.image_star_right:setPositionX(ui.label_type:getPositionX() + ui.label_type:getContentSize().width / 2 + 9)
  local rarity_ui_cfg = ed.ui.rogueCollectDestinyScene.rarity_to_list_item_cfg[rarity]
  ed.setTexture(ui.image_star_left, rarity_ui_cfg.star)
  ed.setTexture(ui.image_star_right, rarity_ui_cfg.star)
  ed.setTexture(ui.image_bg, rarity_ui_cfg.card_bg)
  ed.setLabelColor(ui.label_type, rarity_ui_cfg.type_color)
  ed.setLabelStroke(ui.label_type, rarity_ui_cfg.type_stroke_color, 1)
  ed.setLabelColor(ui.label_name, rarity_ui_cfg.name_color)
  ed.setLabelStroke(ui.label_name, rarity_ui_cfg.name_stroke_color, 1)
  return container
end

function class:createAllCharmItem()
  self.charmCardUIArr = {}
  local container = CCLayerColor:create(ccc4(0, 0, 0, 0))
  container:ignoreAnchorPointForPosition(false)
  container:setAnchorPoint(ccp(0.5, 0.5))
  local oldCharms = self.curChapter._charm_list or {}
  local dataList = {}
  for i, oldCharm in ipairs(oldCharms) do
    local newCharm = self.newCharms[i]
    if oldCharm and newCharm and oldCharm._id == newCharm._charm_id then
      table.insert(dataList, {
        id = newCharm._charm_id,
        oldExp = oldCharm._exp,
        newExp = newCharm._exp
      })
    end
  end
  local itemScale = 0.82
  local itemSize = CCSizeMake(106 * itemScale, 141.5 * itemScale)
  local gapX, gapY = 10, 10
  local col = 5
  local row = math.ceil(#dataList / col - 0.001)
  local totalItemWidth = itemSize.width * col + (col - 1) * gapX
  local panelSize = CCSizeMake(523, itemSize.height * row + (row - 1) * gapY + 30)
  container:setContentSize(panelSize)
  local totalWeightVal = 0
  local posX = (panelSize.width - totalItemWidth) * 0.5
  local posY = panelSize.height - 30
  for index, data in ipairs(dataList) do
    local itemContainer, itemUI, itemWeight = self:createCharmCardItem(data)
    itemUI.bg:setScale(itemScale)
    container:addChild(itemContainer)
    local colIndex = (index - 1) % col + 1
    local rowIndex = math.ceil(index / col - 0.001)
    itemContainer:setPosition(posX + (colIndex - 0.5) * itemSize.width + (colIndex - 1) * gapX, posY - (rowIndex - 0.5) * itemSize.height - (rowIndex - 1) * gapY)
    totalWeightVal = totalWeightVal + itemWeight
    table.insert(self.charmCardUIArr, itemUI)
  end
  local bgSize = CCSizeMake(panelSize.width, 24.5)
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/instance/instance_tally_info_frame_2.png")
  bg:setContentSize(bgSize)
  bg:setAnchorPoint(ccp(0.5, 1))
  container:addChild(bg)
  bg:setPosition(bgSize.width * 0.5, panelSize.height)
  local charmTipsLabel = ed.createttf(T("\232\163\133\233\133\141\230\138\164\231\172\166"), 18)
  charmTipsLabel:setAnchorPoint(ccp(0, 0.5))
  charmTipsLabel:setPosition(20, bgSize.height * 0.5)
  ed.setLabelColor(charmTipsLabel, ed.toccc3(12759551))
  ed.setLabelStroke(charmTipsLabel, ed.toccc3(2368548), 1)
  bg:addChild(charmTipsLabel)
  local weightTipsLabel = ed.createttf(T("\232\180\159\233\135\141\239\188\154%d", totalWeightVal), 15)
  weightTipsLabel:setAnchorPoint(ccp(0, 0.5))
  weightTipsLabel:setPosition(charmTipsLabel:getPositionX() + charmTipsLabel:getContentSize().width + 10, bgSize.height * 0.5)
  ed.setLabelColor(weightTipsLabel, ed.toccc3(16770986))
  ed.setLabelStroke(weightTipsLabel, ed.toccc3(263719), 1)
  bg:addChild(weightTipsLabel)
  return container, panelSize
end

function class:createCharmCardItem(data)
  local container, ui = ed.editorui(ed.uieditor.rogueCharmBagCardItem)
  ui.img_mask:setVisible(false)
  ed.setTexture(ui.bg, "UI/alpha/1080P/rogue/charm/charm_normal_bg.png")
  ed.setLabelStroke(ui.label_weight, ed.toccc3(263719), 1)
  ui.heartImgArr = {}
  ui.heartSpaceArr = {}
  for i = 1, 999 do
    local img = ui["img_heart_" .. i]
    if nil == img then
      break
    end
    table.insert(ui.heartImgArr, img)
    table.insert(ui.heartSpaceArr, 5)
  end
  local charmTableItem = ed.getDataTable("RogueCharm")[data.id]
  ed.setTexture(ui.img_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  ed.setLabelString(ui.label_weight, charmTableItem.Weight)
  local starNum = self.rogueLikeMgr:getCharmStarNum(data.newExp, charmTableItem)
  local oldStarNum = self.rogueLikeMgr:getCharmStarNum(data.oldExp, charmTableItem)
  for i, v in ipairs(ui.heartImgArr) do
    v:setVisible(i <= starNum)
    v:setOpacity(i <= oldStarNum and 255 or 0)
  end
  ed.layout.horizontalSortNode(ui.heartImgArr, ui.heartSpaceArr, ui.bg:getContentSize().width * 0.5)
  return container, ui, charmTableItem.Weight
end

function class:checkCharmUpEffect()
  if nil == self.charmCardUIArr or #self.charmCardUIArr == 0 then
    return
  end
  local firstCardUI = self.charmCardUIArr[1]
  local pos = firstCardUI.bg:getParent():convertToWorldSpace(ed.getBottomPos(firstCardUI.bg))
  if ed.containsPoint(self.ui.panel_list, pos.x, pos.y) then
    local uiArr = self.charmCardUIArr
    self.charmCardUIArr = nil
    self:listenTimer(Timer:Once(0.5), function()
      self:playCharmUpEffect(uiArr)
    end)
  end
end

function class:playCharmUpEffect(uiArr)
  for _, ui in ipairs(uiArr) do
    local isAction = false
    for _, heartImg in ipairs(ui.heartImgArr) do
      if heartImg:isVisible() and heartImg:getOpacity() < 100 then
        isAction = true
        heartImg:setScale(9.6)
        local action1 = CCSpawn:create(ccArrayMake(CCFadeTo:create(0.1667, 89.25), CCScaleTo:create(0.1667, 6.6)))
        local action2 = CCSpawn:create(ccArrayMake(CCFadeTo:create(0.125, 255), CCScaleTo:create(0.125, 0.65)))
        local action3 = CCScaleTo:create(0.3, 1)
        local action = CCSequence:create(ccArrayMake(CCDelayTime:create(0.25), action1, action2, action3))
        heartImg:runAction(action)
      end
    end
    if isAction then
      local upEffect = ed.createFcaNode("eff_UI_rogue_addheart")
      upEffect:setScale(1 / ui.bg:getScale())
      self:addFcaOnce(upEffect)
      ui.bg:addChild(upEffect)
      local bgSize = ui.bg:getContentSize()
      upEffect:setPosition(bgSize.width * 0.5, bgSize.height * 0.5)
      upEffect:update(0)
      local arrowImg = ed.createSprite("UI/alpha/1080P/battleresult/arrow_up.png")
      ui.bg:addChild(arrowImg)
      local posY = ui.bg:getContentSize().height - arrowImg:getContentSize().height * 0.5 + 5
      arrowImg:setPosition(5, posY - 5)
      arrowImg:setOpacity(0)
      local action = CCSpawn:create(ccArrayMake(CCMoveBy:create(0.25, ccp(0, 5)), CCFadeIn:create(0.25)))
      action = CCEaseOut:create(action, 2)
      action = CCSequence:createWithTwoActions(CCDelayTime:create(0.9), action)
      arrowImg:runAction(action)
    end
  end
end

function class:createConfirmBtn()
  local btn = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_shop_buy.png")
  local label = ed.createttf(T("\231\161\174\229\174\154"), 24)
  ed.setLabelColor(label, ed.toccc3(16382443))
  btn:addChild(label)
  ed.layout.centerInParent(label)
  self:btRegisterButtonClick({
    button = btn,
    key = "btn_confirm",
    pressScale = 0.95,
    clickHandler = function()
      self:onClickBtnBack()
    end
  })
  return btn, btn:getContentSize()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_chapter_name, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_chapter_diff, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_chapter_progress_tips, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_chapter_progress, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_score, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_tech, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_hero_title, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_bless_title, ed.toccc3(2368548), 1)
  ed.setLabelStroke(self.ui.label_bless_amount, ed.toccc3(2368548), 1)
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\230\140\145\230\136\152\229\174\140\230\136\144"),
    fontSize = 45,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15971327),
    endColor = ed.toccc3(16707839),
    strokeSize = 3,
    strokeColor = ed.toccc3(5447810)
  })
  self.ui.image_bg_1:addChild(titleLabel.node)
  titleLabel.node:setPosition(ccp(430, 510))
end

function class:onClickBtnBack()
  self:destroy({
    skipAnim = true,
    callback = function()
      if self.closeCallBack then
        self.closeCallBack()
      end
    end
  })
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end)
end

function class:addEventListener()
end
