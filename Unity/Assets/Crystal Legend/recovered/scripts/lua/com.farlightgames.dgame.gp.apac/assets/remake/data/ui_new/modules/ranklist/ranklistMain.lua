local base = ed.ranklistpop
local ranklist = {}
setmetatable(ranklist, {__index = base})
ed.ui.ranklistpop = ranklist
ed.UITool.registViewOpenFunc("ranklist", function(param)
  param = param or {}
  ed.pushScene(ed.ui.ranklistpop.create({
    index = param.index or 0,
    index2 = param.index2 or 1
  }))
end)

function ranklist.create(param)
  local self = base.create("ranklistpop")
  setmetatable(self, {__index = ranklist})
  ed.enableFcaAutoRelease(false)
  self.param = param
  ed.ranklistData.rankData = {}
  self.accOpacitys = {}
  self:initView()
  self:setBackground("UI/alpha/1080P/bg/rank_bg.jpg")
  self:setBackButton(function()
    ed.asyncload.unregistLoadingListener()
    ed.registerNetReply("query_pvp_oppo", function(data)
    end)
    ed.playEffect(ed.sound.common.back)
  end)
  self:removeOnExitHandler("ranklistscene_exit")
  self:registerOnExitHandler("ranklistscene_exit", function()
    ed.enableFcaAutoRelease(true)
  end)
  return self
end

function ranklist:initView()
  self:createUiShow()
  self:addEventBtRegister()
  self:autoWinUiSize()
  self.draglist = self:createDragList()
  self.accordionlist = self:createAccList(self.param.index, self.param.index2)
  self:createListenEvent()
end

function ranklist:clickOut(isPas, data)
  data = data.config or {}
  if isPas and data and data.mode then
    self.newMode = data.mode
    local data = self:getDragListData(data.mode)
    if data and type(data) == "table" then
      local mydata = self.listData:getModeListMyData(self.newMode)
      self:upDataDragList({myData = mydata, list = data}, self.createItemUi(self.newMode))
    else
      self.upMode = self.newMode
      ed.rank_network:sendLadderRank(self.newMode, self:getRankModeParam(self.newMode))
    end
    if self.newMode ~= "collect_point_local" then
      self.listData:setModeListDataNil("collect_point_local")
    end
    if self.newMode ~= "collection_point_global" then
      self.listData:setModeListDataNil("collection_point_global")
    end
  end
end

function ranklist:allClickOut(isLeaf, isPas, data)
end
