local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AutoChessPetBagWin = class
local ColorParam = ed.AutoChessDefine.ColorParam
local ColorStrokeParam = ed.AutoChessDefine.ColorStrokeParam
local RankMap = {
  price_1 = 1,
  price_2 = 2,
  price_3 = 4,
  price_4 = 7,
  price_5 = 12
}

function class:initData()
  self.petDataList = ed.AutoChessModel:getDropPetData()
  self.heroItems = {}
  self.bagHeroItems = {}
  self.selectPet = nil
end

function class:handlerHeroClick(item)
  if not self.selectPet then
    return
  end
  local heroSid = item.heroSid
  local hero = ed.AutoChessModel:getChessHeroBySid(heroSid)
  local chessPet = self.selectPet
  if chessPet:isEquiped() then
    local masterSid = chessPet:getChessPetMaster()
    if masterSid == heroSid then
      ed.showToast(T("\229\183\178\232\163\133\229\164\135\232\175\165\232\163\133\229\164\135"))
    elseif ed.chess_debug_mode then
      ed.AutoChessManager:handlerExchangePet({
        _to_hero = {
          _pet = {
            _insid = chessPet:getChessPetInsid(),
            _pid = chessPet:getChessPetId()
          },
          _insid = heroSid
        },
        _from_hero = {_insid = masterSid}
      })
    else
      ed.AutoChessNetwork:sendChessExchangePet(masterSid, heroSid)
    end
  else
    local equipPet = hero:getEquipChessPet()
    if equipPet == nil then
      print("<<<<<<<<<<< handlerClickPet equip >>>>> ")
      if ed.chess_debug_mode then
        ed.AutoChessManager:handlerEquipPet({
          _hero = {
            _pet = {
              _insid = chessPet:getChessPetInsid(),
              _pid = chessPet:getChessPetId()
            },
            _insid = heroSid
          }
        })
      else
        ed.AutoChessNetwork:sendChessEquipPet(heroSid, chessPet:getChessPetInsid())
      end
    else
      print("<<<<<<<<<<< handlerClickPet replace >>>>> ")
      if ed.chess_debug_mode then
        ed.AutoChessManager:handlerReplacePet({
          _hero = {
            _pet = {
              _insid = chessPet:getChessPetInsid(),
              _pid = chessPet:getChessPetId()
            },
            _insid = heroSid
          },
          _pet = {
            _insid = equipPet:getChessPetInsid(),
            _pid = equipPet:getChessPetId()
          }
        })
      else
        ed.AutoChessNetwork:sendChessReplacePet(heroSid, chessPet:getChessPetInsid())
      end
    end
  end
end

function class:createIconByHero(heroSid, scale)
  local chessHero = ed.AutoChessModel:getChessHeroBySid(heroSid)
  local iconNode = CCSprite:create()
  local param = {
    id = chessHero:getChessId(),
    stars = chessHero:getHeroStar(),
    level = false,
    rank = RankMap["price_" .. chessHero:getHeroInitPrice()]
  }
  local heroIcon = ed.readhero.createChessIcon(param)
  heroIcon.icon:setAnchorPoint(ccp(0, 0))
  heroIcon.icon:setScale(scale or 0.7)
  iconNode:addChild(heroIcon.icon, 10)
  local imgAddTip = ed.createSprite("UI/alpha/1080P/chess/battle/chess_equip_fream_1.png")
  imgAddTip:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.8, 255), CCFadeTo:create(0.8, 96))))
  iconNode:addChild(imgAddTip, 11)
  local chessPet = chessHero:getEquipChessPet()
  local petNode = CCNode:create()
  if chessPet then
    local petId = chessPet:getChessPetId()
    local petObject = ed.readpet.createChessIcon({type = petId})
    petObject.icon:setScale(0.2)
    petObject.icon:setAnchorPoint(ccp(0, 0))
    petNode:addChild(petObject.icon)
  elseif self.selectPet then
  end
  iconNode:addChild(petNode, 12)
  local iconSize = heroIcon.icon:getContentSize()
  iconNode:setContentSize(CCSizeMake(iconSize.width * 0.7, iconSize.height * 0.7))
  ed.layout.centerInParent(imgAddTip)
  self:btRegisterButtonClick({
    button = iconNode,
    key = "iconNode" .. heroSid,
    clickHandler = function()
      self:handlerHeroClick({heroSid = heroSid})
    end,
    force = true,
    mcpMode = true
  })
  return iconNode
end

function class:createBattleHeros()
  for k, v in ipairs(self.heroItems or {}) do
    v.icon:removeFromParentAndCleanup(true)
  end
  self.heroItems = {}
  
  local function getPos(i)
    local row = math.ceil(i / 4)
    local col = (i - 1) % 4 + 1
    local ox, oy = -35, 340
    local dx, dy = 70, 68
    return ccp(ox + dx * col, oy - dy * row)
  end
  
  local index = 0
  local heroNum = 0
  local battleData = ed.AutoChessModel:getBattleHeroData()
  local iconHeight = 0
  for _, battleHero in pairs(battleData) do
    local heroIcon = self:createIconByHero(battleHero.heroSid)
    heroNum = heroNum + 1
    heroIcon:setPosition(getPos(heroNum))
    self.ui.panel_hero_list:addChild(heroIcon)
    table.insert(self.heroItems, {
      icon = heroIcon,
      heroSid = battleHero.heroSid
    })
  end
  self.ui.label_none_hero:setVisible(heroNum == 0)
end

function class:createSlotHeros()
  for k, v in ipairs(self.bagHeroItems or {}) do
    v.icon:removeFromParentAndCleanup(true)
  end
  self.bagHeroItems = {}
  
  local function getPos(i)
    local row = math.ceil(i / 4)
    local col = (i - 1) % 4 + 1
    local ox, oy = -24, 160
    local dx, dy = 68.5, 64
    return ccp(ox + dx * col, oy - dy * row)
  end
  
  local index = 0
  local heroNum = 0
  local slotHeros = ed.AutoChessModel:getChessHeroList()
  local iconHeight = 0
  for _, slotHeroSid in pairs(slotHeros) do
    local heroIcon = self:createIconByHero(slotHeroSid)
    heroNum = heroNum + 1
    heroIcon:setPosition(getPos(heroNum))
    self.ui.bg_bag_hero:addChild(heroIcon)
    table.insert(self.bagHeroItems, {icon = heroIcon, heroSid = slotHeroSid})
  end
end

function class:updateHeroList()
  self:createBattleHeros()
  self:createSlotHeros()
end

function class:initHeroList()
  self:updateHeroList()
end

function class:loadPet(index)
  if index < 1 then
    return
  end
  if index > #self.petDataList then
    return
  end
  local chessPet = self.petDataList[index]
  local petId = chessPet:getChessPetId()
  local petSid = chessPet:getChessPetInsid()
  local masterId = chessPet:getChessPetMaster()
  local container, ui = ed.editorui(ed.uieditor.AutoChessPetItem)
  local petObject = ed.readpet.createChessIcon({type = petId})
  container:setContentSize(ui.bg:getContentSize())
  petObject.icon:setPosition(ccp(45, 46))
  ui.node_icon:addChild(petObject.icon)
  local petColor = ed.getChessUnitSellPrice(petId)
  local petName = ed.getChestDisplyName(petId)
  local nameColor = ColorParam["color_" .. petColor] or ColorParam.color_1
  local strokeColor = ColorStrokeParam["color_" .. petColor] or ColorStrokeParam.color_1
  ed.setString(ui.label_pet_name, petName)
  ed.setLabelColor(ui.label_pet_name, nameColor)
  ed.setLabelStroke(ui.label_pet_name, strokeColor, 1)
  local uinfo = ed.lookupDataTable("ChessUnit", nil, petId)
  local heroId = uinfo["Hero ID"]
  local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, heroId)
  local skillId = skillGroupInfo[1].none["Skill Group ID"]
  local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0) or {}
  ed.setString(ui.label_pet_equip_desc, skillInfo.Description)
  ui.label_pet_equip_desc:setDimensions(CCSizeMake(250, 100))
  ui.img_select:setVisible(chessPet == self.selectPet)
  local chessHero = masterId and 0 < masterId and ed.AutoChessModel:getChessHeroBySid(masterId) or nil
  if chessHero then
    local price = chessHero:getHeroInitPrice()
    local hid = chessHero:getChessId()
    local param = {
      id = hid,
      stars = chessHero:getHeroStar(),
      level = false,
      rank = RankMap["price_" .. price]
    }
    local heroIcon = ed.readhero.createChessIcon(param)
    heroIcon.icon:setScale(0.7)
    ui.img_pet_add:setVisible(false)
    ui.img_pet_icon_bg:addChild(heroIcon.icon)
    ed.layout.centerInParent(heroIcon.icon)
  end
  local data = {
    petSid = petSid,
    petId = petId,
    ui = ui
  }
  return container, data
end

function class:handlerClickPet(cell)
  local index = cell.idx
  local data = cell.data
  local chessPet = self.petDataList[index]
  if self.selectPet ~= chessPet then
    self.selectPet = chessPet
    self:refreshUI()
  end
end

function class:setTableDelegate()
  local delegate = {}
  
  function delegate.numberOfCells()
    return #self.petDataList
  end
  
  function delegate.cellSizeFromIndex(idx)
    return CCSizeMake(400, 78)
  end
  
  function delegate.createCell(idx)
    local node, data = self:loadPet(idx)
    return node, data
  end
  
  function delegate.syncCell(cell, idx)
    local node, data = self:loadPet(idx)
    return node, data
  end
  
  function delegate.doClickIn(cell, x, y)
    if ed.containsPoint(cell.data.ui.img_pet_icon_bg, x, y) then
      self:handlerClickPet(cell, x, y)
    elseif self.selectPet then
      self.selectPet = nil
      self:refreshUI()
    end
  end
  
  return delegate
end

function class:createPetTableView()
  local panelSize = self.ui.panel_pet_list:getContentSize()
  self.delegate = self:setTableDelegate()
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_pet_list,
    cliprect = CCRectMake(8, 0, panelSize.width, panelSize.height),
    dragMode = 1,
    colNum = 1,
    zorder = 50,
    touchpriority = -302,
    bar = {
      bglen = panelSize.height - 10,
      bgpos = ccp(0, 120)
    }
  }
  self.petTableView = Tableview.create(param)
  self.ui.label_empty_tip:setVisible(#self.petDataList == 0)
  ed.setLabelStroke(self.ui.label_empty_tip, ccc3(20, 18, 18), 1)
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessPetBagWin, {
    container = self.container,
    ui = self.ui
  })
  self:initHeroList()
  self:createPetTableView()
end

function class:registerTouchEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end

function class:refreshUI()
  local srcListX, srcListY = self.petTableView:getListPos()
  self.petTableView:reloadData()
  self.petTableView:setListPos(ccp(srcListX, srcListY))
  self:updateHeroList()
end

function class:registerGameEvents()
  self:listenEvent("EventEquipChessPet", function()
    self:refreshUI()
  end)
  self:listenEvent("EventReplaceChessPet", function()
    self:refreshUI()
  end)
  self:listenEvent("EventExchangeChessPet", function()
    self:refreshUI()
  end)
  self:listenEvent("EventCloseOtherWin", function()
    self:destroy({skipAnim = true})
  end)
end

function class:registerEvents()
  self:registerTouchEvents()
  self:registerGameEvents()
end

function class:destroy(param)
  FireEvent("AutoChessPetBagWinClose")
  base.destroy(self, param)
end

function class.create()
  local self = base.create("AutoChessPetBagWin", {
    noShade = true,
    priority = -301,
    notBlurBg = true
  })
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  return self
end
