local class = newclass()
ed.ui.equipboard = class

local function doFadeOut(self, callback)
  local fo = CCFadeOut:create(0.5)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  if not tolua.isnull(self.ui.frame) then
    self.ui.frame:runAction(ed.readaction.create({
      t = "seq",
      fo,
      func
    }))
  end
end

class.doFadeOut = doFadeOut

local function refreshAmount(self, isEquiped)
  local ui = self.ui
  local label = ui.amount_label
  local amount = ed.player.equip_qunty[self.param.id] or 0
  ed.setLabelString(label, amount)
  if amount == 0 then
    ed.setLabelColor(label, ccc3(255, 0, 0))
  else
    ed.setLabelColor(label, ccc3(0, 71, 188))
  end
  return amount
end

class.refreshAmount = refreshAmount

local function initAmount(self, addition)
  local amount = ed.player.equip_qunty[self.param.id] or 0
  local amountColor = ccc3(0, 71, 188)
  if amount == 0 then
    amountColor = ccc3(255, 0, 0)
  end
  local ui = self.ui
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "amount_title",
        text = T("\230\140\129\230\156\137\239\188\154"),
        size = 16
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(130, 255)
      },
      config = {
        color = ccc3(107, 97, 91)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = amount,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {
          name = "amount_title",
          offset = 2
        }
      },
      config = {color = amountColor}
    }
  }
  local readNode = ed.readnode.create(ui.frame, ui)
  readNode:addNode(ui_info)
end

class.initAmount = initAmount

local function createListLayer(self)
  local ui = self.ui
  local container = ui.frame
  local param = {
    cliprect = CCRectMake(14.5, 98.5, 230, 140),
    noshade = true,
    container = container,
    zorder = 10
  }
  local draglist = ed.draglist.create(param)
  self.draglist = draglist
  self:resgiterTouchHandlers("equip_list_touch", draglist:getListLayerTouchHandler())
end

class.createListLayer = createListLayer

local function createAttItem(self, index, desc)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.itemAtt)
  ui.bg:setVisible(index % 2 ~= 0)
  ui.bg1:setVisible(index % 2 == 0)
  ed.setString(ui.name, desc[1])
  ed.setString(ui.num, desc[2] or "")
  ed.setLabelStroke(ui.name, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.num, ccc3(23, 49, 31), 1)
  return container, ui
end

class.createAttItem = createAttItem

local function initAtt(self, addition)
  addition = addition or {}
  self:createListLayer()
  local param = self.param
  local id = param.id
  local amount = ed.player.equip_qunty[id] or 0
  local desc = ed.readequip.getDescriptionNew(id, param.level, 0)
  for i = 1, #desc do
    local att, ui = self:createAttItem(i, desc[i])
    att:setPosition(ccp(129.5, 252 - i * 27))
    self.draglist:addItem(att)
  end
  local totalHeight = #desc * 27
  local desStr = ed.readequip.value(id, "Description")
  local commentStr = ed.readequip.value(id, "Comment")
  if desStr then
    local desLabel = ed.createLabelTTF(desStr, 15)
    desLabel:setAnchorPoint(ccp(0.5, 0.5))
    desLabel:setColor(ccc3(61, 48, 36))
    desLabel:setDimensions(CCSizeMake(230, 0))
    desLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = desLabel:getContentSize().height
    local width = desLabel:getContentSize().width
    desLabel:setPosition(ccp(129.5, 252 - (totalHeight + height / 2 + 15)))
    self.draglist:addItem(desLabel)
    totalHeight = totalHeight + height + 4
  end
  if commentStr then
    local commentLabel = ed.createLabelTTF(commentStr, 15)
    commentLabel:setColor(ccc3(108, 92, 77))
    commentLabel:setDimensions(CCSizeMake(230, 0))
    commentLabel:setAnchorPoint(ccp(0.5, 0.5))
    commentLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = commentLabel:getContentSize().height
    commentLabel:setPosition(ccp(129.5, 252 - (totalHeight + height / 2 + 15)))
    self.draglist:addItem(commentLabel)
    totalHeight = totalHeight + height + 4
  end
  self.draglist:initListHeight(totalHeight)
end

class.initAtt = initAtt

local function refreshAtt(self)
  if self.ui.detail then
    self.ui.detail:removeFromParentAndCleanup(true)
  end
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  self:initAtt(self.addition)
end

class.refreshAtt = refreshAtt

local function initTitle(self, addition)
  addition = addition or {}
  local ui = self.ui
  local container = ui.container
  local titleContainer = ui.title_container
  if not tolua.isnull(titleContainer) and not addition.isFadeContainer then
    titleContainer:removeFromParentAndCleanup(true)
  end
  local titleContainer = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, container)
  ui.title_container = titleContainer
  local param = self.param
  local id = param.id
  local level = param.level or 0
  local hero = param.hero
  local sid = param.sid
  local context = param.context
  if 0 < level then
    ui.icon = ed.readequip.createIconWithLevel(id, level)
  else
    ui.icon = ed.readequip.createIcon(id)
  end
  ui.icon:setScale(0.9)
  ui.icon:setPosition(ccp(131, 332.5))
  titleContainer:addChild(ui.icon, 50)
  local name = ed.readequip.value(id, "Name")
  if ed.isComplexText(name) then
    ui.name = ed.createNode({
      t = "ComplexLabel",
      base = {text = name, size = 18},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 280)
      },
      config = {}
    }, titleContainer)
  else
    ui.name = ed.createNode({
      t = "Label",
      base = {text = name, size = 18},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 280)
      },
      config = {
        color = ccc3(255, 252, 231),
        stroke = {
          color = ccc3(39, 37, 36),
          size = 1
        }
      }
    }, titleContainer)
  end
  if param.level then
    local level_des = ed.ui.baseres.enhance_level_res
    local text = ""
    if 1 < ed.readequip.getMaxLevel(id) then
      text = T("\230\156\170\233\153\132\233\173\148")
    end
    if 1 <= level then
      text = level_des[level] or ""
    end
    text = T("")
    ui.level = ed.createNode({
      t = "Label",
      base = {text = text, size = 16},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 255)
      },
      config = {
        color = ccc3(103, 185, 249),
        stroke = {
          color = ccc3(ed.colorToStr("#161d31")),
          size = 1
        }
      }
    }, titleContainer)
  end
end

class.initTitle = initTitle

local function showItemRefresh(self, id)
  self.showId = self.showId or self.param.id
  local oldAddition = self.param.id
  self.param.id = id or self.showId
  if oldAddition ~= self.param.id then
    if not self.addition.ignoreTitle then
      self:initTitle()
    end
    if not self.addition.ignoreAtt then
      self:refreshAtt()
    end
    self:refreshAmount()
  end
end

class.showItemRefresh = showItemRefresh

local function initContainer(self, addition)
  local fade_gap = 0.1
  addition = addition or {}
  local ui = self.ui
  local frame = ui.frame
  local container = ui.container
  if not tolua.isnull(container) then
    if addition.isFade then
      local fo = CCFadeOut:create(fade_gap)
      local callback = CCCallFunc:create(function()
        container:removeFromParentAndCleanup(true)
      end)
      container:runAction(ed.readaction.create({
        t = "seq",
        fo,
        callback
      }))
    else
      container:removeFromParentAndCleanup(true)
    end
  end
  local container = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, frame)
  ui.container = container
  addition.isFadeContainer = addition.isFade
  if not addition.ignoreTitle then
    self:initTitle(addition)
  end
  if not addition.ignoreAtt then
    self:initAtt(addition)
  end
  if addition.isFade then
    container:setOpacity(0)
    container:runAction(ed.readaction.create({
      t = "seq",
      CCDelayTime:create(0),
      CCFadeIn:create(fade_gap)
    }))
  end
end

class.initContainer = initContainer

local function setCloseVisible(self, isVisible)
  self.ui.close:setVisible(isVisible)
end

class.setCloseVisible = setCloseVisible

local function playAttAnim(self, amount)
  amount = amount or 1
  local effect = ed.createFcaNode("eff_UI_skill_level_up")
  effect:setPosition(ccp(35, 35))
  self.ui.icon:addChild(effect)
  self:getScene():addFca(effect)
  local vital = ed.getDataTable("equip")[self.param.id].Vitality
  local label = ed.createNode({
    t = "Label",
    base = {
      text = T("\228\189\147\229\138\155+") .. vital * amount,
      size = 20
    },
    layout = {
      position = ccp(32, 35)
    },
    config = {
      color = ccc3(231, 206, 19),
      stroke = {
        color = ccc3(0, 0, 0),
        size = 2
      },
      visible = false
    }
  }, self.ui.icon)
  local a1 = CCDelayTime:create(0)
  local a2 = CCCallFunc:create(function()
    label:setVisible(true)
  end)
  local a3 = CCMoveTo:create(0.5, ccp(32, 70))
  local a4 = CCFadeOut:create(0.1)
  local a5 = CCCallFunc:create(function()
    label:removeFromParentAndCleanup(true)
  end)
  label:runAction(ed.readaction.create({
    t = "seq",
    a1,
    a2,
    a3,
    a4,
    a5
  }))
end

class.playAttAnim = playAttAnim

local function playResAnim(self, idx, val, num)
  local typeName = {
    wood = "\230\156\168\229\164\180",
    iron = "\231\148\159\233\147\129",
    crystal = "\230\176\180\230\153\182",
    sun = "\229\164\170\233\152\179\231\178\190\229\141\142",
    moon = "\230\150\176\230\156\136\231\178\190\229\141\142",
    star = "\230\153\168\230\152\159\231\178\190\229\141\142",
    legendArena = "\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186\230\140\145\230\136\152\230\172\161\230\149\176",
    skillPoint = "\230\138\128\232\131\189\231\130\185\230\149\176",
    pet_point = "\230\183\177\230\181\183\233\177\188\232\130\157\230\178\185",
    star_point = "\230\152\159\229\184\129",
    gcwpoint = "\229\156\163\229\159\159\229\184\129",
    legend_point = "\228\188\160\229\165\135\229\184\129",
    dreampoint = "\230\162\166\228\185\139\230\150\176\229\143\182",
    guildenergy = "\229\133\172\228\188\154\229\184\129",
    gvgpoint = "\230\136\152\229\156\186\229\184\129"
  }
  if tolua.isnull(self.ui.icon) then
    return
  end
  local effect = ed.createFcaNode("eff_UI_skill_level_up")
  effect:setPosition(ccp(35, 35))
  self.ui.icon:addChild(effect)
  self:getScene():addFca(effect)
  local type = val.type
  local amount = val.amount
  local numStr = ""
  if num and 1 < num then
    numStr = " x" .. num
  end
  local label = ed.createNode({
    t = "Label",
    base = {
      text = typeName[type] .. "+" .. amount .. numStr,
      size = 20
    },
    layout = {
      position = ccp(12, 35),
      anchor = ccp(0, 0.5)
    },
    config = {
      color = ccc3(231, 206, 19),
      stroke = {
        color = ccc3(0, 0, 0),
        size = 2
      },
      visible = false
    }
  }, self.ui.icon)
  local a1 = CCDelayTime:create(0.3 * (idx - 1))
  local a2 = CCCallFunc:create(function()
    label:setVisible(true)
  end)
  local a3 = CCMoveTo:create(0.5, ccp(12, 70))
  local a4 = CCFadeOut:create(0.1)
  local a5 = CCCallFunc:create(function()
    label:removeFromParentAndCleanup(true)
  end)
  label:runAction(ed.readaction.create({
    t = "seq",
    a1,
    a2,
    a3,
    a4,
    a5
  }))
end

class.playResAnim = playResAnim

local function initFrame(self, addition)
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  self.ui = ui
  self.container = container
  local readnode = ed.readnode.create(container, ui)
  addition = addition or {}
  self.addition = addition
  local ui = self.ui
  local frame = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_1.png", CCRectMake(25, 20, 50, 350))
  frame:setContentSize(CCSizeMake(260, 387))
  ui.frame = frame
  frame:setCascadeOpacityEnabled(true)
  frame:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
  if not addition.isFeralFrame then
    self.container:addChild(frame)
  end
  local readnode = ed.readnode.create(frame, ui)
  readnode:addNode({
    {
      t = "Sprite",
      base = {
        name = "deco_top",
        res = "UI/alpha/1080P/package/bg_deso.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 299)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "deco_mid",
        res = "UI/alpha/1080P/package/seg_normal.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 239.5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "deco_bottom",
        res = "UI/alpha/1080P/package/bg_bottom_deco.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(130, 45)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ImageView_11317",
        res = "UI/alpha/1080P/hero/equip/equip_tattoo_1.png",
        parent = "deco_bottom"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(114.5, 104.5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ImageView_11527",
        res = "UI/alpha/1080P/package/seg_normal.png",
        parent = "ImageView_11317"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(45.5, 1)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "icon_compose",
        res = "UI/alpha/1080P/hero/equip/equip_route_button.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(225, 355)
      }
    }
  })
  if not addition.ignoreClose then
    local readnode = ed.readnode.create(frame, ui)
    readnode:addNode({
      {
        t = "DGButton",
        base = {
          name = "close",
          normal = "UI/alpha/1080P/common/herodetail-detail-close.png",
          press = "UI/alpha/1080P/common/herodetail-detail-close-p.png"
        },
        layout = {
          position = ccp(286, 358)
        },
        config = {}
      }
    })
  end
  if not addition.ignoreContainer then
    self:initContainer(addition)
  end
end

class.initFrame = initFrame

local function init(t, param)
  if not class[t] then
    print("Invalid identity of equipboard!")
    return
  end
  return class[t].create(param)
end

class.init = init

local function resgiterTouchHandlers(self, key, handler)
  self.touchHandlers = self.touchHandlers or {}
  self.touchHandlers[key] = handler
end

class.resgiterTouchHandlers = resgiterTouchHandlers
