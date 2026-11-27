module("ed.battleprepare", package.seeall)
MultiTeamView = {}
MultiTeamView.__index = MultiTeamView
max_team = 3

function MultiTeamView:create(param)
  local obj = {}
  setmetatable(obj, self)
  local scene = UIView:create(param)
  obj:init(scene, param)
  return scene, obj
end

function MultiTeamView:init(scene, param)
  self.scene = scene
  self.param = param or {}
  self.current_team_index = 1
  self.teams_herosid = {
    {},
    {},
    {}
  }
  self.teams_herosIcon = {
    {},
    {},
    {}
  }
  scene.channel:setTagVisible(false)
  scene.enterbattle:setVisible(false)
  self:registerHandler()
  self.teamChannel = TeamChannel:create(param)
  scene:addChild(self.teamChannel)
  self.buttomBG = self:createButtomBG()
  scene.buttom:addChild(self.buttomBG.layer)
  self:registerWaitEvent()
end

function MultiTeamView:registerHandler()
  local scene = self.scene
  scene:getController():setAddMemberCallBack(function(hid)
    self:addCallBack(hid)
  end)
  scene:getController():setRemoveMemberCallBack(function(hid)
    self:deleteCallback(hid)
  end)
  scene:getController():setAddMemberAffirmHandler(function(hid, callback)
    self:addAffirm(hid, callback)
  end)
  scene.pool.presetPool:setClickConfirm(function(callback, list)
    self:presetConfirmHandler(callback, list)
  end)
end

function MultiTeamView:presetConfirmHandler(callback, list)
  local hasOtherTeamHero
  for i = 1, #list.heroes do
    local hid = list.heroes[i]
    local row, index = self:findHeroTeam(hid)
    if row and row ~= self.current_team_index then
      hasOtherTeamHero = true
      break
    end
  end
  if hasOtherTeamHero then
    ed.showToast(T("\233\131\168\229\136\134\232\139\177\233\155\132\229\156\168\229\133\182\228\187\150\233\152\159\228\188\141\228\184\173\239\188\140\228\184\141\229\143\175\228\189\191\231\148\168\232\175\165\233\152\181\229\174\185"))
    return
  else
    callback()
  end
end

function MultiTeamView:addCallBack(hid)
  local scene = self.scene
  SendEvent("selectHero", scene:getController():getModel():getHeroNum())
  scene.pool.heroPool:changeHeroTeam(hid, self.current_team_index)
  table.insert(self.teams_herosid[self.current_team_index], hid)
  self:refreshPresetView(scene.channel:getCurrentChannel())
end

function MultiTeamView:deleteCallback(hid)
  local scene = self.scene
  SendEvent("selectHero", scene:getController():getModel():getHeroNum())
  self.scene.pool.heroPool:RemoveTeamInfo(hid)
  local row, index = self:findHeroTeam(hid)
  if row then
    table.remove(self.teams_herosid[row], index)
  end
  self:refreshPresetView(scene.channel:getCurrentChannel())
end

function MultiTeamView:addAffirm(hid, callback)
  local team, index = self:findHeroTeam(hid)
  if not team or team == self.current_team_index then
    callback()
  else
    local function confirmhandler()
      table.remove(self.teams_herosid[team], index)
      
      table.remove(self.teams_herosIcon[team], index)
      callback()
    end
    
    local hero_name = T(ed.player:getHero(hid):getDisplayName())
    local info = {
      text = T("%s\229\183\178\231\187\143\229\156\168\229\133\182\228\187\150\233\152\159\228\188\141\228\184\173\239\188\140\230\152\175\229\144\166\231\167\187\229\138\168\229\136\176\232\191\153\230\148\175\233\152\159\228\188\141\239\188\159", hero_name),
      rightHandler = confirmhandler
    }
    ed.showConfirmDialog(info)
  end
end

function MultiTeamView:multiPreload(teamList)
  if not teamList then
    return
  end
  for team_index, list in ipairs(teamList) do
    SendEvent("selectHero", #list, team_index)
    for index, heroid in ipairs(list) do
      self.scene.pool.heroPool:changeHeroTeam(heroid, team_index)
      table.insert(self.teams_herosid[team_index], heroid)
      local node = ed.readhero.createIconByID(heroid, {state = "idle"})
      local tpos = Buttom:getTeamMemberPos(index)
      node.icon:setPosition(tpos)
      node.icon:setVisible(false)
      local temp = {
        bg = node.icon,
        hid = heroid
      }
      self.scene.buttom.layer:addChild(node.icon, 30)
      table.insert(self.teams_herosIcon[team_index], temp)
    end
  end
  self:recoverCurrentHero()
  local gs = self.scene:getController():getModel():getTeamGS()
  self.scene.buttom:setLabelContent(gs)
end

function MultiTeamView:findHeroTeam(hid)
  for k, list in ipairs(self.teams_herosid) do
    for i, heroid in ipairs(list) do
      if heroid == hid then
        return k, i
      end
    end
  end
  return nil
end

function MultiTeamView:registerWaitEvent()
  WaitEvent("changeSelectTeam", function(team_index)
    self:changeSelectTeam(team_index)
    self:refreshPresetView(self.scene.channel:getCurrentChannel())
  end)
  WaitEvent("changeChannel", function(channel)
    self:refreshPresetView(channel)
  end)
  WaitEvent("clearAllSelectHero", function()
    self:clearCurrentTeamAllSelectHero()
  end)
  WaitEvent("onEnter", function()
    self:multiPreload(self.param.multiPreload)
  end)
end

function MultiTeamView:clearCurrentTeamAllSelectHero()
  for k, hid in ipairs(self.teams_herosid[self.current_team_index]) do
    self.scene.pool.heroPool:RemoveTeamInfo(hid)
  end
  self.teams_herosid[self.current_team_index] = {}
  for k, temp in ipairs(self.teams_herosIcon[self.current_team_index]) do
    if not tolua.isnull(temp.bg) then
      temp.bg:removeFromParentAndCleanup(true)
    end
  end
  self.teams_herosIcon[self.current_team_index] = {}
end

function MultiTeamView:refreshPresetView(channel)
  if channel ~= presetTeam then
    return
  end
  local heroIconList = self.scene.pool.presetPool:getHeroIconList()
  local temp = {}
  for k, list in ipairs(self.teams_herosid) do
    for i, hid in ipairs(list) do
      temp[hid] = k
    end
  end
  for row, list in ipairs(heroIconList) do
    for k, node in ipairs(list) do
      if temp[node.hid] then
        local row = temp[node.hid]
        if row == self.current_team_index then
          node.icon:showSelectTag()
        else
          node.icon:deleteSelectTag()
        end
        node.icon:addTeamInfo({team_index = row})
      else
        node.icon:deleteSelectTag()
        node.icon:RemoveTeamInfo()
      end
    end
  end
end

function MultiTeamView:changeSelectTeam(team_index)
  self:refreshTeamButton(team_index)
  self:savePreTeamHero()
  self.current_team_index = team_index
  self:recoverCurrentHero()
  local gs = self.scene:getController():getModel():getTeamGS()
  self.scene.buttom:setLabelContent(gs)
  for k = 1, max_team do
    self.buttomBG.ui[T("team_bg_light_%s", k)]:setVisible(team_index == k)
  end
end

function MultiTeamView:savePreTeamHero()
  self.teams_herosid[self.current_team_index] = {}
  self.teams_herosIcon[self.current_team_index] = {}
  local herolist = self.scene:getController():getModel():getSelectList()
  local heroPool = self.scene.pool.heroPool
  for k, hid in ipairs(herolist) do
    heroPool:removeHero(hid)
    heroPool:changeHeroTeam(hid, self.current_team_index)
    table.insert(self.teams_herosid[self.current_team_index], hid)
  end
  self.scene:getController():getModel():clearAll()
  local herosIconList = self.scene.buttom.lockedHeroList
  self.teams_herosIcon[self.current_team_index] = ed.copyTable(herosIconList)
  for k, temp in ipairs(self.teams_herosIcon[self.current_team_index]) do
    temp.bg:setVisible(false)
  end
  self.scene.buttom.lockedHeroList = {}
end

function MultiTeamView:recoverCurrentHero()
  local model = self.scene:getController():getModel()
  model:clearAll()
  local heroPool = self.scene.pool.heroPool
  local herosid = self.teams_herosid[self.current_team_index]
  for k, hid in ipairs(herosid) do
    model:addMember(hid)
    heroPool:addHero(hid)
  end
  self.scene.buttom.lockedHeroList = ed.copyTable(self.teams_herosIcon[self.current_team_index])
  local buttonList = self.scene.buttom.lockedHeroList
  for k, temp in ipairs(buttonList) do
    local tpos = Buttom:getTeamMemberPos(k)
    temp.bg:setVisible(true)
    temp.bg:setPosition(tpos)
  end
end

function MultiTeamView:refreshTeamButton(team_index)
  self.scene.enterbattle:setVisible(team_index == max_team)
  self.teamChannel:setNextTeamVisible(team_index ~= max_team)
end

function MultiTeamView:getHerosList()
  return self.teams_herosid
end

function MultiTeamView:createButtomBG()
  local buttomBG = {}
  local layer = CCLayer:create()
  local ui = {}
  local readNode = ed.readnode.create(layer, ui)
  readNode:addNode(self:getUiInfo())
  buttomBG.layer = layer
  buttomBG.ui = ui
  ui.team_bg_light_1:setVisible(true)
  return buttomBG
end

function MultiTeamView:getUiInfo()
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "team_bg_light_1",
        res = "UI/alpha/HVGA/top_pvp/team_1_select_light.png",
        z = 1
      },
      layout = {
        position = ccp(392, 62)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_light_2",
        res = "UI/alpha/HVGA/top_pvp/team_2_select_light.png",
        z = 1
      },
      layout = {
        position = ccp(392, 62)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_light_3",
        res = "UI/alpha/HVGA/top_pvp/team_3_select_light.png",
        z = 1
      },
      layout = {
        position = ccp(392, 62)
      },
      config = {visible = false}
    }
  }
  return ui_info
end
