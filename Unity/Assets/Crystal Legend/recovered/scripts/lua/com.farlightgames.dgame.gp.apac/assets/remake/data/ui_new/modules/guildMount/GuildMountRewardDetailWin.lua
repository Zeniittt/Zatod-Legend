local GuildMountRewardDetailWin = {}
GuildMountRewardDetailWin.__index = GuildMountRewardDetailWin
ed.ui.GuildMountRewardDetailWin = GuildMountRewardDetailWin
local base = ed.ui.popwindow
setmetatable(GuildMountRewardDetailWin, base.mt)
local MAX_RANK = 999999

function GuildMountRewardDetailWin.create(params)
  local panel = base.create("GuildMountRewardDetailWin")
  setmetatable(panel, GuildMountRewardDetailWin)
  panel:initData(params)
  panel:initAppearance()
  panel:registerTouchHandler()
  panel:popWindow(514)
  return panel
end

function GuildMountRewardDetailWin:destroy()
  ed.playEffect(ed.sound.deo.common_close_popup_window)
  if self.mainLayer then
    self.mainLayer:setTouchEnabled(false)
    self.mainLayer:removeFromParentAndCleanup(true)
    self.mainLayer = nil
  end
end

function GuildMountRewardDetailWin:initData(params)
  params = params or {}
  self.rank = params.rank
  self.score = params.score
end

function GuildMountRewardDetailWin:initAppearance()
  local mainLayer = self.mainLayer
  local container, ui = ed.editorui(ed.uieditor.star_gate_reward_panel)
  self.container = container
  self.ui = ui
  mainLayer:addChild(container)
  ed.setString(self.ui.Label_3613, T("\229\188\130\231\149\140\229\177\177\230\180\187\229\138\168\231\187\147\230\157\159\229\165\150\229\138\177"))
  self:createDragList()
  self:createRewards()
end

function GuildMountRewardDetailWin:createDragList()
  local contentSize = self.ui.node_list:getContentSize()
  self.contentSize = contentSize
  local info = {
    cliprect = CCRectMake(0, 0, contentSize.width, contentSize.height),
    container = self.ui.node_list,
    noshade = true,
    priority = -401,
    bar = {
      bglen = contentSize.height,
      bgpos = ccp(1, contentSize.height / 2)
    },
    doPressIn = self:getDoPressInHander(),
    doClickIn = self:getDoClickInHander()
  }
  self.draglist = ed.draglist.create(info)
end

function GuildMountRewardDetailWin:getDoPressInHander()
  local function doPressIn(x, y)
  end
  
  return doPressIn
end

function GuildMountRewardDetailWin:getDoClickInHander()
  local function doClickIn(x, y)
  end
  
  return doClickIn
end

function GuildMountRewardDetailWin:createRewards()
  local rewardTable = ed.getDataTable("GuildMountSeasonReward")
  local rankArr = {}
  for k, v in pairs(rewardTable) do
    if type(k) == "number" then
      table.insert(rankArr, v.Rank)
    end
  end
  table.sort(rankArr, function(e1, e2)
    return e1 < e2
  end)
  local content
  if self.rank then
    local myRewardRank = MAX_RANK
    for k, v in ipairs(rankArr) do
      if v >= self.rank then
        myRewardRank = v
        break
      end
    end
    local myRankStr = self:getRewardsRichTextStr(rewardTable[myRewardRank])
    content = {
      T("<text|normalButton|\229\133\172\228\188\154\231\155\174\229\137\141\231\167\175\229\136\134\228\184\186%d\239\188\140\230\142\146\229\144\141\230\152\175%d\229\144\141\239\188\140\233\162\132\232\174\161\230\180\187\229\138\168\231\187\147\230\157\159\229\143\175\233\162\134\229\143\150\231\154\132\229\165\150\229\138\177\228\184\186\239\188\154|500>", self.score, self.rank),
      T("<text|normalButton|       |500>"),
      myRankStr
    }
  else
    content = {
      T("<text|normalButton|\229\133\172\228\188\154\230\178\161\230\156\137\229\175\185BOSS\233\128\160\230\136\144\228\188\164\229\174\179\239\188\140\230\154\130\230\151\160\231\167\175\229\136\134\230\142\146\229\144\141\227\128\130|500>")
    }
  end
  local rankRewards = {}
  for i = 1, #rankArr do
    local curRank = rankArr[i]
    local preRank = rankArr[i - 1] and rankArr[i - 1] + 1 or 1
    local result
    if i < #rankArr then
      result = T("\231\172\172%d\232\135\179\231\172\172%d\229\144\141", preRank, curRank)
    else
      result = T("%d\229\144\141\228\187\165\229\144\142", preRank)
    end
    result = string.format("<text|normalButton|%s: >%s", result, self:getRewardsRichTextStr(rewardTable[curRank]))
    table.insert(rankRewards, result)
  end
  table.insert(content, T("<text|normalButton|       |500>"))
  table.insert(content, T("<text|normalButton|\228\187\165\228\184\139\228\184\186\229\188\130\231\149\140\229\177\177\230\180\187\229\138\168\231\187\147\230\157\159\231\167\175\229\136\134\230\142\146\229\144\141\229\165\150\229\138\177\232\161\168\239\188\154|500>"))
  table.insert(content, T("<text|normalButton|       |500>"))
  for i, rewardStr in pairs(rankRewards) do
    table.insert(content, rewardStr)
    if i == 19 then
      break
    end
  end
  local textHeight = 30
  local ty = self.contentSize.height
  local dy = 5
  for _, text in ipairs(content) do
    local richText = self:createRichText(text, ccp(20, ty - textHeight), ccp(0, 0.5))
    self.draglist.listLayer:addChild(richText.rootNode)
    textHeight = textHeight + richText:getContentSize().height + dy
  end
  self.draglist:initListHeight(textHeight + 50 - 30)
end

function GuildMountRewardDetailWin:createRichText(string, position, anchor)
  local rich_text = richText:new()
  rich_text:setPosition(position)
  rich_text:setAnchor(anchor)
  rich_text:setString(string)
  return rich_text
end

function GuildMountRewardDetailWin:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    press = self.ui.btn_close_press,
    key = "btn_close",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end

function GuildMountRewardDetailWin:getRewardRichTextStr(row, index)
  local typ = row["Reward Type" .. index]
  local id = row["Reward ID" .. index]
  local amount = row["Reward Amount" .. index]
  if typ == "Item" then
    return string.format("<item|%d|0.5><text|pressButton| \195\151%d >", id, amount)
  elseif typ == "Gold" then
    return string.format("<sprite|UI/alpha/HVGA/goldicon.png|0.5><text|pressButton| %d >", amount)
  elseif typ == "Diamond" then
    return string.format("<sprite|UI/alpha/HVGA/task_rmb_icon.png|0.5><text|pressButton| %d >", amount)
  elseif typ == "Medal" then
    local medalTbl = ed.getDataTable("Medal")
    local medalinfo = medalTbl[id]
    if medalinfo then
      local pic_res = medalinfo.Picture
      local nameStr = medalinfo.Name
      return string.format("<sprite|%s|0.5><text|pressButton| %s >", pic_res, nameStr)
    end
  else
    error("Unknown Type: " .. typ)
  end
end

function GuildMountRewardDetailWin:getRewardsRichTextStr(row)
  if nil == row then
    return
  end
  local result = ""
  for i = 1, 5 do
    local typ = row["Reward Type" .. i]
    if typ then
      local str = self:getRewardRichTextStr(row, i)
      result = result .. str
    end
  end
  return result
end
