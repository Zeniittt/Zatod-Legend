local base = ed.ui.popwindow
local GuildSettingWin = newclass(base.mt)
ed.ui.GuildSettingWin = GuildSettingWin

function GuildSettingWin.create(param)
  local self = base.create("GuildSettingWin")
  setmetatable(self, GuildSettingWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildSettingWin:initData(param)
  self.mgr = ed.GuildManager
  self.name = self.mgr.name
  self.type = self.mgr.joinType
  self.joinLimit = self.mgr.joinLimit
  self.avatar = self.mgr.avatar
  self.frame = self.mgr.frame
end

function GuildSettingWin:refreshAvatar()
  local guildIcon = ed.createGuildAvatar(self.avatar, self.frame)
  ed.UITool.replaceUI(self.ui, "bg", "avatar", guildIcon)
end

function GuildSettingWin:initLabels()
  ed.setLabelShadow(self.ui.label_change_avatar, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_change_frame, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_change_name, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_ok, ccc3(0, 0, 0), ccp(1, 0))
  local maxTextWid = 90
  local labelWid = self.ui.label_change_frame:getContentSize().width
  if maxTextWid < labelWid then
    self.ui.label_change_frame:setScale(maxTextWid / labelWid)
  end
  if self.ui.label_level:getContentSize().width > 120 then
    self.ui.label_level:setScale(120 / self.ui.label_level:getContentSize().width)
  end
  self.ui.label_avatar:limitWidthByScale(110)
  ed.adaptLabel(self.ui.label_change_name, {
    maxWidth = self.ui.btn_change_name:getContentSize().width - 4,
    minScale = 0.8
  })
end

function GuildSettingWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.GuildSettingWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:refreshGuildType()
  self:refreshAvatar()
  self:refreshName()
  self:refreshJoinLevel()
end

function GuildSettingWin:refreshName()
  ed.setString(self.ui.name, self.name)
end

function GuildSettingWin:refreshJoinLevel()
  ed.setString(self.ui.level, self.joinLimit)
end

function GuildSettingWin:refreshGuildType()
  ed.setString(self.ui.type, self.mgr.guildType[self.type])
end

function GuildSettingWin:doClickSetting()
  self.mgr.settingData = {
    avatar = self.avatar,
    frame = self.frame,
    type = self.type,
    joinLimit = self.joinLimit,
    name = self.name
  }
  local msg = ed.upmsg.guild()
  msg._set = {}
  msg._set._avatar = ed.packAvatar(self.frame, self.avatar)
  msg._set._join_type = self.type
  msg._set._join_limit = self.joinLimit
  msg._set._change_guild_name = self.name
  ed.send(msg, "guild")
  self:destroy()
end

function GuildSettingWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_change_avatar", function()
    ed.ui.GuildChangeHeadWin.create({
      callback = function(id)
        self.avatar = id
        self:refreshAvatar()
      end
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_change_frame", function()
    ed.ui.GuildChangeFrameWin.create({
      callback = function(frame)
        self.frame = frame
        self:refreshAvatar()
      end
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_change_name", function()
    if self.mgr.lastSetNameTime + 259200 > ed.getServerTime() then
      local timeStr = ed.time2dhms(self.mgr.lastSetNameTime + 259200 - ed.getServerTime())
      ed.showToast(string.format(T("\232\191\152\233\156\128%s\230\137\141\232\131\189\230\148\185\229\144\141"), timeStr))
      return
    end
    if ed.player._rmb < 500 then
      ed.showHandyDialog("toRecharge")
      return
    end
    local info = {
      text = T("\228\191\174\230\148\185\229\133\172\228\188\154\229\144\141\233\156\128\232\138\177\232\180\185500\233\146\187\231\159\179\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.ui.GuildChangeNameWin.create({
          callback = function(name)
            if self.name and self.name ~= "" then
              local _, count = string.gsub(name, "[^\128-\193]", "")
              if "" == name then
                ed.showToast(T("\229\133\172\228\188\154\229\144\141\231\167\176\228\184\141\232\131\189\228\184\186\231\169\186"))
                return
              end
              if 7 < count then
                ed.showToast(T("\229\133\172\228\188\154\229\144\141\231\167\176\228\184\141\229\190\151\232\182\133\232\191\1357\228\184\170\229\173\151"))
                return
              end
              if ed.dirtyword_check(name) then
                ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
                return
              end
              self.name = name
              self:refreshName()
            end
          end
        })
      end
    }
    ed.showConfirmDialog(info)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_type_left", function()
    if self.type == "no_verify" then
      self.type = "verify"
    elseif self.type == "verify" then
      self.type = "closed"
    else
      self.type = "no_verify"
    end
    self:refreshGuildType()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_type_right", function()
    if self.type == "no_verify" then
      self.type = "closed"
    elseif self.type == "verify" then
      self.type = "no_verify"
    else
      self.type = "verify"
    end
    self:refreshGuildType()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_level_left", function()
    if self.joinLimit == 1 then
      return
    end
    self.joinLimit = self.joinLimit - 1
    self:refreshJoinLevel()
  end, {
    normalScale = 0.8,
    pressScale = 0.75,
    clickInterval = 0.1
  })
  ed.UITool.registerBtn(self, "btn_right_left", function()
    if self.joinLimit == 80 then
      return
    end
    self.joinLimit = self.joinLimit + 1
    self:refreshJoinLevel()
  end, {
    normalScale = 0.8,
    pressScale = 0.75,
    clickInterval = 0.1
  })
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:doClickSetting()
  end, {pressScale = 0.9})
end

function GuildSettingWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self)
end
