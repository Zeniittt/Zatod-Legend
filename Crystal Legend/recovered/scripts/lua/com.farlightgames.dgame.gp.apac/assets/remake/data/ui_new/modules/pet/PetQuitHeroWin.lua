local base = ed.ui.popwindow
local petQuitHeroWin = {}
petQuitHeroWin.__index = petQuitHeroWin
setmetatable(petQuitHeroWin, base.mt)
ed.ui.petQuitHeroWin = petQuitHeroWin
local res = ed.heroDetailManager.resConfig

function petQuitHeroWin.create(param)
  local self = base.create("petQuitHeroWin")
  setmetatable(self, petQuitHeroWin)
  self:initData(param)
  self:initUI()
  self:registerEvents()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function petQuitHeroWin:initData(param)
  self.pet = param.pet
  self.controller = param.controller
  self.itemId = 20331
  self.itemNum = ed.player:getEquipAmount(self.itemId)
  self.bCanUseItem = self.itemNum > 0
end

function petQuitHeroWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.package_dialogue)
  ui.right_deco:setScaleX(-1)
  ed.layout.centerInScreen(self.ui.bg, true)
  ed.setLabelShadow(ui.left_button_label, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(ui.right_button_label, ed.toccc3(0), ccp(1, 0))
  local bg_size = self.ui.bg:getContentSize()
  local centerWid, centerHei = bg_size.width * 0.5, bg_size.height * 0.5
  ui.left_button_label:setString(T("\229\143\150\230\182\136"))
  ui.right_button_label:setString(T("\231\161\174\229\174\154"))
  local color = ccc3(25, 2, 3)
  ed.setLabelStroke(self.ui.label_title, ccc3(56, 38, 34), 2)
  local beforeTimer = ed.createLabelTTF(T("\228\191\161\228\189\191\231\166\187\229\188\128\229\128\146\232\174\161\230\151\182\239\188\154"), 18)
  ed.setLabelColor(beforeTimer, ccc3(25, 2, 3))
  local timer = ed.createLabelTTF(self.pet:getCDStr(), 18)
  ed.setLabelColor(timer, ed.toccc3(12076863))
  beforeTimer:setPosition(ccp(centerWid - 35, centerHei + 70))
  self.ui.bg:addChild(beforeTimer)
  self.ui.bg:addChild(timer)
  self.timer = timer
  ed.right2(timer, beforeTimer, 2)
  local afterTimer = ed.createLabelTTF(T("\228\191\161\228\189\191\233\163\159\231\148\168\229\191\152\230\131\133\233\187\145\229\183\167\229\144\142\229\143\175\228\187\165\231\171\139\229\141\179\231\166\187\229\188\128\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\228\189\191\231\148\168\239\188\159"), 18)
  afterTimer:setPosition(ccp(centerWid + 10, centerHei + 30))
  ed.setLabelColor(afterTimer, ccc3(25, 2, 3))
  self.ui.bg:addChild(afterTimer)
  local item_icon = ed.createItemIcon({
    id = self.itemId,
    type = "item"
  })
  item_icon:setPosition(ccp(centerWid - 60, centerHei - 20))
  item_icon:setScale(0.5)
  self.ui.bg:addChild(item_icon)
  local number_bg = ed.createScale9Sprite("UI/alpha/1080P/pet/hero_pet/hero_pet_cost_bg.png")
  number_bg:setOpacity(178)
  number_bg:setContentSize(CCSizeMake(125, 20))
  self.ui.bg:addChild(number_bg)
  ed.right2(number_bg, item_icon, 2)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format("<lable color=%s strokeColor=ccc3(22,40,31)>%s</lable>/1", 1 <= self.itemNum and "ccc3(141,244,118)" or "ccc3(255,0,0)", self.itemNum),
    color = ed.toccc3(16776423),
    strokeColor = ccc3(0, 0, 0),
    strokeSize = 1,
    fontSize = 14
  })
  local atWid = autoText:getCurContentSize()
  local num_bg_size = number_bg:getContentSize()
  autoText.node:setPosition(ccp((num_bg_size.width - atWid) * 0.5, num_bg_size.height * 0.5))
  number_bg:addChild(autoText.node)
  local backBtn = ed.createSprite("UI/alpha/1080P/common/break_butt_bj.png")
  local backCross = ed.createSprite("UI/alpha/1080P/common/butt_off.png")
  backBtn:addChild(backCross)
  ed.layout.centerInParent(backCross)
  backBtn:setScale(0.8)
  ui.backBtn = backBtn
  ui.frame:addChild(backBtn)
  backBtn:setPosition(ccp(bg_size.width, bg_size.height))
end

function petQuitHeroWin:registerEvents()
  self:updateTimer()
  self:listenTimer(Timer:Always(1), function()
    self:updateTimer()
  end)
end

function petQuitHeroWin:updateTimer()
  self.timer:setString(self.pet:getCDStr())
  if self.pet:getCD() <= 0 then
    self:destroy()
  end
end

function petQuitHeroWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.left_button,
    key = "cancel_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.right_button,
    key = "ok_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickInterval = 0.5,
    clickHandler = function()
      if self.bCanUseItem then
        self.controller:sendPetSkillUp()
        ed.PetManager.bUseItemForUnequip = self.itemId
        ed.PetNetwork:unequipPet(self.pet:getCarriedHeroId(), true)
        self:destroy()
        return
      end
      ed.showToast(T("\229\191\152\230\131\133\233\187\145\229\183\167\228\184\141\232\182\179"))
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.backBtn,
    key = "back_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      self:destroy()
    end
  })
end
