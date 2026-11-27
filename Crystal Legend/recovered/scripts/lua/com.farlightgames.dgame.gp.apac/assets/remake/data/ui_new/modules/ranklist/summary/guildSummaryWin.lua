local base = ed.ui.popwindow
local guildSummaryWin = newclass(base.mt)
ed.ui.guildSummaryWin = guildSummaryWin

function guildSummaryWin.create(index, data)
  local self = base.create("guildSummaryWin")
  setmetatable(self, guildSummaryWin.mt)
  self:init(index, data)
  return self
end

function guildSummaryWin:init(index, data)
  self.index = index
  self.data = data
  self:initView()
  self:addEventListener()
  return self
end

function guildSummaryWin:initView()
  local container, ui = ed.editorui(ed.uieditor.guildSummary)
  self.ui = ui
  self.container:addChild(container)
  self:show()
  local avatar = ed.analyzeAvatar(self.data._avatar)
  avatar.avatar = avatar.avatar or 1
  avatar.avatarFrame = avatar.avatarFrame or 0
  local avatarData = ed.analyzeAvatar(self.data._avatar)
  local head = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  self.ui.guildIcon:addChild(head)
  ed.layout.centerInParent(head)
  self.ui.guildName:setString(self.data._name or "")
  self.ui.guildID:setString(self.data._id)
  if self.data.server then
    self.ui.guildID:setVisible(false)
    self.ui.guildIDLabel:setString(self.data.server)
    self.ui.guildIDLabel:setColor(ccc3(245, 207, 141))
  end
  if self.data.power then
    ed.createLabelTools({
      txt = T("\229\135\186\229\190\129\233\152\159\228\188\141\230\128\187\230\136\152\229\138\155\239\188\154%s", self.data.power),
      size = 17,
      pos = ccp(32.75, 35),
      anchor = ccp(0, 0.5),
      color = ccc3(255, 252, 231),
      stroke = {
        ccc3(ed.colorToStr("#614017")),
        1
      },
      parent = self.ui.bg
    })
  end
  if 0 == self.index then
    self.ui.guildRank:setString(T("\230\156\170\228\184\138\230\166\156"))
  else
    local rankNode = ed.getNumberNode({
      text = tostring(self.index),
      folder = "big_pvp",
      scale = 0.75
    }).node
    self.ui.bg:addChild(rankNode)
    rankNode:setPositionX(self.ui.guildRank:getPositionX() + rankNode:getContentSize().width / 2)
    rankNode:setPositionY(self.ui.guildRank:getPositionY())
  end
  self.ui.guildPresidentName:setString(self.data._president._name)
  local name = ed.getPlayerName(self.data._president._name, self.data._president._medal, {
    anchorPoint = ccp(0, 0.5),
    fontSize = 18,
    labelColor = "ccc3(254,211,109)"
  })
  ed.UITool.replaceUI(self.ui, "bg", "guildPresidentName", name)
  self.ui.memberCount:setString(self.data._member_cnt)
  local slogan = self.data._slogan == "" and T("\230\151\160") or self.data._slogan
  ed.setLabelDimensions(self.ui.guildSlogan, CCSizeMake(260, 0))
  self.ui.guildSlogan:setHorizontalAlignment(kCCTextAlignmentLeft)
  self.ui.guildSlogan:setVerticalAlignment(kCCVerticalTextAlignmentTop)
  self.ui.guildSlogan:setString(slogan)
end

function guildSummaryWin:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "close",
    force = true,
    clickInterval = 0.2,
    clickHandler = function()
      self:close()
    end
  })
end

function guildSummaryWin:close()
  self:destroy()
end
