local base = ed.ui.popwindow
local PvpOppoInfoWin = newclass(base.mt)
ed.ui.PvpOppoInfoWin = PvpOppoInfoWin

function PvpOppoInfoWin.create(data, showRevenge)
  local self = base.create("PvpOppoInfoWin")
  setmetatable(self, PvpOppoInfoWin.mt)
  self.showRevenge = showRevenge
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function PvpOppoInfoWin:initData(data)
  self.rawData = data
  self.data = data._user
end

function PvpOppoInfoWin:initLabels()
  ed.setLabelStroke(self.ui.name, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.guild_name, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.cur_rank1, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.win_count1, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.gs1, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.cur_rank2, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.win_count2, ed.toccc3(2366999), 1)
  ed.setLabelStroke(self.ui.gs2, ed.toccc3(2366999), 1)
  ed.setLabelShadow(self.ui.label_info, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelShadow(self.ui.label_re, ccc3(0, 0, 0), ccp(1, 1))
end

function PvpOppoInfoWin:initUI()
  ed.editorui(ed.uieditor.pvpOppoInfoWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  if not self.showRevenge then
    self.ui.btn_revenge:setVisible(false)
    self.ui.btn_info:setPositionX(151)
  end
  self:refreshUI()
end

function PvpOppoInfoWin:refreshUI()
  local summary = self.data._summary
  local nameStr = ed.transBotName(summary._name)
  ed.setString(self.ui.name, nameStr)
  ed.setString(self.ui.guild_name, summary._guild_name or " ")
  ed.setString(self.ui.win_count2, self.data._win_cnt or 0)
  ed.setString(self.ui.gs2, self.data._gs or 0)
  ed.setString(self.ui.cur_rank2, self.data._rank)
  local head = ed.getWholeHeadIcon({
    id = summary._avatar,
    level = summary._level,
    lvoffset = {x = -47, y = -38}
  })
  head:setScale(0.7)
  ed.UITool.replaceUINew(self.ui, "head", head)
  self.ui.layer_item:removeAllChildrenWithCleanup(true)
  for k, v in ipairs(self.data._heros or {}) do
    local icon = ed.readhero.createIconByServer(v).icon
    icon:setScale(0.6)
    self.ui.layer_item:addChild(icon)
    icon:setPosition(ccp(-20 + 54 * k, 36))
  end
end

function PvpOppoInfoWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_info", function()
    ed.UITool.openView("playerInfoPanel", self.data._summary._role_id)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_revenge", function()
    ed.registerNetReply("query_pvp_oppo", function(data)
      self:initData(data)
      self:refreshUI()
      if ed.pvpManager.rank < self.data._rank then
        ed.showToast("\228\189\160\231\154\132\230\142\146\229\144\141\229\183\178\231\187\143\229\156\168\229\175\185\230\150\185\229\137\141\233\157\162\228\186\134,\233\165\182\228\187\150\228\184\128\230\172\161\229\144\167\239\188\129")
        return
      end
      local uRank = math.floor(ed.pvpManager.rank * 0.3)
      if uRank > self.data._rank then
        ed.showToast(T("\228\189\160\231\154\132\230\142\146\229\144\141\232\144\189\229\144\142\229\175\185\230\150\185\229\164\170\229\164\154\239\188\140\229\134\141\229\138\160\230\138\138\229\138\178\229\144\167\239\188\129"))
        return
      end
      base.destroy(self, {skipAnim = true})
      ed.pvpManager.win:challengeEnemy(self.data)
    end)
    ed.pvpNetwork:sendQueryOppo(self.data._user_id)
  end, {pressScale = 0.95})
end
