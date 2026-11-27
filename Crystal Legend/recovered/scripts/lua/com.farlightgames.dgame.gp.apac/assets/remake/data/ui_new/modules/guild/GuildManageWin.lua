local base = ed.ui.popwindow
local GuildManageWin = newclass(base.mt)
ed.ui.GuildManageWin = GuildManageWin

function GuildManageWin.create()
  local self = base.create("GuildManageWin")
  setmetatable(self, GuildManageWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildManageWin:initData()
  self.btnConfig = {
    [1] = {
      key = "application",
      name = T("\229\133\165\228\188\154\231\148\179\232\175\183"),
      handler = function()
        if not ed.GuildManager.appliers then
          ed.showToast(T("\230\154\130\230\151\160\231\148\179\232\175\183"))
          return
        end
        ed.ui.GuildApplyMemberWin.create()
      end,
      red = function()
        return ed.GuildManager.guildJoinNotify ~= nil
      end,
      show = ed.player:getGuildJob() ~= "member",
      iconRes = "UI/alpha/1080P/guild/application.png"
    },
    [2] = {
      key = "menmberManager",
      name = T("\230\136\144\229\145\152\231\174\161\231\144\134"),
      handler = function()
        ed.ui.GuildMemberManageWin.create()
      end,
      show = ed.player:getGuildJob() ~= "member",
      iconRes = "UI/alpha/1080P/guild/manage.png"
    },
    [3] = {
      key = "setSlogan",
      name = T("\229\133\172\229\145\138\228\191\174\230\148\185"),
      handler = function()
        ed.ui.GuildSetSloganWin.create()
      end,
      show = false,
      iconRes = "UI/alpha/1080P/guild/bb.png"
    },
    [4] = {
      key = "setUp",
      name = T("\229\133\172\228\188\154\232\174\190\231\189\174"),
      handler = function()
        ed.ui.GuildSettingWin.create()
      end,
      show = ed.player:getGuildJob() ~= "member",
      iconRes = "UI/alpha/1080P/guild/setup.png"
    },
    [5] = {
      key = "mail",
      name = T("\229\133\168\229\145\152\233\130\174\228\187\182"),
      handler = function()
        ed.ui.GuildMailWin.create()
      end,
      show = ed.player:getGuildJob() ~= "member",
      iconRes = "UI/alpha/1080P/guild/mail.png"
    },
    [6] = {
      key = "setRecruitments",
      name = T("\230\139\155\229\139\159\228\191\174\230\148\185"),
      handler = function()
        ed.ui.GuildSetRecruitWin.create()
      end,
      show = ed.player:getGuildJob() ~= "member",
      iconRes = "UI/alpha/1080P/guild/recruitmentslogan.png"
    },
    [7] = {
      key = "findGuild",
      name = T("\230\159\165\230\137\190\229\133\172\228\188\154"),
      handler = function()
        ed.GuildNetwork:sendQueryGuildList()
      end,
      show = true,
      iconRes = "UI/alpha/1080P/guild/recruitmentslogan.png"
    },
    [8] = {
      key = "quit",
      name = T("\233\128\128\229\135\186\229\133\172\228\188\154"),
      handler = function()
        ed.GuildManager:onClickQuit()
      end,
      show = ed.player:getGuildJob() ~= "chairman",
      iconRes = "UI/alpha/1080P/guild/seach_tab.png"
    },
    [9] = {
      key = "dissolve",
      name = T("\232\167\163\230\149\163\229\133\172\228\188\154"),
      handler = function()
        self:dismissGuild()
      end,
      show = ed.player:getGuildJob() == "chairman",
      iconRes = "UI/alpha/1080P/guild/dissolve.png"
    },
    [10] = {
      key = "dissolve",
      name = T("\230\139\155\229\139\159\229\164\167\229\142\133"),
      handler = function()
        ed.GuildManager.openGuildRecruit = true
        ed.GuildNetwork:sendQueryGuildList()
      end,
      show = 1 <= ed.GuildManager.guildRecruitNotify,
      iconRes = "UI/alpha/1080P/guild/guild_enlist/tab_unselected.png"
    },
    [11] = {
      key = "gameplayRank",
      name = T("\231\142\169\230\179\149\230\142\146\232\161\140"),
      handler = function()
        ed.ui.GuildGameplayRanklistWin.create()
      end,
      show = ed.player:getGuildJob() ~= "member",
      iconRes = "UI/alpha/1080P/guild/ranking/ranking.png"
    }
  }
end

function GuildManageWin:initLabels()
end

function GuildManageWin:getPressInHandler()
  local function handler(x, y)
    for _, btn in ipairs(self.uiList or {}) do
      if ed.containsPoint(btn, x, y) then
        btn:setScale(0.9)
        
        return btn
      end
    end
  end
  
  return handler
end

function GuildManageWin:getCancelPressInHandler()
  local function handler(x, y, btn)
    if btn then
      btn:setScale(1)
    end
  end
  
  return handler
end

function GuildManageWin:getClickInHandler()
  local function handler(x, y, btn)
    if btn and btn.handler then
      btn.handler()
    end
  end
  
  return handler
end

function GuildManageWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildManagerWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    priority = -300
  })
  local size = self.ui.layer_item:getContentSize()
  local numOfCol = 3
  
  local function getPos(i)
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    local ox, oy = size.width / (numOfCol * 2), size.height - 30
    local dx, dy = size.width / numOfCol, 60
    return ccp(ox + col * dx, oy - row * dy)
  end
  
  local numOfBtn = 0
  self.uiList = {}
  for k, v in ipairs(self.btnConfig) do
    if v.show then
      numOfBtn = numOfBtn + 1
      local btn = ed.createScale9Sprite("UI/alpha/1080P/common/button_com_sys.png", CCRectMake(25, 11.5, 25, 11.5))
      btn:setContentSize(CCSizeMake(120, 40))
      local icon = ed.createSprite(v.iconRes)
      icon:setPosition(ccpAdd(ed.getCenterPos(btn), ccp(-34, 1)))
      local label = ed.createttf(v.name, 16)
      ed.adaptLabel(label, {maxWidth = 70, minScale = 0.7})
      label:setColor(ed.toccc3(16776423))
      ed.setLabelShadow(label, ed.toccc3(0), ccp(1, 1))
      label:setPosition(ccpAdd(ed.getCenterPos(btn), ccp(13, 1)))
      btn:setPosition(getPos(numOfBtn))
      btn:addChild(icon)
      btn:addChild(label)
      if v.red then
        btn.red = ed.createSpriteTools({
          res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
          pos = ccp(115, 37),
          parent = btn,
          notShow = not v.red()
        })
      end
      btn.handler = v.handler
      btn.redhDandler = v.red
      self.draglist:addItem(btn)
      table.insert(self.uiList, btn)
    end
  end
  self.draglist:initListHeight(math.floor(numOfBtn / 3) * 60 + 60)
end

function GuildManageWin:dismissGuild()
  if #ed.GuildManager.members > 1 then
    ed.showToast(T("\229\189\147\229\137\141\229\133\172\228\188\154\232\191\152\230\156\137\229\133\182\228\187\150\230\136\144\229\145\152,\228\184\141\232\131\189\232\167\163\230\149\163"))
    return
  end
  local info = {
    text = T("\231\161\174\229\174\154\232\167\163\230\149\163\229\133\172\228\188\154\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      ed.GuildNetwork:sendDismissGuild()
    end
  }
  ed.showConfirmDialog(info)
end

function GuildManageWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  self:listenEvent("MainBuildRedTagChange", function(building)
    if building == ed.ui.configs.mainSceneMap.builddingType.Guild then
      for _, v in ipairs(self.uiList) do
        if v.red then
          v.red:setVisible(v.redhDandler())
        end
      end
    end
  end)
end
