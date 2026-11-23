module("ed.ui", package.seeall)
local base = ed.ui.popwindow
local class = newclass(base.mt)
AutoChessHeroDetailWin = class
local AutoChessHeroDetailScope = {}
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
  local self = base.create("AutoChessHeroDetailWin", {noShade = true, notBlurBg = true})
  setmetatable(self, class.mt)
  self:initData(heroSid)
  self:initUI()
  self:registerEvents()
  return self
end

function class:destroy(param)
  if self.equipPetWin then
    self.equipPetWin:destroy(param)
    self.equipPetWin = nil
  end
  self:removeTagDetail()
  FireEvent("EventCloseChessDetail")
  base.destroy(self, param)
  CloseScope(AutoChessHeroDetailScope)
end

function class:initData(heroSid)
  self.heroSid = heroSid
  self.chessHero = ed.AutoChessModel:getChessHeroBySid(heroSid)
  local chessId = self.chessHero:getChessId()
  self.sellPrice = ed.getChessUnitSellPrice(chessId)
  self.heroTags = {}
  self.petDataList = ed.AutoChessModel:getDropPetData()
  self.selectPet = nil
  self.equipPetWin = nil
end

function class:initUI()
  ed.editorui(ed.uieditor.AutoChessHeroDetailWin, {
    container = self.container,
    ui = self.ui
  })
  ed.layout.layoutWithMagin(self.ui.bg, {right = 0})
  self:initBaseInfo()
end

function class:initBaseInfo()
  self:initHeadInfo()
  self:initAttrInfo()
  self:initSkillInfo()
  self:initPriceInfo()
  self:initPetIcon()
end

function class:initHeadInfo()
  local chessId = self.chessHero:getChessId()
  local price = self.chessHero:getHeroInitPrice()
  local info = {
    id = chessId,
    stars = self.chessHero:getHeroStar(),
    level = false,
    rank = RankMap["price_" .. price]
  }
  local heroIcon = ed.readhero.createChessIcon(info)
  heroIcon.icon:setScale(0.6)
  self.ui.node_head:addChild(heroIcon.icon)
  self.ui.gold:setString(price)
  ed.setLabelStroke(self.ui.gold, ccc3(20, 18, 18), 1)
  local heroName = ed.getChestDisplyName(chessId)
  self.ui.name:setColor(ColorParam["color_" .. price])
  self.ui.name:setString(heroName)
  self.ui.name:limitWidthByScale(145)
  self:addChessTagNode()
end

function class:addChessTagNode()
  local function getPos(i)
    local ox, oy = 24, 12.5
    
    local dx, dy = 100, 25
    local row = math.floor((i - 1) / 2)
    local col = (i + 1) % 2
    return ccp(ox + col * dx, oy - dy * row)
  end
  
  local hid = self.chessHero:getChessId()
  local raceTags = ed.getChessUnitRaceTags(hid)
  local abilityTags = ed.getChessUnitAbilityTags(hid)
  local sumTags = #raceTags + #abilityTags
  local offsetY = -12.5
  for i = 3, sumTags, 2 do
    local tagBg = ed.createSprite("UI/alpha/1080P/chess/battle/tag_tips_bg.png")
    tagBg:setPosition(ccp(112, offsetY))
    self.ui.node_tag:addChild(tagBg)
    offsetY = offsetY - 25
    ed.UITool.setPositionBy(self.ui.panel_attr, ccp(0, -25))
  end
  local index = 1
  
  local function createTag(tag)
    local tagConfig = ed.AutoChessModel:getTagNumByType(tag)
    local tagData = ed.getDataTable("ChessTags")[tag]
    local tagSprite = ed.createSprite(tagData.Sign)
    tagSprite:setScale(0.6)
    local name = ed.createLabelTTF(tagData["Display Name"], 15)
    name:setAnchorPoint(ccp(0, 0.5))
    ed.setLabelColor(name, ed.toccc3(16776423))
    ed.setLabelStroke(name, ccc3(20, 18, 18), 1)
    local pos = getPos(index)
    tagSprite:setPosition(pos)
    self.ui.node_tag:addChild(tagSprite, 2)
    name:setPosition(ccpAdd(pos, ccp(14, 0)))
    self.ui.node_tag:addChild(name, 2)
    index = index + 1
    table.insert(self.heroTags, {
      tagIcon = tagSprite,
      tagData = {
        tag = tag,
        num = 0,
        level = 0,
        target = #tagConfig
      }
    })
  end
  
  for _, tag in ipairs(raceTags) do
    createTag(tag)
  end
  for _, tag in pairs(abilityTags) do
    createTag(tag)
  end
end

function class:initAttrInfo()
  local hid = self.chessHero:getChessId()
  local uinfo = ed.lookupDataTable("ChessUnit", nil, hid)
  local HP = uinfo.HP
  local AD = uinfo.AD
  local ARM = uinfo.ARM
  local MR = uinfo.MR
  ed.setString(self.ui.label_attr_hp, HP)
  ed.setLabelStroke(self.ui.label_attr_hp, ccc3(20, 18, 18), 1)
  ed.setString(self.ui.label_attr_ad, AD)
  ed.setLabelStroke(self.ui.label_attr_ad, ccc3(20, 18, 18), 1)
  ed.setString(self.ui.label_attr_arm, ARM)
  ed.setLabelStroke(self.ui.label_attr_arm, ccc3(20, 18, 18), 1)
  ed.setString(self.ui.label_attr_crit, MR)
  ed.setLabelStroke(self.ui.label_attr_crit, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_skill_desc, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_pet_desc, ccc3(20, 18, 18), 1)
  ed.setLabelStroke(self.ui.label_equip_tip, ccc3(20, 18, 18), 1)
end

function class:initSkillInfo()
  local hid = self.chessHero:getChessId()
  local uinfo = ed.lookupDataTable("ChessUnit", nil, hid)
  local heroId = uinfo["Hero ID"]
  local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, heroId)
  local skillId = skillGroupInfo[1].none["Skill Group ID"]
  local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0)
  local skillIcon = ed.readhero.createChessSkillIcon(heroId, 1)
  skillIcon:setPosition(ccp(45, 45))
  self.ui.icon_skill:addChild(skillIcon)
  ed.setString(self.ui.label_skill_desc, skillInfo.Description)
  self.ui.label_skill_desc:limitSizeByScale(145, 100)
end

function class:initPriceInfo()
  ed.setLabelStroke(self.ui.label_price, ed.toccc3(1312776), 1.5)
  self.sellPrice = self.sellPrice or 0
  self.ui.label_price:setString("+" .. self.sellPrice)
end

function class:initPetIcon()
  self.ui.img_pet_bg:removeAllChildrenWithCleanup(true)
  local chessPet = self.chessHero:getEquipChessPet()
  if chessPet then
    local petId = chessPet:getChessPetId()
    local petIcon = ed.readpet.createChessIcon({type = petId})
    self.ui.img_pet_bg:addChild(petIcon.icon)
    petIcon.icon:setPosition(ccp(45, 46))
    self.ui.label_equip_tip:setVisible(false)
    self.ui.label_pet_desc:setVisible(true)
    local uinfo = ed.lookupDataTable("ChessUnit", nil, petId)
    local heroId = uinfo["Hero ID"]
    local skillGroupInfo = ed.lookupDataTable("ChessSkillGroup", nil, heroId)
    local skillId = skillGroupInfo[1].none["Skill Group ID"]
    local skillInfo = ed.lookupDataTable("ChessSkill", nil, skillId, 0) or {}
    ed.setString(self.ui.label_pet_desc, skillInfo.Description)
    self.ui.label_pet_desc:limitSizeByScale(145, 100)
  else
    self.ui.label_equip_tip:setVisible(true)
    self.ui.label_pet_desc:setVisible(false)
  end
end

function class:initPetDetail()
  self.ui.pet_detail_bg:setVisible(false)
  self.ui.label_pet_equip_desc:setDimensions(CCSizeMake(310, 100))
end

function class:registerEvents()
  self:registerBtnEvents()
  self:registerGameEvents()
end

function class:registerGameEvents()
  ListenEvent("EventEquipChessPet", function()
    self:onEventEquipChessPet()
  end, AutoChessHeroDetailScope)
  ListenEvent("EventReplaceChessPet", function()
    self:onEventReplaceChessPet()
  end, AutoChessHeroDetailScope)
  ListenEvent("EventExchangeChessPet", function()
    self:onEventExchangeChessPet()
  end, AutoChessHeroDetailScope)
  ListenEvent("EventCloseOtherWin", function()
    self:destroy({skipAnim = true})
  end, AutoChessHeroDetailScope)
end

function class:onEventEquipChessPet()
  self:initPetIcon()
end

function class:onEventReplaceChessPet()
  self:initPetIcon()
end

function class:onEventExchangeChessPet()
  self:initPetIcon()
end

function class:registerBtnEvents()
  self:btRegisterHandler({
    key = "autochess_herodetail_rect",
    handler = function(event, x, y)
      if event == "began" then
        for i, v in ipairs(self.heroTags) do
          if ed.containsPoint(v.tagIcon, x, y) then
            v.isPress = true
            return true
          end
        end
      elseif event == "ended" then
        if not ed.containsPoint(self.ui.bg, x, y) then
          if self.equipPetWin and self.equipPetWin:isContainsPoint(x, y) then
            return
          end
          self:destroy({skipAnim = true})
          return
        end
        for i, v in ipairs(self.heroTags) do
          if ed.containsPoint(v.tagIcon, x, y) and v.isPress then
            self:handlerClickHeroTag(i)
            v.isPress = false
            break
          end
        end
      end
    end,
    force = true,
    priority = 0
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_sell,
    press = self.ui.btn_sell_press,
    clickHandler = function()
      self:handlerSellClick()
    end,
    pressHandler = function()
      self.ui.btn_sell_press:setVisible(true)
    end,
    cancelHandler = function()
      self.ui.btn_sell_press:setVisible(false)
    end
  })
end

function class:handlerSellClick()
  if ed.AutoChessTeachManager:isGuideFlag() then
    return
  end
  if ed.chess_debug_mode then
    ed.AutoChessManager:dispatchDebugReply("sellhero", {
      _hero_insid = self.chessHero:getHeroInsid(),
      _gold = ed.AutoChessModel:getTotalGold() + self.sellPrice
    })
  else
    local insid = self.chessHero:getHeroInsid()
    ed.AutoChessNetwork:sendChessSellHero(insid)
  end
  self:destroy({skipAnim = true})
end

function class:handlerClickHeroTag(i)
  local heroTag = self.heroTags[i]
  if heroTag then
    local isGuideFlag = ed.AutoChessTeachManager:isGuideFlag()
    if isGuideFlag then
      return
    end
    self:removeTagDetail()
    self.tagDetail = ed.ui.AutoChessTagPanel.createDetailTagPanel(heroTag.tagIcon, heroTag.tagData, ccp(-169, 25))
  end
end

function class:removeTagDetail()
  if self.tagDetail and not tolua.isnull(self.tagDetail.container) then
    self.tagDetail:closeSelf()
    self.tagDetail = nil
  end
end

function class:handlerPetClick()
  if self.equipPetWin then
    self.equipPetWin:destroy({skipAnim = true})
    self.equipPetWin = nil
    self.selectPet = nil
  else
    self.equipPetWin = ed.ui.AutoChessEquipPetWin.create(self.heroSid)
    self.equipPetWin:popWindow()
  end
end
