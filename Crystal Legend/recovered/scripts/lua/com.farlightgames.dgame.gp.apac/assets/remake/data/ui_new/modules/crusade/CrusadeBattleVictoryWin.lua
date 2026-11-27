local base = ed.ui.popwindow
local CrusadeBattleVictoryWin = {}
CrusadeBattleVictoryWin.__index = CrusadeBattleVictoryWin
setmetatable(CrusadeBattleVictoryWin, base.mt)
ed.ui.CrusadeBattleVictoryWin = CrusadeBattleVictoryWin
local CrusadeBattleVictoryWinScope = {}
local lsr = ed.ui.stagedonelsr.create()

function CrusadeBattleVictoryWin.create(params)
  local self = base.create("CrusadeBattleVictoryWin")
  setmetatable(self, CrusadeBattleVictoryWin)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow(500)
  self:show()
  return self
end

function CrusadeBattleVictoryWin:initData(params)
  self.param = params
end

function CrusadeBattleVictoryWin:createHeroIcon()
  self.heroui = {}
  local heroes = self.param.heroes
  for i = 1, 5 do
    if heroes[i] then
      local head = ed.readhero.createIconByID(heroes[i].id, {length = 63}).icon
      ed.UITool.replaceUI(self.ui, "bg_bar" .. i, "icon" .. i, head)
      ed.setString(self.ui["exp" .. i], string.format(T("EXP+%d"), heroes[i].addExp))
      local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/battleresult/expbar.png", 0.5)
      clippingNode:setPosition(0.5, 5.5)
      local sprite = ed.createScale9Sprite("UI/alpha/1080P/battleresult/expbar.png", CCRectMake(1.5, 2.5, 72, 3))
      sprite:setContentSize(CCSizeMake(65.5, 9))
      sprite:setAnchorPoint(ccp(0, 0.5))
      clippingNode:addChild(sprite)
      local stencil = clippingNode:getStencil()
      stencil:setAnchorPoint(ccp(0, 0.5))
      stencil:setScaleX(heroes[i].exp / heroes[i].maxExp * self.barScale)
      self.barScale = 65.5 / stencil:getContentSize().width
      self.ui["bar" .. i]:setVisible(false)
      self.ui["bar" .. i] = stencil
      self.ui["bg_bar" .. i]:addChild(clippingNode)
      self.heroui[i] = {
        icon = head,
        barBg = self.ui["bg_bar" .. i],
        bar = stencil,
        lv = 1
      }
    else
      self.ui["bg_bar" .. i]:setVisible(false)
    end
  end
end

function CrusadeBattleVictoryWin:playLevelupEffect(icon, id)
  local levelupFca = ed.createFcaNode("eff_UI_levelup")
  local img_levelUp
  if ed.isAreaZhCn() then
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr.png")
  else
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr-global.png")
    img_levelUp:setScale(0.9)
  end
  local img_node = CCSprite:create()
  img_node:addChild(img_levelUp)
  node:addNodeToComponent(img_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  self:addFca(levelupFca)
  levelupFca:setScale(1.45)
  levelupFca:setPosition(ccp(38, 38))
  icon:addChild(levelupFca, 5)
end

function CrusadeBattleVictoryWin:playLightAnim()
  local lightFca = ed.createFcaNode("eff_UI_pvp_light")
  lightFca:setPosition(self.ui.light:getPosition())
  self:addFca(lightFca)
  self.ui.bg:addChild(lightFca)
end

function CrusadeBattleVictoryWin:playWinAnim()
  self:playLightAnim()
end

function CrusadeBattleVictoryWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.tbcBattleVictoryWin)
  self:createHeroIcon()
  ed.setString(self.ui.label_playerlevel, string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167   Lv.%d"), ed.player:getLevel()))
  ed.setString(self.ui.label_exp, "0")
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_playerlevel, ccc3(57, 36, 21), 1)
  ed.setLabelStroke(self.ui.label_exp, ccc3(23, 49, 31), 1)
  local playerLevel = ed.player:getLevel()
  local playerExp = ed.player:getExp()
  local pt = ed.getDataTable("PlayerLevel")
  local playerMaxExp = pt[playerLevel].Exp
  local size = self.ui.exp_bar:getContentSize()
  ed.left2(self.ui.exp, self.ui.label_exp, 8)
  self.barsize = self.ui.bar1:getContentSize()
  self.ui.exp_bar:setContentSize(CCSizeMake(playerExp / playerMaxExp * size.width, size.height))
  self:playWinAnim()
end

function CrusadeBattleVictoryWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "crusade", true)
  end, {pressScale = 0.9})
end
