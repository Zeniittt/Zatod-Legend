local base = ed.ui.popwindow
local midasWin = newclass(base.mt)
ed.ui.midasWin = midasWin

function midasWin:getCost(times)
  times = times or 1
  local useCount = math.min(times, ed.player:getMidasMaxTimes() - ed.player:getMidasTimes())
  local freeTimes = 0
  if ed.player:isMonthCardValid("payed") then
    freeTimes = ed.getDataTable("MonthCard").Payed["Free Midas Times"]
  end
  self.costList = {}
  self.totalCost = 0
  local costTb = ed.getDataTable("GradientPrice")
  local usedTimes = ed.player:getMidasTimes()
  for i = 1, useCount do
    local cost = 0
    if freeTimes < usedTimes + i then
      cost = costTb[usedTimes + i].Midas
    end
    table.insert(self.costList, cost)
    self.totalCost = self.totalCost + cost
  end
  return useCount, self.totalCost, self:getAcquire() * useCount
end

function midasWin:getAcquire()
  local plt = ed.getDataTable("PlayerLevel")
  local mt = ed.getDataTable("Midas")
  local t = ed.player:getMidasTimes() + 1
  local yd = (mt[t] or {})["Yield 1"]
  if not yd then
    return 99999
  else
    local money = plt[ed.player:getLevel()]["Midas Money"] * yd
    return math.floor(money)
  end
end

function midasWin:playGetAcquireAnim(times, money, playDelay, isLast)
  local posX = ed.display.winSize.width / 2 - ed.display.halfFixedWidth
  
  local function getAction(config)
    if not config then
      return true
    end
    local node = config.node
    if tolua.isnull(node) then
      return true
    end
    local handler = config.handler
    local delay = config.delay
    local pd
    if playDelay then
      pd = CCDelayTime:create(playDelay)
    end
    local f1 = CCCallFunc:create(function()
      xpcall(function()
        node:setVisible(true)
      end, EDDebug)
    end)
    local s = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
    local d
    if delay then
      d = CCDelayTime:create(delay)
    end
    local func1 = CCCallFunc:create(function()
      xpcall(function()
        if handler then
          handler()
        end
      end, EDDebug)
    end)
    local m = CCMoveBy:create(1, ccp(0, 80))
    local f = CCFadeOut:create(1)
    local func2 = CCCallFunc:create(function()
      xpcall(function()
        node:removeFromParentAndCleanup(true)
      end, EDDebug)
    end)
    return ed.readaction.create({
      t = "seq",
      pd,
      f1,
      s,
      d,
      func1,
      {
        t = "sp",
        m,
        f
      },
      func2
    })
  end
  
  local times_res = {
    {},
    {
      text = T("\230\154\180\229\135\187x2"),
      color = ed.toccc3(16739803),
      strokeColor = ed.toccc3(16731014),
      strokeSize = 1
    },
    {
      text = T("\230\154\180\229\135\187x3"),
      color = ed.toccc3(16731014),
      strokeColor = ed.toccc3(5636120),
      strokeSize = 1
    },
    {
      text = T("\230\154\180\229\135\187x10"),
      color = ed.toccc3(16745293),
      strokeColor = ed.toccc3(5118976),
      strokeSize = 1
    },
    {
      text = T("\230\154\180\229\135\187x20"),
      color = ed.toccc3(16728128),
      strokeColor = ed.toccc3(4587520),
      strokeSize = 1
    }
  }
  if 1 < times then
    local cfg = times_res[times]
    local node = ed.createNode({
      t = "Label",
      base = {
        text = cfg.text,
        size = 17
      },
      layout = {
        position = ccp(posX, 320),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = cfg.color,
        stroke = {
          color = cfg.strokeColor,
          size = cfg.strokeSize
        }
      }
    }, self.container, 10)
    node:runAction(getAction({node = node, delay = 0.5}))
  end
  local node = ed.createNode({
    t = "Sprite",
    layout = {
      position = ccp(posX, 280)
    },
    config = {
      scale = 3,
      visible = false,
      isCascadeOpacity = true
    }
  }, self.container)
  local title = ed.createNode({
    t = "Label",
    base = {
      text = T("\232\142\183\229\190\151\233\135\145\233\146\177\239\188\154"),
      size = 23
    },
    layout = {
      anchor = ccp(1, 0.5)
    },
    config = {
      color = ed.toccc3(16769367),
      stroke = {
        color = ed.toccc3(2104347),
        size = 1.5
      }
    }
  }, node)
  local sc = ed.createNode({
    t = "CCNode",
    base = {
      node = ed.getNumberNode({
        text = tostring(money),
        folder = "midas",
        suffix = ".png"
      }).node
    },
    layout = {
      anchor = ccp(0, 0.5)
    },
    config = {isCascadeOpacity = true}
  }, node)
  node:runAction(getAction({node = node, delay = 0.2}))
end

function midasWin:doUseReply()
  local function handler(acquire, addition)
    xpcall(function()
      addition = addition or {}
      
      ed.ui.baselsr.create():report("useMidas")
      if self.refreshHandler then
        self.refreshHandler()
      end
      local history = {}
      for i, v in ipairs(acquire) do
        table.insert(history, {
          cost = self.costList[i],
          acquire = v._money,
          ratio = v._type
        })
      end
      self:createHistory(history, addition.animOriMoney)
      for i, v in ipairs(acquire) do
        self:playGetAcquireAnim(v._type, v._money, 0.4 * (i - 1), i == #acquire)
      end
      ed.setString(self.ui.label_num, string.format("%d/%d", ed.player:getMidasMaxTimes() - ed.player:getMidasTimes(), ed.player:getMidasMaxTimes()))
      self:getCost()
      ed.setString(self.ui.label_diamond, self.totalCost)
      ed.setString(self.ui.label_money, self:getAcquire())
    end, EDDebug)
  end
  
  return handler
end

function midasWin:doUse(times)
  times = times or 1
  if self.totalCost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
    return
  end
  
  local function consumeHandler()
    ed.registerNetReply("use_midas", self:doUseReply(), {
      cost = self.totalCost,
      times = times
    })
    local msg = ed.upmsg.midas()
    msg._times = times
    ed.send(msg, "midas")
  end
  
  if ed.isOpenConsumeTips() and self.totalCost > 0 then
    if ed.ui.consumeTipsWin.isEnableShowWin() then
      ed.UITool.openView("consumeTipsWin", {
        text = T("\230\152\175\229\144\166\232\138\177\232\180\185%s\233\146\187\231\159\179\228\189\191\231\148\168\231\130\185\233\135\145\230\137\139", self.totalCost),
        rightHandler = function()
          consumeHandler()
        end
      })
    else
      consumeHandler()
    end
  else
    consumeHandler()
  end
end

function midasWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
    if self.params.callback then
      self.params.callback()
    end
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_use", function()
    if ed.player:getMidasTimes() < ed.player:getMidasMaxTimes() then
      self:doUse()
    else
      ed.showToast(T("\231\130\185\233\135\145\230\137\139\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140"))
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_use_continue", function()
    self:createMultiWindow()
  end, {pressScale = 0.9})
end

function midasWin:initHistoryItemHandler()
  local function handler(param)
    if not param then
      return
    end
    local cost = param.cost
    local acquire = param.acquire
    local ratio = param.ratio
    local container = param.container
    local ratio_config = {
      [1] = {
        ratio = 1,
        color = ccc3(255, 104, 174),
        size = 20
      },
      [2] = {
        ratio = 2,
        color = ccc3(255, 104, 174),
        size = 20,
        textColor = ed.toccc3(16739803),
        text = T("\230\154\180\229\135\187x2"),
        stroke = {
          color = ed.toccc3(6357056),
          size = 1
        }
      },
      [3] = {
        ratio = 3,
        color = ccc3(255, 104, 174),
        size = 20,
        textColor = ed.toccc3(16731014),
        text = T("\230\154\180\229\135\187x3"),
        stroke = {
          color = ed.toccc3(5636120),
          size = 1
        }
      },
      [4] = {
        ratio = 10,
        color = ccc3(194, 91, 68),
        size = 21,
        textColor = ed.toccc3(16745293),
        text = T("\230\154\180\229\135\187x10"),
        stroke = {
          color = ed.toccc3(5118976),
          size = 1
        }
      },
      [5] = {
        ratio = 20,
        color = ccc3(194, 91, 68),
        size = 21,
        textColor = ed.toccc3(16728128),
        text = T("\230\154\180\229\135\187x20"),
        stroke = {
          color = ed.toccc3(4587520),
          size = 1
        }
      }
    }
    local rc = ratio_config[ratio]
    local ui_info = {
      t = "HorizontalNode",
      layout = {
        anchor = ccp(0, 1)
      },
      ui = {
        {
          t = "Label",
          base = {
            text = T(" "),
            size = 20
          },
          config = {
            color = ccc3(245, 221, 183)
          }
        }
      }
    }
    local icon = ed.createNode(ui_info, container)
    local atLabel = ed.ui.autoText.new()
    local atText = T("\228\189\191\231\148\168<diamond_label>\232\142\183\229\190\151<money_label>")
    local diamond_label = "<lable fontSize=f8> </lable><lable color=ccc3(50,223,253)>" .. cost .. "</lable><sprite src=UI/alpha/1080P/common/shop_token_icon.png  scale=0.7><lable fontSize=f8> </lable>"
    local money_label = "<lable fontSize=f8> </lable><sprite src=UI/alpha/1080P/common/goldicon_small.png  scale=0.9><lable color=ccc3(255,175,52)>" .. acquire .. "</lable>"
    atText = atText:gsub("<diamond_label>", diamond_label)
    atText = atText:gsub("<money_label>", money_label)
    atLabel:initParam({
      color = ccc3(245, 221, 183),
      context = atText,
      fontSize = 20
    })
    local atWid, atHei = atLabel:getCurContentSize()
    atLabel.node:setPosition(ccp(0, atHei * 0.5))
    icon:addChild(atLabel.node)
    if rc.text then
      local atSpec_label = ed.ui.autoText.new()
      atSpec_label:initParam({
        color = rc.textColor,
        strokeColor = rc.stroke.color,
        strokeSize = rc.stroke.size,
        context = rc.text,
        fontSize = 17
      })
      atSpec_label.node:setPosition(ccp(math.max(atWid + 10, resource_config.midas_crip_x or 250), atHei * 0.5))
      icon:addChild(atSpec_label.node)
    end
    return {icon = icon}
  end
  
  return handler
end

function midasWin:createMultiWindow()
  if ed.player:getMidasTimes() >= ed.player:getMidasMaxTimes() then
    ed.showToast(T("\231\130\185\233\135\145\230\137\139\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140"))
    return
  end
  local count, cost, acquire = self:getCost(5)
  ed.ui.multiMidas.create({
    count = count,
    cost = cost,
    acquire = acquire,
    parent = self
  })
end

function midasWin:refreshHistory(history, animOriMoney)
  local scrollView = self.scrollView
  
  local function playMoneyAnim(index)
    local acq = history[index].acquire
    if animOriMoney and acq then
      animOriMoney = animOriMoney + acq
      if self:getScene().updateMRV then
        self:getScene():updateMRV("money", animOriMoney)
      end
    end
  end
  
  local function loadItem(index)
    if index > #history then
      self:removeUpdateHandler("load_history")
      return
    end
    playMoneyAnim(index)
    local v = history[index]
    scrollView:push({
      cost = v.cost,
      acquire = v.acquire,
      ratio = v.ratio or 1
    })
  end
  
  local count = 0.4
  local index = 1
  self:registerUpdateHandler("load_history", function(dt)
    if tolua.isnull(self.mainLayer) then
      ed.player.addMoneySilent = nil
      self:removeUpdateHandler("load_history")
      return
    end
    count = count + dt
    if 0.4 < count then
      count = count - 0.4
      loadItem(index)
      index = index + 1
      scrollView:move2end(0.4)
    end
  end)
end

function midasWin:createHistory(history, animOriMoney)
  self.ui.bg_result:setVisible(false)
  local ui = self.ui
  if not tolua.isnull(ui.history_frame) then
    self:refreshHistory(history, animOriMoney)
    return
  end
  self.isSkipDestroyAnim = true
  local container = self.ui.bg
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "history_frame",
        res = "UI/alpha/1080P/common/mail_bj9_1.png",
        capInsets = CCRectMake(10, 17, 10, 130)
      },
      layout = {
        position = ccp(250, -63)
      },
      config = {
        scaleSize = CCSizeMake(500, 126)
      }
    }
  }
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ui_info)
  local text_height = {cn = 42, ko = 54}
  local oriPosX = (EDCurLanguage == "ko" or EDCurLanguage == "ja") and 100 or 160
  local info = {
    cliprect = ed.DGRectMake(35, 14, 950, 225),
    noshade = true,
    zorder = 5,
    container = ui.history_frame,
    priority = self.mainTouchPriority,
    direction = "v",
    oriPosition = ed.DGccp(oriPosX, 230),
    itemSize = ed.DGSizeMake(435, text_height[EDCurLanguage] or 42),
    initHandler = self:initHistoryItemHandler(),
    useBar = false,
    barPosition = "left",
    barLenOffset = -10,
    barPosOffset = ccp(-16, 0),
    barThick = 3,
    heightOffset = 5
  }
  local scrollView = ed.scrollview.create(info)
  self.scrollView = scrollView
  self:refreshHistory(history, animOriMoney)
end

function midasWin:initData(params)
  self.params = params or {}
  self.refreshHandler = self.params.refreshHandler
  self:getCost()
end

function midasWin:initLabels()
  ed.setLabelShadow(self.ui.Label_4438, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_num, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.Label_4442, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_diamond, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_money, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_use, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_use_continue, ccc3(0, 0, 0), ccp(0, 2))
  self.ui.Label_4438:limitWidthByScale(80)
  self.ui.Label_4442:limitWidthByScale(240)
end

function midasWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.MidasWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.label_diamond, self.totalCost)
  ed.setString(self.ui.label_money, self:getAcquire())
  ed.setString(self.ui.label_num, string.format("%d/%d", ed.player:getMidasMaxTimes() - ed.player:getMidasTimes(), ed.player:getMidasMaxTimes()))
end

local function dealUse(reply)
  local acquire = reply._acquire or {}
  local handler, data = ed.getNetReply("use_midas")
  local animOriMoney = ed.player._money
  if data then
    local money = 0
    for i, v in ipairs(acquire) do
      money = money + v._money
    end
    local cost = data.cost
    local times = data.times or 1
    ed.player:useMidasTimes(times)
    ed.player:addrmb(-cost)
    ed.player:addMoney(money, true)
  end
  if handler then
    handler(acquire, {animOriMoney = animOriMoney})
  end
  ed.record:refreshCommonRecord("midasUse")
end

midasWin.dealUse = dealUse

function midasWin.create(params)
  local self = base.create("midas")
  setmetatable(self, midasWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end
