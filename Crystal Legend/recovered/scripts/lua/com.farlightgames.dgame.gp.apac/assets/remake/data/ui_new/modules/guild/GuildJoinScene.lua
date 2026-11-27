local base = ed.ui.commonscene
local GuildJoinScene = newclass(base.mt)
ed.ui.GuildJoinScene = GuildJoinScene
local GuildJoinSceneScope = {}
local guildRecruit = {}
ed.ui.guildRecruit = guildRecruit

function GuildJoinScene:initData(data)
  self.mgr = ed.GuildManager
  self.tableIndex = 1
  self.avatar = self.mgr.avatar
  self.frame = self.mgr.frame
  self.name = self.mgr.name
end

function GuildJoinScene:doClickBack()
  self:removeUpdateHandler("setName")
  self:removeUpdateHandler("searchGuildId")
  CloseScope(GuildJoinSceneScope)
end

function GuildJoinScene:createItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.GuildItem)
  local size = ui.bg:getContentSize()
  ui.bg:setContentSize(CCSizeMake(size.width + self.fix, size.height))
  ui.bg:setPositionX(ui.bg:getPositionX() + self.fix / 2)
  ed.setLabelStroke(ui.name, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.num, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.slogan, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.cond, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.vitality, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.vitality_num, ed.toccc3(5586983), 1)
  ed.setLabelShadow(ui.label_apply, ed.toccc3(0), ccp(1, 0))
  ed.setLabelDimensions(ui.slogan, CCSizeMake(100, 0))
  ed.setString(ui.name, data.name)
  ed.setString(ui.num, string.format("%d/%d", data.memberCnt, self.mgr.maxMember))
  ed.setString(ui.slogan, data.slogan or " ")
  ed.setString(ui.cond, string.format(T("\231\173\137\231\186\167>%d\231\186\167"), data.joinLimit))
  ed.setString(ui.vitality_num, data.liveness)
  ed.setString(ui.label_apply, self.mgr.guildJoinType[data.joinType])
  local avatarData = ed.analyzeAvatar(data.avatar)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  local x, y = ui.icon:getPosition()
  ui.icon:setVisible(false)
  guildIcon:setPosition(ccp(x, y))
  ui.bg:addChild(guildIcon)
  if avatarData.avatarFrame and avatarData.avatarFrame ~= 1 then
    guildIcon:setScale(0.72)
  else
    guildIcon:setScale(0.82)
  end
  guildIcon:setPositionX(guildIcon:getPositionX() / self.rowWidth * self.curWidth)
  ui.name:setPositionX(ui.name:getPositionX() / self.rowWidth * self.curWidth)
  ui.num:setPositionX(ui.num:getPositionX() / self.rowWidth * self.curWidth)
  ui.slogan:setPositionX(ui.slogan:getPositionX() / self.rowWidth * self.curWidth)
  ui.cond:setPositionX(ui.cond:getPositionX() / self.rowWidth * self.curWidth)
  ui.vitality:setPositionX(ui.vitality:getPositionX() / self.rowWidth * self.curWidth)
  ui.vitality_num:setPositionX(ui.vitality_num:getPositionX() / self.rowWidth * self.curWidth)
  ui.btn_apply:setPositionX(ui.btn_apply:getPositionX() / self.rowWidth * self.curWidth)
  return container, ui
end

function GuildJoinScene:refreshDraglist()
  local uiList = {}
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  
  local function getPos(i)
    return ccp(335, 432.5 - 77 * i + self.fiy * 0.6)
  end
  
  for k, v in ipairs(self.mgr.guilds or {}) do
    local container, ui = self:createItem(v)
    ui.data = v
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.uiList = uiList
  self.draglist:initListHeight(77 * #self.mgr.guilds)
end

function GuildJoinScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      local btn = v.btn_apply
      
      if ed.checkVisible(btn) and ed.containsPoint(btn, x, y) then
        btn:setScale(0.95)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildJoinScene:doJoinClick(id)
  if nil == id then
    return
  end
  local guildleftdays = ed.player:getMonthCardLeftTimes(ed.parameter.guild_month_card)
  local cardInfo = ed.player:getMonthCardData(ed.parameter.guild_month_card)
  if cardInfo and 0 < guildleftdays and id ~= cardInfo._guild_id then
    local info = {
      text = T("\229\166\130\230\158\156\229\138\160\229\133\165\230\173\164\229\133\172\228\188\154\239\188\140\229\136\153\228\189\160\228\187\142%s\229\133\172\228\188\154\232\142\183\229\190\151\231\154\132%d\229\164\169\229\133\172\228\188\154\230\156\136\229\141\161\229\176\134\229\164\177\230\149\136\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", cardInfo._guild_name or "", guildleftdays),
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.GuildNetwork:sendJoinGuild(id)
      end
    }
    ed.showConfirmDialog(info)
  else
    ed.GuildNetwork:sendJoinGuild(id)
  end
end

function GuildJoinScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    self:doJoinClick(v.data.id)
  end
  
  return handler
end

function GuildJoinScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.btn_apply:setScale(1)
  end
  
  return handler
end

function GuildJoinScene:initLabels()
  ed.setLabelShadow(self.ui.label_btn1, ed.toccc3(5384722), ccp(1, 2))
  ed.setLabelShadow(self.ui.label_btn2, ed.toccc3(5384722), ccp(1, 2))
  ed.setLabelShadow(self.ui.label_btn3, ed.toccc3(5384722), ccp(1, 2))
  ed.setLabelShadow(self.ui.label_icon, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.name, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.Label_12442, ed.toccc3(0), ccp(1, 0))
  ed.setLabelStroke(self.ui.label_diamondnum, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.guildid, ed.toccc3(0), ccp(1, 0))
  ed.setLabelStroke(self.ui.name_3, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.member_3, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.slogan_3, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.cond_3, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.vitality_3, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.vitality_num_3, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.label_apply_3, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_find, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_changeIcon, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.Label_12371, ed.toccc3(0), ccp(1, 0))
  self.ui.Label_12441:setVisible(false)
  self.ui.Label_124434:setVisible(false)
end

function GuildJoinScene:initEditBox(parent)
  local size = parent:getContentSize()
  local layer = CCLayer:create()
  layer:setContentSize(size)
  layer:setClipRect(CCRectMake(0, 0, size.width - 10, size.height))
  parent:addChild(layer)
  local info = {
    config = {
      editSize = size,
      maxLength = 30,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    },
    bDealMessage = true
  }
  local edit_box = editBox:new(info)
  edit_box:setEnabled(true)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(10, 0))
  layer:addChild(edit_box.edit)
  return edit_box
end

function GuildJoinScene:initUI()
  self.container = self.scene
  self.ui = {}
  local readnode = ed.readnode.create(self.container, self.ui)
  readnode:addNode(ed.uieditor.GuildSearchScene)
  self:setBackground("UI/alpha/1080P/bg/guild_bg.png")
  self:setBackButton(function()
    self:doClickBack()
  end)
  self.ui.title:setVisible(false)
  local titleBG, _ = ed.UITool.createSceneTitle(T("\229\138\160\229\133\165\229\133\172\228\188\154"), self.ui.bg_title, {
    position = ccp(13, 16)
  })
  self:initLabels()
  self:adaptUI()
  if ed.player:getGuildId() == 0 then
    self.ui.btn_quit_guild:setVisible(false)
  end
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -131
  })
  self:refreshDraglist()
  self.ui.edit_box = ed.UITool.createEditBox(self.ui.bg_input, {
    placeHolder = T("\232\175\183\232\190\147\229\133\165\229\133\172\228\188\154\229\144\141:")
  }, true)
  self:refreshHeadIcon()
  self.ui.edit_box1 = ed.UITool.createEditBox(self.ui.bg_input1, {
    placeHolder = T("\232\175\183\232\190\147\229\133\165\229\133\172\228\188\154ID:")
  }, true)
  self.ui.edit_box:setVisible(false)
  self.ui.edit_box1:setVisible(false)
  self:refreshUI()
  local rootPos = ccp(ed.display.center.x, ed.display.center.y)
  local fca1 = ed.createFcaNode("eff_UI_guild_particle_main")
  fca1:setPosition(rootPos)
  self:addFca(fca1)
  self.mainLayer:addChild(fca1, -1)
  ed.right2(self.ui.btn_rule, titleBG, 0)
  ed.adaptLabel(self.ui.label_create_btn, {maxWidth = 105, minScale = 0.7})
  for i = 1, 4 do
    ed.adaptLabel(self.ui["label_btn" .. i], {maxWidth = 100, minScale = 0.7})
    ed.adaptLabel(self.ui["label_u_btn" .. i], {maxWidth = 100, minScale = 0.7})
  end
  ed.adaptLabel(self.ui.Label_437, {maxWidth = 85, minScale = 0.7})
  self.ui.Label_437:setHorizontalAlignment(kCCTextAlignmentCenter)
end

function GuildJoinScene:showRuleInfo()
  ed.ui.GuildRuleWin.create({}):popWindow(999)
end

function GuildJoinScene:refreshHeadIcon()
  local res = ed.getDataTable("GuildAvatar")[self.avatar].Picture
  local contioner = ed.createGuildAvatar(self.avatar, self.frame)
  local x, y = self.ui.icon_guild:getPosition()
  self.ui.icon_guild:setVisible(false)
  contioner:setPosition(ccp(x, y))
  self.ui.icon_guild = contioner
  self.ui.layer2:addChild(contioner)
end

function GuildJoinScene:refreshSearchGuild(data)
  local guildInfo = data._guilds
  if guildInfo == nil then
    ed.showToast(T("\230\178\161\230\156\137\230\159\165\230\137\190\229\136\176\229\133\172\228\188\154"))
    return
  end
  self.currentSearchId = guildInfo._id
  self.ui.search_item:setVisible(true)
  local avatarData = ed.analyzeAvatar(guildInfo._avatar)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  local x, y = self.ui.icon_3:getPosition()
  self.ui.icon_3:setVisible(false)
  guildIcon:setPosition(ccp(x, y))
  self.ui.icon_3 = guildIcon
  self.ui.search_item:addChild(guildIcon)
  ed.setLabelDimensions(self.ui.slogan_3, CCSizeMake(150, 0))
  ed.setString(self.ui.name_3, guildInfo._name)
  ed.setString(self.ui.member_3, string.format("%d/%d", guildInfo._member_cnt, self.mgr.maxMember))
  local slogan = guildInfo._slogan
  if guildInfo._recruit_item and guildInfo._recruit_item._recruit_declare then
    slogan = guildInfo._recruit_item._recruit_declare
  end
  if slogan and slogan ~= "" then
    ed.setString(self.ui.slogan_3, slogan)
  else
    self.ui.slogan_3:setVisible(false)
  end
  ed.setString(self.ui.cond_3, string.format(T("\231\173\137\231\186\167>%d\231\186\167"), guildInfo._join_limit))
  ed.setString(self.ui.vitality_num_3, guildInfo._liveness or 0)
  ed.setString(self.ui.label_apply_3, self.mgr.guildJoinType[guildInfo._join_type])
end

function GuildJoinScene:registerEvents()
  ListenEvent("GuildRefreshSearch", function(data)
    self:refreshSearchGuild(data)
  end, GuildJoinSceneScope)
end

function GuildJoinScene:onClickCreate()
  local name = self.name
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
  if ed.player._rmb < self.mgr.createGuildCost then
    ed.showHandyDialog("toRecharge")
    return
  end
  local sprite = CCSprite:create()
  local info = {
    text = T("\229\133\172\228\188\154\229\136\155\229\187\186\229\144\142\239\188\140\228\189\160\229\176\134\232\135\170\229\138\168\230\136\144\228\184\186\228\188\154\233\149\191\227\128\130\229\166\130\230\158\156\228\189\160\232\191\158\231\187\173\228\184\137\229\164\169\230\156\170\228\184\138\231\186\191\239\188\140\229\136\153\228\188\154\233\149\191\232\129\140\228\189\141\229\176\134\232\135\170\229\138\168\232\189\172\232\174\169\231\187\153\229\133\182\228\187\150\229\133\172\228\188\154\230\136\144\229\145\152\227\128\130\230\152\175\229\144\166\231\161\174\232\174\164\229\136\155\229\187\186\229\133\172\228\188\154\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      ed.GuildNetwork:sendCreateGuild(self.name, self.avatar, self.frame)
    end
  }
  ed.showConfirmDialog(info)
end

function GuildJoinScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:showRuleInfo()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn1", function()
    self.tableIndex = 1
    self.ui.edit_box:setVisible(false)
    self.ui.edit_box1:setVisible(false)
    self:refreshUI()
    if self.guildRecruit.dialog then
      self.guildRecruit.dialog:hide()
    end
  end)
  ed.UITool.registerBtn(self, "btn2", function()
    self.tableIndex = 2
    self.ui.edit_box:setVisible(true)
    self.ui.edit_box1:setVisible(false)
    self:refreshUI()
    if self.guildRecruit.dialog then
      self.guildRecruit.dialog:hide()
    end
  end)
  ed.UITool.registerBtn(self, "btn3", function()
    self.tableIndex = 3
    self.ui.edit_box:setVisible(false)
    self.ui.edit_box1:setVisible(true)
    self:refreshUI()
    if self.guildRecruit.dialog then
      self.guildRecruit.dialog:hide()
    end
  end)
  ed.UITool.registerBtn(self, "btn4", function()
    self.tableIndex = 4
    self.ui.edit_box:setVisible(false)
    self.ui.edit_box1:setVisible(false)
    self:refreshUI()
    self.guildRecruit:showGuide()
  end)
  ed.UITool.registerBtn(self, "btn_quit_guild", function()
    ed.GuildManager:onClickQuit()
  end)
  self:registerUpdateHandler("setName", function()
    if self.ui.layer2:isVisible() then
      local name = self.ui.edit_box:getString()
      if self.name ~= name then
        self.name = name
      end
    end
    if self.ui.layer3:isVisible() then
      local searchId = self.ui.edit_box1:getString()
      if self.searchId ~= searchId then
        self.searchId = searchId
      end
    end
  end)
  ed.UITool.registerBtn(self, "btn_change_icon", function()
    ed.ui.GuildChangeHeadWin.create({
      callback = function(id)
        self.avatar = id
        self:refreshHeadIcon()
      end
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_create", function()
    self:onClickCreate()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_search", function()
    local guildId = self.searchId
    if guildId == nil or guildId == "" then
      ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\229\133\172\228\188\154ID"))
      return
    end
    ed.GuildNetwork:sendSearchGuild(self.searchId)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_apply_3", function()
    self:doJoinClick(self.currentSearchId)
  end, {pressScale = 0.9})
end

function GuildJoinScene:refreshBtnUI()
  for i = 1, 4 do
    self.ui["choose_btn" .. i]:setVisible(i == self.tableIndex)
    self.ui["btn" .. i]:setVisible(i ~= self.tableIndex)
    self.ui["layer" .. i]:setVisible(i == self.tableIndex)
  end
  if ed.player:getGuildId() ~= 0 then
    self.ui.btn2:setVisible(false)
    self.ui.choose_btn2:setVisible(false)
    local x, y = self.ui.choose_btn2:getPosition()
    self.ui.choose_btn3:setPosition(ccp(x, y))
    self.ui.choose_btn4:setPosition(ccp(x, y - 63))
    local x, y = self.ui.btn2:getPosition()
    self.ui.btn3:setPosition(ccp(x, y))
    self.ui.btn4:setPosition(ccp(x, y - 63))
  end
  if not self.guildRecruitIsOpen then
    self.ui.choose_btn4:setVisible(false)
    self.ui.btn4:setVisible(false)
  end
end

function GuildJoinScene:refreshUI()
  self:refreshBtnUI()
end

function GuildJoinScene:adaptUI()
  local ui = self.ui
  local fix = ed.display.winSize.width - 960
  local fiy = ed.display.winSize.height - 540
  self.fix = fix
  self.fiy = fiy
  ui.bg_title:setPositionY(ui.bg_title:getPositionY() + fiy)
  ui.layer_btn:setPosition(ccp(ui.layer_btn:getPositionX(), ui.layer_btn:getPositionY() + fiy))
  local size = ui.bg_main:getContentSize()
  local curWidth = size.width + fix
  self.rowWidth = size.width
  self.curWidth = curWidth
  ui.bg_main:setPosition(ccp(ui.bg_main:getPositionX(), ui.bg_main:getPositionY() + fiy * 0.4))
  ui.bg_main:setContentSize(CCSizeMake(curWidth, size.height + 0.6 * fiy))
  ui.layer1:setPositionY(ui.layer1:getPositionY() + fiy * 0.6)
  ui.layer2:setPositionX(ui.layer2:getPositionX() + fix / 2)
  ui.layer2:setPositionY(ui.layer2:getPositionY() + fiy * 0.6)
  ui.layer3:setPositionX(ui.layer3:getPositionX() + fix / 2)
  ui.layer3:setPositionY(ui.layer3:getPositionY() + fiy * 0.6)
  ui.layer4:setPositionX(ui.layer4:getPositionX() + fix / 2)
  ui.layer4:setPositionY(ui.layer4:getPositionY() + fiy * 0.6)
  local size1 = ui.layer_item:getContentSize()
  ui.layer_item:setPositionY(ui.layer_item:getPositionY() - fiy * 0.6)
  ui.layer_item:setContentSize(CCSizeMake(size1.width + fix, size1.height + fiy * 0.6))
  ui.layer_bottom:setPositionY(ui.layer_bottom:getPositionY() - fiy * 0.4)
  ui.info:setPositionX(ui.info:getPositionX() / size.width * curWidth)
  ui.num:setPositionX(ui.num:getPositionX() / size.width * curWidth)
  ui.slogan:setPositionX(ui.slogan:getPositionX() / size.width * curWidth)
  ui.cond:setPositionX(ui.cond:getPositionX() / size.width * curWidth)
  ui.vitality:setPositionX(ui.vitality:getPositionX() / size.width * curWidth)
  ui.line1:setPositionX(ui.line1:getPositionX() / size.width * curWidth)
  ui.line2:setPositionX(ui.line2:getPositionX() / size.width * curWidth)
  ui.line3:setPositionX(ui.line3:getPositionX() / size.width * curWidth)
  ui.line4:setPositionX(ui.line4:getPositionX() / size.width * curWidth)
  local size2 = ui.search_item:getContentSize()
  ui.search_item:setContentSize(CCSizeMake(size2.width + fix, size2.height))
  ui.name_3:setPositionX(ui.name_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.member_3:setPositionX(ui.member_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.slogan_3:setPositionX(ui.slogan_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.cond_3:setPositionX(ui.cond_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.icon_3:setPositionX(ui.icon_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.vitality_3:setPositionX(ui.vitality_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.vitality_num_3:setPositionX(ui.vitality_num_3:getPositionX() / self.rowWidth * self.curWidth)
  ui.btn_apply_3:setPositionX(ui.btn_apply_3:getPositionX() / self.rowWidth * self.curWidth)
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 75, top = 18})
  local size = ui.ImageView_bj:getContentSize()
  local curWidth = size.width + fix
  ui.ImageView_bj:setContentSize(CCSizeMake(curWidth, size.height))
  local posx, posy = ui.recruitBtn:getPosition()
  ui.recruitBtn:setPosition(posx - fix / 2.2, posy - fiy / 2)
  posx, posy = ui.btn_cancel:getPosition()
  ui.btn_cancel:setPosition(posx + fix / 2.2, posy - fiy / 2)
  posx, posy = ui.btn_up:getPosition()
  ui.btn_up:setPosition(posx - fix / 10, posy - fiy / 2)
  posx, posy = ui.btn_down:getPosition()
  ui.btn_down:setPosition(posx + fix / 10, posy - fiy / 2)
  ui.ImageView_pages:setPositionY(ui.ImageView_pages:getPositionY() - fiy / 2)
  self.ui.choose_btn4:setVisible(false)
  self.ui.btn4:setVisible(false)
  local minScale = 1
  minScale = math.min(minScale, (ui.line1:getPositionX() - ui.info:getPositionX() - ui.line1:getContentSize().width * 0.5) / ui.info:getContentSize().width * 2)
  minScale = math.min(minScale, (ui.line2:getPositionX() - ui.num:getPositionX() - ui.line1:getContentSize().width * 0.5) / ui.num:getContentSize().width * 2)
  minScale = math.min(minScale, (ui.line3:getPositionX() - ui.slogan:getPositionX() - ui.line1:getContentSize().width * 0.5) / ui.slogan:getContentSize().width * 2)
  minScale = math.min(minScale, (ui.line4:getPositionX() - ui.cond:getPositionX() - ui.line1:getContentSize().width * 0.5) / ui.cond:getContentSize().width * 2)
  minScale = math.min(minScale, (ui.vitality:getPositionX() - ui.line4:getPositionX() - ui.line1:getContentSize().width * 0.5) / ui.vitality:getContentSize().width * 2)
  ui.info:setScale(minScale)
  ui.num:setScale(minScale)
  ui.slogan:setScale(minScale)
  ui.cond:setScale(minScale)
  ui.vitality:setScale(minScale)
end

function GuildJoinScene.create(data)
  local self = base.create("GuildJoinScene", {noBottomButton = true})
  setmetatable(self, GuildJoinScene.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchEvents()
  self:registerOnEnterHandler("onEnter", function()
    self:registerEvents()
    if ed.player:getName() == "" then
      local function cancleCallback()
        CloseScope(GuildJoinSceneScope)
        
        ed.popScene()
      end
      
      local bename = ed.ui.renameWindow.create({cancleCallback = cancleCallback})
      bename:popWindow()
    end
  end)
  self:registerOnExitHandler("onExit", function()
    CloseScope(GuildJoinSceneScope)
  end)
  self.guildRecruit = setmetatable({}, {__index = guildRecruit})
  self.guildRecruit.create(self, self.guildRecruit)
  if ed.GuildManager.openGuildRecruit then
    function self.guildRecruit.openGuildRecruit()
      self.tableIndex = 4
      
      self.ui.edit_box:setVisible(false)
      self.ui.edit_box1:setVisible(false)
      self:refreshUI()
      self.guildRecruit:showGuide()
    end
    
    ed.GuildManager.openGuildRecruit = nil
  end
  return self
end

function guildRecruit.create(mainSelf, self)
  self.mainSelf = mainSelf
  self.ui = mainSelf.ui
  self.newPageNum = 1
  self.start = 1
  self.isManage = ed.player:getGuildJob() ~= "member" and ed.player:getGuildId() > 0
  ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  mainSelf:listenEvent("GuildRecruitReply", function(type)
    if type == "OpenPanel" then
      mainSelf.guildRecruitIsOpen = true
      self.ui.btn4:setVisible(true)
      self:refreshList()
      self:registerTouchEvents()
      local redInfo = ed.GuildManager:getShowRecruitRed()
      self.ui.red_btn4:setVisible(redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed)
      self.ui.red_choose_btn4:setVisible(redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed)
      self.ui.recruitBtnRed:setVisible(redInfo.subRed)
      if self.openGuildRecruit then
        self.openGuildRecruit()
        self.openGuildRecruit = nil
      else
        self:showGuide()
      end
    elseif type == "Entry" then
      ed.showToast(T("\231\153\187\232\174\176\230\136\144\229\138\159\239\188\129"))
      self.newPageNum = 1
      self.start = 1
      ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
    elseif type == "Quit" then
      ed.showToast(T("\229\183\178\229\143\150\230\182\136\231\153\187\232\174\176\239\188\129"))
      self.newPageNum = 1
      self.start = 1
      ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
    elseif type == "Sub" then
      ed.showToast(T("\229\188\128\229\144\175\230\136\144\229\138\159\239\188\129"))
      self.newPageNum = 1
      self.start = 1
      ed.GuildManager:notify(1)
      ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
    elseif type == "notify" then
      local redInfo = ed.GuildManager:getShowRecruitRed()
      self.ui.red_btn4:setVisible(redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed)
      self.ui.red_choose_btn4:setVisible(redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed)
      self.ui.recruitBtnRed:setVisible(redInfo.subRed)
    end
  end)
end

function guildRecruit:refreshList()
  self.ui.Panel_443:removeAllChildrenWithCleanup(true)
  self.newPageNum = self.newPageNum <= 0 and 1 or self.newPageNum
  local newPage = (self.newPageNum - 1) * 6 + 1
  local data = ed.GuildManager.guildRecruit
  self.isSub = data.has_sub
  local addWid = self.mainSelf.fix / 2
  local posx, posy = 162 - addWid / 2, 220
  self.newItem = {}
  local roles = data.members or {}
  for i = newPage, newPage + 5 do
    if roles[i] then
      local item = self:createItem(roles[i], i)
      item.lay:setPosition(ccp(posx, posy))
      self.ui.Panel_443:addChild(item.lay)
      for _, v in pairs(item) do
        v:setOpacity(0)
        v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03 * (i - (newPage - 1))), CCFadeIn:create(0.1)))
      end
      if i % 2 == 0 then
        posx = 162 - addWid / 2
        posy = posy - 87
      else
        posx = posx * 3 + addWid * 2
      end
    end
  end
  self.maxPages = math.ceil(data.total_member / 6)
  self.newPageNum = self.newPageNum > self.maxPages and self.maxPages or self.newPageNum
  self.ui.label_page_left:setString(self.newPageNum)
  self.ui.label_page_right:setString("/" .. self.maxPages)
  self.ui.btn_cancel_str:setString(data.has_entry and T("\229\143\150\230\182\136\231\153\187\232\174\176") or T("\231\153\187\232\174\176\228\191\161\230\129\175"))
  ed.adaptLabel(self.ui.btn_cancel_str, {maxWidth = 90, minScale = 0.7})
  self.ui.btn_cancel_str:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.recruitImg_off:setVisible(not data.has_sub)
  self.isManage = ed.player:getGuildJob() ~= "member" and 0 < ed.player:getGuildId()
  self.ui.recruitBtn:setVisible(self.isManage)
end

function guildRecruit:registerTouchEvents()
  if self.isRegister then
    return
  else
    self.isRegister = true
  end
  ed.UITool.registerBtn(self.mainSelf, "btn_up", function()
    local newPage = self.newPageNum
    newPage = ed.clamp(newPage - 1, 1, self.maxPages)
    if newPage ~= self.newPageNum then
      self.newPageNum = newPage
      if newPage % 10 == 1 then
        self.start = 1 >= self.start and 1 or self.start - 1
        ed.GuildRecruitNetwork:sendGuildRecruitQuery(self.start, "down")
        self:refreshList()
      else
        self:refreshList()
      end
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.mainSelf, "btn_down", function()
    local newPage = self.newPageNum
    newPage = ed.clamp(newPage + 1, 1, self.maxPages)
    if newPage ~= self.newPageNum then
      self.newPageNum = newPage
      if newPage % 10 == 0 then
        self.start = self.start + 1
        ed.GuildRecruitNetwork:sendGuildRecruitQuery(self.start, "up")
        self:refreshList()
      else
        self:refreshList()
      end
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.mainSelf, "btn_cancel", function()
    local data = ed.GuildManager.guildRecruit
    local autoText = T("\231\153\187\232\174\176\229\144\142\239\188\140<lable color=ccc3(191,20,37)>\229\156\168\230\139\155\228\186\186\231\154\132\229\133\172\228\188\154 </lable>\229\143\175\230\159\165\231\156\139\229\136\176\228\189\160\231\154\132\228\191\161\230\129\175<br/> <br/>(\229\189\147\229\137\141\229\133\172\228\188\154\231\154\132\228\188\154\233\149\191\228\184\142\233\149\191\232\128\129\228\184\141\228\188\154\231\156\139\229\136\176\228\189\160\231\154\132\228\191\161\230\129\175\229\147\166)")
    local text = data.has_entry and T("\230\152\175\229\144\166\229\143\150\230\182\136\231\153\187\232\174\176") or autoText
    ed.showConfirmDialog({
      autoText = text,
      color = ccc3(97, 88, 83),
      rightHandler = function()
        local data = ed.GuildManager.guildRecruit
        if data.has_entry then
          ed.GuildRecruitNetwork:sendGuildRecruitQuit()
        else
          ed.GuildRecruitNetwork:sendGuildRecruitEntry()
        end
      end
    }).ui.label_title:setString(T("\231\153\187\232\174\176\228\191\161\230\129\175"))
    local entryUidKey = ed.getRoleKey("entryRedGuildRecruit")
    ed.storage.setValue(entryUidKey, true)
    self:showGuide()
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Guild)
    FireEvent("GuildRecruitReply", "notify")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self.mainSelf, "recruitBtn", function()
    ed.UITool.openView("guildEnlistSubscribePop")
    local subUidKey = ed.getRoleKey("subRedGuildRecruit")
    ed.storage.setValue(subUidKey, true)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Guild)
    self:showGuide()
    FireEvent("GuildRecruitReply", "notify")
  end, {pressScale = 1.1, normalScale = 1.2})
  self.ui.Panel_shield:setVisible(false)
  ed.UITool.registerBtn(self.mainSelf, "ImageView_shield", function()
    ed.UITool.openView("GuildEnlistShieldPop")
  end, {pressScale = 1.1, normalScale = 1.2})
end

function guildRecruit:createItem(data, index)
  local addWid = self.mainSelf.fix / 2
  local summary = data.user_summary
  local isSelf = summary._role_id == ed.getRoleId()
  local nodes = {}
  local lay = ed.createScale9Sprite("UI/alpha/1080P/crusade/bg_replay_item.png", CCRectMake(5, 5, 543, 77))
  if isSelf then
    local selflay = ed.createScale9Sprite("UI/alpha/1080P/mail/mail_butt_1.png", CCRectMake(10, 10, 260, 61))
    selflay:setContentSize(CCSizeMake(320 + addWid + 12, 96))
    selflay:setPosition((320 + addWid) / 2, 42)
    lay:addChild(selflay)
  end
  lay:setContentSize(CCSizeMake(320 + addWid, 84))
  nodes.lay = lay
  local head = ed.getTeamHead({
    id = summary._avatar
  })
  head:setScale(0.7)
  head:setPosition(44, 41)
  lay:addChild(head)
  nodes.head = head
  head:setCascadeOpacityEnabled(true)
  local nameBg = ed.createSprite("UI/alpha/1080P/pvp/ce_bg.png")
  nameBg:setPosition(ccp(172, 59))
  lay:addChild(nameBg)
  nodes.nameBg = nameBg
  local addText = ""
  if isSelf then
    addText = T("<lable color=ccc3(84,139,54) >(\230\136\145)</lable>")
  elseif data.is_online and data.is_online == 1 then
    addText = T("<lable color=ccc3(84,139,54) >(\229\156\168\231\186\191)</lable>")
  end
  if (not self.isManage or not self.isSub) and not isSelf then
    summary._name = T("\229\144\141\229\173\151\229\183\178\233\154\144\232\151\143")
    summary._medal = nil
  end
  local name, _, autoText = ed.getPlayerName(summary._name or "nil", summary._medal, {left = true, addText = addText})
  name:setPosition(10, 10)
  name:setScale(0.8)
  nameBg:addChild(name)
  nodes.autoText = autoText.node
  local posY = 0
  if self.isManage and summary._guild_name then
    local label = ed.createttf(T("\229\133\172\228\188\154\239\188\154%s", summary._guild_name), 13)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setColor(ccc3(ed.colorToStr("#433b38")))
    label:setPosition(82, 36)
    lay:addChild(label)
    nodes.guild_name = label
    posY = -6
  end
  local label1 = ed.createttf((self.isManage and self.isSub or isSelf) and T("\228\184\131\230\151\165\230\180\187\232\183\131\239\188\154") or T("\228\187\133\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\229\143\175\230\159\165\231\156\139\227\128\129\233\130\128\232\175\183"), 13)
  label1:setColor(ccc3(ed.colorToStr("#433b38")))
  label1:setAnchorPoint(ccp(0, 0.5))
  label1:setPosition(78, 23 + posY)
  lay:addChild(label1)
  nodes.liveness_left = label1
  ed.adaptLabel(label1, {maxWidth = 240, minScale = 0.7})
  if self.isManage and self.isSub or isSelf then
    local label = ed.createttf(data.liveness, 13)
    ed.setLabelStroke(label, ed.toccc3(5586983), 1)
    label:setColor(ccc3(147, 255, 126))
    label:setAnchorPoint(ccp(0, 0.5))
    ed.right2(label, label1, 5)
    lay:addChild(label)
    nodes.liveness = label
    if summary._level and 0 < summary._level then
      local lvBg = ed.createSprite("UI/alpha/1080P/ranking/lv_bg.png")
      lvBg:setPosition(35, 2)
      head:addChild(lvBg)
      lvBg:setScale(1.1)
      local levelLabel = ed.createLabelTTF(summary._level or 0, 16)
      ed.setLabelStroke(levelLabel, ccc3(43, 28, 8), 1)
      ed.setLabelColor(levelLabel, ccc3(251, 224, 116))
      levelLabel:setPosition(35, 2)
      head:addChild(levelLabel)
    end
  end
  self.mainSelf:btRemoveMainTouchHandler({
    key = "guild_recruit_manage_" .. index
  })
  self.mainSelf:btRemoveMainTouchHandler({
    key = "guild_recruit_head_" .. index
  })
  self.mainSelf:btRemoveMainTouchHandler({
    key = "guild_recruit_lay_" .. index
  })
  if self.isManage and not isSelf and ed.GuildManager.guildRecruit.has_sub then
    local btn = ed.createSprite("UI/alpha/1080P/common/button_com_big.png")
    btn:setPosition(ccp(270 + addWid * 0.9, 38))
    btn:setScale(0.7)
    lay:addChild(btn)
    nodes.btn = btn
    btn:setCascadeOpacityEnabled(true)
    local label = ed.createttf(T("\232\129\148\231\179\187"), 24)
    ed.setLabelShadow(label, ccc3(88, 54, 25), ccp(0, 4))
    label:setColor(ccc3(ed.colorToStr("#FDF1A6")))
    label:setPosition(64, 25)
    btn:addChild(label)
    self.mainSelf:btRegisterButtonClick({
      button = btn,
      key = "guild_recruit_manage_" .. index,
      clickHandler = function()
        local params = {
          uid = summary._uid,
          summary = summary,
          roleId = summary._role_id
        }
        if ed.chatManager.chatPopWin.chatMainWin then
          FireEvent("chat_private_target", params)
        else
          FireEvent("chat_private_target", params)
          ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.personal_channel)
        end
        self.mainSelf:listenTimer(Timer:Once(0.3), function()
          if ed.getPopWindow("chatMainWin") then
            ed.getPopWindow("chatMainWin"):setEditBoxString(T("\229\147\136\229\150\189\239\188\140\230\136\145\229\156\168\230\139\155\229\139\159\229\164\167\229\142\133\233\135\140\231\156\139\229\136\176\228\186\134\228\189\160\231\154\132\228\191\161\230\129\175\239\188\140\230\157\165\230\136\145\228\187\172\229\133\172\228\188\154\228\184\128\232\181\183\231\142\169\229\149\138!\230\136\145\228\187\172\229\133\172\228\188\154id\230\152\175%d", ed.player:getGuildId()))
          end
        end)
      end,
      force = true,
      mcpMode = true,
      pressScale = 0.65,
      normalScale = 0.7,
      clickInterval = 0.5,
      priority = -999
    })
    self.mainSelf:btRegisterButtonClick({
      button = lay,
      key = "guild_recruit_lay_" .. index,
      clickHandler = function()
        ed.registerNetReply("req_home_page", function(datas)
          local panel = ed.ui.PlayerInfoPanel.create(datas, false)
          panel:popWindow()
        end)
        ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
      end,
      force = true,
      mcpMode = true
    })
  elseif not isSelf then
    if not ed.GuildManager.guildRecruit.has_sub and self.isManage then
      nodes.liveness_left:setString(T("\229\188\128\229\144\175\230\139\155\229\139\159\230\156\141\229\138\161\229\144\142\229\143\175\230\159\165\231\156\139"))
      ed.adaptLabel(nodes.liveness_left, {maxWidth = 240, minScale = 0.7})
    end
    self.mainSelf:btRegisterButtonClick({
      button = lay,
      key = "guild_recruit_lay_" .. index,
      clickHandler = function()
        if not ed.GuildManager.guildRecruit.has_sub and self.isManage then
          ed.showToast(T("\229\188\128\229\144\175\230\139\155\229\139\159\230\156\141\229\138\161\229\144\142\229\143\175\230\159\165\231\156\139"))
        else
          ed.showToast(T("\228\187\133\228\188\154\233\149\191\227\128\129\233\149\191\232\128\129\229\143\175\230\159\165\231\156\139"))
        end
      end,
      force = true,
      mcpMode = true
    })
  end
  return nodes
end

function guildRecruit:showGuide()
  if self.dialog then
    self.dialog:hide()
  end
  if not self.clickGuide then
    self.clickGuide = CCLayer:create()
    local aperture = ed.createSprite("UI/alpha/1080P/guide/tutorial_circle_big.png")
    self.clickGuide:addChild(aperture)
    aperture:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCScaleTo:create(0.65, 1.35), CCScaleTo:create(0.65, 1))))
    local hand = ed.createSprite("UI/alpha/1080P/guide/tutorial_finger.png")
    hand:setPosition(30, -39)
    self.clickGuide:addChild(hand)
    hand:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.65, ccp(-10, 10)), CCMoveBy:create(0.65, ccp(10, -10)))))
  end
  self.clickGuide:setVisible(false)
  local openUidKey = ed.getRoleKey("GuildRecruitOpenGuide")
  if not self.mainSelf.ui.layer4:isVisible() and not ed.storage.getBool(openUidKey) then
    if not self.mainSelf.guildRecruitIsOpen then
      return
    end
    if not self.guideDialogueContainer then
      local guideDialogueContainer, ui = ed.editorui(ed.uieditor.guideDialogue)
      self.mainSelf.container:addChild(guideDialogueContainer, 10)
      ui.dialog_bg:setScaleX(-1)
      ui.dialog_text:setScaleX(-1)
      guideDialogueContainer:setPosition(ccpAdd(ccp(self.mainSelf.ui.btn4:getPosition()), ccp(240, -100)))
      self.guideDialogueContainer = guideDialogueContainer
      ui.dialog_text:setString(T(" \229\134\146\233\153\169\232\128\133,\230\139\155\229\139\159\229\164\167\229\142\133\229\138\159\232\131\189\n \229\183\178\229\188\128\229\144\175\229\149\166~"))
      ui.dialog_text:setPosition(230, 50)
    end
    self.mainSelf.ui.layer_btn:addChild(self.clickGuide)
    self.clickGuide:setPosition(self.mainSelf.ui.btn4:getPosition())
    self.clickGuide:setVisible(true)
    return
  else
    if self.guideDialogueContainer then
      self.guideDialogueContainer:removeFromParentAndCleanup(true)
      self.guideDialogueContainer = nil
    end
    ed.storage.setValue(openUidKey, true)
    self.mainSelf.ui.layer4:addChild(self.clickGuide, 99)
  end
  local redInfo = ed.GuildManager:getShowRecruitRed()
  if redInfo.entryRed and self.mainSelf.ui.layer4:isVisible() then
    self.dialog = ed.guide.dialog.create(self.mainSelf.container)
    self.dialog:show(11)
    self.dialog:setContent(T("  \229\166\130\230\158\156\230\130\168\230\131\179\230\141\162\229\133\172\228\188\154\n  \229\143\175\228\187\165\229\156\168\232\191\153\233\135\140\231\153\187\232\174\176\229\147\166~"))
    self.clickGuide:setPosition(self.mainSelf.ui.btn_cancel:getPosition())
    self.clickGuide:setVisible(true)
  elseif redInfo.guideSubRed and self.mainSelf.ui.layer4:isVisible() then
    self.dialog = ed.guide.dialog.create(self.mainSelf.container)
    local playAnim = self.dialog.playAnim
    
    function self.dialog.playAnim(this, pos, len)
      pos.x = pos.x - 210 - self.mainSelf.fix / 2
      playAnim(this, pos, len)
    end
    
    self.dialog:show(11)
    self.dialog.ui.dialog_text:setDimensions(CCSizeMake(250, 70))
    self.dialog.ui.dialog_text:setPosition(10, 64)
    self.dialog:setContent(T("  \228\188\154\233\149\191/\233\149\191\232\128\129\229\164\167\228\186\186,\n  \229\188\128\229\144\175\230\139\155\229\139\159\230\156\141\229\138\161\229\144\142,\229\176\177\229\143\175\228\187\165\n  \230\139\155\229\139\159\229\164\167\229\142\133\228\184\173\231\154\132\229\134\146\233\153\169\232\128\133\229\149\166"))
    self.clickGuide:setPosition(self.mainSelf.ui.recruitBtn:getPosition())
    self.clickGuide:setVisible(true)
  end
end
