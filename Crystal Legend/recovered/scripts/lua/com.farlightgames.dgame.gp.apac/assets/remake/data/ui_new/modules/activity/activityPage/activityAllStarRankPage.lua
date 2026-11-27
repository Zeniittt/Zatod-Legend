local activityAllStarRankPage = newclass("g")
ed.ui.activityAllStarRankPage = activityAllStarRankPage

function activityAllStarRankPage.create(base, param, pageKey)
  local this = {}
  setmetatable(activityAllStarRankPage, {__index = base})
  setmetatable(this, {__index = activityAllStarRankPage})
  local container, ui = ed.editorui(ed.uieditor.activity_allstar_rank_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:initView(param)
  this:setButtonClick()
  this:listenEvent("allStarReply", function(info)
    this:pageRefresh(info)
  end)
  this:listenEvent("req_home_page", function(data)
    ed.ui.PlayerInfoPanel.create(data, false):popWindow()
  end)
  this.objWork.sendAllStarRankMsg(1, 100)
  return this
end

function activityAllStarRankPage:initView(param)
  local endTime = ed.dateStringToTime(ed.getDataTable("AllStar")[1]["End Time"])
  if endTime >= ed.getServerTime() then
    self.ui.Label_time:setString(T("\230\180\187\229\138\168\229\128\146\232\174\161\230\151\182:%s", self.objData.getEndTime(endTime) or 0))
  else
    self.showTime = true
    self.ui.Panel_count:setVisible(false)
    local ShowTime = ed.dateStringToTime(ed.getDataTable("AllStar")[1]["Show Time"])
    self.ui.Label_time:setString(T("\229\177\149\231\164\186\229\128\146\232\174\161\230\151\182:%s", self.objData.getEndTime(ShowTime) or 0))
  end
  local task = param._tasks
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
  local count = ed.player.equip_qunty[ed.getDataTable("AllStar")[1]["Star ID"]] or 0
  self.ui.Label_3378:setString(count)
  local size = self.ui.ImageView_count:getContentSize()
  self.ui.ImageView_count:setContentSize(CCSizeMake(50 + #tostring(count) * 7.2, size.height))
  
  local function getFrameId(RewardId)
    for id, v in pairs(ed.getDataTable("AvatarFrame")) do
      if v["Requirement ID"] == RewardId then
        return id
      end
    end
  end
  
  self.frameIcons = {}
  local AllStar = ed.getDataTable("AllStar")[1]
  local frameId = getFrameId(AllStar["Send Reward ID"])
  local icon = ed.createItemIcon({
    id = AllStar["Send Reward ID"],
    amount = AllStar["Send Reward Amount"]
  })
  if frameId then
    local bgImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/avatar_bg.png",
      parent = self.dragList.listLayer,
      pos = ccp(100, thisCon.height / 2 + 128),
      scale = 0.8
    })
    icon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
    table.insert(self.frameIcons, {
      icon = bgImg,
      id = AllStar["Send Reward ID"]
    })
  end
  self.dragList:addItem(icon, ccp(100, thisCon.height / 2 + 128))
  ed.createLabelTools({
    txt = T("\232\181\160\233\128\129%d\231\137\135", AllStar["Send Star"]),
    size = 15,
    pos = ccp(50.25, 11),
    color = ed.toccc3(16776423),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_avatar_gb.png",
      parent = self.dragList.listLayer,
      pos = ccp(100, thisCon.height / 2 + 80)
    })
  })
  icon:setScale(0.8)
  local frameId = getFrameId(AllStar["Get Reward ID"])
  local icon = ed.createItemIcon({
    id = AllStar["Get Reward ID"],
    amount = AllStar["Get Reward Amount"]
  })
  if frameId then
    local bgImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/avatar_bg.png",
      parent = self.dragList.listLayer,
      pos = ccp(230, thisCon.height / 2 + 132),
      scale = 0.85
    })
    icon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
    table.insert(self.frameIcons, {
      icon = bgImg,
      id = AllStar["Get Reward ID"]
    })
  end
  self.dragList:addItem(icon, ccp(230, thisCon.height / 2 + 132))
  ed.createLabelTools({
    txt = T("\232\142\183\232\181\160%d\231\137\135", AllStar["Get Star"]),
    size = 15,
    pos = ccp(50.25, 11),
    color = ed.toccc3(16776423),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_avatar_gb.png",
      parent = self.dragList.listLayer,
      pos = ccp(230, thisCon.height / 2 + 80)
    })
  })
  icon:setScale(0.85)
  local AllStarRank = ed.getDataTable("AllStarRank")[1]
  local frameId = getFrameId(AllStarRank[2]["Reward ID 1"])
  local icon = ed.createItemIcon({
    id = AllStarRank[2]["Reward ID 1"],
    amount = AllStarRank[2]["Reward Amount 1"]
  })
  if frameId then
    local bgImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/avatar_bg.png",
      parent = self.dragList.listLayer,
      pos = ccp(360, thisCon.height / 2 + 137),
      scale = 0.9
    })
    icon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
    table.insert(self.frameIcons, {
      icon = bgImg,
      id = AllStarRank[2]["Reward ID 1"]
    })
  end
  self.dragList:addItem(icon, ccp(360, thisCon.height / 2 + 137))
  ed.createLabelTools({
    txt = T("\232\142\183\232\181\160\229\137\141%d\229\144\141", AllStarRank[2]["Top Rank"]),
    size = 15,
    pos = ccp(50.25, 11),
    color = ed.toccc3(16776423),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_avatar_gb.png",
      parent = self.dragList.listLayer,
      pos = ccp(360, thisCon.height / 2 + 80)
    })
  })
  icon:setScale(0.9)
  local frameId = getFrameId(AllStarRank[1]["Reward ID 1"])
  local icon = ed.createItemIcon({
    id = AllStarRank[1]["Reward ID 1"],
    amount = AllStarRank[1]["Reward Amount 1"]
  })
  if frameId then
    local bgImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/avatar_bg.png",
      parent = self.dragList.listLayer,
      pos = ccp(thisCon.width / 2 + 190, thisCon.height / 2 + 143)
    })
    icon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
    table.insert(self.frameIcons, {
      icon = bgImg,
      id = AllStarRank[1]["Reward ID 1"]
    })
  end
  self.dragList:addItem(icon, ccp(thisCon.width / 2 + 190, thisCon.height / 2 + 143))
  ed.createLabelTools({
    txt = T("\232\142\183\232\181\160\229\137\141%d\229\144\141", AllStarRank[1]["Top Rank"]),
    size = 15,
    pos = ccp(50.25, 11),
    color = ed.toccc3(16776423),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_avatar_gb.png",
      parent = self.dragList.listLayer,
      pos = ccp(thisCon.width / 2 + 190, thisCon.height / 2 + 80)
    })
  })
  self.ui.Label_3491:setStroke(ccc3(ed.colorToStr("#221505")), 1.5)
  self.ui.Label_3375:setStroke(ccc3(2, 2, 2), 1.2)
  self.ui.Label_3378:setStroke(ccc3(2, 2, 2), 1)
end

function activityAllStarRankPage:pageUpDate(param)
  self.param = param
end

function activityAllStarRankPage:pageRefresh(info)
  if info._query_rankboard then
    self.selfRank = info._query_rankboard._self_rank or {}
    self.rankList = info._query_rankboard._rank_list or {}
    self:refreshDragList()
  elseif info._give and info._give._result == "success" then
    self.objWork.sendAllStarRankMsg(1, 100)
  end
end

function activityAllStarRankPage:refreshDragList()
  for i, v in ipairs(self.items or {}) do
    v.ui.bg:removeFromParentAndCleanup(true)
  end
  self.items = {}
  local thisCon = self.ui.Panel_item:getContentSize()
  for i, v in ipairs(self.rankList) do
    local item = self.itemBox.create(self, v, i)
    self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2, thisCon.height - 84 * i + 42 - 130))
    self.items[v._user_summary._role_id] = item
  end
  self.dragList:initListHeight(#self.rankList * 85 + 130)
  self.ui.ImageView_nil:setVisible(#self.rankList == 0)
end

function activityAllStarRankPage:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.btn_record,
    key = "btn_record",
    force = true,
    mcpMode = true,
    pressScale = 0.94,
    clickHandler = function()
      ed.ui.activityAllStarRankPop.create({
        selfRank = self.selfRank
      }):popWindow()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.rule_btn,
    key = "rule_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      local head = self.param._head
      ed.ui.commonRulePop.create({
        title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
        txt = T(head._rules or "")
      }):popWindow()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_count,
    key = "ImageView_count",
    force = true,
    mcpMode = true,
    pressScale = 1,
    clickHandler = function()
      ed.UITool.openView("packageDetail", {
        id = ed.getDataTable("AllStar")[1]["Star ID"],
        type = "item"
      })
    end
  })
  for i, v in ipairs(self.frameIcons) do
    self:btRegisterButtonClick({
      button = v.icon,
      key = "frameIcons_" .. i,
      force = true,
      mcpMode = true,
      pressScale = v.icon:getScale() - 0.05,
      normalScale = v.icon:getScale(),
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.Panel_item, x, y) then
          return
        end
        ed.UITool.openView("packageDetail", {
          id = v.id,
          type = "item"
        })
      end
    })
  end
  self:listenEvent("ResourceNumChange", function(resType, id)
    if id == ed.getDataTable("AllStar")[1]["Star ID"] then
      local count = ed.player.equip_qunty[ed.getDataTable("AllStar")[1]["Star ID"]] or 0
      self.ui.Label_3378:setString(count)
      local size = self.ui.ImageView_count:getContentSize()
      self.ui.ImageView_count:setContentSize(CCSizeMake(50 + #tostring(count) * 5, size.height))
    end
  end)
  self:listenTimer(Timer:Always(0), function()
    local posY = self.dragList.listLayer:getPositionY()
    local size = self.ui.ImageView_3372:getContentSize()
    self.ui.ImageView_3372:setContentSize(CCSizeMake(size.width, 272.5 + ed.clamp(posY, -200, 126)))
  end)
end

function activityAllStarRankPage:setVisibleCallBack(isVisible)
  self.dragList:setVisible(isVisible)
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
  local num = self.index > 4 and 4 or self.index
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_rank/allstar_tank" .. num .. ".png"
  })
  local rankNum
  if num < 4 then
    local res = {
      "rank_1st.png",
      "rank_2nd.png",
      "rank_3rd.png"
    }
    rankNum = ed.createSpriteTools({
      res = "UI/alpha/1080P/toparena/rank/" .. res[num],
      parent = bg,
      pos = ccp(70, 40.75)
    })
  else
    rankNum = ed.getNumberNode({
      text = self.index or 0,
      folder = "peakarena_rank"
    }).node
    rankNum:setPosition(70, 40.75)
    bg:addChild(rankNum)
  end
  local summary = param._user_summary
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar
  })
  head:setPosition(170, 40.75)
  head:setScale(0.8)
  bg:addChild(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(173,255,107)",
    fontSize = 17
  })
  name:setPosition(ccp(214, 53.75))
  bg:addChild(name)
  ed.createLabelTools({
    txt = T(param._param4),
    size = 17,
    pos = ccp(216, 27.75),
    color = ccc3(ed.colorToStr("#fff088")),
    parent = bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  local numbg = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_rank/feather_num_bg.png",
    parent = bg,
    pos = ccp(430, 40.75)
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_rank/feather.png",
    parent = numbg,
    pos = ccp(10, 13)
  })
  local nums = ed.createLabelTools({
    txt = T(param._param1),
    size = 18,
    pos = ccp(60, 13),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = numbg,
    font = ed.fontBold
  })
  local giveBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/allstar/allstar_rank/give_away.png",
    parent = bg,
    pos = ccp(555, 45.75)
  })
  ed.createLabelTools({
    txt = T("\232\181\160\233\128\129"),
    size = 17,
    pos = ccp(19.5, 0),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = giveBtn,
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  giveBtn:setVisible(not self.mainSelf.showTime)
  self.ui = {
    bg = bg,
    nums = nums,
    rankNum = rankNum,
    headIcon = headIcon,
    giveBtn = giveBtn
  }
end

function itemBox:update(param, index)
  self.ui.nums:setString(param._param1)
  self.param = param
  self.index = index
  local num = self.index > 4 and 4 or self.index
  if self.ui.rankNum then
    self.ui.rankNum:removeFromParentAndCleanup(true)
  end
  local rankNum
  if num < 4 then
    local res = {
      "rank_1st.png",
      "rank_2nd.png",
      "rank_3rd.png"
    }
    rankNum = ed.createSpriteTools({
      res = "UI/alpha/1080P/toparena/rank/" .. res[num],
      parent = self.ui.bg,
      pos = ccp(70, 40.75)
    })
  else
    rankNum = ed.getNumberNode({
      text = self.index or 0,
      folder = "peakarena_rank"
    }).node
    rankNum:setPosition(70, 40.75)
    self.ui.bg:addChild(rankNum)
  end
  self.ui.rankNum = rankNum
end

activityAllStarRankPage.itemBox = itemBox

function activityAllStarRankPage:doPressInList()
  local function handler(x, y)
    for k, v in pairs(self.items or {}) do
      if ed.containsPoint(v.ui.headIcon, x, y) then
        v.ui.headIcon:setScale(0.95)
        
        return {
          icon = v.ui.headIcon,
          fun = function()
            local summary = v.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end
        }
      elseif ed.containsPoint(v.ui.giveBtn, x, y) then
        v.ui.giveBtn:setScale(0.95)
        return {
          icon = v.ui.giveBtn,
          fun = function()
            local summary = v.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end
        }
      end
    end
  end
  
  return handler
end

function activityAllStarRankPage:cancelPressInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityAllStarRankPage:cancelClickInList()
  local function handler(x, y, info)
    info.icon:setScale(info.normalScale or 1)
  end
  
  return handler
end

function activityAllStarRankPage:doClickInList()
  local function handler(x, y, info)
    if info.fun then
      info.fun()
    end
  end
  
  return handler
end
