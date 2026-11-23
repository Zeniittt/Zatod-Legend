local base = ed.ui.popwindow
ed.ui.heroDetailShardPops = {}
local shardActivationPop = newclass(base.mt)
ed.ui.heroDetailShardPops.activation = shardActivationPop
ed.UITool.registViewOpenFunc("shardActivationPop", function(param)
  setmetatable(base.create("shardActivationPop"), shardActivationPop.mt):create(param):popWindow()
end)

function shardActivationPop:create(param)
  self:initUI(param)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function shardActivationPop:initUI(param)
  self.shardPopLay, self.ui = ed.editorui(ed.uieditor.heroEvolveWin)
  self.container:addChild(self.shardPopLay)
  self.shardPopLay:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  self.ui.title:setString(T("\230\191\128\230\180\187\232\167\137\233\134\146\232\163\133\229\164\135"))
  self.ui.desc:setString(T("\230\152\175\229\144\166\230\182\136\232\128\151\228\187\165\228\184\139\230\157\144\230\150\153\228\184\186\232\139\177\233\155\132\230\191\128\230\180\187\232\167\137\233\134\146\232\163\133\229\164\135?"))
  self.ui.bg_heroicon:setVisible(false)
  self.hero = param.hero
  self.hid = self.hero.tid
  self.callback = param.callback
  local dataObj = ed.ui.heroDetailScene.newShard.data
  local _, attrs = dataObj.getHeroShardAttrByLevel(self.hero.shardId, self.hero.shardLv)
  ed.setString(self.ui.from1, 0)
  ed.setString(self.ui.from2, 0)
  ed.setString(self.ui.from3, 0)
  local key = {
    STR = 1,
    INT = 2,
    AGI = 3
  }
  for k, v in pairs(key) do
    ed.setString(self.ui["to" .. v], attrs[k] or 0)
  end
  local itemBg = ed.createScale9Sprite("UI/alpha/1080P/skill/new/skill_rankup_detail_bg.png", CCRectMake(5, 5, 5, 5))
  itemBg:setContentSize(CCSizeMake(600, 84))
  itemBg:setPosition(ccp(275, 240))
  self.ui.bg:addChild(itemBg)
  local consume = dataObj.getHeroLvByConsume(self.hero.shardId, 1)
  local icon1 = ed.createItemIcon(consume[1])
  icon1:setPosition(265, 40)
  itemBg:addChild(icon1)
  local icon2 = ed.createItemIcon(consume[2])
  icon2:setPosition(335, 40)
  itemBg:addChild(icon2)
  for i = 1, 3 do
    local str = self.ui["attrname" .. i]:getString()
    str = string.gsub(str, T("\230\136\144\233\149\191"), "")
    self.ui["attrname" .. i]:setString(str)
  end
end

function shardActivationPop:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:destroy({skipAnim = false})
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_ok", function()
    self.callback()
    self:destroy({skipAnim = false})
  end, {pressScale = 0.95})
end

local shardAttributesPop = newclass(base.mt)
ed.ui.heroDetailShardPops.Attributes = shardAttributesPop
ed.UITool.registViewOpenFunc("shardAttributesPop", function(param)
  setmetatable(base.create("shardAttributesPop"), shardAttributesPop.mt):create(param):popWindow()
end)

function shardAttributesPop:create(param)
  self:initUI(param)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function shardAttributesPop:initUI(param)
  self.shardPopLay, self.ui = ed.editorui(ed.uieditor.heroAttWin)
  self.container:addChild(self.shardPopLay)
  self.shardPopLay:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  self.ui.title:setString(T("\229\177\158\230\128\167\230\128\187\232\167\136"))
  self.hero = param.hero
  self.hid = self.hero.tid
  self.desc = ed.getDataTable("ShardToHero")[self.hero.shardId].Description or "\228\184\128\228\184\170\230\178\161\230\156\137\231\174\128\228\187\139\231\154\132\229\176\143\232\167\146\232\137\178"
  self.comment = ""
  local list_panel = CCLayer:create()
  list_panel:setContentSize(CCSizeMake(500, 32))
  list_panel:setPosition(ccp(25, 274))
  self.ui.bg:addChild(list_panel)
  local dlDesc = ed.UITool.createDraglist(list_panel, {priority = -300})
  local desc_label = ed.createLabelTTF(self.desc, 15)
  ed.setLabelColor(desc_label, ed.toccc3(16776423))
  ed.setLabelDimensions(desc_label, CCSizeMake(500, 0))
  desc_label:setHorizontalAlignment(kCCTextAlignmentLeft)
  desc_label:setAnchorPoint(ccp(0.5, 1))
  desc_label:setPosition(ccp(250, 32))
  dlDesc:addItem(desc_label)
  dlDesc:initListHeight(desc_label:getContentSize().height)
  self.ui.desc:setVisible(false)
  self.ui.comment:setVisible(false)
  local size = self.ui.layer_att:getContentSize()
  self.ui.layer_att:setContentSize(CCSizeMake(size.width, size.height + 20))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_att, {})
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  local names = {
    STR = 1,
    INT = 1,
    AGI = 1
  }
  for i, v in ipairs(self.hero.attrDesc or {}) do
    local container, ui = CCNode:create(), {}
    local readnode = ed.readnode.create(container, ui)
    readnode:addNode(i % 2 == 1 and ed.uieditor.itemAttr1 or ed.uieditor.itemAttr2)
    self.draglist:addItem(container)
    ui.attrname:setColor(names[v.key] and ccc3(254, 211, 109) or ccc3(255, 234, 198))
    ed.setLabelStroke(ui.attrname, ccc3(41, 27, 27), 1)
    ed.setString(ui.attrname, names[v.key] and v.name or v.name)
    ui.attrnum:setColor(ccc3(255, 234, 198))
    ed.setLabelStroke(ui.attrnum, ccc3(41, 27, 27), 1)
    ed.setString(ui.attrnum, v.num)
    container:setPosition(252, 260 - i * 35)
  end
  self.draglist:initListHeight(35 * #self.hero.attrDesc)
end

function shardAttributesPop:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end

local shardLevelupPop = newclass(base.mt)
ed.ui.heroDetailShardPops.Levelup = shardLevelupPop
ed.UITool.registViewOpenFunc("shardLevelupPop", function(param)
  setmetatable(base.create("shardLevelupPop"), shardLevelupPop.mt):create(param):popWindow()
end)

function shardLevelupPop:create(param)
  self:initUI(param)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function shardLevelupPop.localCreatettf(param)
  local label = ed.createttf(param.txt or 0, param.size or 17)
  label:setPosition(param.pos or ccp(0, 0))
  label:setColor(param.color or ccc3(243, 220, 181))
  label:setAnchorPoint(param.anchor or ccp(0.5, 0.5))
  param.parent:addChild(label)
  if param.stroke then
    ed.setLabelStroke(label, param.stroke.color, param.stroke.size or 1)
  end
  return label
end

local localCreatettfFunc = shardLevelupPop.localCreatettf

function shardLevelupPop:initUI(param)
  self.ui = {}
  local layBg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 25, 10, 25))
  layBg:setContentSize(CCSizeMake(640, 380))
  layBg:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  self.container:addChild(layBg)
  self.ui.bg = layBg
  self.container:setPosition(0, 0)
  self.hero = param.hero
  self.hid = self.hero.tid
  local label_title = self.localCreatettf({
    txt = T("\229\188\186\229\140\150\229\177\158\230\128\167\233\162\132\232\167\136"),
    size = 17,
    pos = ccp(320, 360),
    color = ccc3(243, 220, 181),
    parent = layBg
  })
  local lins_1 = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lins_1.png")
  layBg:addChild(lins_1)
  ed.right2(lins_1, label_title, 15)
  local lins_2 = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lins_1.png")
  layBg:addChild(lins_2)
  ed.left2(lins_2, label_title, 15)
  lins_2:setScaleX(-1)
  local layer = CCLayer:create()
  layer:setContentSize(CCSizeMake(600, 330))
  layer:setPosition(ccp(20, 15))
  layBg:addChild(layer)
  self.draglist = ed.UITool.createDraglist(layer, {
    bar = {
      bgpos = ccp(602, 165),
      alwaysShow = true
    }
  })
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  local leftPosy, toMovePoxY = 328, false
  for i, v in ipairs(param.allAttrs or {}) do
    local descBg = ed.createScale9Sprite(string.format("UI/alpha/1080P/shard/levelpreview_%d.png", i == self.hero.shardLv and 2 or 3), CCRectMake(8, 8, 20, 20))
    descBg:setAnchorPoint(ccp(0, 1))
    descBg:setContentSize(CCSizeMake(90, 35 * #v))
    descBg:setPosition(ccp(2, leftPosy))
    self.draglist.listLayer:addChild(descBg)
    local clipLayer = CCLayer:create()
    descBg:addChild(clipLayer)
    clipLayer:setClipRect(CCRectMake(0, 0, 90, 35 * #v))
    local fa = ed.createSprite(string.format("UI/alpha/1080P/shard/shading_%d.png", i == self.hero.shardLv and 1 or 2))
    fa:setPosition(45, 35 * #v / 2)
    clipLayer:addChild(fa)
    self.localCreatettf({
      txt = ed.formatLevel("LV.") .. i,
      size = 17,
      pos = ccp(45, 35 * #v / 2),
      color = i == self.hero.shardLv and ccc3(254, 211, 109) or ccc3(245, 221, 183),
      parent = descBg,
      stroke = {
        color = ccc3(41, 27, 27),
        size = 1.5
      }
    }):setFontName(ed.fontBold)
    if i == self.hero.shardLv then
      toMovePoxY = math.abs(leftPosy - 318) - 160 + 35 * #v / 2
    end
    local localPosy = leftPosy
    for _, vv in ipairs(v) do
      local rigDescBg = ed.createScale9Sprite(string.format("UI/alpha/1080P/shard/levelpreview_%d.png", i == self.hero.shardLv and 3 or 1), CCRectMake(8, 8, 20, 20))
      rigDescBg:setAnchorPoint(ccp(0, 1))
      rigDescBg:setContentSize(CCSizeMake(500, 35))
      rigDescBg:setPosition(ccp(91, localPosy))
      self.draglist.listLayer:addChild(rigDescBg)
      local star = ed.createSprite("UI/alpha/1080P/skill/new/skill_rankup_point.png")
      star:setPosition(22, 17.5)
      rigDescBg:addChild(star)
      star:setScale(0.85)
      self.localCreatettf({
        txt = vv.name,
        size = 17,
        pos = ccp(40, 17.5),
        color = i == self.hero.shardLv and ccc3(251, 219, 106) or ccc3(243, 220, 181),
        parent = rigDescBg,
        anchor = ccp(0, 0.5),
        stroke = {
          color = ccc3(41, 27, 27),
          size = 1
        }
      })
      self.localCreatettf({
        txt = "+" .. vv.num,
        size = 17,
        pos = ccp(480, 17.5),
        color = i == self.hero.shardLv and ccc3(251, 219, 106) or ccc3(243, 220, 181),
        parent = rigDescBg,
        anchor = ccp(1, 0.5),
        stroke = {
          color = ccc3(41, 27, 27),
          size = 1
        }
      })
      localPosy = localPosy - 35
    end
    leftPosy = leftPosy - 35 * #v + 1
  end
  self.draglist:initListHeight(math.abs(leftPosy) + 333)
  if toMovePoxY then
    toMovePoxY = ed.clamp(toMovePoxY, 0, self.draglist.listHeight - 333)
    self.draglist.listLayer:setPositionY(toMovePoxY)
    local sb = self.draglist.scrollbar[1]
    local bar = sb.bar
    local bg = sb.barBg
    local proportion = toMovePoxY / (self.draglist.listHeight - 320)
    local berHieght = bar:getContentSize().height * bar:getScaleY()
    local height = 320 - berHieght
    local barPosY = height + berHieght - height * proportion - berHieght / 2
    bar:setPositionY(barPosY - 5)
    do return end
    toMovePoxY = ed.clamp(toMovePoxY, 0, self.draglist.listHeight - 330)
    self.draglist.listLayer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(1, ccp(self.draglist.listLayer:getPositionX(), toMovePoxY))))
    local sb = self.draglist.scrollbar[1]
    local bar = sb.bar
    local bg = sb.barBg
    local proportion = toMovePoxY / (self.draglist.listHeight - 330)
    local berHieght = bar:getContentSize().height * bar:getScaleY()
    local height = 330 - berHieght
    local barPosY = height + berHieght - height * proportion - berHieght / 2
    bar:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(1, ccp(bar:getPositionX(), barPosY))))
  end
end

function shardLevelupPop:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end

local shardRankUpPop = newclass(base.mt)
ed.ui.heroDetailShardPops.Levelup = shardRankUpPop
ed.UITool.registViewOpenFunc("shardRankUpPop", function(param)
  setmetatable(base.create("shardRankUpPop", {notBlurBg = true}), shardRankUpPop.mt):create(param):popWindow()
end)

function shardRankUpPop:create(param)
  self:initUI(param)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function shardRankUpPop:initUI(param)
  self.shardPopLay, self.ui = ed.editorui(ed.uieditor.skillRankUpWin)
  self.container:addChild(self.shardPopLay)
  self.shardPopLay:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.shardPopLay:setScale(1.2)
  self.container:setPosition(0, 0)
  self.hero = param.hero
  self.callbackFun = param.closeCallback
  self.hid = self.hero.tid
  self.ui.ImageView_22157:setVisible(false)
  self.ui.frame_skill_rank:setVisible(false)
  self.ui.bg_skill_rank:setVisible(false)
  self.ui.skill_uprank_desc_bg:setVisible(false)
  self.ui.skill_icon:setVisible(false)
  self.ui.skill_level:setString(ed.formatLevel("lv.") .. self.hero.shardLv)
  ed.setLabelStroke(self.ui.skill_level, ccc3(41, 27, 27), 1)
  if param.heroShardInfo then
    local arcanaLight = ed.createFcaNode("eff_UI_arcana_light")
    arcanaLight:setPosition(ccp(178, 85))
    self.ui.skill_icon_bg:addChild(arcanaLight)
    self:addFca(arcanaLight)
    local iconSmall = ed.createSprite(param.heroShardInfo["Equip Icon Small"])
    iconSmall:setPosition(175, 95)
    self.ui.skill_icon_bg:addChild(iconSmall)
  end
  local allAttrs = param.allAttrs or {}
  local addAttr = param.addAttr or {}
  local addHight = (#addAttr - 3) * 26
  for i, v in ipairs(addAttr) do
    local star = ed.createSprite("UI/alpha/1080P/skill/new/skill_rankup_point.png")
    star:setPosition(96, 36 - 26 * i)
    self.ui.skill_attr:addChild(star)
    star:setScale(0.9)
    local desLabel = localCreatettfFunc({
      txt = v.name .. ":  " .. (allAttrs[v.key] and allAttrs[v.key] - v.num or 0),
      size = 15,
      pos = ccp(110, 36 - 26 * i),
      color = ccc3(252, 234, 197),
      parent = self.ui.skill_attr,
      anchor = ccp(0, 0.5),
      stroke = {
        color = ccc3(41, 27, 27),
        size = 1
      }
    })
    local arrow = ed.createSprite("UI/alpha/1080P/hero/hero_upgrade_arrow.png")
    self.ui.skill_attr:addChild(arrow)
    arrow:setScale(0.5)
    arrow:setPosition(desLabel:getPositionX() + desLabel:getContentSize().width + arrow:getContentSize().width * 0.5 + 10, 36 - 26 * i)
    localCreatettfFunc({
      txt = allAttrs[v.key] or 0,
      size = 15,
      pos = ccp(arrow:getPositionX() + arrow:getContentSize().width * 0.5 + 10, 36 - 26 * i),
      color = ccc3(135, 255, 72),
      parent = self.ui.skill_attr,
      anchor = ccp(0, 0.5),
      stroke = {
        color = ccc3(41, 27, 27),
        size = 1
      }
    })
  end
  if param.newUnlockSkill then
    local skillBg = ed.createScale9Sprite("UI/alpha/1080P/skill/new/skill_rankup_detail_bg.png", CCRectMake(5, 2, 5, 35))
    self.ui.skill_attr:addChild(skillBg)
    local star = ed.createSprite("UI/alpha/1080P/skill/skill_point.png")
    star:setPosition(ccp(40, -70 - addHight))
    self.ui.skill_attr:addChild(star)
    localCreatettfFunc({
      txt = T("\229\138\160\230\136\144\230\149\136\230\158\156:"),
      size = 15,
      pos = ccp(50, -70 - addHight),
      color = ccc3(252, 234, 197),
      parent = self.ui.skill_attr,
      anchor = ccp(0, 0.5),
      stroke = {
        color = ccc3(41, 27, 27),
        size = 1
      }
    })
    star:setScale(0.85)
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = param.newUnlockSkill.description,
      fontSize = 15,
      maxWidth = 350,
      color = ccc3(252, 234, 197),
      strokeColor = ccc3(0, 0, 0),
      strokeSize = 1
    })
    local _, sizeH = autoText:getContentSize()
    autoText.node:setPosition(ccp(120, -70 - (#addAttr - 3) * 26))
    self.ui.skill_attr:addChild(autoText.node)
    skillBg:setContentSize(CCSizeMake(600, sizeH + 10))
    skillBg:setPosition(ccp(260, -55 - addHight - (sizeH + 10) / 2))
    addHight = addHight + sizeH + 10
  end
  local oldSize = self.ui.skill_rankup_bg:getContentSize()
  self.ui.skill_rankup_bg:setContentSize(CCSizeMake(oldSize.width, oldSize.height + addHight))
  self.ui.skill_icon_bg:setPositionY(self.ui.skill_icon_bg:getPositionY() + addHight)
  self.ui.skill_attr:setPositionY(self.ui.skill_attr:getPositionY() + addHight)
end

function shardRankUpPop:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.skill_rankup_bg,
    key = "out_click",
    clickHandler = function()
      if self.callbackFun then
        self.callbackFun()
      end
      self:destroy({skipAnim = false})
    end
  })
end

local showDictInfoPop = newclass(base.mt)
ed.ui.heroDetailShardPops.Levelup = showDictInfoPop
ed.UITool.registViewOpenFunc("showDictInfoPop", function(param)
  setmetatable(base.create("showDictInfoPop", {noShade = true, notBlurBg = true}), showDictInfoPop.mt):create(param):popWindow()
end)

function showDictInfoPop:create(param)
  self.desc = param.desc
  self:showDictInfo(param.index, param.x, param.y)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function showDictInfoPop:showDictInfo(index, x, y)
  if not index then
    return
  end
  local desc = self.desc
  if not desc then
    local tb = ed.getDataTable("Dictionary")
    desc = tb[tonumber(index)].Description
    desc = string.gsub(desc, "#br#", "<br/>")
  end
  local autoText = ed.ui.autoText:new()
  autoText:initParam({
    context = desc,
    fontSize = 16,
    maxWidth = 400,
    color = ccc3(255, 251, 231)
  })
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 10, 200))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 20, height + 20))
  local bgWidth = bg:getContentSize().width
  autoText.node:setPosition(ccp(10, height))
  bg:addChild(autoText.node)
  bg:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2 + 40))
  self.actionLayer:setPosition(x - ed.display.winSize.width / 2, y - ed.display.winSize.height / 2)
  self.uiBg = bg
  self.actionLayer:addChild(bg)
  local parent = bg:getParent()
  local pos = parent:convertToWorldSpace(ccp(bg:getPosition()))
  if pos.x - bg:getContentSize().width / 2 < 0 then
    ed.layout.layoutWithMagin(bg, {
      left = ed.display.getNotchHeight()
    })
  elseif pos.x + bg:getContentSize().width / 2 > ed.display.winSize.width then
    ed.layout.layoutWithMagin(bg, {
      right = ed.display.getNotchHeight()
    })
  end
end

function showDictInfoPop:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.uiBg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end
