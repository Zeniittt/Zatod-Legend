local activityTaskTool = {}
ed.activityTaskTool = activityTaskTool
local res = ed.heroDetailManager.resConfig

function activityTaskTool.openHeroPackage()
  ed.pushScene(ed.ui.Heropackage.create())
end

function activityTaskTool.openSummonScene(type)
  ed.UITool.openView("summonScene", {page = type})
end

function activityTaskTool.openTaskScene(page)
  ed.UITool.openView("taskScene", {page = page})
end

function activityTaskTool.openDreamland()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Dreamland")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.UITool.openView("dreamland")
end

function activityTaskTool.openSkillTower()
  local ds = ed.playerlimit.getAreaUnlockPrompt("SkillTower")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.UITool.openView("SkillTowerScene")
end

function activityTaskTool.openCrusadeScene()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Crusade")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.UITool.openView("crusade")
end

function activityTaskTool.openStageSelect()
  ed.UITool.openView("stageSelect")
end

function activityTaskTool.openExerciseScene()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Exercise")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.UITool.openView("exerciseMainScene")
end

function activityTaskTool.enterRaid()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.UITool.openView("guildScene")
  ListenTimer(Timer:Once(0.1), function()
    local ds = ed.playerlimit.getAreaUnlockPrompt("Raid")
    if ds then
      ed.showToast(ds)
      return
    end
    if ed.player:getGuildId() == 0 then
      return
    end
    ed.GuildRaidNetwork:sendOpenPanel()
  end)
end

function activityTaskTool.enterGuildMercenary()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.UITool.openView("guildScene")
  ListenTimer(Timer:Once(0.1), function()
    local ds = ed.playerlimit.getAreaUnlockPrompt("Raid")
    if ds then
      ed.showToast(ds)
      return
    end
    if ed.player:getGuildId() == 0 then
      return
    end
    ed.GuildNetwork:sendQueryMercenary()
  end)
end

function activityTaskTool.openMidasuse()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Midas")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.ui.midasWin.create()
end

function activityTaskTool.openPvp()
  ed.UITool.openView("PVP")
end

function activityTaskTool.openShop(page)
  ed.UITool.openView("shopMain", {
    page = page or 1
  })
end

function activityTaskTool.openGuildChat()
  ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.guild_channel)
end

function activityTaskTool.openRealArenaScene()
  ed.UITool.openView("KingsPvpMainScene")
end

function activityTaskTool.openGuildClashScene()
  ed.UITool.openView("GuildClashMainScene", {})
end

function activityTaskTool.openPeakArenaScene()
  ed.UITool.openView("PeakArenaPvpScene")
end

function activityTaskTool.openFireForgeMainScene()
  ed.UITool.openView("fireForgeMainScene")
end

function activityTaskTool.openLoginPop()
  ed.UITool.openView("signIn")
end

function activityTaskTool.taskSkip(key, param)
  local condType = key
  if ed.isElementInTable(condType, {
    "add_hero",
    "hero_upgrade",
    "hero_evolve",
    "hero_level_up",
    "taverngroupuse"
  }) then
    local heroId = param
    local hero = ed.player:getHero(heroId)
    if hero then
      activityTaskTool.openHeroPackage()
    elseif condType == "taverngroupuse" then
      activityTaskTool.openSummonScene(1)
    else
      activityTaskTool.openSummonScene(3)
    end
  elseif ed.isElementInTable(condType, {
    "use_vit",
    "reach_level"
  }) then
    activityTaskTool.openStageSelect()
  elseif ed.isElementInTable(condType, {
    "complete_stage"
  }) then
    ed.pushScene(ed.ui.stageselect.create(nil, "elite"))
  elseif condType == "midasuse" then
    activityTaskTool.openMidasuse()
  elseif ed.isElementInTable(condType, {
    "tbc_victory",
    "completecrusadestage",
    "finishanycrusade",
    "weeklyjob_tpt_anycrusade"
  }) then
    activityTaskTool.openCrusadeScene()
  elseif ed.isElementInTable(condType, {
    "enter_dreamland",
    "realtime_dreamlandrank"
  }) then
    activityTaskTool.openDreamland()
  elseif ed.isElementInTable(condType, {"enter_raid"}) then
    activityTaskTool.enterRaid()
  elseif ed.isElementInTable(condType, {
    "sendmercenary"
  }) then
    activityTaskTool.enterGuildMercenary()
  elseif ed.isElementInTable(condType, {
    "pvpbattle",
    "weeklyjob_tpt_pvprank",
    "pvprank",
    "realtime_pvprank",
    "pvp_victory",
    "hero_group_challenge",
    "pvp_battle"
  }) then
    activityTaskTool.openPvp()
  elseif ed.isElementInTable(condType, {
    "farm_fancy_tower_stage",
    "complete_fancy_tower_stage"
  }) then
    activityTaskTool.openSkillTower()
  elseif ed.isElementInTable(condType, {
    "farm_act_stage",
    "complete_act_stage"
  }) then
    activityTaskTool.openExerciseScene()
  elseif ed.isElementInTable(condType, {
    "skill_upgrade_success",
    "hero_level_times",
    "multiherorank",
    "shard_level_up"
  }) then
    activityTaskTool.openHeroPackage()
  elseif ed.isElementInTable(condType, {"shop_buy"}) then
    activityTaskTool.openShop(param)
  elseif ed.isElementInTable(condType, {"guild_chat"}) then
    activityTaskTool.openGuildChat()
  elseif ed.isElementInTable(condType, {
    "taverngroupuse"
  }) then
    activityTaskTool.openSummonScene(1)
  elseif ed.isElementInTable(condType, {
    "rise_star_summon",
    "diamond_consume"
  }) then
    activityTaskTool.openSummonScene(5)
  elseif ed.isElementInTable(condType, {
    "dailyjob_open_chest"
  }) then
    activityTaskTool.openTaskScene(2)
  elseif ed.isElementInTable(condType, {
    "share_fight",
    "tally_pvprank"
  }) then
    activityTaskTool.openPvp()
  elseif ed.isElementInTable(condType, {
    "realarena_battle",
    "realarena_victory",
    "realarena_athletics_victory"
  }) then
    activityTaskTool.openRealArenaScene()
  elseif ed.isElementInTable(condType, {
    "legend_equip_forge_times",
    "getlegendequip"
  }) then
    activityTaskTool.openFireForgeMainScene()
  elseif condType == "peak_arena_battle" then
    activityTaskTool.openPeakArenaScene()
  elseif ed.isElementInTable(condType, {"days_login"}) then
    activityTaskTool.openLoginPop()
  end
end

function activityTaskTool.getTaskDesc(taskData)
  local condType = taskData._cond_type
  local condId = taskData._cond_id
  local condTarget = taskData._cond_target
  if condType == "add_hero" then
    local heroName = ed.getDataTable("Unit")[condId]["Display Name"]
    return string.format(T("\232\142\183\229\190\151%s"), heroName)
  elseif condType == "hero_evolve" then
    local heroName = ed.getDataTable("Unit")[condId]["Display Name"]
    return string.format(T("%s\229\141\135\229\136\176%s\230\152\159"), heroName, condTarget)
  elseif condType == "hero_upgrade" then
    local heroName = ed.getDataTable("Unit")[condId]["Display Name"]
    return string.format(T("%s\229\141\135\229\136\176%s"), heroName, res.skill_unlock_color_text[condTarget])
  elseif condType == "hero_level_up" then
    local heroName = ed.getDataTable("Unit")[condId]["Display Name"]
    return string.format(T("%s\229\159\185\229\133\187\232\135\179%s\231\186\167"), heroName, condTarget)
  elseif condType == "use_vit" then
    return string.format(T("\230\182\136\232\128\151%s\231\130\185\228\189\147\229\138\155"), condTarget)
  elseif condType == "midasuse" then
    return string.format(T("\228\189\191\231\148\168%s\230\172\161\231\130\185\233\135\145\230\137\139"), condTarget)
  elseif condType == "tbc_victory" then
    return string.format(T("\229\156\168\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\228\184\173\229\143\150\229\190\151%s\229\156\186\232\131\156\229\136\169"), condTarget)
  elseif condType == "enter_dreamland" then
    return string.format(T("\229\174\140\230\136\144%s\230\172\161\230\176\184\231\148\159\230\162\166\229\162\131\231\154\132\230\140\145\230\136\152"), condTarget)
  elseif condType == "enter_raid" then
    return string.format(T("\229\174\140\230\136\144%s\230\172\161\229\155\162\233\152\159\229\137\175\230\156\172\231\154\132\230\140\145\230\136\152"), condTarget)
  elseif condType == "farm_fancy_tower_stage" then
    return string.format(T("\229\174\140\230\136\144%s\230\172\161\229\185\187\229\162\131\228\185\139\229\161\148\231\154\132\230\140\145\230\136\152/\230\137\171\232\141\161"), condTarget)
  elseif condType == "farm_act_stage" then
    return string.format(T("\229\174\140\230\136\144%s\230\172\161\232\139\177\233\155\132\232\175\149\231\130\188\231\154\132\230\140\145\230\136\152/\230\137\171\232\141\161"), condTarget)
  elseif condType == "skill_upgrade_success" then
    return string.format(T("\230\143\144\229\141\135%s\230\172\161\232\139\177\233\155\132\230\138\128\232\131\189"), condTarget)
  elseif condType == "hero_level_times" then
    return string.format(T("\230\143\144\229\141\135%s\230\172\161\232\139\177\233\155\132\231\173\137\231\186\167"), condTarget)
  elseif condType == "taverngroupuse" then
    return string.format(T("\228\187\187\230\132\143\229\141\161\230\177\160\232\191\155\232\161\140%s\230\172\161\229\143\172\229\148\164"), condTarget)
  elseif condType == "dailyjob_open_chest" then
    return string.format(T("\229\188\128\229\144\175%s\230\172\161\230\175\143\230\151\165\228\187\187\229\138\161\229\174\157\231\174\177"), condTarget)
  elseif condType == "hero_group_challenge" then
    local requireGroupArr = ed.getDataTable("ActivityRequireGroup")[condId]
    local unitTable = ed.getDataTable("Unit")
    local nameStr
    for i, v in ipairs(requireGroupArr) do
      if v["Param Type"] == "Hero" then
        if nil == nameStr then
          nameStr = unitTable[v.ID]["Display Name"]
        else
          nameStr = T("%s\230\136\150\232\128\133%s", nameStr, unitTable[v.ID]["Display Name"])
        end
      end
    end
    return string.format(T("\228\189\191\231\148\168%s\229\174\140\230\136\144\231\171\158\230\138\128\229\156\186\230\140\145\230\136\152%s\230\172\161"), nameStr, condTarget)
  elseif condType == "pvp_battle" then
    return string.format(T("\229\174\140\230\136\144%s\229\156\186\231\171\158\230\138\128\229\156\186\231\154\132\230\140\145\230\136\152"), condTarget)
  elseif condType == "pvp_victory" then
    return string.format(T("\229\156\168\231\171\158\230\138\128\229\156\186\228\184\173\232\131\156\229\136\169%s\230\172\161"), condTarget)
  elseif condType == "share_fight" then
    return string.format(T("\229\136\134\228\186\171\231\171\158\230\138\128\229\156\186\233\152\181\229\174\185%s\230\172\161"), condTarget)
  elseif condType == "realarena_battle" then
    return string.format(T("\229\143\130\228\184\142%s\230\172\161\232\175\184\231\142\139\228\186\137\233\156\184"), condTarget)
  elseif condType == "realarena_victory" then
    return string.format(T("\232\175\184\231\142\139\228\186\137\233\156\184\231\180\175\232\174\161\232\131\156\229\136\169%s\229\156\186"), condTarget)
  elseif condType == "complete_stage" then
    local Chapter = ed.getDataTable("Stage")[condId]["Chapter ID"]
    return string.format(T("\231\178\190\232\139\177\231\172\172%s\231\171\160\232\138\130"), Chapter)
  elseif condType == "realarena_athletics_victory" then
    return string.format(T("\232\175\184\231\142\139\229\164\169\230\162\175\232\142\183\232\131\156%s\230\172\161"), condTarget)
  elseif condType == "peak_arena_battle" then
    return string.format(T("\229\174\140\230\136\144%s\229\156\186\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\231\154\132\230\140\145\230\136\152"), condTarget)
  elseif condType == "legend_equip_forge_times" then
    return string.format(T("\228\188\160\229\165\135\232\163\133\229\164\135\233\148\187\233\128\160%s\230\172\161"), condTarget)
  end
end

function activityTaskTool.getTaskState(taskData)
  local taskState = "TODO"
  local isCompleted = taskData._progress >= taskData._cond_target
  local isFinished = taskData._cur_reward_times and taskData._cur_reward_times >= taskData._max_reward_times
  if isFinished then
    taskState = "IS_FINISHED"
  elseif isCompleted then
    taskState = "IS_COMPLETED"
  end
  return taskState
end

function activityTaskTool.getRunCricketTaskDesc(taskData)
  local condType = taskData.progressType
  local condId = taskData.progressId
  local condTarget = taskData.target
  if condType == "solo_rank" then
    return string.format(T("\232\191\155\229\133\165\229\137\141<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\229\144\141\232\190\190\230\136\144<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\229\156\186\230\175\148\232\181\155"), condId, condTarget)
  elseif condType == "solo_flush_card" then
    return string.format(T("\229\141\161\231\137\140\229\149\134\229\186\151\228\189\191\231\148\168<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161\229\136\183\230\150\176"), condTarget)
  elseif condType == "solo_flush_remnant" then
    return string.format(T("\229\174\157\231\137\169\231\149\140\233\157\162\229\136\183\230\150\176<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), condTarget)
  elseif condType == "solo_buy_random" then
    return string.format(T("\228\189\191\231\148\168\233\154\143\230\156\186\232\180\173\228\185\176\229\141\161\231\137\140<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), condTarget)
  elseif condType == "solo_hero_win" then
    local heroName = ed.getDataTable("SoloUnit")[condId]["Display Name"]
    return string.format(T("\228\189\191\231\148\168\232\139\177\233\155\132<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%s</lable>\229\137\141\229\155\155\229\144\141<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), heroName, condTarget)
  elseif condType == "solo_rank" then
    return string.format(T("\232\191\155\229\133\165\229\137\141<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\229\144\141\232\190\190\230\136\144<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\229\156\186\230\175\148\232\181\155"), condId, condTarget)
  elseif condType == "solo_use_emoji" then
    return string.format(T("\228\189\191\231\148\168\232\161\168\230\131\133\229\143\145\233\128\129<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), condTarget)
  elseif condType == "solo_level_up" then
    return string.format(T("\228\187\187\230\132\143\232\139\177\233\155\132\232\190\190\229\136\176<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\231\186\167<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), condId, condTarget)
  elseif condType == "solo_win_faction" then
    local tagName = ed.getDataTable("SoloCardTag")[condId].Name
    return string.format(T("\228\189\191\231\148\168<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%s</lable>\230\181\129\230\180\190\228\189\156\228\184\186\228\184\187\232\166\129\230\181\129\230\180\190\232\142\183\229\190\151\229\137\141\229\155\155\229\144\141<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), tagName, condTarget)
  elseif condType == "solo_pay_coin" then
    return string.format(T("\230\184\184\230\136\143\229\134\133\232\138\177\232\180\185<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\233\135\145\229\184\129"), condTarget)
  elseif condType == "solo_match_casual" then
    return string.format(T("\228\189\191\231\148\168\228\188\145\233\151\178\230\168\161\229\188\143\233\155\134\233\189\144<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\228\184\170\228\186\186\228\187\165\228\184\138\229\188\128\229\144\175\230\175\148\232\181\155<lable color=ccc3(160,255,148) strokeColor=ccc3(70,86,25) strokeSize=1.4>%d</lable>\230\172\161"), condId, condTarget)
  end
  return "nil = " .. condType
end
