local base = ed.ui.commonscene
local pirateshopScene = newclass(base.mt)
ed.ui.pirateshopScene = pirateshopScene

function pirateshopScene.create(param)
  return setmetatable(base.create("pirateshopScene", {noBottomButton = true}), pirateshopScene.mt):init(param)
end

function pirateshopScene:init(param)
  self:initUI()
  self:registerEvents()
  self:refreshTask(param)
  self:createList(param.goods)
  return self
end

function pirateshopScene:initUI()
  local ws = ed.display.designSize
  local hw = ed.display.halfFixedWidth
  local hh = ed.display.halfFixedHeight
  self.container, self.ui = ed.editorui(ed.uieditor.pirateshopScene)
  self.mainLayer:addChild(self.container)
  self.ui.title = ed.createSpriteTools({
    res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
    pos = ccp(210 - hw, ws.height - 37 + hh),
    parent = self.mainLayer
  })
  local title_bg = ed.UITool.createSceneTitle(T("\230\181\183\231\155\151\229\174\157\229\186\147"), self.ui.title, {
    position = ccp(9, 19),
    maxWidth = 190
  })
  self.ui.rule = ed.createSpriteTools({
    res = "UI/alpha/1080P/summon/rule_btn.png",
    pos = ccp(170, 18),
    parent = self.ui.title,
    scale = 0.85
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/rule_butt.png",
    pos = ccp(15.75, 15.75),
    parent = self.ui.rule
  })
  self.ui.maxtxt = ed.createSpriteTools({
    res = "UI/alpha/1080P/pirateshop/full_mask.png",
    pos = ccp(248, 36),
    parent = self.ui.Panel_333,
    notShow = true
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/pirateshop/lock.png",
    pos = ccp(38, 12),
    parent = self.ui.maxtxt,
    scale = 0.8
  })
  ed.right2(self.ui.rule, title_bg)
  local cfg = ed.getDataTable("PirateShopConfig")
  local itemId = cfg["Refresh Item"].Value[1]
  local item = ed.taskItemModule.new(self, {
    id = itemId,
    type = "item",
    amount = 1
  }, nil, 9, false, false, true)
  item.icon:setPosition(248, 36)
  self.ui.Panel_333:addChild(item.icon)
  item.icon:setScale(0.6)
  item:refresh(0)
  self.ui.itemIcon = item.icon
  self.taskItem = item
  ed.setLabelStroke(self.ui.Label_341, ed.toccc3(5521188), 2)
  ed.setLabelStroke(self.ui.Label_2398, ed.toccc3(9261832), 2)
  ed.setLabelStroke(self.ui.Label_336, ed.toccc3(1709587), 2)
  ed.setLabelStroke(self.ui.Label_347, ed.toccc3(3418659), 2)
  ed.layout.layoutWithMagin(self.ui.map_count_bg, {right = 230, top = 10})
  ed.setLabelStroke(self.ui.Label_map_count, ed.toccc3(3284227), 2)
  self:createProgress()
  self:createSpine()
  self:setBackButton(function()
    FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.PirateShop)
  end)
  self:setBackground()
end

function pirateshopScene:createProgress()
  self.ui.ImageView_2404:setVisible(false)
  local progress = CCProgressTimer:create(self.ui.ImageView_2404)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  self.ui.Panel_2399:addChild(progress)
  progress:setPosition(self.ui.ImageView_2404:getPosition())
  self.progress = progress
  self.progress:setPercentage(0)
end

function pirateshopScene:createSpine()
  local spine = ed.createSpine("effect/eff_UI_pirateshop_Coco/eff_UI_pirateshop_Coco", 0.3, function(event, spine)
    if event == "complete" then
      self.ui.spine:setAnimation(1, "Idle", true)
    end
  end)
  spine:setAnimation(1, "Idle", true)
  spine:setPosition(ccp(245, 110))
  self.ui.ImageView_327:addChild(spine, 3)
  if ed.display.winSize.width <= 960 then
    self.ui.ImageView_327:setPositionX(505)
  end
  self.ui.spine = spine
  self.ui.Label_bubble:setOpacity(0)
  self.ui.bubble_bg_img:setOpacity(0)
end

function pirateshopScene:playSpineTalk(random)
  local random = random or math.random(1, 2)
  local actionList = {"Idle3", "Idle2"}
  self.ui.spine:setAnimation(1, actionList[random], false)
  local talk = {
    T("\230\144\158\230\157\165\232\191\153\228\186\155\229\165\189\228\184\156\232\165\191\239\188\140\229\143\175\228\184\141\229\174\185\230\152\147\239\188\129"),
    T("\229\176\143\229\173\144\239\188\140\228\189\160\231\154\132\232\151\143\229\174\157\229\155\190\230\136\145\230\178\161\230\148\182\228\186\134\239\188\129")
  }
  self.ui.Label_bubble:setString(talk[random])
  local size = self.ui.Label_bubble:getContentSize()
  size.width = size.width < 150 and 150 or size.width
  self.ui.bubble_bg_img:setContentSize(CCSizeMake(size.width + 60, 52))
  local uiname = {
    "Label_bubble",
    "bubble_bg_img"
  }
  for _, name in ipairs(uiname) do
    self.ui[name]:stopAllActions()
    self.ui[name]:runAction(CCSequence:create(ccArrayMake(CCFadeTo:create(0.3, 255), CCDelayTime:create(4), CCFadeTo:create(0.5, 0))))
  end
end

function pirateshopScene:registerEvents()
  ed.UITool.registerBtn(self, "Panel_spine", function()
    self:playSpineTalk()
  end, {pressScale = 0.96})
  ed.UITool.registerBtn(self, "rule", function()
    ed.ui.commonRulePop.create({
      title = T("\230\181\183\231\155\151\229\174\157\229\186\147"),
      txt = ed.pirateshopManager.ruleTxt
    }):popWindow()
  end, {pressScale = 0.96})
  ed.UITool.registerBtn(self, "ImageView_343", function()
    if self.canRrefresh then
      ed.showConfirmDialog({
        mode = "simple",
        autoText = T("\230\152\175\229\144\166\232\166\129\232\138\177\232\180\185 <sprite src=UI/alpha/1080P/pirateshop/map.png>1 \229\136\183\230\150\176\232\180\167\231\137\169\239\188\159"),
        rightHandler = function()
          ed.pirateshopNetwork.sendRefreshShop()
        end
      })
    else
      ed.showToast(T("\232\151\143\229\174\157\229\155\190\228\184\141\232\182\179"))
    end
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "itemIcon", function()
    if self.taskState == 1 then
      if self.canTakeMap then
        ed.pirateshopNetwork.sendTakeMap()
      else
        ed.showToast(T("\232\151\143\229\174\157\229\155\190\232\182\133\228\184\138\233\153\144"))
      end
    else
      local cfg = ed.getDataTable("PirateShopConfig")
      local itemId = cfg["Refresh Item"].Value[1]
      ed.UITool.openView("packageDetail", {
        id = itemId,
        type = "item",
        amount = 1
      })
    end
  end, {pressScale = 0.55, normalScale = 0.6})
  self:listenEvent("pirateshopSceneRefreshBuyGoods", function(data)
    self:refreshGood(data._index)
    self:playSpineTalk(1)
  end)
  self:listenEvent("pirateshopSceneRefreshGoods", function(goods)
    self:refreshGoods(goods)
    self:playSpineTalk(2)
  end)
  self:listenEvent("pirateshopSceneRefreshMap", function(data)
    self:refreshTaskMapCount(data)
  end)
  self:listenEvent("activityCrossDays", function()
    ed.UITool.openView("pirateshopScene")
  end)
end

function pirateshopScene:createList(goods)
  local thisCon = self.ui.Panel_332:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_332,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  self:refreshGoods(goods)
end

function pirateshopScene:refreshTask(data)
  local cfg = ed.getDataTable("PirateShopConfig")
  local vitality = cfg["Target Vitality"].Value[1]
  local free = cfg["Max free map"].Value[1]
  local itemId = cfg["Refresh Item"].Value[1]
  self.progress:setPercentage(data.vit_use / vitality * 100)
  self.ui.Label_2398:setString(T(data.vit_use))
  self.ui.Label_336:setString(T("/%d", vitality))
  local state = 0
  if data.reward_flag == 1 then
    state = 2
  elseif vitality <= data.vit_use then
    state = 1
  end
  local count = ed.player:getEquipAmount(itemId) or 0
  if 5 <= count then
    state = 0
  end
  self.taskState = state
  self.taskItem:refresh(state)
  ed.pirateshopManager.redShow = state == 1
  self:refreshTaskMapCount()
end

function pirateshopScene:refreshTaskMapCount(data)
  if data and data.free then
    self.taskState = 2
    self.taskItem:refresh(2)
    ed.pirateshopManager.redShow = false
  end
  local cfg = ed.getDataTable("PirateShopConfig")
  local itemId = cfg["Refresh Item"].Value[1]
  local free = cfg["Max free map"].Value[1]
  local count = ed.player:getEquipAmount(itemId) or 0
  self.ui.Label_347:setString(T("\229\136\183\230\150\176   %d", 1))
  self.ui.Label_347:limitWidthByScale(75)
  self.canTakeMap = free > count
  self.canRrefresh = 0 < count
  ed.setLabelColor(self.ui.Label_347, self.canRrefresh and ccc3(255, 252, 231) or ccc3(247, 152, 127))
  self.ui.Label_map_count:setString(T("%d/5", count))
  if self.taskState == 2 then
    self.ui.ImageView_2400:setVisible(true)
    self.ui.ImageView_334:setVisible(false)
    self.ui.Panel_2399:setVisible(false)
    self.ui.maxtxt:setVisible(false)
  elseif not self.canTakeMap then
    self.ui.ImageView_2395:setVisible(true)
    self.ui.ImageView_2400:setVisible(false)
    self.ui.ImageView_334:setVisible(false)
    self.ui.maxtxt:setVisible(true)
  else
    self.ui.ImageView_2395:setVisible(false)
    self.ui.ImageView_2400:setVisible(false)
    self.ui.ImageView_334:setVisible(true)
    self.ui.maxtxt:setVisible(false)
  end
end

function pirateshopScene:refreshGood(index)
  for i, v in ipairs(self.items) do
    if v.param.index == index then
      v:setStatus(1)
    end
  end
end

function pirateshopScene:refreshGoods(goods)
  local thisCon = self.ui.Panel_332:getContentSize()
  self.goods = goods
  self.items = {}
  self.dragList:clearList()
  local width, heigh = 156, 190
  local posY = thisCon.height
  for i, v in ipairs(self.goods) do
    local posX = (i % 4 == 0 and 4 or i % 4) * width - width / 2
    local item = self.itemModule.create(self, v, i)
    self.dragList:addItem(item.ui.Layer, ccp(posX, posY))
    posY = i % 4 == 0 and posY - heigh or posY
    table.insert(self.items, item)
  end
  self.dragList:initListHeight(math.ceil(#self.goods / 4) * heigh + 10)
end

local itemModule = {}

function itemModule.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemModule})
  this:init(param)
  return this
end

itemModule.discountCfg = {
  {
    res = "discount1",
    label = {
      startColor = "#efff99",
      endColor = "#ffffff",
      strokeColor = "#bf2f08",
      pos = ccp(37, 25),
      size = 18
    },
    countSize = 21,
    countPos = ccp(21, 24)
  },
  {
    res = "discount2",
    label = {
      startColor = "#fffbb1",
      endColor = "#fffdec",
      strokeColor = "#a85c03",
      pos = ccp(37, 25),
      size = 18
    },
    countSize = 18,
    countPos = ccp(21, 24)
  },
  {
    res = "discount3",
    label = {
      startColor = "#ffdc52",
      endColor = "#ffffff",
      strokeColor = "#8717d5",
      pos = ccp(37, 25),
      size = 18
    },
    countSize = 17,
    countPos = ccp(21, 24)
  }
}

function itemModule:createDiscount(discount, bg, status)
  local cfg = discount < 4 and 1 or discount < 7 and 2 or 3
  cfg = self.discountCfg[cfg]
  local res = string.format("UI/alpha/1080P/pirateshop/%s.png", cfg.res)
  local zheBg = ed.createSpriteTools({
    res = res,
    pos = ccp(13, 157),
    parent = bg,
    z = 99
  })
  local res = string.format("UI/alpha/1080P/pirateshop/%s_dark.png", cfg.res)
  local size = zheBg:getContentSize()
  self.discountMask = ed.createSpriteTools({
    res = res,
    pos = ccp(size.width / 2, size.height / 2),
    parent = zheBg,
    notShow = status ~= 1
  })
  local str = discount - 10 .. "0%"
  local label = ed.ui.gradientLabel.create({
    text = str,
    fontSize = cfg.countSize,
    startColor = ccc3(ed.colorToStr(cfg.label.startColor)),
    endColor = ccc3(ed.colorToStr(cfg.label.endColor)),
    strokeColor = ccc3(ed.colorToStr(cfg.label.strokeColor)),
    strokeSize = 3
  })
  label.node:setPosition(cfg.countPos)
  zheBg:addChild(label.node, 9)
  label.node:setRotation(-10)
  self.discountLabelMask = label.node
  self.discountLabelMask:setOpacity(status == 1 and 70 or 255)
end

function itemModule:init(param)
  local Layer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0)
  })
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/pirateshop/item_bg.png",
    parent = Layer,
    pos = ccp(0, -99)
  })
  local icon = ed.createItemIcon({
    id = param.itemID,
    type = "item",
    amount = param.amount
  })
  icon:setPosition(63.75, 117)
  icon:setScale(0.95)
  bg:addChild(icon)
  local red = ed.createSpriteTools({
    res = "UI/alpha/1080P/pirateshop/redpoint.png",
    pos = ccp(120, 162),
    parent = bg,
    notShow = not param.red
  })
  local name = ed.readequip.value(param.itemID, "Name")
  local nameTxt = ed.createLabelTools({
    txt = name,
    size = 16,
    pos = ccp(63.75, 65),
    color = ed.toccc3(16771782),
    parent = bg,
    stroke = {
      ed.toccc3(4072466),
      2
    }
  })
  nameTxt:limitSizeByScale(128, 35)
  local scale = 1
  if param.price_value > 9999 then
    scale = 0.75
  elseif param.price_value > 99999 then
    scale = 0.65
  end
  local priceScale = 1
  if param.price > 999 then
    priceScale = 0.85
  elseif 9999 < param.price then
    priceScale = 0.75
  end
  ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/icon/%s.png", param.price_type),
    pos = ccp(33, 30),
    parent = bg
  })
  local discount = param.discount
  local zhe = discount ~= 0
  if zhe then
    ed.createLabelTools({
      txt = param.price,
      size = 14,
      pos = ccp(97, 30),
      color = ed.toccc3(9796699),
      parent = bg
    }):setScale(priceScale)
    ed.createSpriteTools({
      res = "UI/alpha/1080P/pirateshop/line_discount.png",
      pos = ccp(97, 30),
      parent = bg
    })
    self:createDiscount(discount, bg, param.status)
  end
  self.price = param.price_value
  ed.createLabelTools({
    txt = self.price,
    size = 18,
    pos = ccp(63, 30),
    color = ed.toccc3(7357730),
    parent = bg
  }):setScale(scale)
  local mask = ed.createSpriteTools({
    res = "UI/alpha/1080P/pirateshop/item_mask.png",
    parent = bg,
    pos = ccp(63.75, 93.5),
    notShow = param.status == 0
  })
  local soldout_img = ed.createSpriteTools({
    res = "UI/alpha/1080P/newshop/over_tf.png",
    parent = mask,
    pos = ccp(63.75, 93.5)
  })
  local soldout_label = ed.createLabelTools({
    txt = T("\229\148\174\231\189\132"),
    size = 20,
    font = ed.fontBold,
    color = ccc3(255, 94, 94),
    stroke = {
      ed.toccc3(2826261),
      1.5
    },
    parent = soldout_img
  })
  soldout_label:limitWidthByScale(56)
  ed.layout.centerInParent(soldout_label)
  soldout_img:setRotation(-14)
  self.ui = {
    Layer = Layer,
    bg = bg,
    mask = mask,
    red = red
  }
  if param.status == 1 then
    self.ui.red:setVisible(false)
  end
end

function itemModule:setStatus(status)
  self.param.status = status
  self.ui.mask:setVisible(status == 1)
  if status == 1 then
    self.ui.red:setVisible(false)
  end
  if self.discountMask then
    self.discountMask:setVisible(status == 1)
    self.discountLabelMask:setOpacity(status == 1 and 70 or 255)
  end
end

pirateshopScene.itemModule = itemModule

function pirateshopScene:doPressInList()
  local function handler(x, y)
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.bg, x, y) then
        v.ui.bg:setScale(0.95)
        
        return {
          icon = v.ui.bg,
          fun = function(param)
            if v.ui.mask:isVisible() then
              return ed.showToast(T("\229\183\178\232\180\173\228\185\176"))
            end
            ed.ui.pirateshopGoodsPop.create({
              data = param,
              price = v.price
            }):popWindow()
          end,
          param = v.param
        }
      end
    end
  end
  
  return handler
end

function pirateshopScene:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function pirateshopScene:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
