local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloDataPanel = class

function class:initLabels()
  ed.setLabelStroke(self.ui.player_label_type_title, ed.toccc3(4403750), 1.5)
  ed.setLabelStroke(self.ui.oppo_label_type_title, ed.toccc3(4403750), 1.5)
  ed.setLabelStroke(self.ui.player_label_detail_title, ed.toccc3(4403750), 1.5)
  ed.setLabelStroke(self.ui.oppo_label_detail_title, ed.toccc3(4403750), 1.5)
  ed.setLabelStroke(self.ui.player_label_damage, ed.toccc3(2039582), 1.5)
  ed.setLabelStroke(self.ui.oppo_label_damage, ed.toccc3(1315860), 1.5)
end

function class:createFactionIcon(id, isOppo)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(70, 20))
  local iconRes = ed.getDataTable("SoloCardTag")[id]["Tag2 Icon"]
  local icon = ed.createSprite(iconRes)
  icon:setScale(0.6)
  icon:setPosition(ccp(20, 10))
  container:addChild(icon)
  local label = ed.createLabelTTF("0", 14)
  label:setPosition(ccp(32, 10))
  label:setAnchorPoint(ccp(0, 0.5))
  label:setColor(ed.toccc3(16776423))
  ed.setLabelStroke(label, ed.toccc3(2039582), 1.5)
  container:addChild(label)
  local suffix = isOppo and "_oppo" or "_player"
  self:btRegisterButtonClick({
    button = container,
    key = "faction_" .. id .. suffix,
    clickHandler = function()
      self:handlerFactionIconClick(id, isOppo)
    end
  })
  return container, label
end

function class:handlerFactionIconClick(id, isOppo)
  if isOppo then
    if id == self.showOppoTid then
      return
    end
    self:refreshOppoDetail(id)
  else
    if id == self.showPlayerTid then
      return
    end
    self:refreshPlayerDetail(id)
  end
end

function class:getCardIconRes(type, id, isPlayer)
  if type == 1 then
    return ed.getDataTable("SoloCardSkill")[id]["Card Icon"]
  elseif type == 2 then
    local tid = isPlayer and ed.SoloModel.playerHeroId or ed.SoloModel.oppoHeroId
    local res = ed.getDataTable("SoloSkillGroup")[tid][id].Icon
    return string.gsub(res, ".png", ".jpg")
  elseif type == 3 then
    return "UI/alpha/1080P/chesscard/tagicon5.png"
  elseif type == 4 then
    return "UI/alpha/1080P/chesscard/tagicon6.png"
  elseif type == 7 then
    return "UI/alpha/1080P/chesscard/3.png"
  elseif type == 8 then
    return "UI/alpha/1080P/chesscard/4.png"
  end
end

function class:getCardName(type, id, isPlayer)
  if type == 1 then
    return ed.getDataTable("SoloCardSkill")[id].Name
  elseif type == 2 then
    local tid = isPlayer and ed.SoloModel.playerHeroId or ed.SoloModel.oppoHeroId
    return ed.getDataTable("SoloSkillGroup")[tid][id]["Display Name"]
  elseif type == 3 then
    return T("\229\155\158\232\161\128")
  elseif type == 4 then
    return T("\229\155\158\232\147\157")
  elseif type == 7 then
    return T("\228\184\173\230\175\146")
  elseif type == 8 then
    return T("\229\134\176\229\134\187")
  end
end

function class:createCardData(v, maxDamage, isPlayer)
  local container, ui = ed.editorui(ed.uieditor.SoloDataItem)
  local iconRes = self:getCardIconRes(v.type, v.id, isPlayer)
  if iconRes then
    ed.setTextureV2(ui.icon, iconRes)
  end
  ed.setString(ui.label_info, string.format("%sx%d", self:getCardName(v.type, v.id, isPlayer), v.amount))
  ed.setString(ui.label_value, math.floor(v.value))
  ed.setLabelStroke(ui.label_info, ed.toccc3(1315860), 1)
  ed.setLabelStroke(ui.label_value, ed.toccc3(1315860), 1)
  local progress = CCProgressTimer:create(ui.bar)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  ui.bg_bar:addChild(progress)
  ui.bar:setVisible(false)
  ed.layout.centerInParent(progress)
  progress:setPercentage(v.value / maxDamage * 100)
  return container, ui
end

local TypeName = {
  [1] = T("\230\153\174\230\148\187\230\172\161\230\149\176"),
  [2] = T("\233\151\170\233\129\191\230\172\161\230\149\176"),
  [3] = T("\230\154\180\229\135\187\230\172\161\230\149\176"),
  [4] = T("\231\148\159\229\145\189\229\138\160\230\136\144"),
  [5] = T("\230\129\162\229\164\141\232\161\128\233\135\143"),
  [6] = T("\229\164\167\230\139\155\230\172\161\230\149\176"),
  [7] = T("\229\137\167\230\175\146\229\177\130\230\149\176"),
  [8] = T("\229\134\176\229\134\187\229\177\130\230\149\176"),
  [9] = T("\230\138\164\231\155\190\229\177\130\230\149\176"),
  [10] = T("\229\162\158\228\188\164\229\177\130\230\149\176"),
  [11] = T("\230\158\129\233\128\159\229\177\130\230\149\176")
}

function class:refreshOppoDetail(id)
  self.showOppoTid = id
  id = id or 0
  if id == 0 then
    ed.setString(self.ui.oppo_label_detail_title, T("\228\188\164 \229\174\179"))
  else
    ed.setString(self.ui.oppo_label_detail_title, TypeName[id])
  end
  self.ui.layer_oppo_detail:removeAllChildrenWithCleanup(true)
  local factionData = ed.SoloModel:getFactionBattleData(id, false) or {}
  if not factionData then
    return
  end
  local subData = factionData.subData
  if #subData == 0 then
    return
  end
  local maxDamage = subData[1].value
  for k, v in ipairs(subData) do
    local container, ui = self:createCardData(v, maxDamage, false)
    container:setPosition(ccp(0, 156 - k * 25))
    self.ui.layer_oppo_detail:addChild(container)
    if 5 < k then
      return
    end
  end
end

function class:refreshPlayerDetail(id)
  self.showPlayerTid = id
  id = id or 0
  if id == 0 then
    ed.setString(self.ui.player_label_detail_title, T("\228\188\164 \229\174\179"))
  else
    local cardTagTb = TypeName[id]
    ed.setString(self.ui.player_label_detail_title, cardTagTb)
  end
  self.ui.layer_player_detail:removeAllChildrenWithCleanup(true)
  local factionData = ed.SoloModel:getFactionBattleData(id, true)
  if not factionData then
    return
  end
  local subData = factionData.subData
  if #subData == 0 then
    return
  end
  local maxDamage = subData[1].value
  for k, v in ipairs(subData) do
    local container, ui = self:createCardData(v, maxDamage, true)
    container:setPosition(ccp(0, 156 - k * 25))
    self.ui.layer_player_detail:addChild(container)
    if 5 < k then
      return
    end
  end
end

function class:initPanel()
  ed.setString(self.ui.player_label_damage, "0")
  ed.setString(self.ui.oppo_label_damage, "0")
  
  local function getPos(i)
    local oy = 245
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    return ccp(37 + col * 70, oy - row * 19)
  end
  
  local factions = {}
  for factionId, faction in pairs(ed.SoloModel.factions or {}) do
    if factionId ~= 4 then
      table.insert(factions, factionId)
    end
  end
  table.sort(factions)
  self.playerItems = {}
  for k, v in ipairs(factions) do
    local container, label = self:createFactionIcon(v)
    container:setPosition(getPos(k))
    self.ui.player_type:addChild(container)
    table.insert(self.playerItems, {id = v, label = label})
  end
  self.oppoItems = {}
  for k, v in ipairs(factions) do
    local container, label = self:createFactionIcon(v, true)
    container:setPosition(getPos(k))
    self.ui.oppo_type:addChild(container)
    table.insert(self.oppoItems, {id = v, label = label})
  end
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloDataPop, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.layout.layoutWithMagin(self.ui.player_type, {
    left = ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.oppo_type, {
    right = ed.display.getNotchHeight()
  }, false, true)
  self:initPanel()
  self:closePanel()
end

function class:updatePanel()
  local dataDamage = ed.SoloModel:getFactionBattleData(0, true)
  if not dataDamage then
    return
  end
  local damagePlayer = dataDamage.totalValue
  local damageOppo = ed.SoloModel:getFactionBattleData(0, false).totalValue
  ed.setString(self.ui.player_label_damage, math.floor(damagePlayer))
  ed.setString(self.ui.oppo_label_damage, math.floor(damageOppo))
  for k, v in ipairs(self.playerItems) do
    local battleData = ed.SoloModel:getFactionBattleData(v.id, true)
    if battleData then
      ed.setString(v.label, math.floor(battleData.totalValue))
    end
  end
  self:refreshPlayerDetail(self.showPlayerTid)
  for k, v in ipairs(self.oppoItems) do
    local battleData = ed.SoloModel:getFactionBattleData(v.id, false)
    if battleData then
      ed.setString(v.label, math.floor(battleData.totalValue))
    end
  end
  self:refreshOppoDetail(self.showOppoTid)
end

function class:onBattleStart()
  self.ui.layer_player:setVisible(true)
  self.ui.layer_oppo:setVisible(true)
  self:refreshPlayerDetail(0)
  self:refreshOppoDetail(0)
end

function class:switchPanel(isPlayer)
  if isPlayer then
    self.ui.layer_player:setVisible(not self.ui.layer_player:isVisible())
  else
    self.ui.layer_oppo:setVisible(not self.ui.layer_oppo:isVisible())
  end
end

function class:closePanel()
  self.ui.layer_player:setVisible(false)
  self.ui.layer_oppo:setVisible(false)
end

function class:update()
  self:updatePanel()
end

function class.create()
  local self = base.create("SoloDataPanel", {
    notBlurBg = true,
    noShade = true,
    swallow = false
  })
  setmetatable(self, class.mt)
  self:initUI()
  self.ticks = 0
  self.isOpenLeft = true
  self.isOpenRight = true
  ed.UITool.registerBtn(self, "player_damage", function()
    self:handlerFactionIconClick(0, false)
  end)
  ed.UITool.registerBtn(self, "oppo_damage", function()
    self:handlerFactionIconClick(0, true)
  end)
  ed.UITool.registerBtn(self, "ImageView_1841", function()
    if self.isOpenLeft then
      self.isOpenLeft = false
      self.ui.player_type:runAction(CCMoveBy:create(0.2, ccp(-145, 0)))
      self.ui.ImageView_1854:setScaleX(1)
    else
      self.isOpenLeft = true
      self.ui.player_type:runAction(CCMoveBy:create(0.2, ccp(145, 0)))
      self.ui.ImageView_1854:setScaleX(-1)
    end
  end, {clickInterval = 0.4})
  ed.UITool.registerBtn(self, "ImageView_1841_Copy0", function()
    if self.isOpenRight then
      self.isOpenRight = false
      self.ui.oppo_type:runAction(CCMoveBy:create(0.2, ccp(145, 0)))
      self.ui.ImageView_18541:setScaleX(1)
    else
      self.isOpenRight = true
      self.ui.oppo_type:runAction(CCMoveBy:create(0.2, ccp(-145, 0)))
      self.ui.ImageView_18541:setScaleX(-1)
    end
  end, {clickInterval = 0.4})
  return self
end
