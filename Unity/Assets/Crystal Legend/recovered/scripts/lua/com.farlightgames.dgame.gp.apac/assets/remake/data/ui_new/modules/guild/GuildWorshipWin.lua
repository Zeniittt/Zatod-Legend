local base = ed.ui.popwindow
local GuildWorshipWin = newclass(base.mt)
ed.ui.GuildWorshipWin = GuildWorshipWin

function GuildWorshipWin.create(param)
  local self = base.create("GuildWorshipWin")
  setmetatable(self, GuildWorshipWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function GuildWorshipWin:initData(param)
  self.selectMemberId = param.uid
  local worshipTable = ed.getDataTable("GuildWorship")
  self.worshipInfos = {
    {
      power = worshipTable[1]["Get Vitality"],
      cost = 0
    },
    {
      power = worshipTable[2]["Get Vitality"],
      cost = worshipTable[2]["Price Amount"]
    },
    {
      power = worshipTable[3]["Get Vitality"],
      cost = worshipTable[3]["Price Amount"]
    }
  }
end

function GuildWorshipWin:initLabels()
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelStroke(self.ui.cost1, ed.toccc3(27, 25, 24), 1)
  ed.setLabelStroke(self.ui.cost2, ed.toccc3(27, 25, 24), 1)
  ed.setLabelStroke(self.ui.cost3, ed.toccc3(27, 25, 24), 1)
  ed.setLabelStroke(self.ui.label_title_1, ed.toccc3(8274695), 1)
  ed.setLabelStroke(self.ui.label_title_2, ed.toccc3(8274695), 1)
  ed.setLabelStroke(self.ui.label_title_3, ed.toccc3(8274695), 1)
  ed.setLabelShadow(self.ui.label1, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label2, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label3, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.power1, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.power2, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.power3, ccc3(0, 0, 0), ccp(2, 0))
end

function GuildWorshipWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.GuildWorshipWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local worshipTable = ed.getDataTable("GuildWorship")
  for i = 1, 3 do
    ed.setString(self.ui["power" .. i], self.worshipInfos[i].power)
    ed.setString(self.ui["cost" .. i], self.worshipInfos[i].cost)
    self.ui["label_title_" .. i]:limitWidthByScale(110)
    self.ui["label" .. i]:limitWidthByScale(110)
    ed.layout.horizontalSortNode({
      self.ui["label" .. i],
      self.ui["power" .. i]
    }, {0, 0}, self.ui["bg_item" .. i]:getContentSize().width * 0.5)
  end
  ed.setString(self.ui.cost1, T("\229\133\141\232\180\185"))
  ed.layout.horizontalSortNode({
    self.ui.line1,
    self.ui.title,
    self.ui.line2
  }, {
    10,
    10,
    0
  }, self.ui.bg:getContentSize().width * 0.5)
end

function GuildWorshipWin:registerEvents()
  self:listenEvent("GuildWorshipSuccess", function()
    function self.callback()
      local amount = self.worshipInfos[self.curWorshipType].power
      
      ed.player:addVitality(amount)
      if self.curWorshipType == 2 then
        ed.player:addMoney(-self.worshipInfos[2].cost)
      elseif self.curWorshipType == 3 then
        ed.player:subrmb(self.worshipInfos[3].cost)
      end
      ed.announce({
        type = "getProp",
        param = {
          title = T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
          items = {
            {type = "vitality", amount = amount}
          }
        }
      })
    end
    
    if ed.isAreaOverSea() then
      self:destroy()
      return
    end
    local worshipFca = ed.createFcaNode("eff_UI_Guild_worship")
    worshipFca:setPosition(ccp(ed.display.center.x, ed.display.center.y - 100))
    worshipFca:setScale(0.7)
    self:addFcaOnce(worshipFca)
    worshipFca:setAction("Start")
    worshipFca:setLoop(false)
    self.mainLayer:addChild(worshipFca)
    self:btRegisterHandler({
      key = "clicktodestroy",
      handler = function(event, x, y)
        self:destroy()
      end,
      priority = -10
    })
    self:listenTimer(Timer:Once(2.8), function()
      worshipFca:removeFromParentAndCleanup(true)
      local worshipFca = ed.createFcaNode("eff_point_mirror_die")
      worshipFca:setPosition(ccp(ed.display.center.x, ed.display.center.y - 100))
      worshipFca:setScale(2.7)
      self:addFcaOnce(worshipFca)
      worshipFca:setAction("Start")
      worshipFca:setLoop(false)
      self.mainLayer:addChild(worshipFca)
      self:destroy()
    end)
  end)
end

function GuildWorshipWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "bg_item1", function()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    else
      self.curWorshipType = 1
      local msg = ed.upmsg.guild()
      msg._worship_req = {}
      msg._worship_req._id = 1
      msg._worship_req._uid = self.selectMemberId
      ed.send(msg, "guild")
    end
  end, {pressScale = 0.95, clickInterval = 0.5})
  ed.UITool.registerBtn(self, "bg_item2", function()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    elseif ed.player._money < self.worshipInfos[2].cost then
      ed.showHandyDialog("useMidas")
      return
    else
      self.curWorshipType = 2
      local msg = ed.upmsg.guild()
      msg._worship_req = {}
      msg._worship_req._id = 2
      msg._worship_req._uid = self.selectMemberId
      ed.send(msg, "guild")
    end
  end, {pressScale = 0.95, clickInterval = 0.5})
  ed.UITool.registerBtn(self, "bg_item3", function()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    else
      if ed.player._rmb < self.worshipInfos[3].cost then
        ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
        return
      end
      local info = {
        text = T("\232\138\177\232\180\185%d\233\146\187\231\159\179\232\142\183\229\190\151%d\228\189\147\229\138\155\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", self.worshipInfos[3].cost, self.worshipInfos[3].power),
        leftText = T("\229\143\150\230\182\136"),
        rightText = T("\231\161\174\229\174\154"),
        rightHandler = function()
          self.curWorshipType = 3
          local msg = ed.upmsg.guild()
          msg._worship_req = {}
          msg._worship_req._id = 3
          msg._worship_req._uid = self.selectMemberId
          ed.send(msg, "guild")
        end
      }
      ed.showConfirmDialog(info)
    end
  end, {pressScale = 0.95, clickInterval = 0.5})
end

function GuildWorshipWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self, {skipAnim = true})
end
