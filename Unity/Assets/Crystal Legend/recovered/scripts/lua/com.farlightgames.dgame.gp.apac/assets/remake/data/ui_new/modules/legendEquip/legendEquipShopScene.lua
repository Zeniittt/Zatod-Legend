local base = ed.ui.commonscene
local legendEquipShopScene = newclass(base.mt)
ed.ui.legendEquipShopScene = legendEquipShopScene
legendEquipShopScene.scope = {}
ed.UITool.registViewOpenFunc("legendEquipShopScene", function()
  ed.legendEquipNet.sendOpenShop()
  CloseScope(ed.ui.legendEquipShopScene.scope)
  ListenEventOnce("FireForgeOpenShop", function(param)
    local scene = ed.ui.legendEquipShopScene.create(param)
    ed.pushScene(scene)
  end, ed.ui.legendEquipShopScene.scope)
end)

function legendEquipShopScene.create(param)
  return setmetatable(base.create("legendEquipShopScene", {noBottomButton = true}), legendEquipShopScene.mt):init(param)
end

function legendEquipShopScene:init(param)
  self.goods = param.goods or {}
  self.refreshTime = param.refreshTime or 0
  self.isShowNew = ed.legendEquipTool.getIsShowLegendEquipShopNew()
  self:initUI()
  self:registerEvents()
  self:createList()
  return self
end

function legendEquipShopScene:initUI()
  local ws = ed.display.designSize
  local hw = ed.display.halfFixedWidth
  local hh = ed.display.halfFixedHeight
  local ui = {}
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/shop/background.png",
    pos = ccp(ws.width / 2, ws.height / 2),
    parent = self.mainLayer
  })
  ui.title = ed.createSpriteTools({
    res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
    pos = ccp(210 - hw, ws.height - 37 + hh),
    parent = self.mainLayer
  })
  ed.UITool.createSceneTitle(T("\231\134\148\231\130\137\229\149\134\229\186\151"), ui.title, {
    position = ccp(9, 19)
  })
  ui.rule = ed.createSpriteTools({
    res = "UI/alpha/1080P/summon/rule_btn.png",
    pos = ccp(170, 18),
    parent = ui.title,
    scale = 0.85
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/rule_butt.png",
    pos = ccp(15.75, 15.75),
    parent = ui.rule
  })
  ui.close = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt_bj.png",
    pos = ccp(57 - hw, ws.height - 37 + hh),
    parent = self.mainLayer,
    scale = 0.8
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt.png",
    pos = ccp(25, 27),
    parent = ui.close
  })
  ui.timeBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/fireforge/shop/updatetime_board.png",
    pos = ccp(ws.width / 2, ws.height - 37 + hh),
    parent = self.mainLayer
  })
  local tiem = ed.time2dhm(self.refreshTime - ed.getServerTime())
  ui.timeTxt = ed.createLabelTools({
    txt = T("%s\229\144\142\228\184\138\230\158\182\230\150\176\229\149\134\229\147\129", tiem),
    size = 17,
    pos = ccp(162.25, 14.25),
    color = ed.toccc3(16773591),
    parent = ui.timeBg,
    stroke = {
      ed.toccc3(10749997),
      1
    }
  })
  ui.listLayer = ed.createCCLayer({
    pos = ccp(50 - hw, -hh),
    sizeMake = CCSizeMake(ws.width - 100 + hw * 2, ws.height + hh * 2 - 70),
    parent = self.mainLayer
  })
  ed.storage.setValue(ed.getRoleKey("legendShopNextRefreshTime"), self.refreshTime)
  self.resourceBox.container:setPositionY(self.resourceBox.container:getPositionY() - 10)
  self.ui = ui
end

function legendEquipShopScene:registerEvents()
  ed.UITool.registerBtn(self, "close", function()
    ed.popScene()
  end)
  ed.UITool.registerBtn(self, "rule", function()
    ed.ui.commonRulePop.create({
      title = T("\231\134\148\231\130\137\229\149\134\229\186\151"),
      txt = ed.legendEquipDefine.SHOP_RULE_TEXT
    }):popWindow()
  end)
  self:listenEvent("legendEquipBuyGoods", function(data)
    self:refreshGoods(data._good or {})
  end)
  self:listenEvent("activityCrossDays", function()
    ed.legendEquipNet.sendOpenShop()
  end)
end

function legendEquipShopScene:createList()
  local thisCon = self.ui.listLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.listLayer,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  local wid = thisCon.width
  local count = math.floor(wid / 170)
  local posx = wid % 170
  self.items = {}
  self.goodsKey = {}
  self.dragList:clearList()
  local Height = 0
  table.sort(self.goods, ed.cmpSort({
    {
      getValue = function(good)
        local groupId = good._group_id
        local groupType = ed.getDataTable("LegendEquipShop")[groupId]["Group Type"]
        if groupType == "ShortTime" then
          return 0
        elseif groupType == "Normal" then
          return 1
        else
          return 2
        end
      end
    },
    {
      getValue = function(good)
        local goodCfg = ed.getDataTable("LegendEquipGoods")[good._index]
        return goodCfg["Order ID"] == 0 and 9999 or goodCfg["Order ID"]
      end
    },
    {key = "_index"}
  }))
  for i, v in ipairs(self.goods) do
    if (i - 1) % count == 0 then
      Height = Height + 184
    end
    local item = self.itemModule.create(self, v, i)
    self.dragList:addItem(item.ui.Layer, ccp((i - 1) % count * 170 + posx / 2 + 85, thisCon.height - Height - 15 + 92))
    table.insert(self.items, item)
    self.goodsKey[v._group_id] = self.goodsKey[v._group_id] or {}
    self.goodsKey[v._group_id][v._index] = i
  end
  self.dragList:initListHeight(Height + 18)
end

function legendEquipShopScene:refreshGoods(data)
  local inedx = self.goodsKey[data._group_id][data._index]
  self.items[inedx]:update(data)
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

function itemModule:init(param)
  local item = param._rewards[1]
  local Layer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0)
  })
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/shop_goods_bg_6.png",
    pos = ccp(0, 0),
    parent = Layer
  })
  local name = ed.readequip.value(item._id, "Name")
  if item._type == "legend_equip" then
    name = ed.getDataTable("LegendEquip")[item._id]["Equip Name"]
  end
  ed.createLabelTools({
    txt = name,
    size = 17,
    pos = ccp(82, 71),
    color = ccc3(253, 241, 214),
    parent = bg,
    stroke = {
      ccc3(29, 19, 8),
      1
    }
  })
  local count = param._max_buy_times - param._cur_buy_times
  local legendEquipGoodsCfg = ed.getDataTable("LegendEquipGoods")[param._index]
  local costResType = legendEquipGoodsCfg["Goods Buy Type"]
  local config = ed.ui.configs.resBar.getResBarConfig(string.lower(costResType))
  local res = "UI/alpha/1080P/fireforge/art3.png"
  if config then
    res = config.smallIcon
  end
  local countTxt = ed.createLabelTools({
    txt = T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", count),
    size = 13,
    pos = ccp(82, 52),
    color = ed.toccc3(16504716),
    parent = bg,
    stroke = {
      ed.toccc3(2565412),
      1
    }
  })
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = T("<sprite src=%s scale=0.7><lable color=ccc3(189,116,0)>%d</lable>", res, legendEquipGoodsCfg["Goods Price"]),
    fontSize = 16,
    lineSpacing = 4,
    align = "CENTER",
    strokeColor = ccc3(244, 234, 207),
    strokeSize = 2
  })
  autoText.node:setPosition(-122, 23)
  bg:addChild(autoText.node)
  local icon = ed.createItemIcon({
    id = item._id,
    type = item._type,
    amount = item._amount
  })
  icon:setPosition(82, 122)
  icon:setScale(0.9)
  bg:addChild(icon)
  local mask = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/shop_goods_soldout_shade.png",
    pos = ccp(82, 88),
    parent = bg
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/shop_goods_soldout_icon.png",
    pos = ccp(81.5, 101.5),
    parent = mask
  })
  mask:setVisible(count <= 0)
  local newTag
  if param.groupType == "Forever" then
    local forever = ed.createSpriteTools({
      res = "UI/alpha/1080P/newshop/foreverlimit_bg.png",
      pos = ccp(42, 172),
      parent = bg
    })
    ed.createLabelTools({
      txt = T("\231\187\136\232\186\171\233\153\144\232\180\173"),
      size = 14,
      pos = ccp(44, 13),
      color = ccc3(207, 77, 0),
      parent = forever,
      stroke = {
        ccc3(255, 255, 255),
        2
      },
      font = ed.fontBold
    })
  elseif param.groupType == "ShortTime" then
    local shortTime = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/shop_count_down_bg.png",
      pos = ccp(82, 172),
      parent = bg
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/shop_count_down.png",
      pos = ccp(5, 10.75),
      parent = shortTime
    })
    local tiem = ed.time2dhmOnly(ed.dateStringToServerTime(param.endTime) - ed.getServerTime())
    ed.createLabelTools({
      txt = T("%s\229\144\142\228\184\139\230\158\182", tiem),
      size = 14,
      pos = ccp(56.75, 10.75),
      color = ccc3(255, 246, 0),
      parent = shortTime,
      stroke = {
        ed.toccc3(2565412),
        1
      }
    })
    ed.createSpriteTools({
      res = "UI/alpha/1080P/fireforge/shop/new.png",
      pos = ccp(7, 72),
      parent = icon
    })
  elseif param.weekSign == 1 then
    local forever = ed.createSpriteTools({
      res = "UI/alpha/1080P/fireforge/shop/weekbuy.png",
      pos = ccp(42, 172),
      parent = bg
    })
    local onlyTag = ed.ui.gradientLabel.create({
      text = T("\230\156\172\229\145\168\233\153\144\229\174\154"),
      fontSize = 15,
      startColor = ed.toccc3(16445028),
      endColor = ed.toccc3(16449508),
      strokeColor = ed.toccc3(8270762),
      strokeSize = 2
    })
    onlyTag.node:setPosition(44, 13)
    forever:addChild(onlyTag.node)
  else
    newTag = ed.createSpriteTools({
      res = "UI/alpha/1080P/summon/hero_new_tag.png",
      pos = ccp(17, 174),
      parent = bg,
      notShow = not self.mainSelf.isShowNew
    })
  end
  self.ui = {
    Layer = Layer,
    bg = bg,
    countTxt = countTxt,
    mask = mask,
    newTag = newTag
  }
  self:update(param)
end

function itemModule:update(param)
  self.param = param
  local count = param._max_buy_times - param._cur_buy_times
  self.ui.countTxt:setString(T("\229\137\169\228\189\153\230\149\176\233\135\143:%d", count))
  self.ui.mask:setVisible(count <= 0)
end

legendEquipShopScene.itemModule = itemModule

function legendEquipShopScene:doPressInList()
  local function handler(x, y)
    if ed.containsPoint(self.ui.btn, x, y) then
      return
    end
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.bg, x, y) then
        v.ui.bg:setScale(0.95)
        return {
          icon = v.ui.bg,
          fun = function(param)
            local item = param._rewards[1]
            local count = param._max_buy_times - param._cur_buy_times
            local groupId = param._group_id
            local index = param._index
            if count <= 0 then
              return ed.showToast(T("\229\183\178\229\148\174\231\189\132"))
            end
            if v.ui.newTag then
              v.ui.newTag:setVisible(false)
            end
            local legendEquipGoodsCfg = ed.getDataTable("LegendEquipGoods")[index]
            local buyResourceBox = ed.ui.buyResourceBox.create({
              buyLimitNum = count,
              defaultBuyNum = 1,
              goodsResType = ed.ui.configs.resType.getResType(item._type),
              goodsId = item._id,
              costResType = legendEquipGoodsCfg["Goods Buy Type"],
              costId = legendEquipGoodsCfg["Goods Buy ID"],
              costIconConfig = {
                smallIcon = "UI/alpha/1080P/fireforge/art3.png"
              },
              item = {
                id = item._id,
                type = item._type,
                count = item._amount
              },
              price = legendEquipGoodsCfg["Goods Price"],
              buyAction = function(num)
                ed.showToast(T("\232\180\173\228\185\176"))
                ed.legendEquipNet.sendBuyGoods(param._group_id, param._index, num, {
                  costType = legendEquipGoodsCfg["Goods Buy Type"],
                  price = legendEquipGoodsCfg["Goods Price"],
                  count = num,
                  item = item
                })
              end
            })
            buyResourceBox:popWindow()
            buyResourceBox.ui.text_buy_num_limit:setVisible(false)
          end,
          param = v.param
        }
      end
    end
  end
  
  return handler
end

function legendEquipShopScene:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function legendEquipShopScene:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
