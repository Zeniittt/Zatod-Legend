local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueBattleWin = class
local lsr = ed.ui.stagedonelsr.create()
ed.UITool.registViewOpenFunc("rogueBattleWin", function(param)
  ed.ui.rogueBattleWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueBattleWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.heroInfos = param.heroInfos or {}
  self.results = param.results or {}
  self.closeCallBack = param.closeCallBack
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBattleWin)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initHeroList()
  self:initEffect()
end

function class:initLabels()
end

function class:initHeroList()
  local panelSize = self.ui.heroLayer:getContentSize()
  local width = 40
  for index, heroData in ipairs(self.heroInfos) do
    local heroId = heroData._heroid
    local hero = ed.player:getHero(heroId)
    local heroIcon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      hp = heroData._hp_perc,
      mp = heroData._mp_perc,
      level = hero._level,
      stars = hero._stars,
      fashion_id = hero._fashion,
      summary = hero
    })
    self.ui.heroLayer:addChild(heroIcon.icon)
    heroIcon.icon:setPosition(ccp(width, panelSize.height / 2))
    width = width + 100
  end
end

function class:initReward()
  local pealAmount = 0
  for _, rogueResult in ipairs(self.results) do
    if rogueResult._type == "pearl_add" then
      pealAmount = pealAmount + rogueResult._params[1]
    end
  end
  if 0 < pealAmount then
    local itemIcon = ed.createItemIcon({
      id = nil,
      type = "Pearl",
      amount = pealAmount
    })
    itemIcon:setPosition(ccp(45, self.ui.lootLayer:getContentSize().height / 2))
    self.ui.lootLayer:addChild(itemIcon)
    self:btRegisterButtonClick({
      button = itemIcon,
      key = "item",
      clickHandler = function()
        ed.ui.packageDetailWin.create({
          id = nil,
          type = "Pearl",
          count = pealAmount
        }):popWindow()
      end,
      force = true
    })
  end
end

function class:initEffect()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y))
  self.ui.light:setVisible(false)
  self.ui.image_bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 44))
  self.ui.image_bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 44))
  self.ui.image_bg:addChild(node)
end

function class:onClickBtnData()
  lsr:report("showBattleCount")
  ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "common", true)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_back", function()
    ed.popScene()
    if self.closeCallBack then
      self.closeCallBack()
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_data", function()
    self:onClickBtnData()
  end, {pressScale = 0.95})
end

function class:addEventListener()
end
