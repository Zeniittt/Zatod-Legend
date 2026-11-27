local base = ed.ui.popwindow
local timeCorridorRewardsWin = newclass(base.mt)
ed.ui.timeCorridorRewardsWin = timeCorridorRewardsWin
local lsr = ed.ui.popherocardlsr.create()

function timeCorridorRewardsWin.create(params)
  local self = base.create("timeCorridorRewardsWin", {notBlurBg = true})
  setmetatable(self, timeCorridorRewardsWin.mt)
  timeCorridorRewardsWin.eventScope = {}
  self:initData(params)
  self:initView()
  self:initRewardsList()
  self:addEventListener()
  self:popWindow()
  self:show()
  lsr:report("showCardAnim")
  return self
end

local function defaultFunc()
end

function timeCorridorRewardsWin:initData(params)
  self.rewards = params.rewards or {}
  self.summonAction = params.summonAction or defaultFunc
  self.closeAction = params.closeAction or defaultFunc
  self.smashMap = params.smashMap
  self.callback = params.callback or defaultFunc
end

function timeCorridorRewardsWin:initView()
  local uiCfg = ed.uieditor.timeCorridorOneRewardWindow
  if #self.rewards > 5 then
    uiCfg = ed.uieditor.timeCorridorRewardsWindow
  end
  local container, ui = ed.editorui(uiCfg)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelShadow(ui.btn_summon_label, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(ui.btn_back_label, ccc3(0, 0, 0), ccp(1, 0))
  self.ui.btn_summon_label:setString(string.format(T("\232\191\189\229\175\187%d\230\172\161"), #self.rewards))
  local cost = ed.timeCorridorMgr:calcSummonCost(#self.rewards)
  self.ui.cost_res_nun:setString(T("x%d", cost))
  if cost == 0 then
    self.ui.ImageView_88:setVisible(false)
  end
  local isRed = cost > ed.player:getEquipAmount(ed.timeCorridorMgr.summonPassId)
  self.ui.cost_res_nun:setColor(ccc3(ed.colorToStr(isRed and "#FF0005" or "#FFFCE7")))
  local fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(self.ui.btn_summon_label, fontcolor)
  ed.setLabelColor(self.ui.btn_back_label, fontcolor)
  local icon = ed.createSprite(ed.timeCorridorMgr:getPassSmallIconRes())
  ed.UITool.replaceUINew(ui, "cost_res_icon", icon)
  ed.right2(ui.cost_res_nun, icon, 2)
end

local itemSize = CCSizeMake(90, 90)
local spaceSize = CCSizeMake(50, 75)
if not ed.isAreaZh() then
  spaceSize = CCSizeMake(75, 75)
end

function timeCorridorRewardsWin:initRewardsList()
  self.ui.rewardView = CCLayer:create()
  self.ui.rewardView:setAnchorPoint(ccp(0.5, 0.5))
  self.ui.rewardView:ignoreAnchorPointForPosition(false)
  self.ui.panel_content:addChild(self.ui.rewardView)
  self.items = {}
  local rewardsLen = #self.rewards
  local w, h = itemSize.width + spaceSize.width, itemSize.height + spaceSize.height
  local totalSize = CCSizeMake(math.min(5, rewardsLen) * w, h * math.ceil(rewardsLen / 5))
  self.ui.rewardView:setContentSize(totalSize)
  ed.layout.centerInParent(self.ui.rewardView)
  for i, reward in ipairs(self.rewards) do
    local isSmash = self.smashMap[i]
    local item = self:createRewardItem(reward, isSmash)
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

local function createSmashTip(num, pos)
  local bg = ed.createSprite("UI/alpha/1080P/summon/item_num_bg.png")
  bg:setPosition(pos.x, pos.y)
  local size = bg:getContentSize()
  local icon = ed.createSprite(ed.timeCorridorMgr:getTokenSmallIconRes())
  icon:setScale(0.7)
  icon:setPositionY(size.height * 0.5)
  bg:addChild(icon)
  local ttf = ed.createLabelTTF("+" .. num, 18)
  ed.setLabelColor(ttf, ccc3(237, 151, 255))
  ttf:setPositionY(size.height * 0.5)
  bg:addChild(ttf)
  ed.layout.horizontalSortNode({ttf, icon}, {0, 0}, size.width * 0.5)
  return bg
end

local summonColorName = {
  "blue",
  "blue",
  "blue",
  "purple",
  "purple",
  "orange",
  "red",
  "pink",
  "color"
}

function timeCorridorRewardsWin:createRewardItem(reward, isSmash)
  local rewardId = reward._id
  local rewardType = reward._type
  local rewardAmount = reward._amount
  local item = CCLayer:create()
  item:setAnchorPoint(ccp(0.5, 0.5))
  item:ignoreAnchorPointForPosition(false)
  item:setContentSize(itemSize)
  local center = ccp(itemSize.width / 2, itemSize.height / 2)
  local isFashion = ed.isElementInTable(ed.readequip.value(rewardId, "Consume Type"), {"\231\154\174\232\130\164"})
  local hasColorBg = ed.isElementInTable(ed.readequip.value(rewardId, "Category"), {
    T("\229\164\180\229\131\143"),
    T("\229\164\180\229\131\143\230\161\134")
  })
  local hasNewTag = (ed.isElementInTable(ed.readequip.value(rewardId, "Category"), {
    T("\232\161\168\230\131\133\229\140\133")
  }) or hasColorBg) and not isSmash
  if hasColorBg then
    local quality = math.max(ed.lookupDataTable("equip", "Quality", rewardId), 3)
    local bg = ed.createSprite(ed.getFashionFrameResByQuality(quality, "fashionRewardItemBg"))
    bg:setPosition(ccp(center.x, center.y + 20))
    item:addChild(bg)
  end
  if isFashion then
    local quality = ed.lookupDataTable("equip", "Quality", rewardId)
    local actionName = "Start_" .. summonColorName[quality]
    local fcaBack = ed.createFcaActor("eff_UI_Skin_Light", 0.5)
    fcaBack:setAction(actionName)
    fcaBack:setLoop(true)
    fcaBack:setPosition(ccp(center.x + 5, center.y + 15))
    self:addFca(fcaBack)
    item:addChild(fcaBack, -1)
    local fcaFront = ed.createFcaActor("eff_UI_Skin_Light", 0.5)
    fcaFront:setAction("Start_color_star")
    fcaFront:setLoop(true)
    fcaFront:setPosition(ccp(center.x + 5, center.y + 15))
    self:addFca(fcaFront)
    item:addChild(fcaFront, 15)
  end
  local name = ed.lookupDataTable("equip", "Name", rewardId)
  if isFashion then
    local fashionId = ed.getDataTable("equip")[rewardId]["Fashion ID"]
    local heroId = ed.lookupDataTable("Fashion", "Hero ID", fashionId)
    local puppet, puppet_id, cha = ed.readhero.getActor(heroId, "Idle", true, false, fashionId, false)
    local row = ed.getDataTable("Puppet")[puppet_id]
    local scale = row.Scale * 0.6
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = row.Scale * wscale
    end
    puppet:setScale(scale)
    puppet:setPosition(ccp(center.x, 10))
    item:addChild(puppet, 10)
    self:addFca(puppet)
  else
    local icon = ed.readequip.createIconWithAmount(rewardId, itemSize.width, rewardAmount)
    icon:setPosition(center.x, center.y + 5)
    item:addChild(icon)
  end
  local label = createItemName(name, ccp(center.x, -5))
  ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
  item:addChild(label, 1)
  if hasNewTag then
    local new_tag = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
    new_tag:setPosition(18, itemSize.width - 5)
    item:addChild(new_tag, 20)
  end
  if isSmash then
    item:addChild(createSmashTip(ed.timeCorridorMgr:getRewardSmashNumById(rewardId), ccp(center.x, -25)), 10)
  end
  return item
end

function timeCorridorRewardsWin:addEventListener()
  self:registerBtnClick("btn_summon", function()
    if not self.inPlaying and self.summonAction then
      local summon = self.summonAction(#self.rewards)
      if not summon then
        return
      end
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

function timeCorridorRewardsWin:registerBtnClick(key, func)
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

function timeCorridorRewardsWin:onDestroy()
  if self.callback then
    self.callback()
  end
  if self.closeAction then
    self.closeAction()
  end
end
