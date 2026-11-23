local class = {}
ed.AwakeDungeonNetwork = class

function class.isDebug()
  return false
end

function class.dispatch(reply)
  if class.isDebug() then
    print("-------------AwakeDungeonNetwork:replyReq--------------")
    ed.pt(reply)
  end
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  if reply._open_panel then
    dungeonMgr:handleOpenPanel(reply._open_panel)
  elseif reply._enter_stage then
    dungeonMgr:handleEnterStage(reply._enter_stage)
  elseif reply._exit_stage then
    dungeonMgr:handleExitStage(reply._exit_stage)
  elseif reply._sweep then
    dungeonMgr:handleSweep(reply._sweep, class.sweepTimes)
  elseif reply._buy_vitality then
    dungeonMgr:handleBuyVitality(reply._buy_vitality)
  elseif reply._level_rewards then
    dungeonMgr:handleLevelReward(reply._level_rewards)
  elseif reply._stage_record then
    dungeonMgr:handleStageRecord(reply._stage_record)
  elseif reply._take_block_rewards then
    dungeonMgr:handleBlockRewards(reply._take_block_rewards)
  elseif reply._enter_next_chapter then
    dungeonMgr:handleEnterChapter(reply._enter_next_chapter, class.chapterId)
  elseif reply._chapter_reward then
    dungeonMgr:handleChapterReward(reply._chapter_reward, class.sendRewardChapterId)
  elseif reply._prepare_battle then
    dungeonMgr:handlePrepareBattle(reply._prepare_battle)
  elseif reply._chapter_info then
    dungeonMgr:handleChapterRecord(reply._chapter_info)
  end
end

function class.notify(reply)
  if class.isDebug() then
    print("-------------AwakeDungeonNetwork:notify--------------")
    ed.pt(reply)
  end
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  dungeonMgr:handleNotify(reply)
end

function class.createReq()
  local req = ed.upmsg.awake_dungeon_req()
  return req
end

function class.sendReq(req)
  if class.isDebug() then
    print("-------------AwakeDungeonNetwork:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "awake_dungeon")
end

function class.sendOpenPanel()
  local req = class.createReq()
  req._open_panel = {}
  class.sendReq(req)
end

function class.sendEnterStage(stageId, x, y, lineup, freeHeroes, isUseHire)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  x, y = dungeonMgr:convertXYToServer(x, y)
  local req = class.createReq()
  req._enter_stage = {}
  req._enter_stage._coordinate = {}
  req._enter_stage._coordinate._x = x
  req._enter_stage._coordinate._y = y
  req._enter_stage._stage_id = stageId
  req._enter_stage._lineup = lineup
  req._enter_stage._free_heroes = freeHeroes
  req._enter_stage._use_hire = isUseHire and 1 or 0
  class.sendReq(req)
end

function class.sendExitStage(battleResult, operations, progress)
  local req = class.createReq()
  req._exit_stage = {}
  req._exit_stage._result = battleResult
  req._exit_stage._operations = operations
  req._exit_stage._progress = progress
  class.sendReq(req)
end

function class.sendSweep(sweepTimes)
  class.sweepTimes = sweepTimes
  local req = class.createReq()
  req._sweep = {}
  req._sweep._sweep_times = sweepTimes
  class.sendReq(req)
end

function class.sendBuyVitality(times)
  local req = class.createReq()
  req._buy_vitality = {}
  req._buy_vitality._times = times
  class.sendReq(req)
end

function class.sendLevelRewards(level)
  local req = class.createReq()
  req._level_rewards = {}
  req._level_rewards._level = level
  class.sendReq(req)
end

function class.sendStageRecord(stageId)
  local req = class.createReq()
  req._stage_record = {}
  req._stage_record._stage_id = stageId
  class.sendReq(req)
end

function class.sendEnterChapter(chapterId)
  class.chapterId = chapterId
  local req = class.createReq()
  req._enter_next_chapter = {}
  req._enter_next_chapter._chapter_id = chapterId
  class.sendReq(req)
end

function class.sendBlockRewards(x, y)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  x, y = dungeonMgr:convertXYToServer(x, y)
  local req = class.createReq()
  req._take_block_rewards = {}
  req._take_block_rewards._coordinate = {}
  req._take_block_rewards._coordinate._x = x
  req._take_block_rewards._coordinate._y = y
  class.sendReq(req)
end

function class.sendEnterBlock(x, y)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  x, y = dungeonMgr:convertXYToServer(x, y)
  local req = class.createReq()
  req._enter_block = {}
  req._enter_block._coordinate = {}
  req._enter_block._coordinate._x = x
  req._enter_block._coordinate._y = y
  class.sendReq(req)
end

function class.sendChapterReward(chapterId)
  class.sendRewardChapterId = chapterId
  local req = class.createReq()
  req._chapter_reward = {}
  req._chapter_reward._chapter_id = chapterId
  class.sendReq(req)
end

function class:sendPrepareBattle(stageId, x, y)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  x, y = dungeonMgr:convertXYToServer(x, y)
  local req = class.createReq()
  req._prepare_battle = {}
  req._prepare_battle._coordinate = {}
  req._prepare_battle._coordinate._x = x
  req._prepare_battle._coordinate._y = y
  req._prepare_battle._stage_id = stageId
  class.sendReq(req)
end

function class.sendChapterRecord(chapterId)
  local req = class.createReq()
  req._chapter_info = {}
  req._chapter_info._chapter_id = chapterId
  class.sendReq(req)
end
