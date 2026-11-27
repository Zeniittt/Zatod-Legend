local base = ed.ui.popwindow
local dreamLandBattleResult = {}
dreamLandBattleResult.__index = dreamLandBattleResult
setmetatable(dreamLandBattleResult, base.mt)
ed.ui.dreamLandBattleResult = dreamLandBattleResult
local dreamLandBattleResultScope = {}
local lsr = ed.ui.stagedonelsr.create()

function dreamLandBattleResult.create(param)
  local self = base.create("dreamLandBattleResult")
  setmetatable(self, dreamLandBattleResult)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:playEnterAnim()
  self:popWindow()
  self:show()
  return self
end

function dreamLandBattleResult:initData(param)
  self.param = param
  self.lootui = {}
  self.loot_x = 0
end

function dreamLandBattleResult:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.dreamLandBattleResult)
  self.ui.btn_share:setVisible(false)
  self:initLabel()
  self:initRank()
  self:initLootList()
end

function dreamLandBattleResult:initLabel()
  ed.setLabelStroke(self.ui.rank_first_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.damage_first_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.rank_top_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.damage_top_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.my_milestone_damage_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.award_title, ccc3(ed.colorToStr("#000000")), 2)
  ed.setLabelStroke(self.ui.award_mail, ccc3(ed.colorToStr("#000000")), 2)
  ed.setLabelStroke(self.ui.milestone_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.name, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.milestone_rank_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.milestone_damage_title, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.label_back, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_share, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_share, ccc3(0, 0, 0), ccp(0, 2))
end

function dreamLandBattleResult:initRank()
  local data = self.param.dreamland_data
  ed.pt(data)
  if data.damage_current > data.damage_previous then
    ed.setTexture(self.ui.title, "UI/alpha/1080P/battleresult/damage_up.png")
  else
    ed.setTexture(self.ui.title, "UI/alpha/1080P/battleresult/missioncomplete.png", true)
  end
  if data.damage_top then
    self.ui.rank_bg = self.ui.rank_top_bg
    self.ui.rank_title = self.ui.rank_top_title
    self.ui.damage_title = self.ui.damage_top_title
    local damage_top = richText:new()
    damage_top:setString(T("<text|damage_white|%s>", ed.formatNumWithComma(data.damage_top)))
    damage_top:setVerticalCenter()
    local damage_top_w = damage_top:getSize()
    damage_top:setPosition(ccp(self.ui.rank_bg:getContentSize().width - damage_top_w - 10 / ed.display.scaleFactor, self.ui.my_milestone_damage_title:getPositionY()))
    self.ui.rank_bg:addChild(damage_top.rootNode)
    self.ui.damage_top = damage_top
  else
    self.ui.rank_bg = self.ui.rank_first_bg
    self.ui.rank_title = self.ui.rank_first_title
    self.ui.damage_title = self.ui.damage_first_title
  end
  self.ui.rank_bg:setVisible(true)
  self.ui.my_rank = CCNode:create()
  self.ui.rank_bg:addChild(self.ui.my_rank)
  local my_rank_width = self:createNumbers(self.ui.my_rank, tostring(data.rank_current))
  self.ui.my_rank:setPosition(ccp(self.ui.rank_bg:getContentSize().width - my_rank_width - 10 / ed.display.scaleFactor, self.ui.rank_title:getPositionY()))
  local damage_delta = data.damage_current - data.damage_previous
  local damage_delta_string = T("<text|damage_white|%s>", ed.formatNumWithComma(data.damage_current))
  if 0 < damage_delta and data.damage_previous > 0 then
    damage_delta_string = T("<text|damage_white|%s><text|damage_green|(><sprite|UI/alpha/1080P/battleresult/arrow_up.png><text|damage_green|%s)>", ed.formatNumWithComma(data.damage_current), tostring(damage_delta))
  end
  local damage = richText:new()
  damage:setString(damage_delta_string)
  damage:setVerticalCenter()
  local damage_w = damage:getSize()
  damage:setPosition(ccp(self.ui.rank_bg:getContentSize().width - damage_w - 10 / ed.display.scaleFactor, self.ui.damage_title:getPositionY()))
  self.ui.rank_bg:addChild(damage.rootNode)
  self.ui.damage = damage
  local summary = data.player_summary_milestone
  if summary then
    local name = ed.getPlayerName(summary._name, summary._medal, {left = true})
    ed.UITool.replaceUI(self.ui, "name_bg", "name", name)
    local hand = ed.getTeamHead({
      id = summary._avatar,
      vip = 0 < (data._vip or 0)
    })
    hand:setPosition(self.ui.player_head:getPosition())
    self.ui.milestone_rank_bg:addChild(hand)
    self.ui.other_rank = CCNode:create()
    self.ui.milestone_rank_bg:addChild(self.ui.other_rank)
    local other_rank_width = self:createNumbers(self.ui.other_rank, tostring(data.rank_milestone))
    self.ui.other_rank:setPosition(ccp(self.ui.milestone_rank_bg:getContentSize().width - other_rank_width - 10 / ed.display.scaleFactor, self.ui.milestone_rank_title:getPositionY()))
    local damage_other = richText:new()
    damage_other:setString(T("<text|damage_white|%s>", ed.formatNumWithComma(data.damage_milestone)))
    damage_other:setVerticalCenter()
    local damage_other_w = damage_other:getSize()
    damage_other:setPosition(ccp(self.ui.milestone_rank_bg:getContentSize().width - damage_other_w - 10 / ed.display.scaleFactor, self.ui.milestone_damage_title:getPositionY()))
    self.ui.milestone_rank_bg:addChild(damage_other.rootNode)
    self.ui.damage_other = damage_other
  else
    self.ui.milestone_title:setVisible(false)
    self.ui.milestone_rank_bg:setVisible(false)
  end
end

function dreamLandBattleResult:initLootList()
  local layersize = self.ui.lootLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.lootLayer,
    zorder = 10,
    priority = -300,
    doClickIn = self:doClickInLoot(),
    cancelClickIn = self:cancelClickInLoot(),
    doPressIn = self:doPressInLoot(),
    cancelPressIn = self:cancelPressInLoot()
  }
  self.lootdraglist = ed.draglist.create(info)
  self:addLootIcons()
end

function dreamLandBattleResult:addLootIcons()
  local reward_data = ed.dreamland.dreamland_object:GetRewardData()
  local reward_set = {}
  for i = 1, 7 do
    local reward_type = reward_data["Reward Type " .. i]
    if reward_type then
      local reward_amount = reward_data["Reward Amount " .. i]
      if 0 < reward_amount then
        table.insert(reward_set, {
          type = reward_type,
          amount = reward_amount,
          id = reward_data["Reward ID " .. i]
        })
      end
    end
  end
  local loots = reward_set
  for _, v in ipairs(loots) do
    self:createLootIcon(v)
  end
  self.ui.award_title:setVisible(0 < #reward_set)
  self.ui.award_mail:setVisible(0 < #reward_set)
end

function dreamLandBattleResult:createLootIcon(loot)
  local icon = ed.createItemIcon(loot)
  icon:setAnchorPoint(ccp(0, 0))
  icon:setScale(0.88)
  icon:setPosition(ccp(self.loot_x, 0))
  self.loot_x = self.loot_x + ed.layout.getScaleSize(icon).width
  self.lootdraglist.listLayer:addChild(icon)
  self.lootdraglist:initListWidth(self.loot_x)
  table.insert(self.lootui, {
    icon = icon,
    id = loot.id == 0 and loot.type or loot.id
  })
end

function dreamLandBattleResult:doClickInLoot()
  local function handler(x, y, id)
    lsr:report("clickLoot")
    
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      self.namePanel = nil
    end
  end
  
  return handler
end

function dreamLandBattleResult:cancelClickInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function dreamLandBattleResult:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        local panel = ed.readequip.getDetailCard(loot.id)
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

function dreamLandBattleResult:cancelPressInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function dreamLandBattleResult:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    base.destroy(self)
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    lsr:report("showBattleCount")
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "dramland", true)
  end, {pressScale = 0.9})
end

function dreamLandBattleResult:createNumbers(node, str)
  str = str == "0" and "99999+" or str
  local width = 0
  local height = 0
  for index = 1, #str do
    local i = index
    local c = string.sub(str, i, i)
    local frameName = ""
    if c == "+" then
      frameName = "UI/alpha/1080P/common/add.png"
    else
      frameName = T("UI/alpha/1080P/battleresult/%s.png", c)
    end
    local spr = CCSprite:create(frameName)
    if spr then
      local w = spr:getContentSize().width
      height = spr:getContentSize().height
      local relativeX = width + w * 0.5
      spr:setPosition(ccp(relativeX, 0))
      width = width + w
      node:addChild(spr)
    else
    end
  end
  return width, height
end

function dreamLandBattleResult:playEnterAnim()
  self:playLightAnim()
end

function dreamLandBattleResult:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y + 40))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 95))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 95))
  self.ui.bg:addChild(node)
end
