local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonChapterInfo = class
ed.UITool.registViewOpenFunc("awakeDungeonChapterInfo", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("awakeDungeonChapterInfo")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.chapterId = param.chapterId
  ed.AwakeDungeonNetwork.sendChapterRecord(self.chapterId)
  self:initView()
  self:refreshView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonChapterInfo)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.chapter_name, ed.toccc3(5914124), 1.5)
  self.ui.chapter_name:setFontName(ed.fontBold)
  self.ui.none_first_record:setFontName(ed.fontBold)
  self.ui.image_left_line:setPositionX(self.ui.chapter_name:getPositionX() - self.ui.chapter_name:getContentSize().width * 0.5 - 14 - self.ui.image_left_line:getContentSize().width * 0.5)
  self.ui.image_right_line:setPositionX(self.ui.chapter_name:getPositionX() + self.ui.chapter_name:getContentSize().width * 0.5 + 14 + self.ui.image_right_line:getContentSize().width * 0.5)
  ed.setLabelStroke(self.ui.label_normal_box_current, ed.toccc3(1907208), 1)
  ed.setLabelStroke(self.ui.label_normal_box_target, ed.toccc3(1907208), 1)
  ed.setLabelStroke(self.ui.label_special_box_current, ed.toccc3(1907208), 1)
  ed.setLabelStroke(self.ui.label_special_box_target, ed.toccc3(1907208), 1)
  ed.setLabelStroke(self.ui.label_search_progress_target, ed.toccc3(1907208), 1)
  ed.setLabelStroke(self.ui.label_enter, ed.toccc3(9458959), 1)
  ed.setLabelShadow(self.ui.label_enter, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_disable, ed.toccc3(0), 1)
  ed.setLabelShadow(self.ui.label_disable, ccc3(0, 0, 0), ccp(0, 2))
end

function class:refreshView()
  self:refreshBasic()
  self:refreshChapterBox()
  self:refreshChapterReward()
  self:refreshUnlock()
end

function class:refreshBasic()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local chapterTableItem = ed.getDataTable("DungeonChapter")[dungeonMgr:getChapterGroup()][self.chapterId]
  if nil == chapterTableItem then
    return
  end
  ed.setLabelString(self.ui.chapter_name, chapterTableItem["Chapter Name"])
  ed.setTexture(self.ui.image_chapter_bg, string.format("UI/alpha/1080P/dungeon/chapterinfo/chapter%d_bg.png", self.chapterId))
  local desPanelSize = self.ui.panel_des:getContentSize()
  local desLabel = ed.ui.autoText.new()
  desLabel:initParam({
    context = chapterTableItem.Description,
    fontSize = 15,
    color = ed.toccc3(16710632),
    lineSpacing = 4,
    maxWidth = desPanelSize.width,
    isTripLastSpacing = true
  })
  self.ui.panel_des:addChild(desLabel.node)
  desLabel.node:setPosition(0, desPanelSize.height - desLabel:getFirstLineHeight() * 0.5)
end

function class:refreshChapterBox()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local chapterTableItem = ed.getDataTable("DungeonChapter")[dungeonMgr:getChapterGroup()][self.chapterId]
  if nil == chapterTableItem then
    return
  end
  local totalSmallRewardNum = 0
  local doneSmallRewardNum = 0
  local totalBigRewardNum = 0
  local doneBigRewardNum = 0
  local buildingData = dungeonMgr:getMapBuildingConfig(chapterTableItem.Map)
  if nil ~= buildingData then
    local rewardTable = ed.getDataTable("DungeonTreasureReward")
    for k, v in ipairs(buildingData.tiles) do
      if v.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_REWARD then
        local rewardTableItem = rewardTable[v.id]
        if rewardTableItem["Treasure Type"] == "Small" then
          totalSmallRewardNum = totalSmallRewardNum + 1
          if dungeonMgr:isChapterStageDone(self.chapterId, v.x, v.y) then
            doneSmallRewardNum = doneSmallRewardNum + 1
          end
        elseif rewardTableItem["Treasure Type"] == "Big" then
          totalBigRewardNum = totalBigRewardNum + 1
          if dungeonMgr:isChapterStageDone(self.chapterId, v.x, v.y) then
            doneBigRewardNum = doneBigRewardNum + 1
          end
        end
      end
    end
  end
  ed.setLabelString(self.ui.label_normal_box_current, doneSmallRewardNum)
  ed.setLabelString(self.ui.label_normal_box_target, "/" .. totalSmallRewardNum)
  local normalBarSize = self.ui.panel_normal_box_progress_bar:getContentSize()
  self.ui.panel_normal_box_progress_bar:setClipRect(CCRectMake(0, 0, normalBarSize.width * doneSmallRewardNum / totalSmallRewardNum, normalBarSize.height))
  ed.setLabelString(self.ui.label_special_box_current, doneBigRewardNum)
  ed.setLabelString(self.ui.label_special_box_target, "/" .. totalBigRewardNum)
  local specialBarSize = self.ui.panel_special_box_progress_bar:getContentSize()
  self.ui.panel_special_box_progress_bar:setClipRect(CCRectMake(0, 0, specialBarSize.width * doneBigRewardNum / totalBigRewardNum, specialBarSize.height))
  ed.layout.horizontalSortNode({
    self.ui.label_normal_box_current,
    self.ui.label_normal_box_target
  }, {0}, self.ui.panel_normal_box_progress_bar:getContentSize().width * 0.5 + 5)
  ed.layout.horizontalSortNode({
    self.ui.label_special_box_current,
    self.ui.label_special_box_target
  }, {0}, self.ui.panel_special_box_progress_bar:getContentSize().width * 0.5 + 5)
  if 0 == doneSmallRewardNum then
    ed.setLabelColor(self.ui.label_normal_box_current, ed.toccc3(16775665))
  else
    ed.setLabelColor(self.ui.label_normal_box_current, ed.toccc3(16758579))
  end
  if 0 == doneBigRewardNum then
    ed.setLabelColor(self.ui.label_special_box_current, ed.toccc3(16775665))
  else
    ed.setLabelColor(self.ui.label_special_box_current, ed.toccc3(16758579))
  end
  if totalSmallRewardNum == doneSmallRewardNum then
    ed.setLabelColor(self.ui.label_normal_box_target, ed.toccc3(16758579))
  else
    ed.setLabelColor(self.ui.label_normal_box_target, ed.toccc3(16775665))
  end
  if totalBigRewardNum == doneBigRewardNum then
    ed.setLabelColor(self.ui.label_special_box_target, ed.toccc3(16758579))
  else
    ed.setLabelColor(self.ui.label_special_box_target, ed.toccc3(16775665))
  end
end

function class:refreshChapterReward()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local chapterTableItem = ed.getDataTable("DungeonChapter")[dungeonMgr:getChapterGroup()][self.chapterId]
  if nil == chapterTableItem then
    return
  end
  local progressVal = dungeonMgr:getChapterProgress(self.chapterId)
  ed.setLabelString(self.ui.label_search_progress_target, string.format("%d%%", progressVal))
  local searchBarSize = self.ui.panel_search_progress_bar:getContentSize()
  self.ui.panel_search_progress_bar:setClipRect(CCRectMake(0, 0, searchBarSize.width * progressVal / 100, searchBarSize.height))
  if progressVal < 100 then
    if nil ~= self.boxModel then
      self.boxModel:removeFromParentAndCleanup(true)
      self.boxModel = nil
    end
    self.ui.image_chapter_reward_box:setVisible(true)
    ed.setTexture(self.ui.image_chapter_reward_box, "UI/alpha/1080P/dungeon/chapterinfo/reward_doing.png")
  elseif dungeonMgr:isChapterRewardComplete(self.chapterId) then
    if nil ~= self.boxModel then
      self.boxModel:removeFromParentAndCleanup(true)
      self.boxModel = nil
    end
    self.ui.image_chapter_reward_box:setVisible(true)
    ed.setTexture(self.ui.image_chapter_reward_box, "UI/alpha/1080P/dungeon/chapterinfo/reward_finished.png")
  else
    self.ui.image_chapter_reward_box:setVisible(false)
    if nil == self.boxModel then
      self.boxModel = ed.createFcaNode("eff_UI_Dungeon_box")
      self:addFca(self.boxModel)
      self.ui.image_chapter_reward_box:getParent():addChild(self.boxModel)
      self.boxModel:setPosition(self.ui.image_chapter_reward_box:getPosition())
      self.boxModel:setLoopAction("Start")
    end
  end
end

function class:refreshUnlock(...)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local isUnlock = dungeonMgr:isChapterUnlock(self.chapterId)
  self.ui.btn_enter:setVisible(isUnlock)
  self.ui.btn_disable:setVisible(not isUnlock)
end

function class:refreshChapterRecord(data)
  local isExistRecord = nil ~= data
  self.ui.none_first_record:setVisible(not isExistRecord)
  self.ui.label_first_des:setVisible(isExistRecord)
  self.ui.panel_first_head:setVisible(isExistRecord)
  self.ui.label_first_guild:setVisible(isExistRecord)
  self.ui.panel_first_name:setVisible(isExistRecord)
  self.ui.image_first_time_bg:setVisible(isExistRecord)
  if not isExistRecord then
    return
  end
  local user_summary = data._user_summary
  local param = {
    id = user_summary._avatar,
    scale = 0.8
  }
  local headRoot, headIcon = ed.getWholeHeadIcon(param)
  self.ui.panel_first_head:addChild(headRoot)
  ed.layout.centerInParent(headRoot)
  self:btRemoveMainTouchHandler({
    key = "first_record_player"
  })
  self:btRegisterButtonClick({
    button = headIcon,
    key = "first_record_player",
    param = user_summary._role_id,
    pressHandler = function(...)
      headRoot:setScale(0.95)
    end,
    cancelPressHandler = function(...)
      headRoot:setScale(1)
    end,
    clickHandler = function(param, x, y)
      ed.UITool.openView("playerInfoPanel", param)
    end
  })
  local name = ed.getPlayerName(user_summary._name, user_summary._medal, {
    anchorPoint = ccp(0, 0.5),
    medalScale = 0.13,
    fontSize = 14
  })
  self.ui.panel_first_name:removeAllChildrenWithCleanup(true)
  self.ui.panel_first_name:addChild(name)
  name:setPosition(ccp(2, 12))
  ed.setLabelString(self.ui.label_first_guild, user_summary._guild_name or "")
  local y, m, d, h, min, s = ed.time2YMDHMS(ed.time2Server(data._time))
  ed.setLabelString(self.ui.label_first_time_val, string.format("%s-%s-%s  %s:%s:%s" .. ed.getUTCLabel(), y, m, d, h, min, s))
end

function class:onClickRewardEvent(...)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local progressVal = dungeonMgr:getChapterProgress(self.chapterId)
  if progressVal < 100 then
    return
  end
  if dungeonMgr:isChapterRewardComplete(self.chapterId) then
    return
  end
  if nil == self.delaySendTimer and nil ~= self.boxModel then
    self.boxModel:setAction("Opening")
    self.delaySendTimer = self:listenTimer(Timer:Once(0.5), function()
      self.delaySendTimer = nil
      ed.AwakeDungeonNetwork.sendChapterReward(self.chapterId)
    end)
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({skipAnim = false})
  end, {
    normalScale = 0.8,
    pressScale = 0.76,
    clickInterval = 0.2
  })
  ed.UITool.registerBtn(self, "image_chapter_reward_bg", function()
    self:onClickRewardEvent()
  end, {
    clickInterval = 0.2,
    pressHandler = function(param, x, y)
      local dungeonMgr = ed.awakeDungeonMgr.getInstance()
      local progressVal = dungeonMgr:getChapterProgress(self.chapterId)
      if 100 <= progressVal then
        return
      end
      if nil == self.rewardTipBg then
        self.rewardTipBg = ed.createSprite("UI/alpha/1080P/dungeon/chapterinfo/reward_tips.png")
        self.ui.image_progress_bg:addChild(self.rewardTipBg)
        local posX, posY = self.ui.image_chapter_reward_bg:getPosition()
        self.rewardTipBg:setPosition(posX, posY + 70)
        local chapterTableItem = ed.getDataTable("DungeonChapter")[dungeonMgr:getChapterGroup()][self.chapterId]
        local rewardIcon, rewardLabel = ed.createItemIcon({
          id = chapterTableItem["Reward ID 1"],
          type = chapterTableItem["Reward Type 1"],
          amount = chapterTableItem["Reward Amount 1"]
        }, {size = 14})
        local bgSize = self.rewardTipBg:getContentSize()
        rewardLabel:setScale(math.min(80 / rewardLabel:getContentSize().width / rewardIcon:getScaleX(), 1 / rewardIcon:getScaleX()))
        rewardLabel:setPositionY(rewardLabel:getPositionY() - 2.5)
        local iconHeight = rewardIcon:getContentSize().height * rewardIcon:getScaleX()
        rewardIcon:setPosition(bgSize.width * 0.5, bgSize.height * 0.5 + 10)
        self.rewardTipBg:addChild(rewardIcon)
      else
        self.rewardTipBg:setVisible(true)
      end
      self.ui.image_chapter_reward_box:setScale(0.95)
    end,
    cancelPressHandler = function()
      if self.rewardTipBg then
        self.rewardTipBg:setVisible(false)
      end
      self.ui.image_chapter_reward_box:setScale(1)
    end
  })
  ed.UITool.registerBtn(self, "btn_enter", function()
    ed.AwakeDungeonNetwork.sendEnterChapter(self.chapterId)
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "btn_disable", function()
    ed.showToast(T("\229\176\154\230\156\170\232\167\163\233\148\129"))
  end, {pressScale = 0.98, clickInterval = 0.2})
end

function class:addEventListener()
  self:listenEvent("awakeDungeonChapterRecord", function(data)
    self:refreshChapterRecord(data)
  end)
  self:listenEvent("awakeDungeonEnterChapter", function()
    self:destroy({skipAnim = true})
    ed.pushScene(ed.ui.awakeDungeonGridMapScene.create(self.chapterId))
  end)
  self:listenEvent("awakeDungeonChapterRewardComplete", function(chapterId)
    if chapterId ~= self.chapterId then
      return
    end
    self:refreshChapterReward()
  end)
end
