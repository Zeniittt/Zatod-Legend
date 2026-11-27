local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueExchangePetWindow = class
ed.UITool.registViewOpenFunc("rogueExchangePetWindow", function(param)
  ed.ui.rogueExchangePetWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueExchangePetWindow", {noShade = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.petReward = param.petReward
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:show()
  ed.rogueGuide.getInstance():startGuide("rogueExchangePetWindow", self.ui.image_item_bg)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueExchangePetWindow)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initEffect()
  self:initLabels()
  self:initDragList()
  self:initEgg()
  self:refreshDragList()
  self:startCountDown()
  local vitalityAmount = self.rogueLikeMgr:getVitality()
  local maxVitality = ed.getDataTable("RogueConfig")["Max Vitality"]["Script Arg"]
  ed.setLabelString(self.ui.vitality_amount, string.format("%s/%s", vitalityAmount, maxVitality))
  local amount = self.rogueLikeMgr:getItemAmount()
  local maxAmount = self.rogueLikeMgr:getItemMaxAmount()
  ed.setLabelString(self.ui.fish_amount, string.format("%s/%s", amount, maxAmount))
  if vitalityAmount < 1 then
    ed.setLabelColor(self.ui.label_use_vitality_amount, ed.toccc3(16744036))
    ed.setLabelStroke(self.ui.label_use_vitality_amount, ed.toccc3(9840662), 1)
    ed.setTexture(self.ui.btn_use_vitality, "UI/alpha/1080P/common/button_grey.png")
  end
  if amount < 1 then
    ed.setLabelColor(self.ui.label_use_item_amount, ed.toccc3(16744036))
    ed.setLabelStroke(self.ui.label_use_item_amount, ed.toccc3(9840662), 1)
    ed.setTexture(self.ui.btn_use_item, "UI/alpha/1080P/common/button_grey.png")
  end
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_vitality_bg, {right = 10, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_fish_bg, {right = 120, top = 20}, false, true)
end

function class:initEffect()
  local eff_eggLight = ed.createFcaNode("eff_UI_rogue_egg_light")
  self:addFca(eff_eggLight)
  self.ui.image_bg:addChild(eff_eggLight)
  eff_eggLight:setPositionX(self.ui.image_egg:getPositionX())
  eff_eggLight:setPositionY(self.ui.image_egg:getPositionY() + 20)
end

function class:initLabels()
  ed.setLabelShadow(self.ui.label_tips, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_end_tips, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_left_time, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_left_time_tips, ed.toccc3(0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_hatch_tips, ed.toccc3(0), ccp(0, 2))
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = function(x, y)
      for _, petCfg in ipairs(self.petList or {}) do
        if ed.containsPoint(petCfg.icon, x, y) then
          local panel = ed.rogueLikeTool.showPetDetail(petCfg.petId)
          self.mainLayer:addChild(panel)
          ed.layout.relateLayout(petCfg.icon, panel, {top = 0})
          self.petInfoPanel = panel
          return petCfg
        end
      end
    end,
    cancelPressIn = function()
      if self.petInfoPanel and not tolua.isnull(self.petInfoPanel) then
        self.petInfoPanel:removeFromParentAndCleanup(true)
        self.petInfoPanel = nil
      end
    end
  })
end

function class:initEgg()
  local eggId = self.petReward.rewardId
  local eggIcon = ed.createItemIcon({id = eggId})
  self.ui.panel_egg_icon:addChild(eggIcon)
  eggIcon:setScale(1)
  ed.layout.centerInParent(eggIcon)
  local eggName = ed.readequip.value(eggId, "Name")
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format("\229\143\145\231\142\176\228\186\134<lable color=ccc3(255,165,49)>%s</lable>\239\188\129\230\182\136\232\128\151\228\188\160\233\128\129\229\141\183\232\189\180\230\136\150\232\128\133\229\145\188\229\148\164\233\128\129\229\173\144\233\185\164\229\176\134\228\187\150\229\184\166\229\136\176\228\191\161\228\189\191\229\177\139", eggName),
    color = ed.toccc3(16776423),
    fontSize = 18,
    maxWidth = panelSize.width
  })
  self.ui.panel_desc:addChild(autoText.node)
  local descSizeW, descSizeH = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(panelSize.width / 2 - descSizeW / 2, 9))
end

function class:refreshDragList()
  local panelSize = self.ui.panel_list:getContentSize()
  self.dragList:clearList()
  local eggId = self.petReward.rewardId
  local eggCfg = ed.getDataTable("PetEgg")[eggId]
  local width = 0
  local gapX = 5
  local lootDisplay = ed.copyTable(eggCfg["Loot Display"] or {})
  ed.readpet.sortPetIdByColor(lootDisplay)
  self.petList = {}
  for index, loot in ipairs(lootDisplay) do
    local icon = ed.readpet.createIcon({type = loot}).icon
    self.dragList:addItem(icon)
    table.insert(self.petList, {petId = loot, icon = icon})
    local iconSize = icon:getContentSize()
    icon:setPosition(ccp(width + iconSize.width / 2, panelSize.height / 2))
    width = width + iconSize.width + gapX
  end
  self.dragList:initListWidth(width)
  if width < panelSize.width then
    self.dragList:setListPos(ccp((panelSize.width - width) / 2, 0))
  end
end

function class:startCountDown()
  self:refreshLeftTime()
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local endTime = curChapter._end_time
  local leftTime = endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local sec = leftTime % 60
  self.ui.label_left_time:setString((string.format(T("%.2d:%.2d:%.2d"), hour, min, sec)))
end

function class:showVitalityExchangeEff(callBack)
  local eff_rogueEggSummon = ed.createFcaNode("eff_UI_rogue_egg_summon")
  self:addFca(eff_rogueEggSummon)
  self.ui.image_bg:addChild(eff_rogueEggSummon, 999)
  eff_rogueEggSummon:setPosition(self.ui.image_egg:getPosition())
  self.ui.image_egg:setVisible(false)
  eff_rogueEggSummon:setAction("Start")
  local delay = CCDelayTime:create(1.3)
  local callFunc = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
  end)
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(delay, callFunc)))
end

function class:showItemExchangeEff(callBack)
  local eff_rogueEggBird = ed.createFcaNode("eff_UI_rogue_egg_bird")
  self:addFca(eff_rogueEggBird)
  self.ui.image_bg:addChild(eff_rogueEggBird, 999)
  eff_rogueEggBird:setPosition(self.ui.image_egg:getPosition())
  self.ui.image_egg:setVisible(false)
  eff_rogueEggBird:setAction("Start")
  local delay = CCDelayTime:create(1.3)
  local callFunc = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
  end)
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(delay, callFunc)))
end

function class:onClickBtnUse(type)
  if type == "vitality" then
    local vitality = self.rogueLikeMgr:getVitality()
    if vitality < 1 then
      ed.showToast(T("\228\188\160\233\128\129\229\141\183\232\189\180\228\184\141\232\182\179"))
      return
    end
    self:showVitalityExchangeEff(function()
      self:onEffectEndCallBack(type)
    end)
  elseif type == "item" then
    local itemAmount = self.rogueLikeMgr:getItemAmount()
    local itemId = ed.getDataTable("RogueConfig")["Use Vitality Item"]["Script Arg"]
    local name = ed.readequip.value(itemId, "Name") or ""
    if itemAmount < 1 then
      ed.showToast(string.format(T("%s\228\184\141\232\182\179"), name))
      return
    end
    self:showItemExchangeEff(function()
      self:onEffectEndCallBack(type)
    end)
  end
end

function class:onEffectEndCallBack(type)
  local waveId = self.petReward.waveId
  ed.rogueLikeNet.sendVitalityExchangeReward(waveId, type, 1)
  self:close({skipAnim = true})
end

function class:onClickFish()
  local itemId = ed.getDataTable("RogueConfig")["Use Vitality Item"]["Script Arg"]
  ed.ui.packageDetailWin.create({id = itemId, type = "item"}):popWindow()
end

function class:onClickVitality()
  ed.ui.packageDetailWin.create({
    type = "roguevitality"
  }):popWindow()
end

function class:close(param)
  self:destroy(param)
  ed.rogueGuide.getInstance():startGuide("closeRogueExchangePetWindow")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:close()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_use_vitality", function()
    self:onClickBtnUse("vitality")
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_use_item", function()
    self:onClickBtnUse("item")
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "image_fish_bg", function()
    self:onClickFish()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_vitality_bg", function()
    self:onClickVitality()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.panel_click_area,
    key = "clickOut",
    clickHandler = function()
      self:close()
    end,
    force = true
  })
end

function class:addEventListener()
end
