local base = ed.ui.popwindow
local heroDetailAstrolabeRulePop = newclass(base.mt)
ed.ui.heroDetailAstrolabeRulePop = heroDetailAstrolabeRulePop
ed.UITool.registViewOpenFunc("heroDetailAstrolabeRulePop", function(param)
  setmetatable(base.create("heroDetailAstrolabeRulePop"), ed.ui.heroDetailAstrolabeRulePop.mt):create(param):popWindow()
end)

function heroDetailAstrolabeRulePop:create(param)
  self:initUI(param)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function heroDetailAstrolabeRulePop.localCreatettf(param)
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

local localCreatettfFunc = heroDetailAstrolabeRulePop.localCreatettf

function heroDetailAstrolabeRulePop:initUI(param)
  self.ui = {}
  local layBg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 25, 10, 25))
  layBg:setContentSize(CCSizeMake(640, 380))
  layBg:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  self.container:addChild(layBg)
  self.ui.bg = layBg
  self.container:setPosition(0, 0)
  self.param = param or {}
  self.hero = param.hero
  self.index = 1
  self.labelTitleStr = {
    T("\230\152\159\231\155\152\229\159\186\231\161\128\232\167\132\229\136\153"),
    T("\230\152\159\231\155\152\229\159\186\231\161\128\229\177\158\230\128\167"),
    T("\230\152\159\231\155\152\232\175\141\230\157\161\232\175\180\230\152\142")
  }
  local label_title = self.localCreatettf({
    txt = self.labelTitleStr[self.index],
    size = 17,
    pos = ccp(320, 360),
    color = ccc3(243, 220, 181),
    parent = layBg
  })
  local lins_1 = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lins_1.png")
  layBg:addChild(lins_1)
  ed.right2(lins_1, label_title, 20)
  local lins_2 = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lins_1.png")
  layBg:addChild(lins_2)
  ed.left2(lins_2, label_title, 20)
  lins_2:setScaleX(-1)
  self.labelTitle = label_title
  self.ui.arrow_left = ed.createSpriteTools({
    res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
    pos = ccp(0, 190),
    parent = layBg
  })
  self.ui.arrow_right = ed.createSpriteTools({
    res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
    pos = ccp(640, 190),
    parent = layBg
  })
  self.ui.arrow_left:setFlipX(true)
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(-10, 0)), CCMoveBy:create(0.7, ccp(10, 0)))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(10, 0)), CCMoveBy:create(0.7, ccp(-10, 0)))))
  self.ui.arrow_left:setVisible(self.index > 1)
  self.ui.arrow_right:setVisible(self.index < 3)
  self.clipLayer = CCLayer:create()
  layBg:addChild(self.clipLayer)
  self.clipLayer:setClipRect(CCRectMake(6, 12, 628, 320))
  self:addPage1()
  self:addPage2()
  self:addPage3()
  local width = 30
  local posx = 300 - width * 3 / 2 + 5
  self.point = {}
  for i = 1, 3 do
    local point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_1.png")
    point:setPosition(posx + i * width, 21)
    layBg:addChild(point)
    self.point[i] = point
  end
  self.pointMove = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_2.png")
  self.pointMove:setPosition(self.point[1]:getPosition())
  layBg:addChild(self.pointMove)
end

function heroDetailAstrolabeRulePop:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.bg,
    key = "out_click",
    clickHandler = function()
      for i = 1, 3 do
        if self.index ~= i then
          self["layer" .. i]:removeAllChildrenWithCleanup(true)
        end
      end
      self:destroy({skipAnim = false})
    end
  })
  ed.UITool.registerBtn(self, "arrow_left", function()
    self:listMove(-1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "arrow_right", function()
    self:listMove(1)
  end, {pressScale = 0.95})
  local moveing = false
  local container = CCLayer:create()
  container:registerScriptTouchHandler(function(event, x, y)
    if event == "began" then
      self.posX = x
      return ed.containsPoint(self.ui.bg, x, y)
    elseif event == "moved" then
      local toPosx = self.posX - x
      if math.abs(toPosx) > 200 and not moveing then
        self:listMove(0 < toPosx and 1 or -1)
        self.posX = x
        moveing = true
      end
    elseif event == "ended" then
      local toPosx = self.posX - x
      if math.abs(toPosx) > 50 and not moveing then
        self:listMove(0 < toPosx and 1 or -1)
        self.posX = x
      end
      moveing = false
    end
  end, false, -300, false)
  container:setContentSize(CCSizeMake(600, 350))
  self.ui.bg:addChild(container)
  self.touchLayer = container
  self.touchLayer:setTouchEnabled(true)
end

function heroDetailAstrolabeRulePop:listMove(up)
  local index = ed.clamp(self.index + up, 1, 3)
  if index ~= self.index then
    self.index = index
    for i = 1, 3 do
      self["layer" .. i]:stopAllActions()
      self["layer" .. i]:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp((i - index) * 640 + 7, 10))))
      self.ui.arrow_left:setVisible(1 < index)
      self.ui.arrow_right:setVisible(index < 3)
      self.pointMove:stopAllActions()
      self.pointMove:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(self.point[self.index]:getPositionX(), 21))))
    end
    if self.index == 1 then
      self.refreshCliprectConfig = {
        draglist = self.page1Draglist
      }
    elseif self.index == 2 then
      self.refreshCliprectConfig = {
        draglist = self.draglist
      }
    else
      self.refreshCliprectConfig = {
        draglist = self.page2Draglist
      }
    end
  end
  self.labelTitle:setString(self.labelTitleStr[self.index])
end

function heroDetailAstrolabeRulePop:addPage1()
  local layer = CCLayer:create()
  layer:setContentSize(CCSizeMake(630, 330))
  self.layer1 = layer
  layer:setPosition(ccp((self.index - 1) * 640 + 7, 10))
  self.clipLayer:addChild(layer)
  local thisCon = layer:getContentSize()
  self.page1Draglist = ed.UITool.createDraglist(layer, {
    bar = {
      bgpos = ccp(620, 165)
    }
  })
  self.refreshCliprectConfig = {
    draglist = self.page1Draglist
  }
  local text = T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\230\152\159\231\155\152\231\154\132\231\173\137\231\186\167\228\184\138\233\153\144\228\184\18680\231\186\167<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\233\128\154\232\191\135\229\141\160\230\152\159\230\143\144\229\141\135\230\152\159\231\155\152\231\173\137\231\186\167\239\188\140\228\184\148\232\167\163\233\148\129\229\146\140\229\136\183\230\150\176\232\175\141\230\157\161<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\177\233\155\132\230\175\143\230\151\16505:00\232\142\183\229\190\15110\230\172\161\229\141\160\230\152\159\230\172\161\230\149\176\239\188\140\230\175\143\228\184\170\232\139\177\233\155\132\231\154\132\229\141\160\230\152\159\230\172\161\230\149\176\230\156\128\229\164\154\232\131\189\231\167\175\231\180\17530\230\172\161<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\230\143\144\229\141\135\230\152\159\231\155\152\231\173\137\231\186\167\228\188\154\232\142\183\229\190\151\229\138\155\233\135\143\227\128\129\230\153\186\229\138\155\227\128\129\230\149\143\230\141\183\231\154\132\229\155\186\229\174\154\229\138\160\230\136\144<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\232\175\141\230\157\161\228\184\186\233\154\143\230\156\186\229\177\158\230\128\167\239\188\140\230\156\128\229\164\154\230\139\165\230\156\1375\230\157\161\229\177\158\230\128\167<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\232\175\141\230\157\161\229\136\183\230\150\176\229\144\142\239\188\140\233\152\159\233\149\191\229\143\175\228\187\165\233\128\137\230\139\169\230\152\175\229\144\166\228\191\157\229\173\152<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\233\152\159\233\149\191\229\143\175\228\187\165\233\148\129\229\174\154\233\131\168\229\136\134\232\175\141\230\157\161\229\144\142\232\191\155\232\161\140\229\141\160\230\152\159\239\188\140\233\148\129\229\174\154\231\154\132\232\175\141\230\157\161\229\176\134\228\184\141\228\188\154\229\143\145\231\148\159\229\143\152\229\140\150\239\188\140\230\156\128\229\164\154\229\143\175\228\187\165\233\148\129\229\174\1544\228\184\170\232\175\141\230\157\161<br/><br/>") .. T("  <sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\228\184\170\229\177\158\230\128\167\230\156\128\229\164\154\229\143\170\232\131\189\230\139\165\230\156\1371\230\157\161\239\188\140\229\141\179\228\184\141\228\188\154\229\144\140\230\151\182\229\173\152\229\156\168\231\155\184\229\144\140\231\154\132\229\177\158\230\128\167\231\177\187\229\158\139<br/><br/>")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({context = text, maxWidth = 610})
  local _, sizeH = autoText:getContentSize()
  autoText.node:setPosition(ccp(10, 310))
  self.page1Draglist:addItem(autoText.node)
  self.page1Draglist:initListHeight(sizeH + 40)
end

function heroDetailAstrolabeRulePop:addPage2()
  local layer = CCLayer:create()
  layer:setContentSize(CCSizeMake(600, 330))
  layer:setPosition(ccp((2 - self.index) * 640 + 7, 0))
  self.layer2 = layer
  self.clipLayer:addChild(layer)
  local layer = CCLayer:create()
  layer:setContentSize(CCSizeMake(600, 340))
  layer:setPosition(ccp(10, -10))
  self.layer2:addChild(layer)
  self.draglist = ed.UITool.createDraglist(layer, {
    bar = {
      bgpos = ccp(602, 165),
      alwaysShow = true
    }
  })
  local leftPosy, toMovePoxY = 328, false
  for i, v in ipairs(self.param.allAttrs or {}) do
    local descBg = ed.createScale9Sprite(string.format("UI/alpha/1080P/shard/levelpreview_%d.png", i == self.hero.level and 2 or 3), CCRectMake(8, 8, 20, 20))
    descBg:setAnchorPoint(ccp(0, 1))
    descBg:setContentSize(CCSizeMake(90, 35 * #v))
    descBg:setPosition(ccp(2, leftPosy))
    self.draglist.listLayer:addChild(descBg)
    local clipLayer = CCLayer:create()
    descBg:addChild(clipLayer)
    clipLayer:setClipRect(CCRectMake(0, 0, 90, 35 * #v))
    local fa = ed.createSprite(string.format("UI/alpha/1080P/shard/shading_%d.png", i == self.hero.level and 1 or 2))
    fa:setPosition(45, 35 * #v / 2)
    clipLayer:addChild(fa)
    self.localCreatettf({
      txt = ed.formatLevel("LV.") .. i,
      size = 17,
      pos = ccp(45, 35 * #v / 2),
      color = i == self.hero.level and ccc3(254, 211, 109) or ccc3(245, 221, 183),
      parent = descBg,
      stroke = {
        color = ccc3(41, 27, 27),
        size = 1.5
      }
    }):setFontName(ed.fontBold)
    if i == self.hero.level then
      toMovePoxY = math.abs(leftPosy - 318) - 160 + 35 * #v / 2
    end
    local localPosy = leftPosy
    for _, vv in ipairs(v) do
      local rigDescBg = ed.createScale9Sprite(string.format("UI/alpha/1080P/shard/levelpreview_%d.png", i == self.hero.level and 3 or 1), CCRectMake(8, 8, 20, 20))
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
        color = i == self.hero.level and ccc3(251, 219, 106) or ccc3(243, 220, 181),
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
        color = i == self.hero.level and ccc3(251, 219, 106) or ccc3(243, 220, 181),
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
  self.draglist:initListHeight(math.abs(leftPosy) + 333 + 20)
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

function heroDetailAstrolabeRulePop:addPage3()
  local layer = CCLayer:create()
  layer:setContentSize(CCSizeMake(600, 330))
  self.layer3 = layer
  layer:setPosition(ccp((3 - self.index) * 640 + 7, 10))
  self.clipLayer:addChild(layer)
  local thisCon = layer:getContentSize()
  self.page2Draglist = ed.UITool.createDraglist(layer, {
    bar = {
      bgpos = ccp(620, 165)
    }
  })
  ed.createLabelTools({
    txt = T("\230\152\159\231\155\152\231\173\137\231\186\167\232\182\138\233\171\152\239\188\140\229\143\175\229\136\183\229\135\186\231\154\132\229\177\158\230\128\167\229\147\129\232\180\168\232\182\138\229\165\189"),
    size = 16,
    pos = ccp(300, 310),
    color = ed.toccc3(16710632),
    parent = self.page2Draglist.listLayer
  })
  local astrolabeInfo = ed.getDataTable("Astrolabe")[self.param.hero.hid]
  local weight
  for i = 1, 5 do
    if self.param.hero.level >= astrolabeInfo["Rank " .. i .. " Level"] then
      weight = i
    end
  end
  local weightStrs = {
    {
      T("\231\187\191"),
      ed.toccc3(9303158)
    },
    {
      T("\232\147\157"),
      ed.toccc3(6797817)
    },
    {
      T("\231\180\171"),
      ed.toccc3(15570943)
    },
    {
      T("\230\169\153"),
      ed.toccc3(16700269)
    },
    {
      T("\231\187\191"),
      ed.toccc3(16734039)
    }
  }
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_1.png",
    pos = ccp(170, 210),
    parent = self.page2Draglist.listLayer,
    scale = 1,
    rectMake = CCRectMake(50, 28, 13, 2),
    sizeMake = CCSizeMake(280, 160),
    notShow = true
  })
  self.notTop = weight ~= 5
  if weight then
    bg:setVisible(true)
    ed.createLabelTools({
      txt = T("\229\189\147\229\137\141\229\141\160\230\152\159\231\154\132\229\177\158\230\128\167\229\147\129\232\180\168\230\166\130\231\142\135"),
      size = 14,
      pos = ccp(140, 144),
      color = ed.toccc3(12958964),
      stroke = {
        ed.toccc3(2565412),
        1.5
      },
      parent = bg
    })
    weight = ed.getDataTable("AstrolabeRandomAttr")[astrolabeInfo["Level Group"]][1]["Rank " .. weight .. " Weight"]
    local alls = 0
    for k, v in pairs(weight) do
      alls = alls + v
    end
    for i, v in ipairs(weightStrs) do
      if weight[i] then
        ed.createLabelTools({
          txt = v[1],
          size = 14,
          pos = ccp(40, 140 - i * 30),
          color = v[2],
          parent = bg
        })
        ed.createLabelTools({
          txt = weight[i] / alls * 100 .. "%",
          size = 14,
          pos = ccp(240, 140 - i * 30),
          color = v[2],
          parent = bg,
          anchor = ccp(1, 0.5)
        })
        ed.createSpriteTools({
          res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_2.png",
          pos = ccp(140, 140 - i * 30 - 10),
          parent = bg,
          rectMake = CCRectMake(1, 1, 1, 1),
          sizeMake = CCSizeMake(250, 1)
        })
      end
    end
  end
  if self.notTop then
    local bg2 = ed.createSpriteTools({
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_1.png",
      pos = ccp(460, 210),
      parent = self.page2Draglist.listLayer,
      scale = 1,
      rectMake = CCRectMake(50, 28, 13, 2),
      sizeMake = CCSizeMake(280, 160)
    })
    if not weight then
      bg2:setPositionX(300)
    end
    ed.createLabelTools({
      txt = T("\230\152\159\231\155\15280\231\186\167\229\144\142\229\141\160\230\152\159\231\154\132\229\177\158\230\128\167\229\147\129\232\180\168\230\166\130\231\142\135"),
      size = 14,
      pos = ccp(140, 144),
      color = ed.toccc3(12958964),
      stroke = {
        ed.toccc3(2565412),
        1.5
      },
      parent = bg2
    })
    local weight = ed.getDataTable("AstrolabeRandomAttr")[astrolabeInfo["Level Group"]][1]["Rank 5 Weight"]
    local alls = 0
    for k, v in pairs(weight) do
      alls = alls + v
    end
    for i, v in ipairs(weightStrs) do
      if weight[i] then
        ed.createLabelTools({
          txt = v[1],
          size = 14,
          pos = ccp(40, 140 - i * 30),
          color = v[2],
          parent = bg2
        })
        ed.createLabelTools({
          txt = weight[i] / alls * 100 .. "%",
          size = 14,
          pos = ccp(240, 140 - i * 30),
          color = v[2],
          parent = bg2,
          anchor = ccp(1, 0.5)
        })
        ed.createSpriteTools({
          res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_2.png",
          pos = ccp(140, 140 - i * 30 - 10),
          parent = bg2,
          rectMake = CCRectMake(1, 1, 1, 1),
          sizeMake = CCSizeMake(250, 1)
        })
      end
    end
  else
    bg:setPositionX(300)
  end
  local bg3 = ed.createSpriteTools({
    res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_1.png",
    pos = ccp(315, 95),
    parent = self.page2Draglist.listLayer,
    scale = 1,
    rectMake = CCRectMake(50, 28, 13, 2),
    sizeMake = CCSizeMake(570, 50)
  })
  local layer = CCLayer:create()
  bg3:addChild(layer)
  local res = ed.heroDetailManager.resConfig
  
  local function labelFunc(v, x, y, parent)
    ed.createLabelTools({
      txt = res.att_cn_name[v["Attr Type"]],
      size = 14,
      pos = ccp(x, y),
      color = ed.toccc3(16710632),
      parent = parent,
      anchor = ccp(0, 0.5)
    })
    ed.createLabelTools({
      txt = T("%s-%s", v["Value Quality 1"][1], v["Max Value"]),
      size = 14,
      pos = ccp(x + 200, y),
      color = ed.toccc3(16710632),
      parent = parent,
      anchor = ccp(1, 0.5)
    })
  end
  
  local y, two = 0, false
  for k, v in pairs(ed.getDataTable("AstrolabeRandomAttr")[astrolabeInfo["Level Group"]]) do
    labelFunc(v, two and 330 or 40, y, layer)
    ed.createSpriteTools({
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_2.png",
      pos = ccp(285, y - 12),
      parent = layer,
      rectMake = CCRectMake(1, 1, 1, 1),
      sizeMake = CCSizeMake(500, 1)
    })
    if two then
      y = y - 30
    end
    two = not two
  end
  y = y * -1
  bg3:setPositionY(95 - y / 2)
  layer:setPositionY(y)
  bg3:setContentSize(CCSizeMake(570, 50 + y))
  ed.createLabelTools({
    txt = T("\232\175\165\232\139\177\233\155\132\229\143\175\229\136\183\229\135\186\231\154\132\229\177\158\230\128\167\231\177\187\229\158\139\229\146\140\229\177\158\230\128\167\229\140\186\233\151\180"),
    size = 14,
    pos = ccp(285, 50 + y - 17),
    color = ed.toccc3(12958964),
    stroke = {
      ed.toccc3(2565412),
      1.5
    },
    parent = bg3
  })
  local sizeH = 280 + y
  self.page2Draglist:initListHeight(sizeH)
end
