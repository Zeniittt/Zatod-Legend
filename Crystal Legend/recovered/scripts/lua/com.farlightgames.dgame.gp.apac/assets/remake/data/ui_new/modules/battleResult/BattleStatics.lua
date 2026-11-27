local base = ed.ui.popwindow
local BattleStaticsWin = {}
BattleStaticsWin.__index = BattleStaticsWin
setmetatable(BattleStaticsWin, base.mt)
ed.ui.BattleStaticsWin = BattleStaticsWin
local BattleStaticsWinScope = {}

local function replaceUI(ui, parent, to, from)
  local x, y = ui[to]:getPosition()
  ui[to]:setVisible(false)
  from:setPosition(ccp(x, y))
  ui[parent]:addChild(from)
  ui[to] = from
end

function BattleStaticsWin.create(param, type, isBattleData)
  local self = base.create("BattleStaticsWin")
  setmetatable(self, BattleStaticsWin)
  self.maxNum = {
    0,
    0,
    0,
    0
  }
  self.titles = {
    {
      my = T("\230\136\145\230\150\185\232\190\147\229\135\186\228\188\164\229\174\179"),
      enemy = T("\230\149\140\230\150\185\232\190\147\229\135\186\228\188\164\229\174\179")
    },
    {
      my = T("\230\136\145\230\150\185\230\137\191\229\143\151\228\188\164\229\174\179"),
      enemy = T("\230\149\140\230\150\185\230\137\191\229\143\151\228\188\164\229\174\179")
    },
    {
      my = T("\230\136\145\230\150\185\230\178\187\231\150\151"),
      enemy = T("\230\149\140\230\150\185\230\178\187\231\150\151")
    },
    {
      my = T("\230\136\145\230\150\185\229\135\187\230\157\128\228\186\186\230\149\176"),
      enemy = T("\230\149\140\230\150\185\229\135\187\230\157\128\228\186\186\230\149\176")
    }
  }
  if type == "pvp" or type == "guildClash" or type == "cupArena" then
    self.titles = {
      {
        my = T("\232\191\155\230\148\187\230\150\185\232\190\147\229\135\186\228\188\164\229\174\179"),
        enemy = T("\233\152\178\229\174\136\230\150\185\232\190\147\229\135\186\228\188\164\229\174\179")
      },
      {
        my = T("\232\191\155\230\148\187\230\150\185\230\137\191\229\143\151\228\188\164\229\174\179"),
        enemy = T("\233\152\178\229\174\136\230\150\185\230\137\191\229\143\151\228\188\164\229\174\179")
      },
      {
        my = T("\232\191\155\230\148\187\230\150\185\230\178\187\231\150\151"),
        enemy = T("\233\152\178\229\174\136\230\150\185\230\178\187\231\150\151")
      },
      {
        my = T("\232\191\155\230\148\187\230\150\185\229\135\187\230\157\128\228\186\186\230\149\176"),
        enemy = T("\233\152\178\229\174\136\230\150\185\229\135\187\230\157\128\228\186\186\230\149\176")
      }
    }
  end
  self.isBattleData = isBattleData
  if isBattleData then
    self:initDataByBattle(param, type)
  else
    self:initData(param, type)
  end
  self.tabIndex = 1
  self.selfIcon = {}
  self.enemyIcon = {}
  self.schedule = {}
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  self:popWindow()
  return self
end

function BattleStaticsWin:initData(data, type)
  self.serverEnineList = data._hero_data
  for i, unit in ipairs(self.serverEnineList) do
    self.maxNum[1] = math.max(self.maxNum[1], unit._damage)
    self.maxNum[2] = math.max(self.maxNum[2], unit._suffer_damage)
    self.maxNum[3] = math.max(self.maxNum[3], unit._healing)
    self.maxNum[4] = math.max(self.maxNum[4], unit._kill)
  end
end

function BattleStaticsWin:initDataByBattle(data, type)
  self.serverEnineList = data
  self.maxNum = {
    0,
    0,
    0,
    0
  }
  for i, unit in ipairs(self.serverEnineList) do
    self.maxNum[1] = math.max(self.maxNum[1], unit.battledata:getDamage())
    self.maxNum[2] = math.max(self.maxNum[2], unit.battledata:getBearDamage())
    self.maxNum[3] = math.max(self.maxNum[3], unit.battledata:getTakeHeal())
    self.maxNum[4] = math.max(self.maxNum[4], unit.battledata:getKillNum())
  end
end

function BattleStaticsWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.BattleStaticWin)
  ed.left2(self.ui.title_left_line, self.ui.label_title, 15)
  ed.right2(self.ui.title_right_line, self.ui.label_title, 15)
  for i = 1, 4 do
    if ed.isAreaZh() then
      ed.setLabelDimensions(self.ui["label_btn" .. i], CCSizeMake(30, 0))
    else
      ed.adaptLabel(self.ui["label_btn" .. i], {maxWidth = 50, minScale = 0.8})
      self.ui["label_btn" .. i]:setHorizontalAlignment(kCCTextAlignmentCenter)
    end
  end
  self.ui.line1:setScale(1.3)
  self.ui.line2:setScale(1.3)
  self.ui.line3:setScale(1.3)
  self:initDragList()
  self:refreshUI()
end

function BattleStaticsWin:initDragList()
  self.leftDragList = ed.UITool.createDraglist(self.ui.layer_left)
  self.rightDragList = ed.UITool.createDraglist(self.ui.layer_right)
end

function BattleStaticsWin:createStaticItem(type, unit)
  local container, ui
  if type == "left" then
    container, ui = ed.editorui(ed.uieditor.BattleStaticItemLeft)
  else
    container, ui = ed.editorui(ed.uieditor.BattleStaticItemRight)
  end
  container:setContentSize(CCSizeMake(300, 55))
  local spriteIcon
  if self.isBattleData then
    spriteIcon = self:createHeroIconByBattle(unit)
  else
    spriteIcon = self:createHeroIcon(unit)
  end
  ui.bar_bg:addChild(spriteIcon)
  spriteIcon:setPosition(ui.panel_icon:getPosition())
  return container, ui
end

function BattleStaticsWin:getBarTime(tdmg, cmaxdmg, maxtime)
  if 0 == cmaxdmg then
    return 0
  end
  return tdmg / cmaxdmg * maxtime
end

function BattleStaticsWin:numberJump(id, label, dmg_statistics, speedtime)
  local count = 0
  local scheduler = self.container:getScheduler()
  local speed = 0
  self.currentJumpId = id
  if 0 ~= speedtime then
    speed = dmg_statistics / speedtime
  end
  
  local function handler(dt)
    count = count + dt
    local ce = math.min(math.floor(speed * count), dmg_statistics)
    if ce >= dmg_statistics then
      ce = dmg_statistics
      scheduler:unscheduleScriptEntry(self.schedule[id])
      self.currentJumpId = nil
    end
    ed.setString(label, ed.setCommaForNumber(math.floor(ce)))
  end
  
  return handler
end

local function createDeadLabel()
  local label = ed.createLabelTTF(T("\229\183\178\233\152\181\228\186\161"), 18)
  ed.setLabelColor(label, ed.toccc3(16741231))
  ed.setLabelStroke(label, ed.toccc3(0), 2)
  return label
end

function BattleStaticsWin:createHeroIconByBattle(unit)
  local rank = math.min(unit.rank or 1, ed.parameter.unit_max_rank)
  local legendInfo = unit.legendEquip and unit.legendEquip.proto
  local spriteIcon, heroInfo = ed.readhero.getIcon({
    id = unit.tid,
    level = unit.level,
    stars = unit.stars,
    length = 45,
    rank = rank,
    fashion_id = unit.fashion_id,
    summary = unit.proto,
    shard = unit.proto._shard,
    legendEquip = legendInfo
  })
  heroInfo:showLegendEquip(not ed.openLegendEquip())
  if unit.hp and unit.hp <= 0 then
    local die = createDeadLabel()
    die:setPosition(36, 60)
    spriteIcon:addChild(die, 10)
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(spriteIcon:getContentSize())
    spriteIcon:addChild(shade)
  end
  return spriteIcon
end

function BattleStaticsWin:createHeroIcon(unit)
  local rank = math.min(unit._rank or 1, ed.parameter.unit_max_rank)
  local legendInfo
  if unit._legend_equip then
    legendInfo = unit._legend_equip and unit._legend_equip._equip
  else
    legendInfo = nil
  end
  local spriteIcon, heroInfo = ed.readhero.getIcon({
    id = unit._tid,
    level = unit._level,
    stars = unit._stars,
    length = 45,
    rank = rank,
    fashion_id = unit._fashion_id,
    shard = unit._shard_id,
    summary = unit,
    legendEquip = legendInfo
  })
  heroInfo:showLegendEquip(not ed.openLegendEquip())
  if unit._hp and unit._hp <= 0 then
    local die = createDeadLabel()
    die:setPosition(36, 60)
    spriteIcon:addChild(die, 10)
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(spriteIcon:getContentSize())
    spriteIcon:addChild(shade)
  end
  return spriteIcon
end

function BattleStaticsWin:refreshMainPanelByBattle()
  local scheduler = self.container:getScheduler()
  if scheduler then
    for i, v in pairs(self.schedule or {}) do
      scheduler:unscheduleScriptEntry(v)
    end
  end
  local index = self.tabIndex
  ed.setString(self.ui.self_statistics, self.titles[index].my)
  ed.setString(self.ui.enemy_statistics, self.titles[index].enemy)
  self.leftDragList:clearList()
  self.rightDragList:clearList()
  local mCNum, eCNum = 1, 1
  for i, unit in ipairs(self.serverEnineList) do
    local len
    if index == 1 then
      len = unit.battledata:getDamage() or 0
    elseif index == 2 then
      len = unit.battledata:getBearDamage() or 0
    elseif index == 3 then
      len = unit.battledata:getTakeHeal() or 0
    elseif index == 4 then
      len = unit.battledata:getKillNum() or 0
    end
    local maxLen = self.maxNum[index]
    local batTime = self:getBarTime(len, maxLen, 0.8)
    local array = CCArray:create()
    array:addObject(CCScaleTo:create(batTime, len / maxLen, 1))
    local sequence = CCSequence:create(array)
    if ed.emCampPlayer == unit.camp then
      local leftStaticItem, ui = self:createStaticItem("left", unit)
      local itemSize = leftStaticItem:getContentSize()
      self.leftDragList:addItem(leftStaticItem)
      leftStaticItem:setPosition(ccp(itemSize.width / 2 + 27, self.ui.layer_left:getContentSize().height - itemSize.height * mCNum + 17))
      ui.bar:setScaleX(0)
      ui.bar:runAction(sequence)
      ed.setString(ui.label_num, 0)
      self.schedule["self" .. index .. mCNum] = self.container:getScheduler():scheduleScriptFunc(self:numberJump("self" .. index .. mCNum, ui.label_num, len, batTime), 0, false)
      mCNum = mCNum + 1
    elseif ed.emCampEnemy == unit.camp then
      local rightStaticItem, ui = self:createStaticItem("right", unit)
      local itemSize = rightStaticItem:getContentSize()
      self.rightDragList:addItem(rightStaticItem)
      rightStaticItem:setPosition(ccp(itemSize.width / 2 - 27, self.ui.layer_right:getContentSize().height - itemSize.height * eCNum + 17))
      ui.bar:setScaleX(0)
      ui.bar:runAction(sequence)
      ed.setString(ui.label_num, 0)
      self.schedule["enemy" .. index .. eCNum] = self.container:getScheduler():scheduleScriptFunc(self:numberJump("enemy" .. index .. eCNum, ui.label_num, len, batTime), 0, false)
      eCNum = eCNum + 1
    end
  end
  self.leftDragList:initListHeight((mCNum - 1) * 55)
  self.rightDragList:initListHeight((eCNum - 1) * 55)
end

function BattleStaticsWin:refreshMainPanel()
  local scheduler = self.container:getScheduler()
  if scheduler then
    for i, v in pairs(self.schedule or {}) do
      scheduler:unscheduleScriptEntry(v)
    end
  end
  local index = self.tabIndex
  ed.setString(self.ui.self_statistics, self.titles[index].my)
  ed.setString(self.ui.enemy_statistics, self.titles[index].enemy)
  local mCNum, eCNum = 1, 1
  self.leftDragList:clearList()
  self.rightDragList:clearList()
  for i, unit in ipairs(self.serverEnineList) do
    local len
    if index == 1 then
      len = unit._damage or 0
    elseif index == 2 then
      len = unit._suffer_damage or 0
    elseif index == 3 then
      len = unit._healing or 0
    elseif index == 4 then
      len = unit._kill or 0
    end
    local maxLen = self.maxNum[index]
    local batTime = self:getBarTime(len, maxLen, 0.8)
    local array = CCArray:create()
    array:addObject(CCScaleTo:create(batTime, len / maxLen, 1))
    local sequence = CCSequence:create(array)
    if ed.emCampPlayer == unit._camp then
      local leftStaticItem, ui = self:createStaticItem("left", unit)
      local itemSize = leftStaticItem:getContentSize()
      self.leftDragList:addItem(leftStaticItem)
      leftStaticItem:setPosition(ccp(itemSize.width / 2 + 27, self.ui.layer_left:getContentSize().height - itemSize.height * mCNum + 17))
      ui.bar:setScaleX(0)
      ui.bar:runAction(sequence)
      ed.setString(ui.label_num, 0)
      self.schedule["self" .. index .. mCNum] = self.container:getScheduler():scheduleScriptFunc(self:numberJump("self" .. index .. mCNum, ui.label_num, len, batTime), 0, false)
      mCNum = mCNum + 1
    elseif ed.emCampEnemy == unit._camp then
      local rightStaticItem, ui = self:createStaticItem("right", unit)
      local itemSize = rightStaticItem:getContentSize()
      self.rightDragList:addItem(rightStaticItem)
      rightStaticItem:setPosition(ccp(itemSize.width / 2 - 27, self.ui.layer_right:getContentSize().height - itemSize.height * eCNum + 17))
      ui.bar:setScaleX(0)
      ui.bar:runAction(sequence)
      ed.setString(ui.label_num, 0)
      self.schedule["enemy" .. index .. eCNum] = self.container:getScheduler():scheduleScriptFunc(self:numberJump("enemy" .. index .. eCNum, ui.label_num, len, batTime), 0, false)
      eCNum = eCNum + 1
    end
  end
  self.leftDragList:initListHeight((mCNum - 1) * 55)
  self.rightDragList:initListHeight((eCNum - 1) * 55)
end

function BattleStaticsWin:refreshButton()
  for i = 1, 4 do
    if i == self.tabIndex then
      self.ui["selected_btn" .. i]:setVisible(true)
      ed.setLabelColor(self.ui["label_btn" .. i], ccc3(254, 241, 169))
    else
      self.ui["selected_btn" .. i]:setVisible(false)
      ed.setLabelColor(self.ui["label_btn" .. i], ccc3(146, 146, 147))
    end
  end
end

function BattleStaticsWin:refreshUI()
  if self.isBattleData then
    self:refreshMainPanelByBattle()
  else
    self:refreshMainPanel()
  end
  self:refreshButton()
end

function BattleStaticsWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {clickInterval = 0.1, pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn1", function()
    if self.tabIndex ~= 1 then
      self.tabIndex = 1
      self:refreshUI()
    end
  end, {clickInterval = 0.1, pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn2", function()
    if self.tabIndex ~= 2 then
      self.tabIndex = 2
      self:refreshUI()
    end
  end, {clickInterval = 0.1, pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn3", function()
    if self.tabIndex ~= 3 then
      self.tabIndex = 3
      self:refreshUI()
    end
  end, {clickInterval = 0.1, pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_btn4", function()
    if self.tabIndex ~= 4 then
      self.tabIndex = 4
      self:refreshUI()
    end
  end, {clickInterval = 0.1, pressScale = 0.9})
end
