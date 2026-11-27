local exteriorShopMain = {
  pageType = {
    "Skin",
    "Avatar",
    "AvatarFrame"
  }
}

function exteriorShopMain.new(mainSelf)
  return setmetatable({
    mainSelf = mainSelf,
    passIndex = 1,
    dragListItems = {},
    allItemsKey = {},
    redIcons = {}
  }, {__index = exteriorShopMain}):create()
end

function exteriorShopMain:create()
  self.layer, self.listLay = self:createlayer()
  self.draglistShop = self:createDragList()
  self.mainSelf:listenEvent("MainBuildRedTagChange", function(buildType)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    if buildType == BuilddingType.Shop then
      for k, v in pairs(self.redIcons) do
        if ed.exteriorShopData.red[k] then
          v:setVisible(true)
        else
          v:setVisible(false)
        end
      end
    end
  end)
  ed.shop_network.cosmeticSendOpenPanel()
  self.mainSelf:listenEvent("cosmeticShopReplyShow", function(info)
    ed.pt(info)
    if info and info.isInit then
      self:refreshPage()
      if not self.btns then
        self.btns = self:createPageBut()
      end
    end
    self:refreshDragListItems()
  end)
  return self
end

function exteriorShopMain:createlayer()
  local layer = CCLayer:create()
  local size = self.mainSelf.ui.pan_item:getContentSize()
  layer:setContentSize(CCSizeMake(size.width, size.height))
  self.mainSelf.ui.pan_item:getParent():addChild(layer)
  layer:setPosition(self.mainSelf.ui.pan_item:getPosition())
  local listLay = CCLayer:create()
  listLay:setContentSize(CCSizeMake(size.width, size.height - 44))
  layer:addChild(listLay)
  return layer, listLay
end

function exteriorShopMain:createPageBut()
  local upRight = self.upRight or 100
  local height = self.layer:getContentSize().height
  local res = {
    "shop_cosmetic_tag_unselected_1.png",
    "shop_cosmetic_tag_unselected_2.png",
    "shop_cosmetic_tag_unselected_1.png"
  }
  local passRes = {
    "shop_cosmetic_tag_selected_1.png",
    "shop_cosmetic_tag_selected_2.png",
    "shop_cosmetic_tag_selected_1.png"
  }
  local button = {
    "\231\154\174\232\130\164",
    "\229\164\180\229\131\143",
    "\229\164\180\229\131\143\230\161\134"
  }
  for i, v in ipairs(button) do
    local bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/" .. res[i],
      pos = ccp(i * 154 - 167 + upRight, height - 30),
      parent = self.layer
    })
    bg.pass = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/" .. passRes[i],
      pos = ccp(76, 15.5),
      parent = bg
    })
    bg.red = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      pos = ccp(146, 25),
      parent = bg,
      notShow = not ed.exteriorShopData.red or not ed.exteriorShopData.red[self.pageType[i]]
    })
    ed.createLabelTools({
      txt = T(v),
      size = 17,
      anchor = ccp(0.5, 0.5),
      pos = ccp(76, 15.5),
      color = ccc3(ed.colorToStr("#ffeed0")),
      stroke = {
        ccc3(ed.colorToStr("#000000")),
        1
      },
      parent = bg
    })
    if i == 3 then
      bg:setFlipX(true)
      bg.pass:setFlipX(true)
    else
      ed.createSpriteTools({
        res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_tag_small.png",
        pos = ccp(i * 154 - 90 + upRight, height - 30),
        parent = self.layer
      })
    end
    bg.pass:setVisible(i == self.passIndex)
    self.redIcons[self.pageType[i]] = bg.red
    self.mainSelf:btRegisterButtonClick({
      button = bg,
      selected = bg.pass,
      pressScale = 0.95,
      key = "number" .. i,
      radioGroupName = "number",
      clickHandler = function()
        if self.passIndex ~= i then
          self.passIndex = i
          ed.exteriorShopData:setShopGoodsInfo(nil, true)
          self:refreshPage()
        end
      end,
      force = true
    })
  end
end

function exteriorShopMain:createDragList()
  local function ClickInFun(isRight)
    return function(x, y, passItem)
      if not self.newTouch then
        return
      end
      if passItem then
        passItem.layer:setScale(1)
      end
      if isRight then
        if passItem.data.isBuy then
          ed.showToast(T("\229\183\178\230\139\165\230\156\137"))
        elseif self.pageType[self.passIndex] == "Skin" then
          ed.ui.buyFashionShopBox.create(passItem.data):popWindow()
        else
          ed.ui.buyExteriorShopBox.create(passItem.data):popWindow()
        end
      end
    end
  end
  
  return ed.UITool.createDraglist(self.listLay, {
    doPressIn = function(x, y)
      local items = self.dragListItems[self.passIndex] or {}
      for i, v in ipairs(items) do
        if ed.containsPoint(v.layer, x, y) then
          v.layer:setScale(0.98)
          self.newTouch = true
          return v
        end
      end
    end,
    doClickIn = ClickInFun(true),
    cancelPressIn = ClickInFun(),
    cancelClickIn = ClickInFun(),
    priority = -200
  })
end

function exteriorShopMain:refreshPage()
  if self.draglistShop then
    self.draglistShop:clearList()
  end
  self.allItemsKey = {}
  local dragListItems = {}
  local size = self.listLay:getContentSize()
  local data = ed.exteriorShopData:getShopInfo()
  local itemSize = {
    {
      w = 170,
      h = 210,
      fun = "createShowItem"
    },
    {
      w = 170,
      h = 180,
      fun = "createAvatarItem"
    },
    {
      w = 170,
      h = 180,
      fun = "createAvatarFrameItem"
    }
  }
  local count = math.floor(size.width / itemSize[self.passIndex].w)
  local posx = size.width % itemSize[self.passIndex].w
  local Height = 0
  local i = 0
  for _, v in ipairs(data[self.pageType[self.passIndex]] or {}) do
    if i % count == 0 then
      Height = Height + itemSize[self.passIndex].h
    end
    local item = self[itemSize[self.passIndex].fun](v)
    self.draglistShop:addItem(item.layer, ccp(i % count * itemSize[self.passIndex].w + posx / 2 + itemSize[self.passIndex].w / 2, size.height - Height + itemSize[self.passIndex].h / 2 - 5))
    dragListItems[i + 1] = item
    self.allItemsKey[v["Goods ID"]] = item
    i = i + 1
    self.upRight = self.upRight or item.layer:getPositionX()
  end
  self.draglistShop:initListHeight(Height + 15)
  self.dragListItems[self.passIndex] = dragListItems
  if ed.exteriorShopData.red and ed.exteriorShopData.red[self.pageType[self.passIndex]] then
    ed.exteriorShopData.red[self.pageType[self.passIndex]] = false
    ed.exteriorShopData.redNum = ed.exteriorShopData.redNum - 1
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Shop)
    ed.shop_network.cosmeticSendViewFlag(self.passIndex)
  end
end

function exteriorShopMain:refreshDragListItems()
  local data = ed.exteriorShopData:getShopInfo()
  for _, v in ipairs(data[self.pageType[self.passIndex]] or {}) do
    if self.allItemsKey[v["Goods ID"]] and self.allItemsKey[v["Goods ID"]].data.isBuy ~= v.isBuy then
      self.allItemsKey[v["Goods ID"]].mask:setVisible(true)
      if self.allItemsKey[v["Goods ID"]].effLight then
        self.allItemsKey[v["Goods ID"]].effLight:setVisible(false)
        self.allItemsKey[v["Goods ID"]].newTag:setVisible(false)
      end
      self.allItemsKey[v["Goods ID"]].data.isBuy = true
    end
  end
end

function exteriorShopMain.createShowItem(data)
  local fashionId = ed.getDataTable("equip")[data["Reward Item ID"]]["Fashion ID"]
  local bg = ed.createSpriteTools({
    res = ed.getFashionFrameRes(fashionId, "fashionShopItemBg")
  })
  local card = ed.createSpriteTools({
    res = ed.getFashionFrameRes(fashionId, "show"),
    pos = ccp(81.5, 121.5),
    parent = bg
  })
  local effLight, newTag
  if data.New and not data.isBuy then
    local eff_Light = ed.createSpine("effect/eff_UI_CosmeticShop_New/eff_UI_CosmeticShop_New", 0.5)
    eff_Light:setAnimation(0, "Idle", true)
    eff_Light:setPosition(ccp(91.5, 84.5))
    bg:addChild(eff_Light)
    effLight, newTag = eff_Light, ed.createSpriteTools({
      res = "UI/alpha/1080P/newshop/new_tag.png",
      pos = ccp(144.5, 181.5),
      parent = bg,
      z = 9
    })
  end
  local Frame = ed.createSpriteTools({
    res = ed.getFashionFrameRes(fashionId, "FrameMini"),
    pos = ccp(81.5, 121.5),
    parent = bg
  })
  ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(ed.createSpriteTools({
    res = ed.getFashionFrameRes(fashionId, "qualityBg"),
    pos = ccp(81.5, 83.5),
    parent = bg
  }), ccp(28, 26), 16)
  local nameStr = ed.exteriorShopData.getFashionName(fashionId)
  if EDCurLanguage == "en" or EDCurLanguage == "ja" then
    nameStr = string.gsub(nameStr, " \194\183 ", "\n")
  end
  local name_label = ed.createLabelTools({
    txt = nameStr,
    size = 16,
    anchor = ccp(0.5, 0.5),
    pos = ccp(81.5, 46),
    color = ccc3(ed.colorToStr("#fffce7")),
    stroke = {
      ccc3(ed.colorToStr("#000000")),
      1
    },
    parent = bg
  })
  name_label:limitSizeByScale(140, 30)
  local posX = 0
  if data["Orange Price"] == 0 then
    posX = -40
  elseif data["Blue Price"] == 0 then
    posX = 40
  end
  if 0 < data["Orange Price"] then
    local icon = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png",
      pos = ccp(23 + posX, 17),
      parent = bg,
      scale = 0.8
    })
    local oPrice = ed.createLabelTools({
      txt = data["Orange Price"],
      size = 16,
      anchor = ccp(0, 0.5),
      pos = ccp(35 + posX, 16),
      color = ccc3(ed.colorToStr("#c37510")),
      parent = bg
    })
    if 0 < data["Orange Price Discount"] then
      oPrice:setString(data["Orange Price Discount"])
      ed.createLabelTools({
        txt = data["Orange Price"],
        size = 13,
        anchor = ccp(0.5, 0.5),
        pos = ccp(65 + posX, 16),
        color = ccc3(ed.colorToStr("#a99c94")),
        parent = bg
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/shop/shop_line_2.png",
        pos = ccp(65 + posX, 16),
        parent = bg,
        scale = 0.8
      })
    else
      icon:setPositionX(icon:getPositionX() + 7)
      oPrice:setPositionX(oPrice:getPositionX() + 7)
    end
  end
  if 0 < data["Blue Price"] then
    local icon = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png",
      pos = ccp(95 + posX, 17),
      parent = bg,
      scale = 0.8
    })
    local bPrice = ed.createLabelTools({
      txt = data["Blue Price"],
      size = 16,
      anchor = ccp(0, 0.5),
      pos = ccp(106 + posX, 16),
      color = ccc3(ed.colorToStr("#c37510")),
      parent = bg
    })
    if 0 < data["Blue Price Discount"] then
      bPrice:setString(data["Blue Price Discount"])
      ed.createLabelTools({
        txt = data["Blue Price"],
        size = 13,
        anchor = ccp(0.5, 0.5),
        pos = ccp(139 + posX, 16),
        color = ccc3(ed.colorToStr("#a99c94")),
        parent = bg
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/shop/shop_line_2.png",
        pos = ccp(139 + posX, 16),
        parent = bg,
        scale = 0.8
      })
    else
      icon:setPositionX(icon:getPositionX() + 7)
      bPrice:setPositionX(bPrice:getPositionX() + 7)
    end
  end
  if posX == 0 then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_line.png",
      pos = ccp(82, 16),
      parent = bg
    })
  end
  local mask = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_mask.png",
    rectMake = CCRectMake(4, 4, 30, 30),
    sizeMake = CCSizeMake(163, 203),
    pos = ccp(81.5, 101.5),
    parent = bg
  })
  local pass = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_own.png",
    pos = ccp(81.5, 121.5),
    parent = mask
  })
  pass:setRotation(-12)
  ed.createLabelTools({
    txt = T("\229\183\178\230\139\165\230\156\137"),
    size = 18,
    anchor = ccp(0.5, 0.5),
    pos = ccp(40.75, 23.75),
    color = ccc3(ed.colorToStr("#ffda69")),
    parent = pass
  })
  mask:setVisible(data.isBuy)
  return {
    layer = bg,
    data = ed.copyTable(data),
    mask = mask,
    effLight = effLight,
    newTag = newTag
  }
end

function exteriorShopMain.createAvatarItem(data)
  local quality = ed.readequip.quality(data["Reward Item ID"]) or 1
  local bg = ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/shop/shop_goods_bg_%d.png", quality)
  })
  local item = ed.createItemIcon({
    id = data["Reward Item ID"]
  })
  item:setPosition(82, 122.75)
  bg:addChild(item)
  item:setScale(1)
  local name = ed.createLabelTools({
    txt = ed.readequip.value(data["Reward Item ID"], "Name"),
    size = 16,
    anchor = ccp(0.5, 0.5),
    pos = ccp(82, 65),
    color = ccc3(ed.colorToStr("#fffce7")),
    stroke = {
      ccc3(ed.colorToStr("#000000")),
      1
    },
    parent = bg
  })
  name:setDimensions(CCSizeMake(bg:getContentSize().width * 0.9, 0))
  local posX = 5
  if data["Orange Price"] == 0 then
    posX = -35
  elseif data["Blue Price"] == 0 then
    posX = 45
  end
  if 0 < data["Orange Price"] then
    local icon = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_orange.png",
      pos = ccp(23 + posX, 23),
      parent = bg,
      scale = 0.8
    })
    local oPrice = ed.createLabelTools({
      txt = data["Orange Price"],
      size = 16,
      anchor = ccp(0, 0.5),
      pos = ccp(35 + posX, 22),
      color = ccc3(ed.colorToStr("#c37510")),
      parent = bg
    })
    if 0 < data["Orange Price Discount"] then
      oPrice:setString(data["Orange Price Discount"])
      ed.createLabelTools({
        txt = data["Orange Price"],
        size = 13,
        anchor = ccp(0.5, 0.5),
        pos = ccp(62 + posX, 22),
        color = ccc3(ed.colorToStr("#a99c94")),
        parent = bg
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/shop/shop_line_2.png",
        pos = ccp(62 + posX, 22),
        parent = bg,
        scale = 0.8
      })
    else
      icon:setPositionX(icon:getPositionX() + 7)
      oPrice:setPositionX(oPrice:getPositionX() + 7)
    end
  end
  if 0 < data["Blue Price"] then
    local icon = ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_currency_blue.png",
      pos = ccp(95 + posX, 23),
      parent = bg,
      scale = 0.8
    })
    local bPrice = ed.createLabelTools({
      txt = data["Blue Price"],
      size = 16,
      anchor = ccp(0, 0.5),
      pos = ccp(106 + posX, 22),
      color = ccc3(ed.colorToStr("#c37510")),
      parent = bg
    })
    if 0 < data["Blue Price Discount"] then
      bPrice:setString(data["Blue Price Discount"])
      ed.createLabelTools({
        txt = data["Blue Price"],
        size = 13,
        anchor = ccp(0.5, 0.5),
        pos = ccp(139 + posX, 22),
        color = ccc3(ed.colorToStr("#a99c94")),
        parent = bg
      })
      ed.createSpriteTools({
        res = "UI/alpha/1080P/shop/shop_line_2.png",
        pos = ccp(139 + posX, 22),
        parent = bg,
        scale = 0.8
      })
    else
      icon:setPositionX(icon:getPositionX() + 7)
      bPrice:setPositionX(bPrice:getPositionX() + 7)
    end
  end
  if posX == 5 then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_line.png",
      pos = ccp(82, 24),
      parent = bg
    })
  end
  local mask = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/shop_goods_soldout_shade.png",
    pos = ccp(82, 88),
    parent = bg
  })
  local pass = ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_own.png",
    pos = ccp(81.5, 121.5),
    parent = mask
  })
  pass:setRotation(-12)
  ed.createLabelTools({
    txt = T("\229\183\178\230\139\165\230\156\137"),
    size = 18,
    anchor = ccp(0.5, 0.5),
    pos = ccp(40.75, 23.75),
    color = ccc3(ed.colorToStr("#ffda69")),
    parent = pass
  })
  mask:setVisible(data.isBuy)
  return {
    layer = bg,
    data = ed.copyTable(data),
    mask = mask
  }
end

function exteriorShopMain.createAvatarFrameItem(data)
  return exteriorShopMain.createAvatarItem(data)
end

return exteriorShopMain
