local class = {}
ed.ui.exchangeSoulPage = class
class.LOW_TOKEN_ID = 20142
class.HEIGHT_TOKEN_ID = 20143
class.TOKEN_TO_PATH = {
  [class.LOW_TOKEN_ID] = "UI/alpha/1080P/icon/lowsoul.png",
  [class.HEIGHT_TOKEN_ID] = "UI/alpha/1080P/icon/highsoul.png"
}

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.pageKey = pageKey
  self.taskList = param._tasks
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.endTime = param._end_time
  self.actiDataTable = ed.getDataTable("Activity")[self.cfgId]
  self.soulExchangeGroup = self.actiDataTable["Extra AN"][1] or 1
  self.exchangeTaskList = {}
  self.isVisible = true
  self:initView()
  self:addListenEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_exchange_soul)
  self.container = container
  self.ui = ui
  self:adaptUI()
  self:refreshLeftTime()
  self:refreshTokenAmount()
  self:initTableView()
  self:refreshTask()
end

function class:adaptUI()
  self.subColNum = 0
  local fixX = math.max(0, 1170 - ed.display.winSize.width)
  if 168 <= fixX then
    ed.UITool.setContentSizeBy(self.ui.layer_item, -168, 0)
    self.subColNum = 1
    ed.UITool.setPositionBy(self.ui.layer_item, ccp(68, 0))
    ed.UITool.setPositionBy(self.ui.panel_eff_resolve, ccp(-100, 0))
  end
  local eff_soulExchange = ed.createFcaActor("eff_UI_Main_SoulExchange")
  local soul_label = ed.createLabelTTF(T("\231\134\148\231\130\188"), 21, ed.fontBold)
  ed.setLabelColor(soul_label, ed.toccc3(16776423))
  ed.setLabelStroke(soul_label, ed.toccc3(295033), 1)
  local soul_label_bg = ed.createSprite("UI/alpha/1080P/soulexchange/soulexchange_button1.png")
  soul_label_bg:addChild(soul_label)
  soul_label:limitWidthByScale(soul_label_bg:getContentSize().width * 0.7)
  ed.layout.centerInParent(soul_label)
  local soul_node = CCSprite:create()
  soul_node:addChild(soul_label_bg)
  eff_soulExchange:addNodeToComponent(soul_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  self.eff_soulExchange = eff_soulExchange
  self:addFca(eff_soulExchange)
  self.ui.panel_eff_resolve:ignoreAnchorPointForPosition(false)
  self.ui.panel_eff_resolve:setAnchorPoint(ccp(0.5, 0.5))
  self.ui.panel_eff_resolve:addChild(eff_soulExchange)
  ed.layout.centerInParent(eff_soulExchange)
  eff_soulExchange:setScale(1.5)
  eff_soulExchange:setAction("Loop")
  eff_soulExchange:setLoop(true)
  ed.layout.layoutHalfFixedMagin(self.ui.token_bg1, {right = true, top = true})
  ed.layout.layoutHalfFixedMagin(self.ui.token_bg2, {right = true, top = true})
end

function class:initTableView()
  local delegate = {
    numberOfCells = function()
      return #self.exchangeTaskList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(165, 180)
    end,
    createCell = function(index)
      local taskData = self.exchangeTaskList[index]
      local node, ui = self:createExchangeItem(taskData)
      return node, {taskData = taskData, ui = ui}
    end,
    doClickIn = function(cell)
      if not self.isVisible then
        return
      end
      local param = cell.data
      local taskData = param.taskData
      local ui = param.ui
      local needTokenAmount = taskData._cond_target
      local reward = taskData._rewards and taskData._rewards[1]
      local surplusAmount = taskData._max_reward_times - taskData._cur_reward_times
      if surplusAmount <= 0 then
        ed.showToast(T("\230\178\161\230\156\137\229\186\147\229\173\152\228\186\134"))
        return
      end
      if ui.isHeld then
        ed.showToast(T("\229\183\178\230\139\165\230\156\137\232\175\165\231\137\169\229\147\129"))
        return
      end
      local panel = ed.ui.buyResourceBox.create({
        buyLimitNum = surplusAmount,
        defaultBuyNum = 1,
        goodsResType = ed.ui.configs.resType.getResType(reward._type),
        goodsId = reward._id,
        costResType = "Item",
        costId = taskData._cond_id,
        price = needTokenAmount,
        groupAmount = reward._amount,
        costIconConfig = {
          smallIcon = class.TOKEN_TO_PATH[taskData._cond_id]
        },
        buyAction = function(num)
          if 0 < num then
            self.objWork:activitySubmit(self.activityId, taskData._id, num)
            self.reduceCostAmount = needTokenAmount * num
            self.reduceItemId = taskData._cond_id
            self.objWork:activityPull(self.activityId)
          end
        end
      })
      panel:setSurplusAmount(surplusAmount)
      panel:popWindow()
    end
  }
  local size = self.ui.layer_item:getContentSize()
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(1, 1, size.width - 2, size.height - 2),
    container = self.ui.layer_item,
    touchpriority = -300,
    zorder = 10,
    dragMode = 1,
    noshade = true,
    colNum = 4 - self.subColNum,
    offset = {0, -5},
    padding = {width = 3, height = 5}
  }
  self.itemTbView = Tableview.create(param)
end

function class:refreshLeftTime()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  self.ui.label_left_time:setString(T("\229\137\169\228\189\153%s", ed.time2dhmsV2(leftTime)))
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(2516847), 1)
end

function class:refreshTokenAmount()
  if self.reduceCostAmount and self.reduceCostAmount > 0 then
    ed.player:consumeEquip(self.reduceItemId, self.reduceCostAmount)
    self.reduceCostAmount = 0
  end
  ed.setLabelString(self.ui.token_amount1, ed.player:getEquipAmount(class.LOW_TOKEN_ID))
  ed.setLabelString(self.ui.token_amount2, ed.player:getEquipAmount(class.HEIGHT_TOKEN_ID))
end

function class:refreshTask()
  self.exchangeTaskList = {}
  for index, taskData in ipairs(self.taskList or {}) do
    if taskData._cond_type == "soul_exchange" then
      table.insert(self.exchangeTaskList, taskData)
    end
  end
  table.sort(self.exchangeTaskList, ed.cmpSort({
    {
      getValue = function(taskData)
        local isSoldOut = taskData._max_reward_times - taskData._cur_reward_times <= 0
        if isSoldOut then
          return 2
        end
        local reward = taskData._rewards[1]
        if ed.isElementInTable(ed.readequip.value(reward._id, "Consume Type"), {"\231\154\174\232\130\164"}) or ed.isElementInTable(ed.readequip.value(reward._id, "Category"), {"\229\164\180\229\131\143", "\229\164\180\229\131\143\230\161\134"}) then
          local ownAmount = ed.player:getEquipAmount(reward._id)
          if not isSoldOut and 0 < ownAmount then
            return 1
          end
        end
        return 0
      end
    },
    {key = "_id"}
  }))
  self:refreshTableView()
end

function class:refreshTableView()
  self.itemTbView:reloadData()
end

function class:createExchangeItem(taskData)
  local container, ui = ed.editorui(ed.uieditor.shopitem)
  local soldout_label = ui.soldout_label
  ed.setLabelFontName(soldout_label, ed.fontBold)
  ed.setLabelStroke(soldout_label, ed.toccc3(2826261), 1.5)
  ed.adaptLabel(soldout_label, {maxWidth = 56, minScale = 0.65})
  ui.img_bg:setZOrder(-10)
  container:setContentSize(CCSizeMake(165, 175.5))
  local reward = taskData._rewards[1]
  local quality = ed.readequip.quality(reward._id) or 1
  local bg_size = ui.img_bg:getContentSize()
  ui.img_bg:setSpriteFrame(ed.getSpriteFrame(string.format("UI/alpha/1080P/shop/shop_goods_bg_%d.png", quality == 4 and 5 or quality)))
  ui.img_bg:setContentSize(bg_size)
  ed.initSpriteWithFrame(ui.img_price, class.TOKEN_TO_PATH[taskData._cond_id])
  local maxRewardTimes = taskData._max_reward_times
  local curRewardTimes = taskData._cur_reward_times
  local amount = maxRewardTimes - curRewardTimes
  ui.label_num:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", amount))
  ui.label_num:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
  ui.label_num:setColor(ccc3(ed.colorToStr(amount <= 0 and "#FF664B" or "#FFD790")))
  local isSoldOut = amount <= 0
  ui.img_nil:setVisible(isSoldOut)
  ui.soldout_shade:setVisible(isSoldOut)
  ui.pan_time:setVisible(false)
  ui.label_name:setString("")
  local wid = ui.img_bj:getContentSize()
  local icon, name = ed.createItemIcon({
    id = reward._id,
    amount = reward._amount,
    type = reward._type
  }, true)
  icon:setPosition(wid.width / 2, wid.height - 50)
  icon:setScale(1)
  ui.img_bj:addChild(icon)
  name:setColor(ccc3(ed.colorToStr("#FFF1D7")))
  name:setStroke(ccc3(ed.colorToStr("#2b2015")), 1)
  name:setPositionY(name:getPositionY() - 8)
  ed.adaptLabel(name, {
    maxWidth = wid.width * 0.85,
    minScale = 0.8
  })
  ui.line_long_price:setVisible(false)
  ui.label_long_price:setVisible(false)
  ui.label_zhe:setVisible(false)
  ui.label_price:setString(taskData._cond_target)
  ui.label_price:setFontSize(20)
  local isRed = taskData._cond_target > ed.player:getEquipAmount(taskData._cond_id)
  if ed.isElementInTable(ed.readequip.value(reward._id, "Consume Type"), {"\231\154\174\232\130\164"}) or ed.isElementInTable(ed.readequip.value(reward._id, "Category"), {"\229\164\180\229\131\143", "\229\164\180\229\131\143\230\161\134"}) then
    local ownAmount = ed.player:getEquipAmount(reward._id)
    if not isSoldOut and 0 < ownAmount then
      ed.setTexture(ui.img_nil, "UI/alpha/1080P/soulexchange/soulexchange_held.png", true)
      ui.img_nil:setVisible(true)
      ui.soldout_shade:setVisible(true)
      ui.soldout_label:setVisible(false)
      ui.isHeld = true
      local labelHeld = ed.createttf(T("\229\183\178\230\140\129\230\156\137"), 20, ed.fontBold)
      ed.setLabelColor(labelHeld, ed.toccc3(15950681))
      ed.setLabelStroke(labelHeld, ed.toccc3(2826261), 1.5)
      labelHeld:limitWidthByScale(64)
      ui.img_nil:addChild(labelHeld)
      local size = ui.img_nil:getContentSize()
      labelHeld:setPosition(ccp(size.width * 0.5, size.height * 0.5 + 3))
    end
  end
  local extraStringList = taskData._extend._extra_string
  local isCheap = extraStringList and extraStringList[1] == "cheap"
  ui.pan_zhe:setVisible(isCheap)
  if isCheap then
    ed.setTexture(ui.pan_zhe, "UI/alpha/1080P/soulexchange/soulexchange_cheap_tf.png", true)
    ui.pan_zhe:setPosition(ccp(26, 168))
    ui.pan_zhe:setZOrder(2)
    local text = ed.createttf(T("\231\137\185\230\131\160"), 14)
    ed.setLabelColor(text, ed.toccc3(14901535))
    ed.setLabelStroke(text, ed.toccc3(16777215), 1.5)
    ui.pan_zhe:addChild(text)
    local size = ui.pan_zhe:getContentSize()
    text:setPosition(ccp(size.width * 0.5 - 4, size.height * 0.5 + 1))
  end
  ed.setLabelColor(ui.label_price, ccc3(ed.colorToStr(isRed and "#FF0005" or "#493C2F")))
  return container, ui
end

function class:pageUpDate(param)
  self.taskList = param._tasks
  self:refreshTokenAmount()
  self:refreshTask()
end

function class:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
  if isVisible then
    self:refreshTokenAmount()
    self:refreshTask()
  end
end

function class:onExchangeSoulPopClose()
  if not self.isVisible then
    return
  end
  self:refreshTokenAmount()
  self:refreshTask()
end

function class:onClickToken(id)
  ed.ui.packageDetailWin.create({id = id}):popWindow()
end

function class:addListenEvent()
  ed.UITool.registerBtn(self, "panel_eff_resolve", function()
    ed.ui.ExchangeSoulPopWin.create({
      soulExchangeGroup = self.soulExchangeGroup,
      closeCallBack = function()
        self:onExchangeSoulPopClose()
      end
    })
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "token_bg1", function()
    self:onClickToken(class.LOW_TOKEN_ID)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "token_bg2", function()
    self:onClickToken(class.HEIGHT_TOKEN_ID)
  end, {pressScale = 0.98})
end
