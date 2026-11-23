local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.debugShaderScene = class
ed.UITool.registViewOpenFunc("debugShaderScene", function()
  local scene = ed.ui.debugShaderScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("debugShaderScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initView()
end

function class:initView()
  self:initButton()
  self:testHeroCard()
  self:setBackButton()
  local btnCustomerService = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local label = ed.createLabelTTF(T("\229\174\162\230\156\141"), 18)
  btnCustomerService:addChild(label)
  ed.layout.centerInParent(label)
  self.mainLayer:addChild(btnCustomerService)
  btnCustomerService:setPosition(ccp(200, 500))
  self:btRegisterButtonClick({
    button = btnCustomerService,
    key = "btnCustomerService",
    clickHandler = function()
      if EDFLAGIOS or EDFLAGANDROID then
        if EDSDKType == 302 then
          EDOpenCustomerService(ed.getJson({bbx_region = "official"}))
        elseif EDSDKType == 301 then
          EDOpenCustomerService(ed.getJson({bbx_region = "cnptr"}))
        elseif EDSDKType == 303 then
          EDOpenCustomerService(ed.getJson({bbx_region = "official"}))
        elseif EDSDKType == 501 then
          EDOpenCustomerService(ed.getJson({
            bbx_region = "farlight%3Aglobal%3Aobt"
          }))
        else
          EDOpenCustomerService("")
        end
      end
    end,
    pressScale = 0.95
  })
end

function class:initButton()
  self.angleX = 0
  self.angleY = 0
  self.angleZ = 0
  self.step = 10
  local xMinus = self:createBtn("x-", function()
    self.angleX = self.angleX - self.step
  end)
  local xAdd = self:createBtn("x+", function()
    self.angleX = self.angleX + self.step
  end)
  self.mainLayer:addChild(xMinus)
  self.mainLayer:addChild(xAdd)
  xMinus:setPosition(ccp(400, 500))
  xAdd:setPosition(ccp(600, 500))
  self.labelX = ed.createLabelTTF(self.angleX, 18)
  self.mainLayer:addChild(self.labelX)
  self.labelX:setPosition(ccp(500, 500))
  local yMinus = self:createBtn("y-", function()
    self.angleY = self.angleY - self.step
  end)
  local yAdd = self:createBtn("y+", function()
    self.angleY = self.angleY + self.step
  end)
  self.mainLayer:addChild(yMinus)
  self.mainLayer:addChild(yAdd)
  yMinus:setPosition(ccp(400, 450))
  yAdd:setPosition(ccp(600, 450))
  self.labelY = ed.createLabelTTF(self.angleY, 18)
  self.mainLayer:addChild(self.labelY)
  self.labelY:setPosition(ccp(500, 450))
  local zMinus = self:createBtn("z-", function()
    self.angleZ = self.angleZ - self.step
  end)
  local zAdd = self:createBtn("z+", function()
    self.angleZ = self.angleZ + self.step
  end)
  self.mainLayer:addChild(zMinus)
  self.mainLayer:addChild(zAdd)
  zMinus:setPosition(ccp(400, 400))
  zAdd:setPosition(ccp(600, 400))
  self.labelZ = ed.createLabelTTF(self.angleZ, 18)
  self.mainLayer:addChild(self.labelZ)
  self.labelZ:setPosition(ccp(500, 400))
end

function class:createBtn(str, clickCallBack)
  local btn = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local label = ed.createLabelTTF(str, 18)
  btn:addChild(label)
  ed.layout.centerInParent(label)
  self:btRegisterButtonClick({
    button = btn,
    key = str,
    clickHandler = function()
      clickCallBack()
      self:refresh()
    end,
    pressScale = 0.95
  })
  return btn
end

function class:refresh()
  self.labelX:setString(self.angleX)
  self.labelY:setString(self.angleY)
  self.labelZ:setString(self.angleZ)
  local location = self.rtSpr:getShaderProgram():getUniformLocationForName("angleVec4")
  self.rtSpr:getShaderProgram():use()
  self.rtSpr:getShaderProgram():setUniformsForBuiltins()
  self.rtSpr:getShaderProgram():setUniformLocationWith4f(location, -self.angleX, -self.angleY, self.angleZ, 0)
end

function class:testHeroCard()
  local hid = 53
  local fashion_id = 531
  local card = ed.readhero.getHeroCard(hid, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = fashion_id,
    rank = 13,
    stars = 5
  }, {_tid = 53})
  local sprite = card.container
  self.mainLayer:addChild(sprite)
  sprite:setVisible(false)
  sprite:setPosition(ccp(15, -15))
  sprite:setAnchorPoint(ccp(0, 0))
  local size = sprite:getContentSize()
  local rt = CCRenderTexture:create(280, 485, 0, 35056)
  self.mainLayer:addChild(rt)
  rt:setVisible(true)
  local anyRt = CCRenderTexture:create(960, 540, 0, 35056)
  self.mainLayer:addChild(anyRt)
  anyRt:setVisible(true)
  EDLoadShader("SpitePerspective")
  local x = 0
  local lab = ed.createLabelTTF("", 28)
  sprite:addChild(lab, 9999)
  lab:setPosition(ccp(100, 100))
  ed.setLabelColor(lab, ed.toccc3(16711680))
  sprite:getScheduler():scheduleScriptFunc(function()
    x = x + 0.1
    lab:setString(x)
    rt:beginWithClear(0, 0, 0, 0)
    sprite:setVisible(true)
    sprite:visit()
    rt:endToLua()
    sprite:setVisible(true)
    if not self.rtSpr then
      local rtSpr = rt:getSprite()
      local texture = rt:getSprite():getTexture()
      texture:setAntiAliasTexParameters()
      self.rtSpr = rtSpr
      rtSpr:setRotation(0)
      ed.layout.centerInScreen(rtSpr)
      local scale = 0.8
      rtSpr:setScaleX(scale)
      rtSpr:setScaleY(-scale)
      ed.useShader(self.rtSpr, "SpitePerspective")
      local sprSize = rtSpr:getContentSize()
      local location = self.rtSpr:getShaderProgram():getUniformLocationForName("sizeAnchorVec4")
      self.rtSpr:getShaderProgram():use()
      self.rtSpr:getShaderProgram():setUniformsForBuiltins()
      self.rtSpr:getShaderProgram():setUniformLocationWith4f(location, sprSize.width, sprSize.height, 0.5, 0.5)
    end
    self.rtSpr = rt:getSprite()
    anyRt:beginWithClear(0, 0, 0, 0)
    self.rtSpr:setVisible(true)
    self.rtSpr:visit()
    anyRt:endToLua()
    self.rtSpr:setVisible(true)
    if not self.anyRtSpr then
      local anyRtSpr = anyRt:getSprite()
      local texture = anyRt:getSprite():getTexture()
      texture:setAntiAliasTexParameters()
      self.anyRtSpr = anyRtSpr
      anyRtSpr:setRotation(0)
      anyRtSpr:setPosition(ccp(800, 280))
      local scale = 1
      anyRtSpr:setScaleX(scale)
      anyRtSpr:setScaleY(-scale)
    end
  end, 0, false)
end
