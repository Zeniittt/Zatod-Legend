local base = ed.ui.popwindow
local heroPayWin = newclass(base.mt)
ed.ui.heroPayWin = heroPayWin

function heroPayWin.create(cost, name, id, currentMercenary, prepareInfo)
  local self = base.create("heroPayWin")
  setmetatable(self, heroPayWin.mt)
  self:initData(cost, name, id, currentMercenary, prepareInfo)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function heroPayWin:initData(cost, name, id, currentMercenary, prepareInfo)
  self.cost = cost
  self.name = name
  self.id = id
  self.currentMercenary = currentMercenary
  self.prepareInfo = prepareInfo
  self.eventScope = {}
end

function heroPayWin:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.heroPayWin)
  self.mainLayer:addChild(self.container)
  self.ui.bg:setPosition(ed.display.center)
  self:initLabel()
end

function heroPayWin:initLabel()
  local heroName = ""
  local ut = ed.getDataTable("Unit")
  local row = ut[self.id]
  if row then
    heroName = row["Display Name"]
  end
  local x, y = self.ui.gold_bg:getPosition()
  local rich1 = richText:new()
  rich1:setString(T("<text|dark_white|\233\155\135\228\189\163\230\157\165\232\135\170><text|dark_yellow|%s><text|dark_white|\231\154\132\232\139\177\233\155\132><text|dark_yellow|%s><text|dark_white|\233\156\128\232\166\129\230\148\175\228\187\152\228\189\163\233\135\145>", self.name, heroName))
  rich1:setVerticalCenter()
  rich1:setPosition(ccp(x - rich1:getContentSize().width / 2, y + 80 / ed.display.scaleFactor))
  self.ui.bg:addChild(rich1.rootNode)
  self.ui.rich1 = rich1
  self.ui.gold_num:setString(self.cost)
  local rich2 = richText:new()
  rich2:setString(T("<text|dark_white|\228\189\160\228\187\138\229\164\169\229\176\134\228\184\141\232\131\189\229\134\141\233\155\135\228\189\163\230\157\165\232\135\170><text|dark_yellow|%s><text|dark_white|\231\154\132\229\133\182\228\187\150\232\139\177\233\155\132>", self.name))
  rich2:setVerticalCenter()
  rich2:setPosition(ccp(x - rich2:getContentSize().width / 2, y - 80 / ed.display.scaleFactor))
  self.ui.bg:addChild(rich2.rootNode)
  self.ui.rich2 = rich2
end

function heroPayWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "cancel_btn", function()
    CloseScope(self.eventScope)
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "confirm_btn", function()
    self:doConfirm()
    CloseScope(self.eventScope)
    self:destroy()
  end, {pressScale = 0.9})
end

function heroPayWin:doConfirm()
  if self.currentMercenary then
    local msg = ed.upmsg.guild()
    msg._hire_hero = {}
    msg._hire_hero._uid = self.currentMercenary.uid
    msg._hire_hero._heroid = self.currentMercenary.tid
    if self.prepareInfo.mode == "crusade" then
      msg._hire_hero._from = "tbc"
    elseif self.prepareInfo.mode == "tower" then
      msg._hire_hero._from = "tower"
    elseif ed.isElementInTable(self.prepareInfo.mode, {
      "excavateAttack"
    }) then
      msg._hire_hero._from = "excav"
    elseif self.prepareInfo.mode == "AwakeStage" then
      msg._hire_hero._from = "awake_dungeon"
    else
      if self.prepareInfo.mode == "guildInstance" then
        msg._hire_hero._stage_id = self.prepareInfo.stage_id
      end
      msg._hire_hero._from = "stage"
      if self.prepareInfo.mode == "GuildMountBoss" then
        msg._hire_hero._from = "guild_mount"
      end
    end
    ed.pt(msg)
    ed.send(msg, "guild")
  end
end
