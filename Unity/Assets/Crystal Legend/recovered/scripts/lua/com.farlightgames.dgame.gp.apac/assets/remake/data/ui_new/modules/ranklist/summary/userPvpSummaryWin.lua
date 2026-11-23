local base = ed.ui.popwindow
local userPvpSummaryWin = newclass(base.mt)
ed.ui.userPvpSummaryWin = userPvpSummaryWin

function userPvpSummaryWin.create(data, param, param1)
  local self = base.create("userPvpSummaryWin", param)
  setmetatable(self, userPvpSummaryWin.mt)
  self:init(data, param, param1)
  return self
end

function userPvpSummaryWin:init(data, param, param1)
  self.data = data
  self.config = param1
  self.summary = data._summary
  self:initView()
  self:addEventListener()
end

function userPvpSummaryWin:initView()
  local container, ui = ed.editorui(ed.uieditor.userPvpSummary)
  self.ui = ui
  self.container:addChild(container)
  self:show()
  self:createHeroList()
  self:createPlayerInfo()
end

function userPvpSummaryWin:createHeroList()
  local heroes = ed.SortHeroesByMaxRange(self.data._heros or {})
  for index, v in ipairs(heroes) do
    local heroParam
    if v._legend_equip == nil then
      heroParam = {
        id = v._tid,
        rank = v._rank,
        level = v._level,
        stars = v._stars,
        length = 50,
        fashion_id = v._fashion,
        shard = v._shard,
        summary = v,
        legendEquip = nil
      }
    else
      heroParam = {
        id = v._tid,
        rank = v._rank,
        level = v._level,
        stars = v._stars,
        length = 50,
        fashion_id = v._fashion,
        shard = v._shard,
        summary = v,
        legendEquip = v._legend_equip and v._legend_equip._equip
      }
    end
    local heroInfo = ed.readhero.createIcon(heroParam)
    local icon = heroInfo.icon
    heroInfo:showLegendEquip(not ed.openLegendEquip())
    self.ui["heroIcon" .. index]:addChild(icon)
    ed.layout.centerInParent(icon)
    self:btRegisterButtonClick({
      button = icon,
      key = "heroIcon" .. index,
      force = true,
      mcpMode = true,
      clickHandler = function()
        ed.ui.checkOthersHeroWindow.create():popWindow()
        ed.PlayerInfoNetwork:requestHeroData(self.data._summary._role_id, v._tid)
      end
    })
  end
end

function userPvpSummaryWin:createPlayerInfo()
  if self.summary._medal ~= nil then
  end
  local param = {
    id = self.summary._avatar
  }
  local head = ed.getWholeHeadIcon(param)
  self.ui.headFrame:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(ed.transBotName(self.summary._name), self.summary._medal, {
    anchorPoint = ccp(0.5, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "bg", "playerName", name)
  self.ui.playerLevel:setString(self.summary._level)
  if self.summary._guild_name then
    self.ui.guildInfoLabel:setString(T("\230\157\165\232\135\170\229\133\172\228\188\154\239\188\154"))
    self.ui.guildName:setString(self.summary._guild_name)
    ed.right2(self.ui.guildName, self.ui.guildInfoLabel, 10)
  else
    self.ui.guildInfoLabel:setString(T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"))
    self.ui.guildName:setString("")
  end
  local rankNode = ed.getNumberNode({
    text = self.data._rank,
    folder = "big_pvp",
    scale = 0.75
  }).node
  self.ui.settlementBg:addChild(rankNode)
  ed.right2(rankNode, self.ui.settlementLabel, 10)
  self.ui.winCount:setString(self.data._win_cnt)
  ed.right2(self.ui.winCount, self.ui.winCountLabel, 10)
  local numGsNode = ed.getNumberNode({
    text = self.data._gs,
    folder = "hero_gs",
    padding = -1
  }).node
  self.ui.gsCountBg:addChild(numGsNode)
  ed.right2(numGsNode, self.ui.gsCountLabel, 10)
end

function userPvpSummaryWin:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event ~= "ended" then
        return false
      end
      if not ed.containsPoint(self.ui.bg, x, y) then
        self:close()
        return false
      end
      return false
    end,
    key = "close",
    priority = -100
  })
  self:btRegisterButtonClick({
    button = self.ui.btnHomePage,
    press = self.ui.btnHomePage_press,
    pressScale = 0.95,
    key = "btnHomePage",
    force = true,
    mcpMode = true,
    priority = -100,
    clickHandler = function()
      if self.summary._level > 0 then
        if ed.getUserid() ~= self.summary._uid then
          ed.registerNetReply("req_home_page", function(data)
            local panel = ed.ui.PlayerInfoPanel.create(data, false)
            panel:popWindow()
          end)
          ed.PlayerInfoNetwork:requestHomePage(self.summary._role_id)
        else
          ed.registerNetReply("personal_home_page", function(data)
            local panel = ed.ui.PlayerInfoPanel.create(data, true)
            panel:popWindow()
          end)
          ed.PlayerInfoNetwork:openPanel()
        end
      else
        ed.showToast(T("\231\139\130\230\172\162\231\154\132\232\138\130\230\151\165\229\143\170\233\156\128\232\166\129\230\191\128\230\131\133\228\184\141\233\156\128\232\166\129\229\144\141\229\146\140\229\167\147"))
      end
    end
  })
end

function userPvpSummaryWin:close()
  self:destroy()
end
