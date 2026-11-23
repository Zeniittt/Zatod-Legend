local base = ed.ui.popwindow
local guildClashBattlePop = newclass(base.mt)
ed.guildClashBattlePop = guildClashBattlePop

local function autoOpenFuns()
  local guildClashSchedule = {}
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    table.insert(guildClashSchedule, v)
  end
  table.sort(guildClashSchedule, function(a, b)
    return a["Schedule ID"] < b["Schedule ID"]
  end)
  local begin, clashEnd
  for _, v in ipairs(guildClashSchedule) do
    if v["State Type"] == "PrepareBegin" then
      begin = ed.dateStringToTime(v["Start Time"])
    elseif v["State Type"] == "ClashEnd" then
      clashEnd = ed.dateStringToTime(v["Start Time"])
      break
    end
  end
  if not clashEnd or clashEnd < ed.getFitServerTime() then
    return false
  end
  local week = math.ceil((ed.getFitServerTime() - begin) / 604800) + 1
  local uidKey = ed.getRoleKey("guildClashBattleIsOpenInt")
  local zt = ed.storage.getInt(uidKey) ~= week
  if zt and uidKey and week then
    ed.storage.setValue(uidKey, week)
  end
  return zt
end

local function getEndTimeFuns()
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    if v["State Type"] == "ClashEnd" then
      return ed.getFitServerTime() > ed.dateStringToTime(v["Start Time"])
    elseif v["State Type"] == "SeasonEnd" then
      return ed.getFitServerTime() > ed.dateStringToTime(v["Start Time"])
    end
  end
end

local function getPreciseRound()
  local round = ed.GuildClashManager:getRoundId()
  if round == 0 or getEndTimeFuns() then
    for roundId, _ in ipairs(ed.getDataTable("GuildClashCourseShow") or {}) do
      round = roundId
    end
  end
  local guildClashSchedule = {}
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    table.insert(guildClashSchedule, v)
  end
  table.sort(guildClashSchedule, function(a, b)
    return a["Schedule ID"] < b["Schedule ID"]
  end)
  local MatchGuilds, PrepareBegin
  for _, v in ipairs(guildClashSchedule) do
    if v["State Type"] == "MatchGuilds" then
      MatchGuilds = ed.dateStringToTime(v["Start Time"])
    elseif v["State Type"] == "PrepareBegin" then
      PrepareBegin = ed.dateStringToTime(v["Start Time"])
    end
    if MatchGuilds and PrepareBegin and MatchGuilds <= ed.getFitServerTime() and PrepareBegin >= ed.getFitServerTime() then
      return round - 1
    end
  end
  return round
end

local function nextBattleTime()
  local guildClashSchedule = {}
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    table.insert(guildClashSchedule, v)
  end
  table.sort(guildClashSchedule, function(a, b)
    return a["Schedule ID"] < b["Schedule ID"]
  end)
  local nextTimes, index = {}, 1
  for _, v in ipairs(guildClashSchedule) do
    if v["State Type"] == "PrepareBegin" then
      nextTimes[index] = {}
      nextTimes[index].PrepareBegin = ed.dateStringToTime(v["Start Time"])
    elseif v["State Type"] == "ClashShow" then
      nextTimes[index].ClashShow = ed.dateStringToTime(v["Start Time"])
      index = index + 1
    end
  end
  for i = 2, index - 1 do
    if nextTimes[i] and ed.getFitServerTime() >= nextTimes[i].PrepareBegin and ed.getFitServerTime() <= nextTimes[i].ClashShow then
      return true
    end
  end
  return false
end

ed.UITool.registViewOpenFunc("guildClashBattlePop", function(param)
  local isOpen = param and param.isOpen
  if isOpen and autoOpenFuns() or not isOpen then
    setmetatable(base.create("guildClashBattlePop"), guildClashBattlePop.mt):create():popWindow()
  end
end)

function guildClashBattlePop:create()
  self.data = self:initInfo()
  if self.data.self_guild_summary and self.data.oppo_guild_summary then
    self:initFca()
    self.actionLayer:setPosition(340 - ed.display.winSize.width / 2, ed.display.winSize.height * 0.45)
    self.localActionLayer:setPosition(ed.display.winSize.width / 2 - 340, -(ed.display.winSize.height * 0.45))
  else
    local container, ui = ed.editorui(ed.uieditor.guildClashBattlePop)
    self.actionLayer:addChild(container)
    self.container = container
    self.actionLayer:setPosition(340 - ed.display.winSize.width / 2, ed.display.winSize.height * 0.45)
    local newWid = ed.display.halfFixedWidth
    local newHei = ed.display.halfFixedHeight
    self.container:setPosition(ed.display.winSize.width / 2 - 340 + newWid, -(ed.display.winSize.height * 0.45) + newHei)
    self.ui = ui
    self:initEdui()
  end
  self:show({skipAnim = false})
  return self
end

function guildClashBattlePop:initInfo()
  local selfGuildSummary = ed.GuildClashManager[ed.GuildClashManager.campId ~= 1 and "oppoGuildSummary" or "selfGuildSummary"]
  local guildData = selfGuildSummary._guild_summary
  local self_guild_summary
  if selfGuildSummary and guildData then
    local president = guildData._president
    self_guild_summary = {
      guild_summary = {
        _id = guildData._id,
        _name = guildData._name,
        _avatar = guildData._avatar,
        _member_cnt = guildData._member_cnt,
        _chairman = president._name,
        _medal = president._medal
      },
      win_cnt = selfGuildSummary._win_cnt,
      lose_cnt = selfGuildSummary._lose_cnt,
      svr_id = selfGuildSummary._svr_id,
      svr_name = selfGuildSummary._svr_name
    }
  end
  selfGuildSummary = ed.GuildClashManager[ed.GuildClashManager.campId ~= 1 and "selfGuildSummary" or "oppoGuildSummary"]
  guildData = selfGuildSummary._guild_summary
  local oppo_guild_summary
  if selfGuildSummary and guildData then
    local president = guildData._president
    oppo_guild_summary = {
      guild_summary = {
        _id = guildData._id,
        _name = guildData._name,
        _avatar = guildData._avatar,
        _member_cnt = guildData._member_cnt,
        _chairman = president._name,
        _medal = president._medal
      },
      win_cnt = selfGuildSummary._win_cnt,
      lose_cnt = selfGuildSummary._lose_cnt,
      svr_id = selfGuildSummary._svr_id,
      svr_name = selfGuildSummary._svr_name
    }
  end
  local rateInfo = ed.GuildClashManager:getRateInfo()
  local winItems, loseItems = {}, {}
  for i, v in ipairs(ed.getDataTable("GuildClashPerReward")) do
    if v["Grade ID"] == rateInfo._grade then
      for ii = 1, 10 do
        if v["Win Reward Amount " .. ii] and v["Lose Reward Amount " .. ii] > 0 then
          table.insert(winItems, {
            id = v["Win Reward ID " .. ii],
            count = v["Win Reward Amount " .. ii],
            type = v["Win Reward Type " .. ii]
          })
        end
        if v["Lose Reward Amount " .. ii] and v["Lose Reward Amount " .. ii] > 0 then
          table.insert(loseItems, {
            id = v["Lose Reward ID " .. ii],
            count = v["Lose Reward Amount " .. ii],
            type = v["Lose Reward Type " .. ii]
          })
        end
      end
      break
    end
  end
  local gradeId = rateInfo._grade or 0
  local zoneId = rateInfo._zone_id or 0
  return {
    round = getPreciseRound(),
    end_time = ed.GuildClashManager:getStateEndTime(),
    zone_id = zoneId,
    zone_str = T("%s%s\230\136\152\229\140\186", ed.ui.guildClashGradeResultScene.GUILD_GRADE_TO_NAME[gradeId], zoneId),
    self_guild_summary = self_guild_summary,
    oppo_guild_summary = oppo_guild_summary,
    winItems = winItems,
    loseItems = loseItems
  }
end

function guildClashBattlePop:addUpdateScale()
  self:registerUpdateHandler("guildClashPopUpdate", function(dt)
    local s = self.actionLayer:getScale()
    self.clipLayer:setClipRect(CCRectMake(((ed.display.winSize.width - 820) / 2 - 20) * s, (ed.display.winSize.height - 500) / 2 * s, 820 * s, 500 * s))
  end)
end

function guildClashBattlePop:initFca()
  local actionLayer = CCLayer:create()
  self.localActionLayer = actionLayer
  self.actionLayer:addChild(actionLayer)
  local posx = ed.display.winSize.width / 2 - 30
  local posy = ed.display.winSize.height / 2
  local wid, hei = 820, 500
  local bjLayer = CCLayer:create()
  actionLayer:addChild(bjLayer)
  local clipLayer = CCLayer:create()
  actionLayer:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake((ed.display.winSize.width - wid) / 2 - 20, (ed.display.winSize.height - hei) / 2, wid, hei))
  local sprite1
  if ed.isAreaZhCn() then
    sprite1 = ed.createFcaNode("eff_UI_gvg_summarize2")
  else
    sprite1 = ed.createFcaNode("eff_UI_gvg_summarize2_globe")
    local win_label, win_node, lose_label, lose_node
    win_label = ed.createLabelTTF(T("\232\131\156"), 35, ed.fontBold)
    ed.setLabelColor(win_label, ed.toccc3(16640915))
    ed.setLabelStroke(win_label, ed.toccc3(3542034), 1.5)
    win_label:setPosition(ccp(-32, 0))
    win_label:setAnchorPoint(ccp(0, 0.5))
    win_node = CCSprite:create()
    win_node:addChild(win_label)
    sprite1:addNodeToComponent(win_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    lose_label = ed.createLabelTTF(T("\232\180\159"), 35, ed.fontBold)
    ed.setLabelColor(lose_label, ed.toccc3(16640915))
    ed.setLabelStroke(lose_label, ed.toccc3(3542034), 1.5)
    lose_label:setPosition(ccp(-32, 0))
    lose_label:setAnchorPoint(ccp(0, 0.5))
    lose_node = CCSprite:create()
    lose_node:addChild(lose_label)
    sprite1:addNodeToComponent(lose_node, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    win_label = ed.createLabelTTF(T("\232\131\156"), 35, ed.fontBold)
    ed.setLabelColor(win_label, ed.toccc3(16640915))
    ed.setLabelStroke(win_label, ed.toccc3(3542034), 1.5)
    win_label:setPosition(ccp(-32, 0))
    win_label:setAnchorPoint(ccp(0, 0.5))
    win_node = CCSprite:create()
    win_node:addChild(win_label)
    sprite1:addNodeToComponent(win_node, "Node3", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    lose_label = ed.createLabelTTF(T("\232\180\159"), 35, ed.fontBold)
    ed.setLabelColor(lose_label, ed.toccc3(16640915))
    ed.setLabelStroke(lose_label, ed.toccc3(3542034), 1.5)
    lose_label:setPosition(ccp(-32, 0))
    lose_label:setAnchorPoint(ccp(0, 0.5))
    lose_node = CCSprite:create()
    lose_node:addChild(lose_label)
    sprite1:addNodeToComponent(lose_node, "Node4", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  end
  sprite1:setPosition(posx, posy)
  clipLayer:addChild(sprite1)
  self.clipLayer = clipLayer
  self:addFca(sprite1)
  local middleLayer = CCLayer:create()
  actionLayer:addChild(middleLayer)
  local sprite = ed.createFcaNode("eff_UI_gvg_summarize")
  sprite:setPosition(posx, posy)
  actionLayer:addChild(sprite)
  self:addFca(sprite)
  local bookSpr = CCLayer:create()
  local close = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt_bj.png",
    pos = ccp(380, 20),
    scale = 0.8
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/butt_off.png",
    pos = ccp(28, 28),
    parent = close
  })
  self:btRegisterButtonClick({
    button = close,
    key = "close",
    clickHandler = function()
      self:addUpdateScale()
      self:destroy({
        skipAnim = false,
        actionTime = 0.6,
        callback = function()
          self:removeUpdateHandler("guildClashPopUpdate")
        end
      })
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  local timeStr, s = ed.GuildClashManager:getNextPrepareBegin()
  local timeTxt = ed.createLabelTools({
    txt = T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182:%s", timeStr),
    size = 17,
    color = ccc3(ed.colorToStr("#fef3a8")),
    stroke = {
      ccc3(ed.colorToStr("#614017")),
      1
    },
    parent = bookSpr
  })
  if s <= 0 then
    timeTxt:setString(T("\229\133\172\228\188\154\230\136\152\229\183\178\231\187\147\230\157\159"))
  elseif s < 3601 then
    self:listenTimer(Timer:Always(1), function()
      if not s then
        return
      end
      s = s - 1
      if s <= 0 then
        timeStr, s = ed.GuildClashManager:getNextPrepareBegin()
        if s <= 0 then
          s = nil
          timeTxt:setString(T("\229\133\172\228\188\154\230\136\152\229\183\178\231\187\147\230\157\159"))
        else
          if 3600 < s then
            s = nil
          end
          timeTxt:setString(T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182:%s", timeStr))
        end
      else
        timeTxt:setString(T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182:%s", ed.time2dhms(s)))
      end
    end)
  end
  ed.createLabelTools({
    txt = self.data.zone_str,
    size = 18,
    pos = ccp(0, -20),
    color = ccc3(255, 252, 231),
    stroke = {
      ccc3(ed.colorToStr("#614017")),
      1
    },
    parent = bookSpr
  })
  bookSpr:addChild(close)
  sprite:addNodeToComponent(bookSpr, "zhanqu", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  bookSpr = CCLayer:create()
  local label_title = ed.ui.gradientLabel.create({
    text = T("\229\133\172\228\188\154\230\136\152-\231\172\172%d\232\189\174\229\175\185\230\136\152", ed.clamp(self.data.round, 1, 99)),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776366),
    endColor = ed.toccc3(16495744),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(2887950)
  })
  bookSpr:addChild(label_title.node)
  sprite:addNodeToComponent(bookSpr, "biaoti", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  local label
  if ed.isAreaZhCn() then
    self:listenTimer(Timer:Once(1.5), function()
      local data = self.data.oppo_guild_summary
      label = ed.createLabelTools({
        txt = data.win_cnt,
        size = 36,
        pos = ccp(posx + 208, posy + 123),
        font = ed.fontBold,
        color = ccc3(253, 234, 146),
        stroke = {
          ccc3(ed.colorToStr("#46564c")),
          1
        },
        shadow = {
          ccc3(0, 0, 0),
          ccp(0, 4)
        },
        parent = middleLayer,
        scale = 3
      })
      label:runAction(CCEaseElasticOut:create(CCScaleTo:create(0.8, 1)))
      self:listenTimer(Timer:Once(0.2), function()
        label = ed.createLabelTools({
          txt = data.lose_cnt,
          size = 36,
          pos = ccp(posx + 270, posy + 123),
          font = ed.fontBold,
          color = ccc3(253, 234, 146),
          stroke = {
            ccc3(ed.colorToStr("#46564c")),
            1
          },
          shadow = {
            ccc3(0, 0, 0),
            ccp(0, 4)
          },
          parent = middleLayer,
          scale = 3
        })
        label:runAction(CCEaseElasticOut:create(CCScaleTo:create(0.8, 1)))
      end)
    end)
    self:listenTimer(Timer:Once(1), function()
      local data = self.data.self_guild_summary
      label = ed.createLabelTools({
        txt = data.win_cnt,
        size = 36,
        pos = ccp(posx - 280, posy + 123),
        font = ed.fontBold,
        color = ccc3(253, 234, 146),
        stroke = {
          ccc3(ed.colorToStr("#46564c")),
          1
        },
        shadow = {
          ccc3(0, 0, 0),
          ccp(0, 4)
        },
        parent = middleLayer,
        scale = 3
      })
      label:runAction(CCEaseElasticOut:create(CCScaleTo:create(0.8, 1)))
      self:listenTimer(Timer:Once(0.2), function()
        label = ed.createLabelTools({
          txt = data.lose_cnt,
          size = 36,
          pos = ccp(posx - 217, posy + 123),
          font = ed.fontBold,
          color = ccc3(253, 234, 146),
          stroke = {
            ccc3(ed.colorToStr("#46564c")),
            1
          },
          shadow = {
            ccc3(0, 0, 0),
            ccp(0, 4)
          },
          parent = middleLayer,
          scale = 3
        })
        label:runAction(CCEaseElasticOut:create(CCScaleTo:create(0.8, 1)))
      end)
    end)
  else
    local data = self.data.self_guild_summary
    label = ed.createLabelTools({
      txt = data.win_cnt,
      size = 36,
      font = ed.fontBold,
      color = ccc3(253, 234, 146),
      pos = ccp(-60, 0),
      stroke = {
        ccc3(ed.colorToStr("#46564c")),
        1
      },
      shadow = {
        ccc3(0, 0, 0),
        ccp(0, 4)
      }
    })
    local label_node = CCSprite:create()
    label_node:addChild(label)
    sprite1:addNodeToComponent(label_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    label = ed.createLabelTools({
      txt = data.lose_cnt,
      size = 36,
      font = ed.fontBold,
      color = ccc3(253, 234, 146),
      pos = ccp(-60, 0),
      stroke = {
        ccc3(ed.colorToStr("#46564c")),
        1
      },
      shadow = {
        ccc3(0, 0, 0),
        ccp(0, 4)
      }
    })
    label_node = CCSprite:create()
    label_node:addChild(label)
    sprite1:addNodeToComponent(label_node, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    data = self.data.oppo_guild_summary
    label = ed.createLabelTools({
      txt = data.win_cnt,
      size = 36,
      font = ed.fontBold,
      color = ccc3(253, 234, 146),
      pos = ccp(-60, 0),
      stroke = {
        ccc3(ed.colorToStr("#46564c")),
        1
      },
      shadow = {
        ccc3(0, 0, 0),
        ccp(0, 4)
      }
    })
    label_node = CCSprite:create()
    label_node:addChild(label)
    sprite1:addNodeToComponent(label_node, "Node3", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    label = ed.createLabelTools({
      txt = data.lose_cnt,
      size = 36,
      font = ed.fontBold,
      color = ccc3(253, 234, 146),
      pos = ccp(-60, 0),
      stroke = {
        ccc3(ed.colorToStr("#46564c")),
        1
      },
      shadow = {
        ccc3(0, 0, 0),
        ccp(0, 4)
      }
    })
    label_node = CCSprite:create()
    label_node:addChild(label)
    sprite1:addNodeToComponent(label_node, "Node4", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  end
  local name_label, member_label, name_tip, member_tip
  local data = self.data.self_guild_summary.guild_summary
  bookSpr = CCLayer:create()
  sprite1:addNodeToComponent(bookSpr, "xinxi1", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  name_label = ed.createLabelTools({
    txt = T(data._name),
    size = 18,
    font = ed.fontBold,
    pos = ccp(-60, 25),
    color = ccc3(255, 252, 231),
    stroke = {
      ccc3(ed.colorToStr("#37685c")),
      1
    },
    parent = bookSpr
  })
  member_tip = ed.createLabelTools({
    txt = "\230\136\144\229\145\152:",
    size = 15,
    anchor = ccp(0, 0.5),
    pos = ccp(-124, -3),
    color = ccc3(205, 255, 181),
    shadow = {
      ccc3(3, 3, 3),
      ccp(0, 2)
    },
    parent = bookSpr
  })
  member_label = ed.createLabelTools({
    txt = T("%d\229\144\141", data._member_cnt),
    size = 15,
    anchor = ccp(0, 0.5),
    pos = ccp(-80, -3),
    color = ccc3(255, 252, 231),
    shadow = {
      ccc3(3, 3, 3),
      ccp(0, 2)
    },
    parent = bookSpr
  })
  name_tip = ed.createLabelTools({
    txt = "\229\155\162\233\149\191:",
    size = 15,
    anchor = ccp(0, 0.5),
    pos = ccp(-124, -25),
    color = ccc3(205, 255, 181),
    shadow = {
      ccc3(3, 3, 3),
      ccp(0, 2)
    },
    parent = bookSpr
  })
  local name_1 = ed.getPlayerName(data._chairman, data._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  bookSpr:addChild(name_1)
  ed.right2(member_label, member_tip, 2)
  ed.right2(name_1, name_tip, 2)
  name_1:setScale(0.87)
  name_1.data = data
  self:listenTimer(Timer:Once(1.5), function()
    local pos = name_1:getParent():convertToWorldSpace(ccp(name_1:getPosition()))
    local name = ed.getPlayerName(name_1.data._chairman, name_1.data._medal, {
      anchorPoint = ccp(0, 0.5)
    })
    self.localActionLayer:addChild(name, 99999)
    name:setPosition(pos)
    name:setScale(0.87)
    name_1:removeFromParentAndCleanup(true)
  end)
  local avatarData = ed.analyzeAvatar(data._avatar or 1)
  local hand = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  hand:setPosition(90, 2)
  hand:setScale(1.1)
  bookSpr:addChild(hand)
  data = self.data.oppo_guild_summary.guild_summary
  bookSpr = CCLayer:create()
  sprite1:addNodeToComponent(bookSpr, "xinxi2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  name_label = ed.createLabelTools({
    txt = T(data._name),
    size = 18,
    font = ed.fontBold,
    pos = ccp(20, 25),
    color = ccc3(ed.colorToStr("#ffeee7")),
    stroke = {
      ccc3(ed.colorToStr("#74403c")),
      1
    },
    parent = bookSpr
  })
  member_tip = ed.createLabelTools({
    txt = T("\230\136\144\229\145\152:"),
    size = 15,
    anchor = ccp(0, 0.5),
    pos = ccp(-44, -3),
    color = ccc3(252, 237, 202),
    shadow = {
      ccc3(3, 3, 3),
      ccp(0, 2)
    },
    parent = bookSpr
  })
  member_label = ed.createLabelTools({
    txt = T("%d\229\144\141", data._member_cnt),
    size = 15,
    anchor = ccp(0, 0.5),
    pos = ccp(0, -3),
    color = ccc3(255, 252, 231),
    shadow = {
      ccc3(3, 3, 3),
      ccp(0, 2)
    },
    parent = bookSpr
  })
  name_tip = ed.createLabelTools({
    txt = T("\229\155\162\233\149\191:"),
    size = 15,
    anchor = ccp(0, 0.5),
    pos = ccp(-44, -25),
    color = ccc3(252, 237, 202),
    shadow = {
      ccc3(3, 3, 3),
      ccp(0, 2)
    },
    parent = bookSpr
  })
  local name_2 = ed.getPlayerName(data._chairman, data._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  bookSpr:addChild(name_2)
  ed.right2(member_label, member_tip, 2)
  ed.right2(name_2, name_tip, 2)
  name_2:setScale(0.87)
  name_2.data = data
  self:listenTimer(Timer:Once(1.5), function()
    local pos = name_2:getParent():convertToWorldSpace(ccp(name_2:getPosition()))
    local name = ed.getPlayerName(name_2.data._chairman, name_2.data._medal, {
      anchorPoint = ccp(0, 0.5)
    })
    self.localActionLayer:addChild(name, 99999)
    name:setPosition(pos)
    name:setScale(0.87)
    name_2:removeFromParentAndCleanup(true)
  end)
  avatarData = ed.analyzeAvatar(data._avatar or 1)
  hand = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  hand:setPosition(-100, 2)
  hand:setScale(1.1)
  bookSpr:addChild(hand)
  self:listenTimer(Timer:Once(1), function()
    label = ed.createLabelTools({
      txt = T(self.data.self_guild_summary.svr_name),
      size = 18,
      pos = ccp(posx - 267, posy - 65),
      color = ccc3(255, 252, 231),
      parent = middleLayer
    })
    label:setOpacity(0)
    label:runAction(CCFadeTo:create(0.7, 255))
    label = ed.createLabelTools({
      txt = T(self.data.oppo_guild_summary.svr_name),
      size = 18,
      pos = ccp(posx + 267, posy - 65),
      color = ccc3(255, 252, 231),
      parent = middleLayer
    })
    label:setOpacity(0)
    label:runAction(CCFadeTo:create(0.7, 255))
  end)
  self:listenTimer(Timer:Once(1), function()
    bookSpr = CCLayer:create()
    local itemBjImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/guild/guild_clash_battleinfo/battleinfo_award_background.png",
      pos = ccp(0, -170),
      parent = bookSpr
    })
    bookSpr:setPosition(posx, posy)
    actionLayer:addChild(bookSpr)
    itemBjImg:setOpacity(0)
    itemBjImg:runAction(CCFadeTo:create(0.7, 255))
    local oldTime = 0
    self:listenTimer(Timer:Once(0.3), function()
      local items = self.data.winItems
      local localposx = 340 - 22 * #items
      label = ed.createLabelTools({
        txt = T("\232\131\156\229\136\169\229\165\150\229\138\177"),
        size = 18,
        color = ccc3(252, 237, 202),
        parent = itemBjImg,
        scale = 1.9
      })
      label:setPosition(ccp(localposx - label:getContentSize().width / 2, 84))
      label:runAction(CCEaseBackOut:create(CCScaleTo:create(0.5, 1)))
      for i, v in ipairs(items) do
        local icon = ed.createItemIcon(v)
        icon:setPosition(localposx + i * 55, 84)
        itemBjImg:addChild(icon)
        icon:setScale(0.1)
        icon:setVisible(false)
        local array = ccArrayMake(CCDelayTime:create(i * 0.1), CCCallFunc:create(function()
          icon:setVisible(true)
        end), CCEaseElasticOut:create(CCScaleTo:create(0.4, 0.62)))
        icon:runAction(CCSequence:create(array))
        oldTime = i * 0.1
        self:btRegisterButtonClick({
          button = icon,
          key = "winItem" .. i,
          clickHandler = function()
            ed.UITool.openView("packageDetail", v)
          end,
          force = true,
          mcpMode = true,
          pressScale = 0.55,
          normalScale = 0.62
        })
      end
      self:listenTimer(Timer:Once(oldTime), function()
        local items = self.data.loseItems
        local localposx = 340 - 22 * #items
        label = ed.createLabelTools({
          txt = T("\229\164\177\232\180\165\229\165\150\229\138\177"),
          size = 18,
          color = ccc3(216, 239, 255),
          parent = itemBjImg,
          scale = 1.9
        })
        label:setPosition(ccp(localposx - label:getContentSize().width / 2, 32))
        label:runAction(CCEaseBackOut:create(CCScaleTo:create(0.5, 1)))
        for i, v in ipairs(items) do
          local icon = ed.createItemIcon(v)
          icon:setPosition(localposx + i * 55, 32)
          itemBjImg:addChild(icon)
          icon:setScale(0.1)
          icon:setVisible(false)
          local array = ccArrayMake(CCDelayTime:create(i * 0.1), CCCallFunc:create(function()
            icon:setVisible(true)
          end), CCEaseElasticOut:create(CCScaleTo:create(0.4, 0.62)))
          icon:runAction(CCSequence:create(array))
          self:btRegisterButtonClick({
            button = icon,
            key = "loseItem" .. i,
            clickHandler = function()
              ed.UITool.openView("packageDetail", v)
            end,
            force = true,
            mcpMode = true,
            pressScale = 0.55,
            normalScale = 0.62
          })
        end
      end)
    end)
  end)
  
  local function createButtonFunc(res, str, pos, callBack)
    local buttBjImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      pos = pos
    })
    ed.createSpriteTools({
      res = res,
      pos = ccp(33, 33),
      parent = buttBjImg
    })
    local label = ed.createttf(str, 17)
    label:setPosition(33.5, 5)
    label:setColor(ccc3(253, 241, 189))
    label:setStroke(ccc3(0, 0, 0), 1)
    ed.adaptLabel(label, {maxWidth = 80})
    buttBjImg:addChild(label)
    self:btRegisterButtonClick({
      button = buttBjImg,
      key = str,
      clickHandler = function()
        callBack()
      end,
      force = true,
      mcpMode = true,
      pressScale = 0.95
    })
    return buttBjImg
  end
  
  self:listenTimer(Timer:Once(1), function()
    local buttBjImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/guild/guild_clash_battleinfo/battleinfo_thorns_bottom.png",
      pos = ccp(posx + 370, posy + 28),
      parent = bjLayer
    })
    buttBjImg:runAction(CCMoveBy:create(0.4, ccp(92, 0)))
    buttBjImg:addChild(createButtonFunc("UI/alpha/1080P/pvp/record.png", T("\231\142\169\230\179\149"), ccp(68, 234), function()
      ed.UITool.openView("guildClashGameGuideWin")
    end))
    buttBjImg:addChild(createButtonFunc("UI/alpha/1080P/crusade/icon_hot.png", T("\232\181\155\231\168\139"), ccp(68, 164), function()
      ed.UITool.openView("guildClashCourseWin")
    end))
    buttBjImg:addChild(createButtonFunc("UI/alpha/1080P/toparena/toparena_report_icon.png", nextBattleTime() and T("\228\184\138\232\189\174\230\136\152\230\138\165") or T("\230\136\152\230\138\165"), ccp(68, 94), function()
      if getEndTimeFuns() then
        ed.UITool.openView("guildClashResultWin")
      else
        ed.GuildClashNetwork:sendQueryBattleSummary()
      end
    end))
  end)
end

function guildClashBattlePop:initEdui()
  local timeStr, s = ed.GuildClashManager:getNextPrepareBegin()
  local timeTxt = self.ui.Label_time
  self.ui.Label_time:setString(T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182:%s", timeStr))
  if s <= 0 then
    timeTxt:setString(T("\229\133\172\228\188\154\230\136\152\229\183\178\231\187\147\230\157\159"))
  elseif s < 3601 then
    self:listenTimer(Timer:Always(1), function()
      if not s then
        return
      end
      s = s - 1
      if s <= 0 then
        timeStr, s = ed.GuildClashManager:getNextPrepareBegin()
        if s <= 0 then
          s = nil
          timeTxt:setString(T("\229\133\172\228\188\154\230\136\152\229\183\178\231\187\147\230\157\159"))
        else
          if 3600 < s then
            s = nil
          end
          timeTxt:setString(T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182:%s", timeStr))
        end
      else
        timeTxt:setString(T("\231\187\147\230\157\159\229\128\146\232\174\161\230\151\182:%s", ed.time2dhms(s)))
      end
    end)
  end
  self.ui.Label_warZone:setString(T(self.data.zone_str))
  local label_title = ed.ui.gradientLabel.create({
    text = T("\229\133\172\228\188\154\230\136\152-\231\172\172%d\232\189\174\229\175\185\230\136\152", ed.clamp(self.data.round, 1, 99)),
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776366),
    endColor = ed.toccc3(16495744),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(2887950)
  })
  self.ui.title_pos:addChild(label_title.node)
  self.ui.Label_706:setFontName(ed.fontBold)
  self.ui.Label_706:setStroke(ed.toccc3(12750365), 1.2)
  self.ui.Label_706:setShadow(ccc3(39, 40, 34), ccp(0, 4))
  self.ui.Label_706_2:setFontName(ed.fontBold)
  self.ui.Label_706_2:setStroke(ed.toccc3(12750365), 1.2)
  self.ui.Label_706_2:setShadow(ccc3(39, 40, 34), ccp(0, 4))
  if self.data.self_guild_summary then
    local data = self.data.self_guild_summary
    self.ui.Label_win_left:setFontName(ed.fontBold)
    self.ui.Label_win_left:setStroke(ed.toccc3(4609612), 1.2)
    self.ui.Label_win_left:setShadow(ccc3(39, 40, 34), ccp(0, 4))
    self.ui.Label_win_left:setString(T("%s\232\131\156%s\232\180\159", data.win_cnt, data.lose_cnt))
    data = self.data.self_guild_summary.guild_summary
    self.ui.Label_guild_name_left:setString(T(data._name))
    self.ui.Label_team_num_left:setString(T(data._member_cnt))
    self.ui.Label_leader_left:setString(T(""))
    local name = ed.getPlayerName(data._chairman, data._medal, {
      anchorPoint = ccp(0, 0.5)
    })
    ed.UITool.replaceUI(self.ui, "ImageView_306_left", "Label_leader_left", name)
    name:setScale(0.87)
    ed.right2(self.ui.Label_leader_left, self.ui.Label_309_Copy0_left, 2)
    ed.right2(self.ui.Label_team_num_left, self.ui.Label_309_left, 2)
    self.ui.Label_server_left:setString(T(self.data.self_guild_summary.svr_name))
    local avatarData = ed.analyzeAvatar(data._avatar or 1)
    local hand = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
    hand:setPosition(275, 50)
    hand:setScale(1.1)
    self.ui.ImageView_306_left:addChild(hand)
  else
    self.ui.Label_win_left:setVisible(false)
    self.ui.Label_server_left:setVisible(false)
    self.ui.ImageView_306_left:setVisible(false)
    self.ui.Panel_left_nil:setVisible(true)
  end
  if self.data.oppo_guild_summary then
    local data = self.data.oppo_guild_summary
    self.ui.Label_win_right:setFontName(ed.fontBold)
    self.ui.Label_win_right:setStroke(ed.toccc3(4609612), 1.2)
    self.ui.Label_win_right:setShadow(ccc3(39, 40, 34), ccp(0, 4))
    self.ui.Label_win_right:setString(T("%s\232\131\156%s\232\180\159", data.win_cnt, data.lose_cnt))
    data = self.data.oppo_guild_summary.guild_summary
    self.ui.Label_guild_name_right:setString(T(data._name))
    self.ui.Label_team_num_right:setString(T(data._member_cnt))
    self.ui.Label_leader_right:setString(T(""))
    local name = ed.getPlayerName(data._chairman, data._medal, {
      anchorPoint = ccp(0, 0.5)
    })
    ed.UITool.replaceUI(self.ui, "ImageView_306_right", "Label_leader_right", name)
    name:setScale(0.87)
    ed.right2(self.ui.Label_leader_right, self.ui.Label_309_Copy0_right, 2)
    ed.right2(self.ui.Label_team_num_right, self.ui.Label_309_right, 2)
    self.ui.Label_server_right:setString(T(self.data.oppo_guild_summary.svr_name))
    local avatarData = ed.analyzeAvatar(data._avatar or 1)
    local hand = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
    hand:setPosition(65, 50)
    hand:setScale(1.1)
    self.ui.ImageView_306_right:addChild(hand)
  else
    self.ui.Label_win_right:setVisible(false)
    self.ui.Label_server_right:setVisible(false)
    self.ui.ImageView_306_right:setVisible(false)
    self.ui.Panel_right_nil:setVisible(true)
  end
  local posx = ed.display.winSize.width / 2 - 30
  local posy = ed.display.winSize.height / 2
  self.ui.Panel_bottom:setVisible(false)
  self:listenTimer(Timer:Once(0.1), function()
    local newWid = ed.display.halfFixedWidth
    local newHei = ed.display.halfFixedHeight
    local bookSpr = CCLayer:create()
    local itemBjImg = ed.createSpriteTools({
      res = "UI/alpha/1080P/guild/guild_clash_battleinfo/battleinfo_award_background.png",
      pos = ccp(0, -170),
      parent = bookSpr
    })
    bookSpr:setPosition(posx - newWid, posy - newHei)
    self.container:addChild(bookSpr, 999)
    itemBjImg:setOpacity(0)
    itemBjImg:runAction(CCFadeTo:create(0.7, 255))
    local oldTime = 0
    self:listenTimer(Timer:Once(0.2), function()
      local items = self.data.winItems
      local localposx = 340 - 22 * #items
      local label = ed.createLabelTools({
        txt = T("\232\131\156\229\136\169\229\165\150\229\138\177"),
        size = 18,
        color = ccc3(252, 237, 202),
        parent = itemBjImg,
        scale = 1.9
      })
      label:setPosition(ccp(localposx - label:getContentSize().width / 2, 84))
      label:runAction(CCEaseBackOut:create(CCScaleTo:create(0.5, 1)))
      for i, v in ipairs(items) do
        local icon = ed.createItemIcon(v)
        icon:setPosition(localposx + i * 55, 84)
        itemBjImg:addChild(icon)
        icon:setScale(0.1)
        icon:setVisible(false)
        local array = ccArrayMake(CCDelayTime:create(i * 0.1), CCCallFunc:create(function()
          icon:setVisible(true)
        end), CCEaseElasticOut:create(CCScaleTo:create(0.4, 0.62)))
        icon:runAction(CCSequence:create(array))
        oldTime = i * 0.1
        self:btRegisterButtonClick({
          button = icon,
          key = "winItem" .. i,
          clickHandler = function()
            ed.UITool.openView("packageDetail", v)
          end,
          force = true,
          mcpMode = true,
          pressScale = 0.55,
          normalScale = 0.62
        })
      end
      self:listenTimer(Timer:Once(oldTime), function()
        local items = self.data.loseItems
        local localposx = 340 - 22 * #items
        label = ed.createLabelTools({
          txt = T("\229\164\177\232\180\165\229\165\150\229\138\177"),
          size = 18,
          color = ccc3(216, 239, 255),
          parent = itemBjImg,
          scale = 1.9
        })
        label:setPosition(ccp(localposx - label:getContentSize().width / 2, 32))
        label:runAction(CCEaseBackOut:create(CCScaleTo:create(0.5, 1)))
        for i, v in ipairs(items) do
          local icon = ed.createItemIcon(v)
          icon:setPosition(localposx + i * 55, 32)
          itemBjImg:addChild(icon)
          icon:setScale(0.1)
          icon:setVisible(false)
          local array = ccArrayMake(CCDelayTime:create(i * 0.1), CCCallFunc:create(function()
            icon:setVisible(true)
          end), CCEaseElasticOut:create(CCScaleTo:create(0.4, 0.62)))
          icon:runAction(CCSequence:create(array))
          self:btRegisterButtonClick({
            button = icon,
            key = "loseItem" .. i,
            clickHandler = function()
              ed.UITool.openView("packageDetail", v)
            end,
            force = true,
            mcpMode = true,
            pressScale = 0.55,
            normalScale = 0.62
          })
        end
      end)
    end)
  end)
  self:btRegisterButtonClick({
    button = self.ui.ImageView_711,
    key = "close",
    clickHandler = function()
      self:destroy({skipAnim = false, actionTime = 0.5})
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_btn_1,
    key = "ImageView_btn_1",
    clickHandler = function()
      ed.UITool.openView("guildClashGameGuideWin")
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_btn_2,
    key = "ImageView_btn_2",
    clickHandler = function()
      ed.UITool.openView("guildClashCourseWin")
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_btn_3,
    key = "ImageView_btn_3",
    clickHandler = function()
      if getEndTimeFuns() then
        ed.UITool.openView("guildClashResultWin")
      else
        ed.GuildClashNetwork:sendQueryBattleSummary()
      end
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.95
  })
  self.ui.Label_353:setString(nextBattleTime() and T("\228\184\138\232\189\174\230\136\152\230\138\165") or T("\230\136\152\230\138\165"))
  ed.adaptLabel(self.ui.Label_353, {maxWidth = 80, minScale = 0.8})
end
