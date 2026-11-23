local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.hadesHeatRank = class
local RANK_TO_BG = {
  [1] = "UI/alpha/1080P/hades/hades_rank_bg1.png",
  [2] = "UI/alpha/1080P/hades/hades_rank_bg3.png",
  [3] = "UI/alpha/1080P/hades/hades_rank_bg4.png"
}
class.RANK_TO_BG = RANK_TO_BG
local RANK_RES = {
  [1] = "UI/alpha/1080P/toparena/rank/rank_1st.png",
  [2] = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
  [3] = "UI/alpha/1080P/toparena/rank/rank_3rd.png"
}
class.RANK_RES = RANK_RES
ed.UITool.registViewOpenFunc("hadesHeatRank", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("hadesHeatRank")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.groupId = param.groupId or 1
  self.rankDataList = {}
  self.selfRank = {}
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  ed.hadesHeatNet.sendRankboard(self.groupId)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.hades_rank_win)
  self.ui = ui
  self.container:addChild(container)
  self:initTableView()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.rankDataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(728.5, 84)
    end,
    createCell = function(index)
      local rankData = self.rankDataList[index]
      local itemContainer, ui = self:createHeatRankItem(index, rankData)
      return itemContainer, {rankData = rankData, ui = ui}
    end,
    doClickIn = function(cell, x, y)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {9, 0},
    noshade = true,
    doMove = self:tableViewDoMove()
  }
  self.tableView = Tableview.create(param)
end

function class:tableViewDoMove()
  local function handler()
    local x, y = self.tableView:getListPos()
    
    local listHeight = self.tableView.dragList.listHeight or 0
    if y > listHeight - 40 and listHeight > self.ui.list_layer:getContentSize().height - 40 then
      self.ui.my_rank_bg:setVisible(false)
    else
      local rank = self.selfRank and self.selfRank._rank
      if not rank then
        self.ui.my_rank_bg:setVisible(false)
        return
      else
        self.ui.my_rank_bg:setVisible(true)
      end
    end
  end
  
  return handler
end

function class:refreshView()
  self.ui.image_empty_tips:setVisible(#self.rankDataList <= 0)
  self:refreshMyRank()
  self.tableView:reloadData()
end

function class:createHeatRankItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.hades_rank_item)
  container:setContentSize(CCSizeMake(728.5, 84))
  ui.image_bg:setPosition(364.25, 42)
  local userSummary = data._user_summary
  local heatValue = data._heat_value
  local rank = data._rank
  local bgPath = class.RANK_TO_BG[rank]
  ed.setLabelStroke(ui.label_1, ed.toccc3(4659467), 1)
  ed.setLabelStroke(ui.label_2, ed.toccc3(2233605), 1)
  if bgPath then
    ed.setTexture(ui.image_bg, bgPath)
  end
  local rankRes = class.RANK_RES[rank]
  if rankRes then
    ui.label_rank:setVisible(false)
    ui.image_rank:setVisible(true)
    ed.setTexture(ui.image_rank, rankRes, true)
  else
    ui.label_rank:setVisible(true)
    ui.image_rank:setVisible(false)
    ui.label_rank:setFontName(ed.fontBold)
    ed.setLabelString(ui.label_rank, rank or T("\230\156\170\228\184\138\230\166\156"))
    ed.setLabelStroke(ui.label_rank, ed.toccc3(1312532), 1.5)
  end
  local head = ed.getWholeHeadIcon({
    id = userSummary._avatar,
    level = userSummary._level,
    lvoffset = {x = -47, y = -38}
  })
  head:setScale(0.9)
  ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(userSummary._name, userSummary._medal, {
    anchorPoint = ui.label_player_name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "image_bg", "label_player_name", name)
  ed.setLabelStroke(ui.label_guild_name, ed.toccc3(2233605), 1)
  ed.setLabelString(ui.label_guild_name, userSummary._guild_name or "")
  ed.setLabelStroke(ui.label_heat, ed.toccc3(8003852), 1)
  ed.setLabelString(ui.label_heat, heatValue)
  local passTime = data._pass_time
  local hour = math.floor(passTime / 3600)
  local min = math.floor(passTime % 3600 / 60)
  local seconds = math.floor(passTime % 60)
  ed.setLabelStroke(ui.label_time, ed.toccc3(2233605), 1)
  ed.setLabelString(ui.label_time, string.format("%.2d:%.2d:%.2d", hour, min, seconds))
  return container, ui
end

function class:refreshMyRank()
  if not self.selfRank then
    self.ui.my_rank_bg:setVisible(false)
    return
  end
  local userSummary = self.selfRank._user_summary
  local heatValue = self.selfRank._heat_value
  local rank = self.selfRank._rank
  ed.setLabelStroke(self.ui.label_1, ed.toccc3(4659467), 1)
  ed.setLabelStroke(self.ui.label_2, ed.toccc3(2233605), 1)
  local rankRes = class.RANK_RES[rank]
  if rankRes then
    self.ui.label_3:setVisible(false)
    self.ui.image_rank:setVisible(true)
    ed.setTexture(self.ui.image_rank, rankRes, true)
  else
    self.ui.label_3:setVisible(true)
    self.ui.image_rank:setVisible(false)
    self.ui.label_rank:setFontName(ed.fontBold)
    ed.setLabelString(self.ui.label_rank, rank or T("\230\156\170\228\184\138\230\166\156"))
    ed.setLabelStroke(self.ui.label_rank, ed.toccc3(1312532), 1.5)
  end
  local head = ed.getWholeHeadIcon({
    id = userSummary._avatar,
    level = userSummary._level,
    lvoffset = {x = -47, y = -38}
  })
  head:setScale(0.9)
  self.ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(userSummary._name, userSummary._medal, {left = true})
  ed.UITool.replaceUI(self.ui, "image_my_rank", "label_player_name", name)
  ed.setLabelStroke(self.ui.label_guild_name, ed.toccc3(2233605), 1)
  ed.setLabelString(self.ui.label_guild_name, userSummary._guild_name or "")
  ed.setLabelStroke(self.ui.label_heat, ed.toccc3(8003852), 1)
  ed.setLabelString(self.ui.label_heat, heatValue)
  local passTime = self.selfRank._pass_time
  local hour = math.floor(passTime / 3600)
  local min = math.floor(passTime % 3600 / 60)
  local seconds = math.floor(passTime % 60)
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(2233605), 1)
  ed.setLabelString(self.ui.label_time, string.format("%.2d:%.2d:%.2d", hour, min, seconds))
end

function class:addTouchEvent()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        if ed.containsPoint(self.ui.layer_click_area, x, y) then
          self.clickInList = true
        else
          self.clickInList = false
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.layer_click_area, x, y) and not self.clickInList then
        self:close()
        return false
      end
      return false
    end,
    key = "close"
  })
  ed.UITool.registerBtn(self, "btn_close", function()
    self:close()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("HeatRankboard", function(data)
    local rankList = data._rank_list
    local selfRank = data._self_rank
    self.rankDataList = rankList or {}
    self.selfRank = selfRank
    self:refreshView()
  end)
end

function class:close()
  self:destroy()
end
