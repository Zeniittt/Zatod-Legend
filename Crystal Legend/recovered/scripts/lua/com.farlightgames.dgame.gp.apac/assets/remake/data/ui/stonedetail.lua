local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.stonedetail = class
ed.ui.fragmentdetail = class

local function checkStageOpen(id)
  local star = ed.player:getStageStar(id) or 0
  local preStar = ed.player:getStageStar(id - 1) or 0
  if 0 < star + preStar then
    return true
  else
    return false
  end
end

class.checkStageOpen = checkStageOpen

local function createStoneAmount(self)
  if not tolua.isnull(self.amountContainer) then
    self.amountContainer:removeFromParentAndCleanup(true)
  end
  local amount, need = 0, 0
  if ed.itemType(self.id) == "hero" then
    amount = ed.readhero.getStoneAmount(self.id) or 0
    need = ed.readhero.getStoneNeed(self.id)
  else
    amount = ed.player.equip_qunty[self.sid] or 0
    need = self.need
  end
  if not need then
    return
  end
  local container = CCSprite:create()
  self.infoContainer:addChild(container)
  self.amountContainer = container
  local ec = ccc3(169, 91, 28)
  local nc = ccc3(226, 18, 18)
  local amountui = {}
  self.amountui = amountui
  local readnode = ed.readnode.create(container, amountui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "pre",
        text = "(",
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(100, 275)
      },
      config = {color = ec}
    },
    {
      t = "Label",
      base = {
        name = "amount",
        text = amount,
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {array = amountui, name = "pre"}
      },
      config = {
        color = amount < need and nc or ec
      }
    },
    {
      t = "Label",
      base = {
        name = "need",
        text = string.format("/%d)", need),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        right2 = {array = amountui, name = "amount"}
      },
      config = {color = ec}
    }
  }
  readnode:addNode(ui_info)
end

class.createStoneAmount = createStoneAmount

local function initWindow(self)
  local row = {}
  local name = ""
  if ed.itemType(self.id) == "hero" then
    row = ed.getDataTable("Unit")[self.id]
    name = row["Display Name"]
  elseif ed.itemType(self.id) == "equip" then
    row = ed.getDataTable("equip")[self.id]
    name = row.Name
  end
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/HVGA/fragment_compose_bg.png"
      },
      layout = {
        position = ccp(400, 242)
      }
    }
  }
  local readnode = ed.readnode.create(self.container, self.ui)
  readnode:addNode(ui_info)
  local container = ed.createNode({
    t = "Sprite",
    base = {},
    layout = {
      position = ccp(400, 242)
    },
    config = {
      scaleSize = CCSizeMake(285, 388)
    }
  }, self.container, 5)
  self.infoContainer = container
  ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = name,
        size = 18
      },
      layout = {
        position = ccp(142, 350)
      },
      config = {
        color = ccc3(184, 6, 6)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(280, 365)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/1080P/common/herodetail-detail-close-p.png",
        parent = "close"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(142, 55)
      },
      config = {
        scaleSize = CCSizeMake(200, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "ok"
      },
      layout = {mediate = true},
      config = {
        scaleSize = CCSizeMake(200, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T("\232\191\148\229\155\158"),
        size = 18,
        parent = "ok",
        z = 1
      },
      layout = {mediate = true}
    }
  }
  readnode = ed.readnode.create(container, self.ui)
  readnode:addNode(ui_info)
  local icon = ed.readequip.createIcon(self.sid)
  self.ui.icon = icon
  icon:setPosition(ccp(60, 290))
  container:addChild(icon)
  local ui = self.ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "gw_title",
        text = T("\232\142\183\229\190\151\233\128\148\229\190\132\239\188\154"),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(100, 300)
      },
      config = {
        color = ccc3(203, 128, 91)
      }
    }
  }
  readnode:addNode(ui_info)
end

class.initWindow = initWindow

local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(0, 85, 800, 165),
    noshade = true,
    priority = -165,
    container = self.infoContainer
  }
  self.draglist = ed.draglist.create(info)
end

class.createListLayer = createListLayer
local howToGet = {
  [T("\229\143\175\228\187\142\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151\229\133\145\230\141\162\232\142\183\229\190\151")] = 15,
  [T("\229\143\175\228\187\142\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\232\161\165\231\187\153\231\171\153\229\133\145\230\141\162\232\142\183\229\190\151")] = 4,
  [T("\229\143\175\228\187\142\230\176\184\231\148\159\230\162\166\229\162\131\229\149\134\229\186\151\229\133\145\230\141\162\232\142\183\229\190\151")] = 11,
  [T("\229\143\175\228\187\142\229\133\172\228\188\154\229\149\134\229\186\151\229\133\145\230\141\162\232\142\183\229\190\151")] = 7,
  [T("\229\143\175\228\187\142\231\171\158\230\138\128\229\156\186\229\134\155\233\156\128\229\149\134\229\186\151\229\133\145\230\141\162\232\142\183\229\190\151")] = 5,
  [T("\231\153\190\232\180\167\229\176\143\229\186\151\232\180\173\228\185\176")] = 1
}
local howToGetPlus = {
  [T("\233\173\130\229\140\163\229\143\172\229\148\164\232\142\183\229\143\150")] = {
    icon = "UI/alpha/HVGA/todolist_icon_soul_box_coupon.png",
    title = T("\233\173\130\229\140\163\229\143\172\229\148\164\232\142\183\229\143\150"),
    clickCallback = function(args)
      local canOpenTavern = ed.playerlimit.checkAreaUnlock("tavern")
      if canOpenTavern then
        local tavernScene = ed.ui.tavernScene.create()
        ed.pushScene(tavernScene)
        tavernScene:addFingerToMagicHeroBoxBtn()
      else
        ed.showToast(T("\229\143\172\229\148\164\230\179\149\233\152\181\230\156\170\229\188\128\230\148\190"))
      end
    end
  },
  [T("\230\138\171\232\144\168\229\149\134\229\186\151\232\142\183\229\143\150")] = {
    icon = "UI/alpha/HVGA/todolist_icon_tavern.png",
    title = T("\230\138\171\232\144\168\229\149\134\229\186\151\232\142\183\229\143\150"),
    clickCallback = function(args)
      local canOpenTavern = ed.playerlimit.checkAreaUnlock("tavern")
      if canOpenTavern then
        local tavernScene = ed.ui.tavernScene.create()
        ed.pushScene(tavernScene)
        tavernScene:addFingerToNewMagicHeroBoxBtn()
        tavernScene:makeDraglistRightMost()
      else
        ed.showToast(T("\229\143\172\229\148\164\230\179\149\233\152\181\230\156\170\229\188\128\230\148\190"))
      end
    end
  },
  [T("\230\152\159\233\153\133\230\151\133\232\161\140\229\149\134\228\186\186")] = {
    icon = "UI/alpha/HVGA/shop_head_star.png",
    title = T("\230\152\159\233\153\133\230\151\133\232\161\140\229\149\134\228\186\186"),
    clickCallback = function(args)
      local canOpenStarshop = ed.playerlimit.checkAreaUnlock("starshop")
      if canOpenStarshop then
        ed.pushScene(ed.ui.shop.create(ed.ui.marketconfig.shopName2IdTbl.hideStar, {enter = true}))
      else
        ed.showToast(T("\230\152\159\233\153\133\230\151\133\232\161\140\229\149\134\228\186\186\230\156\170\229\188\128\230\148\190"))
      end
    end
  },
  [T("\230\179\176\229\157\166\231\178\190\229\141\142\229\133\145\230\141\162")] = {
    icon = "UI/alpha/HVGA/titan_altar/titan_coin.png",
    title = T("\230\179\176\229\157\166\231\178\190\229\141\142\229\133\145\230\141\162"),
    clickCallback = function(args)
      local level = ed.player:getLevel()
      if level < 100 then
        ed.showToast(T("\230\179\176\229\157\166\231\165\173\229\157\155\230\156\170\229\188\128\230\148\190"))
        return
      end
      ed.TitanNetwork:openPanel(args.id)
    end
  }
}

local function bookDisplayOrderToChapterInfo(displayOrder)
  local table = ed.getDataTable("BooksChapter")
  for k, v in pairs(table) do
    if v["Display Order"] == displayOrder then
      return k, v.Icon
    end
  end
  return 0, ""
end

local function createList(self)
  local container = self.draglist:getList()
  local ox, oy = 142, 220
  local row = ed.getDataTable("equip")[self.sid] or {}
  local emptyList = true
  local getway = {}
  local et = ed.getDataTable("equip")[self.sid]
  local tg = et.Drop
  for i, v in ipairs(tg) do
    if v and 0 < v then
      table.insert(getway, v)
    end
  end
  self.getways = {}
  for i = 1, #(getway or {}) do
    local id = getway[i]
    self.getways[i] = {}
    self.getways[i].id = id
    local readnode = ed.readnode.create(container, self.getways[i])
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "board",
          res = "UI/alpha/HVGA/equip_craft_getway_board.png"
        },
        layout = {
          position = ccp(ox, oy)
        },
        config = {isCascadeOpacity = true}
      }
    }
    readnode:addNode(ui_info)
    local board = self.getways[i].board
    local st = ed.getDataTable("Stage")
    local row = st[id]
    local isElite = ed.stageType(id) == "elite"
    readnode = ed.readnode.create(board, self.getways[i])
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "icon",
          res = ed.ui.stageselectres.getStageIcon(id)
        },
        layout = {
          position = ccp(35, 25)
        },
        config = {fix_height = 75}
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T("\194\183\231\172\172%d\231\171\160", row["Chapter ID"]),
          size = 18,
          skipFormat = true
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(65, 35)
        },
        config = {
          color = ccc3(182, 65, 21)
        }
      },
      {
        t = "Label",
        base = {
          name = "elite",
          text = T("\231\178\190\232\139\177"),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          right2 = {
            array = self.getways[i],
            name = "title",
            offset = 10
          }
        },
        config = {
          color = ccc3(255, 0, 0),
          visible = isElite
        }
      },
      {
        t = "Label",
        base = {
          name = "name",
          text = row["Stage Name"],
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(68, 12)
        },
        config = {
          color = ccc3(182, 65, 21)
        }
      }
    }
    readnode:addNode(ui_info)
    local ui = self.getways[i]
    local oriScale = ui.icon:getScale()
    self:btRegisterButtonClick({
      button = board,
      pressHandler = function()
        ui.icon:setScale(oriScale * 0.95)
      end,
      cancelPressHandler = function()
        ui.icon:setScale(oriScale)
      end,
      clickHandler = function()
        local st = ed.stageType(ui.id)
        if ed.isElementInTable(st, {"normal", "elite"}) then
          if checkStageOpen(id) then
            ed.pushScene(ed.ui.stageselect.createByStage(ui.id))
          else
            ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
          end
        end
      end,
      clickInterval = 0.5,
      force = true,
      key = "getway" .. i
    })
    oy = oy - 50
  end
  local htgs = row["How To Get"]
  for i = 1, #(htgs or {}) do
    local htg = htgs[i]
    local conf
    local fix_height = 60
    if howToGet[htg] then
      local shopid = howToGet[htg]
      local shopConfig = ed.ui.marketconfig.getShopCfg(shopid)
      conf = {
        icon = shopConfig.shopHeadRes,
        title = T(shopConfig.shopName),
        clickCallback = function()
          if ed.player:checkShopValid(shopid) then
            ed.pushScene(ed.ui.shop.create(shopid))
          else
            ed.showToast(T("\229\149\134\229\186\151\230\156\170\229\188\128\230\148\190"))
          end
        end
      }
    end
    if howToGetPlus[htg] then
      conf = howToGetPlus[htg]
      fix_height = 40
    end
    local matchBook = string.match(htg, "\229\139\135\232\128\133\228\185\139\228\185\166(%d+)\232\142\183\229\143\150")
    if matchBook then
      local bookDisplayOrder = tonumber(matchBook)
      local chapterId, iconPath = bookDisplayOrderToChapterInfo(bookDisplayOrder)
      conf = {
        icon = iconPath,
        title = T("\229\139\135\232\128\133\228\185\139\228\185\166\232\142\183\229\143\150"),
        clickCallback = function()
          local canOpenBook = ed.playerlimit.checkAreaUnlock("multistage")
          if canOpenBook then
            ed.multistage.manager:openPanel(chapterId)
          else
            ed.showToast(T("\229\139\135\232\128\133\228\185\139\228\185\166\230\156\170\229\188\128\230\148\190"))
          end
        end
      }
    end
    if conf then
      emptyList = false
      local ui = {}
      local readnode = ed.readnode.create(container, ui)
      local ui_info = {
        {
          t = "Sprite",
          base = {
            name = "board",
            res = "UI/alpha/HVGA/equip_craft_getway_board.png"
          },
          layout = {
            position = ccp(ox, oy)
          },
          config = {isCascadeOpacity = true}
        }
      }
      readnode:addNode(ui_info)
      local board = ui.board
      readnode = ed.readnode.create(board, ui)
      ui_info = {
        {
          t = "Sprite",
          base = {
            name = "icon",
            res = conf.icon
          },
          layout = {
            position = ccp(35, 28)
          },
          config = {fix_height = fix_height}
        },
        {
          t = "Label",
          base = {
            name = "title",
            text = T(conf.title),
            size = 18,
            skipFormat = true
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(65, 25)
          },
          config = {
            color = ccc3(182, 65, 21)
          }
        }
      }
      readnode:addNode(ui_info)
      local oriScale = ui.icon:getScale()
      self:btRegisterButtonClick({
        button = board,
        pressHandler = function()
          ui.icon:setScale(oriScale * 0.95)
        end,
        cancelPressHandler = function()
          ui.icon:setScale(oriScale)
        end,
        clickHandler = function()
          conf.clickCallback({
            sid = self.sid,
            id = self.id
          })
        end,
        clickInterval = 0.5,
        force = true,
        key = "howToGet" .. i
      })
      oy = oy - 50
    else
      self.emptyPrompt = htg
    end
  end
  local draglistHeight = 55 * (#(getway or {}) + #(htgs or {}))
  self.draglist:initListHeight(draglistHeight)
  self:refreshGetwayLimit()
  local num = math.max(draglistHeight - 235 + (self.waysNum - 3) * 55, 0)
  if #getway <= 0 and emptyList then
    self:createEmptyPrompt()
  end
end

class.createList = createList

local function setListLayerHeight(self, num)
  local ll = self.draglist:getList()
  local x, y = ll:getPosition()
  local bp = ccp(x, y)
  ll:setPosition(bp)
  local ep = ccp(x, num)
  ll:setPosition(ep)
  if ll:getPositionY() > 0 then
    self.draglist:refreshShade()
  end
end

class.setListLayerHeight = setListLayerHeight

local function refreshGetwayLimit(self)
  local ec = ccc3(169, 91, 28)
  local nc = ccc3(226, 18, 18)
  self.waysNum = 0
  for i = 1, #self.getways do
    local gw = self.getways[i]
    local id = gw.id
    local board = gw.board
    local name = gw.name
    if not tolua.isnull(gw.limitContainer) then
      gw.limitContainer:removeFromParentAndCleanup(true)
    end
    local readnode = ed.readnode.create(board, gw)
    local ui
    local nodes = {}
    if checkStageOpen(id) then
      local limit = ed.getDataTable("Stage")[id]["Daily Limit"] or 0
      local s = ed.elite2NormalStage(id)
      local count = limit - ((ed.player.stage_limit or {})[s] or 0)
      if 0 < limit then
        ui = {
          {
            t = "Label",
            base = {text = "\239\188\136", size = 16},
            layout = {},
            config = {color = ec}
          },
          {
            t = "Label",
            base = {text = count, size = 16},
            layout = {},
            config = {
              color = 0 < count and ec or nc
            }
          },
          {
            t = "Label",
            base = {
              text = string.format("/%d\239\188\137", limit),
              size = 16
            },
            layout = {},
            config = {color = ec}
          }
        }
      end
      self.waysNum = self.waysNum + 1
    else
      ui = {
        {
          t = "Label",
          base = {
            text = T("\239\188\136\230\156\170\229\188\128\230\148\190\239\188\137"),
            size = 16
          },
          layout = {},
          config = {color = nc}
        }
      }
    end
    self.waysNum = self.waysNum + #(htgs or {})
    if ui then
      local ui_info = {
        {
          t = "HorizontalNode",
          base = {
            name = "limitContainer"
          },
          layout = {
            anchor = ccp(0, 0.5)
          },
          config = {},
          ui = ui
        }
      }
      readnode:addNode(ui_info)
      gw.limitContainer:setPosition(ed.getRightSidePos(gw.elite))
    end
  end
end

class.refreshGetwayLimit = refreshGetwayLimit

local function createEmptyPrompt(self)
  local ui = self.ui
  local bg = self.infoContainer
  local readnode = ed.readnode.create(bg, ui)
  local text
  if ed.itemType(self.id) == "hero" then
    text = T("\232\175\165\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179\230\154\130\228\184\141\231\148\177\229\133\179\229\141\161\230\142\137\232\144\189")
  else
    text = T("\232\175\165\231\162\142\231\137\135\230\154\130\228\184\141\231\148\177\229\133\179\229\141\161\230\142\137\232\144\189")
  end
  local gt = self.emptyPrompt or text
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "empty_prompt",
        text = gt,
        size = 18
      },
      layout = {
        position = ccp(142, 180)
      },
      config = {
        color = ccc3(238, 204, 119),
        dimension = CCSizeMake(240, 0),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  }
  readnode:addNode(ui_info)
end

class.createEmptyPrompt = createEmptyPrompt

local function create(param)
  local self = base.create("stonedetail")
  setmetatable(self, class.mt)
  param = param or {}
  self.destroyCallback = param.callback
  self.isSkipTransAnim = true
  local id = param.id
  self.id = id
  if ed.itemType(id) == "hero" then
    self.sid = ed.readhero.getStoneid(id)
  elseif ed.itemType(id) == "equip" then
    local row = ed.getDataTable("equipcraft")[id] or {}
    if row.Component2 > 0 then
      EDLog("<error>the equip can not composed by fragment.")
      return
    end
    self.sid = (ed.getDataTable("equipcraft")[id] or {}).Component1
    self.need = row["Component1 Count"]
  end
  self:initWindow()
  self:createListLayer()
  self:createList()
  self:registerTouchHandler()
  self:registerOnEnterHandler("enter_stone_detail", function()
    self:createStoneAmount()
    self:refreshGetwayLimit()
  end)
  self:show()
  return self
end

class.create = create

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "ok_button",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      self:destroy()
    end,
    force = true,
    priority = -1
  })
end

class.registerTouchHandler = registerTouchHandler
