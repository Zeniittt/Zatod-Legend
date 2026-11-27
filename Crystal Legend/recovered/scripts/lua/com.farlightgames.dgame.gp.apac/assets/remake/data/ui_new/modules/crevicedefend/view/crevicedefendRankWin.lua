local base = ed.ui.popwindow
local CreviceDefendRankWin = newclass(base.mt)
ed.ui.CreviceDefendRankWin = CreviceDefendRankWin
local RANK_RANGE_TO_RES = {
  [1] = {
    rankImage = "UI/alpha/1080P/toparena/rank/rank_1st.png",
    bg = "UI/alpha/1080P/crevicedefend/list1.png"
  },
  [2] = {
    rankImage = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
    bg = "UI/alpha/1080P/crevicedefend/list2.png"
  },
  [3] = {
    rankImage = "UI/alpha/1080P/toparena/rank/rank_3rd.png",
    bg = "UI/alpha/1080P/crevicedefend/list3.png"
  },
  [4] = {
    bg = "UI/alpha/1080P/crevicedefend/listnormal.png"
  }
}
CreviceDefendRankWin.RANK_RANGE_TO_RES = RANK_RANGE_TO_RES
ed.UITool.registViewOpenFunc("OpenCreviceDefendRankWin", function(data)
  ed.ui.CreviceDefendRankWin.create(data)
end)

function CreviceDefendRankWin.create(data)
  local self = base.create("CreviceDefendRankWin")
  setmetatable(self, CreviceDefendRankWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function CreviceDefendRankWin:initData(data)
  self.zone_id = data._zone_id
  self.rank_list = data._rank_list or {}
  self.myRank = data._self_rank
end

function CreviceDefendRankWin:registerTouchHandlers()
end

function CreviceDefendRankWin:registerEvents()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function CreviceDefendRankWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRankWin)
  self.ui = ui
  self.container:addChild(container)
  self:setSelfRankItem(self.myRank)
  local title_node = ed.ui.gradientLabel.create({
    text = T("\230\136\141\229\141\171\230\142\146\232\161\140\230\166\156"),
    fontSize = 25,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16767652),
    endColor = ed.toccc3(16751190),
    strokeSize = 1,
    strokeColor = ed.toccc3(1901829)
  })
  self.ui.layer_title:addChild(title_node.node)
  ed.setLabelColor(self.ui.label_title_des, ccc3(255, 188, 116))
  local zoneId = ed.CreviceDefendManager:getZoneId()
  local title_des = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142,\230\160\185\230\141\174\233\152\159\233\149\191\229\156\168\232\181\155\229\140\186\229\134\133\230\142\146\232\161\140\229\143\145\230\148\190\229\165\150\229\138\177 (\229\189\147\229\137\141\231\172\172%s\232\181\155\229\140\186) ")
  ed.setString(self.ui.label_title_des, string.format(title_des, zoneId))
  self.ui.label_empty:setString(T("\230\154\130\230\151\160\228\184\138\230\166\156"))
  self.ui.img_empty:setVisible(#self.rank_list == 0)
  self:createRankList()
end

function CreviceDefendRankWin:createRankList()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.rank_list
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(656, 85)
    end,
    createCell = function(index)
      return self:createRankItem(index, self.rank_list[index])
    end,
    syncCell = function(cell, index)
      local container, ui = self:createRankItem(index, self.rank_list[index])
      return container
    end,
    doPressIn = function(cell, x, y)
      local ui = cell.data
      if ui and ed.containsPoint(ui.root_icon, x, y) then
        ui.root_icon:setScale(0.7)
      end
    end,
    doClickIn = function(cell, x, y)
      local ui = cell.data
      if ui and ed.containsPoint(ui.root_icon, x, y) then
        local RoleId = self.rank_list[cell.idx]._user_info._user_summary._role_id
        ed.UITool.openView("playerInfoPanel", RoleId)
      end
    end,
    cancelPressIn = function(cell, x, y)
      local ui = cell.data
      if ui then
        ui.root_icon:setScale(0.8)
      end
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    offset = {343, 42},
    touchpriority = -300,
    noshade = true
  }
  self.recordTableview = Tableview.create(param)
  self.recordTableview:reloadData()
end

function CreviceDefendRankWin:createRankItem(index, rankdata)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRankItem)
  ui.idx = index
  container:setContentSize(ui.bg:getContentSize())
  local cur_rank = rankdata._rank
  local _user_info = rankdata._user_info
  local damage = _user_info._damage
  local summary = _user_info._user_summary
  local server_name = rankdata._server_name
  ed.setLabelColor(ui.label_damage, ccc3(255, 240, 142))
  ed.setLabelStroke(ui.label_damage, ed.toccc3(3087902), 1)
  local title_node = ed.ui.gradientLabel.create({
    text = ed.formatDamage(damage),
    fontSize = 23,
    startColor = ed.toccc3(16775135),
    endColor = ed.toccc3(16774069),
    strokeSize = 1,
    strokeColor = ed.toccc3(7747872)
  })
  local width = title_node:getContentSize().width
  ui.layer_damage_value:addChild(title_node.node)
  title_node.node:setPositionX(width / 2)
  ui.root_icon:removeAllChildrenWithCleanup(true)
  local uiConfig = RANK_RANGE_TO_RES[cur_rank]
  if cur_rank <= 3 then
    ed.setTexture(ui.image_rank, uiConfig.rankImage, true)
    ed.setTexture(ui.bg, uiConfig.bg)
    ui.label_rank:setVisible(false)
    ui.image_rank:setVisible(true)
  else
    ui.label_rank:setVisible(true)
    ui.image_rank:setVisible(false)
    ed.setTexture(ui.bg, RANK_RANGE_TO_RES[4].bg)
    local scoreTxt = ed.ui.gradientLabel.create({
      text = cur_rank,
      fontSize = 40,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16774621),
      endColor = ed.toccc3(16774586),
      strokeSize = 1.5,
      strokeColor = ed.toccc3(7747872)
    })
    ui.label_rank:addChild(scoreTxt.node)
    ed.layout.centerInParent(scoreTxt.node)
  end
  local headId = ed.analyzeAvatar(summary._avatar).avatar
  local headFrameId = ed.analyzeAvatar(summary._avatar).avatarFrame
  local head = ed.getHeadIcon({id = headId})
  local frame, frameicon, framefca = ed.getHeadFrame({
    id = headFrameId,
    sp_delay = false,
    hide_icon_when_dyna = true
  })
  ui.root_icon:addChild(head, 1)
  ui.root_icon:addChild(frame, 2)
  ed.layout.centerInParent(head)
  ed.layout.centerInParent(frame)
  ui.root_icon:setScale(0.8)
  local label_player_name, _, innerText = ed.getPlayerName(summary._name, summary._medal, {left = true})
  if innerText.spriteNode.medalIcon then
    innerText.node:setPositionX(15)
  else
    innerText.node:setPositionX(0)
  end
  ed.UITool.replaceUI(ui, "bg", "label_name", label_player_name)
  ed.setLabelString(ui.label_guild, server_name or " ")
  ed.setLabelColor(ui.label_guild, ed.toccc3(16700269))
  ed.setLabelStroke(ui.label_guild, ed.toccc3(2233605), 1)
  ed.setLabelColor(innerText, ed.toccc3(16776423))
  ed.setLabelStroke(innerText, ed.toccc3(2233605), 1)
  return container, ui
end

function CreviceDefendRankWin:setSelfRankItem(rankdata)
  if rankdata == nil then
    self.ui.self_bg:setVisible(false)
    return
  end
  local cur_rank = rankdata._rank
  local _user_info = rankdata._user_info
  local damage = _user_info._damage
  local summary = _user_info._user_summary
  local server_name = rankdata._server_name
  ed.setLabelColor(self.ui.label_damage, ccc3(255, 240, 142))
  ed.setLabelStroke(self.ui.label_damage, ed.toccc3(3087902), 1)
  local title_node = ed.ui.gradientLabel.create({
    text = ed.formatDamage(damage),
    fontSize = 23,
    startColor = ed.toccc3(16775135),
    endColor = ed.toccc3(16774069),
    strokeSize = 1,
    strokeColor = ed.toccc3(7747872)
  })
  local width = title_node:getContentSize().width
  self.ui.layer_damage_value:addChild(title_node.node)
  title_node.node:setPositionX(width / 2)
  self.ui.root_icon:removeAllChildrenWithCleanup(true)
  local uiConfig = RANK_RANGE_TO_RES[cur_rank]
  if cur_rank <= 3 then
    ed.setTexture(self.ui.image_rank, uiConfig.rankImage, true)
    self.ui.label_rank:setVisible(false)
    self.ui.image_rank:setVisible(true)
  else
    self.ui.label_rank:setVisible(true)
    self.ui.image_rank:setVisible(false)
    local scoreTxt = ed.ui.gradientLabel.create({
      text = cur_rank,
      fontSize = 40,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16774621),
      endColor = ed.toccc3(16774586),
      strokeSize = 1.5,
      strokeColor = ed.toccc3(7747872)
    })
    self.ui.label_rank:addChild(scoreTxt.node)
    ed.layout.centerInParent(scoreTxt.node)
  end
  local headId = ed.analyzeAvatar(summary._avatar).avatar
  local headFrameId = ed.analyzeAvatar(summary._avatar).avatarFrame
  local head = ed.getHeadIcon({id = headId})
  local frame, frameicon, framefca = ed.getHeadFrame({
    id = headFrameId,
    sp_delay = false,
    hide_icon_when_dyna = true
  })
  self.ui.root_icon:addChild(head, 1)
  self.ui.root_icon:addChild(frame, 2)
  ed.layout.centerInParent(head)
  ed.layout.centerInParent(frame)
  self.ui.root_icon:setScale(0.8)
  local label_player_name, _, innerText = ed.getPlayerName(summary._name, summary._medal, {left = true})
  if innerText.spriteNode.medalIcon then
    innerText.node:setPositionX(15)
  else
    innerText.node:setPositionX(0)
  end
  ed.UITool.replaceUI(self.ui, "self_bg", "label_name", label_player_name)
  ed.setLabelString(self.ui.label_guild, server_name or " ")
  ed.setLabelColor(self.ui.label_guild, ed.toccc3(16700269))
  ed.setLabelStroke(self.ui.label_guild, ed.toccc3(2233605), 1)
  ed.setLabelColor(innerText, ed.toccc3(16776423))
  ed.setLabelStroke(innerText, ed.toccc3(2233605), 1)
end
