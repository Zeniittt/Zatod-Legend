local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.heroAdditionPanel = class
ed.UITool.registViewOpenFunc("adventureAdditionPanel", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("heroAdditionPanel")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.actId = param.actId
  self.adventureMgr = ed.actiAdventureMgr.getInstance()
  self:initView()
  self:refreshView()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_adventure_addition_win)
  self.ui = ui
  self.container:addChild(container)
  local tokenName = ed.adventureDefine.getAdventureTokenInfo(self.actId).tokenName
  ed.setLabelString(self.ui.desc, string.format(T("\228\184\138\233\152\181\232\139\177\233\155\132\230\151\182\239\188\140%s\232\142\183\229\143\150\233\135\143\230\143\144\229\141\135"), tokenName))
  self:initDragList()
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.list_layer)
end

function class:refreshView()
  local allHeroAddition = self.adventureMgr:getAllBonusHeroInfo(self.actId)
  local heroAdditionList = {}
  for heroId, additionInfo in pairs(allHeroAddition or {}) do
    table.insert(heroAdditionList, {heroId = heroId, additionInfo = additionInfo})
  end
  table.sort(heroAdditionList, function(a, b)
    return a.additionInfo.BonusValue1 > b.additionInfo.BonusValue1
  end)
  self.dragList:clearList()
  local posY, gapY = 0, 0
  local layerSize = self.ui.list_layer:getContentSize()
  for index, heroAddition in pairs(heroAdditionList or {}) do
    local heroId = heroAddition.heroId
    local additionInfo = heroAddition.additionInfo
    local additionItem = self:createAdditionItem(heroId, additionInfo)
    local itemSize = additionItem:getContentSize()
    self.dragList:addItem(additionItem)
    additionItem:setPosition(ccp(0, layerSize.height - (itemSize.height + posY + gapY)))
    posY = posY + itemSize.height + gapY
  end
  self.dragList:initListHeight(posY)
end

function class:createAdditionItem(heroId, additionInfo)
  local container, ui = ed.editorui(ed.uieditor.activity_adventure_addition_item)
  container:setContentSize(ui.image_bg:getContentSize())
  local heroIcon = ed.readhero.createIcon({id = heroId})
  heroIcon.icon:setScale(0.9)
  ui.hero_icon:addChild(heroIcon.icon)
  ed.layout.centerInParent(heroIcon.icon)
  ed.setTexture(ui.icon, ed.adventureDefine.getAdventureTokenSmallRes(self.actId), true)
  local heroName = ed.getDataTable("Unit")[heroId]["Display Name"]
  ed.setLabelString(ui.hero_name, heroName)
  ed.setLabelStroke(ui.hero_name, ed.toccc3(2037784), 1)
  ed.setLabelString(ui.addition, string.format("+%s%%", additionInfo.BonusValue1 / 100))
  ed.setLabelStroke(ui.addition, ed.toccc3(1519903), 1)
  return container, ui
end

function class:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        if ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickInList = true
        else
          self.clickInList = false
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and not self.clickInList then
        self:close()
        return false
      end
      return false
    end,
    key = "close",
    priority = -100
  })
end

function class:close()
  self:destroy()
end
