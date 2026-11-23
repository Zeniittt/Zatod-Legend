local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fragmentcompose = class
local lsr = ed.ui.fragmentcomposelsr.create()

local function refreshFragmentAmount(self)
  self.info.fragmentAmount = self.info.fragmentAmount - self.info.needAmount * self.info.amount
  ed.setString(self.ui.amount_label, self.info.fragmentAmount)
  if self.info.fragmentAmount < self.info.needAmount then
    self.info.amountColor = ccc3(255, 0, 0)
  else
    self.info.amountColor = ccc3(169, 91, 28)
  end
  ed.setLabelColor(self.ui.amount_label, self.info.amountColor)
end

class.refreshFragmentAmount = refreshFragmentAmount

local function composeReply(self, id)
  local function handler(result, amount)
    self:refreshFragmentAmount()
    
    self:destroy()
    ed.showToast(T("\231\162\142\231\137\135\229\144\136\230\136\144\230\136\144\229\138\159"))
  end
  
  return handler
end

class.composeReply = composeReply

local function refreshCostColor(self)
  local function handler()
    local ui = self.ui
    
    local info = self.info
    if info.cost > ed.player._money then
      ed.setLabelColor(ui.cost, ccc3(232, 18, 18))
    else
      ed.setLabelColor(ui.cost, ccc3(182, 65, 21))
    end
  end
  
  return handler
end

class.refreshCostColor = refreshCostColor

local function doCompose(self)
  local ua = self.info.universalAmount
  if self.info.universalAmount > self.info.universalNeedAmount then
    ua = self.info.universalNeedAmount
  end
  if self.info.fragmentAmount + ua < self.info.needAmount then
    ed.showToast(T("\231\162\142\231\137\135\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\239\188\129"))
    return
  end
  if self.info.cost > ed.player._money then
    ed.showHandyDialog("useMidas", {
      refreshHandler = self:refreshCostColor()
    })
    return
  end
  if ed.itemType(self.info.makeId) == "hero" and ed.player.heroes[self.info.makeId] then
    ed.showToast(T("\229\183\178\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
    return
  end
  if self.info.makeEquipCategory == T("\228\185\166\230\156\172") and 0 < (ed.player.equip_qunty[self.info.makeId] or 0) then
    ed.showToast(T("\229\183\178\231\187\143\230\148\182\232\151\143\229\175\185\229\186\148\229\155\190\228\185\166\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144"))
    return
  end
  local fragmentAmount = self.info.fragmentAmount
  if self.info.fragmentAmount > self.info.needAmount then
    fragmentAmount = self.info.needAmount
  end
  local universalAmount = self.info.needAmount - self.info.fragmentAmount
  if universalAmount < 0 then
    universalAmount = 0
  end
  ed.netdata.fragmentCompose = {
    id = self.info.id,
    fragmentAmount = fragmentAmount * self.info.amount,
    universalAmount = universalAmount,
    cost = self.info.cost,
    makeId = self.info.makeId,
    composeResultAmount = self.info.amount
  }
  if self.package then
    ed.netreply.composeFragmentReply = self.package:downFragmentCompose()
  else
    ed.netreply.composeFragmentReply = ed.ui.package.downFragmentCompose(nil, self.info.makeId)
    self:destroy()
  end
  local craftId = self.info.makeId
  if ed.player:hasMaxAmount(craftId) then
    ed.showToast(T("\231\137\169\229\147\129\229\183\178\232\190\190\230\156\128\229\164\167\230\149\176\233\135\143\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\227\128\130"))
    return
  end
  local msg = ed.upmsg.fragment_compose()
  msg._fragment = craftId
  msg._frag_amount = fragmentAmount
  msg._compose_amount = self.info.amount
  ed.send(msg, "fragment_compose")
end

class.doCompose = doCompose

local function openGuideLayer(self)
  local fragmentGuideLayer = ed.ui.fragmentGuide.create(self.info.id)
  fragmentGuideLayer.package = self.package or {}
  ed.getCurrentScene():ccScene():addChild(fragmentGuideLayer.mainLayer, 120)
  fragmentGuideLayer.package.composeLayer = nil
  fragmentGuideLayer.destroyHandler = self.destroyHandler
end

class.openGuideLayer = openGuideLayer

local function registerTouchHandler(self)
  self:btRegisterOutClick({
    area = self.bg,
    key = "fragment_out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.ui.close,
    press = self.ui.close_down,
    key = "fragment_close_button",
    force = true,
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.fragmentIcon,
    pressScale = 0.95,
    key = "fragment_fragment_icon",
    force = true,
    clickHandler = function()
      self:openGuideLayer()
      self:destroy({skipAnim = true})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ok,
    press = self.ui.ok_down,
    key = "fragment_ok_button",
    force = true,
    clickHandler = function()
      self:doCompose()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.add,
    press = self.ui.add_press,
    key = "fragment_add_button",
    force = true,
    clickHandler = function()
      self:refreshAmount("1")
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.minus,
    press = self.ui.minus_press,
    force = true,
    key = "fragment_minus_button",
    clickHandler = function()
      self:refreshAmount("-1")
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.max,
    press = self.ui.max_press,
    force = true,
    key = "fragment_max_button",
    clickHandler = function()
      self:refreshAmount("999")
    end
  })
end

class.registerTouchHandler = registerTouchHandler

local function refreshAmount(self, input)
  local ui = self.ui
  if type(input) == "string" then
    local add = tonumber(input)
    if add ~= 999 then
      self.info.amount = self.info.amount + add
      if self.info.amount > self.info.maxAmount then
        self.info.amount = self.info.maxAmount
      end
      if self.info.amount < 1 then
        return
      elseif self.info.amount * self.info.needAmount > self.info.fragmentAmount then
        self.info.amount = self.info.amount - 1
        return
      end
    else
      self.info.amount = self.info.maxAmount
    end
  end
  local composeAmount = self.info.amount > 0 and self.info.amount or 0
  ed.setString(ui.compose_amount, tostring(composeAmount))
  local cost = self.info.unitCost * composeAmount
  self.info.cost = cost
  ed.setString(ui.cost, tostring(cost))
end

class.refreshAmount = refreshAmount

local function getInformation(self, id)
  local info = {}
  local equipInfo = ed.getDataTable("equip")[id]
  local fragmentTable = ed.getDataTable("fragment")
  local fragmentInfo
  for k, v in pairs(fragmentTable) do
    if v["Fragment ID"] == id then
      info.makeId = k
      if ed.itemType(k) == "equip" then
        info.makeName = ed.getDataTable("equip")[k].Name
      elseif ed.itemType(k) == "hero" then
        info.makeName = ed.getDataTable("Unit")[k]["Display Name"]
      else
        info.makeName = ""
      end
      info.cost = v.Expense
      fragmentInfo = v
      break
    end
  end
  info.id = id
  info.name = equipInfo.Name
  info.unitCost = info.cost
  local makeEquip = ed.getDataTable("equip")[info.makeId]
  info.makeEquipCategory = makeEquip.Category
  info.needAmount = fragmentInfo["Fragment Count"]
  info.universalNeedAmount = fragmentInfo["Universal Fragment Count"]
  info.universalId = fragmentInfo["Universal Fragment ID"]
  info.fragmentAmount = ed.player.equip_qunty[id] or 0
  info.universalAmount = ed.player.equip_qunty[info.universalId] or 0
  info.amount = 1
  info.maxAmount = math.floor(info.fragmentAmount / info.needAmount)
  local canMakeAmount = math.max(ed.player:getItemMaxAmount(info.makeId) - ed.player:getEquipAmount(info.makeId), 1)
  if canMakeAmount < info.maxAmount then
    info.maxAmount = canMakeAmount
  end
  info.lackAmount = info.needAmount - info.fragmentAmount
  if 0 > info.lackAmount then
    info.lackAmount = 0
  end
  if info.lackAmount > info.universalNeedAmount then
    info.lackAmount = info.universalNeedAmount
  end
  if info.lackAmount > info.universalAmount then
    info.lackText = T("\231\162\142\231\137\135\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144")
  else
    info.lackText = T("\231\162\142\231\137\135\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144")
  end
  if 0 < info.lackAmount then
    info.amountColor = ccc3(255, 0, 0)
  else
    info.amountColor = ccc3(169, 91, 28)
  end
  self.info = info
  return info
end

class.getInformation = getInformation

local function create(id, params)
  local self = base.create("fragmentcompose")
  setmetatable(self, class.mt)
  params = params or {}
  self.package = params.package
  self.destroyCallback = params.destroyCallback
  local info = self:getInformation(id)
  self.info = info
  local mainLayer = self.mainLayer
  local bg = ed.createSprite("UI/alpha/HVGA/fragment_compose_bg.png")
  bg:setPosition(ccp(400, 240))
  self.bg = bg
  mainLayer:addChild(bg)
  local titleName = T("\229\144\136\230\136\144")
  if resource_config.is_break_work_with_space then
    titleName = titleName .. " "
  end
  titleName = titleName .. info.makeName
  local BookFlag = true
  if self.info.makeEquipCategory == T("\228\185\166\230\156\172") then
    BookFlag = false
  end
  self.ui = {}
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = titleName,
        size = 18
      },
      layout = {
        position = ccp(142, 345)
      },
      config = {
        color = ccc3(184, 6, 6)
      }
    },
    {
      t = "Label",
      base = {
        name = "make_name",
        text = info.makeName,
        size = 18
      },
      layout = {
        position = ccp(212, 178)
      },
      config = {
        color = ccc3(169, 91, 28)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "arrow",
        res = "UI/alpha/HVGA/fragment_compose_arrow.png"
      },
      layout = {
        position = ccp(145, 230)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = info.fragmentAmount,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(78, 178)
      },
      config = {
        color = info.amountColor
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_need_label",
        text = "/" .. info.needAmount,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(78, 178)
      },
      config = {
        color = ccc3(169, 91, 28)
      }
    },
    {
      t = "Label",
      base = {
        name = "universal",
        text = info.lackText,
        size = 20
      },
      layout = {
        position = ccp(145, 130)
      },
      config = {
        color = ccc3(182, 65, 21),
        visible = info.lackAmount ~= 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "cost_bg",
        res = "UI/alpha/HVGA/equip_craft_money_bg.png"
      },
      layout = {
        position = ccp(142, 95)
      },
      config = {
        fix_size = CCSizeMake(260, 32)
      }
    },
    {
      t = "Label",
      base = {
        name = "cost_title",
        text = T("\229\144\136\230\136\144\232\138\177\232\180\185\239\188\154"),
        size = 18
      },
      layout = {
        position = ccp(72, 95)
      },
      config = {
        color = ccc3(182, 65, 21)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "cost_icon",
        res = "UI/alpha/1080P/common/goldicon.png"
      },
      layout = {
        position = ccp(152, 98)
      },
      config = {scale = 0.8}
    },
    {
      t = "Label",
      base = {
        name = "cost",
        text = info.cost,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(180, 95)
      },
      config = {
        color = info.cost <= ed.player._money and ccc3(182, 65, 21) or ccc3(232, 18, 18)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "compose_amount_bg",
        res = "UI/alpha/HVGA/sell_number_bg.png"
      },
      layout = {
        position = ccp(144, 135)
      },
      config = {
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Sprite",
      base = {
        name = "minus",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      layout = {
        position = ccp(42, 135)
      },
      config = {
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Sprite",
      base = {
        name = "minus_press",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        parent = "minus"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "minus_label",
        text = "-",
        size = 24,
        parent = "minus"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "add",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      layout = {
        position = ccp(177, 135)
      },
      config = {
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Sprite",
      base = {
        name = "add_press",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        parent = "add"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "add_label",
        text = "+",
        size = 24,
        parent = "add"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "max",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        capInsets = CCRectMake(10, 10, 28, 29)
      },
      layout = {
        position = ccp(234, 135)
      },
      config = {
        scaleSize = CCSizeMake(70, 49),
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "max_press",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        capInsets = CCRectMake(10, 10, 28, 29),
        parent = "max"
      },
      layout = {mediate = true},
      config = {
        scaleSize = CCSizeMake(70, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "max_label",
        text = T("\230\156\128\229\164\167"),
        size = 24,
        parent = "max"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "compose_amount",
        text = tostring(info.amount),
        size = 20
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(102, 135)
      },
      config = {
        color = ccc3(255, 234, 198),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Label",
      base = {
        name = "compose_amount_gap",
        text = "/",
        size = 20
      },
      layout = {
        position = ccp(108, 135)
      },
      config = {
        color = ccc3(241, 193, 113),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Label",
      base = {
        name = "compose_amount_limit",
        text = tostring(info.maxAmount),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(114, 135)
      },
      config = {
        color = ccc3(241, 193, 113),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        visible = info.lackAmount == 0 and BookFlag
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(280, 360)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close_down",
        res = "UI/alpha/1080P/common/common_tips_button_close_2.png",
        parent = "close"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "installer/herodetail-upgrade.png",
        capInsets = CCRectMake(10, 10, 50, 29)
      },
      layout = {
        position = ccp(145, 42)
      },
      config = {
        scaleSize = CCSizeMake(250, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_down",
        res = "installer/herodetail-upgrade-mask.png",
        capInsets = CCRectMake(10, 10, 50, 29),
        parent = "ok"
      },
      layout = {mediate = true},
      config = {
        scaleSize = CCSizeMake(250, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T("\231\161\174\232\174\164\229\144\136\230\136\144"),
        size = 26,
        parent = "ok"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(251, 206, 16)
      }
    }
  }
  local readNode = ed.readnode.create(self.bg, self.ui)
  readNode:addNode(ui_info)
  local fragmentIcon = ed.readequip.createFragment(info.id)
  self.fragmentIcon = fragmentIcon
  fragmentIcon:setPosition(ccp(78, 230))
  self.bg:addChild(fragmentIcon)
  local makeIcon = ed.readequip.createIcon(info.makeId)
  self.makeIcon = makeIcon
  makeIcon:setPosition(ccp(212, 230))
  self.bg:addChild(makeIcon)
  self:show()
  self:registerTouchHandler()
  return self
end

class.create = create

local function pop(id, params)
  local window = class.create(id, params)
  window:popWindow(params.z or 100)
  return window
end

class.pop = pop
