module("ed.battleprepare", package.seeall)
pay = {}
pay.__index = pay
local base = ed.ui.popwindow
setmetatable(pay, base.mt)

function pay.create(data, priority)
  local object = base.create("battleprepare_pay", {priority = priority})
  setmetatable(object, pay)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function pay:initData(data)
  self.type = data.type
  self.hero = data.hero
end

function pay:initAppearence()
  local uires = self:getUiInfo()
  local container, ui = ed.editorui(uires)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  self:initTitle()
end

function pay:initTitle()
  local id = self.hero._tid
  local mercenaryInfo = self.hero:getMercenaryData()
  local name = mercenaryInfo._name
  local cost = mercenaryInfo._cost
  local ui = self.ui
  ed.setString(ui.payNum, cost)
  if 10006 ~= id then
    ui.hintText:setString(T("<text|dark_white|\228\189\160\228\187\138\229\164\169\229\176\134\228\184\141\232\131\189\229\134\141\233\155\135\228\189\163\230\157\165\232\135\170><text|dark_yellow|%s><text|dark_white|\231\154\132\229\133\182\228\187\150\232\139\177\233\155\132>", name))
    ui.hintText:setVisible(true)
  else
    name = ed.player:getGuildName()
    ui.hintText:setVisible(false)
  end
  local heroName = ""
  local ut = ed.getDataTable("Unit")
  local row = ut[id]
  if row then
    heroName = row["Display Name"]
  end
  ui.hintText2:setString(T("<text|dark_white|\233\155\135\228\189\163\230\157\165\232\135\170><text|dark_yellow|%s><text|dark_white|\231\154\132\232\139\177\233\155\132><text|dark_yellow|%s><text|dark_white|\233\156\128\232\166\129\230\148\175\228\187\152\228\189\163\233\135\145>", name, heroName))
  if 10006 == id then
    local x, _ = ui.hintText2:getPosition()
    ui.hintText2:setPosition(ccp(x, 135))
    local x, _ = ui.priceIcon:getPosition()
    ui.priceIcon:setPosition(ccp(x, 104))
    local x, _ = ui.payNum:getPosition()
    ui.payNum:setPosition(ccp(x, 104))
  end
end

function pay:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.conform,
    press = self.ui.conform_press,
    key = "battleprepare_pay_conform",
    clickHandler = function()
      manager:sendHireHero(self.hero, self.type)
      self:destroy({skipAnim = true})
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.cancel,
    press = self.ui.cancel_press,
    key = "battleprepare_pay_cancel",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    clickInterval = 0.5
  })
end

function pay:getUiInfo()
  local uires = {
    {
      t = "Sprite",
      base = {name = "payResult"},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(300, 150)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/1080P/common/main_vit_tips.png",
        capInsets = CCRectMake(15, 20, 45, 15),
        parent = "payResult"
      },
      layout = {
        position = ccp(91, 100)
      },
      config = {
        scaleSize = CCSizeMake(450, 252)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/act/act_popup_bg.png",
        parent = "payResult"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(90, 188)
      },
      config = {
        scalexy = {x = 0.7, y = 1}
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T("\231\161\174\232\174\164\233\155\135\228\189\163"),
        parent = "payResult",
        fontinfo = "title_yellow"
      },
      layout = {
        position = ccp(88, 188)
      }
    },
    {
      t = "RichText",
      base = {
        name = "hintText2",
        middle = true,
        text = T("<text|dark_white|\228\189\160\228\187\138\229\164\169\229\176\134\228\184\141\232\131\189\229\134\141\233\155\135\228\189\163\230\157\165\232\135\170><text|dark_yellow|xxxxxxxxx><text|dark_white|\231\154\132\229\133\182\228\187\150\228\189\163\229\133\181>"),
        parent = "payResult"
      },
      layout = {
        position = ccp(88, 148)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "priceIcon",
        res = "UI/alpha/1080P/common/goldicon_small.png",
        parent = "payResult"
      },
      layout = {
        position = ccp(50, 114)
      }
    },
    {
      t = "Label",
      base = {
        name = "payNum",
        text = "5000",
        parent = "payResult",
        fontinfo = "normal_button"
      },
      layout = {
        position = ccp(110, 114)
      }
    },
    {
      t = "RichText",
      base = {
        name = "hintText",
        middle = true,
        text = T("<text|dark_white|\228\189\160\228\187\138\229\164\169\229\176\134\228\184\141\232\131\189\229\134\141\233\155\135\228\189\163\230\157\165\232\135\170><text|dark_yellow|xxxxxxxxx><text|dark_white|\231\154\132\229\133\182\228\187\150\228\189\163\229\133\181>"),
        parent = "payResult"
      },
      layout = {
        position = ccp(90, 78)
      }
    },
    {
      config = {
        rotation = 0,
        fix_scale = {y = 1, x = 1},
        fix_wh = {w = 100, h = 48},
        flip = "",
        labelConfig = {
          color = ccc3(255, 255, 255)
        },
        opacity = 255,
        visible = true,
        pressConfig = {flip = ""}
      },
      t = "DGButton",
      base = {
        normal = "UI/alpha/1080P/common/tavern_button_normal_1.png",
        name = "conform",
        z = 0,
        parent = "payResult",
        text = "\231\161\174\229\174\154",
        press = "UI/alpha/1080P/common/tavern_button_normal_2.png",
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(180, 24)
      }
    },
    {
      config = {
        rotation = 0,
        fix_scale = {y = 1, x = 1},
        fix_wh = {w = 100, h = 48},
        flip = "",
        labelConfig = {
          color = ccc3(255, 255, 255)
        },
        opacity = 255,
        visible = true,
        pressConfig = {flip = ""}
      },
      t = "DGButton",
      base = {
        normal = "UI/alpha/1080P/common/tavern_button_normal_1.png",
        name = "cancel",
        z = 0,
        parent = "payResult",
        text = "\229\143\150\230\182\136",
        press = "UI/alpha/1080P/common/tavern_button_normal_2.png",
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(20, 24)
      }
    }
  }
  return uires
end
