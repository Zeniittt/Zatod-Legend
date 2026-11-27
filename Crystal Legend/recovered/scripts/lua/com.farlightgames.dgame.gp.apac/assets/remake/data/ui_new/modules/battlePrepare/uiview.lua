module("ed.battleprepare", package.seeall)
local base = ed.ui.basescene
UIView = newclass(base.mt)
UIView.__index = UIView
local lsr = ed.ui.battlepreparepeakarenalsr.create()
local eventScope = {}

function UIView:create(param)
  local obj = base.create("battlePrepare")
  setmetatable(obj, self)
  obj:init(param)
  return obj
end

function UIView:release()
  self.ui = {}
  self:getController():Return()
  EventStack:pop()
  CloseScope(eventScope)
end

function UIView:init(param)
  local eventProxy = EventList:new()
  EventStack:push(eventProxy)
  self.controller = Controller:create(param.data)
  self.ui = {}
  self:initWindow()
  self.pool = UIPool:create(self, param.pool)
  self.SystemType = param.pool.type
  self.channel = Channel:create(self, param.channel)
  self.rButton = Return:create(self)
  self.buttom = Buttom:create(self)
  self.enterbattle = EnterBattle:create(self, param.enterbattle)
  self.enemyHeros = EnemyHeros:create(self)
  self:addChild(self.pool)
  self:addChild(self.enemyHeros)
  self:addChild(self.channel)
  self:addChild(self.rButton)
  self:addChild(self.enterbattle)
  self:addChild(self.buttom)
  self:registerEventHandler()
end

function UIView:initWindow()
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(self:getUiInfo())
end

function UIView:addChild(child)
  self.mainLayer:addChild(child:getView())
end

function UIView:onEnter()
end

function UIView:onExit()
end

function UIView:onPop()
  self.mainLayer:setTouchEnabled(false)
  self:release()
end

function UIView:preLoad()
  local list = self.controller:getModel():getPreList()
  local forbidListHash = self.controller:getModel():getForbidListHash()
  local maxNum = self.controller:getModel():getMaxNum()
  local index = 1
  self:getController():setCanEnterBattle(false)
  
  local function handler()
    if not self.pool:isLoadEnd() then
      return
    end
    if #list == 0 then
      self.pool.heroPool:enableClick(true)
      self:removeUpdateHandler("preloadTeam")
      self:getController():setCanEnterBattle(true)
      return
    end
    if not self.buttom:isMove() then
      local hid = list[index]
      local model = self.controller:getModel()
      if not forbidListHash[hid] and not model:teamWithHero(hid) and model:isHeroExist(hid) then
        local index = self:getController():addMember(hid)
        self:addHero(hid, index, true)
      end
      if index == math.min(#list, maxNum) then
        self.pool.heroPool:enableClick(true)
        self:removeUpdateHandler("preloadTeam")
        self:getController():setCanEnterBattle(true)
      else
        index = index + 1
      end
    end
  end
  
  return handler
end

function UIView:registerEventHandler()
  self:registerOnEnterHandler("onenter", function()
    self:onEnter()
  end)
  self.mainLayer:setTouchEnabled(true)
  self.mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  self:registerOnExitHandler("onexit", function()
    self:onExit()
  end)
  self:registerUpdateHandler("preloadTeam", self:preLoad())
  self:registerOnPopSceneHandler("onPop", function()
    self:onPop()
  end)
  ListenEvent("refresh_stage_recommend_reply", function()
    self:doRecommendReply()
  end, eventScope)
  ListenEvent("MercenaryAlready", function(info)
    self:doMercenaryReply(info)
  end, eventScope)
  ListenEvent("HireMercenarySuccess", function()
    self:doHireMercenarySuccessReply()
  end, eventScope)
  WaitEvent("clearAllSelectHero", function()
    self:getController():getModel():clearAll()
  end)
  WaitEvent("popScene", function()
    ed.popScene()
  end)
end

function UIView:doRecommendReply()
  self.pool:doRecommendReply()
end

function UIView:doMercenaryReply(info)
  self.pool:doMercenaryReply(info)
  self.controller:initMercenaryMode(info)
end

function UIView:doHireMercenarySuccessReply()
  self.controller:doHireMercenarySuccessReply()
end

function UIView:doMainLayerTouch()
  local function handler(event, x, y)
    xpcall(function()
      SendEvent("mainTouch", event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

function UIView:addHero(hid, index, notAnim)
  local pos = self.pool.heroPool:getHeroIconPos(hid)
  SendEvent("addHeroWithId", hid, pos, index, notAnim)
  SendEvent("addMemberCallBack", hid)
end

function UIView:removeHero(hid, index, notAnim)
  local pos = self.pool.heroPool:getHeroIconPos(hid)
  SendEvent("removeHeroWithId", hid, pos, index, notAnim)
  SendEvent("removeMemverCallBack", hid)
end

function UIView:addMercenary(hid, index)
  local pos = self.pool.mercenary:getHeroIconPos(hid)
  SendEvent("addMercenaryWithId", hid, pos, index)
  SendEvent("addMemberCallBack", hid)
end

function UIView:removeMercenary(hid, index)
  local pos = self.pool.mercenary:getHeroIconPos(hid)
  SendEvent("removeMercenaryWithId", hid, pos, index)
  SendEvent("addMemberCallBack", hid)
end

function UIView:clickHero(hid, notaddsound, notAnim)
  if self.buttom:isVisible() and self.buttom:isMove() then
    return
  end
  local msg = self:getController():clickHeroWithId(hid)
  if msg == "repet" then
    ed.showToast(T("\229\144\140\229\144\141\232\139\177\233\155\132\228\184\141\232\131\189\229\144\140\230\151\182\228\184\138\229\156\186"))
  elseif msg == "remove" then
    if not notaddsound then
      lsr:clickHeadRemoveHero()
    end
    local index = self:getController():removeMember(hid)
    self:removeHero(hid, index, notAnim)
  elseif msg == "full" then
    if not notaddsound then
      lsr:clickAddHeroTeamFilled()
    end
    ed.showToast(T("\233\152\159\228\188\141\228\186\186\230\149\176\229\183\178\232\190\190\228\184\138\233\153\144"))
    SendEvent("teamIsFull")
  elseif msg == "forbid" then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\231\166\129\230\173\162\228\184\138\229\156\186"))
  elseif msg == "first" then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\229\135\186\231\142\176\229\134\141\233\166\150\229\143\145\233\152\159\228\188\141\233\135\140"))
  elseif msg == "dead" then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\233\152\181\228\186\161"))
  elseif msg == "dispatch" then
    ed.showToast(T("\230\180\190\233\129\163\229\144\141\233\162\157\229\183\178\231\148\168\229\176\189\239\188\140\230\151\160\230\179\149\230\180\190\233\129\163\230\150\176\232\139\177\233\155\132\229\135\186\230\136\152"))
  elseif msg == "own" then
    ed.showToast(T("\232\191\152\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
  elseif msg == "add" then
    local function handler()
      if not notaddsound then
        lsr:report("clickAddHero", {hid = hid})
      end
      local index = self:getController():addMember(hid)
      self:addHero(hid, index, notAnim)
    end
    
    if self.controller.addMemberAffirm then
      self.controller.addMemberAffirm(hid, handler)
    else
      handler()
    end
  elseif msg == "mustadd" then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\191\133\233\161\187\228\184\138\229\156\186"))
  end
end

function UIView:clickMercenary(hid)
  if self.buttom:isVisible() and self.buttom:isMove() then
    return
  end
  local msg = self:getController():clickMercenaryWithId(hid)
  print("clickMercenary---> msg", msg)
  if msg == "repet" then
    ed.showToast(T("\229\144\140\229\144\141\232\139\177\233\155\132\228\184\141\232\131\189\229\144\140\230\151\182\228\184\138\229\156\186"))
  elseif msg == "remove" then
    local index = self:getController():removeMercenary(hid)
    self:removeMercenary(hid, index)
  elseif msg == "full" then
    ed.showToast(T("\233\152\159\228\188\141\228\186\186\230\149\176\229\183\178\232\190\190\228\184\138\233\153\144"))
  elseif msg == "mercenary" then
    ed.showToast(T("\228\184\128\229\156\186\230\136\152\230\150\151\229\143\170\232\131\189\233\155\135\228\189\163\228\184\128\228\189\141\232\139\177\233\155\132"))
  elseif msg == "dispatch" then
    ed.showToast(T("\230\180\190\233\129\163\229\144\141\233\162\157\229\183\178\231\148\168\229\176\189\239\188\140\230\151\160\230\179\149\230\180\190\233\129\163\230\150\176\232\139\177\233\155\132\229\135\186\230\136\152"))
  elseif msg == "isHired" then
    ed.showToast(T("\228\189\160\228\187\138\229\164\169\229\183\178\231\187\143\233\155\135\228\189\163\232\191\135\232\191\153\228\184\170\231\142\169\229\174\182\231\154\132\228\189\163\229\133\181"))
  elseif msg == "levelLimit" then
    local limitlevel = ed.player:getLevel() + ed.getDataTable("VIP")[ed.player:getvip()]["Hire Hero Level Limit"]
    ed.showToast(T("\228\184\141\232\131\189\233\155\135\228\189\163\231\173\137\231\186\167\232\182\133\232\191\135%d\231\154\132\228\189\163\229\133\181", limitlevel))
  elseif msg == "add" then
    local function handler()
      print("clickMercenary--->1111", hid)
      
      local index = self:getController():addMercenary(hid)
      self:addMercenary(hid, index)
    end
    
    if self.controller.addMemberAffirm then
      self.controller.addMemberAffirm(hid, handler)
    else
      handler()
    end
  elseif msg == "mustadd" then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\191\133\233\161\187\228\184\138\229\156\186"))
  end
end

function UIView:getController()
  return self.controller
end

function UIView:getUiInfo()
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/1080P/common/bg.jpg"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    }
  }
  return ui_info
end
