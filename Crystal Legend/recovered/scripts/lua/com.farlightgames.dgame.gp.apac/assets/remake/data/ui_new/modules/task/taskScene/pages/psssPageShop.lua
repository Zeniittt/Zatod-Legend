local base = ed.ui.popwindow
local psssPageShopPop = newclass(base.mt)
ed.ui.psssPageShopPop = psssPageShopPop
psssPageShopPop.showRmb = 68
psssPageShopPop.showLevel = 30
psssPageShopPop.titStr = T("\232\180\173\228\185\176\230\136\152\232\175\129")
psssPageShopPop.shopStr = T("\232\180\173\228\185\176\230\136\152\232\175\129\239\188\140\233\154\143\231\157\128\231\173\137\231\186\167\230\143\144\229\141\135\232\167\163\233\148\129\230\181\183\233\135\143\229\165\150\229\138\177")
psssPageShopPop.toLvStr = T("\230\136\152\232\175\129\232\190\190\229\136\176%s\231\186\167\232\142\183\229\190\151\233\153\144\229\174\154\229\165\150\229\138\177")
ed.UITool.registViewOpenFunc("psssPageShopPop", function(param)
  ed.ui.psssPageShopPop.create(param or {}):popWindow()
end)

function psssPageShopPop.create(param)
  return setmetatable(base.create("psssPageShopPop"), psssPageShopPop.mt):init(param or {})
end

function psssPageShopPop:init(param)
  self:uiCreate()
  self:leftcardCreate()
  self:uiRefresh()
  self:registerBtnEvents()
  self:show({skipAnim = false})
  return self
end

function psssPageShopPop:uiCreate()
  self.frame, self.ui = ed.editorui(ed.uieditor.passTaskLayePop)
  self.container:addChild(self.frame)
  self.dataObj = ed.taskData:getPageDataObj("pass")
  self.showLevel = self.dataObj.showLevel or self.showLevel
  self.ui.label_str_title:setString(T(self.titStr))
  self.ui.label_ach_str:setString(T(self.shopStr))
  self.ui.label_item_str:setString(T(self.toLvStr, self.showLevel))
  self.ui.label_ach_str:limitWidthByScale(480)
  ed.setLabelStroke(self.ui.label_item_str, ccc3(ed.colorToStr("#2e161a")), 1)
  ed.setLabelStroke(self.ui.Label_482_Copy1, ccc3(ed.colorToStr("#2e161a")), 1)
  ed.setLabelStroke(self.ui.label_str_title, ccc3(ed.colorToStr("#2f2032")), 1)
  ed.setLabelStroke(self.ui.label_fashion_name_tips, ed.toccc3(4076838), 2)
  local thisCon = self.ui.item_pos_1:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.item_pos_1,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end
  }
  self.draglist_1 = ed.draglist.create(info)
  thisCon = self.ui.item_pos_2:getContentSize()
  info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.item_pos_2,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end
  }
  self.draglist_2 = ed.draglist.create(info)
  self.ui.label_btn_str:setString(ed.RechargeManager:getCostDisplayByCNYCost(self.showRmb))
end

function psssPageShopPop:uiRefresh()
  self.dataObj = ed.taskData:getPageDataObj("pass")
  if self.dataObj.passData and self.dataObj.passData.is_advanced and self.dataObj.passData.is_advanced == 1 then
    return ed.showToast(T("\229\183\178\232\180\173\228\185\176\230\136\152\232\175\129"))
  end
  local itemWidth = 76
  local items = self.dataObj:getAdvancedRewardToLevel(self.showLevel) or {}
  local posx = #items < 6 and self.draglist_1.cliprect.size.width / 2 - (#items + 1) * (itemWidth / 2) or 0 - itemWidth / 2
  for i, v in ipairs(items) do
    self.draglist_1:addItem(self:registerBtnEventsItems(ed.createItemIcon(v, false, 0.8), "item_1_" .. i, v, self.ui.item_pos_1), ccp(posx + i * itemWidth, itemWidth / 2))
  end
  self.draglist_1:initListWidth(#self.draglist_1.listItems * itemWidth)
  local fashionId, lv = 0, self.showLevel
  
  local function func()
    local items = self.dataObj:getAdvancedRewardToLevel(lv) or {}
    for i, v in ipairs(items) do
      if v.id and v.id > 0 then
        local id = ed.getDataTable("equip")[v.id]["Fashion ID"]
        if id then
        end
        fashionId = 0 < id and id or fashionId or fashionId
      end
    end
    if 0 < #items and fashionId <= 0 and 0 < lv then
      lv = lv - 1
      return func()
    else
      return fashionId
    end
  end
  
  self:leftCardRefresh(func())
  items = self.dataObj:getAdvancedReward(self.showLevel) or {}
  posx = #items < 6 and self.draglist_2.cliprect.size.width / 2 - (#items + 1) * (itemWidth / 2) or 0 - itemWidth / 2
  for i, v in ipairs(items) do
    self.draglist_2:addItem(self:registerBtnEventsItems(ed.createItemIcon(v, false, 0.8), "item_2_" .. i, v, self.ui.item_pos_2), ccp(posx + i * itemWidth, itemWidth / 2))
  end
  self.draglist_2:initListWidth(#self.draglist_2.listItems * itemWidth)
end

function psssPageShopPop:buyPass()
  if self.dataObj and self.dataObj.passData and self.dataObj.passData.is_advanced and self.dataObj.passData.is_advanced == 1 then
    return ed.showToast(T("\229\183\178\232\180\173\228\185\176\230\136\152\232\175\129"))
  end
  if ed.getServerTime() >= self.dataObj.passData.exp_end_time then
    ed.showConfirmDialog({
      text = T("\232\175\165\230\156\159\230\136\152\232\175\129\229\183\178\231\187\147\230\157\159\239\188\140\230\151\160\230\179\149\233\128\154\232\191\135\230\151\165\229\184\184\228\187\187\229\138\161\232\142\183\229\143\150\230\136\152\232\175\129\231\187\143\233\170\140\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\232\180\173\228\185\176\239\188\159"),
      rightHandler = function()
        local info = ed.RechargeManager:getDailyPassItem()
        if info then
          ed.taskData.isInRechargeing = true
          ed.RechargeManager:doRecharge(info)
        else
          ed.showToast(T("\232\180\173\228\185\176\233\161\185\228\184\141\229\173\152\229\156\168"))
        end
      end
    })
  elseif self.dataObj:getBuyLevelToTaskExp() then
    ed.showConfirmDialog({
      text = T("\232\180\173\228\185\176\230\156\172\230\156\159\230\136\152\232\175\129\229\144\142\239\188\140\229\137\169\228\189\153\230\151\182\233\151\180\229\134\133\228\188\154\229\173\152\229\156\168\230\151\160\230\179\149\233\128\154\232\191\135\230\175\143\230\151\165\228\187\187\229\138\161\229\141\135\231\186\167\232\135\179\230\187\161\231\186\167\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\232\180\173\228\185\176\230\136\152\232\175\129\239\188\159"),
      rightHandler = function()
        local info = ed.RechargeManager:getDailyPassItem()
        if info then
          ed.taskData.isInRechargeing = true
          ed.RechargeManager:doRecharge(info)
        else
          ed.showToast(T("\232\180\173\228\185\176\233\161\185\228\184\141\229\173\152\229\156\168"))
        end
      end
    })
  else
    local info = ed.RechargeManager:getDailyPassItem()
    if info then
      ed.taskData.isInRechargeing = true
      ed.RechargeManager:doRecharge(info)
    else
      ed.showToast(T("\232\180\173\228\185\176\233\161\185\228\184\141\229\173\152\229\156\168"))
    end
  end
end

function psssPageShopPop:registerBtnEventsItems(node, key, param, list_node)
  self:btRemoveMainTouchHandler({key = "items"})
  self:btRegisterButtonClick({
    button = node,
    key = key,
    radioGroupName = "items",
    param = param,
    clickHandler = function(param, x, y)
      if not ed.containsPoint(list_node, x, y) then
        return
      end
      if self.touch then
        ed.ui.packageDetailWin.create(param):popWindow()
      end
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  return node
end

function psssPageShopPop:registerBtnEvents()
  local index = 1
  
  local function func(node, click, press, normal)
    self:btRegisterButtonClick({
      button = node,
      key = "psssPageShopPop_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_close, function()
    self:destroy({skipAnim = false})
  end, 0.85, 0.9)
  func(self.ui.btn_shoping_img, function()
    self:buyPass()
    self:destroy({skipAnim = false})
  end)
  self:btRegisterOutClick({
    area = self.ui.panel_close_pos,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end

function psssPageShopPop:leftcardCreate()
  local size = self.ui.Panel_540:getContentSize()
  local clipLayer = CCLayer:create()
  clipLayer:setPosition(self.ui.fashion_card_img:getPosition())
  clipLayer:setClipRect(CCRectMake(size.width / 2 * -1, size.height / 2 * -1, size.width, size.height))
  self.ui.Panel_left:addChild(clipLayer)
  self.fashionCardLay = clipLayer
end

function psssPageShopPop:leftCardRefresh(fashionId)
  if not fashionId or fashionId == 0 then
    print("[---   find fashion_id nil !!!   ---]")
  end
  fashionId = fashionId and (0 < fashionId and fashionId or 331) or 331
  local name = ed.lookupDataTable("Fashion", "Name", fashionId)
  local label = ed.createttf(name, 22)
  label:setPosition(ccp(30, 100))
  label:setColor(ccc3(ed.colorToStr("#fffcd3")))
  self.ui.img_fashion_name_bg:addChild(label)
  ed.setLabelDimensions(label, CCSizeMake(22, 150))
  label:setStroke(ccc3(ed.colorToStr("#aa632e")), 1)
  label:setFontName(ed.fontBold)
  self:refreshCard(fashionId)
  self:refreshHeroFca(fashionId)
  if ed.isAreaZh() then
    ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "qualityBg"),
      pos = ccp(28, 28),
      parent = self.ui.img_fashion_name_bg
    }), ccp(28, 26), 21)
  else
    self.ui.img_fashion_name_bg:setVisible(false)
    local fashBg = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "fashionNameBg_Globe"),
      pos = ccp(110, 45),
      parent = self.ui.fashion_card_img,
      z = 999
    })
    local qualityLabel = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashionId, "qualityBg"),
      pos = ccp(22, 22),
      parent = fashBg
    }), ccp(28, 26), 18)
    qualityLabel:limitWidthByScale(45)
    local name = ed.lookupDataTable("Fashion", "Name", fashionId)
    local label = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashionId))(fashBg, ccp(110, 22), 19)
    label:setString(name)
    ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
  end
end

function psssPageShopPop:refreshCard(fashion_id)
  local res = ed.lookupDataTable("Fashion", "Art Switch", fashion_id)
  local cardBg
  if res then
    cardBg = ed.createSprite(res)
    self.fashionCardLay:addChild(cardBg)
  end
  local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashion_id)
  if fashion_effect_res and fashion_id == 13 and not ed.isAreaZhCn() then
    fashion_effect_res = fashion_effect_res .. "_globe"
  end
  local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashion_id)
  local size = cardBg:getContentSize()
  if fashion_spine_res and ed.isSupportSpine() then
    local spine = ed.createSpine("effect/" .. fashion_spine_res .. "/" .. fashion_spine_res, size.height / 928)
    spine:setAnimation(0, "Idle", true)
    spine:setPosition(-size.width / 2, -size.height / 2)
    self.fashionCardLay:addChild(spine, 5)
  elseif fashion_effect_res then
    local effect_fca = ed.createFcaActor(fashion_effect_res)
    effect_fca:setLoop(true)
    effect_fca:setAction("Loop")
    self:addFca(effect_fca)
    self.fashionCardLay:addChild(effect_fca, 5)
  end
  local fashion_plist_res = ed.lookupDataTable("Fashion", "Plist", fashion_id)
  if fashion_plist_res then
    local particle = CCParticleSystemQuad:create("UI/particle/" .. fashion_plist_res)
    self.fashionCardLay:addChild(particle, 6)
  end
end

function psssPageShopPop:refreshHeroFca(fashion_id)
  local puppet_id = ed.getDataTable("Fashion")[fashion_id].Puppet
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local actor = ed.createFcaActor(info.Resource, 1.5)
  local comps = info["Change Components"]
  if comps then
    for i = 1, #comps, 2 do
      actor:setComponent(comps[i], comps[i + 1])
    end
  end
  actor:setAction("Idle")
  actor:setLoop(true)
  actor:update(0)
  self.ui.Panel_left:addChild(actor, 99)
  self:addFca(actor)
  actor:setPosition(320, 55)
end
