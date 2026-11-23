module("ed.ui", package.seeall)
local base = ed.ui.popwindow
local class = newclass(base.mt)
AutoChessEquipPetWin = class
local AutoChessEquipPetScope = {}
local ColorParam = ed.AutoChessDefine.ColorParam
local ColorStrokeParam = ed.AutoChessDefine.ColorStrokeParam
local RankMap = {
  price_1 = 1,
  price_2 = 2,
  price_3 = 4,
  price_4 = 7,
  price_5 = 12
}

function class.create(heroSid)
  local self = base.create("AutoChessEquipPetWin", {noShade = true, notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData(heroSid)
  self:initUI()
  self:registerEvents()
  return self
end

function class:destroy(param)
  base.destroy(self, param)
  CloseScope(AutoChessEquipPetScope)
end

function class:initData(heroSid)
  self.heroSid = heroSid
  self.chessHero = ed.AutoChessModel:getChessHeroBySid(heroSid)
  local chessId = self.chessHero:getChessId()
  self.petDataList = ed.AutoChessModel:getDropPetData()
  self.selectPet = nil
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessEquipPetWin, {
    container = self.container,
    ui = self.ui
  })
  self:initPetDetail()
end

function class:initPetDetail(...)
  self.ui.label_pet_equip_desc:setDimensions(CCSizeMake(310, 100))
  self:createPetList()
  self:resetSelectPet()
end

function class:registerEvents(...)
  self:registerBtnEvents()
  self:registerGameEvents()
end

function class:registerBtnEvents()
  self:btRegisterButtonClick({
    button = self.ui.btn_pet_equip,
    press = self.ui.btn_pet_equip_press,
    clickHandler = function(...)
      self:handlerEquipClick()
    end,
    pressHandler = function(...)
      self.ui.btn_pet_equip_press:setVisible(true)
    end,
    cancelHandler = function(...)
      self.ui.btn_pet_equip_press:setVisible(false)
    end
  })
end

function class:registerGameEvents(...)
  ListenEvent("EventEquipChessPet", function()
    self:onEventEquipChessPet()
  end, AutoChessEquipPetScope)
  ListenEvent("EventReplaceChessPet", function()
    self:onEventReplaceChessPet()
  end, AutoChessEquipPetScope)
  ListenEvent("EventExchangeChessPet", function()
    self:onEventExchangeChessPet()
  end, AutoChessEquipPetScope)
end

function class:onEventEquipChessPet(...)
  if self.petTableView then
    local dragList = self.petTableView:getDragList()
    if not tolua.isnull(dragList:getList()) then
      self.petTableView:staticSync()
    else
      self:createPetTableView()
    end
  else
    self:createPetTableView()
  end
  self:resetSelectPet()
end

function class:onEventReplaceChessPet(...)
  if self.petTableView then
    local dragList = self.petTableView:getDragList()
    if not tolua.isnull(dragList:getList()) then
      self.petTableView:staticSync()
    else
      self:createPetTableView()
    end
  else
    self:createPetTableView()
  end
  self:resetSelectPet()
end

function class:onEventExchangeChessPet(...)
  if self.petTableView then
    local dragList = self.petTableView:getDragList()
    if not tolua.isnull(dragList:getList()) then
      self.petTableView:staticSync()
    else
      self:createPetTableView()
    end
  else
    self:createPetTableView()
  end
  self:resetSelectPet()
end

function class:createPetList()
  if not self.petTableView then
    self:createPetTableView()
  end
end

function class:createPetTableView()
  self.delegate = self:setTableDelegate()
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_pet_list,
    cliprect = CCRectMake(10, 0, 312, 139),
    dragMode = 1,
    colNum = 5,
    zorder = 50,
    touchpriority = -160,
    bar = {
      bglen = 60,
      bgpos = ccp(0, 100)
    }
  }
  self.petTableView = Tableview.create(param)
end

function class:setTableDelegate()
  local delegate = {}
  
  function delegate.numberOfCells()
    return #self.petDataList
  end
  
  function delegate.cellSizeFromIndex(idx)
    return CCSizeMake(60, 60)
  end
  
  function delegate.createCell(idx)
    local node, data = self:loadPet(idx, self.selectPet)
    return node, data
  end
  
  function delegate.syncCell(cell, idx)
    local node, data = self:loadPet(idx, self.selectPet)
    return node, data
  end
  
  function delegate.doClickIn(cell)
    self:handlerClickPet(cell)
  end
  
  return delegate
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
  local node = CCNode:create()
  local petObject = ed.readpet.createChessIcon({type = petId})
  petObject.icon:setScale(0.2)
  petObject.icon:setAnchorPoint(ccp(0, 0))
  petObject.icon:setPosition(ccp(0, 5))
  node:addChild(petObject.icon)
  local selectTag = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
  selectTag:setScale(0.8)
  selectTag:setAnchorPoint(ccp(0, 0))
  selectTag:setPosition(ccp(-3, 3))
  node:addChild(selectTag, 10)
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
    heroIcon.icon:setScale(0.2)
    heroIcon.icon:setPosition(ccp(10, 45))
    node:addChild(heroIcon.icon)
  end
  local isSelsect = false
  if self.selectPet and chessPet == self.selectPet then
    isSelsect = true
  end
  local data = {
    petSid = petSid,
    petId = petId,
    icon = petObject.icon,
    selected = isSelsect,
    tag = selectTag
  }
  data.tag:setVisible(isSelsect)
  return node, data
end

function class:handlerClickPet(cell)
  local index = cell.idx
  local data = cell.data
  local chessPet = self.petDataList[index]
  if not self.selectPet or self.selectPet ~= chessPet then
    self.selectPet = chessPet
  elseif self.selectPet == chessPet then
    self.selectPet = nil
  end
  FireEvent("EventSelectEquipPet", self.selectPet)
  if self.petTableView then
    self.petTableView:staticSync()
  end
  self:updateSelectPet()
end

function class:resetSelectPet(...)
  self.selectPet = nil
  if self.petTableView then
    self.petTableView:staticSync()
  end
  FireEvent("EventSelectEquipPet", self.selectPet)
  self:updateSelectPet()
end

function class:updateSelectPet(...)
  self.ui.label_pet_tip:setVisible(self.selectPet == nil)
  self.ui.node_pet_info:setVisible(self.selectPet ~= nil)
  self.ui.btn_pet_equip:setVisible(self.selectPet ~= nil)
  if self.selectPet ~= nil then
    local petId = self.selectPet:getChessPetId()
    local petColor = ed.getChessUnitSellPrice(petId)
    local petName = ed.getChestDisplyName(petId)
    local nameColor = ColorParam["color_" .. petColor] or ColorParam.color_1
    ed.setString(self.ui.label_pet_name, petName)
    ed.setLabelColor(self.ui.label_pet_name, nameColor)
    local uinfo = ed.lookupDataTable("ChessUnit", nil, petId)
    local heroId = uinfo["Hero ID"]
    local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, heroId)
    local skillId = skillGroupInfo[1].none["Skill Group ID"]
    local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0)
    ed.setString(self.ui.label_pet_equip_desc, skillInfo.Description)
  end
end

function class:isContainsPoint(x, y)
  return ed.containsPoint(self.ui.pet_detail_bg, x, y) or ed.containsPoint(self.ui.btn_pet_equip, x, y)
end

function class:handlerEquipClick()
  if not self.selectPet then
    return
  end
  local chessPet = self.selectPet
  if chessPet:isEquiped() then
    local masterSid = chessPet:getChessPetMaster()
    if masterSid == self.heroSid then
      ed.showToast(T("\229\183\178\232\163\133\229\164\135\232\175\165\232\163\133\229\164\135"))
    elseif ed.chess_debug_mode then
      ed.AutoChessManager:handlerExchangePet({
        _to_hero = {
          _pet = {
            _insid = chessPet:getChessPetInsid(),
            _pid = chessPet:getChessPetId()
          },
          _insid = self.heroSid
        },
        _from_hero = {_insid = masterSid}
      })
    else
      ed.AutoChessNetwork:sendChessExchangePet(masterSid, self.heroSid)
    end
  else
    local equipPet = self.chessHero:getEquipChessPet()
    if equipPet == nil then
      print("<<<<<<<<<<< handlerClickPet equip >>>>> ")
      if ed.chess_debug_mode then
        ed.AutoChessManager:handlerEquipPet({
          _hero = {
            _pet = {
              _insid = chessPet:getChessPetInsid(),
              _pid = chessPet:getChessPetId()
            },
            _insid = self.heroSid
          }
        })
      else
        ed.AutoChessNetwork:sendChessEquipPet(self.heroSid, chessPet:getChessPetInsid())
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
            _insid = self.heroSid
          },
          _pet = {
            _insid = equipPet:getChessPetInsid(),
            _pid = equipPet:getChessPetId()
          }
        })
      else
        ed.AutoChessNetwork:sendChessReplacePet(self.heroSid, chessPet:getChessPetInsid())
      end
    end
  end
end
