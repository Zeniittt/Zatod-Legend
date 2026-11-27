local base = ed.ui.basescene
local ranklist = {}
setmetatable(ranklist, base.mt)
ed.ranklistpop = ranklist
local treeBtnRes = {
  {
    normal = "UI/alpha/1080P/rankingscene/tab1.png",
    press = "UI/alpha/1080P/rankingscene/tab4.png",
    height = 46
  },
  {
    normal = "",
    press = "UI/alpha/1080P/rankingscene/tab2.png",
    height = 38
  },
  {
    normal = "",
    press = "UI/alpha/1080P/rankingscene/tab3.png",
    height = 33
  }
}

function ranklist:createUiShow()
  local container, ui = ed.editorui(ed.uieditor.ranklistpop)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  self.ui.ImageView_2735:setVisible(false)
  ed.UITool.createSceneTitle(T("\230\142\146\232\161\140\230\166\156"), self.ui.img_title_bg, {
    position = ccp(11, 18)
  })
  self.listData = ed.ranklistData
  local panelSize = self.ui.pan_top_clip:getContentSize()
  self.ui.pan_top_clip:setClipRect(CCRectMake(0, 0, panelSize.width, panelSize.height))
end

function ranklist:addEventBtRegister()
  local ui = self.ui
end

function ranklist:createListenEvent()
  self:listenEvent("query_rankpvpdata_reply", function(data)
    if self.upMode == self.newMode then
      self.listData:transferPvpList(self.newMode, data)
      local data = self:getDragListData(self.newMode)
      local mydata = self.listData:getModeListMyData(self.newMode)
      self:upDataDragList({myData = mydata, list = data}, self.createItemUi(self.newMode))
    end
  end)
  self:listenEvent("query_ranklistdata_reply", function(data)
    if self.upMode == self.newMode then
      self.listData:transferList(self.newMode, data)
      local data = self:getDragListData(self.newMode)
      local mydata = self.listData:getModeListMyData(self.newMode)
      self:upDataDragList({myData = mydata, list = data}, self.createItemUi(self.newMode))
    end
  end)
  self:listenEvent("collection_point_reply_show", function(info)
    ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159\239\188\129"))
    self:setCollectionHeroReply(info._hero_id)
  end)
end

function ranklist:createAccList(index, index2)
  local listData = self:accordionData()
  local accordionlist = self:accordionlist(listData)
  accordionlist:passTreeIndex(true, ed.ranklistData:getTreeListIndex(self.param.index, self.param.index2))
  return accordionlist
end

function ranklist:accordionData()
  return self.listData:getTreeList()
end

function ranklist:accordionlist(data)
  local accordion = ed.accordion.createAccordion(self.ui.pan_butt_pos, {
    vertex = {
      winLeft = -63,
      winRight = 0,
      winTop = 10,
      winBottom = 10
    },
    isTrigger = function()
      return not self.notReplyEnd
    end,
    doClickOut = function(isPas, data)
      self:clickOut(isPas, data)
    end,
    doAllClickOut = function(isLeaf, isPas, data)
      self:allClickOut(isLeaf, isPas, data)
    end,
    isBoom = true,
    treeBtnRes = treeBtnRes,
    anchor = 0,
    isTakeBack = true
  })
  accordion:addAcclist(data)
  return accordion
end

function ranklist:createDragList()
  if not self.dragList then
    local thisCon = self.ui.pan_list_pos:getContentSize()
    local info = {
      cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
      container = self.ui.pan_list_pos,
      noshade = true,
      cancelPressIn = self:cancelScrollViewPressIn(),
      doPressIn = self:doScrollViewPressIn()
    }
    self.dragList = ed.draglist.create(info)
    local ClipLayer = CCLayer:create()
    ClipLayer:setPosition(0, 0)
    self.dragList.listLayer:addChild(ClipLayer)
    self.ClipLayer_L = ClipLayer
    ClipLayer = CCLayer:create()
    ClipLayer:setPosition(thisCon.width + thisCon.width / 2, 0)
    self.ClipLayer_R = ClipLayer
    self.dragList.listLayer:addChild(ClipLayer)
    ClipLayer = ed.createSprite("")
    self.myContainer = ClipLayer
    self.ui.pan_list_pos:addChild(ClipLayer, 999)
    self.handLayer = {}
    for i = 1, 3 do
      local layer = CCLayer:create()
      self.ui["Panel_hand_" .. i]:addChild(layer, 99)
      self.handLayer[i] = layer
    end
    local oldOpacity = -1
    self:registerUpdateHandler("updataOpacityHandler", function(dt)
      local posY = self.dragList.listLayer:getPositionY()
      local mode = self.newMode
      if mode and (mode == "pvp" or mode == "pvp_r") and self.rankPvpTopBgImg then
        if self.rankPvpTopBgImg:isVisible() ~= (posY <= 100) then
          self.rankPvpTopBgImg:setVisible(posY <= 100)
        end
        if posY < 120 and 30 < posY then
          self.rankPvpTopBgImg:setPositionY(70 + (posY - 30) / 2.5)
        elseif posY <= 30 then
          self.rankPvpTopBgImg:setPositionY(70)
        end
        local opy = 100 < posY and 100 or posY
        opy = opy < 1 and 1 or opy
        local opacity = 255 * ((100 - opy) / 100)
        opacity = math.floor(opacity)
        if opacity ~= oldOpacity then
          for _, v in pairs(self.accOpacitys or {}) do
            v:setOpacity(255 * ((100 - opy) / 100))
          end
          oldOpacity = opacity
        end
      end
    end)
  else
    for i, v in ipairs(self.handLayer) do
      v:removeAllChildrenWithCleanup(true)
    end
    self.ClipLayer_L:removeAllChildrenWithCleanup(true)
    self.ClipLayer_R:removeAllChildrenWithCleanup(true)
  end
  return self.dragList
end

function ranklist:doScrollViewPressIn()
  local function handler(x, y, id)
    ed.playEffect(ed.sound.deo.common_click_feedback)
    
    if self.myContainer and self.newMode ~= "collect_point_local" and self.newMode ~= "collection_point_global" then
      self.myContainer:stopAllActions()
      self.myContainer:runAction(CCFadeTo:create(0.2, 128))
    end
    return 1
  end
  
  return handler
end

function ranklist:cancelScrollViewPressIn()
  local function handler(x, y, id)
    if self.myContainer and self.newMode ~= "collect_point_local" and self.newMode ~= "collection_point_global" then
      self.myContainer:stopAllActions()
      
      self.myContainer:runAction(CCFadeTo:create(0.2, 255))
    end
  end
  
  return handler
end

function ranklist:upDataDragList(data, rankItemUi)
  local function handfunc(v)
    return function(param, x, y)
      self:passRankHand(v, nil, x, y)
    end
  end
  
  if self.dragList and data and data.list and rankItemUi then
    if self.overAction then
      self.ClipLayer_L:stopAllActions()
      self.ClipLayer_L:setPosition(self.overAction)
      self.ClipLayer_R:stopAllActions()
      self.ClipLayer_R:setPosition(1, 0)
    end
    for i, v in ipairs(self.handLayer or {}) do
      v:removeAllChildrenWithCleanup(true)
      if v.FcaDz then
        v.FcaDz:removeFromParentAndCleanup(true)
        v.FcaDz = nil
      end
      if v.FcaFly then
        v.FcaFly:removeFromParentAndCleanup(true)
        v.FcaFly = nil
      end
    end
    if self.myContainer then
      self.myContainer:removeAllChildrenWithCleanup(true)
    end
    self.ClipLayer_R:removeAllChildrenWithCleanup(true)
    local newlayer = self.ClipLayer_R
    local thisCon = self.ui.pan_list_pos:getContentSize()
    local height = 3
    local listData = data.list
    if self.newMode == "collect_point_local" or self.newMode == "collection_point_global" then
      for i = 1, 3 do
        self.ui["Panel_hand_" .. i]:setVisible(false)
      end
      if self.collectionRank then
        self.collectionRank:setVisible(true)
      elseif #listData == 0 then
        self.collectionRank = self:createCollectionRank(newlayer)
      end
      if #listData == 0 then
        ed.showToast(T("\230\148\182\232\151\143\230\142\146\232\161\140\230\166\156\230\149\176\230\141\174\231\187\159\232\174\161\228\184\173"))
      end
      for k, v in pairs(self.collectionList or {}) do
        v:removeAllChildrenWithCleanup(true)
      end
      if self.rankPvpBgImg then
        self.rankPvpBgImg:setVisible(false)
      end
    elseif self.newMode == "pvp" or self.newMode == "pvp_r" then
      height = height + 110
      for i = 1, 3 do
        self.ui["Panel_hand_" .. i]:setVisible(false)
      end
      if self.rankPvpBgImg then
        self.rankPvpBgImg:setVisible(true)
      else
        self.rankPvpBgImg, self.rankPvpTopBgImg = self:createTopHandler(newlayer)
      end
      local thisCon = self.ui.pan_list_pos:getContentSize()
      self.dragList:setClipRect(CCRectMake(0, 0, thisCon.width, thisCon.height + 30))
      if self.collectionRank then
        self.collectionRank:setVisible(false)
      end
    else
      if self.rankPvpBgImg then
        self.rankPvpBgImg:setVisible(false)
      end
      if self.collectionRank then
        self.collectionRank:setVisible(false)
      end
      for i = 1, 3 do
        self.ui["Panel_hand_" .. i]:setVisible(true)
      end
      local thisCon = self.ui.pan_list_pos:getContentSize()
      self.dragList:setClipRect(CCRectMake(0, 0, thisCon.width, thisCon.height))
    end
    self.ui.img_top:setVisible(self.newMode ~= "collect_point_local" and self.newMode ~= "collection_point_global")
    self.ui.ImageView_2687:setVisible(self.newMode ~= "collect_point_local" and self.newMode ~= "collection_point_global")
    for i, v in ipairs(self.headBgImgs or {}) do
      v:removeAllChildrenWithCleanup(true)
    end
    for i = 1, 3 do
      self.accOpacitys["hand" .. i] = nil
      self.accOpacitys["autoText" .. i] = nil
      self.accOpacitys["labelGuild" .. i] = nil
    end
    for i, v in ipairs(listData or {}) do
      if i <= 3 then
        self:rankHandUi(v, newlayer)
      else
        height = height + 85
        local container, ui = rankItemUi(v)
        container:setPosition(7, thisCon.height - height)
        newlayer:addChild(container)
        self:btRegisterButtonClick({
          button = ui.hand_pos,
          key = "rankItem" .. i,
          clickHandler = handfunc(v),
          force = true,
          pressScale = 0.75,
          normalScale = 0.8,
          radius = 30,
          centerOffset = ccp(ui.hand_pos:getPosition())
        })
      end
    end
    for i, v in ipairs(self.herosFcaLays or {}) do
      v:removeAllChildrenWithCleanup(true)
    end
    for i = 2, 3 do
      for s = 1, 5 do
        self.accOpacitys[i .. "rank" .. s] = nil
      end
    end
    local heroDatas = {}
    
    local function rectClickFun(replyIdx, index)
      return function()
        if heroDatas[replyIdx] and heroDatas[replyIdx][index] and (replyIdx ~= 1 and self.rankPvpTopBgImg:isVisible() and self.rankPvpBgImg:isVisible() or replyIdx == 1 and self.rankPvpBgImg:isVisible()) then
          if heroDatas[replyIdx][index]._role_id == 0 then
            ed.showToast(T("\231\139\130\230\172\162\230\180\190\229\175\185\228\184\173\232\183\175\232\191\135\231\154\132\228\186\148\229\176\143\229\188\186"))
          else
            ed.ui.checkOthersHeroWindow.create():popWindow()
            ed.PlayerInfoNetwork:requestHeroData(heroDatas[replyIdx][index]._role_id, heroDatas[replyIdx][index]._tid)
          end
        end
      end
    end
    
    local asyncloadFca = {}
    local replyIdx = 1
    local heroID = {}
    local sendMax = 0
    local maxIdx = #listData < 3 and #listData or 3
    
    local function func()
      ed.registerNetReply("query_pvp_oppo", function(data)
        heroDatas[replyIdx] = {}
        asyncloadFca[replyIdx] = {}
        data = data[".data"] or data
        data = data._user or data
        if self.newMode ~= "pvp" and self.newMode ~= "pvp_r" then
          return
        end
        local heroLayer = self.herosFcaLays[replyIdx]
        local heroes = ed.SortHeroesByMaxRange(data._heros or {})
        local width = replyIdx == 1 and 80 or 60
        local posx = -150 + (5 - #heroes) * width / 2 - (replyIdx == 1 and 55 or 0)
        for index = #heroes, 1, -1 do
          heroID[heroes[index]._tid] = true
          table.insert(asyncloadFca[replyIdx], {
            data = heroes[index],
            scale = replyIdx == 1 and 0.52 or 0.4,
            pos = ccp(posx + width * (#heroes + 1 - index), 10),
            rect = CCRectMake(posx + width * (#heroes + 1 - index) - 30, 10, 60, 60),
            parent = heroLayer
          })
          heroDatas[replyIdx][index] = {
            _role_id = data._summary._role_id,
            _tid = heroes[index]._tid
          }
        end
        replyIdx = replyIdx + 1
        if replyIdx <= maxIdx then
          func()
        else
          self:showTeam(heroID, asyncloadFca, rectClickFun)
          self.notReplyEnd = nil
        end
      end)
      if listData[replyIdx] then
        if listData[replyIdx].level == 0 then
          local handler = ed.getNetReply("query_pvp_oppo")
          if handler then
            handler({
              _heros = {
                {_tid = 1},
                {_tid = 2},
                {_tid = 3},
                {_tid = 4},
                {_tid = 45}
              },
              _summary = {_role_id = 0}
            })
          end
        else
          if 4 < sendMax then
            return
          end
          local msg = ed.upmsg.ladder()
          msg._query_oppo = {}
          msg._query_oppo._oppo_user_id = listData[replyIdx].uid
          ed.send(msg, "ladder")
          sendMax = sendMax + 1
        end
      else
        self.notReplyEnd = nil
      end
    end
    
    if self.newMode == "pvp" or self.newMode == "pvp_r" then
      self.notReplyEnd = true
      func()
    end
    if data.myData and data.myData.name then
      local container, ui = rankItemUi(data.myData, {
        container = self.myContainer
      })
      ui.bj_img_pass:setVisible(true)
      container:setPosition(8, 0)
      height = height + 80
      container:setCascadeOpacityEnabled(true)
      if self.newMode == "collect_point_local" or self.newMode == "collection_point_global" then
        self:btRemoveMainTouchHandler({
          key = "self_headIcon"
        })
        self:btRegisterButtonClick({
          button = ui.headIcon,
          key = "self_headIcon",
          clickHandler = function()
            local guildName = ed.player:getGuildName() and ed.player:getGuildName() ~= "" and ed.player:getGuildName() and ed.player:getGuildName() or T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154")
            if data.myData.rankNum == 0 then
              ed.rank_network.rank = 0
              ed.ui.collectionSummaryPop.create({
                _avatar_num = 0,
                _frame_num = 0,
                _fashion_num = 0,
                _sticker_num = 0,
                _background_num = 0,
                _user_summary = {
                  _avatar = data.myData.avatar,
                  _name = data.myData.name,
                  _guild_name = guildName,
                  _medal = data.myData.medal,
                  _role_id = ed.getRoleId(),
                  _level = data.myData.level
                }
              })
            else
              ed.rank_network.sendLookCollectionReq(data.myData.roleId, data.myData.rankNum)
            end
          end,
          force = true,
          pressScale = 0.95
        })
        self:btRemoveMainTouchHandler({
          key = "self_changecloth"
        })
        if ui.changecloth then
          self:btRegisterButtonClick({
            button = ui.changecloth,
            key = "self_changecloth",
            clickHandler = function()
              ed.ui.GuildMountChangeActorWin.create({
                callBack = function(selectTid)
                  if data.myData.rankNum > 3 then
                    ed.showToast(T("\229\137\1413\230\137\141\229\143\175\230\141\162\232\163\133"))
                  elseif data.myData.param2 ~= selectTid then
                    ed.rank_network.sendSetCollectionHeroReq(selectTid)
                  end
                end,
                txt = T("\229\143\175\228\187\165\233\128\137\230\139\169\228\187\187\230\132\143<lable color=ccc3(255,219,124)>\229\183\178\230\139\165\230\156\137</lable>\232\139\177\233\155\132\232\191\155\232\161\140\230\141\162\232\163\133"),
                btnTxt = T("\230\141\162 \232\163\133"),
                selectTid = data.myData.param2
              })
            end,
            force = true,
            pressScale = 0.95
          })
        end
      end
    end
    local oldY = self.dragList.listLayer:getPositionY()
    self.dragList:initListHeight(height + 5)
    self.ClipLayer_L:setPositionY(oldY)
    local moveX = thisCon.width + thisCon.width / 2
    if not self.onceUpDataList then
      self.onceUpDataList = true
      newlayer:setPosition(1, 0)
      self.ClipLayer_L:setPosition(moveX, 0)
      self.ClipLayer_R = self.ClipLayer_L
      self.ClipLayer_L = newlayer
      self.ClipLayer_R:removeAllChildrenWithCleanup(true)
      return
    end
    self.overAction = ccp(moveX * -1, oldY)
    newlayer:runAction(CCEaseSineInOut:create(CCMoveTo:create(0.2, ccp(1, 0))))
    self.ClipLayer_L:runAction(CCSequence:create(ccArrayMake(CCEaseSineInOut:create(CCMoveTo:create(0.2, self.overAction)), CCCallFunc:create(function()
      self.overAction = false
      self.ClipLayer_L:setPosition(moveX, 0)
      self.ClipLayer_R = self.ClipLayer_L
      self.ClipLayer_L = newlayer
      self.ClipLayer_R:removeAllChildrenWithCleanup(true)
    end))))
  end
end

function ranklist:showTeam(heroID, asyncloadFca, rectClickFun)
  for k, v in pairs(heroID) do
    ed.asyncload.preloadFcaByUnitID(k, true)
  end
  ed.asyncload.registLoadingListener(nil)
  ed.asyncload.registLoadingListener(function()
    for i, v in ipairs(asyncloadFca) do
      for ii, vv in ipairs(v) do
        local datass = vv.data
        local puppet, _ = ed.readhero.getActor(datass._tid, "Idle", true, false, datass._fashion)
        puppet:setScale(i == 1 and 0.52 or 0.4)
        puppet:setPosition(vv.pos)
        vv.parent:addChild(puppet, 99)
        self:addFca(puppet)
        puppet.scaleNum = i == 1 and 0.52 or 0.4
        if 1 < i then
        end
        self:btRegisterRectClick({
          rect = vv.rect,
          parent = vv.parent,
          pressHandler = function()
            if not tolua.isnull(puppet) then
              puppet:setScale(puppet.scaleNum - 0.05)
            end
          end,
          cancelPressHandler = function()
            if not tolua.isnull(puppet) then
              puppet:setScale(puppet.scaleNum)
            end
          end,
          key = i .. "puppet" .. ii,
          clickHandler = rectClickFun(i, #v + 1 - ii),
          force = true
        })
      end
    end
  end)
end

function ranklist:getDragListData(mode)
  local data = self.listData:getModeListData(mode)
  return data
end

function ranklist:getRankModeParam(mode)
  local data = self.listData:getDataConfig(mode)
  return data and {
    type = data.type,
    board = data.board,
    custom = data.custom
  } or {}
end

local function cmnFunc(ui, data, headGuild)
  local name = ed.getPlayerName(ed.transBotName(data.name or "nil"), data.medal, {left = true})
  ed.UITool.replaceUI(ui, "panel_item", "label_role_name", name)
  if data.rankNum and data.rankNum > 100 then
    ed.createLabelTools({
      txt = T("100+"),
      size = 18,
      color = ed.toccc3(16776423),
      stroke = {
        ccc3(ed.colorToStr("#221505")),
        1.3
      },
      parent = ui.num_pos
    })
  elseif data.rankNum and data.rankNum ~= 0 then
    ui.num_pos:addChild(ed.getNumberNode({
      text = data.rankNum or 0,
      folder = "big_pvp"
    }).node)
  else
    ed.createLabelTools({
      txt = T("\230\156\170\228\184\138\230\166\156"),
      size = 18,
      color = ed.toccc3(16776423),
      stroke = {
        ccc3(ed.colorToStr("#221505")),
        1.3
      },
      parent = ui.num_pos
    })
  end
  if headGuild and data.avatar then
    local avatarData = ed.analyzeAvatar(data.avatar)
    ui.hand_pos:addChild(ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame))
  elseif data.avatar then
    ui.headIcon = ed.getTeamHead({
      id = data.avatar,
      vip = 0 < (data.vip or 0)
    })
    ui.hand_pos:addChild(ui.headIcon)
    if data.level and 0 < data.level then
      local frame = ed.createSprite("UI/alpha/1080P/ranking/lv_bg.png")
      frame:setPositionY(-35)
      ui.hand_pos:addChild(frame)
      local levelLabel = ed.createLabelTTF(data.level or 0, 16)
      ed.setLabelStroke(levelLabel, ccc3(43, 28, 8), 1)
      ed.setLabelColor(levelLabel, ccc3(251, 224, 116))
      levelLabel:setPositionY(-35)
      ui.hand_pos:addChild(levelLabel)
    end
  end
  ui.hand_pos:setScale(0.8)
end

local rankItem = {
  common = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data)
    ui.Panel_fighting:setVisible(true)
    local cfgStr = data.cfgStr or {}
    ui.Label_31012:setString(cfgStr.tipsText or "nil")
    ui.fighting_num:addChild(ed.getNumberNode({
      text = data.param1 or 0,
      folder = "hero_gs"
    }).node)
    return container, ui
  end,
  pvp = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data)
    ui.Panel_pvp:setVisible(true)
    ui.label_name:setString(data.guild_name or T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"))
    ui.label_name:setStroke(ccc3(ed.colorToStr("#372317")), 1)
    return container, ui
  end,
  hero_evo_star = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data)
    ui.Panel_fighting_star:setVisible(true)
    ui.fighting_star_num:setString(data.param1 or 0)
    ui.fighting_star_num:setStroke(ccc3(ed.colorToStr("#372317")), 1)
    return container, ui
  end,
  dreamland_guild = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data, true)
    ui.Panel_fighting:setVisible(true)
    local cfgStr = data.cfgStr or {}
    ui.Label_31012:setString(cfgStr.tipsText or "nil")
    ui.fighting_num:addChild(ed.getNumberNode({
      text = data.param1 or 0,
      folder = "damage"
    }).node)
    return container, ui
  end,
  guildliveness = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data, true)
    ui.Panel_pvp:setVisible(true)
    local cfgStr = data.cfgStr or {}
    ui.Label_3098:setString(cfgStr.tipsText or "nil")
    ui.label_name:setString(data.param1 or 0)
    ui.label_name:setStroke(ccc3(ed.colorToStr("#372317")), 1)
    ui.label_name:setColor(ccc3(ed.colorToStr("#70ff54")))
    return container, ui
  end,
  season_score = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data, true)
    return container, ui
  end,
  autochess_rank = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data)
    ui.Panel_fighting:setVisible(true)
    local cfgStr = data.cfgStr or {}
    ui.Label_31012:setVisible(false)
    ui.fighting_num:setVisible(false)
    local stage = ed.AutoChessRankManager:getRankGradeInfoByScore(data.param1 or 0)
    ed.createLabelTools({
      txt = T("\230\174\181\228\189\141:%s", stage.name),
      size = 18,
      anchor = ccp(0, 0.5),
      pos = ccp(50, 33),
      color = ccc3(62, 51, 28),
      parent = ui.Panel_fighting
    })
    ed.createLabelTools({
      txt = T("\231\167\175\229\136\134:%s", data.param1),
      size = 18,
      anchor = ccp(0, 0.5),
      pos = ccp(170, 33),
      color = ccc3(62, 51, 28),
      parent = ui.Panel_fighting
    })
    return container, ui
  end,
  real_arena = function(data, container)
    local container, ui = ed.editorui(ed.uieditor.rankListItem, container)
    cmnFunc(ui, data, false)
    ui.Panel_fighting:setVisible(true)
    ui.Label_31012:setVisible(false)
    ui.fighting_num:setVisible(false)
    ed.createLabelTools({
      txt = T("\231\167\175\229\136\134:%s", data.param1),
      size = 18,
      anchor = ccp(0, 0.5),
      pos = ccp(170, 33),
      color = ccc3(62, 51, 28),
      parent = ui.Panel_fighting
    })
    return container, ui
  end,
  collect_point_local = function(data, container)
    local ui = {}
    ui.container = ed.createCCLayer({
      pos = ccp(0, 0),
      sizeMake = CCSizeMake(100, 50),
      color = ccc4(111, 111, 111, 150),
      parent = container.container
    })
    ui.bj_img_pass = ed.createSpriteTools({
      res = "UI/alpha/1080P/rankingscene/collection_myself_1.png",
      parent = ui.container,
      pos = ccp(362.25, 54)
    })
    ui.num_pos = ed.createCCLayer({
      pos = ccp(80, 46),
      parent = ui.bj_img_pass
    })
    ui.hand_pos = ed.createCCLayer({
      pos = ccp(196, 43),
      sizeMake = CCSizeMake(100, 50),
      parent = ui.bj_img_pass
    })
    ui.panel_item = ed.createCCLayer({
      pos = ccp(254, 46),
      parent = ui.bj_img_pass
    })
    ui.label_role_name = ed.createCCLayer({
      pos = ccp(0, 0),
      parent = ui.panel_item
    })
    if data.rankNum < 4 and data.rankNum ~= 0 then
      ui.changecloth = ed.createSpriteTools({
        res = "UI/alpha/1080P/guildmount/changecloth.png",
        parent = ui.container,
        pos = ccp(460, 46)
      })
    end
    cmnFunc(ui, data)
    ui.txt = ed.createLabelTools({
      txt = T("\230\148\182\232\151\143\229\136\134"),
      size = 18,
      pos = ccp(625, 65),
      color = ed.toccc3(16776423),
      parent = ui.bj_img_pass,
      stroke = {
        ed.toccc3(0),
        2
      },
      font = ed.fontBold
    })
    local point = ed.ui.gradientLabel.create({
      text = data.param1 or 0,
      fontSize = 26,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16445333),
      endColor = ed.toccc3(16760922),
      strokeSize = 2,
      strokeColor = ed.toccc3(0)
    })
    point.node:setPosition(625, 32)
    ui.bj_img_pass:addChild(point.node)
    return ui.container, ui
  end
}
rankItem.pvp_r = rankItem.pvp
rankItem.collection_point_global = rankItem.collect_point_local

function ranklist.createItemUi(mode)
  if not rankItem[mode] then
    print("rankItem mode is nil ====", mode)
  end
  return rankItem[mode] or rankItem.common
end

local rankTop = {
  {
    "eff_UI_ranking_lighting_1st",
    "eff_UI_ranking_flashinglight_1st",
    "UI/alpha/1080P/rankingscene/1st.png",
    posX = -0.5,
    posY = 17.6,
    scale = 1.22,
    fly = "eff_UI_ranking_wings_1st"
  },
  {
    "eff_UI_ranking_lighting_2nd",
    "eff_UI_ranking_flashinglight_2nd",
    "UI/alpha/1080P/rankingscene/2nd.png",
    posX = -3.5,
    posY = 7,
    scale = 1.25
  },
  {
    "eff_UI_ranking_lighting_3rd",
    "eff_UI_ranking_flashinglight_3rd",
    "UI/alpha/1080P/rankingscene/3rd.png",
    posX = -2.5,
    posY = 11.5,
    scale = 1.21
  }
}

function ranklist:rankHandUi(data, newlayer)
  local mode = self.newMode
  if mode and data then
    if mode == "collect_point_local" or mode == "collection_point_global" then
      for i = 1, 3 do
        self.ui["Panel_hand_" .. i]:setVisible(false)
      end
      if self.rankPvpBgImg then
        self.rankPvpBgImg:setVisible(false)
      end
      if self.collectionRank then
        self.collectionRank:setVisible(true)
        self:refreshCollectionRank(data)
      else
        self.collectionRank = self:createCollectionRank(newlayer)
        self:refreshCollectionRank(data)
      end
      return
    elseif mode == "pvp" or mode == "pvp_r" then
      if self.collectionRank then
        self.collectionRank:setVisible(false)
      end
      for i = 1, 3 do
        self.ui["Panel_hand_" .. i]:setVisible(false)
      end
      if self.rankPvpBgImg then
        self.rankPvpBgImg:setVisible(true)
        self:refreshTopHandler(data)
      else
        self.rankPvpBgImg, self.rankPvpTopBgImg = self:createTopHandler(newlayer)
        self:refreshTopHandler(data)
      end
      return
    end
    if self.collectionRank then
      self.collectionRank:setVisible(false)
    end
    if self.rankPvpBgImg then
      self.rankPvpBgImg:setVisible(false)
    end
    for i = 1, 3 do
      self.ui["Panel_hand_" .. i]:setVisible(true)
    end
    local num = data.rankNum
    local lay = self.handLayer[num]
    local headGuild = mode == "guildliveness" or mode == "season_score" or mode == "dreamland_guild"
    local name = ed.getPlayerName(ed.transBotName(data.name), data.medal, {
      anchorPoint = self.ui["label_name_" .. num]:getAnchorPoint()
    })
    local posx, _ = self.ui["label_name_" .. num]:getPosition()
    name:setPosition(posx, num == 1 and 69 or 67)
    lay:addChild(name)
    local hand
    if headGuild and data.avatar then
      local avatarData = ed.analyzeAvatar(data.avatar)
      hand = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
    elseif data.avatar then
      hand = ed.getTeamHead({
        id = data.avatar,
        vip = 0 < (data.vip or 0)
      })
    end
    local posx, posy = self.ui["pan_icon_pos_" .. num]:getPosition()
    if hand then
      lay:addChild(hand, 9)
      hand:setPosition(posx, posy)
      hand:setScale(num == 1 and 1.1 or 0.95)
      if headGuild and data.avatar then
        hand = hand.icon
      end
      self:btRegisterButtonClick({
        button = hand,
        key = "rankItem" .. num,
        clickHandler = function()
          self:passRankHand(data, headGuild)
        end,
        force = true,
        pressScale = hand:getScale() - 0.1,
        normalScale = hand:getScale()
      })
    end
    local Fca = ed.createFcaNode(rankTop[num][1])
    Fca:setPosition(posx + rankTop[num].posX, posy - rankTop[num].posY)
    self:addFca(Fca)
    self.ui["Panel_hand_" .. num]:addChild(Fca, 3)
    Fca:setScale(rankTop[num].scale)
    lay.FcaDz = Fca
    if rankTop[num].fly then
      local Fca = ed.createFcaNode(rankTop[num].fly)
      Fca:setPosition(posx, posy - 60)
      self:addFca(Fca)
      self.ui["Panel_hand_" .. num]:addChild(Fca, 3)
      lay.FcaFly = Fca
    end
    local Fca = ed.createFcaNode(rankTop[num][2])
    Fca:setPosition(posx - 60, posy + 10)
    self:addFca(Fca)
    lay:addChild(Fca, 12)
    Fca:setScale(num == 1 and 1.2 or 1)
    local tag = ed.createSprite(rankTop[num][3])
    tag:setPosition(posx - 60, posy + 10)
    lay:addChild(tag, 13)
    tag:setScale(num == 1 and 1.2 or 1)
    local cfgStr = data.cfgStr or {}
    local label = ed.createttf(cfgStr.tipsText or "nil", 16)
    local posXY = ccpAdd(ccp(self.ui["img_dizuo_" .. num]:getPosition()), ccp(0, -70))
    local posx, posy = posXY.x, 35
    label:setPosition(posx - 40, posy)
    lay:addChild(label)
    label:setStroke(ccc3(ed.colorToStr("#372317")), 1)
    label:setColor(ccc3(ed.colorToStr("#fff39d")))
    if mode == "pvp" or mode == "pvp_r" then
      label:setString(T("\229\133\172\228\188\154:"))
      label:setColor(ccc3(ed.colorToStr("#fffce7")))
      local labelGuild = ed.createttf(data.guild_name or T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"), 16)
      labelGuild:setPosition(posx + 30, posy)
      labelGuild:setColor(ccc3(ed.colorToStr("#fff39d")))
      labelGuild:setStroke(ccc3(ed.colorToStr("#372317")), 1)
      lay:addChild(labelGuild)
    elseif mode == "full_hero_gs" or mode == "hero_team_gs" then
      local numNode = ed.getNumberNode({
        text = data.param1 or 0,
        folder = "hero_gs"
      }).node
      numNode:setPosition(posx + 50, posy)
      lay:addChild(numNode)
    elseif mode == "hero_evo_star" then
      local star = ed.createSprite("UI/alpha/1080P/campaign/worldmap/worldmap_star_normal.png")
      star:setPosition(posx + 17, posy)
      lay:addChild(star)
      local param = ed.createttf(data.param1 or 0, 16)
      param:setPosition(posx + 50, posy)
      param:setColor(ccc3(ed.colorToStr("#fff39d")))
      param:setStroke(ccc3(ed.colorToStr("#372317")), 1)
      lay:addChild(param)
    elseif mode == "autochess_rank" then
      local colors = {
        ccc3(186, 158, 96),
        ccc3(141, 164, 194),
        ccc3(183, 157, 137)
      }
      label:setVisible(false)
      ed.createLabelTools({
        txt = cfgStr.tipsText and cfgStr.tipsText .. ":" or "nil",
        size = 16,
        anchor = ccp(1, 0.5),
        pos = ccp(posx + 3, posy + 7),
        color = colors[num],
        parent = lay
      })
      ed.createLabelTools({
        txt = T("\231\167\175\229\136\134:"),
        size = 16,
        anchor = ccp(1, 0.5),
        pos = ccp(posx + 3, posy - 10),
        color = colors[num],
        parent = lay
      })
      local stage = ed.AutoChessRankManager:getRankGradeInfoByScore(data.param1 or 0)
      ed.createLabelTools({
        txt = stage.name or 0,
        size = 16,
        anchor = ccp(0, 0.5),
        pos = ccp(posx + 5, posy + 7),
        color = colors[num],
        parent = lay
      })
      ed.createLabelTools({
        txt = data.param1 or 0,
        size = 16,
        anchor = ccp(0, 0.5),
        pos = ccp(posx + 5, posy - 10),
        color = colors[num],
        parent = lay
      })
    elseif mode == "real_arena" then
      label:setVisible(false)
      local colors = {
        ccc3(186, 158, 96),
        ccc3(141, 164, 194),
        ccc3(183, 157, 137)
      }
      ed.createLabelTools({
        txt = T("\231\167\175\229\136\134:"),
        size = 16,
        anchor = ccp(1, 0.5),
        pos = ccp(posx - 5, posy),
        color = colors[num],
        parent = lay
      })
      ed.createLabelTools({
        txt = data.param1 or 0,
        size = 16,
        anchor = ccp(0, 0.5),
        pos = ccp(posx + 5, posy),
        color = colors[num],
        parent = lay
      })
    else
      local param = ed.createttf(data.param1 or "", 16)
      param:setPosition(posx + 50, posy)
      param:setColor(ccc3(249, 210, 102))
      lay:addChild(param)
    end
    label:limitWidthByScale(100)
  end
end

function ranklist:passRankHand(data, isguild, x, y)
  if x and y and not ed.containsPoint(self.ui.pan_list_pos, x, y) then
    return
  end
  local mode = self.newMode
  if not data then
    return
  end
  if mode == "pvp" or mode == "pvp_r" then
    ed.registerNetReply("query_pvp_oppo", function(data)
      data = data[".data"]
      data = data._user or data
      local panel = ed.ui.userPvpSummaryWin.create(data)
      panel:popWindow()
    end)
    local msg = ed.upmsg.ladder()
    msg._query_oppo = {}
    msg._query_oppo._oppo_user_id = data.uid
    ed.send(msg, "ladder")
  elseif isguild or mode == "guildliveness" or mode == "dreamland_guild" then
    local president = data.president
    local guild_summary = {
      _avatar = data.avatar or president._avatar,
      _name = data.name,
      _id = data.id,
      _president = {
        _name = president._name or ""
      },
      _member_cnt = data.member_cnt,
      _slogan = data.slogan
    }
    ed.ui.guildSummaryWin.create(data.rankNum, guild_summary):popWindow()
  elseif ed.getUserid() ~= data.uid then
    ed.registerNetReply("req_home_page", function(data)
      local panel = ed.ui.PlayerInfoPanel.create(data, false)
      panel:popWindow()
    end)
    ed.PlayerInfoNetwork:requestHomePage(data.roleId)
  else
    ed.registerNetReply("personal_home_page", function(data)
      local panel = ed.ui.PlayerInfoPanel.create(data, true)
      panel:popWindow()
    end)
    ed.PlayerInfoNetwork:openPanel()
  end
end

function ranklist:autoWinUiSize()
  local ui = self.ui
  local thisCon = self.ui.pan_list_pos:getContentSize()
  ui.pan_list_pos:setContentSize(CCSizeMake(thisCon.width, thisCon.height - 57))
  ed.layout.layoutWithMagin(ui.img_title_bg, {left = 80, top = 15})
end

function ranklist:createTopHandler(newlayer)
  local bgImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/rankingscene/arena_1st_base.png",
    pos = ccp(344, -186),
    parent = self.ui.pan_top
  })
  local spine = ed.createSpine("effect/eff_UI_rankingscene_arena_1st_light/eff_UI_rankingscene_arena_1st_light", 1)
  spine:setAnimation(0, "Idle", true)
  spine:setPosition(345, 240)
  bgImg:addChild(spine, 999)
  spine:setOpacity(150)
  local particle = CCParticleSystemQuad:create("UI/particle/xingxing.plist")
  bgImg:addChild(particle, 999)
  particle:setEmissionRate(11)
  particle:setPosition(225, 245)
  local particle = CCParticleSystemQuad:create("UI/particle/xingxing.plist")
  bgImg:addChild(particle, 999)
  particle:setPosition(465, 245)
  particle:setEmissionRate(11)
  local topBgImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/rankingscene/arena_2nd3rd_base.png",
    pos = ccp(330, 70),
    parent = bgImg,
    z = 99
  })
  topBgImg:setAnchorPoint(ccp(0.5, 1))
  self.accOpacitys.topBgImg = topBgImg
  self.headBgImgs = {}
  self.herosFcaLays = {}
  local fcaInfo = {
    {
      pos = ccp(210, 175),
      panel = bgImg,
      headBgImgPos = ccp(370, 175),
      res = "1st",
      fcaPos = ccp(310, 202)
    },
    {
      pos = ccp(100, 40),
      panel = topBgImg,
      headBgImgPos = ccp(260, 40),
      res = "2nd",
      fcaPos = ccp(180, 67)
    },
    {
      pos = ccp(465, 40),
      panel = topBgImg,
      headBgImgPos = ccp(625, 40),
      res = "3rd",
      fcaPos = ccp(545, 67)
    }
  }
  for num = 1, 3 do
    local Fca = ed.createFcaNode(rankTop[num][2])
    Fca:setPosition(fcaInfo[num].pos)
    self:addFca(Fca)
    fcaInfo[num].panel:addChild(Fca, 12)
    local tag = ed.createSprite(rankTop[num][3])
    tag:setPosition(fcaInfo[num].pos)
    fcaInfo[num].panel:addChild(tag, 13)
    local headBgImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/rankingscene/arena_" .. fcaInfo[num].res .. "_nameframe.png",
      pos = fcaInfo[num].headBgImgPos,
      parent = fcaInfo[num].panel
    })
    self.headBgImgs[num] = headBgImg
    local layer = CCLayer:create()
    layer:setPosition(fcaInfo[num].fcaPos)
    fcaInfo[num].panel:addChild(layer, 99)
    self.herosFcaLays[num] = layer
    if 1 < num then
      self.accOpacitys["tag" .. num] = tag
      self.accOpacitys["headBgImg" .. num] = headBgImg
    end
  end
  return bgImg, topBgImg
end

function ranklist:refreshTopHandler(data)
  local headBgImg = self.headBgImgs[data.rankNum]
  headBgImg:removeAllChildrenWithCleanup(true)
  local hand = ed.getTeamHead({
    id = data.avatar,
    vip = 0 < (data.vip or 0)
  })
  hand:setCascadeOpacityEnabled(true)
  if hand then
    headBgImg:addChild(hand, 9)
    hand:setPosition(0, 25)
    hand:setScale(0.72)
    self:btRegisterButtonClick({
      button = hand,
      key = "rankItem" .. data.rankNum,
      clickHandler = function()
        self:passRankHand(data)
      end,
      force = true,
      pressScale = hand:getScale() - 0.1,
      normalScale = hand:getScale()
    })
  end
  local name, _, autoText = ed.getPlayerName(ed.transBotName(data.name), data.medal, {left = true})
  name:setPosition(49, 35)
  headBgImg:addChild(name)
  name:setScale(0.95)
  local labelGuild = ed.createttf(data.guild_name or T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"), 17)
  labelGuild:setPosition(49, 12)
  labelGuild:setColor(ccc3(ed.colorToStr("#fff39d")))
  labelGuild:setStroke(ccc3(ed.colorToStr("#372317")), 1)
  headBgImg:addChild(labelGuild)
  labelGuild:setAnchorPoint(ccp(0, 0.5))
  if data.rankNum > 1 then
    self.accOpacitys["hand" .. data.rankNum] = hand
    self.accOpacitys["autoText" .. data.rankNum] = autoText.node
    self.accOpacitys["labelGuild" .. data.rankNum] = labelGuild
  end
end

function ranklist:createCollectionRank(newlayer)
  local bgImg = ed.createSpriteTools({
    res = "",
    pos = ccp(0, -186),
    parent = self.ui.pan_top
  })
  local collection_1st = ed.createSpriteTools({
    res = "UI/alpha/1080P/rankingscene/collection_1st.png",
    pos = ccp(344, -100),
    parent = bgImg
  })
  local collection_2st = ed.createSpriteTools({
    res = "UI/alpha/1080P/rankingscene/collection_2nd.png",
    pos = ccp(104, -120),
    parent = bgImg
  })
  local collection_3st = ed.createSpriteTools({
    res = "UI/alpha/1080P/rankingscene/collection_3rd.png",
    pos = ccp(584, -130),
    parent = bgImg
  })
  self.collectionList = {
    collection_1st,
    collection_2st,
    collection_3st
  }
  return bgImg
end

function ranklist:refreshCollectionRank(data)
  local bg = self.collectionList[data.rankNum]
  bg:removeAllChildrenWithCleanup(true)
  local size = bg:getContentSize()
  local hand = ed.getTeamHead({
    id = data.avatar,
    vip = 0 < (data.vip or 0)
  })
  hand:setCascadeOpacityEnabled(true)
  if hand then
    bg:addChild(hand, 9)
    hand:setPosition(size.width / 2, size.height * 0.72 + (data.rankNum == 3 and 10 or 0))
    hand:setScale(data.rankNum == 1 and 0.9 or 0.82)
    self:btRegisterButtonClick({
      button = hand,
      key = "CollectionRank" .. data.rankNum,
      clickHandler = function()
        ed.rank_network.sendLookCollectionReq(data.roleId, data.rankNum)
      end,
      force = true,
      pressScale = hand:getScale() - 0.1,
      normalScale = hand:getScale()
    })
  end
  local name, _, autoText = ed.getPlayerName(ed.transBotName(data.name), data.medal)
  name:setPosition(size.width / 2, size.height * 0.57 + (data.rankNum == 3 and 10 or 0))
  bg:addChild(name)
  name:setScale(data.rankNum == 1 and 0.97 or 0.9)
  local point = ed.ui.gradientLabel.create({
    text = T("\230\148\182\232\151\143\229\136\134\239\188\154%d", data.param1),
    fontSize = data.rankNum == 1 and 16 or 14,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16445333),
    endColor = ed.toccc3(16760922),
    strokeSize = 2,
    strokeColor = ed.toccc3(1514544)
  })
  point.node:setPosition(size.width / 2, size.height * 0.51 + (data.rankNum == 3 and 10 or 0))
  bg:addChild(point.node)
  local puppet, _ = ed.readhero.getActor(data.param2, "Idle", true, false, data.param3)
  puppet:setScale(0.6)
  puppet:setPosition(size.width / 2, data.rankNum == 1 and 95 or data.rankNum == 2 and 70 or 70)
  bg:addChild(puppet, 99)
  self:addFca(puppet)
  local spine = ed.createSpine("effect/eff_UI_ranking_collection/eff_UI_ranking_collection", 0.6)
  spine:setAnimation(0, data.rankNum == 1 and "Idle" or data.rankNum == 2 and "Idle2" or "Idle3", true)
  spine:setPosition(0, 0)
  puppet:addChild(spine, 999)
  local mydata = self.listData:getModeListMyData(self.newMode)
  if mydata and mydata.rankNum == data.rankNum then
    self.selfPuppet = puppet
  end
end

function ranklist:setCollectionHeroReply(hero_id)
  if self.selfPuppet then
    local p = self.selfPuppet:getParent()
    local x, y = self.selfPuppet:getPosition()
    self.selfPuppet:removeFromParentAndCleanup(true)
    self:removeFca(self.selfPuppet)
    local hero = ed.player:getHero(hero_id)
    local fashionId
    if hero and hero.data and hero.data._fashion then
      fashionId = hero.data._fashion
    end
    local puppet, _ = ed.readhero.getActor(hero_id, "Idle", true, false, fashionId)
    puppet:setScale(0.7)
    puppet:setPosition(x, y)
    p:addChild(puppet, 99)
    self:addFca(puppet)
    self.selfPuppet = puppet
    local mydata = self.listData:getModeListMyData(self.newMode)
    mydata.param2 = hero_id
    local spine = ed.createSpine("effect/eff_UI_ranking_collection/eff_UI_ranking_collection", 0.6)
    spine:setAnimation(0, mydata.rankNum == 1 and "Idle" or mydata.rankNum == 2 and "Idle2" or "Idle3", true)
    spine:setPosition(0, 0)
    puppet:addChild(spine, 999)
  end
end
