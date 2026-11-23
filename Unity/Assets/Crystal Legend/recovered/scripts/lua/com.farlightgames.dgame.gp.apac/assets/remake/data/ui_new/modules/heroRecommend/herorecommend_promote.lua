module("ed.herorecommend", package.seeall)
promote = {}
promote.__index = promote
local base = ed.ui.popwindow
setmetatable(promote, base.mt)
ed.herorecommend.promote = promote

function promote.create(data)
  local object = base.create("promote")
  setmetatable(object, promote)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function promote:initData(data)
  self.promoteTable = ed.getDataTable("HeroPromote")
  self.mgr = promoteMgr.create(data)
end

function promote:initAppearence()
  self.window = ed.createui("herorecommend_promotion", {
    mainLayer = self.mainLayer,
    touch_node = self
  })
  self:initManito()
  self:createPromoteList()
end

function promote:initManito()
  local userhead = self:createUserHead(self.mgr.manito)
  self.window.ui.img_herodetail_bg:addChild(userhead)
  userhead:setPosition(ccp(-40, 100))
  if self.mgr.manito._guild_name then
    ed.setString(self.window.ui.lab_guild, self.mgr.manito._guild_name)
  else
    self.window.ui.lab_guild:setVisible(false)
    self.window.ui.img_guild_title:setVisible(false)
  end
  ed.setString(self.window.ui.lab_fighting, tostring(self.mgr.data._top_gs))
  ed.setString(self.window.ui.lab_myfighting, tostring(self.mgr.data._self_gs))
  local nameSprite = self:createHeroNameSprite()
  local fixHeight = 25
  local height = nameSprite:getContentSize().height
  local scale = fixHeight / height
  nameSprite:setScale(scale)
  self.window.ui.panel_heroname:addChild(nameSprite)
end

function promote:createUserHead(summary)
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.8,
    name = summary._name,
    vip = summary._vip > 0,
    lvoffset = {
      x = -5,
      y = 0,
      scale = 0.75
    },
    offset = {x = 0, y = 0}
  }
  if summary._medal then
    param.medal = summary._medal
  end
  if summary._babel_level then
    param.babelLevel = summary._babel_level
  end
  return ed.getWholeHeadIcon(param)
end

function promote:createHeroNameSprite()
  local nameres = ed.getUnitArtName(self.mgr.heroid)
  return ed.createSprite(nameres)
end

function promote:createPromoteList()
  local promoteWay = self.mgr.upway
  for i, id in ipairs(promoteWay) do
    local promote = self:createPromoteIcon(id)
    self.window.ui.img_bg:addChild(promote)
    promote:setPosition(ccp(-35 + i * 160, 30))
  end
end

function promote:createPromoteIcon(id)
  local data = self.promoteTable[id]
  local node = CCNode:create()
  local iconres = data.UI
  local iconSprite = ed.createSprite(iconres)
  iconSprite:setPosition(ccp(0, 70))
  local labbgres = "UI/alpha/1080P/common/tip_detail_bg.png"
  local labbgSprite = ed.createSprite(labbgres)
  local hotLabel = ed.createLabelWithFontInfo(data["Promote Type Des"], "herorecommend_white")
  node:addChild(labbgSprite)
  node:addChild(hotLabel)
  node:addChild(iconSprite)
  local type = data["Promote Type"]
  self:btRegisterButtonClick({
    button = iconSprite,
    key = "click_promote_hero" .. type,
    clickHandler = function()
      self:openPromote(type)
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  return node
end

function promote:openPromote(type)
  local typeToFunHash = {
    awake2 = "openHeroCard",
    awake = "openHeroCard",
    level = "openHeroCard",
    skill = "openHeroSkill",
    enchantment = "openEnchantment",
    book = "openSchoolBook",
    runestone = "openRunestone",
    concise = "openConcise",
    school = "openLearnedClub",
    pet = "openPetPanel",
    petskill = "openPetPanel",
    star = "openHeroCard",
    petequip = "openPetPanel"
  }
  local funName = typeToFunHash[type]
  local fun = self[funName]
  return fun(self)
end

function promote:openHeroCard()
  self:openHeroAttribute("card")
end

function promote:openHeroSkill()
  self:openHeroAttribute("skill")
end

function promote:openHeroAttribute(mode)
  local heroDetailLayer = ed.ui.herodetail.initWindow(self.mgr.hero, nil, {openMode = mode, isShowUpgradeButton = true})
  heroDetailLayer:popWindow(manager.baseZorde + 2)
  if ed.getCurrentScene().identity == "heropackage_recommend" then
    local scene = ed.getCurrentScene()
    scene.heroDetailLayer = heroDetailLayer
  end
  return heroDetailLayer
end

function promote:openEnchantment()
  ed.pushScene(ed.ui.equipstrengthen.create())
end

function promote:openSchoolBook()
  ed.ui.warcollege.open(self.mgr.promoteBookid)
end

function promote:openRunestone()
  self:openHeroAttribute("rune")
end

function promote:openConcise()
  local msg = ed.upmsg.open_arousal()
  ed.send(msg, "open_arousal")
end

function promote:openLearnedClub()
  local readingHouse = ed.ui.readinghouse.create()
  readingHouse.identity = "readinghouse_promote"
  ed.pushScene(readingHouse)
end

function promote:openPetPanel()
  local heroDetailLayer = self:openHeroAttribute("card")
  heroDetailLayer:openPetWindow()
end

function promote:registerTouchHandler()
  self.window:registerBtn("btn_close", function()
    self:destroy({skipAnim = true})
  end)
end
