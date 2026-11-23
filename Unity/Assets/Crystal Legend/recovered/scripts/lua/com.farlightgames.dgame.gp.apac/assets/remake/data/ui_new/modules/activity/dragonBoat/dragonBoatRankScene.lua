local base = ed.ui.basescene
local dragonBoatRankScene = newclass(base.mt)
ed.ui.dragonBoatRankScene = dragonBoatRankScene
ed.UITool.registViewOpenFunc("dragonBoatRankScene", function()
  ed.pushScene(ed.ui.dragonBoatRankScene.create())
end)

function dragonBoatRankScene.create()
  return setmetatable(base.create("dragonBoatRankScene", {noBottomButton = true}), dragonBoatRankScene.mt):init()
end

function dragonBoatRankScene:init()
  self:initUI()
  self:createList()
  self:createHeadIcon()
  self:registerEvents()
  ed.dragonBoatNet:sendQueryRank()
  return self
end

function dragonBoatRankScene:initData(param)
  self.selfRank = param._self_rank or {}
  self.rankList = param._rank_list or {}
end

function dragonBoatRankScene:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.dragonBoatRankScene)
  self.mainLayer:addChild(self.container)
  local name = ed.dragonBoatMgr.getInstance():getActivityCfg()["Activity Name"]
  local titleLabel = ed.ui.gradientLabel.create({
    text = name,
    fontName = ed.fontBold,
    fontSize = 30,
    startColor = ed.toccc3(14677158),
    endColor = ed.toccc3(16383983),
    shadowColor = ccc3(39, 100, 105),
    shadowOffset = ccp(0, -1.5)
  })
  self.ui.img_title_bg:addChild(titleLabel.node)
  titleLabel.node:setPosition(ccp(25, 31))
  titleLabel.node:setAnchorPoint(ccp(0, 0.5))
  titleLabel.node:setScale(math.min(1, 225 / titleLabel.node:getContentSize().width))
  ed.layout.layoutWithMagin(self.ui.img_title_bg, {left = 60, top = 8})
  ed.layout.layoutWithMagin(self.ui.ImageView_2669, {right = 50, top = 12})
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\233\128\144\230\181\170\228\186\137\233\148\139"),
    fontName = ed.fontBold,
    fontSize = 58.5,
    startColor = ed.toccc3(16773751),
    endColor = ed.toccc3(16776948),
    strokeSize = 2,
    strokeColor = ed.toccc3(12601885),
    shadowColor = ccc3(203, 83, 37),
    shadowOffset = ccp(0, -2)
  })
  self.ui.ImageView_2668:addChild(titleLabel.node)
  titleLabel.node:setPosition(ccp(506, 486))
  local leftTime = ed.dragonBoatMgr.getInstance().endTime - ed.getServerTime()
  ed.setLabelStroke(self.ui.Label_time, ed.toccc3(7614487), 1)
  if leftTime <= 0 then
    ed.setLabelString(self.ui.Label_time, T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
    self.actOver = true
  else
    ed.setLabelString(self.ui.Label_time, T("\229\137\169\228\189\153 %s", ed.time2dhms(leftTime)))
  end
  self.ui.ImageView_2669:setVisible(not self.actOver)
  local count = ed.player.equip_qunty[ed.getDataTable("DragonBoat")[1]["Item ID"]] or 0
  self.ui.Label_count:setString(count)
  ed.layout.adaptBG(self.ui.bj, "X")
  self:initEffect()
end

function dragonBoatRankScene:initEffect()
  local eff = ed.createFcaNode("eff_UI_DragonBoat_shine")
  self.ui.ImageView_2668:addChild(eff)
  self:addFca(eff)
  eff:setPosition(ccp(500, 495))
end

function dragonBoatRankScene:registerEvents()
  ed.UITool.registerBtn(self, "img_rule", function()
    local rules = ed.dragonBoatMgr.getInstance():getActivityCfg().Rules
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = rules
    }):popWindow()
  end)
  ed.UITool.registerBtn(self, "img_close", function()
    ed.popScene()
    if ed.dragonBoatMgr:getInstance():isInRace() then
      FireEvent("DragonBoatSetRegisterTime", ed.getServerTime() - 6)
    end
  end, {normalScale = 0.8, pressScale = 0.75})
  for i, v in ipairs(self.frameIcons) do
    self:btRegisterRectClick({
      rect = CCRectMake(-50, -50, 100, 100),
      parent = v.icon,
      clickHandler = function()
        ed.UITool.openView("packageDetail", {
          id = v.id,
          type = "item"
        })
      end
    })
  end
  ed.UITool.registerBtn(self, "ImageView_icon", function()
    ed.UITool.openView("packageDetail", {
      id = ed.getDataTable("DragonBoat")[1]["Item ID"],
      type = "item"
    })
  end, {normalScale = 1, pressScale = 0.95})
  self:listenEvent("req_home_page", function(data)
    ed.ui.PlayerInfoPanel.create(data, false):popWindow()
  end)
  self:listenEvent("DragonBoatQueryGiveStatus", function(data)
    if self.roleId then
      if data._give_status and (data._give_status == "dragon_boat_can_give" or data._give_status == "dragon_boat_give_num_not_enough" or data._give_status == "dragon_boat_item_not_enough") then
        ed.UITool.openView("activityAllStarGiveFlower", {
          roleId = self.roleId,
          dragonBoatStatus = data._give_status
        })
      else
        if data._give_status == "dragon_boat_not_open" then
          ed.showToast(T("\230\156\170\229\156\168\230\180\187\229\138\168\230\151\182\233\151\180\229\134\133"))
        elseif data._give_status == "dragon_boat_not_start" then
          ed.showToast(T("\232\135\170\229\183\177\230\156\170\229\143\130\229\138\160\230\180\187\229\138\168"))
        elseif data._give_status == "dragon_boat_level_not_enough" then
          ed.showToast(T("\229\176\143\233\152\159\231\173\137\231\186\167\228\184\141\232\182\179"))
        elseif data._give_status == "dragon_boat_oppo_not_start" then
          ed.showToast(T("\229\175\185\230\150\185\230\156\170\229\143\130\229\138\160\230\180\187\229\138\168"))
        elseif data._give_status == "dragon_boat_oppo_server_down" then
          ed.showToast(T("\230\154\130\228\184\141\229\143\175\232\181\160\233\128\129\239\188\140\229\175\185\230\150\185\230\156\141\229\138\161\229\153\168\230\173\163\229\156\168\231\187\180\230\138\164\228\184\173"))
        end
        print(data._give_status)
      end
    end
    self.roleId = nil
  end)
  self:listenEvent("ResourceNumChange", function(resType, id)
    if id == ed.getDataTable("DragonBoat")[1]["Item ID"] then
      local count = ed.player.equip_qunty[ed.getDataTable("DragonBoat")[1]["Item ID"]] or 0
      self.ui.Label_count:setString(count)
    end
  end)
  self:listenEvent("DragonBoatQueryRankReply", function(data)
    self:initData(data)
    self:refreshRank()
  end)
  self:listenEvent("dragonBoatGiveReply", function(info)
    info = ed.copyProto(info)
    if info._result and info._result == "success" then
      ed.dragonBoatNet:sendQueryRank()
    end
  end)
end

function dragonBoatRankScene:createList()
  local thisCon = self.ui.Panel_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_item,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelPressInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(true)
  }
  self.dragList = ed.draglist.create(info)
end

function dragonBoatRankScene:refreshRank()
  local list = self.rankList or {}
  if #list < 100 then
    table.insert(list, {})
  end
  self.items = {}
  self.dragList:clearList()
  local listPosY = self.dragList.listLayer:getPositionY()
  local heigh, posY = 100, 272
  local thisCon = self.ui.Panel_item:getContentSize()
  self.listOver = false
  self.ui.Panel_item:stopAllActions()
  local index = 1
  self:registerUpdateHandler("dragonBoatUpdateBG", function(dt)
    if not list[index] then
      self:removeUpdateHandler("dragonBoatRankSceneUpdate")
      self.listOver = true
      return
    end
    local item = self.itemBox.create(self, list[index], index)
    self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2 - 0.5, thisCon.height - 72.5 * index + 36.25 - 2))
    table.insert(self.items, item)
    index = index + 1
  end)
  self.dragList:initListHeight(#list * 72.5 + 5)
  if self.selfItem then
    self.selfItem.ui.bg:removeFromParentAndCleanup(true)
    self.selfItem = nil
  end
  if self.selfRank and self.selfRank._param2 then
    local item = self.itemBox.create(self, self.selfRank, self.selfRank._param2)
    item.ui.bg:setPosition(510, 40)
    item.ui.labelGive:setString(T("\228\189\191\231\148\168"))
    self.ui.ImageView_2668:addChild(item.ui.bg)
    self.selfItem = item
    self.dragList:initListHeight(#list * 72.5 + 5 + 55)
    ed.createSpriteTools({
      res = "UI/alpha/1080P/dragonboat/db_ranking_list/db_ranking_myself.png",
      parent = item.ui.selfBg,
      pos = ccp(310.5, 40)
    })
  end
end

function dragonBoatRankScene:createHeadIcon()
  local function getFrameId(RewardId)
    for id, v in pairs(ed.getDataTable("AvatarFrame")) do
      if v["Requirement ID"] == RewardId then
        return id
      end
    end
  end
  
  self.frameIcons = {}
  local tmpLabel
  local posx, posy = self.ui.Panel_head_pos:getPosition()
  for i, v in ipairs(ed.getDataTable("DragonBoatRank")) do
    local frameId = getFrameId(v["Reward ID 1"])
    local icon
    if frameId then
      icon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
      table.insert(self.frameIcons, {
        icon = icon,
        id = v["Reward ID 1"]
      })
    else
      icon = ed.createItemIcon({
        id = v["Reward ID 1"],
        amount = v["Reward Amount 1"]
      })
    end
    icon:setScale(i == 1 and 1 or 0.9)
    icon:setPosition(ccp(posx + 10, posy))
    self.ui.ImageView_2668:addChild(icon)
    if i == 1 then
      ed.createSpriteTools({
        res = "UI/alpha/1080P/dragonboat/db_ranking_list/db_crown.png",
        parent = self.ui.ImageView_2668,
        pos = ccp(posx - 55, posy - 61)
      })
      tmpLabel = ed.createLabelTools({
        txt = T("\233\190\153\232\136\159\230\142\146\229\144\141\229\137\141%d", v["Top Rank"]),
        size = i == 1 and 18 or 15,
        pos = ccp(posx + 13, posy - 62),
        color = i == 1 and ccc3(255, 250, 194) or ccc3(255, 249, 247),
        parent = self.ui.ImageView_2668,
        stroke = {
          ccc3(ed.colorToStr(i == 1 and "#7e3e00" or "#851f0b")),
          1.3
        }
      })
      if not ed.isElementInTable(EDCurLanguage, {"cn", "tw"}) then
        tmpLabel:limitSizeByScale(100, 40)
      end
    else
      tmpLabel = ed.createLabelTools({
        txt = T("\233\190\153\232\136\159\230\142\146\229\144\141\229\137\141%d", v["Top Rank"]),
        size = i == 1 and 18 or 15,
        pos = ccp(posx + 10, posy - 62),
        color = i == 1 and ccc3(255, 250, 194) or ccc3(255, 249, 247),
        parent = self.ui.ImageView_2668,
        stroke = {
          ccc3(ed.colorToStr(i == 1 and "#7e3e00" or "#851f0b")),
          1.3
        }
      })
      if not ed.isElementInTable(EDCurLanguage, {"cn", "tw"}) then
        tmpLabel:limitSizeByScale(100, 40)
      end
    end
    posx = posx + 120
  end
  local cfg = ed.getDataTable("DragonBoat")[1]
  local frameId = getFrameId(cfg["Get Reward ID"])
  local icon
  if frameId then
    icon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
    table.insert(self.frameIcons, {
      icon = icon,
      id = cfg["Get Reward ID"]
    })
  else
    icon = ed.createItemIcon({
      id = cfg["Get Reward ID"],
      amount = v["Get Reward Amount"]
    })
  end
  icon:setScale(0.9)
  icon:setPosition(ccp(posx + 10, posy))
  self.ui.ImageView_2668:addChild(icon)
  tmpLabel = ed.createLabelTools({
    txt = T("\232\190\190\230\136\144%d\229\176\186", cfg["Reach Sailing Feet"]),
    size = 15,
    pos = ccp(posx + 10, posy - 62),
    color = ed.toccc3(16776423),
    parent = self.ui.ImageView_2668,
    stroke = {
      ccc3(ed.colorToStr("#851f0b")),
      1.3
    }
  })
  if not ed.isElementInTable(EDCurLanguage, {"cn", "tw"}) then
    tmpLabel:limitSizeByScale(100, 40)
  end
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
  local bg = ed.createCCLayer({
    sizeMake = CCSizeMake(621.5, 80)
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/dragonboat/db_ranking_list/db_ranking" .. num .. ".png",
    parent = bg
  }):setScaleY(0.85)
  local selfBg = ed.createSpriteTools({
    res = "",
    parent = bg,
    pos = ccp(-310.75, -32)
  })
  selfBg:setScaleY(0.85)
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
      pos = ccp(-250.75, 0.75)
    })
  else
    local index = self.index or 0
    rankNum = ed.getNumberNode({
      text = 1000 < index and "1000+" or index,
      folder = "peakarena_rank"
    }).node
    rankNum:setPosition(-255.75, 0.75)
    bg:addChild(rankNum)
  end
  local summary = param._user_summary
  if not summary or not summary._avatar then
    ed.createLabelTools({
      txt = T("\229\189\147\229\137\141\230\154\130\230\151\160\233\152\159\233\149\191\228\184\138\230\166\156"),
      size = 22,
      pos = ccp(0, 0),
      color = ccc3(ed.colorToStr("#fffce7")),
      parent = bg,
      stroke = {
        ccc3(ed.colorToStr("#221505")),
        1.3
      }
    })
    self.ui = {bg = bg}
    return
  end
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar
  })
  head:setPosition(-145.75, 0.75)
  head:setScale(0.7)
  bg:addChild(head)
  local isMyself = summary._role_id == ed.getRoleId()
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = isMyself and "ccc3(173,255,107)" or "ccc3(255,252,231)",
    fontSize = 17,
    disableOffset = true
  })
  name:setPosition(ccp(-111.75, 13.75))
  bg:addChild(name)
  ed.createLabelTools({
    txt = T(summary._guild_name or ""),
    size = 17,
    pos = ccp(-94.75, -12.25),
    color = ccc3(ed.colorToStr("#fff088")),
    parent = bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#362006")),
      1.3
    }
  })
  local numbg = ed.createSpriteTools({
    res = "UI/alpha/1080P/dragonboat/db_ranking_list/db_sliding base.png",
    parent = bg,
    pos = ccp(134.25, 0.75)
  })
  local dragonIconRes = "UI/alpha/1080P/dragonboat/db_ranking_list/db_boat" .. (param._param3 or 1) .. ".png"
  ed.createSpriteTools({
    res = dragonIconRes,
    parent = numbg,
    pos = ccp(0, 19)
  })
  local nums = ed.createLabelTools({
    txt = T("%d\229\176\186", param._param1),
    size = 18,
    pos = ccp(60, 13),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = numbg,
    stroke = {
      ccc3(ed.colorToStr("#2f1e1e")),
      1.3
    }
  })
  local giveBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/dragonboat/db_ranking_list/db_cheer.png",
    parent = bg,
    pos = ccp(244.25, 5.75)
  })
  local labelGive = ed.createLabelTools({
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
  giveBtn:setVisible(not self.mainSelf.actOver)
  self.ui = {
    bg = bg,
    nums = nums,
    rankNum = rankNum,
    headIcon = headIcon,
    giveBtn = giveBtn,
    selfBg = selfBg,
    labelGive = labelGive
  }
end

function itemBox:update(param, index)
  self.ui.nums:setString(T("%d\229\176\186", param._param1))
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
      pos = ccp(-250.75, 0.75)
    })
  else
    rankNum = ed.getNumberNode({
      text = self.index or 0,
      folder = "peakarena_rank"
    }).node
    rankNum:setPosition(-255.75, 0.75)
    self.ui.bg:addChild(rankNum)
  end
  self.ui.rankNum = rankNum
end

dragonBoatRankScene.itemBox = itemBox

function dragonBoatRankScene:giveStatus(roleId)
  local curNum = ed.player:getEquipAmount(ed.dragonBoatMgr.getInstance().zongziItemId)
  if curNum <= 0 then
    ed.showToast(T("\231\145\158\231\178\189\230\149\176\233\135\143\228\184\141\232\182\179"))
    return
  end
  if ed.player:getLevel() < 70 and roleId ~= ed.getRoleId() then
    ed.showToast(T("70\231\186\167\228\187\165\228\184\138\230\137\141\229\143\175\232\181\160\233\128\129"))
    return
  end
  local giveNum = ed.dragonBoatMgr.getInstance().giveNum or 0
  if giveNum < 400 and roleId ~= ed.getRoleId() then
    ed.showToast(string.format(T("\229\175\185\232\135\170\229\183\177\228\189\191\231\148\168400\229\144\142\230\137\141\229\143\175\232\181\160\233\128\129   \229\189\147\229\137\141\232\191\155\229\186\166%s/400"), giveNum))
    return
  end
  if self.roleId then
    return
  end
  self.roleId = roleId
  ed.dragonBoatNet:sendQueryGiveStatus(roleId)
end

function dragonBoatRankScene:doPressInList()
  local function handler(x, y)
    if self.selfItem then
      if ed.containsPoint(self.selfItem.ui.headIcon, x, y) then
        self.selfItem.ui.headIcon:setScale(0.95)
        
        return {
          icon = self.selfItem.ui.headIcon,
          fun = function(param)
            local summary = self.selfItem.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end,
          param = self.selfItem.param
        }
      elseif self.selfItem.ui.giveBtn and self.selfItem.ui.giveBtn:isVisible() and ed.containsPoint(self.selfItem.ui.giveBtn, x, y) then
        self.selfItem.ui.giveBtn:setScale(0.95)
        return {
          icon = self.selfItem.ui.giveBtn,
          fun = function(param)
            if self.roleId then
              return
            end
            self.roleId = param._user_summary._role_id
            ed.dragonBoatNet:sendQueryGiveStatus(param._user_summary._role_id)
          end,
          param = self.selfItem.param
        }
      end
      self.selfItem.ui.bg:setVisible(false)
    end
    for _, v in pairs(self.items) do
      if ed.containsPoint(v.ui.headIcon, x, y) then
        v.ui.headIcon:setScale(0.95)
        return {
          icon = v.ui.headIcon,
          fun = function(param)
            local summary = v.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end,
          param = v.param
        }
      elseif v.ui.giveBtn and v.ui.giveBtn:isVisible() and ed.containsPoint(v.ui.giveBtn, x, y) then
        v.ui.giveBtn:setScale(0.95)
        return {
          icon = v.ui.giveBtn,
          fun = function(param)
            self:giveStatus(param._user_summary._role_id)
          end,
          param = v.param
        }
      end
    end
    return {}
  end
  
  return handler
end

function dragonBoatRankScene:cancelPressInList(isPressIn)
  local function handler(x, y, info)
    if isPressIn and self.selfItem then
      self.selfItem.ui.bg:setVisible(true)
    end
    if info.icon then
      info.icon:setScale(info.normalScale or 1)
    end
  end
  
  return handler
end

function dragonBoatRankScene:doClickInList()
  local function handler(x, y, info)
    if self.selfItem then
      self.selfItem.ui.bg:setVisible(true)
    end
    if info.fun then
      info.fun(info.param or {})
    end
  end
  
  return handler
end
