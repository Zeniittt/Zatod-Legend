local base = ed.ui.popwindow
local SkillTowerExBattleEndWin = newclass(base.mt)
ed.ui.SkillTowerExBattleEndWin = SkillTowerExBattleEndWin

function SkillTowerExBattleEndWin.create(params)
  local self = base.create("SkillTowerExBattleEndWin")
  setmetatable(self, SkillTowerExBattleEndWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function SkillTowerExBattleEndWin:initData(params)
  self.rewards = params.rewards or {}
  self.curStageData = params.curStageData
  self.breakHistory = params.breakHistory
  self.battleTime = math.floor(ed.engine.ticks * ed.tick_interval)
end

function SkillTowerExBattleEndWin:initLabels()
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_again, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_reward, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.curtime1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.curtime2, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.historytime1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.historytime2, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.besttime1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.besttime2, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.best_in_self, ed.toccc3(10551124), 0.5)
  ed.setLabelShadow(self.ui.best_in_self, ed.toccc3(1727272), ccp(0, 1))
  ed.setLabelFontName(self.ui.best_in_self, ed.fontBold)
end

function SkillTowerExBattleEndWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.SkillTowerExVictoryWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_reward, {
    doClickIn = self:doClickInLoot(),
    cancelClickIn = self:cancelClickInLoot(),
    doPressIn = self:doPressInLoot()
  })
  ed.setString(self.ui.curtime2, ed.gethmsNString(self.battleTime))
  if self.curStageData.passTime then
    if self.battleTime < self.curStageData.passTime then
      self.ui.best_in_self:setVisible(true)
      self.curStageData.passTime = self.battleTime
    else
      self.ui.historytime1:setVisible(true)
      self.ui.historytime2:setVisible(true)
      ed.setString(self.ui.historytime2, ed.gethmsNString(self.curStageData.passTime))
    end
  else
    self.ui.best_in_self:setVisible(true)
    self.curStageData.passTime = self.battleTime
  end
  if self.curStageData.serverPassInfo then
    local bestInfo = self.curStageData.serverPassInfo
    local serverBestTime = bestInfo._min_time
    if self.breakHistory then
      local fca = ed.createFcaNode("eff_UI_abyss_fastrecord")
      fca:setPosition(ccp(self.ui.best_in_server:getPosition()))
      local fca_label = ed.createLabelTTF(T("\229\183\178\229\136\183\230\150\176\230\156\172\230\156\141\230\156\128\229\191\171\232\174\176\229\189\149\239\188\129\239\188\129\239\188\129"), 34, ed.fontBold)
      fca_label:limitWidthByScale(700)
      ed.setLabelColor(fca_label, ed.toccc3(16772519))
      ed.setLabelStroke(fca_label, ed.toccc3(13859851), 1)
      ed.setLabelShadow(fca_label, ed.toccc3(6759697), ccp(0, 1.5))
      local node_label = CCSprite:create()
      node_label:addChild(fca_label)
      local fca_label_bg = ed.createSprite("UI/alpha/1080P/skilltower/bg_tower_record.png")
      local node_label_bg = CCSprite:create()
      node_label_bg:addChild(fca_label_bg)
      if EDCurLanguage == "cn" then
        fca_label:setPosition(ccp(40, 0))
      end
      fca:addNodeToComponent(node_label, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      fca:addNodeToComponent(node_label_bg, "Node", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      self.ui.bg:addChild(fca)
      self:addFca(fca)
    else
      local summary = bestInfo._user_summary
      local head = ed.getWholeHeadIcon({
        id = summary._avatar,
        level = summary._level,
        lvoffset = {x = -48, y = -25},
        scale = 0.7,
        no_name_bg = true
      })
      ed.UITool.replaceUI(self.ui, "bg_head", "icon_head", head)
      local name = ed.getPlayerName(summary._name, summary._medal, {
        anchorPoint = ccp(0, 0.5)
      })
      ed.UITool.replaceUI(self.ui, "bg_head", "label_name", name)
      ed.setString(self.ui.guildname, summary._guild_name or "")
      ed.setString(self.ui.besttime2, ed.gethmsNString(serverBestTime))
      self.ui.bg_head:setVisible(true)
    end
  end
  self:refreshDraglist()
  self:playLightAnim()
end

function SkillTowerExBattleEndWin:playLightAnim()
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

function SkillTowerExBattleEndWin:refreshDraglist()
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  self.lootui = {}
  local width = 0
  for i, v in ipairs(self.rewards) do
    local icon = ed.createItemIcon(v)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(0.88)
    icon:setPosition(ccp(width, 0))
    self.draglist:addItem(icon)
    table.insert(self.lootui, {
      icon = icon,
      id = v.id,
      type = v.type
    })
    width = width + ed.layout.getScaleSize(icon).width
  end
  self.ui.label_reward:setVisible(0 < #self.rewards)
  self.draglist:initListWidth(width)
end

function SkillTowerExBattleEndWin:doClickInLoot()
  local function handler(x, y, id)
    ed.ui.packageDetailWin.create(self.lootui[id]):popWindow()
  end
  
  return handler
end

function SkillTowerExBattleEndWin:cancelClickInLoot()
  local function handler(x, y, id)
  end
  
  return handler
end

function SkillTowerExBattleEndWin:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        return i
      end
    end
  end
  
  return handler
end

function SkillTowerExBattleEndWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
    FireEvent("SkillTowerStageEndReply", {
      nextFloor = #self.rewards > 0
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "skilltower", true)
  end, {pressScale = 0.9})
end
