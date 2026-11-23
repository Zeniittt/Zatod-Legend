local petLayer = newclass(ed.ui.heroDetailScene.newpet.mt)

function petLayer.create(param)
  local self = {}
  setmetatable(self, {__index = petLayer})
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  return self
end

function petLayer:initData(param)
  self.controller = param.controller
  self.pos = param.pos
  self.skillIndex = 1
  self.isSimple = true
  self.upSkillLevelNum = {0, 0}
  self.upLevelNum = 0
  self.openFromPet = true
  self:initPetInfo(param.pet)
end

local base = ed.ui.popwindow
local PetInfoWin = newclass(base.mt)
ed.ui.PetInfoWin = PetInfoWin

function PetInfoWin.create(param)
  local self = base.create("PetInfoWin")
  setmetatable(self, PetInfoWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function PetInfoWin:initData(param)
  self.exitHandler = param.exitHandler
  self.petList = param.petList
  self.index = param.index
  self.pet = self.petList[self.index]
end

function PetInfoWin:adaptUI()
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.bg:setContentSize(CCSizeMake(self.ui.bg:getContentSize().width + fixWidth, self.ui.bg:getContentSize().height))
  self.ui.btn_back:setPositionX(self.ui.btn_back:getPositionX() + fixWidth)
  self.ui.arrow_left:setPositionX(self.ui.arrow_left:getPositionX() - fixWidth / 2)
  self.ui.arrow_right:setPositionX(self.ui.arrow_right:getPositionX() + fixWidth / 2)
end

function PetInfoWin:initUI()
  ed.editorui(ed.uieditor.herodetail, {
    container = self.container,
    ui = self.ui
  })
  self:adaptUI()
  self.ui.layer_tab:setVisible(false)
  self.layer_pet = petLayer.create({
    controller = self,
    pet = self.pet,
    pos = ccp(433.75, 239.75)
  })
  self.ui.bg:addChild(self.layer_pet.mainLayer)
end

function PetInfoWin:refreshUI()
  self.layer_pet:refreshData(self.pet)
  self.layer_pet:refreshUI(true)
end

function PetInfoWin:toNextHero()
  if self.index + 1 > #self.petList then
    self.index = 1
  else
    self.index = self.index + 1
  end
  self:initPetData()
  self:refreshUI()
end

function PetInfoWin:initPetData()
  self.pet = self.petList[self.index]
end

function PetInfoWin:toPreHero()
  if self.index - 1 == 0 then
    self.index = #self.petList
  else
    self.index = self.index - 1
  end
  self:initPetData()
  self:refreshUI()
end

function PetInfoWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self.layer_pet:refreshData(self.pet)
    self.exitHandler()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
  self.ui.arrow_left:setVisible(#self.petList > 1)
  self.ui.arrow_right:setVisible(#self.petList > 1)
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  ed.UITool.registerBtn(self, "arrow_left", function()
    self:toPreHero()
  end)
  ed.UITool.registerBtn(self, "arrow_right", function()
    self:toNextHero()
  end)
end
