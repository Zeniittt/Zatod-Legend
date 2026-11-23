local PlayerInfoPanel = {}
PlayerInfoPanel.__index = PlayerInfoPanel
ed.ui.PlayerInfoPanel = PlayerInfoPanel
local base = ed.ui.popwindow
setmetatable(PlayerInfoPanel, base.mt)
local PlayerInfoPanelScope = {}
local HOMEPAGE_MODE = {
  VIEW = 1,
  EDIT = 2,
  DELETE = 3
}
ed.UITool.registViewOpenFunc("playerInfoPanel", function(roleId)
  ListenEventOnce("req_home_page", function(data)
    local isSelf = roleId == ed.getRoleId()
    if not ed.getPopWindow("playerInfoPanel") then
      local panel = ed.ui.PlayerInfoPanel.create(data, isSelf)
      panel:popWindow()
    end
  end)
  ed.PlayerInfoNetwork:requestHomePage(roleId)
end)

function PlayerInfoPanel.create(data, isSelf)
  local panel = base.create("playerInfoPanel")
  setmetatable(panel, PlayerInfoPanel)
  panel.mode = HOMEPAGE_MODE.VIEW
  panel:initData(data)
  panel:initAppearance()
  panel:registerTouchHandler()
  panel:registerEvent()
  panel:changeMode(HOMEPAGE_MODE.VIEW)
  return panel
end

function PlayerInfoPanel:destroy()
  CloseScope(PlayerInfoPanelScope)
  ed.playEffect(ed.sound.deo.common_close_popup_window)
  base.destroy(self)
end

function PlayerInfoPanel:initData(data)
  self.uid = data._uid
  self.userSummary = data._user_summary
  self.heroCount = data._hero_cnt
  self.totalHeroGs = data._total_hero_gs
  self.guildName = data._guild_name
  self.roleId = data._user_summary._role_id
  self.isSelf = self.roleId == ed.getRoleId()
  self.region = data._region
  self.regionId = data._region_id
  self.serverName = data._svr_name
  self.sign = data._signature
  self.achievementCup = data._achievement_cup or {}
  self.fashoinAmount = data._fashoins or 0
  self.honorWallItems = data._honor_wall or {}
  local params = {}
  params.row = 12
  params.column = 18
  params.gap = 2
  params.gridWidth = 32.2
  params.gridHeight = 32.5
  params.gridRes = "UI/alpha/1080P/honorwall/honorwall_cell.png"
  self.params = params
  self.gridWidth = params.gridWidth
  self.gridHeight = params.gridHeight
  self.gap = params.gap
  self.iconInfoList = {}
  self.iconIndex = 0
  self.deleteBuffer = {}
end

function PlayerInfoPanel:initAppearance()
  local container, ui = ed.editorui(ed.uieditor.player_info_panel)
  self.mainLayer:addChild(container)
  self.container = container
  self.ui = ui
  local posx, posy = ui.image_bg:getPosition()
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  ui.image_bg:setPosition(posx + newWid, posy + newHei)
  if ed.isAreaKorea() or ed.isAreaJapan() then
    ui.label_title:setFontSize(24)
  end
  ed.setLabelFontName(ui.label_title, ed.fontBold)
  ed.setLabelStroke(ui.label_title, ed.toccc3(12743962), 1)
  ed.setLabelShadow(ui.label_title, ed.toccc3(3417361), ccp(0, 2))
  self.ui.btn_deal:setVisible(false)
  self.ui.btn_report:setVisible(false)
  local btn = {
    {"btn_chat"},
    {
      "btn_delete_friend",
      "btn_friend"
    },
    {"btn_black"}
  }
  for i, v in ipairs(btn) do
    for ii, vv in ipairs(v) do
      self.ui[vv]:setPositionX(40 + i * 134)
    end
  end
  local headId = ed.analyzeAvatar(self.userSummary._avatar).avatar
  local headFrameId = ed.analyzeAvatar(self.userSummary._avatar).avatarFrame
  local head = ed.getHeadIcon({id = headId})
  self.ui.node_head:addChild(head)
  local frame, frameicon, framefca = ed.getHeadFrame({
    id = headFrameId,
    sp_delay = false,
    hide_icon_when_dyna = true
  })
  self.ui.node_head:addChild(frame)
  local newLevel, isBabel = ed.player:getNewLevel(self.userSummary._babel_level, self.userSummary._level)
  local newLabel = ed.createLabelTTF(newLevel, 18)
  ed.setLabelColor(newLabel, ccc3(ed.colorToStr("#fffce7")))
  ui.node_level:addChild(newLabel)
  local nameStr = ed.transBotName(self.userSummary._name)
  local name, width, autoText = ed.getPlayerName(nameStr, self.userSummary._medal, {
    anchorPoint = ccp(0.5, 0.5)
  })
  ed.UITool.replaceUI(ui, "image_bg2", "label_name", name)
  name:setScale(0.84)
  if autoText.spriteNode.medalIcon then
    name:setPositionX(name:getPositionX() + 7)
  end
  ed.setString(ui.label_hero_count, self.heroCount)
  ed.setString(ui.label_skin_count, self.fashoinAmount or 0)
  ed.setString(ui.label_gs, self.totalHeroGs)
  if self.guildName == nil or self.guildName == "" then
    self.guildName = T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154")
  end
  ed.setString(ui.label_union, self.guildName)
  ed.setString(ui.label_server, self.serverName)
  local context = self.sign
  if self.isSelf then
    context = context .. "<sprite src=UI/alpha/1080P/honorwall/honorwall_edit.png scale=1>"
  end
  local sign = ed.ui.autoText.new()
  sign:initParam({
    context = context,
    fontSize = 14,
    fontColor = ccc3(255, 252, 231),
    maxWidth = 160,
    lineSpacing = 0
  })
  ed.UITool.replaceUI(self.ui, "image_bg2", "label_sign", sign.node)
  if self.isSelf then
    self.ui.node_btn:setVisible(true)
    self.ui.node_chat:setVisible(false)
  else
    self.ui.node_btn:setVisible(false)
    self.ui.node_chat:setVisible(true)
    if self.uid == tonumber(ed.getUserid()) and self.serverId == tonumber(game_server_id) then
      self.ui.node_chat:setVisible(false)
    end
    local isGM = ed.player:isGM()
    self.ui.btn_gm:setVisible(isGM)
  end
  self.grids = Grids.create(self.params)
  self.gridsNode = self.grids:getNode()
  self.gridsNode:setVisible(false)
  ui.node_grids:addChild(self.gridsNode)
  self.gridsLayer = CCLayer:create()
  ui.node_grids:addChild(self.gridsLayer)
  self:initWallItems()
  self:refreshAchievementCup()
  if not self.isSelf then
    local bool = ed.friendlist.isInFriendlist(self.roleId)
    self.ui.btn_friend:setVisible(not bool)
    self.ui.btn_delete_friend:setVisible(bool)
  end
end

function PlayerInfoPanel:refreshAchievementCup()
  local labelNameList = {
    "cup_diamond_amount",
    "cup_gold_amount",
    "cup_silver_amount",
    "cup_copper_amount"
  }
  for index = 1, #labelNameList do
    local labelName = labelNameList[index]
    local amount = self.achievementCup[index] or 0
    ed.setString(self.ui[labelName], amount)
  end
end

function PlayerInfoPanel:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_close",
    clickHandler = function()
      if self.mode ~= HOMEPAGE_MODE.VIEW then
        ed.showConfirmDialog({
          text = T("\229\189\147\229\137\141\229\164\132\228\186\142\231\188\150\232\190\145\231\138\182\230\128\129\239\188\140\230\152\175\229\144\166\229\176\134\230\155\180\230\148\185\228\191\157\229\173\152\229\136\176\232\141\163\232\170\137\229\162\153\228\184\173\239\188\159"),
          leftText = T("\228\184\141\228\191\157\229\173\152"),
          leftHandler = function()
            self:destroy()
          end,
          showCloseButton = true,
          rightText = T("\228\191\157\229\173\152"),
          rightHandler = function()
            self:saveHonorWall()
            self:destroy()
          end
        })
      else
        self:destroy()
      end
    end,
    clickInterval = 0.5,
    pressScale = 0.75,
    normalScale = 0.8
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_edit,
    press = self.ui.btn_edit_press,
    key = "btn_edit",
    clickHandler = function()
      if self.isSelf then
        self:changeMode(HOMEPAGE_MODE.EDIT)
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_save,
    key = "btn_save",
    clickHandler = function()
      if not self.isSelf then
        return
      end
      ed.showConfirmDialog({
        text = T("\230\152\175\229\144\166\228\191\157\229\173\152\229\189\147\229\137\141\231\154\132\232\141\163\232\170\137\229\162\153\233\133\141\231\189\174\239\188\159"),
        rightText = T("\231\161\174\229\174\154"),
        rightHandler = function()
          self:saveHonorWall()
        end
      })
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_honor,
    press = self.ui.btn_honor_press,
    key = "btn_honor",
    clickHandler = function()
      if self.isSelf then
        self:changeMode(HOMEPAGE_MODE.EDIT)
        local panel = PlayerAddHonorPanel.create()
        panel:popWindow(999)
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_delete,
    press = self.ui.btn_delete_press,
    key = "btn_delete",
    clickHandler = function()
      if self.isSelf then
        if self.mode == HOMEPAGE_MODE.DELETE then
          self:changeMode(HOMEPAGE_MODE.EDIT)
        else
          self:changeMode(HOMEPAGE_MODE.DELETE)
        end
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_undo,
    press = self.ui.btn_undo_press,
    key = "btn_undo",
    clickHandler = function()
      if self.isSelf and #self.deleteBuffer > 0 then
        self:undo()
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_chat,
    press = self.ui.btn_chat_press,
    key = "btn_chat",
    clickHandler = function()
      if not self.isSelf then
        local params = {
          uid = self.uid,
          summary = self.userSummary,
          roleId = self.roleId,
          server_name = self.serverName
        }
        if ed.chatManager.chatPopWin.chatMainWin then
          FireEvent("chat_private_target", params)
        else
          FireEvent("chat_private_target", params)
          ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.personal_channel)
        end
        self:destroy()
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_black,
    press = self.ui.btn_black_press,
    key = "btn_black",
    clickHandler = function()
      if not self.isSelf then
        ed.chatNetDataMrg:sendAddBlackList(self.roleId)
        self:destroy()
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_friend,
    press = self.ui.btn_friend_press,
    key = "btn_friend",
    clickHandler = function()
      if not self.isSelf then
        local roleId = self.roleId
        ed.ui.chat.sendAddFriendLink(roleId)
        self:destroy()
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_delete_friend,
    press = self.ui.btn_delete_friend_press,
    key = "btn_delete_friend",
    clickHandler = function()
      if not self.isSelf then
        local roleId = self.roleId
        
        function ed.netreply.delFriend()
          ed.friendlist.deleteFriendlist(roleId)
        end
        
        ed.chatNetDataMrg:sendDelFriend(roleId)
        self:destroy()
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_report,
    press = self.ui.btn_report_press,
    key = "btn_report",
    clickHandler = function()
      if not self.isSelf then
        local panel = PlayerReportPanel.create({
          serverId = self.serverId,
          userId = self.uid
        })
        panel:popWindow()
      end
    end,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_gm,
    press = self.ui.btn_gm_press,
    key = "btn_gm",
    clickHandler = function()
      if not self.isSelf then
        local panel = PlayerGMPanel.create({
          serverId = self.serverId,
          userId = self.uid
        })
        panel:popWindow()
      end
    end,
    pressScale = 0.95
  })
  local nt = ed.getServerTime()
  local startTime = ed.dateStringToTime(ed.getDataTable("AllStar")[1]["Start Time"])
  local endTime = ed.dateStringToTime(ed.getDataTable("AllStar")[1]["End Time"])
  if nt >= startTime and nt <= endTime then
    self:createGiveBtn()
  end
  if not ed.dragonBoatMgr:getInstance():IsExpire() then
    ed.dragonBoatNet:sendQueryGiveStatus(self.roleId)
  end
  local pressPos, pressTime
  local click_dis = 25
  local click_gap = 2
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        for idx, info in pairs(self.iconInfoList) do
          if ed.containsPoint(info.node, x, y) then
            if self.mode == HOMEPAGE_MODE.EDIT then
              self.selectedInfo = info
              self.selectedIndex = idx
              self.selectedNode = info.node
              self.selectedIconRect = CCRectMake(info.rect.origin.x, info.rect.origin.y, info.rect.size.width, info.rect.size.height)
              self.selectedIconPos = ccp(info.node:getPosition())
              info.selected.Yellow:setVisible(true)
              info.selected.Blue:setVisible(false)
              info.node:setZOrder(1)
              break
            end
            if self.mode == HOMEPAGE_MODE.DELETE then
              self.selectedIndex = idx
              break
            end
            if self.mode == HOMEPAGE_MODE.VIEW then
              self.clickIcon = true
              self.selectedInfo = info
              pressPos = ccp(x, y)
              pressTime = ed.getSystemTime()
            end
            break
          end
        end
        if self.isSelf and ed.containsPoint(self.ui.Panel_1207, x, y) then
          self.editSign = true
        end
      elseif event == "moved" then
        if self.mode == HOMEPAGE_MODE.EDIT and self.selectedIndex then
          local pos = self.gridsNode:convertToNodeSpace(ccp(x, y))
          if math.abs(pos.x - self.selectedIconPos.x) > 0.5 * (self.gridWidth + self.gap) then
            local sign = 1
            if pos.x < self.selectedIconPos.x then
              sign = -1
            end
            self.selectedIconPos.x = self.selectedIconPos.x + sign * (self.gridWidth + self.gap)
            self.selectedIconRect.origin.x = self.selectedIconRect.origin.x + sign
          end
          if math.abs(pos.y - self.selectedIconPos.y) > 0.5 * (self.gridHeight + self.gap) then
            local sign = 1
            if pos.y < self.selectedIconPos.y then
              sign = -1
            end
            self.selectedIconPos.y = self.selectedIconPos.y + sign * (self.gridHeight + self.gap)
            self.selectedIconRect.origin.y = self.selectedIconRect.origin.y + sign
          end
          self.selectedNode:setPosition(self.selectedIconPos)
          if self.grids:checkCollision(self.selectedIconRect, self.selectedInfo.rect) then
            self.selectedInfo.selected.Red:setVisible(true)
            self.selectedInfo.selected.Yellow:setVisible(false)
          else
            self.selectedInfo.selected.Red:setVisible(false)
            self.selectedInfo.selected.Yellow:setVisible(true)
          end
        end
      elseif event == "ended" then
        if self.mode == HOMEPAGE_MODE.EDIT and self.selectedIndex then
          local rect = self.selectedIconRect
          local gridsRect = self.grids:getContentRect()
          self.selectedInfo.selected.Yellow:setVisible(false)
          self.selectedInfo.selected.Red:setVisible(false)
          self.selectedInfo.selected.Blue:setVisible(true)
          self.selectedNode:setZOrder(0)
          if rect:getMinX() >= gridsRect:getMinX() and rect:getMinY() >= gridsRect:getMinY() and rect:getMaxX() <= gridsRect:getMaxX() and rect:getMaxY() <= gridsRect:getMaxY() and not self.grids:checkCollision(rect, self.selectedInfo.rect) then
            self:moveToRect(self.selectedIndex, rect)
          elseif rect:getMaxX() <= gridsRect:getMinX() or rect:getMaxY() <= gridsRect:getMinY() or rect:getMinX() >= gridsRect:getMaxX() or rect:getMinY() >= gridsRect:getMaxY() then
            self:resetToRect(self.selectedIndex)
          else
            self:resetToRect(self.selectedIndex)
          end
        elseif self.mode == HOMEPAGE_MODE.DELETE and self.selectedIndex then
          self:removeIcon(self.selectedIndex)
        elseif self.mode == HOMEPAGE_MODE.VIEW and self.clickIcon then
          local pos = pressPos
          local time = pressTime
          if math.abs(y - pos.y) < click_dis and math.abs(x - pos.x) < click_dis and ed.getSystemTime() - time < click_gap then
            local data = self.selectedInfo.data
            if data.type == "hero" then
              if self.isSelf then
                local hero = ed.player:getHero(data.hero._tid)
                local panel = ed.ui.checkOthersHeroWindow.create(hero)
                panel:popWindow()
              else
                ed.ui.checkOthersHeroWindow.create():popWindow()
                ed.PlayerInfoNetwork:requestHeroData(self.roleId, data.hero._tid)
              end
            elseif data.type == "medal" then
              local panel = MedalInfoPanel.create(data.medalId)
              panel:popWindow()
            elseif data.type == "avatar" then
              local panel = AvatarInfoPanel.create(data.headId, data.frameId)
              panel:popWindow()
            elseif data.type == "achievement" then
              local panel = AchievementInfoPanel.create(data.achievementId)
              panel:popWindow()
            elseif data.type == "photo" then
              if EDCreateCustomizePhoto then
                local panel = PhotoInfoPanel.create(data.photoId)
                panel:popWindow()
              else
                ed.showToast(T("\229\189\147\229\137\141\231\137\136\230\156\172\228\184\141\230\148\175\230\140\129\230\152\190\231\164\186\232\135\170\229\174\154\228\185\137\229\164\180\229\131\143"))
              end
            end
          end
        end
        if self.editSign then
          local panel = PlayerSignPanel.create(self.sign)
          panel:popWindow()
        end
        pressPos = nil
        pressTime = nil
        self.editSign = nil
        self.clickIcon = nil
        self.selectedNode = nil
        self.selectedInfo = nil
        self.selectedIndex = nil
        self.selectedIconRect = nil
        self.selectedIconPos = nil
      end
    end,
    key = "node_grids_touch",
    priority = -1,
    force = true
  })
end

function PlayerInfoPanel:registerEvent()
  self:listenEvent("HomePage_Add_Honor", function(data)
    self:addHonor(data)
  end)
  self:listenEvent("set_honor_wall", function(data)
    self:onSaveResult(data)
  end)
  self:listenEvent("set_signature", function(data)
    self:onSetSign(data)
  end)
  self:listenEvent("req_hero_info", function(data)
    self:onRequestHero(data)
  end)
  self:listenEvent("add_honor_back", function(data)
    self:onAddHonorBack()
  end)
  self:listenEvent("DragonBoatQueryGiveStatus", function(data)
    if data._give_status and ed.isElementInTable(data._give_status, {
      "dragon_boat_can_give",
      "dragon_boat_level_not_enough",
      "dragon_boat_give_num_not_enough",
      "dragon_boat_item_not_enough",
      "dragon_boat_oppo_server_down"
    }) then
      self:createGiveBtn(data._give_status)
    end
  end)
end

function PlayerInfoPanel:addHonor(data)
  local result
  if data.type == "medal" then
    local medal = data.medal
    result = self:addMedalIcon(medal.key)
  elseif data.type == "hero" then
    local hero = data.hero
    result = self:addHeroIcon(hero)
  elseif data.type == "avatar" then
    local avatar = data.avatar
    local frame = data.frame
    result = self:addAvatarIcon(avatar.key, frame.id)
  elseif data.type == "achievement" then
    local achievement = data.achievement
    result = self:addAchievementIcon(achievement.id)
  elseif data.type == "photo" then
    local photoId = data.photoId
    local frame = data.frame
    result = self:addCustomPhoto(photoId, frame.id)
  end
  if result then
    ed.showToast(T("\229\183\178\230\183\187\229\138\160\232\135\179\232\141\163\232\170\137\229\162\153"))
  end
end

function PlayerInfoPanel:saveHonorWall()
  local items = {}
  for idx, info in pairs(self.iconInfoList) do
    local item = {}
    item.type = info.data.type
    if item.type == "hero" then
      item.heroId = info.data.hero._tid
    elseif item.type == "medal" then
      item.medalId = info.data.medalId
    elseif item.type == "avatar" then
      item.frameId = info.data.frameId
      item.headId = info.data.headId
    elseif item.type == "achievement" then
      item.achievementId = info.data.achievementId
    elseif item.type == "photo" then
      item.photoId = info.data.photoId
      item.frameId = info.data.frameId
    end
    item.x = info.rect.origin.x
    item.y = info.rect.origin.y
    table.insert(items, item)
  end
  ed.PlayerInfoNetwork:saveHonorWall(items)
end

function PlayerInfoPanel:onSaveResult(data)
  if data == "success" then
    ed.showToast(T("\228\191\157\229\173\152\230\136\144\229\138\159"))
    self:changeMode(HOMEPAGE_MODE.VIEW)
  else
    ed.showToast(T("\228\191\157\229\173\152\229\164\177\232\180\165"))
  end
end

function PlayerInfoPanel:onSetSign(data)
  self.sign = data
  local context = self.sign
  if self.isSelf then
    context = context .. "<sprite src=UI/alpha/1080P/honorwall/honorwall_edit.png scale=1>"
  end
  local sign = ed.ui.autoText.new()
  sign:initParam({
    context = context,
    fontSize = 14,
    fontColor = ccc3(255, 252, 231),
    maxWidth = 160,
    lineSpacing = 0
  })
  ed.UITool.replaceUI(self.ui, "image_bg2", "label_sign", sign.node)
end

function PlayerInfoPanel:onRequestHero(data)
end

function PlayerInfoPanel:onAddHonorBack()
end

function PlayerInfoPanel:changeMode(mode)
  self.mode = mode
  if mode == HOMEPAGE_MODE.VIEW then
    self.ui.btn_edit:setVisible(true)
    self.ui.btn_save:setVisible(false)
    self.ui.btn_honor:setVisible(false)
    self.ui.btn_delete:setVisible(false)
    self.ui.btn_undo:setVisible(false)
    self.ui.image_delete_valid:setVisible(false)
    self.ui.label_delete:setColor(ccc3(255, 255, 255))
    self.gridsNode:setVisible(false)
  elseif mode == HOMEPAGE_MODE.EDIT then
    self.ui.btn_edit:setVisible(false)
    self.ui.btn_save:setVisible(true)
    self.ui.btn_honor:setVisible(true)
    self.ui.btn_delete:setVisible(true)
    self.ui.btn_undo:setVisible(false)
    self.ui.image_delete_valid:setVisible(false)
    self.ui.label_delete:setColor(ccc3(255, 255, 255))
    self.gridsNode:setVisible(true)
  elseif mode == HOMEPAGE_MODE.DELETE then
    self.ui.btn_edit:setVisible(false)
    self.ui.btn_save:setVisible(true)
    self.ui.btn_honor:setVisible(false)
    self.ui.btn_delete:setVisible(true)
    self.ui.btn_undo:setVisible(true)
    self.ui.image_delete_valid:setVisible(true)
    self.ui.label_delete:setColor(ccc3(232, 255, 148))
    self.gridsNode:setVisible(true)
  end
  for _, info in pairs(self.iconInfoList) do
    info.selected.Blue:setVisible(mode == HOMEPAGE_MODE.EDIT)
  end
  for _, info in pairs(self.iconInfoList) do
    info.selected.Red:setVisible(mode == HOMEPAGE_MODE.DELETE)
  end
  if mode ~= HOMEPAGE_MODE.DELETE then
    self.deleteBuffer = {}
  else
    self.ui.image_undo_disable:setVisible(#self.deleteBuffer == 0)
  end
end

function PlayerInfoPanel:placeIcon(node, size, data, pos)
  local rect
  if pos then
    rect = CCRectMake(pos.x, pos.y, size.width, size.height)
    local res = self.grids:checkCollision(rect)
    if res then
      return
    end
  end
  if rect == nil then
    rect = self.grids:findPlace(size.width, size.height)
    if rect == nil then
      ed.showToast(T("\230\145\134\230\148\190\231\169\186\233\151\180\228\184\141\232\182\179"))
      return false
    end
  end
  local width = size.width * (self.gridWidth + self.gap) - self.gap
  local height = size.height * (self.gridHeight + self.gap) - self.gap
  local selectedBlueImage = ed.createScale9Sprite("UI/alpha/1080P/honorwall/homepage_select_1.png", CCRectMake(10, 10, 20, 20))
  selectedBlueImage:setContentSize(CCSizeMake(width + 4, height + 2))
  selectedBlueImage:setPosition(ccp(width / 2, height / 2 - 1))
  node:addChild(selectedBlueImage)
  local selectedYellowImage = ed.createScale9Sprite("UI/alpha/1080P/honorwall/homepage_select_2.png", CCRectMake(10, 10, 20, 20))
  selectedYellowImage:setContentSize(CCSizeMake(width + 4, height + 2))
  selectedYellowImage:setPosition(ccp(width / 2, height / 2 - 1))
  node:addChild(selectedYellowImage)
  selectedYellowImage:setColor(ccc3(1, 1, 1))
  local selectedRedImage = ed.createScale9Sprite("UI/alpha/1080P/honorwall/homepage_select_3.png", CCRectMake(10, 10, 20, 20))
  selectedRedImage:setContentSize(CCSizeMake(width + 4, height + 2))
  selectedRedImage:setPosition(ccp(width / 2, height / 2 - 1))
  node:addChild(selectedRedImage)
  selectedBlueImage:setVisible(self.mode == HOMEPAGE_MODE.EDIT)
  selectedYellowImage:setVisible(false)
  selectedRedImage:setVisible(self.mode == HOMEPAGE_MODE.DELETE)
  selectedYellowImage:setColor(ccc3(ed.colorToStr("#FF4800")))
  node:setPosition(self:rect2centerPos(rect))
  self.gridsLayer:addChild(node)
  self.iconIndex = self.iconIndex + 1
  self.iconInfoList[self.iconIndex] = {
    node = node,
    rect = rect,
    data = data,
    selected = {
      Blue = selectedBlueImage,
      Yellow = selectedYellowImage,
      Red = selectedRedImage
    }
  }
  self.grids:placeRect(rect)
  return true
end

function PlayerInfoPanel:rect2centerPos(rect)
  local pos = ccp(rect:getMidX() * (self.gridWidth + self.gap) - 0.5 * self.gap, rect:getMidY() * (self.gridHeight + self.gap) - 0.5 * self.gap)
  return pos
end

function PlayerInfoPanel:addHeroIcon(hero, pos)
  local size = CCSizeMake(3, 3)
  local width = size.width * (self.gridWidth + self.gap) - self.gap
  local height = size.height * (self.gridHeight + self.gap) - self.gap
  local node = CCNode:create()
  node:setContentSize(CCSizeMake(width, height))
  node:setAnchorPoint(ccp(0.5, 0.5))
  local icon = ed.readhero.createIconByHero(hero, {
    state = "idle",
    length = size.width * self.gridWidth - 3
  }).icon
  node:addChild(icon)
  icon:setPosition(ccp(width / 2, height / 2))
  local result = self:placeIcon(node, size, {type = "hero", hero = hero}, pos)
  return result
end

function PlayerInfoPanel:addMedalIcon(medalId, pos)
  local size = CCSizeMake(2, 2)
  local width = size.width * (self.gridWidth + self.gap) - self.gap
  local height = size.height * (self.gridHeight + self.gap) - self.gap
  local node = CCNode:create()
  node:setContentSize(CCSizeMake(width, height))
  node:setAnchorPoint(ccp(0.5, 0.5))
  local path = ed.lookupDataTable("Medal", "Picture", tonumber(medalId))
  local icon = ed.createSprite(path)
  local iconSize = icon:getContentSize()
  if iconSize.width > iconSize.height then
    icon:setScale(width / icon:getContentSize().width)
  else
    icon:setScale(height / icon:getContentSize().height)
  end
  node:addChild(icon)
  icon:setPosition(ccp(width / 2, height / 2))
  local result = self:placeIcon(node, size, {type = "medal", medalId = medalId}, pos)
  return result
end

function PlayerInfoPanel:addAvatarIcon(headId, frameId, pos)
  local size = CCSizeMake(3, 3)
  local width = size.width * (self.gridWidth + self.gap) - self.gap
  local height = size.height * (self.gridHeight + self.gap) - self.gap
  local node = CCNode:create()
  node:setContentSize(CCSizeMake(width, height))
  node:setAnchorPoint(ccp(0.5, 0.5))
  local head = ed.getHeadIcon({
    id = headId,
    length = size.width * self.gridWidth - 25
  })
  head:setPosition(ccp(width / 2, height / 2))
  node:addChild(head)
  local frame, frameicon, framefca = ed.getHeadFrame({
    id = frameId,
    sp_delay = false,
    hide_icon_when_dyna = true
  })
  frame:setScale((width + 5) / frameicon:getContentSize().width)
  frame:setPosition(ccp(width / 2, height / 2))
  node:addChild(frame)
  local result = self:placeIcon(node, size, {
    type = "avatar",
    headId = headId,
    frameId = frameId
  }, pos)
  return result
end

function PlayerInfoPanel:addCustomPhoto(photoId, frameId, pos)
  local size = CCSizeMake(3, 3)
  local width = size.width * (self.gridWidth + self.gap) - self.gap
  local height = size.height * (self.gridHeight + self.gap) - self.gap
  local node = CCNode:create()
  node:setContentSize(CCSizeMake(width, height))
  node:setAnchorPoint(ccp(0.5, 0.5))
  local head = ed.getHeadIcon({
    id = 1,
    length = size.width * self.gridWidth - 25
  })
  head:setPosition(ccp(width / 2, height / 2))
  node:addChild(head)
  
  local function callback(path)
    if self.mainLayer then
      head:removeFromParentAndCleanup(true)
      local head = ed.getHeadIcon({
        res = path,
        length = size.width * self.gridWidth - 25,
        not_fca = true
      })
      head:setPosition(ccp(width / 2, height / 2))
      node:addChild(head)
    end
  end
  
  ed.UploadImage:getImage(photoId, true, callback)
  local frame, frameicon, _ = ed.getHeadFrame({id = frameId})
  frame:setScale(width / frameicon:getContentSize().width)
  frame:setPosition(ccp(width / 2, height / 2))
  node:addChild(frame, 1)
  local result = self:placeIcon(node, size, {
    type = "photo",
    photoId = photoId,
    frameId = frameId
  }, pos)
  return result
end

function PlayerInfoPanel:addAchievementIcon(achievementId, pos)
  local size = CCSizeMake(1, 1)
  local width = size.width * (self.gridWidth + self.gap) - self.gap
  local height = size.height * (self.gridHeight + self.gap) - self.gap
  local node = CCNode:create()
  node:setContentSize(CCSizeMake(width, height))
  node:setAnchorPoint(ccp(0.5, 0.5))
  local path = ed.lookupDataTable("AchievementPixel", "Picture", tonumber(achievementId))
  local icon = ed.createSprite(path)
  local iconSize = icon:getContentSize()
  if iconSize.width > iconSize.height then
    icon:setScale(width / icon:getContentSize().width)
  else
    icon:setScale(height / icon:getContentSize().height)
  end
  node:addChild(icon)
  icon:setPosition(ccp(width / 2, height / 2))
  local result = self:placeIcon(node, size, {
    type = "achievement",
    achievementId = achievementId
  }, pos)
  return result
end

function PlayerInfoPanel:moveToRect(index, rect)
  local oldRect = self.iconInfoList[index].rect
  self.grids:clearRect(oldRect)
  self.grids:placeRect(rect)
  oldRect.origin.x = rect.origin.x
  oldRect.origin.y = rect.origin.y
end

function PlayerInfoPanel:resetToRect(index)
  local info = self.iconInfoList[index]
  info.node:setPosition(self:rect2centerPos(info.rect))
end

function PlayerInfoPanel:removeIcon(index)
  local info = self.iconInfoList[index]
  self.grids:clearRect(info.rect)
  info.node:removeFromParentAndCleanup(true)
  self.iconInfoList[index] = nil
  self.deleteBuffer[#self.deleteBuffer + 1] = info
  self.ui.image_undo_disable:setVisible(false)
end

function PlayerInfoPanel:initWallItems()
  for i, item in pairs(self.honorWallItems) do
    if item._type == "hero_summary" then
      local hero = ed.HeroCreate()
      hero:setup(item._hero_summary)
      self:addHeroIcon(hero, ccp(item._x, item._y))
    elseif item._type == "medal" then
      self:addMedalIcon(item._id, ccp(item._x, item._y))
    elseif item._type == "avatar" then
      self:addAvatarIcon(ed.analyzeAvatar(item._id).avatar, ed.analyzeAvatar(item._id).avatarFrame, ccp(item._x, item._y))
    elseif item._type == "pixel" then
      self:addAchievementIcon(item._id, ccp(item._x, item._y))
    elseif item._type == "photo" then
      self:addCustomPhoto(item._photo._photo, item._photo._frame_id, ccp(item._x, item._y))
    end
  end
end

function PlayerInfoPanel:undo()
  local size = #self.deleteBuffer
  if 0 < size then
    local info = self.deleteBuffer[size]
    local data = info.data
    if data.type == "hero" then
      self:addHeroIcon(data.hero, ccp(info.rect.origin.x, info.rect.origin.y))
    elseif data.type == "avatar" then
      self:addAvatarIcon(data.headId, data.frameId, ccp(info.rect.origin.x, info.rect.origin.y))
    elseif data.type == "medal" then
      self:addMedalIcon(data.medalId, ccp(info.rect.origin.x, info.rect.origin.y))
    elseif data.type == "achievement" then
      self:addAchievementIcon(data.achievementId, ccp(info.rect.origin.x, info.rect.origin.y))
    elseif data.type == "photo" then
      self:addCustomPhoto(data.photoId, data.frameId, ccp(info.rect.origin.x, info.rect.origin.y))
    end
    self.deleteBuffer[size] = nil
    size = size - 1
    self.ui.image_undo_disable:setVisible(size == 0)
  end
end

function PlayerInfoPanel:createGiveBtn(status)
  if self.giveBtn or ed.player:getLevel() < 10 or 10 > self.userSummary._level then
    return
  end
  self.ui.btn_chat:setPositionX(self.ui.btn_chat:getPositionX() - 80)
  self.ui.btn_report:setPositionX(self.ui.btn_report:getPositionX() - 80)
  self.ui.btn_friend:setPositionX(self.ui.btn_friend:getPositionX() - 80)
  self.ui.btn_undo:setPositionX(self.ui.btn_undo:getPositionX() - 80)
  self.ui.btn_delete_friend:setPositionX(self.ui.btn_delete_friend:getPositionX() - 80)
  self.ui.btn_black:setPositionX(self.ui.btn_black:getPositionX() - 80)
  self.ui.btn_gm:setPositionX(self.ui.btn_gm:getPositionX() - 80)
  self.ui.btn_honor:setPositionX(self.ui.btn_honor:getPositionX() - 180)
  self.ui.btn_edit:setPositionX(self.ui.btn_edit:getPositionX() - 180)
  self.ui.btn_save:setPositionX(self.ui.btn_save:getPositionX() - 180)
  self.ui.btn_undo:setPositionX(self.ui.btn_undo:getPositionX() - 180)
  local res = status and "UI/alpha/1080P/dragonboat/db_race/db_gift_icon.png" or "UI/alpha/1080P/allstar/allstar_rank/giveaway_button.png"
  local btn = ed.createSpriteTools({
    res = res,
    pos = ccp(520, status and -19 or -13),
    parent = self.ui.image_bg
  })
  self:btRegisterButtonClick({
    button = btn,
    key = "giveaway",
    clickHandler = function()
      if status then
        if status == "dragon_boat_can_give" then
          ed.UITool.openView("activityAllStarGiveFlower", {
            roleId = self.roleId,
            dragonBoatStatus = status
          })
        elseif status == "dragon_boat_level_not_enough" then
          ed.showToast(T("70\231\186\167\228\187\165\228\184\138\230\137\141\229\143\175\232\181\160\233\128\129"))
        elseif status == "dragon_boat_give_num_not_enough" then
          ed.showToast(T("\232\181\160\228\186\136\232\135\170\229\183\177\230\149\176\233\135\143\228\184\141\232\182\179400"))
        elseif status == "dragon_boat_item_not_enough" then
          ed.showToast(T("\233\129\147\229\133\183\228\184\141\232\182\179"))
        elseif status == "dragon_boat_oppo_server_down" then
          ed.showToast(T("\230\154\130\228\184\141\229\143\175\232\181\160\233\128\129\239\188\140\229\175\185\230\150\185\230\156\141\229\138\161\229\153\168\230\173\163\229\156\168\231\187\180\230\138\164\228\184\173"))
        end
      elseif ed.player:getLevel() >= 70 or self.isSelf then
        ed.UITool.openView("activityAllStarGiveFlower", {
          roleId = self.roleId
        })
      else
        ed.showToast(T("70\231\186\167\228\187\165\228\184\138\230\137\141\229\143\175\232\181\160\233\128\129~"))
      end
    end,
    pressScale = 0.95
  })
  if status then
    ed.createLabelTools({
      txt = T("\232\181\160 \233\128\129"),
      size = 17,
      pos = ccp(60.25, 27.25),
      color = ccc3(ed.colorToStr("#fffce7")),
      parent = btn,
      stroke = {
        ccc3(146, 46, 0),
        1
      }
    })
  else
    ed.createLabelTools({
      txt = T("\232\181\160 \233\128\129"),
      size = 17,
      pos = ccp(66.25, 24.25),
      color = ccc3(ed.colorToStr("#fffce7")),
      parent = btn
    })
  end
  self.giveBtn = btn
end
