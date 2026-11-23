local base = ed.ui.commonscene
local PetMainScene = newclass(base.mt)
ed.ui.PetMainScene = PetMainScene
local purplePetLimit = 21
ed.UITool.registViewOpenFunc("PetMainScene", function(param)
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Pet")
  if cpl then
    ed.showToast(cpl)
    return
  end
  ed.PetNetwork:openPanel()
end)

local function selectBtn(btn)
  if not btn then
    return
  end
  btn.select_btn:setVisible(true)
  btn.select_label:setVisible(true)
  btn.normal_label:setVisible(false)
end

local function unSelectBtn(btn)
  if not btn then
    return
  end
  btn.select_btn:setVisible(false)
  btn.select_label:setVisible(false)
  btn.normal_label:setVisible(true)
end

local function cntPurplePets()
  local petsInfo = ed.player:getPets()
  local cnt = 0
  for _, pet in pairs(petsInfo) do
    if pet:getColor() == 3 then
      cnt = cnt + 1
    end
  end
  return cnt
end

local function isDecompLock()
  return ed.PetModel:getCanOpenDecomp() == 0 and #ed.player:getPets() < 30
end

function PetMainScene:setConfig()
  self.select_btn_config = {
    {
      name = T("\229\173\181\229\140\150"),
      clickHandler = function()
        self.lucky_layer.ui.lucky_bg:setVisible(true)
        self:showLayer(1)
      end,
      uiName = "btn_hatch",
      exitHandler = function()
        CloseTimer("updateEggs")
        self.lucky_layer.ui.lucky_bg:setVisible(false)
      end
    },
    {
      name = T("\228\191\161\228\189\191"),
      clickHandler = function()
        self:showLayer(2)
      end,
      uiName = "btn_pet",
      exitHandler = function()
        self.tbView.dragList:setVisible(false)
        self.decompGetDraglist:setVisible(false)
        local layer = self.hero_pet_layer
        local config = self.hero_pet_layer.filter_config
        unSelectBtn(layer.ui[config[layer.cur_index].uiName])
        layer.cur_index = nil
      end
    },
    {
      name = T("\230\148\190\231\148\159"),
      clickHandler = function()
        if isDecompLock() then
          ed.showToast(T("\230\139\165\230\156\13730\228\184\170\229\143\138\228\187\165\228\184\138\231\154\132\228\191\161\228\189\191\230\137\141\232\131\189\232\167\163\233\148\129\229\146\140\228\189\191\231\148\168"))
          return
        end
        if ed.PetModel:getCanOpenDecomp() == 0 then
          ed.PetModel.canOpenDecomp = 1
        end
        self:showLayer(3)
      end,
      uiName = "btn_decomp",
      exitHandler = function()
        self.tbView.dragList:setVisible(false)
        self.decompGetDraglist:setVisible(false)
      end
    }
  }
end

function PetMainScene.create(param)
  local self = base.create("PetMainScene", {noBottomButton = true})
  setmetatable(self, PetMainScene.mt)
  self:init(param or {})
  self:registerOnPopSceneHandler("onPop", function()
    ed.PetManager:setRedFlag(ed.PetModel:isEggCanOpen())
    ed.PetManager.mainScene = nil
  end)
  return self
end

function PetMainScene:init(param)
  self.layers = {}
  self.eggs = {}
  self.decompGetList = {}
  self.selectDecompIndex = {}
  self.purplePetCnt = 0
  self:setConfig()
  self:createUI()
  self:createLayer()
  self:adaptUI()
  self:registerEvents()
  self:showLayer(1)
end

function PetMainScene:showLayer(index)
  if self.select_layer and self.select_layer == index then
    return
  end
  if self.select_layer then
    self.layers[self.select_layer]:setVisible(false)
    local config = self.select_btn_config[self.select_layer]
    config.exitHandler()
  end
  self.layers[index]:setVisible(true)
  self.select_layer = index
  self:refreshLayerButton()
  if index == 1 then
    self:refreshEggsInfo()
    self:registerHatchingEvent()
  elseif index == 2 then
    self.tbView.dragList:setVisible(true)
    self:refreshHeroPetList()
    self.hero_pet_layer.filter_index = 1
    self:refreshHeroPetLayer()
  elseif index == 3 then
    self.selectDecompIndex = {}
    self.decompGetList = {}
    self.purplePetCnt = 0
    self.decompTbView.dragList:setVisible(true)
    self.decompGetDraglist:setVisible(true)
    self:refreshDecompLayer()
  end
end

local function createSideListBtn(name, lock)
  local container = CCSprite:create()
  local select_btn = ed.createSprite("UI/alpha/1080P/pet/pet_room_selected.png")
  local btn_size = select_btn:getContentSize()
  container:setContentSize(btn_size)
  local select_label = ed.createLabelTTF(name, 19)
  ed.setLabelColor(select_label, ed.toccc3(9915407))
  ed.setLabelStroke(select_label, ed.toccc3(16773013), 1.5)
  container:addChild(select_btn)
  ed.setPosition(select_btn, ccp(btn_size.width * 0.5, btn_size.height * 0.5))
  container:addChild(select_label)
  ed.setPosition(select_label, ccp(btn_size.width * 0.5 - 15, btn_size.height * 0.5))
  select_label:setVisible(false)
  select_btn:setVisible(false)
  local normal_label = ed.createLabelTTF(name, 19)
  ed.setLabelColor(normal_label, ed.toccc3(15520938))
  container:addChild(normal_label)
  ed.setPosition(normal_label, ccp(btn_size.width * 0.5 - 15, btn_size.height * 0.5))
  container.select_label = select_label
  container.select_btn = select_btn
  container.normal_label = normal_label
  if lock then
    ed.setLabelColor(normal_label, ed.toccc3(10855588))
    local lock_icon = ed.createSprite("UI/alpha/1080P/skill/skill_lock.png")
    lock_icon:setScale(0.32)
    normal_label:addChild(lock_icon)
    local lab_size = normal_label:getContentSize()
    lock_icon:setPosition(ccp(lab_size.width + 8, lab_size.height * 0.6))
    lock_icon:setColor(ccc3(190, 190, 190))
    container.lock = lock_icon
  end
  return container
end

function PetMainScene:createUI()
  local container, ui = ed.editorui(ed.uieditor.petHouseMainScene)
  self.ui = ui
  self.container = container
  self.layerBtns = {}
  local light1 = ed.createSpine("effect/eff_UI_Main_Pet_Room_Light/eff_UI_Main_Pet_Room_Light", 0.4)
  local light2 = ed.createSpine("effect/eff_UI_Main_Pet_Room_Light/eff_UI_Main_Pet_Room_Light", 0.4)
  local light3 = ed.createSpine("effect/eff_UI_Main_Pet_Room_Light/eff_UI_Main_Pet_Room_Light", 0.4)
  local light4 = ed.createSpine("effect/eff_UI_Main_Pet_Room_Light/eff_UI_Main_Pet_Room_Light", 0.4)
  light1:setAnimation(0, "Idle", true)
  light2:setAnimation(0, "Idle", true)
  light3:setAnimation(0, "Idle", true)
  light4:setAnimation(0, "Idle", true)
  ui.panel_light1:addChild(light1)
  ui.panel_light2:addChild(light2)
  ui.panel_light3:addChild(light3)
  ui.panel_light4:addChild(light4)
  light2:setScaleX(-1)
  light3:setScaleX(-1)
  light2:setOpacity(100)
  light4:setOpacity(100)
  local shop_label = ed.ui.gradientLabel.create({
    text = T("\229\133\145\230\141\162"),
    fontSize = 16,
    startColor = ed.toccc3(16776937),
    endColor = ed.toccc3(16770670),
    strokeColor = ed.toccc3(13464576),
    strokeSize = 1,
    shadowColor = ed.toccc3(0),
    shadowOffset = ccp(0, -0.5)
  })
  ui.shop_label_bg:addChild(shop_label.node)
  ed.layout.centerInParent(shop_label.node)
  self:btRegisterButtonClick({
    button = ui.shop_btn,
    key = "shop_btn",
    clickHandler = function()
      ed.UITool.openView("shopMain", {page = 7})
    end
  })
  self.mainLayer:addChild(self.container)
  ed.layout.lazyAdaptBG(self.ui.bg)
  ed.UITool.createSceneTitle(T("\228\191\161\228\189\191\229\177\139"), self.ui.scene_title, {
    position = ccp(18, 18)
  })
  self:setBackButton(function()
  end)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_draglist, {})
  for i, conf in ipairs(self.select_btn_config) do
    local btn
    if i == 3 then
      local lock = isDecompLock()
      btn = createSideListBtn(conf.name, lock)
      if lock then
        self.decompBtn = btn
      end
    else
      btn = createSideListBtn(conf.name)
    end
    self.draglist:addItem(btn)
    local size = btn:getContentSize()
    local posy = 220 - i * 55 + size.height * 0.5
    local posx = size.width * 0.5
    ed.setPosition(btn, ccp(posx, posy))
    self.layerBtns[i] = btn
  end
end

function PetMainScene:unlockDecompBtn()
  ed.setLabelColor(self.decompBtn.normal_label, ed.toccc3(15520938))
  self.decompBtn.lock:setVisible(false)
  self.decompBtn = nil
end

function PetMainScene:refreshLayerButton()
  if self.curLayer and self.curLayer == self.select_layer then
    return
  end
  if self.curLayer then
    unSelectBtn(self.layerBtns[self.curLayer])
  end
  self.curLayer = self.select_layer
  selectBtn(self.layerBtns[self.select_layer])
end

function PetMainScene:adaptUI()
  local ui = self.ui
  ed.layout.layoutWithMagin(ui.layer_draglist, {top = 85}, false, true)
  ed.layout.layoutWithMagin(ui.shop_btn, {bottom = 85}, false, true)
  ed.layout.layoutWithMagin(ui.scene_title, {left = 70, top = 18})
  ed.layout.layoutWithMagin(self.lucky_layer.ui.panel_side_lucky, {left = 0, top = 65})
  ed.UITool.setPositionBy(self.lucky_layer.ui.panel_side_lucky, ccp(-30, 0))
  local diffWidth = ed.display.winSize.width - 960
  local diffHeight = ed.display.winSize.height - 540
  ed.UITool.setPositionBy(ui.layer_draglist, ccp(diffWidth * 0.3, 0))
  ed.UITool.setPositionBy(ui.shop_btn, ccp(diffWidth * 0.3, 0))
end

function PetMainScene:createLayer()
  local ui = self.ui
  self:createHatchLayer()
  self:createHeroPetLayer()
  self:createDecompLayer()
  self:createLuckyLayer()
  for i = 1, #self.layers do
    self.layers[i]:setVisible(false)
  end
end

function PetMainScene:createHatchLayer()
  local hatch_layer = CCLayer:create()
  ed.setZOrder(hatch_layer, 10)
  self.hatch_layer = hatch_layer
  self.mainLayer:addChild(hatch_layer)
  hatch_layer.container, hatch_layer.ui = ed.editorui(ed.uieditor.PetHatchWin)
  hatch_layer:addChild(hatch_layer.container)
  self.layers[1] = hatch_layer
  self.eggNests = {}
  for i = 1, 6 do
    local container, ui = ed.editorui(ed.uieditor.PetGrassItem)
    self.eggNests[i] = {container = container, ui = ui}
    self.hatch_layer.ui["nest" .. i]:addChild(container)
    ed.setLabelStroke(ui.label_hatch, ed.toccc3(5717532), 1)
    local label_open = ed.ui.gradientLabel.create({
      text = T("\229\143\175\233\162\134\229\143\150"),
      fontSize = 23,
      startColor = ed.toccc3(16774562),
      endColor = ed.toccc3(16774562),
      strokeSize = 1.5,
      strokeStartColor = ed.toccc3(16752171),
      strokeEndColor = ed.toccc3(12274194)
    })
    ui.label_open:addChild(label_open.node)
    ed.setString(ui.label_open, "")
    ui.image_add:runAction(ed.UITool.getBreathAction(1.2))
    self:btRegisterButtonClick({
      button = ui.hatching,
      key = "hatch" .. i,
      clickHandler = function()
        ed.ui.PetChooseHatchWin.create({index = i})
      end
    })
    self:btRegisterButtonClick({
      button = ui.egg,
      key = "clickEgg" .. i,
      clickHandler = function()
        local status = self.eggNests[i].status
        if status == EGG_HATCH_STATUS.INPROGRESS then
          ed.PetNetwork:openPanel()
          ed.ui.PetAddSpeedWin.create({index = i, controller = self})
        elseif status == EGG_HATCH_STATUS.FINISHED then
          self.mainLayer:setTouchEnabled(false)
          self:listenTimer(Timer:Once(2.7), function()
            self.mainLayer:setTouchEnabled(true)
          end)
          ed.PetNetwork:openEgg(i)
        end
      end,
      clickInterval = 0.3
    })
  end
end

function PetMainScene:registerHatchingEvent()
  self:refreshHatchLayer()
  self:listenTimer(Timer:Always(1, "updateEggs"), function()
    self:refreshHatchLayer()
  end)
end

function PetMainScene:refreshHatchLayer()
  for i = 1, 6 do
    self:refreshEgg(i)
  end
end

function PetMainScene:refreshEggsInfo()
  self.eggs = ed.PetModel:getHatchEggData()
end

function PetMainScene:refreshEgg(index)
  if self.eggs[index] then
    if ed.PetModel:isEggFinished(index) then
      self:refreshEggUI(index, EGG_HATCH_STATUS.FINISHED)
    else
      self:refreshEggUI(index, EGG_HATCH_STATUS.INPROGRESS)
    end
  else
    self:refreshEggUI(index, EGG_HATCH_STATUS.EMPTY)
  end
end

function PetMainScene:refreshEggUI(index, status)
  local eggNest = self.eggNests[index]
  local ui = eggNest.ui
  if status == EGG_HATCH_STATUS.EMPTY then
    ui.bg_timer:setVisible(false)
    ui.label_open:setVisible(false)
    ui.egg:setVisible(false)
    ui.hatching:setVisible(true)
    if eggNest.fca then
      self:removeFca(eggNest.fca)
      eggNest.fca:removeFromParentAndCleanup(true)
      eggNest.fca = nil
      eggNest.fcaName = nil
      eggNest.status = EGG_HATCH_STATUS.EMPTY
    end
  elseif status == EGG_HATCH_STATUS.INPROGRESS then
    ui.bg_timer:setVisible(true)
    ui.label_open:setVisible(false)
    ui.egg:setVisible(true)
    ui.hatching:setVisible(false)
    ed.setString(ui.label_timer, ed.PetModel:getTimeStr(index))
    if not eggNest.fca then
      local eggRes = ed.PetModel:getEggFca(index)
      if eggRes then
        local eggUI = ed.createFcaNode(eggRes)
        self:addFca(eggUI)
        ui.egg:addChild(eggUI)
        if self.beginHatchEggIndex and self.beginHatchEggIndex == index then
          local action1 = CCCallFunc:create(function()
            eggUI:setAction("Exchange")
          end)
          local action2 = CCDelayTime:create(3)
          local action3 = CCCallFunc:create(function()
            eggUI:setAction("Idle")
            eggUI:setLoopAction("Idle")
          end)
          local appearAction = CCSequence:create(ccArrayMake(action1, action2, action3))
          ui.egg:runAction(appearAction)
          self.beginHatchEggIndex = nil
        else
          eggUI:setAction("Idle")
          eggUI:setLoopAction("Idle")
        end
        local size = ui.egg:getContentSize()
        eggUI:setPosition(ccp(size.width * 0.5, 20))
        eggNest.fca = eggUI
        eggNest.fcaName = "Idle"
        eggNest.status = EGG_HATCH_STATUS.INPROGRESS
      end
    end
  elseif status == EGG_HATCH_STATUS.FINISHED then
    ui.bg_timer:setVisible(false)
    ui.label_open:setVisible(true)
    ui.egg:setVisible(true)
    ui.hatching:setVisible(false)
    if not eggNest.fca then
      local eggRes = ed.PetModel:getEggFca(index)
      if eggRes then
        local eggUI = ed.createFcaNode(eggRes)
        self:addFca(eggUI)
        eggUI:setAction("shake")
        eggUI:setLoopAction("shake")
        eggUI:setLoop(true)
        local size = ui.egg:getContentSize()
        ui.egg:addChild(eggUI)
        eggUI:setPosition(ccp(size.width * 0.5, 20))
        eggNest.fca = eggUI
      end
    elseif eggNest.fca and eggNest.fcaName == "Idle" then
      ui.egg:stopAllActions()
      eggNest.fca:setAction("shake")
      eggNest.fca:setLoopAction("shake")
      eggNest.fca:setLoop(true)
    end
    eggNest.fcaName = "shake"
    eggNest.status = EGG_HATCH_STATUS.FINISHED
  end
end

function PetMainScene:createHeroPetLayer()
  local hero_pet_layer = CCLayer:create()
  ed.setZOrder(hero_pet_layer, 10)
  self.hero_pet_layer = hero_pet_layer
  self.mainLayer:addChild(hero_pet_layer)
  hero_pet_layer.container, hero_pet_layer.ui = ed.editorui(ed.uieditor.petHousePetWindow)
  hero_pet_layer:addChild(hero_pet_layer.container)
  self.layers[2] = hero_pet_layer
  ed.setLabelStroke(hero_pet_layer.ui.no_pet_label, ed.toccc3(2565412), 1)
  self.heroPetShowList = ed.player:getPets()
  self.heroPetInfoList = {}
  self:initHeroLayerTableView()
  self.filter_draglist = ed.UITool.createDraglist(hero_pet_layer.ui.panel_select, {})
  hero_pet_layer.filter_config = {
    {
      type = "all",
      btnName = T("\229\133\168\233\131\168"),
      handler = function()
        self.hero_pet_layer.filter_index = 1
        self:refreshHeroPetLayer()
      end,
      uiName = "btn_all"
    },
    {
      type = "color",
      color = 4,
      btnName = T("\230\169\153\232\137\178"),
      handler = function()
        self.hero_pet_layer.filter_index = 2
        self:refreshHeroPetLayer()
      end,
      uiName = "btn_lv4"
    },
    {
      type = "color",
      color = 3,
      btnName = T("\231\180\171\232\137\178"),
      handler = function()
        self.hero_pet_layer.filter_index = 3
        self:refreshHeroPetLayer()
      end,
      uiName = "btn_lv3"
    },
    {
      type = "color",
      color = 2,
      btnName = T("\232\147\157\232\137\178"),
      handler = function()
        self.hero_pet_layer.filter_index = 4
        self:refreshHeroPetLayer()
      end,
      uiName = "btn_lv2"
    },
    {
      type = "carried",
      carried = true,
      btnName = T("\229\183\178\233\162\134\229\133\187"),
      handler = function()
        self.hero_pet_layer.filter_index = 5
        self:refreshHeroPetLayer()
      end,
      uiName = "btn_carried"
    },
    {
      type = "carried",
      carried = false,
      btnName = T("\230\156\170\233\162\134\229\133\187"),
      handler = function()
        self.hero_pet_layer.filter_index = 6
        self:refreshHeroPetLayer()
      end,
      uiName = "btn_uncarried"
    }
  }
  self:createFilterDraglistBtn()
end

function PetMainScene:refreshHeroPetList()
  self.heroPetInfoList = {}
  self.heroPetShowList = {}
  local pets = ed.player:getPets()
  local info = {}
  for _, pet in pairs(pets) do
    table.insert(info, pet)
  end
  info = ed.Pet.sort(info)
  self.heroPetInfoList.all = info
end

function PetMainScene:filterPet()
  local config = self.hero_pet_layer.filter_config[self.hero_pet_layer.filter_index]
  self.heroPetShowList = {}
  local type = config.type
  if type == "all" then
    for i = 1, #self.heroPetInfoList[type] do
      self.heroPetShowList[i] = self.heroPetInfoList[type][i]
    end
  elseif type == "color" then
    local color = config.color
    if not self.heroPetInfoList[type .. color] then
      local info = {}
      for i = 1, #self.heroPetInfoList.all do
        if self.heroPetInfoList.all[i]:getColor() == color then
          table.insert(info, self.heroPetInfoList.all[i])
        end
      end
      self.heroPetInfoList[type .. color] = info
    end
    for i = 1, #self.heroPetInfoList[type .. color] do
      self.heroPetShowList[i] = self.heroPetInfoList[type .. color][i]
    end
  elseif type == "carried" then
    local carried, ind = config.carried, 0
    if carried then
      ind = 1
    end
    if not self.heroPetInfoList[type .. ind] then
      local info = {}
      for i = 1, #self.heroPetInfoList.all do
        local carried_id = self.heroPetInfoList.all[i]:getCarriedHeroId()
        if carried_id and 0 < carried_id and carried then
          table.insert(info, self.heroPetInfoList.all[i])
        elseif not carried and (not carried_id or carried_id <= 0) then
          table.insert(info, self.heroPetInfoList.all[i])
        end
      end
      self.heroPetInfoList[type .. ind] = info
    end
    for i = 1, #self.heroPetInfoList[type .. ind] do
      self.heroPetShowList[i] = self.heroPetInfoList[type .. ind][i]
    end
  end
end

function PetMainScene:initHeroLayerTableView()
  self.heroPetShowList = {}
  local delegate = {
    numberOfCells = function()
      return #self.heroPetShowList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(373, 121)
    end,
    createCell = function(index)
      local petInfo = self.heroPetShowList[index]
      local node, ui = self:createHeroPetItem(petInfo)
      return node, {
        playerInfo = petInfo,
        ui = ui,
        index = index
      }
    end,
    doClickIn = function(cell, x, y)
      local param = cell.data
      local ui = param.ui
      self.lastPosX, self.lastPosY = self.tbView:getListPos()
      ed.ui.PetInfoWin.create({
        index = param.index,
        petList = self.heroPetShowList,
        exitHandler = function()
          self:refreshHeroPetList()
          self:refreshHeroPetLayer(true)
        end
      })
    end,
    doPressIn = function(cell, x, y)
      return cell
    end,
    cancelPressIn = function(cell)
    end
  }
  local size = self.hero_pet_layer.ui.panel_showPet:getContentSize()
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.hero_pet_layer.ui.panel_showPet,
    touchpriority = -300,
    zorder = 1,
    dragMode = 1,
    colNum = 2,
    noshade = true,
    padding = {width = 10, height = 3}
  }
  self.tbView = Tableview.create(param)
  self.tbView.dragList:setVisible(false)
end

function PetMainScene:createHeroPetItem(pet)
  local container, ui = ed.editorui(ed.uieditor.singleHeroPetInfoPanel)
  container:setContentSize(CCSizeMake(370, 116))
  local icon_bg = ed.createSprite("UI/alpha/1080P/common/frame/hero_icon_bg.png")
  icon_bg:setScale(1.12)
  local icon = ed.readpet.createIconById(pet:getId(), {noLevel = true, showTag = true}).icon
  icon:setScale(1.2)
  ui.head:addChild(icon_bg)
  icon_bg:setPosition(ccp(0, 1))
  ui.head:addChild(icon)
  local type = ed.getDataTable("Unit")[pet:getTypeId()]["Hero Type"]
  if type == T("\229\138\155\233\135\143") then
    ed.setTexture(ui.pet_attr, "UI/alpha/1080P/hero/hero_str.png")
  elseif type == T("\230\149\143\230\141\183") then
    ed.setTexture(ui.pet_attr, "UI/alpha/1080P/hero/hero_agi.png")
  elseif type == T("\230\153\186\229\138\155") then
    ed.setTexture(ui.pet_attr, "UI/alpha/1080P/hero/hero_int.png")
  end
  ed.setTexture(ui.ImageView_67414, string.format("UI/alpha/1080P/pet/pet_name_bg_%d.png", pet:getColor() - 1))
  local name_label = ed.createLabelTTF(pet:getName(), 24)
  ed.setLabelColor(name_label, ed.toccc3(16776423))
  ed.setLabelStroke(name_label, ed.toccc3(0), 1.5)
  ed.setAnchor(name_label, ed.ccp(0, 0.5))
  ed.setPosition(name_label, ed.ccp(ui.pet_attr:getContentSize().width + 5, ui.pet_attr:getContentSize().height * 0.5))
  ui.pet_name:addChild(name_label)
  local level_label = ed.createLabelTTF("+" .. pet:getLevel(), 24)
  ed.setLabelColor(level_label, ed.toccc3(3014450))
  ed.setLabelStroke(level_label, ed.toccc3(0), 1.5)
  ui.pet_name:addChild(level_label)
  ed.right2(level_label, name_label, 5)
  level_label:setVisible(0 < pet:getLevel())
  local master_lab = ed.createLabelTTF("\228\184\187\228\186\186\239\188\154", 19)
  ed.setLabelColor(master_lab, ed.toccc3(7037275))
  ui.master_label:addChild(master_lab)
  local hero_icon, hero_bg
  local master = ed.player.heroes[pet:getCarriedHeroId()]
  if master then
    hero_icon = ed.readhero.createPureIcon({
      id = master._tid,
      noStar = true,
      rank = master._rank
    }).icon
    hero_bg = ed.createSprite("UI/alpha/1080P/common/frame/hero_icon_bg.png")
  else
    hero_bg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_hero_bg.png")
    hero_icon = ed.createSprite("UI/alpha/1080P/pet/incubate/pet_house_hatch_add_egg.png")
    hero_icon:setScale(2)
  end
  hero_bg:setScale(35 / hero_bg:getContentSize().width)
  local size = hero_bg:getContentSize().width
  ed.setPosition(hero_icon, ed.ccp(size * 0.5, size * 0.5))
  hero_bg:addChild(hero_icon)
  ui.master_label:addChild(hero_bg)
  ed.right2(hero_bg, master_lab, 5)
  if master then
    local master_name_lab = ed.createLabelTTF(master:getDisplayName(), 19)
    ed.setLabelColor(master_name_lab, ed.toccc3(7037275))
    ui.master_label:addChild(master_name_lab)
    ed.right2(master_name_lab, hero_bg, 5)
  end
  return container, ui
end

function PetMainScene:createFilterDraglistBtn()
  for i, config in ipairs(self.hero_pet_layer.filter_config) do
    local container = CCSprite:create()
    local select_btn = ed.createSprite("UI/alpha/1080P/pet/pet_room_tag_chosen_2.png")
    local btn_size = select_btn:getContentSize()
    container:setContentSize(btn_size)
    local select_label = ed.createLabelTTF(config.btnName, 17)
    ed.setLabelColor(select_label, ed.toccc3(16776423))
    container:addChild(select_btn)
    ed.setPosition(select_btn, ccp(btn_size.width * 0.5, btn_size.height * 0.5))
    container:addChild(select_label)
    ed.setPosition(select_label, ccp(btn_size.width * 0.5, btn_size.height * 0.5))
    select_label:setVisible(false)
    select_btn:setVisible(false)
    local normal_label = ed.createLabelTTF(config.btnName, 17)
    ed.setLabelColor(normal_label, ed.toccc3(10194042))
    container:addChild(normal_label)
    ed.setPosition(normal_label, ccp(btn_size.width * 0.5, btn_size.height * 0.5))
    container.select_label = select_label
    container.select_btn = select_btn
    container.normal_label = normal_label
    ed.setPosition(container, ccp(btn_size.width * (i - 0.5), btn_size.height * 0.5))
    self.filter_draglist:addItem(container)
    self.hero_pet_layer.ui[config.uiName] = container
  end
end

function PetMainScene:refreshHeroPetLayer(force)
  local layer = self.hero_pet_layer
  local config = self.hero_pet_layer.filter_config
  if layer.cur_index and layer.cur_index == layer.filter_index and (force == nil or force == false) then
    return
  end
  if layer.cur_index then
    unSelectBtn(layer.ui[config[layer.cur_index].uiName])
  end
  selectBtn(layer.ui[config[layer.filter_index].uiName])
  layer.cur_index = layer.filter_index
  self:filterPet()
  layer.ui.no_pet:setVisible(#self.heroPetShowList == 0)
  self.tbView:reloadData()
  if self.lastPosX then
    self.tbView:setListPos(ccp(self.lastPosX, self.lastPosY))
    self.lastPosX = nil
    self.lastPosY = nil
  end
end

function PetMainScene:createDecompLayer()
  local decomp_layer = CCLayer:create()
  ed.setZOrder(decomp_layer, 10)
  self.decomp_layer = decomp_layer
  self.mainLayer:addChild(decomp_layer)
  decomp_layer.container, decomp_layer.ui = ed.editorui(ed.uieditor.petDecompWin)
  decomp_layer:addChild(decomp_layer.container)
  self.layers[3] = decomp_layer
  self:createDecompLabel()
  self:createDecompDraglist()
end

function PetMainScene:createDecompLabel()
  local layer = self.decomp_layer
  local ui = layer.ui
  local label1 = ed.createLabelTTF(T("\231\180\171\232\137\178"), 16)
  ed.setLabelColor(label1, ed.toccc3(15570943))
  ui.panel_pet:addChild(label1)
  ed.right2(label1, ui.label_note, 0)
  local label2 = ed.createLabelTTF(T("\228\191\161\228\189\191\233\156\128\232\166\129\232\135\179\229\176\145\230\139\165\230\156\137"), 16)
  ed.setLabelColor(label2, ed.toccc3(16771782))
  ui.panel_pet:addChild(label2)
  ed.right2(label2, label1, 0)
  ui.label2 = label2
  local petNum = cntPurplePets() - self.purplePetCnt
  local label3 = ed.createLabelTTF(tostring(petNum), 16)
  if petNum >= purplePetLimit then
    ed.setLabelColor(label3, ed.toccc3(7405396))
  else
    ed.setLabelColor(label3, ed.toccc3(12651013))
  end
  ui.panel_pet:addChild(label3)
  ed.right2(label3, label2, 0)
  ui.label3 = label3
  local label4 = ed.createLabelTTF(string.format(T("/%d\228\184\170\239\188\140\230\137\141\232\131\189\232\191\155\232\161\140\230\148\190\231\148\159\227\128\130"), purplePetLimit), 16)
  ed.setLabelColor(label4, ed.toccc3(16771782))
  ui.panel_pet:addChild(label4)
  ed.right2(label4, label3, 0)
  ui.label4 = label4
  local label5 = ed.createLabelTTF(T("\232\147\157\232\137\178"), 16)
  ed.setLabelColor(label5, ed.toccc3(6797817))
  ui.panel_pet:addChild(label5)
  ed.left2(label5, ui.label_select, 0)
  ed.left2(ui.check_box, label5, 10)
end

function PetMainScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    ed.ui.packageDetailWin.create(v.data):popWindow()
  end
  
  return handler
end

function PetMainScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.decompUIItem or {}) do
      if ed.containsPoint(v.icon, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function PetMainScene:createDecompDraglist()
  local layer = self.decomp_layer
  local ui = layer.ui
  local delegate = {
    numberOfCells = function()
      return #self.heroPetShowList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(90, 90)
    end,
    createCell = function(index)
      local petInfo = self.heroPetShowList[index]
      local node, ui = self:createHeroPetIcon(petInfo, index)
      return node, {
        petInfo = petInfo,
        ui = ui,
        index = index
      }
    end,
    doClickIn = self:doClickInDecompTbView(),
    doPressIn = function(cell, x, y)
      return cell
    end,
    cancelPressIn = function(cell)
    end
  }
  local size = self.decomp_layer.ui.panel_showPet:getContentSize()
  local gap_width = (size.width - 630) / 6
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.decomp_layer.ui.panel_showPet,
    touchpriority = -300,
    zorder = 1,
    dragMode = 1,
    colNum = 7,
    noshade = true,
    padding = {width = gap_width, height = 10}
  }
  self.heroPetShowList = {}
  self.decompTbView = Tableview.create(param)
  self.decompTbView.dragList:setVisible(false)
  self.decompGetDraglist = ed.UITool.createDraglist(ui.panel_getList, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList()
  })
end

function PetMainScene:doClickInDecompTbView()
  local function canSelectPurplePet()
    return cntPurplePets() - self.purplePetCnt >= purplePetLimit
  end
  
  local function handler(cell, x, y)
    local param = cell.data
    local ui = param.ui
    local index = param.index
    local pet = param.petInfo
    if ui.canClick then
      local color = pet:getColor()
      if self.selectDecompIndex[index] then
        if color == 3 then
          self.purplePetCnt = self.purplePetCnt - 1
        end
        self:selectDecompPetHandle(ui, pet, false)
        self.selectDecompIndex[index] = nil
      elseif self.selectDecompIndex[index] == nil then
        if pet:getColor() == 3 and not canSelectPurplePet() then
          ed.showToast(T("\230\151\160\230\179\149\233\128\137\230\139\169\230\155\180\229\164\154\231\154\132\231\180\171\232\137\178\228\191\161\228\189\191"))
          return
        end
        if color == 3 then
          self.purplePetCnt = self.purplePetCnt + 1
        end
        self:selectDecompPetHandle(ui, pet, true)
        self.selectDecompIndex[index] = true
      end
    end
  end
  
  return handler
end

function PetMainScene:selectDecompPetHandle(ui, pet, select)
  if select then
    ui.item:addShade()
  else
    ui.item:removeShade()
  end
  ui.check:setVisible(select)
  self:selectDecompPet(pet, select)
end

function PetMainScene:selectDecompPet(pet, add)
  if not pet then
    return
  end
  
  local function addItem(id, amount)
    if self.decompGetList[id] then
      self.decompGetList[id] = self.decompGetList[id] + amount
    else
      self.decompGetList[id] = amount
    end
  end
  
  local function minusItem(id, amount)
    if not self.decompGetList[id] then
      return
    end
    self.decompGetList[id] = self.decompGetList[id] - amount
    if self.decompGetList[id] <= 0 then
      self.decompGetList[id] = nil
    end
  end
  
  local skill_list = pet:getAllSkillUpCost()
  local level_list = pet:getAllLevelUpCost()
  local cost_list = {}
  
  local function addList(list)
    for _, v in ipairs(list) do
      local key
      if v.type == "item" then
        key = v.id
      else
        key = v.type
      end
      if cost_list[key] then
        cost_list[key] = cost_list[key] + v.amount
      else
        cost_list[key] = v.amount
      end
    end
  end
  
  addList(skill_list)
  addList(level_list)
  local tb = ed.getDataTable("Pet")[pet:getTypeId()]
  local retRatio = tb["Recycle Return Ratio"]
  for _, v in pairs(cost_list) do
    cost_list[_] = math.ceil(v * retRatio)
  end
  cost_list[tb["Recycle Type"]] = tb["Recycle Amount"]
  for id, amount in pairs(cost_list) do
    if add then
      addItem(id, amount)
    else
      minusItem(id, amount)
    end
  end
  self:refreshGetDraglist()
  self:refreshDecompLabel()
end

function PetMainScene:createHeroPetIcon(pet, index)
  local ui = {}
  local container = CCLayer:create()
  container:setContentSize(CCSizeMake(80, 80))
  local item = ed.readpet.createIconById(pet:getId(), {
    length = 80,
    showMaster = true,
    showTag = true
  })
  ui.item = item
  local icon = item.icon
  icon:setScale(80 / icon:getContentSize().width)
  icon:setPosition(ccp(47, 40))
  container:addChild(icon)
  ui.icon = icon
  local carried_id = pet:getCarriedHeroId()
  if carried_id and 0 < carried_id then
    item:addShade()
    ui.canClick = false
  else
    ui.canClick = true
  end
  local check = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
  check:setPosition(ccp(47, 40))
  container:addChild(check)
  ui.check = check
  check:setVisible(false)
  if self.selectDecompIndex[index] then
    item:addShade()
    check:setVisible(true)
  end
  return container, ui
end

function PetMainScene:refreshDecompLayer()
  self:refreshDecompLabel()
  local layer = self.decomp_layer
  local ui = layer.ui
  ui.check:setVisible(false)
  self:refreshHeroPetList()
  self.heroPetShowList = {}
  local list_carried = {}
  local list_not_carried = {}
  local info = self.heroPetInfoList.all
  for _, pet in pairs(info) do
    if ed.getDataTable("Pet")[pet:getTypeId()]["Recycle Type"] then
      local carried_id = pet:getCarriedHeroId()
      if carried_id and 0 < carried_id then
        table.insert(list_carried, pet)
      else
        table.insert(list_not_carried, pet)
      end
    end
  end
  
  local function cmp(pet1, pet2)
    if pet1:getColor() == pet2:getColor() then
      if pet1:getTypeId() == pet2:getTypeId() then
        return pet1:getLevel() > pet2:getLevel()
      else
        return pet1:getTypeId() < pet2:getTypeId()
      end
    else
      return pet1:getColor() < pet2:getColor()
    end
  end
  
  table.sort(list_carried, cmp)
  table.sort(list_not_carried, cmp)
  for i = 1, #list_not_carried do
    self.heroPetShowList[i] = list_not_carried[i]
  end
  for i = #list_not_carried + 1, #info do
    self.heroPetShowList[i] = list_carried[i - #list_not_carried]
  end
  self.decompTbView:reloadData()
  self:refreshGetDraglist()
end

function PetMainScene:refreshDecompLabel()
  local layer = self.decomp_layer
  local ui = layer.ui
  local petNum = cntPurplePets() - self.purplePetCnt
  if petNum >= purplePetLimit then
    ed.setLabelColor(ui.label3, ed.toccc3(7405396))
  else
    ed.setLabelColor(ui.label3, ed.toccc3(12651013))
  end
  ed.setString(ui.label3, tostring(petNum))
  ed.right2(ui.label3, ui.label2, 0)
  ed.right2(ui.label4, ui.label3, 0)
end

function PetMainScene:refreshGetDraglist()
  local list = {}
  for i, k in pairs(self.decompGetList) do
    if type(i) ~= "number" then
      table.insert(list, {type = i, amount = k})
    else
      table.insert(list, {
        type = "item",
        id = i,
        amount = k
      })
    end
  end
  local ui = self.decomp_layer.ui
  ui.label_get:setVisible(0 < #list)
  ui.btn_decomp:setVisible(0 < #list)
  
  local function cmp(item1, item2)
    local typeOrder = {
      bluepetpoint = 1,
      purplepetpoint = 2,
      gold = 3,
      item = 4
    }
    if item1.type ~= item2.type then
      local order1 = typeOrder[string.lower(item1.type)] or 5
      local order2 = typeOrder[string.lower(item2.type)] or 5
      return order1 < order2
    elseif typeOrder[string.lower(item1.type)] == 4 then
      return item1.id < item2.id
    else
      return item1.amount < item2.amount
    end
  end
  
  table.sort(list, cmp)
  self.decompGetDraglist:clearList()
  self.decompUIItem = {}
  local width
  for i, k in ipairs(list) do
    local item = ed.createItemIcon(k)
    item:setScale(0.75)
    self.decompGetDraglist:addItem(item)
    local layer = self.decomp_layer
    local ui = layer.ui
    local height = ui.panel_getList:getContentSize().height
    width = item:getContentSize().width * 0.75
    local posy = height * 0.5
    local posx = width * (i - 0.5)
    item:setPosition(ccp(posx, posy))
    table.insert(self.decompUIItem, {icon = item, data = k})
  end
  if width then
    self.decompGetDraglist:initListWidth(width * #list + 10)
  end
end

function PetMainScene:createLuckyLayer()
  local lucky_layer = CCLayer:create()
  ed.setZOrder(lucky_layer, 20)
  self.lucky_layer = lucky_layer
  self.mainLayer:addChild(lucky_layer)
  lucky_layer.container, lucky_layer.ui = ed.editorui(ed.uieditor.PetLuckyLayer)
  self.lucky_layer:addChild(lucky_layer.container)
  local ui = lucky_layer.ui
  ed.setLabelStroke(ui.label_luck_val, ed.toccc3(6045213), 1)
  ed.setLabelStroke(ui.label_cur_luck_val, ed.toccc3(6045213), 1)
  ed.setLabelStroke(ui.label_luck_name, ed.toccc3(12678428), 1)
  self:refreshLuckyLayer()
end

function PetMainScene:refreshLuckyLayer()
  local ui = self.lucky_layer.ui
  local luckyVal = 60
  ed.setLabelString(ui.label_cur_luck_val, luckyVal)
  local showActivated = 600 <= luckyVal
  local labelColor = showActivated and 7536470 or 16776423
  ed.setLabelColor(ui.label_cur_luck_val, ed.toccc3(labelColor))
  ed.left2(ui.label_cur_luck_val, ui.label_luck_val, 0)
  ui.image_normal_bg:setVisible(not showActivated)
  ui.image_activated_bg:setVisible(showActivated)
end

function PetMainScene:registerEvents()
  self:listenEvent("refreshPetEggRoom", function(index)
    self.beginHatchEggIndex = index
    self:refreshEggsInfo()
    self:refreshHatchLayer()
  end)
  self:listenEvent("onGetNewPet", function(param)
    local index = param.index
    local color = param.color
    local eggNest = self.eggNests[index]
    local fca = eggNest.fca
    local fcaDelayConfig = {
      2,
      2.7,
      2.7
    }
    local action1 = CCCallFunc:create(function()
      fca:setAction("open" .. color)
    end)
    local action2 = CCDelayTime:create(fcaDelayConfig[color])
    local action3 = CCCallFunc:create(function()
      ed.ui.PetGainWin.create({
        pet_id = param.id,
        isBest = param.isBest
      })
      ed.PetModel:setHatchEggDataNull(index)
      FireEvent("refreshPetEggRoom")
      self.mainLayer:setTouchEnabled(true)
    end)
    local actionSequence = CCSequence:create(ccArrayMake(action1, action2, action3))
    eggNest.ui.egg:runAction(actionSequence)
    self.resourceBox:updateResourceValue("gold_pet")
    self.resourceBox:updateResourceValue("purple_pet")
    self.resourceBox:updateResourceValue("blue_pet")
    if not isDecompLock() and self.decompBtn then
      self:unlockDecompBtn()
    end
  end)
  self:listenEvent("successDecomposePets", function(reward)
    ed.UITool.showRewardsFromServer(reward)
    self.decompGetList = {}
    self.selectDecompIndex = {}
    self.purplePetCnt = 0
    self:refreshDecompLayer()
    self.resourceBox:updateResourceValue("gold_pet")
    self.resourceBox:updateResourceValue("purple_pet")
    self.resourceBox:updateResourceValue("blue_pet")
  end)
  for i, btn in pairs(self.layerBtns) do
    local config = self.select_btn_config[i]
    self:btRegisterButtonClick({
      button = btn,
      key = config.uiName,
      clickHandler = config.clickHandler
    })
  end
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.petRuleTips.create():popWindow()
  end)
  for i, config in ipairs(self.hero_pet_layer.filter_config) do
    self:btRegisterButtonClick({
      button = self.hero_pet_layer.ui[config.uiName],
      key = config.btnName,
      clickHandler = config.handler
    })
  end
  self:btRegisterButtonClick({
    button = self.decomp_layer.ui.check_box,
    key = "select_all_blue",
    clickHandler = function()
      local layer = self.decomp_layer
      local ui = layer.ui
      local petList = self.heroPetShowList
      local status = not ui.check:isVisible()
      ui.check:setVisible(status)
      for i, pet in ipairs(petList) do
        if pet:getColor() == 2 and pet:getCarriedHeroId() <= 0 then
          if self.selectDecompIndex[i] and not status then
            self:selectDecompPet(pet, status)
            self.selectDecompIndex[i] = nil
          elseif self.selectDecompIndex[i] == nil and status then
            self:selectDecompPet(pet, status)
            self.selectDecompIndex[i] = true
          end
        end
      end
      self.decompTbView:reloadData()
      self:refreshGetDraglist()
    end
  })
  ed.setLabelShadow(self.decomp_layer.ui.label_decomp, ccc3(0, 0, 0), ccp(1, 1))
  self:btRegisterButtonClick({
    button = self.decomp_layer.ui.btn_decomp,
    key = "btn_decomp",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_back)
      local petids = {}
      local pets = self.heroPetShowList
      for _, id in pairs(self.selectDecompIndex) do
        if id then
          table.insert(petids, pets[_]:getId())
        end
      end
      if 0 < #petids then
        ed.PetNetwork:sendDecomposePets(petids)
      end
    end,
    normalScale = 1,
    pressScale = 0.9,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  })
  self:btRegisterButtonClick({
    button = self.lucky_layer.ui.lucky_bg,
    key = "lucky_rule_tip",
    clickHandler = function()
      ed.ui.PetLuckRuleTip.create()
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  })
end
