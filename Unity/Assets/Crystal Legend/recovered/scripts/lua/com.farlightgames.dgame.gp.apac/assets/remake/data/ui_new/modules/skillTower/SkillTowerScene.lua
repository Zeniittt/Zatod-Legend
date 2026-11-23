local base = ed.ui.commonscene
local SkillTowerScene = newclass(base.mt)
ed.ui.SkillTowerScene = SkillTowerScene
local getResType = ed.ui.configs.resType.getResType

function SkillTowerScene:initData()
  self.mgr = ed.SkillTowerManager
end

local fcaConfig = {
  {
    bgFca = "eff_UI_fancytower_light_str",
    titleFca = "eff_UI_fancytower_title_str",
    bgFcaPos = ccp(104, 202),
    titleFcaPos = ccp(105, 194.5),
    deco = {
      res = "UI/alpha/1080P/skilltower/main_tower_bg_4.png",
      pos = ccp(186, 377)
    }
  },
  {
    bgFca = "eff_UI_fancytower_light_agi",
    titleFca = "eff_UI_fancytower_title_agi",
    bgFcaPos = ccp(104, 202),
    titleFcaPos = ccp(104, 195)
  },
  {
    bgFca = "eff_UI_fancytower_light_int",
    titleFca = "eff_UI_fancytower_title_int",
    bgFcaPos = ccp(105, 207),
    titleFcaPos = ccp(105, 202),
    deco = {
      res = "UI/alpha/1080P/skilltower/main_tower_bg_6.png",
      pos = ccp(125, 398)
    }
  }
}

function SkillTowerScene:createTowerItem(data)
  local container, ui = ed.editorui(ed.uieditor.SkillTowerItem)
  ed.setTexture(ui.bg, string.format("UI/alpha/1080P/skilltower/main_tower_bg_%d.png", data.id))
  ed.setTexture(ui.frame, string.format("UI/alpha/1080P/skilltower/main_tower_frame_%d.png", data.id))
  ed.setTexture(ui.title, string.format("UI/alpha/1080P/skilltower/small_title_tower%d.png", data.id))
  ed.setLabelStroke(ui.label_num_floor, ccc3(27, 50, 81), 1)
  ed.setLabelStroke(ui.label_num_star, ccc3(27, 50, 81), 1)
  ed.setLabelStroke(ui.Label_5022, ccc3(27, 50, 81), 1)
  ed.setLabelStroke(ui.Label_5023, ccc3(27, 50, 81), 1)
  ui.Label_5023:limitWidthByScale(95)
  ed.setString(ui.label_num_floor, string.format("%d/%d", data.curfloor, data.maxFloor))
  ed.setString(ui.label_num_star, string.format("%d/%d", data.curStars, data.maxStars))
  if fcaConfig[data.id].deco then
    local deco = fcaConfig[data.id].deco
    local decoUI = ed.createSprite(deco.res)
    decoUI:setPosition(deco.pos)
    ui.frame:addChild(decoUI)
  end
  self:listenTimer(Timer:Once(data.id * 1), function()
    if tolua.isnull(ui.bg) then
      return
    end
    local bgFca = ed.createFcaNode(fcaConfig[data.id].bgFca)
    bgFca:setPosition(fcaConfig[data.id].bgFcaPos)
    self:addFca(bgFca)
    ui.bg:addChild(bgFca)
    bgFca:update(0)
    if EDCurLanguage == "cn" then
      local titleFca = ed.createFcaNode(fcaConfig[data.id].titleFca)
      titleFca:setPosition(fcaConfig[data.id].titleFcaPos)
      self:addFca(titleFca)
      ui.bg:addChild(titleFca, 99)
      titleFca:update(0)
    end
  end)
  return container, ui
end

function SkillTowerScene:createLockTowerItem()
  local container, ui = ed.editorui(ed.uieditor.SkillTowerLockItem)
  ed.setLabelStroke(ui.Label_4874, ed.toccc3(1642057), 1)
  ed.setLabelStroke(ui.label_time, ed.toccc3(11348174), 1)
  ed.setLabelStroke(ui.label_totaltime1, ed.toccc3(1313324), 1)
  ed.setLabelStroke(ui.label_totaltime2, ed.toccc3(1313324), 1)
  ed.setLabelStroke(ui.label_curfloor1, ed.toccc3(1313324), 1)
  ed.setLabelStroke(ui.label_curfloor2, ed.toccc3(1313324), 1)
  ed.setLabelStroke(ui.label_unopen1, ed.toccc3(3679493), 1)
  ed.setLabelStroke(ui.btn_buff_label, ed.toccc3(5907786), 1)
  ed.adaptLabel(ui.btn_buff_label, {maxWidth = 70, minScale = 0.6})
  local canOpenAbyss = ed.playerlimit.checkAreaUnlock("FancyAbyss")
  local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/skilltower/main_tower_bg_7.png", 0.5)
  clippingNode:setPosition(ed.getCenterPos(ui.bg))
  ui.bg:addChild(clippingNode)
  local lightFca = ed.createFcaNode("eff_UI_abyss_ring")
  self:addFca(lightFca)
  lightFca:setPositionY(-10)
  clippingNode:addChild(lightFca)
  local exTowerData = ed.SkillTowerManager.exTowerData
  if canOpenAbyss then
    ui.mask:setVisible(false)
    lightFca:setStartAction("Start2")
    lightFca:setLoopAction("Loop2")
    local handFca = ed.createFcaNode("eff_UI_abyss_hand")
    local img_flag
    if ed.isAreaZhCn() then
      img_flag = ed.createSprite("UI/alpha/1080P/common/ds.png")
    else
      img_flag = ed.createSprite("UI/alpha/1080P/common/ds-global.png")
    end
    local img_node = CCSprite:create()
    img_node:addChild(img_flag)
    handFca:addNodeToComponent(img_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    handFca:setPosition(ccpAdd(ed.getCenterPos(ui.frame), ccp(0, 0)))
    self:addFca(handFca)
    ui.frame:addChild(handFca)
    if ed.SkillTowerManager:isOpenExTower() then
      if not ed.storage.getBool("PlayedAbyssAnim") then
        local lockFca = ed.createFcaNode("eff_UI_abyss_lock")
        lockFca:setPosition(ccpAdd(ed.getCenterPos(ui.bg), ccp(-5, 0)))
        self:addFca(lockFca)
        ui.bg:addChild(lockFca)
        lockFca:setStartAction("Start2")
        lockFca:setLoopAction("")
        ed.storage.setValue("PlayedAbyssAnim", true)
      else
        handFca:setStartAction("Loop")
      end
      ed.setString(ui.label_curfloor1, string.format("%d/%d", exTowerData.passedFloors, exTowerData.maxFloor))
      if exTowerData.selfAbyssTime then
        ed.setString(ui.label_totaltime1, ed.gethmsNString(exTowerData.selfAbyssTime))
      else
        ed.setString(ui.label_totaltime1, T("\229\176\154\230\156\170\229\133\168\233\131\168\233\128\154\229\133\179"))
        ed.adaptLabel(ui.label_totaltime1, {maxWidth = 80, minScale = 0.7})
        ui.label_totaltime:limitWidthByScale(60)
      end
      ed.setString(ui.label_time, ed.time2dhmsV2(exTowerData.endTime - ed.getServerTime()))
      ed.right2(ui.label_time, ui.ImageView_4878, 1)
      if exTowerData.buffId then
        ui.btn_buff:setVisible(true)
      end
    else
      handFca:setStartAction("Loop")
      ui.bg_time:setVisible(false)
      ui.layer_info:setVisible(false)
      ui.label_unopen:setVisible(true)
    end
  else
    local lockFca = ed.createFcaNode("eff_UI_abyss_lock")
    lockFca:setPosition(ccpAdd(ed.getCenterPos(ui.bg), ccp(-5, 0)))
    self:addFca(lockFca)
    ui.bg:addChild(lockFca)
    ui.bg_info:setVisible(false)
    ui.bg_time:setVisible(false)
  end
  return container, ui
end

function SkillTowerScene:destroyPromptCard()
  if not tolua.isnull(self.detailContainer) then
    self.detailContainer:removeFromParentAndCleanup(true)
    self.detailContainer = nil
  end
end

function SkillTowerScene:refreshCandlePromptHandler()
  local count = 0
  
  local function handler(dt)
    if tolua.isnull(self.detailContainer) or tolua.isnull(self.vitPromptLabel) then
      self:removeUpdateHandler("refreshCandlePrompt")
      return
    end
    count = count + dt
    if 1 < count then
      local prompt = self:getCandlePromptText()
      ed.setString(self.vitPromptLabel, prompt)
      count = count - 1
    end
  end
  
  return handler
end

function SkillTowerScene:getCandlePromptText()
  if self.mgr.power >= self.mgr.maxPower then
    return string.format(T("\230\137\128\230\156\137\229\185\187\231\148\159\231\131\155\229\183\178\230\129\162\229\164\141\230\187\161!"))
  else
    self.nextTime = self.mgr.lastPowerTime + 1200 - ed.getServerTime()
    self.maxTime = (self.mgr.maxPower - self.mgr.power - 1) * 1200 + self.nextTime
    self.nextTimeStr = ed.gethmsNString(self.nextTime)
    self.maxTimeStr = ed.gethmsNString(self.maxTime)
    return string.format(T("\228\184\139\230\148\175\229\185\187\231\148\159\231\131\155\230\129\162\229\164\141\230\151\182\233\151\180\239\188\154%s\n\229\133\168\233\131\168\229\185\187\231\148\159\231\131\155\230\129\162\229\164\141\230\151\182\233\151\180\239\188\154%s"), self.nextTimeStr, self.maxTimeStr)
  end
end

function SkillTowerScene:createPromptCard(text)
  self:destroyPromptCard()
  local container = CCSprite:create()
  self.detailContainer = container
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png", CCRectMake(8, 8, 37, 37))
  bg:setAnchorPoint(ccp(1, 1))
  bg:setPosition(ccp(ed.display.winSize.width - 30, ed.display.winSize.height - 60))
  container:addChild(bg)
  local label = ed.createttf(text, 14)
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(label, ccc3(85, 64, 39), 1)
  bg:addChild(label)
  local size = label:getContentSize()
  bg:setContentSize(CCSizeMake(size.width + 20, size.height + 20))
  label:setPosition(ed.getCenterPos(bg))
  self.container:addChild(container, 60)
  return label
end

function SkillTowerScene:createCandlePrompt()
  local prompt = self:getCandlePromptText()
  local label = self:createPromptCard(prompt)
  self:registerUpdateHandler("refreshCandlePrompt", self:refreshCandlePromptHandler())
  self.vitPromptLabel = label
end

function SkillTowerScene:refreshDraglist()
  local towerData = self.mgr.towerData
  self.uiList = {}
  self.draglist:clearList()
  
  local function getPos(i)
    return ccp(130 + 260 * i, 0.4074074074074074 * ed.display.winSize.height)
  end
  
  for k, v in ipairs(towerData) do
    local container, ui = self:createTowerItem(v)
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k - 1))
  end
  local container, ui = self:createLockTowerItem()
  ui.isEx = true
  self.draglist:addItem(container)
  container:setPosition(getPos(#towerData))
  table.insert(self.uiList, ui)
  self.draglist:initListWidth(260 * #towerData + 280)
end

function SkillTowerScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.bg, x, y) then
        return v
      end
      if v.isEx and ed.containsPoint(v.layer_rank, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function SkillTowerScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if v.isEx and ed.containsPoint(v.layer_rank, x, y) then
      if ed.playerlimit.checkAreaUnlock("FancyAbyss") then
        ed.ui.SkillTowerAbyssRankWin.create()
      else
        local cpl = ed.playerlimit.getAreaUnlockPrompt("FancyAbyss")
        ed.showToast(cpl)
      end
      return
    end
    if v.isEx and v.btn_buff:isVisible() and ed.containsPoint(v.btn_buff, x, y) then
      local buffId = ed.SkillTowerManager.exTowerData and ed.SkillTowerManager.exTowerData.buffId or 0
      if buffId and 0 < buffId then
        ed.ui.SkillTowerBuffDetailWin.create()
      else
        ed.showToast(T("\230\156\172\230\156\159\231\171\158\233\128\159\230\151\160BUFF\229\138\160\230\136\144"))
      end
      return
    end
    if ed.containsPoint(v.bg, x, y) and self.hadHandleClick == false then
      if v.isEx then
        if ed.SkillTowerManager:isOpenExTower() then
          ed.SkillTowerNetwork:sendExTowerOpenPanel()
        elseif ed.playerlimit.checkAreaUnlock("FancyAbyss") then
          ed.showToast(T("\229\185\187\229\162\131\229\189\147\229\137\141\229\156\168\233\135\141\231\187\132\228\184\173..."))
        else
          local cpl = ed.playerlimit.getAreaUnlockPrompt("FancyAbyss")
          ed.showToast(cpl)
        end
      else
        self.hadHandleClick = true
        ed.pushScene(ed.ui.SkillTowerStageScene.create(v.data))
      end
    end
  end
  
  return handler
end

function SkillTowerScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if not v.bg then
      return
    end
    if tolua.isnull(v.bg) then
      return
    end
    v.bg:setScale(1)
  end
  
  return handler
end

function SkillTowerScene:initLabels()
  ed.setLabelStroke(self.ui.Label_4587, ccc3(81, 41, 27), 1)
  ed.setLabelStroke(self.ui.label_buff, ccc3(81, 41, 27), 1)
  ed.setLabelStroke(self.ui.label_power, ccc3(81, 41, 27), 1)
  self.ui.Label_4587:limitWidthByScale(70)
end

function SkillTowerScene:adaptUI()
  self.ui.layer_tower:setContentSize(CCSizeMake(ed.display.winSize.width, ed.display.winSize.height))
  ed.layout.layoutWithMagin(self.ui.bg_btn_power, {right = 44, top = 25})
  ed.layout.layoutWithMagin(self.ui.btn_buff, {right = 294, top = 20})
  ed.layout.layoutWithMagin(self.ui.btn_reward, {right = 169, top = 20})
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  self.ui.layer_tower:setPositionX(0)
  local fixWidth = ed.display.winSize.width - 1040
  if 0 < fixWidth then
    self.ui.layer_tower:setPositionX(self.ui.layer_tower:getPositionX() + fixWidth / 2)
  end
end

function SkillTowerScene:initUI()
  self.container = self.scene
  self.ui = {}
  local readnode = ed.readnode.create(self.container, self.ui)
  readnode:addNode(ed.uieditor.SkillTowerMainScene)
  self:setBackground("UI/alpha/1080P/skilltower/bg1080_main.png")
  self:setBackButton()
  self.back_button:removeFromParentAndCleanup(false)
  self.back_button:setZOrder(0)
  self.scene:addChild(self.back_button)
  ed.layout.layoutWithMagin(self.back_button, {left = 0, top = 0})
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\185\187\229\162\131\228\185\139\229\161\148"), self.ui.bg_title, {
    position = ccp(18, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:adaptUI()
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_tower, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -100
  })
  local mainFca = ed.createFcaNode("eff_UI_fancytower_particle_main")
  mainFca:setPosition(ccp(0, 0))
  self:addFca(mainFca)
  self.container:addChild(mainFca, 1)
  mainFca:setAction("Loop")
  local cloudFca = ed.createFcaNode("eff_UI_fancytower_cloud")
  cloudFca:setPosition(ccp(ed.display.center.x, ed.display.center.y))
  self:addFca(cloudFca)
  self.mainLayer:addChild(cloudFca)
end

function SkillTowerScene:refreshCandleNum()
  local numAction = ed.UITool.getRefreshAction()
  self.ui.label_power:runAction(numAction)
  ed.setString(self.ui.label_power, string.format("%d/%d", self.mgr.power, self.mgr.maxPower))
end

function SkillTowerScene:registerEvents()
  self:listenEvent("SkillTowerCandleBuyReply", function()
    self:refreshCandleNum()
  end)
  self:listenEvent("FancyTowerCandleChange", function()
    self:refreshCandleNum()
  end)
  self:listenEvent("SkillExTowerOpenPanel", function()
    ed.pushScene(ed.ui.SkillTowerExStageScene.create())
  end)
end

function SkillTowerScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.SkillTowerRuleWin.create({}):popWindow(999)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.ui.SkillTowerRewardWin.create({
      callback = function()
        self:refreshRedLight()
      end
    })
  end, {pressScale = 0.9})
  self:btRegisterButtonClick({
    button = self.ui.bg_btn_power,
    key = "bg_btn_power",
    pressHandler = function()
      self:createCandlePrompt()
    end,
    cancelPressHandler = function()
      self:destroyPromptCard(self)
    end,
    force = true,
    mcpMode = true
  })
  ed.UITool.registerBtn(self, "icon_add_power", function()
    ed.ui.buyResourceBox.create({
      buyLimitNum = self.mgr.buyTimes,
      defaultBuyNum = 1,
      goodsResType = getResType("item"),
      goodsId = 20018,
      costResType = getResType("diamond"),
      price = self.mgr.price,
      ownedAmount = self.mgr.power,
      buyAction = function(num)
        if 0 < num then
          ed.SkillTowerNetwork:sendTowerCandleBuy(num)
        end
      end
    }):popWindow()
  end, {pressScale = 0.9})
end

function SkillTowerScene:refreshUI()
  ed.setString(self.ui.label_power, string.format("%d/%d", self.mgr.power, self.mgr.maxPower))
  self:refreshRedLight()
  self:refreshDraglist()
end

function SkillTowerScene:refreshRedLight()
  self.ui.icon_redLight:setVisible(self.mgr.redLight)
end

function SkillTowerScene.create()
  local self = base.create("SkillTowerScene", {noBottomButton = true})
  setmetatable(self, SkillTowerScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnEnterHandler("onEnter", function()
    self:refreshUI()
    self.hadHandleClick = false
  end)
  return self
end
