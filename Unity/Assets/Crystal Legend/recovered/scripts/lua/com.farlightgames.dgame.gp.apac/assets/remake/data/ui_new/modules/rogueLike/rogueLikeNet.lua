local class = newclass("g")
ed.rogueLikeNet = class
class.debug = false

function class.dispatch(reply)
  if class.debug then
    print("-------------rogueLikeNet:replyReq--------------")
    ed.pt(reply)
  end
  local rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  if reply._open_panel then
    rogueLikeMgr:handleOpenPanel(reply._open_panel)
  elseif reply._enter_chapter then
    rogueLikeMgr:handleEnterChapter(reply._enter_chapter)
  elseif reply._enter_room then
    rogueLikeMgr:handleEnterRoom(reply._enter_room)
  elseif reply._start_battle then
    rogueLikeMgr:handleStartBattle(reply._start_battle)
  elseif reply._end_battle then
    rogueLikeMgr:handleEndBattle(reply._end_battle)
  elseif reply._choose_reward then
    rogueLikeMgr:handleChooseReward(reply._choose_reward)
  elseif reply._choose_choice then
    rogueLikeMgr:handleChooseChoice(reply._choose_choice)
  elseif reply._shop_buy_bless then
    rogueLikeMgr:handleBuyBless(reply._shop_buy_bless)
  elseif reply._refresh_bless then
    rogueLikeMgr:handleRefreshBless(reply._refresh_bless)
  elseif reply._enter_next_round then
    rogueLikeMgr:handleEnterNextRound(reply._enter_next_round)
  elseif reply._skip_battle then
    rogueLikeMgr:handleSkipBattle(reply._skip_battle)
  elseif reply._end_chapter then
    rogueLikeMgr:handleEndChapter(reply._end_chapter)
  elseif reply._exit_chapter then
    rogueLikeMgr:handleExitChapter(reply._exit_chapter)
  elseif reply._open_tech then
    rogueLikeMgr:handleOpenTech(reply._open_tech)
  elseif reply._buy_tech then
    rogueLikeMgr:handleBuyTech(reply._buy_tech)
  elseif reply._golden_reward then
    rogueLikeMgr:handleGoldenReward(reply._golden_reward)
  elseif reply._view_bless_reward then
    rogueLikeMgr:handleViewBlessReward(reply._view_bless_reward)
  elseif reply._view_event_reward then
    rogueLikeMgr:handleViewEventReward(reply._view_event_reward)
  elseif reply._query_rankboard then
    rogueLikeMgr:handleRankBoard(reply._query_rankboard)
  elseif reply._open_script then
    rogueLikeMgr:handleOpenScript(reply._open_script)
  elseif reply._script_reward then
    rogueLikeMgr:handleScriptReward(reply._script_reward)
  elseif reply._query_charm then
    rogueLikeMgr:handleQueryCharm(reply._query_charm)
  elseif reply._refresh_room then
    rogueLikeMgr:handleRefreshRoom(reply._refresh_room)
  elseif reply._sync_hero_infos then
    rogueLikeMgr:handleSyncHeroInfos(reply._sync_hero_infos)
  end
end

function class.notify(reply)
  if class.debug then
    print("-------------rogueLikeNet:notify reply--------------")
    ed.pt(reply)
  end
  local rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  rogueLikeMgr:handleNotify(reply)
end

function class.createReq()
  local req = ed.upmsg.rogue_req()
  return req
end

function class.sendReq(req)
  if class.debug then
    print("-------------rogueLikeNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "rogue")
end

function class.sendOpenPanel()
  local req = class.createReq()
  req._open_panel = ed.upmsg.rogue_open_panel()
  class.sendReq(req)
end

function class.sendEnterChapter(chapterId, difficulty, crisis, heroIdList, destinyId, charmIdList)
  local req = class.createReq()
  req._enter_chapter = ed.upmsg.rogue_enter_chapter()
  req._enter_chapter._chapter_id = chapterId
  req._enter_chapter._difficulty = difficulty
  req._enter_chapter._crisis = crisis
  req._enter_chapter._hero_ids = heroIdList
  req._enter_chapter._destiny_id = destinyId
  req._enter_chapter._charm_ids = charmIdList
  class.sendReq(req)
end

function class.sendEnterRoom(roundId, roomId)
  local req = class.createReq()
  req._enter_room = ed.upmsg.rogue_enter_room()
  req._enter_room._round_id = roundId
  req._enter_room._room_id = roomId
  class.sendReq(req)
end

function class.sendStartBattle(heroList)
  local req = class.createReq()
  req._start_battle = ed.upmsg.rogue_start_battle()
  req._start_battle._heroes = heroList
  class.sendReq(req)
end

function class.sendEndBattle(result, operations, heros, desEnergy)
  local req = class.createReq()
  req._end_battle = ed.upmsg.rogue_end_battle()
  req._end_battle._result = result
  req._end_battle._operations = operations
  req._end_battle._heroes = heros
  req._end_battle._des_energy = desEnergy
  class.sendReq(req)
end

function class.sendChooseReward(index, pos)
  local req = class.createReq()
  req._choose_reward = ed.upmsg.rogue_choose_reward()
  req._choose_reward._result_index = index
  req._choose_reward._pos = pos
  class.sendReq(req)
end

function class.sendChooseChoice(choiceIndex, chooseId)
  local req = class.createReq()
  req._choose_choice = ed.upmsg.rogue_choose_choice()
  req._choose_choice._choice_index = choiceIndex
  req._choose_choice._choose = chooseId
  class.sendReq(req)
end

function class.sendShopBuyBless(type, blessId)
  local req = class.createReq()
  req._shop_buy_bless = ed.upmsg.rogue_shop_buy_bless()
  req._shop_buy_bless._type = type
  req._shop_buy_bless._bless_id = blessId
  class.sendReq(req)
end

function class.sendRefreshBless(index)
  local req = class.createReq()
  req._refresh_bless = ed.upmsg.rogue_refresh_bless()
  req._refresh_bless._result_index = index
  class.sendReq(req)
end

function class.sendEnterNextRound()
  local req = class.createReq()
  req._enter_next_round = ed.upmsg.rogue_enter_next_round()
  class.sendReq(req)
end

function class.sendSkipBattle()
  local req = class.createReq()
  req._skip_battle = ed.upmsg.rogue_skip_battle()
  class.sendReq(req)
end

function class.sendEndChapter()
  local req = class.createReq()
  req._end_chapter = ed.upmsg.rogue_end_chapter()
  class.sendReq(req)
end

function class.sendRogueViewResult(roundId, roomId, resultIndexList)
  local req = class.createReq()
  req._view_result = ed.upmsg.rogue_view_result()
  req._view_result._round_id = roundId
  req._view_result._room_id = roomId
  req._view_result._result_index = resultIndexList
  class.sendReq(req)
end

function class.sendExitChapter()
  local req = class.createReq()
  req._exit_chapter = ed.upmsg.rogue_exit_chapter()
  class.sendReq(req)
end

function class.sendOpenTech(chapterId)
  local req = class.createReq()
  req._open_tech = ed.upmsg.rogue_open_tech()
  req._open_tech._chapter_id = chapterId
  class.sendReq(req)
end

function class.sendBuyTech(chapterId, techId)
  local req = class.createReq()
  req._buy_tech = ed.upmsg.rogue_buy_tech()
  req._buy_tech._chapter_id = chapterId
  req._buy_tech._tech_id = techId
  class.sendReq(req)
end

function class.sendGoldenReward(level)
  local req = class.createReq()
  req._golden_reward = ed.upmsg.rogue_golden_reward()
  req._golden_reward._level = level
  class.sendReq(req)
end

function class.sendViewBlessReward(id)
  local req = class.createReq()
  req._view_bless_reward = ed.upmsg.rogue_view_bless_reward()
  req._view_bless_reward._index = id
  class.sendReq(req)
end

function class.sendViewEventReward(id)
  local req = class.createReq()
  req._view_event_reward = ed.upmsg.rogue_view_event_reward()
  req._view_event_reward._id = id
  class.sendReq(req)
end

function class.sendRankBoard(chapterId, type)
  local req = class.createReq()
  req._query_rankboard = ed.upmsg.rogue_query_rankboard()
  req._query_rankboard._chapter_id = chapterId
  req._query_rankboard._type = type
  class.sendReq(req)
end

function class.sendOpenScript()
  local req = class.createReq()
  req._open_script = ed.upmsg.rogue_open_script()
  class.sendReq(req)
end

function class.sendScriptReward(scriptId)
  local req = class.createReq()
  req._script_reward = ed.upmsg.rogue_script_reward()
  req._script_reward._script_id = scriptId
  class.sendReq(req)
end

function class.sendQueryCharm(chapterId)
  local req = class.createReq()
  req._query_charm = ed.upmsg.rogue_query_charm()
  req._query_charm._chapter_id = chapterId
  class.sendReq(req)
end

function class.sendRefreshRoom(roundId, roomId)
  local req = class.createReq()
  req._refresh_room = ed.upmsg.rogue_refresh_room()
  req._refresh_room._round_id = roundId
  req._refresh_room._room_id = roomId
  class.sendReq(req)
end

function class.sendSyncHeroInfos()
  local req = class.createReq()
  req._sync_hero_infos = ed.upmsg.rogue_sync_hero_infos()
  class.sendReq(req)
end
