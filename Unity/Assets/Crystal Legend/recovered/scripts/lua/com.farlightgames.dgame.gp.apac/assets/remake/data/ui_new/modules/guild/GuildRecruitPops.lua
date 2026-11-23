local base = ed.ui.popwindow
local guildLiveness = 60000

local function csLocalfunc(res, pos, scale, parent)
  local sprite = ed.createSprite(res)
  sprite:setPosition(pos)
  sprite:setScale(scale or 1)
  if parent then
    parent:addChild(sprite)
  end
  return sprite
end

local guildEnlistSubscribePop = newclass(base.mt)
ed.UITool.registViewOpenFunc("guildEnlistSubscribePop", function(param)
  setmetatable(base.create("guildEnlistSubscribePop"), guildEnlistSubscribePop.mt):create(param):popWindow()
end)

function guildEnlistSubscribePop:create()
  self.fastsellPop, self.ui = ed.editorui(ed.uieditor.GuildEnlistSubscribePop)
  self.container:addChild(self.fastsellPop)
  self:registerTouchHandler()
  local data = ed.GuildManager.guildRecruit
  local tip1 = T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=ccc3(244,222,182)>\230\156\141\229\138\161\232\175\180\230\152\142</lable><br/>") .. T("  <lable color=ccc3(253,251,229)>\229\188\128\229\144\175\229\144\142\239\188\140\230\156\172\229\133\172\228\188\154\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\239\188\140\229\143\175\230\159\165\231\156\139\229\185\182\232\129\148\231\179\187\230\139\155\229\139\159\229\164\167\229\142\133\228\184\173\231\154\132\229\134\146\233\153\169\232\128\133</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=ccc3(244,222,182)>\229\188\128\229\144\175\232\166\129\230\177\130</lable><br/>") .. T("  <lable color=ccc3(253,251,229)>\229\133\172\228\188\154\231\154\132\228\184\137\230\151\165\230\180\187\232\183\131</lable>") .. T("<lable color=ccc3(253,251,229)>\232\190\190\229\136\176</lable><lable color=ccc3(232,177,82)>%d</lable>", guildLiveness) .. T("<lable color=ccc3(253,251,229)>\229\144\142\229\188\128\229\144\175\239\188\136\229\189\147\229\137\141:</lable><lable color=ccc3(232,177,82)>%d</lable><lable color=ccc3(253,251,229)>\239\188\137</lable><br/>", data.guild_liveness or 0)
  local autoText = ed.ui.autoText.new()
  local textWid = self.ui.ImageView_bj:getContentSize().width - 100
  autoText:initParam({
    context = tip1,
    fontSize = 16,
    lineSpacing = 15,
    maxWidth = textWid
  })
  autoText.node:setPosition(0, self.ui.panel_desc:getContentSize().height - 10)
  local draglist = ed.UITool.createDraglist(self.ui.panel_desc, {})
  self.refreshCliprectConfig = {draglist = draglist}
  draglist:addItem(autoText.node)
  local _, atHei = autoText:getCurContentSize()
  draglist:initListHeight(atHei + 10)
  ed.setLabelDimensions(self.ui.label_open_desc, CCSizeMake(textWid, 0))
  ed.left2(self.ui.ImageView_452, self.ui.Label_454, 20)
  ed.right2(self.ui.ImageView_453, self.ui.Label_454, 20)
  self:refreshBtn(data)
  self:listenEvent("GuildRecruitReply", function(type)
    if type == "OpenPanel" then
      self:refreshBtn(ed.GuildManager.guildRecruit)
    end
  end)
  self:show({skipAnim = false})
  return self
end

function guildEnlistSubscribePop:refreshBtn(param)
  self.ui.Panel_open:setVisible(param.has_sub)
  self.ui.Panel_right:setVisible(not param.has_sub)
  if param.has_sub then
    self.ui.Panel_open:setVisible(false)
    self.ui.Panel_right:setVisible(true)
    local second = param.sub_expire_time - ed.getServerTime()
    local h, m, s = ed.second2hms(second)
    local d = math.floor(h / 24)
    local h = h % 24
    if 0 < d then
      self.ui.Label_time:setString(T("%s\229\164\169%s\229\176\143\230\151\182", d, h))
    elseif 0 < h then
      self.ui.Label_time:setString(T("%s\229\176\143\230\151\182", h))
    elseif 0 < m then
      self.ui.Label_time:setString(T("%s\229\136\134\233\146\159", m))
    else
      self.ui.Label_time:setString(T("%s\231\167\146", s))
    end
  else
    self.ui.Panel_open:setVisible(true)
    self.ui.Panel_right:setVisible(false)
  end
end

function guildEnlistSubscribePop:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.ui.ImageView_bj,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_close,
    key = "ImageView_close",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_open,
    key = "btn_open",
    clickHandler = function()
      local data = ed.GuildManager.guildRecruit
      if data.guild_liveness >= guildLiveness then
        ed.GuildRecruitNetwork:sendGuildRecruitSub()
      else
        ed.showToast(T("\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166\228\184\141\232\182\179"))
      end
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.95
  })
end

local GuildEnlistShieldPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("GuildEnlistShieldPop", function(param)
  setmetatable(base.create("GuildEnlistShieldPop"), GuildEnlistShieldPop.mt):create(param):popWindow()
end)

function GuildEnlistShieldPop:create()
  self.fastsellPop, self.ui = ed.editorui(ed.uieditor.GuildEnlistShieldPop)
  self.container:addChild(self.fastsellPop)
  self:registerTouchHandler()
  local data = ed.GuildManager.guildRecruit
  self:show({skipAnim = false})
  return self
end

function GuildEnlistShieldPop:refreshBtn(param)
end

function GuildEnlistShieldPop:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.ui.ImageView_bj,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_close,
    key = "ImageView_close",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
end
