local base = ed.ui.popwindow
local redeemCodeWin = newclass(base.mt)
ed.ui.redeemCodeWin = redeemCodeWin

function redeemCodeWin.create()
  local self = base.create("redeemCodeWin")
  setmetatable(self, redeemCodeWin.mt)
  self:init()
  return self
end

function redeemCodeWin:init()
  self:initView()
  self:addEventListener()
end

function redeemCodeWin:initView()
  local container, ui = ed.editorui(ed.uieditor.redeemCode)
  self.ui = ui
  self.container:addChild(container)
  ed.layout.layoutWithMagin(self.container, {top = 400}, true)
  self:show()
  local info = {
    config = {
      editSize = ui.panel_input:getContentSize(),
      maxLength = 20,
      fontColor = ccc3(255, 252, 231),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165\229\133\145\230\141\162\231\160\129"))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  self.ui.panel_input:addChild(edit_box.edit)
  self.ui.editbox = edit_box
end

function redeemCodeWin:doAskKeyReply()
  local function handler(result, data)
    local msg_str = T("\230\136\144\229\138\159\229\133\145\230\141\162")
    
    if result == "already_used" then
      ed.showToast(T("\230\173\164\229\133\145\230\141\162\231\160\129\228\184\141\229\173\152\229\156\168\230\136\150\229\183\178\232\162\171\228\189\191\231\148\168"))
      return
    elseif result == "not_exists" then
      ed.showToast(T("\230\151\160\230\149\136\229\133\145\230\141\162\231\160\129"))
      return
    elseif result == "once_only" then
      ed.showToast(T("\230\173\164\229\133\145\230\141\162\231\160\129\228\184\141\229\173\152\229\156\168\230\136\150\229\183\178\232\162\171\228\189\191\231\148\168"))
      return
    elseif result == "invitation_code_used_success" then
      ed.showToast(T("\230\136\144\229\138\159\232\190\147\229\133\165\233\130\128\232\175\183\231\160\129"))
      return
    elseif result == "input_phone_success" then
      ed.showToast(T("\233\170\140\232\175\129\231\160\129\229\183\178\229\143\145\233\128\129\239\188\140\229\166\130\230\158\156\228\189\160\229\156\1683\229\136\134\233\146\159\229\134\133\230\178\161\230\148\182\229\136\176\232\175\165\231\159\173\228\191\161\239\188\140\232\175\183\233\135\141\232\175\149\227\128\130"))
      return
    elseif result == "bind_phone_success" then
      ed.showToast(T("\230\136\144\229\138\159\231\187\145\229\174\154\230\137\139\230\156\186"))
      self:destroy()
      return
    elseif result == "join_bind_actvity_success" then
      ed.showToast(T("\230\129\173\229\150\156\228\189\160\230\138\165\229\144\141\230\136\144\229\138\159!"))
      self:destroy()
      return
    elseif result == "bind_wechat_success" then
      ed.showToast(T("\231\187\145\229\174\154\230\136\144\229\138\159,\232\191\148\229\155\158\229\190\174\228\191\161,\229\185\182\229\136\183\230\150\176\229\190\174\228\191\161\233\161\181\233\157\162"))
      if not data then
        self:destroy()
        return
      end
      msg_str = T("\233\166\150\230\172\161\231\187\145\229\174\154\229\165\150\229\138\177")
    end
    local list = {}
    local money = data._money or 0
    ed.player:addMoney(money)
    if 0 < money then
      table.insert(list, {type = "Gold", amount = money})
    end
    local diamond = data._diamond or 0
    ed.player:addrmb(diamond)
    if 0 < diamond then
      table.insert(list, {type = "Diamond", amount = diamond})
    end
    local items = data._items or {}
    for k, v in pairs(items) do
      local iv = ed.analyzeItem(v)
      local id = iv.id
      local amount = iv.amount
      ed.player:addEquip(id, amount)
      table.insert(list, {
        type = "item",
        id = id,
        amount = amount
      })
    end
    local heroes = data._heroes or {}
    for k, v in pairs(heroes) do
      ed.player:resetHero(v)
      table.insert(list, {
        type = "item",
        id = v._tid,
        amount = 1
      })
    end
    local monthCard = data._month_card
    if monthCard then
      ed.player:refreshMonthCardData(monthCard)
      table.insert(list, {
        type = "MonthCard",
        name = T("\230\156\136\229\141\161\231\164\188\229\140\133\239\188\13630\229\164\169\239\188\137"),
        amount = 1
      })
    end
    ed.announce({
      type = "getProp",
      param = {
        title = msg_str,
        items = list,
        callback = self:getRewardReplyCallback(heroes),
        forbidPopHero = true
      }
    })
    self:destroy()
  end
  
  return handler
end

function redeemCodeWin:getRewardReplyCallback(heroes)
  local function handler()
    local hs = {}
    
    for k, v in pairs(heroes or {}) do
      table.insert(hs, v._tid)
    end
    if #hs == 0 then
      return
    end
    local index = 1
    
    local function popHeroCard(index)
      if hs[index] then
        ed.announce({
          type = "popHeroCard",
          param = {
            id = hs[index],
            callback = function()
              xpcall(function()
                popHeroCard(index + 1)
              end, EDDebug)
            end
          }
        })
      end
    end
    
    popHeroCard(index)
  end
  
  return handler
end

function redeemCodeWin:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_cancel,
    press = self.ui.btn_cancel_press,
    key = "btn_cancel",
    pressScale = 0.9,
    clickHandler = function()
      self:pop()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_confirm,
    press = self.ui.btn_confirm_press,
    key = "btn_confirm",
    pressScale = 0.9,
    clickHandler = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("CDKey")
      if ds then
        ed.showToast(ds)
        return
      end
      local cdKey = self.ui.editbox:getString()
      ed.netreply.cdkeyGift = self:doAskKeyReply()
      local msg = ed.upmsg.cdkey_gift()
      msg._cdkey = cdKey
      ed.send(msg, "cdkey_gift")
    end
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.editbox:touch(event, x, y)
    end,
    key = "edit_box"
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event ~= "ended" then
        return false
      end
      if not ed.containsPoint(self.ui.bg, x, y) then
        self:pop()
        return false
      end
      self.ui.editbox:touch(event, x, y)
      return false
    end,
    key = "redeemCodeWin",
    priority = -100
  })
end

function redeemCodeWin:pop()
  self:destroy()
end
