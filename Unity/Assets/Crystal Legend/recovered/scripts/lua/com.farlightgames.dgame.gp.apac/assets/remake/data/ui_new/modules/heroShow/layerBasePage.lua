local layerBase = {}
ed.ui.heroShowPop.heroMode.layerBase = layerBase

function layerBase.create(popSelf, param)
  local container, ui = ed.editorui(ed.uieditor.herodetailNormal)
  ui.bg_legend_equip:setVisible(false)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    container = container,
    ui = ui
  }, {__index = layerBase}):init()
end

function layerBase.getEquipIdFromTb(hid, slot, rank)
  local slotStr = string.format("Equip%d ID", slot)
  return ed.getDataTable("hero_equip")[hid][rank][slotStr]
end

function layerBase:init()
  self.hero = self.param
  self.hid = self.hero._tid
  self:adaptUI()
  self:initLabels()
  ed.setString(self.ui.label_exp, T("\229\183\178\229\141\135\232\135\179\230\187\161\231\186\167"))
  ed.setString(self.ui.label_stone, T("\229\183\178\232\191\155\229\140\150\232\135\179\233\161\182\231\186\167"))
  ed.setString(self.ui.label_level, T("\231\173\137\231\186\167") .. self.hero._level)
  self.ui.bar_stone = ed.UITool.createProcessBar("UI/alpha/1080P/hero/hero_soulstone_progress.png", self.ui.bg_bar_stone, CCRectMake(45, 6.5, 45, 6.5))
  self.ui.bg_gs:setVisible(false)
  self.ui.icon_collect:setVisible(false)
  self.ui.card:setVisible(false)
  self.ui.bg_gsadd:setVisible(false)
  self.cradPos = ccp(200 - ed.display.halfFixedWidth * 0.66, 250)
  self.cradToPos = ccp(ed.display.winSize.width / 2 - ed.display.halfFixedWidth + 10, ed.display.winSize.height / 2 + 30 - ed.display.halfFixedHeight)
  local layerColor = CCLayer:create()
  layerColor:setPosition(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight)
  self.popSelf.containers:addChild(layerColor, 998)
  self.cardLayerColor = layerColor
  local layer = ed.createSprite()
  self.popSelf.containers:addChild(layer, 999)
  self.cardLayer = layer
  layer:setScale(0.99)
  local color = CCLayerColor:create(ccc4(0, 0, 0, 205))
  color:setPosition(-ed.display.winSize.width / 2, -ed.display.winSize.height / 2)
  layerColor:addChild(color)
  self.cardLayerColor:setVisible(false)
  self:refresh(self.param)
  local index = 1
  
  local function func(node, click, press, normal)
    self.popSelf:btRegisterButtonClick({
      button = node,
      key = "layerBasePage_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_info, function()
    ed.ui.heroDetailAttrWin.create({
      hero = self.hero
    })
  end)
  self.popSelf:btRegisterButtonClick({
    button = self.cardLayerColor,
    key = "layerBasePage_cardcolor",
    clickHandler = function()
      self.cardLayer:stopAllActions()
      local scale = self.cardLayer:getScale()
      local isOp = scale <= 1
      local fadeOut = CCRotateTo:create(0.3, isOp and -90 or 0)
      local scale = CCScaleTo:create(0.3, isOp and 1.96 or 0.99)
      local move = CCMoveTo:create(0.3, isOp and self.cradToPos or self.cradPos)
      local spawn = CCSpawn:create(ccArrayMake(scale, fadeOut, move))
      self.cardLayer:runAction(spawn)
      self.cardLayerColor:setVisible(false)
    end,
    priority = -995,
    clickInterval = 0.6,
    force = true
  })
  self.popSelf:btRegisterButtonClick({
    button = self.cardLayer,
    key = "layerBasePage_card",
    clickHandler = function()
      self.cardLayer:stopAllActions()
      local scale = self.cardLayer:getScale()
      local isOp = scale <= 1
      local fadeOut = CCRotateTo:create(0.3, isOp and -90 or 0)
      local scale = CCScaleTo:create(0.3, isOp and 1.96 or 0.99)
      local move = CCMoveTo:create(0.3, isOp and self.cradToPos or self.cradPos)
      local spawn = CCSpawn:create(ccArrayMake(scale, fadeOut, move))
      self.cardLayer:runAction(spawn)
      self.cardLayerColor:setVisible(isOp)
    end,
    priority = -998,
    clickInterval = 0.3
  })
  self.ui.dungeon_switch_bg:setVisible(false)
  self.ui.dungeon_switch:setVisible(false)
  return self
end

function layerBase:refresh(param)
  self.hero = param
  self.hid = self.hero._tid
  self:createCard()
  self:createHeroName()
  self:createHeroFca()
  local items = {}
  for i = 1, 6 do
    local id = self.hero._items[i] and self.hero._items[i]._item_id or self.getEquipIdFromTb(self.hid, i, self.hero._rank)
    local frame, icon
    if self.hero._items[i] then
      frame, icon = ed.readequip.createIcon(id, nil)
      table.insert(items, {
        _item_id = self.hero._items[i]._item_id,
        _exp = 0
      })
    else
      frame, icon = ed.readequip.createIcon(id, nil, 1)
      ed.setSpriteGray(icon)
      local labelNotHave = ed.createttf(T("\230\151\160\232\163\133\229\164\135"), 18)
      ed.setLabelColor(labelNotHave, ed.toccc3(14735037))
      ed.setLabelStroke(labelNotHave, ed.toccc3(1972758), 1)
      icon:addChild(labelNotHave)
      labelNotHave:setPosition(ccp(34, 14))
    end
    local x, y = self.ui["frame_equip" .. i]:getPosition()
    frame:setPosition(x, y)
    self.ui["equip" .. i]:addChild(frame)
    self.popSelf:btRegisterButtonClick({
      button = icon,
      pressScale = 0.95,
      key = "equip_" .. i,
      param = id or {},
      clickHandler = function(id)
        self:doClickEquip(id)
      end,
      clickInterval = 0.5,
      force = true
    })
  end
  local proto = ed.copyTable(self.hero)
  proto._items = items
  self.attInfo = ed.readhero.getHeroAttByHero(proto)
  ed.setString(self.ui.num_attr1, math.floor(self.attInfo.HP.all and self.attInfo.HP.all + 0.5 or 0))
  ed.setString(self.ui.num_attr2, math.floor(self.attInfo.AD.all and self.attInfo.AD.all + 0.5 or 0))
  ed.setString(self.ui.num_attr3, math.floor(self.attInfo.AP.all and self.attInfo.AP.all + 0.5 or 0))
  ed.setString(self.ui.num_attr4, math.floor(self.attInfo.ARM.all and self.attInfo.ARM.all + 0.5 or 0))
  ed.setString(self.ui.num_attr5, math.floor(self.attInfo.MR.all and self.attInfo.MR.all + 0.5 or 0))
  local posY = self.ui.bg_info:getPositionY() - self.ui.bg_info:getContentSize().height * 0.5 - 1
  local element = ed.getDataTable("Unit")[self.hid].Element
  if nil ~= element then
    ed.setTexture(self.ui.img_element_icon, string.format("UI/alpha/1080P/tag/Kael_%s.png", element))
    self.ui.bg_element_attr:setVisible(true)
    self.ui.bg_element_attr:setPositionY(posY - self.ui.bg_element_attr:getContentSize().height * 0.5)
    posY = posY - self.ui.bg_element_attr:getContentSize().height - 2
  else
    self.ui.bg_element_attr:setVisible(false)
  end
  self.ui.bg_attrlist:setPositionY(posY - self.ui.bg_attrlist:getContentSize().height * 0.5)
  local bar = self.ui.bar_stone
  local stars = self.hero._stars
  for i = 1, 5 do
    self.ui["star" .. i]:setVisible(i <= stars)
  end
  if self.hero._level >= ed.parameter.team_level_max then
    ed.setString(self.ui.label_exp, T("\229\183\178\229\141\135\232\135\179\230\187\161\231\186\167"))
  else
    ed.setString(self.ui.label_exp, T("0%"))
  end
  bar:setVisible(false)
  if 5 <= stars then
    ed.setString(self.ui.label_stone, T("\229\183\178\232\191\155\229\140\150\232\135\179\233\161\182\231\186\167"))
  else
    local row = ed.getDataTable("HeroStars")[self.hero._stars + 1] or {}
    local sn = row["Upgrade Fragments"] or 99999
    ed.setString(self.ui.label_stone, string.format("%d/%d", 0, sn))
  end
  ed.setTexture(self.ui.icon_type, ed.readhero.getTypeRes(self.hid))
  self:createShardIcon()
end

function layerBase:createHeroName()
  local ui = self.ui
  local nb = ed.getCenterPos(ui.frame_name)
  ui.name:removeFromParentAndCleanup(true)
  local name, w, h = ed.readhero.createHeroNameByInfo({
    name = ed.getDataTable("Unit")[self.hid]["Display Name"],
    rank = self.hero._rank,
    tid = self.hero._tid
  })
  ed.setTexture(ui.frame_name, string.format("UI/alpha/1080P/hero/rank/hero_rank_%d.png", self.hero._rank))
  ui.name = name
  name:setPosition(ccp(nb.x - w / 2, nb.y))
  ui.frame_name:addChild(name)
  ui.frame_name:setZOrder(1)
end

function layerBase:createCard()
  if self.cardLayer then
    self.cardLayer:removeAllChildrenWithCleanup(true)
  end
  local card = ed.readhero.getHeroCard(self.hid, {
    hide_star = true,
    starType = "init",
    OriSize = true
  }, self.hero)
  local card_ui = card.container
  card_ui:setScale(0.99)
  card_ui:setZOrder(2)
  self.cardLayer:addChild(card_ui)
  self.cardLayer:setContentSize(card.frame:getContentSize())
  self.cardLayer:setPosition(self.cradPos)
  for fashion_id, effect_fca in pairs(card.card_fashion_effect or {}) do
    self.popSelf:addFca(effect_fca)
  end
end

function layerBase:show(vis, param)
  self.container:setVisible(vis)
  self.cardLayer:setVisible(vis)
  if vis then
    self:refresh(param)
  end
end

function layerBase:adaptUI()
  self.ui.layer_normal:setPosition(ccp(433.75, 239.75))
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  local midPercent = 0.66
  self.ui.bg_mid1:setContentSize(CCSizeMake(self.ui.bg_mid1:getContentSize().width + fixWidth * midPercent, self.ui.bg_mid1:getContentSize().height))
  self.ui.bg_mid1:setPositionX(self.ui.bg_mid1:getPositionX() + fixWidth * midPercent / 2)
  self.ui.sep2:setPositionX(self.ui.sep2:getPositionX() + fixWidth * midPercent)
  self.ui.bg_name:setPositionX(self.ui.bg_name:getPositionX() + fixWidth * midPercent / 2)
  self.ui.equip1:setPositionX(self.ui.equip1:getPositionX() - fixWidth * midPercent / 4)
  self.ui.equip2:setPositionX(self.ui.equip2:getPositionX() - fixWidth * midPercent / 4)
  self.ui.equip3:setPositionX(self.ui.equip3:getPositionX() - fixWidth * midPercent / 4)
  self.ui.equip4:setPositionX(self.ui.equip4:getPositionX() + fixWidth * midPercent / 4)
  self.ui.equip5:setPositionX(self.ui.equip5:getPositionX() + fixWidth * midPercent / 4)
  self.ui.equip6:setPositionX(self.ui.equip6:getPositionX() + fixWidth * midPercent / 4)
  local rightPercent = 1 - midPercent
  self.ui.bg_attr:setContentSize(CCSizeMake(self.ui.bg_attr:getContentSize().width + fixWidth * rightPercent, self.ui.bg_attr:getContentSize().height))
  self.ui.bg_attr:setPositionX(self.ui.bg_attr:getPositionX() + fixWidth * (midPercent + rightPercent / 2))
  self.ui.bg_level:setContentSize(CCSizeMake(self.ui.bg_level:getContentSize().width + fixWidth * rightPercent, self.ui.bg_level:getContentSize().height))
  self.ui.bg_level:setPositionX(self.ui.bg_level:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.bg_star:setContentSize(CCSizeMake(self.ui.bg_star:getContentSize().width + fixWidth * rightPercent, self.ui.bg_star:getContentSize().height))
  self.ui.bg_star:setPositionX(self.ui.bg_star:getPositionX() + fixWidth * rightPercent / 2)
  local starPercent = 0.1
  self.ui.bg_star1:setPositionX(self.ui.bg_star1:getPositionX() + fixWidth * rightPercent * (0.5 - starPercent * 2))
  self.ui.bg_star2:setPositionX(self.ui.bg_star2:getPositionX() + fixWidth * rightPercent * (0.5 - starPercent))
  self.ui.bg_star3:setPositionX(self.ui.bg_star3:getPositionX() + fixWidth * rightPercent * 0.5)
  self.ui.bg_star4:setPositionX(self.ui.bg_star4:getPositionX() + fixWidth * rightPercent * (0.5 + starPercent))
  self.ui.bg_star5:setPositionX(self.ui.bg_star5:getPositionX() + fixWidth * rightPercent * (0.5 + starPercent * 2))
  self.ui.bg_info:setContentSize(CCSizeMake(self.ui.bg_info:getContentSize().width + fixWidth * rightPercent, self.ui.bg_info:getContentSize().height))
  self.ui.bg_info:setPositionX(self.ui.bg_info:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.btn_info:setPositionX(self.ui.btn_info:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.label_info:setPositionX(self.ui.label_info:getPositionX() + fixWidth * rightPercent * 0.2)
  self.ui.bg_element_attr:setContentSize(CCSizeMake(self.ui.bg_element_attr:getContentSize().width + fixWidth * rightPercent, self.ui.bg_element_attr:getContentSize().height))
  self.ui.bg_element_attr:setPositionX(self.ui.bg_element_attr:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.img_element_icon:setPositionX(self.ui.img_element_icon:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.label_element_attr:setPositionX(self.ui.label_element_attr:getPositionX() + fixWidth * rightPercent * 0.2)
  local attrContentSize = self.ui.bg_attrlist:getContentSize()
  self.ui.bg_attrlist:setContentSize(CCSizeMake(self.ui.bg_attrlist:getContentSize().width + fixWidth * rightPercent, self.ui.bg_attrlist:getContentSize().height))
  self.ui.bg_attrlist:setPositionX(self.ui.bg_attrlist:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.attr1:setPositionX(self.ui.attr1:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr2:setPositionX(self.ui.attr2:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr3:setPositionX(self.ui.attr3:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr4:setPositionX(self.ui.attr4:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.attr5:setPositionX(self.ui.attr5:getPositionX() + fixWidth * rightPercent * 0.1)
  self.ui.num_attr1:setPositionX(self.ui.num_attr1:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr2:setPositionX(self.ui.num_attr2:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr3:setPositionX(self.ui.num_attr3:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr4:setPositionX(self.ui.num_attr4:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.num_attr5:setPositionX(self.ui.num_attr5:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.layer_collect:setPositionX(self.ui.layer_collect:getPositionX() + fixWidth * rightPercent / 2)
  self.ui.deco1:setScaleX(0.9 * (attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.deco2:setScaleX(0.9 * (attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.bg_bar_exp:setScaleX((attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.label_exp:setScaleX(1 / self.ui.bg_bar_exp:getScaleX())
  self.ui.bg_bar_stone:setScaleX((attrContentSize.width + fixWidth * rightPercent) / attrContentSize.width)
  self.ui.label_stone:setScaleX(1 / self.ui.bg_bar_stone:getScaleX())
  self.ui.btn_levelup:setPositionX(self.ui.btn_levelup:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.btn_evolve:setPositionX(self.ui.btn_evolve:getPositionX() + fixWidth * rightPercent * 0.8)
  self.ui.btn_levelup:setVisible(false)
  self.ui.btn_evolve:setVisible(false)
  self.ui.bg_gsadd:setPositionX(self.ui.bg_gsadd:getPositionX() + ed.display.halfFixedWidth)
  self.ui.btn_up:setVisible(false)
  self.ui.bg_pet:setVisible(false)
end

function layerBase:initLabels()
  ed.setLabelStroke(self.ui.label_level, ccc3(0, 0, 0), 1)
  ed.setLabelShadow(self.ui.label_levelup, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_evolve, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_up, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelStroke(self.ui.label_exp, ccc3(47, 46, 47), 1)
  ed.setLabelStroke(self.ui.label_stone, ccc3(47, 46, 47), 1)
  ed.setLabelStroke(self.ui.label_info, ccc3(41, 27, 27), 1)
  ed.setLabelStroke(self.ui.label_gs, ed.toccc3(3611404), 1)
  ed.setLabelStroke(self.ui.label_element_attr, ed.toccc3(2693914), 1)
  for i = 1, 5 do
    ed.setLabelStroke(self.ui["attr" .. i], ccc3(41, 27, 27), 1)
    ed.setLabelStroke(self.ui["num_attr" .. i], ccc3(41, 27, 27), 1)
  end
end

function layerBase:doClickEquip(id)
  ed.ui.packageDetailWin.create({id = id, type = "item"}):popWindow()
end

function layerBase:createHeroFca()
  if self.panelHeroFca then
    self.panelHeroFca:removeAllChildrenWithCleanup(true)
  else
    local panel = CCLayer:create()
    panel:setPosition(200, 265)
    panel:setContentSize(CCSizeMake(160, 200))
    self.ui.bg_equip:addChild(panel)
    self.panelHeroFca = panel
  end
  ed.asyncload.unregistLoadingListener()
  ed.asyncload.preloadFcaByUnitID(self.hid)
  ed.asyncload.registLoadingListener(function()
    local puppet, puppet_id, cha = ed.readhero.getActor(self.hid, "Idle", true, false, nil, false)
    local row = ed.getDataTable("Puppet")[puppet_id]
    local scale = row.Scale
    local wscale = row["Window Scale"]
    if wscale ~= 0 then
      scale = scale * wscale
    end
    puppet:setScale(scale)
    puppet:setPosition(0, -100)
    self.panelHeroFca:addChild(puppet, 10)
    self.popSelf:addFca(puppet)
    ed.asyncload.unregistLoadingListener()
    self.puppet = puppet
    self.cha = cha
    local actions = {}
    local row = ed.getDataTable("AnimDuration")[self.cha]
    local can_show_action_tbl = {"Move"}
    local skill_items = ed.getDataTable("SkillGroup")[self.hid]
    for idx, skill_item in pairs(skill_items or {}) do
      for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
        if string.find(action, "special") == nil then
          can_show_action_tbl[#can_show_action_tbl + 1] = action
        end
      end
    end
    for k, v in pairs(row or {}) do
      if ed.isElementInTable(k, can_show_action_tbl) then
        table.insert(actions, {
          act = k,
          time = v.Duration
        })
      end
    end
    self.actions = actions
    self.popSelf:btRegisterButtonClick({
      button = self.panelHeroFca,
      key = "Panel_skill",
      force = true,
      mcpMode = true,
      clickHandler = function()
        if self.timeTig then
          return
        end
        local actions = ed.copyProto(self.actions)
        if self.oldIdx then
          table.remove(actions, self.oldIdx)
        end
        self.oldIdx = math.random(1, #actions)
        local action = actions[self.oldIdx].act
        self.puppet:setAction(action)
        self.puppet:setLoop(action == "Move")
        self.timeTig = true
        self.popSelf:listenTimer(Timer:Once(actions[self.oldIdx].time), function()
          self.puppet:setAction("Idle")
          self.puppet:setLoop(true)
          self.timeTig = false
        end)
      end
    })
  end)
end

function layerBase:createShardIcon()
  local shard = self.hero._shard or {}
  if self.shardEquipBg then
    self.shardEquipBg:removeFromParentAndCleanup(true)
    self.shardEquipBg = nil
  end
  if shard and shard._level and shard._id and shard._level > 0 then
    local res
    for _, v in pairs(ed.getDataTable("ShardToHero")) do
      if shard._id == v["Shard ID"] and v["Hero ID"] == self.hid then
        res = v.Icon
      end
    end
    if not res then
      return
    end
    local shardEquipBg = ed.createSprite("UI/alpha/1080P/shard/shard_frame.png")
    shardEquipBg:setPosition(242, 18)
    self.ui.frame_name:addChild(shardEquipBg)
    local shardEquip = ed.createSprite(res)
    local size = shardEquipBg:getContentSize()
    shardEquip:setPosition(size.width / 2, size.height / 2)
    shardEquipBg:addChild(shardEquip)
    local labelBg = ed.createSprite("UI/alpha/1080P/skill/skill_rank_2.png")
    labelBg:setPosition(size.width / 2, 7)
    shardEquipBg:addChild(labelBg)
    labelBg:setScale(0.66)
    local label = ed.createttf(shard._level, 16)
    label:setPosition(size.width / 2, 7)
    label:setColor(ccc3(254, 255, 170))
    shardEquipBg:addChild(label)
    ed.setLabelStroke(label, ccc3(39, 37, 36), 1)
    self.shardEquipBg = shardEquipBg
  end
end
