local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueRoomDetailWindow = class
class.ROOM_TYPE_TO_DESC = {
  normal_battle = T("\228\184\128\228\186\155\229\174\158\229\138\155\229\185\179\229\186\184\231\154\132\230\149\140\228\186\186\230\138\138\229\174\136\231\157\128\230\173\164\229\164\132"),
  elite_battle = T("\228\184\128\228\186\155\229\174\158\229\138\155\229\188\186\229\164\167\231\154\132\230\149\140\228\186\186\230\138\138\229\174\136\231\157\128\230\173\164\229\164\132\239\188\140\232\175\183\232\176\168\230\133\142\233\128\154\232\191\135"),
  ex_elite_battle = T("\228\184\128\228\186\155\229\174\158\229\138\155\229\188\186\229\164\167\231\154\132\230\149\140\228\186\186\230\138\138\229\174\136\231\157\128\230\173\164\229\164\132\239\188\140\232\175\183\232\176\168\230\133\142\233\128\154\232\191\135"),
  boss_battle = T("\229\135\134\229\164\135\229\165\189\239\188\140\232\191\142\230\142\165\230\156\128\231\187\136\230\140\145\230\136\152\239\188\129"),
  airdrop = T("\233\128\154\232\191\135\230\173\164\229\164\132\239\188\140\229\143\175\229\143\172\229\148\164\228\184\128\229\144\141\232\139\177\233\155\132\229\138\160\229\133\165\228\189\160\231\154\132\229\134\146\233\153\169\233\152\159\228\188\141"),
  event = T("\233\128\154\232\191\135\230\173\164\229\164\132\239\188\140\228\188\188\228\185\142\228\188\154\233\129\173\233\129\135\231\165\158\231\167\152\228\186\139\228\187\182"),
  buy_shop = T("\228\184\128\228\189\141\231\165\158\231\167\152\229\149\134\228\186\186\233\154\144\229\177\133\228\186\142\230\173\164\239\188\140\230\136\150\232\174\184\228\189\160\229\143\175\228\187\165\231\156\139\231\156\139\228\187\150\231\154\132\232\180\167\231\137\169"),
  enhance_shop = T("\228\184\128\228\189\141\231\165\158\231\167\152\229\149\134\228\186\186\233\154\144\229\177\133\228\186\142\230\173\164\239\188\140\230\136\150\232\174\184\228\189\160\229\143\175\228\187\165\231\156\139\231\156\139\228\187\150\231\154\132\232\180\167\231\137\169"),
  hot_spring = T("\233\128\154\232\191\135\230\173\164\229\164\132\239\188\140\229\143\175\229\155\158\229\164\141\232\161\128\233\135\143\230\136\150\232\128\133\232\131\189\233\135\143"),
  all_shop = T("\228\184\128\228\189\141\231\165\158\231\167\152\229\149\134\228\186\186\233\154\144\229\177\133\228\186\142\230\173\164\239\188\140\230\136\150\232\174\184\228\189\160\229\143\175\228\187\165\231\156\139\231\156\139\228\187\150\231\154\132\232\180\167\231\137\169")
}
ed.UITool.registViewOpenFunc("rogueRoomDetailWindow", function(param)
  ed.ui.rogueRoomDetailWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueRoomDetailWindow", {noShade = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.roomId = param.roomId
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueRoomDetailWindow)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelShadow(self.ui.label_change, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_go, ccc3(0, 0, 0), ccp(0, 2))
  self:refreshViewInfo(false)
end

function class:refreshViewInfo(isRefresh)
  local roomData = self.rogueLikeMgr:getRoomData(self.roomId)
  local roomType = roomData.type or "normal_battle"
  local roomWaveId = roomData.waveId
  local roomIconPathCfg = ed.rogueDefine.room_type_to_icon[roomType]
  ed.setLabelString(self.ui.label_tips, self.ROOM_TYPE_TO_DESC[roomType] or "")
  self.ui.image_room:removeAllChildrenWithCleanup(true)
  local roomIcon = ed.createSprite(roomIconPathCfg.choose)
  self.ui.image_room:addChild(roomIcon)
  ed.layout.centerInParent(roomIcon)
  if isRefresh then
    local resetEffect = ed.createFcaNode("eff_UI_rogue_reset")
    self:addFcaOnce(resetEffect)
    self.ui.image_room:addChild(resetEffect)
    local imgSize = self.ui.image_room:getContentSize()
    resetEffect:setPosition(imgSize.width * 0.5, imgSize.height * 0.5)
    resetEffect:update(0)
  end
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local chapterTableItem = ed.getDataTable("RogueChapter")[curChapter._chapter_id][curChapter._difficulty]
  local waveGroup = chapterTableItem["Wave Group"]
  local waveTableItem = ed.getDataTable("RogueChapterWave")[waveGroup][roomWaveId]
  if waveTableItem and not waveTableItem["Roll Forbidden"] then
    self.ui.panel_change:setVisible(true)
    local refreshTimes = curChapter._refresh_room_times or 0
    ed.setLabelString(self.ui.label_change_times, refreshTimes)
    ed.setLabelColor(self.ui.label_change_times, 0 == refreshTimes and ccc3(255, 91, 91) or ccc3(255, 227, 128))
    ed.setTexture(self.ui.btn_change, 0 == refreshTimes and "UI/alpha/1080P/common/button_mini_grey.png" or "UI/alpha/1080P/common/button_com_mini.png")
    ed.setLabelColor(self.ui.label_change, 0 == refreshTimes and ccc3(217, 217, 217) or ccc3(254, 241, 169))
  else
    self.ui.panel_change:setVisible(false)
  end
  ed.layout.horizontalSortNode({
    self.ui.panel_change,
    self.ui.btn_go
  }, {30, 0}, self.ui.image_bg:getContentSize().width * 0.5)
end

function class:onClickBtnGo()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local curRoundId = curChapter._cur_round_id
  ed.rogueLikeNet.sendEnterRoom(curRoundId, self.roomId)
  self:destroy({skipAnim = true})
end

function class:onClickBtnChange()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  if (curChapter._refresh_room_times or 0) <= 0 then
    return
  end
  local curRoundId = curChapter._cur_round_id
  ed.rogueLikeNet.sendRefreshRoom(curRoundId, self.roomId)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_go", function()
    self:onClickBtnGo()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_change", function()
    self:onClickBtnChange()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function class:addEventListener()
  self:listenEvent("rogueRefreshRoom", function(...)
    self:refreshViewInfo(true)
  end)
end
