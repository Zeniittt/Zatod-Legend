local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.vcdLayer = class
local ed = ed
local vcdPanel, currentAccessory, currentMode, currentStageId, currentExrtaUIInfo
local base = ed.ui.basescene

local function initPlayer(medal, player, name, level, result, heros, icon, vip, dyna, teamIdx)
  local sIcon = player .. "Icon"
  local sLevel = player .. "Level"
  local sName = player .. "Name"
  local sResult = player .. "Result"
  local labelResult = player .. "LabelResult"
  local parent = player .. "NameBg"
  local bShowBaseInfo = currentMode ~= "quest"
  if bShowBaseInfo then
    local head = ed.getHeroIconByID({
      id = icon,
      vip = 0 < (vip or 0)
    })
    if head then
      vcdPanel.pvpLayer[sIcon]:removeAllChildrenWithCleanup(true)
      head:setScale(0.6)
      vcdPanel.pvpLayer[sIcon]:addChild(head)
    end
  end
  if bShowBaseInfo then
    ed.setString(vcdPanel.pvpLayer[sLevel], tostring(level))
  else
    vcdPanel.pvpLayer[player .. "LevelBg"]:setVisible(false)
    vcdPanel.pvpLayer[sLevel]:setVisible(false)
  end
  if bShowBaseInfo then
    if player == "left" then
      local name = ed.getPlayerName(name, medal, {
        anchorPoint = ccp(0, 0.5)
      })
      ed.UITool.replaceUI(vcdPanel.pvpLayer, player .. "NameBg", sName, name)
    else
      local name = ed.getPlayerName(name, medal, {
        anchorPoint = ccp(1, 0.5),
        medalRight = true
      })
      name:setScaleX(-1)
      ed.UITool.replaceUI(vcdPanel.pvpLayer, player .. "NameBg", sName, name)
    end
  else
    vcdPanel.pvpLayer[player .. "NameBg"]:setVisible(false)
    vcdPanel.pvpLayer[sName]:setVisible(false)
  end
  local effectName = result == "victory" and "UI/alpha/1080P/crusade/icon_win.png" or "UI/alpha/1080P/crusade/icon_defead.png"
  if teamIdx then
    effectName = string.format("UI/alpha/HVGA/stargate/stargate_tab_team%d.png", teamIdx)
  end
  local frame = ed.getSpriteFrame(effectName)
  if frame then
    vcdPanel.pvpLayer[sResult]:initWithSpriteFrame(frame)
  end
  if result == "victory" then
    ed.setLabelColor(vcdPanel.pvpLayer[labelResult], ed.toccc3(16774293))
    ed.setLabelStroke(vcdPanel.pvpLayer[labelResult], ed.toccc3(1335817), 1)
    ed.setString(vcdPanel.pvpLayer[labelResult], T("\232\131\156"))
  else
    ed.setLabelColor(vcdPanel.pvpLayer[labelResult], ed.toccc3(16763825))
    ed.setLabelStroke(vcdPanel.pvpLayer[labelResult], ed.toccc3(6168596), 1)
    ed.setString(vcdPanel.pvpLayer[labelResult], T("\232\180\165"))
  end
  vcdPanel.pvpLayer[labelResult]:limitWidthByScale(20)
  for i = 1, 5 do
    local hero = string.format("%sHero%d", player, i)
    vcdPanel.pvpLayer[hero]:removeAllChildrenWithCleanup(true)
  end
  if heros then
    ed.readhero.sortIDByRange(heros, function(tab)
      return tab._tid
    end)
    for i, v in ipairs(heros) do
      local hero = string.format("%sHero%d", player, i)
      local hp
      if dyna and dyna[i] then
        hp = dyna[i]._hp_perc
      end
      local legendInfo
      if v._legend_equip then
        legendInfo = v._legend_equip and v._legend_equip._equip
      else
        legendInfo = nil
      end
      local heroIcon = ed.readhero.createIcon({
        id = v._tid,
        rank = v._rank,
        hp = hp,
        level = v._level,
        stars = v._stars,
        fashion_id = v._fashion,
        summary = v,
        legendEquip = legendInfo
      })
      heroIcon.icon:setScale(0.75)
      heroIcon:showLegendEquip(not ed.openLegendEquip())
      vcdPanel.pvpLayer[hero]:addChild(heroIcon.icon)
    end
  end
end

local function showPvp(data)
  if nil == data then
    return
  end
  vcdPanel.pvpLayer.pvpBg:setPositionX(ed.display.winSize.width / 2)
  local leftResult = data._result
  local rightResult
  if leftResult == "victory" then
    rightResult = "defeat"
  elseif leftResult == "defeat" then
    rightResult = "victory"
  end
  if leftResult == "honest" then
    leftResult = "victory"
    rightResult = "defeat"
  end
  if leftResult == "timeout" then
    leftResult = "defeat"
    rightResult = "victory"
  end
  if currentMode == "cupArena" or currentMode == "peakArena" then
    local leftAvatar = data._self_user._avatar ~= 0 and data._self_user._avatar or 1
    local rightAvatar = data._oppo_user._avatar ~= 0 and data._oppo_user._avatar or 1
    initPlayer(data._self_user._medal, "left", data._self_user._name, data._self_user._level, leftResult, data._self_heroes, leftAvatar, data._self_user._vip, data._self_dynas, data._self_tid)
    initPlayer(data._oppo_user._medal, "right", ed.transBotName(data._oppo_user._name), data._oppo_user._level, rightResult, data._oppo_heroes, rightAvatar, data._oppo_user._vip)
    return
  end
  local leftAvatar = data._avatar ~= 0 and data._avatar or 1
  local rightAvatar = data._oppo_avatar ~= 0 and data._oppo_avatar or 1
  initPlayer(data._self_medal, "left", data._username, data._level, leftResult, data._self_heroes, leftAvatar, data._vip, data._self_dynas, data._self_tid)
  initPlayer(data._oppo_medal, "right", ed.transBotName(data._oppo_name), data._oppo_level, rightResult, data._oppo_heroes, rightAvatar, data._oppo_vip, data._oppo_dynas, data._oppo_tid)
end

class.showPvp = showPvp

local function showPve(data)
  vcdPanel.pveLayer.pvpBg:setPositionX(ed.display.winSize.width / 2)
  local avatar = data._avatar ~= 0 and data._avatar or 1
  local headIcon = ed.getHeroIconByID({id = avatar})
  headIcon:setAnchorPoint(ccp(0.5, 0.5))
  headIcon:setPosition(ccp(94, 66))
  headIcon:setScale(1.2)
  vcdPanel.log:addChild(headIcon)
  local name = ed.getPlayerName(data._username, data._self_medal, {
    anchorPoint = ccp(0, 0.5)
  })
  name:setPosition(160, 84)
  vcdPanel.log:addChild(name)
  ed.createLabelTools({
    txt = T("\233\128\160\230\136\144\228\188\164\229\174\179\239\188\154%s", math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))),
    anchor = ccp(0, 0.5),
    size = 16,
    pos = ccp(180, 44),
    color = ccc3(255, 252, 231),
    parent = vcdPanel.log
  })
end

local function showPveByCreviceDefend(data)
  vcdPanel.pveLayer.pvpBg:setPositionX(ed.display.winSize.width / 2)
  local self_data = data._self_user
  local avatar = self_data._avatar ~= 0 and self_data._avatar or 1
  local headIcon = ed.getHeroIconByID({id = avatar})
  headIcon:setAnchorPoint(ccp(0.5, 0.5))
  headIcon:setPosition(ccp(94, 66))
  headIcon:setScale(1.2)
  vcdPanel.log:addChild(headIcon)
  local name = ed.getPlayerName(self_data._name, data._self_medal, {
    anchorPoint = ccp(0, 0.5)
  })
  name:setPosition(160, 84)
  vcdPanel.log:addChild(name)
  ed.createLabelTools({
    txt = T("\233\128\160\230\136\144\228\188\164\229\174\179\239\188\154%s", math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))),
    anchor = ccp(0, 0.5),
    size = 16,
    pos = ccp(180, 44),
    color = ccc3(255, 252, 231),
    parent = vcdPanel.log
  })
end

local function showData()
  if ed.engine.unit_list then
    ed.netdata.pvpQuerySummaryReply = {}
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, currentMode or "common", true)
  end
end

class.showData = showData

local function create()
  local currentScene = ed.getCurrentScene()
  if currentScene and currentScene.identity == "battle" then
    if nil == currentAccessory then
      return
    end
    if not vcdPanel then
      if currentMode == "dreamland" then
        vcdPanel = panelMeta:new2(class, EDTables.vcdConfig.PveUIRes)
        currentScene.scene:addChild(vcdPanel:getRootLayer(), 300)
        showPve(currentAccessory)
      elseif currentMode == "crevicedefend" then
        vcdPanel = panelMeta:new2(class, EDTables.vcdConfig.PveUIRes)
        currentScene.scene:addChild(vcdPanel:getRootLayer(), 300)
        showPveByCreviceDefend(currentAccessory)
      else
        vcdPanel = panelMeta:new2(class, EDTables.vcdConfig.UIRes)
        currentScene.scene:addChild(vcdPanel:getRootLayer(), 300)
        showPvp(currentAccessory)
      end
    end
  end
end

class.create = create

local function setData(data, mode, stage_id, extra_ui_info)
  if nil == data then
    return
  end
  data = ed.copyProto(data)
  currentAccessory = data
  currentMode = mode
  currentStageId = stage_id
  currentExrtaUIInfo = extra_ui_info
end

class.setData = setData

local function release()
  vcdPanel = nil
  currentAccessory = nil
end

local function showReplay()
  ed.popScene()
  if currentMode == "dreamland" then
    ed.dreamland.network_mgr:showDreamlandReply(currentAccessory, currentMode, currentStageId, currentExrtaUIInfo)
  elseif currentMode == "real_pvp" then
    ed.realarena.RealArenaMgr.showReplay(currentAccessory, currentStageId)
  elseif currentMode == "crevicedefend" then
    ed.CreviceDefendBattleManager:showReply(currentAccessory, currentStageId)
  else
    ed.showReplay(currentAccessory, currentMode, currentStageId, currentExrtaUIInfo)
  end
  vcdPanel = nil
end

class.showReplay = showReplay

local function closePvp()
  ed.popScene()
  release()
end

class.closePvp = closePvp
