local headlineConfig = {}
headlineConfig.__index = headlineConfig
ed.ui.headlineConfig = headlineConfig
headlineConfig.defaultDelayTime = 5
headlineConfig.ServerPlayer = T("<lable color=ccc3(251,224,71) fontName=font fontSize=f18 strokeColor=ccc3(32,17,14) strokeSize=1>%s</lable>")
headlineConfig.AddMedal = T("<sprite src=%s scale=0.2>")
headlineConfig.ServerOther = T("<lable color=ccc3(255,189,130) fontName=font fontSize=f18 strokeColor=ccc3(32,17,14) strokeSize=1>%s</lable>")
headlineConfig.GuildAll = T("<lable color=ccc3(103,185,249) fontName=font fontSize=f18 strokeColor=ccc3(22,27,49) strokeSize=1>%s</lable>")
headlineConfig.Text = T("<lable color=ccc3(255,252,231) fontName=font fontSize=f18 strokeColor=ccc3(39,37,36) strokeSize=1>%s</lable>")
headlineConfig.DiamondIcon = T("UI/alpha/1080P/icon/diamond.png")
headlineConfig.ServerHero = T("<lable color=ccc3(255,189,130) fontName=font fontSize=f18 strokeColor=ccc3(32,17,14) strokeSize=1>%s</lable><sprite id=%s scale=0.35>")
headlineConfig.GuildHero = T("<lable color=ccc3(103,185,249) fontName=font fontSize=f18 strokeColor=ccc3(22,27,49) strokeSize=1>%s</lable><sprite id=%s scale=0.35>")

function headlineConfig.Y(userInfo)
  local name = ""
  local guildName = ""
  if userInfo._medal and userInfo._medal._medal_id then
    local src = ed.getMedalRes(userInfo._medal)
    name = string.format(headlineConfig.AddMedal .. headlineConfig.ServerPlayer, src, userInfo.u_name)
  else
    name = string.format(headlineConfig.ServerPlayer, userInfo.u_name)
  end
  return guildName .. name
end

function headlineConfig.K(userInfo)
  if userInfo._medal and userInfo._medal._medal_id then
    local src = ed.getMedalRes(userInfo._medal)
    return string.format(headlineConfig.AddMedal .. headlineConfig.ServerPlayer, src, userInfo.u_name)
  else
    return string.format(headlineConfig.ServerPlayer, userInfo.u_name)
  end
end

function headlineConfig.H(params, t)
  t = t or 1
  local hero_id = tonumber(params[1])
  local hero_tbl = ed.getDataTable("Unit")
  local hero_name = hero_tbl[hero_id]["Display Name"]
  if t == 1 then
    return string.format(headlineConfig.ServerHero, hero_name, hero_id)
  else
    return string.format(headlineConfig.GuildHero, hero_name, hero_id)
  end
end

function headlineConfig.L(params, t)
  t = t or 1
  local typeStr = ""
  local context = ""
  local stage_id = tonumber(params[1])
  local stage_name = ed.getDataTable("Stage")[stage_id]["Stage Name"]
  local chapterID = ed.getDataTable("Stage")[stage_id]["Chapter ID"]
  local chapterName = ed.getDataTable("Chapter")[chapterID]["Chapter Name"]
  local difficulty = tostring(ed.getDataTable("Stage")[stage_id].Difficulty)
  local battleType = ed.getDataTable("Battle")[stage_id][1]["Stage Type"]
  if battleType == "elite" then
    typeStr = T("\231\178\190\232\139\177")
  else
    typeStr = T("\230\153\174\233\128\154")
  end
  if chapterID == 103 or chapterID == 102 then
    context = string.format(T("\233\154\190\229\186\166%s\231\154\132%s\229\137\175\230\156\172"), difficulty, stage_name)
  else
    context = string.format(T(" \231\172\172%s\231\171\160 %s%s\229\133\179\229\141\161"), ed.numberToChinese(chapterID), chapterName, typeStr)
  end
  if t == 1 then
    return string.format(headlineConfig.ServerOther, context), context
  else
    return string.format(headlineConfig.GuildAll, context), context
  end
end

function headlineConfig.getChapterName(params, t)
  t = t or 1
  local stage_id = tonumber(params[1])
  local chapterID = ed.getDataTable("Stage")[stage_id]["Chapter ID"]
  local chapterName = ed.getDataTable("Chapter")[chapterID]["Chapter Name"]
  local battleType = ed.getDataTable("Battle")[stage_id][1]["Stage Type"]
  local typeStr
  if battleType == "elite" then
    typeStr = T("\231\178\190\232\139\177\229\133\179\229\141\161")
  else
    typeStr = T("\230\153\174\233\128\154\229\133\179\229\141\161")
  end
  local context = string.format(T("\231\172\172%s\231\171\160 %s%s"), ed.numberToChinese(chapterID), chapterName, typeStr)
  if t == 1 then
    return string.format(headlineConfig.ServerOther, context), context
  else
    return string.format(headlineConfig.GuildAll, context), context
  end
end

function headlineConfig.HJ(params, t)
  t = t or 1
  local hjType = params[1] or "1"
  local hjStr = T("\229\138\155\228\185\139\229\185\187\229\162\131")
  if hjType == "1" then
    hjStr = T("\229\138\155\228\185\139\229\185\187\229\162\131")
  elseif hjType == "2" then
    hjStr = T("\230\149\143\228\185\139\229\185\187\229\162\131")
  elseif hjType == "3" then
    hjStr = T("\230\153\186\228\185\139\229\185\187\229\162\131")
  end
  if t == 1 then
    return string.format(headlineConfig.ServerOther, hjStr), hjStr
  else
    return string.format(headlineConfig.GuildAll, hjStr), hjStr
  end
end

function headlineConfig.R(params, t)
  t = t or 1
  local displayName = ""
  local raid_id = params[1]
  if raid_id then
    raid_id = tonumber(raid_id) or raid_id
    local data = ed.getDataTable("Raid")[raid_id]
    if data then
      displayName = data["Display Name"]
    end
  end
  if t == 1 then
    return string.format(headlineConfig.ServerOther, displayName .. T("\229\155\162\230\156\172BOSS")), displayName .. T("\229\155\162\230\156\172BOSS")
  else
    return string.format(headlineConfig.GuildAll, displayName .. T("\229\155\162\230\156\172BOSS")), displayName .. T("\229\155\162\230\156\172BOSS")
  end
end

local roleIdForMedalId = {}

function headlineConfig.headlineRoleMedalId(RoleId, medalId)
  roleIdForMedalId[RoleId] = medalId or roleIdForMedalId[RoleId] or 0
  return roleIdForMedalId[RoleId] or 0
end

headlineConfig.msglist = {}
headlineConfig.msglist[1] = {
  context = T("%s\229\135\187\232\180\165\228\186\134%s%s\229\141\160\233\162\134\228\186\134\231\171\158\230\138\128\229\156\186\231\172\172\228\184\128\229\144\141\231\154\132\229\174\157\229\186\167\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local name_b = ""
    local guildname_b = ""
    if 1 < #params then
      name_b = string.format(headlineConfig.ServerOther, params[2])
    else
      name_b = string.format(headlineConfig.ServerOther, params[1])
    end
    local text = string.format(context, headlineConfig.Y(userInfo), guildname_b, name_b)
    return text, 1
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|16|0.34><text|chat_content|%s><link|playerlink|%s|%s><text|chat_content|\229\135\187\232\180\165\228\186\134><text|chat_content|%s><link|playerlink|%s|%s><text|chat_content|\229\141\160\233\162\134\228\186\134\231\171\158\230\138\128\229\156\186\231\172\172\228\184\128\229\144\141\231\154\132\229\174\157\229\186\167\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    local targetRoleId = extra.targetRoleId
    local name_a = userInfo._user_name
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local guildname_a = ""
    local name_b = ""
    local guildname_b = ""
    if 1 < #params then
      name_b = params[2]
    else
      name_b = params[1]
    end
    return string.format(richTextStr, guildname_a, name_a, speakerRoleId, guildname_b, name_b, targetRoleId)
  end
}
headlineConfig.msglist[2] = {
  context = T("%s\229\156\168\229\143\172\229\148\164\230\179\149\233\152\181\228\184\173\230\132\143\229\164\150\232\142\183\229\190\151\228\186\134\232\139\177\233\155\132%s\239\188\140\232\191\144\230\176\148\228\184\141\233\148\153\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.H(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|12|0.34><link|playerlink|%s|%s><text|chat_content|\229\156\168\229\143\172\229\148\164\230\179\149\233\152\181\228\184\173\230\132\143\229\164\150\232\142\183\229\190\151\228\186\134\232\139\177\233\155\132><link|herolink2|%s><text|chat_content|\239\188\140\232\191\144\230\176\148\228\184\141\233\148\153\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local heroId = tonumber(params[1])
    local unitTB = ed.getDataTable("Unit")
    local heroName = unitTB[heroId]["Display Name"]
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, heroName)
  end
}
headlineConfig.msglist[3] = {
  context = T("%s\229\133\168\230\156\141\233\166\150\230\172\161\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134%s\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.Y(userInfo), headlineConfig.L(params))
    return text, 1
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|4|0.34><link|playerlink|%s|%s><text|chat_content|\229\133\168\230\156\141\233\166\150\230\172\161\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134><text|chat_content_highline_yellow|%s><text|chat_content|\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, chapterName = headlineConfig.L(params)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, chapterName)
  end
}
headlineConfig.msglist[4] = {
  context = T("%s\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134%s\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.L(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|4|0.34><link|playerlink|%s|%s><text|chat_content|\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134><text|chat_content_highline_yellow|%s><text|chat_content|\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, chapterName = headlineConfig.L(params)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, chapterName)
  end
}
headlineConfig.msglist[5] = {
  context = T("%s\229\133\168\230\156\141\233\166\150\230\172\161\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134%s\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.Y(userInfo), headlineConfig.getChapterName(params))
    return text, 1
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|16|0.34><link|playerlink|%s|%s><text|chat_content|\229\133\168\230\156\141\233\166\150\230\172\161\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134><text|chat_content_highline_yellow|%s><text|chat_content|\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, chapterName = headlineConfig.getChapterName(params)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, chapterName)
  end
}
headlineConfig.msglist[6] = {
  context = T("%s\230\156\172\228\186\186\233\166\150\230\172\161\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134%s\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.L(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|4|0.34><link|playerlink|%s|%s><text|chat_content|\230\156\172\228\186\186\233\166\150\230\172\161\228\184\137\230\152\159\233\128\154\229\133\179\228\186\134><text|chat_content_highline_yellow|%s><text|chat_content|\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, chapterName = headlineConfig.L(params)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, chapterName)
  end
}
headlineConfig.msglist[7] = {
  context = T("%s\230\137\147\229\188\128\232\191\156\229\190\129\229\174\157\231\174\177\239\188\140\232\142\183\229\190\151\228\186\134%s\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local level = string.format(headlineConfig.ServerOther, T("\229\164\167\233\135\143\231\180\171\232\137\178\232\163\133\229\164\135"))
    local text = string.format(context, headlineConfig.K(userInfo), level)
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|8|0.34><link|playerlink|%s|%s><text|chat_content|\230\137\147\229\188\128\232\191\156\229\190\129\229\174\157\231\174\177\239\188\140\232\142\183\229\190\151\228\186\134\229\164\167\233\135\143\231\180\171\232\137\178\232\163\133\229\164\135\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    return string.format(richTextStr, userInfo._user_name, speakerRoleId)
  end
}
headlineConfig.msglist[8] = {
  context = T("%s\230\137\147\229\188\128\232\191\156\229\190\129\229\174\157\231\174\177\239\188\140\232\142\183\229\190\151\228\186\134%s\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.H(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|13|0.34><link|playerlink|%s|%s><text|chat_content|\230\137\147\229\188\128\232\191\156\229\190\129\229\174\157\231\174\177\239\188\140\232\142\183\229\190\151\228\186\134><link|herolink2|%s><text|chat_content|\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local hero_id = tonumber(params[1])
    local hero_tbl = ed.getDataTable("Unit")
    local hero_name = hero_tbl[hero_id]["Display Name"]
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, hero_name)
  end
}
headlineConfig.msglist[9] = {
  context = T("\230\129\173\229\150\156%s\233\128\154\229\133\179\228\186\134%s\228\187\138\229\164\169\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local level = string.format(headlineConfig.GuildAll, "")
    local text = string.format(context, headlineConfig.K(userInfo), level)
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|9|0.34><text|chat_content|\230\129\173\229\150\156><link|playerlink|%s|%s><text|chat_content|\233\128\154\229\133\179\228\186\134\232\191\156\229\190\129\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    return string.format(richTextStr, userInfo._user_name, speakerRoleId)
  end
}
headlineConfig.msglist[10] = {
  context = T("%s\229\175\185boss\233\128\160\230\136\144\228\186\134%s\239\188\140\230\153\139\229\141\135\230\142\146\232\161\140\230\166\156%s\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local p1 = string.format(headlineConfig.ServerOther, (params[1] or "") .. T("\228\188\164\229\174\179"))
    local p2 = string.format(headlineConfig.ServerOther, T("\231\172\172%s\229\144\141", params[2] or "?"))
    local text = string.format(context, headlineConfig.Y(userInfo), p1, p2)
    return text, 1
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|12|0.34><link|playerlink|%s|%s><text|chat_content|\229\175\185boss\233\128\160\230\136\144\228\186\134%s\228\188\164\229\174\179\239\188\140\230\153\139\229\141\135\230\142\146\232\161\140\230\166\156\231\172\172%s\229\144\141\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, params[1], params[2])
  end
}
headlineConfig.msglist[11] = {
  context = T("%s\229\156\168\228\189\163\229\133\181\232\144\165\229\156\176\233\135\140\230\148\190\231\189\174\228\186\134%s\239\188\140\228\190\155\229\133\172\228\188\154\229\133\132\229\188\159\228\187\172\228\189\191\231\148\168"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.H(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|10|0.34><link|playerlink|%s|%s><text|chat_content|\229\156\168\228\189\163\229\133\181\232\144\165\229\156\176\233\135\140\230\148\190\231\189\174\228\186\134><link|herolink2|%s|%s|%s><text|chat_content|\239\188\140\228\190\155\229\133\172\228\188\154\229\133\132\229\188\159\228\187\172\228\189\191\231\148\168>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local hero_id = tonumber(params[1])
    local hero_tbl = ed.getDataTable("Unit")
    local hero_name = hero_tbl[hero_id]["Display Name"]
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, hero_name, speakerRoleId, hero_id)
  end
}
headlineConfig.msglist[12] = {
  context = T("%s\229\156\168\231\171\158\230\138\128\229\156\186\229\164\167\230\152\190\232\186\171\230\137\139\239\188\140\232\191\158\232\131\156%s\229\156\186\230\137\128\229\144\145\230\138\171\233\157\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local p1 = string.format(headlineConfig.ServerOther, params[1] or "")
    local text = string.format(context, headlineConfig.Y(userInfo), p1)
    return text, 1
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|6|0.34><link|playerlink|%s|%s><text|chat_content|\229\156\168\231\171\158\230\138\128\229\156\186\229\164\167\230\152\190\232\186\171\230\137\139\239\188\140\232\191\158\232\131\156%s\229\156\186\230\137\128\229\144\145\230\138\171\233\157\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, params[1])
  end
}
headlineConfig.msglist[13] = {
  context = T("%s\230\156\172\229\140\186\233\166\150\230\172\161\233\128\154\229\133\179\228\186\134%s\239\188\129\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.Y(userInfo), headlineConfig.HJ(params, 1))
    return text, 1
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|16|0.34><link|playerlink|%s|%s><text|chat_content|\230\156\172\229\140\186\233\166\150\230\172\161\233\128\154\229\133\179\228\186\134><text|chat_content_highline_yellow|%s><text|chat_content|\239\188\129\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, skillTowerName = headlineConfig.HJ(params, 1)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, skillTowerName)
  end
}
headlineConfig.msglist[14] = {
  context = T("%s\230\156\172\228\186\186\233\166\150\230\172\161\233\128\154\229\133\179\228\186\134%s\239\188\129\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.HJ(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|16|0.34><link|playerlink|%s|%s><text|chat_content|\230\156\172\228\186\186\233\166\150\230\172\161\233\128\154\229\133\179\228\186\134%s\239\188\129\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, skillTowerName = headlineConfig.HJ(params, 2)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, skillTowerName)
  end
}
headlineConfig.msglist[15] = {
  context = T("%s\229\135\187\230\157\128\228\186\134%s\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.K(userInfo), headlineConfig.R(params, 2))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|16|0.34><link|playerlink|%s|%s><text|chat_content|\229\135\187\230\157\128\228\186\134><text|chat_content_highline_yellow|%s><text|chat_content|\239\188\140\233\148\139\232\138\146\230\175\149\233\156\178\239\188\140\229\138\191\228\184\141\229\143\175\230\140\161\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local _, raidName = headlineConfig.R(params, 2)
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, raidName)
  end
}
headlineConfig.msglist[16] = {
  context = T("%s\229\156\168\233\173\148\231\149\140\232\174\168\228\188\144\231\142\169\230\179\149\230\140\145\230\136\152boss\229\144\142\239\188\140\232\142\183\229\190\151\228\186\134<lable color=ccc3(251,224,71) fontName=font fontSize=f18 strokeColor=ccc3(32,17,14) strokeSize=1>10\229\188\160\229\143\172\229\148\164\229\141\183</lable>\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local text = string.format(context, headlineConfig.Y(userInfo))
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|6|0.34><link|playerlink|%s|%s><text|chat_content|\229\156\168\233\173\148\231\149\140\232\174\168\228\188\144\231\142\169\230\179\149\230\140\145\230\136\152boss\229\144\142\239\188\140\232\142\183\229\190\151\228\186\13410\229\188\160\229\143\172\229\148\164\229\141\183\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    return string.format(richTextStr, userInfo._user_name, speakerRoleId)
  end
}
headlineConfig.msglist[17] = {
  context = T("%s\229\156\168\229\165\179\231\165\158\228\185\139\230\136\152\231\171\158\231\140\156\229\174\157\231\174\177\228\184\173\239\188\140\232\142\183\229\190\151\228\186\134%s\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129"),
  handler = function(info, context)
    local params = info.params
    local userInfo = info.user_a
    local equipStr = ""
    if params and 2 == #params then
      local equipTableItem = ed.getDataTable("equip")[tonumber(params[1])]
      local equipName = ""
      if nil ~= equipTableItem then
        equipName = equipTableItem.Name
      end
      equipStr = string.format("<lable color=ccc3(251,224,71) fontName=font fontSize=f18 strokeColor=ccc3(32,17,14) strokeSize=1>%sx%d</lable>", equipName, params[2] or 0)
    end
    local text = string.format(context, headlineConfig.Y(userInfo), equipStr)
    return text, 2
  end,
  chatContextHandler = function(_lantern_msg, extra)
    local richTextStr = T("<emoji|6|0.34><link|playerlink|%s|%s><text|chat_content|\229\156\168\229\165\179\231\165\158\228\185\139\230\136\152\231\171\158\231\140\156\229\174\157\231\174\177\228\184\173\239\188\140\232\142\183\229\190\151\228\186\134>%s<text|chat_content|\239\188\140\232\191\144\230\176\148\229\164\170\229\165\189\228\186\134\239\188\129>")
    local params = _lantern_msg._params
    local userInfo = _lantern_msg._user_a
    local speakerRoleId = extra.speakerRoleId
    if userInfo._medal and userInfo._medal._medal_id then
      headlineConfig.headlineRoleMedalId(speakerRoleId, userInfo._medal._medal_id)
    end
    local equipStr = ""
    if params and 2 == #params then
      local equipTableItem = ed.getDataTable("equip")[tonumber(params[1])]
      local equipName = ""
      if nil ~= equipTableItem then
        equipName = equipTableItem.Name
      end
      equipStr = string.format("<text|bl_tip_yellow|%sx%d>", equipName, params[2] or 0)
    end
    return string.format(richTextStr, userInfo._user_name, speakerRoleId, equipStr)
  end
}
