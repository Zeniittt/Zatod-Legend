local base = ed.ui.popwindow
local SummonRewardsWindow = newclass(base.mt)
ed.ui.SummonRewardsWindow = SummonRewardsWindow
local lsr = ed.ui.popherocardlsr.create()

function SummonRewardsWindow.create(params)
  local self = base.create("SummonRewardsWindow", {notBlurBg = true})
  setmetatable(self, SummonRewardsWindow.mt)
  SummonRewardsWindow.eventScope = {}
  self:initData(params)
  self:initView()
  self:addEventListener()
  self:show()
  lsr:report("showCardAnim")
  return self
end

function SummonRewardsWindow:initData(params)
  self.rewards = params.rewards or {}
  self.summonAction = params.summonAction
  self.closeAction = params.closeAction
  self.convertIdxs = params.convertIdxs
  self.callback = params.callback
  self.tabName = params.tabName
end

function SummonRewardsWindow:initView()
  local uiCfg = ed.uieditor.summonOneRewardWindow
  if #self.rewards > 5 then
    uiCfg = ed.uieditor.summonRewardsWindow
  end
  local container, ui = ed.editorui(uiCfg)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelShadow(ui.btn_summon_label, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(ui.btn_back_label, ccc3(0, 0, 0), ccp(1, 0))
  self.ui.btn_summon_label:setString(string.format(T("\229\143\172\229\148\164%d\230\172\161"), #self.rewards))
  self.ui.cost_res_nun:setString(T("x%d", #self.rewards))
  local ticketId = ed.summonMgr:getNormalCfgConstant("Use Ticket")
  local ticketNum = ed.player:getEquipAmount(ticketId)
  if self.tabName == "destiny" then
    ticketNum = ed.player:getEquipAmount(ed.summonMgr.destinyItemId) or 0
  elseif self.tabName == "timely" or self.tabName == "newbie" then
    ticketNum = ed.player:getEquipAmount(ed.summonMgr.timelyItemId) or 0
  end
  local isRed = ticketNum < #self.rewards
  self.ui.cost_res_nun:setColor(ccc3(ed.colorToStr(isRed and "#FF0005" or "#FFFCE7")))
  self:initFontStyle()
  self:initRewardsView()
  if self.tabName == "destiny" then
    ed.setTexture(self.ui.cost_res_icon, "UI/alpha/1080P/icon/destiny_ticket.png")
  elseif self.tabName == "timely" or self.tabName == "newbie" then
    ed.setTexture(self.ui.cost_res_icon, "UI/alpha/1080P/icon/summontimely_ticket.png")
  end
end

function SummonRewardsWindow:initFontStyle()
  local fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(self.ui.reward_tips, fontcolor)
  fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(self.ui.btn_summon_label, fontcolor)
  ed.setLabelColor(self.ui.btn_back_label, fontcolor)
end

function SummonRewardsWindow:initRewardsView()
  self.ui.rewardView = CCLayer:create()
  self.ui.rewardView:setAnchorPoint(ccp(0.5, 0.5))
  self.ui.rewardView:ignoreAnchorPointForPosition(false)
  self.ui.panel_content:addChild(self.ui.rewardView)
  if self.tabName == "normal" then
    self.ui.reward_tips:setString(string.format(T("\230\136\144\229\138\159\232\180\173\228\185\176\231\187\143\233\170\140\232\141\175\232\134\143*%d\239\188\140\232\181\160\233\128\129\239\188\154"), #self.rewards))
  elseif self.tabName == "timely" or self.tabName == "newbie" then
    self.ui.reward_tips:setString(string.format(T("\230\136\144\229\138\159\232\180\173\228\185\176\231\187\143\233\170\140\232\141\175\232\134\143*%d\239\188\140\232\181\160\233\128\129\239\188\154"), #self.rewards))
  else
    self.ui.reward_tips:setString(string.format(T("\230\136\144\229\138\159\232\180\173\228\185\176\231\187\143\233\170\140\230\177\137\229\160\161*%d\239\188\140\232\181\160\233\128\129\239\188\154"), #self.rewards))
  end
  self:updateRewardsList()
end

local hero_bgs = {
  "UI/alpha/1080P/summon/hero_blue_bg.png",
  "UI/alpha/1080P/summon/hero_purple_bg.png",
  "UI/alpha/1080P/summon/hero_golden_bg.png"
}
local itemSize = CCSizeMake(75, 75)
local spaceSise = CCSizeMake(50, 75)
if not ed.isAreaZh() then
  spaceSise = CCSizeMake(75, 75)
end

function SummonRewardsWindow:updateRewardsList()
  self.ui.rewardView:removeAllChildrenWithCleanup(true)
  self.items = {}
  local rewardsLen = #self.rewards
  local w, h = itemSize.width + spaceSise.width, itemSize.height + spaceSise.height
  local totalSize = CCSizeMake(math.min(5, rewardsLen) * w, h * math.ceil(rewardsLen / 5))
  self.ui.rewardView:setContentSize(totalSize)
  ed.layout.centerInParent(self.ui.rewardView)
  for i, reward in ipairs(self.rewards) do
    local item = self:createRewardItem(reward, self.convertIdxs[i])
    if item then
      self.ui.rewardView:addChild(item)
      table.insert(self.items, item)
    end
  end
  ed.layout.layoutChildrenWithSize(self.ui.rewardView, totalSize, ed.layoutType.Grid, {
    gridSize = CCSizeMake(w, h)
  })
end

local function createItemName(name, pos)
  local ttf = ed.createttf(name, 15)
  ed.setLabelColor(ttf, ccc3(255, 251, 231))
  ed.setLabelShadow(ttf, ccc3(39, 37, 36), ccp(0, 3))
  ttf:setPosition(pos.x, pos.y)
  return ttf
end

local function createHeroStone(num, pos)
  local bg = ed.createSprite("UI/alpha/1080P/summon/item_num_bg.png")
  bg:setPosition(pos.x, pos.y)
  local size = bg:getContentSize()
  local center = ccp(size.width / 2, size.height / 2)
  local icon = ed.createSprite("UI/alpha/1080P/icon/herodetail_soulstone_icon.png")
  icon:setScale(0.9)
  icon:setPosition(center.x - 10, center.y)
  bg:addChild(icon)
  local ttf = ed.createttf("x" .. num, 14)
  ed.setLabelColor(ttf, ccc3(237, 151, 255))
  ttf:setAnchorPoint(ccp(0, 0.5))
  ttf:setPosition(center.x, center.y)
  bg:addChild(ttf)
  return bg
end

function SummonRewardsWindow:createRewardItem(reward, isConvert)
  local item = CCLayer:create()
  item:setAnchorPoint(ccp(0.5, 0.5))
  item:ignoreAnchorPointForPosition(false)
  item:setContentSize(itemSize)
  local center = ccp(itemSize.width / 2, itemSize.height / 2)
  if reward.type == "item" then
    local icon = ed.readequip.createIconWithAmount(reward.id, itemSize.width, reward.amount)
    icon:setPosition(center.x, center.y + 10)
    item:addChild(icon)
    local name = ed.lookupDataTable("equip", "Name", reward.id)
    if not ed.isAreaZh() then
      name = name:gsub("%(", [[

%(]], 1)
    end
    local label = createItemName(name, ccp(center.x, -10))
    ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
    item:addChild(label, 1)
  elseif reward.type == "hero" then
    local starNum = ed.lookupDataTable("Unit", "Initial Stars", reward.id)
    if self.tabName == "normal" then
      local fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
      fca:setScale(0.5)
      local color = ed.ui.summonScene.QualityColors[starNum + 1] or "gold"
      fca:setStartAction("Start_" .. color)
      fca:setLoopAction("Loop_" .. color)
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca)
      if 3 <= starNum then
        fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
        fca:setScale(0.5)
        fca:setStartAction("Start_" .. color .. "_star")
        fca:setLoopAction("Loop_" .. color .. "_star")
        self:addFca(fca)
        fca:setPosition(center.x, 60)
        item:addChild(fca, 1)
      end
      local actor = ed.readhero.getActor(reward.id)
      actor:setContentSize(itemSize)
      actor:setPosition(center.x + 20, 40)
      local template = ed.lookupDataTable("Unit", nil, reward.id)
      local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
      actor:setScale(scale * 0.6)
      self:addFca(actor)
      item:addChild(actor)
      local name = ed.lookupDataTable("Unit", "Display Name", reward.id)
      local label = createItemName(name, ccp(center.x, -10))
      ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
      item:addChild(label)
      if isConvert then
        local num = ed.summonMgr:getFragmentNumByStar(starNum)
        item:addChild(createHeroStone(num, ccp(center.x, 10)), 1)
      else
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag)
      end
    elseif self.tabName == "destiny" then
      local fca = ed.createFcaNode("eff_UI_SummonDestiny_Light")
      fca:setScale(0.5)
      fca:setStartAction("Start_gold")
      fca:setLoopAction("Loop_gold")
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca)
      fca = ed.createFcaNode("eff_UI_SummonDestiny_Light")
      fca:setScale(0.5)
      fca:setStartAction("Start_gold_star")
      fca:setLoopAction("Loop_color_star")
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca, 1)
      local actor = ed.readhero.getActor(reward.id)
      actor:setContentSize(itemSize)
      actor:setPosition(center.x + 20, 40)
      local template = ed.lookupDataTable("Unit", nil, reward.id)
      local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
      actor:setScale(scale * 0.6)
      self:addFca(actor)
      item:addChild(actor)
      local name = ed.lookupDataTable("Unit", "Display Name", reward.id)
      local label = createItemName(name, ccp(center.x, -10))
      ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
      item:addChild(label)
      local sum = 90
      if isConvert and isConvert == 90 then
        item:addChild(createHeroStone(isConvert, ccp(center.x, 10)), 1)
      elseif isConvert and isConvert < 90 then
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag, 1)
        item:addChild(createHeroStone(isConvert, ccp(center.x, -30)), 1)
      else
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag)
      end
    elseif self.tabName == "timely" or self.tabName == "newbie" or self.tabName == "riseStar" then
      local fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
      fca:setScale(0.5)
      local color = ed.ui.summonScene.QualityColors[starNum + 1] or "gold"
      fca:setStartAction("Start_" .. color)
      fca:setLoopAction("Loop_" .. color)
      self:addFca(fca)
      fca:setPosition(center.x, 60)
      item:addChild(fca)
      if 3 <= starNum then
        fca = ed.createFcaNode("eff_UI_SummonCircle_Light")
        fca:setScale(0.5)
        fca:setStartAction("Start_" .. color .. "_star")
        fca:setLoopAction("Loop_" .. color .. "_star")
        self:addFca(fca)
        fca:setPosition(center.x, 60)
        item:addChild(fca, 1)
      end
      local actor = ed.readhero.getActor(reward.id)
      actor:setContentSize(itemSize)
      actor:setPosition(center.x + 20, 40)
      local template = ed.lookupDataTable("Unit", nil, reward.id)
      local scale = ed.lookupDataTable("Puppet", "Summon Circle Scale", template.Puppet) or 1
      actor:setScale(scale * 0.6)
      self:addFca(actor)
      item:addChild(actor)
      local name = ed.lookupDataTable("Unit", "Display Name", reward.id)
      local label = createItemName(name, ccp(center.x, -10))
      ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
      item:addChild(label)
      if isConvert then
        local num = ed.summonMgr:getFragmentNumByStar(starNum)
        item:addChild(createHeroStone(num, ccp(center.x, 10)), 1)
      else
        local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
        new_tag:setPosition(0, 20)
        label:addChild(new_tag)
      end
    end
  end
  return item
end

function SummonRewardsWindow:addEventListener()
  self:registerBtnClick("btn_summon", function()
    if not self.inPlaying and self.summonAction then
      self.summonAction(#self.rewards)
      self:destroy({
        skipAnim = true,
        callback = function()
          self:onDestroy()
        end
      })
      ed.memeryGC(10)
    end
  end)
  self:registerBtnClick("btn_back", function()
    self:destroy({
      skipAnim = true,
      callback = function()
        self:onDestroy()
      end
    })
    ed.memeryGC(10)
  end)
end

function SummonRewardsWindow:registerBtnClick(key, func)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    pressScale = 0.95,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func()
    end,
    clickInterval = 1,
    priority = 10
  }
  self:btRegisterButtonClick(config)
end

function SummonRewardsWindow:onDestroy()
  if self.callback then
    self.callback()
  end
  CloseScope(SummonRewardsWindow.eventScope)
  SummonRewardsWindow.eventScope = nil
  if self.closeAction then
    self.closeAction()
  end
end
