local base = ed.ui.popwindow
local SkillTowerBattleEndWin = newclass(base.mt)
ed.ui.SkillTowerBattleEndWin = SkillTowerBattleEndWin
local lsr = ed.ui.stagedonelsr.create()

function SkillTowerBattleEndWin.create(params)
  local self = base.create("SkillTowerBattleEndWin")
  setmetatable(self, SkillTowerBattleEndWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function SkillTowerBattleEndWin:initData(params)
  self.mgr = ed.SkillTowerManager
  self.rewards = params.rewards
  self.towerId = params.towerId
  self.curfloor = params.floorId
  self.curStageData = params.curStageData
  self.nextFloor = params.nextFloor
  self.stars = ed.engine.star
end

function SkillTowerBattleEndWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.SkillTowerVictoryWin)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_reward, {
    priority = -300,
    doClickIn = self:doClickInLoot(),
    cancelClickIn = self:cancelClickInLoot(),
    doPressIn = self:doPressInLoot(),
    cancelPressIn = self:cancelPressInLoot()
  })
  local tb = ed.getDataTable("FancyTowerStarTrigger")
  local stageData = self.curStageData
  local conditionStr1 = tb[stageData.trigger1].Describe
  if stageData.triggerParam1 then
    conditionStr1 = string.format(conditionStr1, stageData.triggerParam1)
  end
  ed.setString(self.ui.trigger1, conditionStr1)
  local conditionStr2 = tb[stageData.trigger2].Describe
  if stageData.triggerParam2 then
    conditionStr2 = string.format(conditionStr2, stageData.triggerParam2)
  end
  ed.setString(self.ui.trigger2, conditionStr2)
  local conditionStr3 = tb[stageData.trigger3].Describe
  if stageData.triggerParam3 then
    conditionStr3 = string.format(conditionStr3, stageData.triggerParam3)
  end
  ed.setString(self.ui.trigger3, conditionStr3)
  for i = 1, 3 do
    local star = self.ui["star" .. i]
    local trigger = self.ui["trigger" .. i]
    ed.setLabelColor(trigger, ccc3(222, 219, 201))
    ed.setLabelStroke(trigger, ccc3(0, 0, 0), 1)
    if self.stars[i] then
      local delay = CCDelayTime:create(0.5 + 0.5 * (i - 1))
      local func = CCCallFunc:create(function()
        xpcall(function()
          local triggerfca = ed.createFcaActor("eff_UI_fancytower_battle_light")
          self:addFca(triggerfca)
          triggerfca:setAction("Start")
          triggerfca:setPosition(ccp(0, trigger:getContentSize().height / 2))
          trigger:addChild(triggerfca, 50)
          ed.setLabelColor(trigger, ccc3(254, 211, 155))
          ed.setLabelStroke(trigger, ccc3(57, 36, 21), 1)
          local size = star:getContentSize()
          local starfca = ed.createFcaActor("eff_UI_fancytower_battle_star")
          self:addFca(starfca)
          starfca:setAction("Start")
          starfca:setPosition(ccp(size.width / 2, size.height / 2))
          star:addChild(starfca, 50)
        end, EDDebug)
      end)
      star:runAction(ed.readaction.create({
        t = "seq",
        delay,
        func
      }))
    end
  end
  self.ui.btn_again:setVisible(false)
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_again, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_reward, ccc3(0, 0, 0), 1)
  self.ui.label_back:setString(T("\231\187\167\231\187\173"))
  self:refreshDraglist()
  self:playLightAnim()
end

function SkillTowerBattleEndWin:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y - 55))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 13))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 13))
  self.ui.bg:addChild(node)
end

function SkillTowerBattleEndWin:refreshDraglist()
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  self.lootui = {}
  local loot_x = 0
  for i, v in ipairs(self.rewards) do
    local icon = ed.createItemIcon(v)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(0.88)
    icon:setPosition(ccp(loot_x, 0))
    self.draglist:addItem(icon)
    if v.first then
      local firstIcon = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
      firstIcon:setPosition(ccp(45, 80))
      firstIcon:setScale(2)
      icon:addChild(firstIcon)
      local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
      ed.setLabelColor(labelFirst, ed.toccc3(16776919))
      firstIcon:addChild(labelFirst)
      labelFirst:setPosition(ccp(24, 16.5))
    end
    table.insert(self.lootui, {
      icon = icon,
      id = v.id,
      type = v.type
    })
    loot_x = loot_x + ed.layout.getScaleSize(icon).width
  end
  self.draglist:initListWidth(loot_x)
end

function SkillTowerBattleEndWin:doClickInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function SkillTowerBattleEndWin:cancelClickInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function SkillTowerBattleEndWin:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        local panel
        if loot.id and loot.id ~= 0 then
          panel = ed.readequip.getDetailCard(loot.id)
        elseif ed.resToIconId[string.lower(loot.type)] then
          panel = ed.readequip.getDetailCard(ed.resToIconId[string.lower(loot.type)])
        else
          return
        end
        local iconsize = loot.icon:getContentSize()
        local iconpos = loot.icon:getParent():convertToWorldSpace(ccp(loot.icon:getPosition()))
        local pos = ccpAdd(iconpos, ccp(iconsize.width / 2, iconsize.height / 2))
        panel:setPosition(pos)
        self.mainLayer:addChild(panel, 50)
        self.namePanel = panel
        return i
      end
    end
  end
  
  return handler
end

function SkillTowerBattleEndWin:cancelPressInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function SkillTowerBattleEndWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
    FireEvent("SkillTowerStageEndReply", {
      rewards = self.rewards,
      nextFloor = self.nextFloor
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "skilltower", true)
  end, {pressScale = 0.9})
end
