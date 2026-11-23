local base = ed.ui.popwindow
local activityAllStarRankPop = newclass(base.mt)
ed.ui.activityAllStarRankPop = activityAllStarRankPop
ed.UITool.registViewOpenFunc("activityAllStarRankPop", function(param)
  activityAllStarRankPop.create(param or {}):popWindow()
end)

function activityAllStarRankPop.create(param)
  return setmetatable(base.create("activityAllStarRankPop"), activityAllStarRankPop.mt):init(param or {})
end

function activityAllStarRankPop:init(param)
  self.param = param
  self:editorui()
  self:initView()
  self:addEventListen()
  self:show({skipAnim = false})
  return self
end

function activityAllStarRankPop:editorui()
  self.uieditorLayer, self.ui = ed.editorui(ed.uieditor.activity_allstar_rank_pop)
  self.container:addChild(self.uieditorLayer)
  local mySummary = ed.getPlayerSummary()
  local myHead, headIcon = ed.getWholeHeadIcon({
    id = mySummary._avatar
  })
  myHead:setScale(0.8)
  myHead:setPosition(100, 44.75)
  self.ui.ImageView_3459:addChild(myHead)
  local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(183,255,98)"
  })
  name:setPosition(140, 56.75)
  self.ui.ImageView_3459:addChild(name)
  ed.createLabelTools({
    txt = tostring(game_server_name),
    size = 16,
    pos = ccp(140, 32.75),
    color = ccc3(ed.colorToStr("#FDF081")),
    parent = self.ui.ImageView_3459,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    }
  })
  self.allGiveCount = self.param.selfRank and (self.param.selfRank._param1 or 0) or 0
  self.ui.Label_3484:setString(T("\232\142\183\232\181\160\230\128\187\230\149\176\239\188\154%s", self.allGiveCount))
  ed.ActivityNetwork.sendAllStarRankGiveRecordMsg()
  self.ui.Label_3484:setStroke(ccc3(ed.colorToStr("#221505")), 1.3)
  self.ui.Label_34844:setStroke(ccc3(ed.colorToStr("#221505")), 1.3)
  self.ui.Label_button_selected_1:setStroke(ccc3(ed.colorToStr("#352711")), 1.5)
  self.ui.Label_button_selected_2:setStroke(ccc3(ed.colorToStr("#352711")), 1.5)
  for i = 0, 6 do
    self.ui["Label_404" .. i]:setShadow(ccc3(ed.colorToStr("#1b150f")), ccp(0, 2))
  end
  self.ui.headIcon = headIcon
end

function activityAllStarRankPop:initView()
  local thisCon = self.ui.Panel_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_item,
    priority = -300,
    noshade = true,
    zorder = 10,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
end

function activityAllStarRankPop:addEventListen()
  self:btRegisterOutClick({
    area = self.ui.ImageView_27,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.headIcon,
    key = "headIconSelf",
    force = true,
    mcpMode = true,
    pressScale = 0.95,
    clickHandler = function()
      ed.registerNetReply("personal_home_page", function(data)
        local panel = ed.ui.PlayerInfoPanel.create(data, true)
        panel:popWindow()
      end)
      ed.PlayerInfoNetwork:openPanel()
    end
  })
  for index = 1, 2 do
    self:btRegisterButtonClick({
      button = self.ui["button_" .. index],
      selected = self.ui["button_selected_" .. index],
      key = "number" .. index,
      radioGroupName = "number",
      clickHandler = function()
        self.ui.ImageView_888:setVisible(index == 1)
        self.ui.ImageView_999:setVisible(index == 2)
        if index == 1 then
          ed.ActivityNetwork.sendAllStarRankGiveRecordMsg()
        else
          ed.ActivityNetwork.sendAllStarRankGetMsg()
        end
      end
    })
  end
  self:listenEvent("allStarReply", function(info)
    local data, itemBox = nil, self.itemBox
    info = ed.copyProto(info)
    if info._give_record then
      data = info._give_record._records or {}
      local give_num = info._give_record._give_num
      local get_num = info._give_record._get_num
      self.ui.Label_3484:setString(T("\232\142\183\232\181\160\230\128\187\230\149\176\239\188\154%s", get_num))
      self.ui.Label_34844:setString(T("\232\181\160\233\128\129\230\128\187\230\149\176\239\188\154%s", give_num))
    elseif info._get_rank then
      data = info._get_rank._rank_list or {}
      itemBox = self.rankItemBox
      table.sort(data, function(a, b)
        return a._param1 > b._param1
      end)
    end
    if data then
      self.items = {}
      self.dragList:clearList()
      local thisCon = self.ui.Panel_item:getContentSize()
      for i, v in ipairs(data) do
        local item = itemBox.create(self, v, i)
        self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2 - 1.3, thisCon.height - 54 * i + 26))
        table.insert(self.items, item)
      end
      self.dragList:initListHeight(#data * 54 + 2)
    end
  end)
end

local itemBox = {}

function itemBox.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemBox})
  this:initUi(param)
  return this
end

function itemBox:initUi(param)
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_rank/record2.png"
  })
  local summary = param._user
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar
  })
  head:setPosition(68, 26)
  head:setScale(0.5)
  bg:addChild(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(255,252,231)"
  })
  name:setPosition(ccp(95, 36))
  bg:addChild(name)
  name:setScale(0.8)
  ed.createLabelTools({
    txt = T(param._svr_name),
    size = 14,
    pos = ccp(97, 16),
    color = ccc3(ed.colorToStr("#fff088")),
    parent = bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = T(param._is_give == 1 and "\232\181\160\229\135\186" or "\232\142\183\232\181\160"),
    size = 17,
    pos = ccp(278, 26),
    color = ccc3(ed.colorToStr(param._is_give == 1 and "#fffce7" or "#fff088")),
    parent = bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr(param._is_give == 1 and "#221505" or "#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = T(param._num),
    size = 16,
    pos = ccp(370, 26),
    color = ccc3(ed.colorToStr(param._is_give == 1 and "#fffce7" or "#fff088")),
    parent = bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr(param._is_give == 1 and "#221505" or "#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = T(ed.getYMDHMSTime(param._time)),
    size = 16,
    pos = ccp(540, 26),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    }
  })
  self.ui = {bg = bg, headIcon = headIcon}
end

activityAllStarRankPop.itemBox = itemBox
local rankItemBox = {}

function rankItemBox.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = rankItemBox})
  this:initUi(param)
  return this
end

function rankItemBox:initUi(param)
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_rank/giveaway_rank2.png"
  })
  ed.createLabelTools({
    txt = T(self.index),
    size = 16,
    pos = ccp(40, 26),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    }
  })
  local summary = param._user_summary
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar
  })
  head:setPosition(145, 26)
  head:setScale(0.5)
  bg:addChild(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(255,252,231)"
  })
  name:setPosition(ccp(171, 36))
  bg:addChild(name)
  name:setScale(0.8)
  ed.createLabelTools({
    txt = T(param._param4),
    size = 14,
    pos = ccp(173, 16),
    color = ccc3(ed.colorToStr("#fff088")),
    parent = bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = param._param1 or "?",
    size = 16,
    pos = ccp(483, 26),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#221505")),
      1.3
    }
  })
  self.ui = {bg = bg, headIcon = headIcon}
end

activityAllStarRankPop.rankItemBox = rankItemBox

function activityAllStarRankPop:doPressInList()
  local function handler(x, y)
    for k, v in pairs(self.items or {}) do
      if ed.containsPoint(v.ui.headIcon, x, y) then
        v.ui.headIcon:setScale(0.95)
        
        return {
          icon = v.ui.headIcon,
          fun = function()
            local summary = v.param._user or v.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end
        }
      end
    end
  end
  
  return handler
end

function activityAllStarRankPop:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityAllStarRankPop:cancelClickInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityAllStarRankPop:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun()
    end
  end
  
  return handler
end
