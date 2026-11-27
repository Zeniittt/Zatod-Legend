local base = ed.ui.popwindow
local SkinDetailWin = newclass(base.mt)
ed.ui.SkinDetailWin = SkinDetailWin

function SkinDetailWin.create(param)
  local self = base.create("SkinDetailWin")
  setmetatable(self, SkinDetailWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function SkinDetailWin:initData(param)
  self.param = param
end

function SkinDetailWin:initLabels()
  ed.setString(self.ui.Label_754, T("\229\142\187\232\142\183\229\143\150"))
  ed.setLabelShadow(self.ui.Label_754, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(self.ui.skin_name, ed.toccc3(1315346), 1)
  ed.setLabelStroke(self.ui.label_got, ed.toccc3(4601379), 1)
end

function SkinDetailWin:initUI()
  ed.editorui(ed.uieditor.skinDetailPop, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local fashion_id = self.param.fashionId
  local heroId = ed.lookupDataTable("Fashion", "Hero ID", fashion_id)
  local ress = ed.getFashionFrameRes(fashion_id, "nameFrame")
  if ress then
    ed.setTexture(self.ui.bg_skin_name, ress)
  end
  self.ui.skin_name:setString(ed.lookupDataTable("Fashion", "Name", fashion_id))
  self.hid = heroId
  self.fashion = fashion_id
  local card = ed.readhero.getHeroCard(heroId, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = fashion_id or 0
  }, {
    index = 1,
    _tid = heroId,
    _stars = 2,
    _level = 1,
    _rank = 1,
    _items = {}
  })
  local card_ui = card.container
  card_ui:setScale(0.99)
  card_ui:setZOrder(2)
  self.ui.bg:addChild(card_ui)
  card_ui:setPosition(7, -11)
  self.ui.skin_card = card_ui
  for _, effect_fca in pairs(card.card_fashion_effect or {}) do
    self:addFca(effect_fca)
  end
  for _, plist in pairs(card.fashion_plist_res or {}) do
    self:addFca(plist)
  end
  local puppet, puppet_id, cha = ed.readhero.getActor(heroId, "Idle", true, false, fashion_id, false)
  local row = ed.getDataTable("Puppet")[puppet_id]
  local scale = row.Scale
  local wscale = row["Window Scale"]
  if wscale ~= 0 then
    scale = row.Scale * wscale
  end
  puppet:setScale(scale)
  puppet:setPosition(ccp(self.ui.bg_mid:getContentSize().width / 2, 200))
  self.ui.bg_mid:addChild(puppet, 10)
  self:addFca(puppet)
  self.puppet = puppet
  self.cha = cha
  self.action_pre = "Idle"
  self:btRegisterRectClick({
    rect = CCRectMake(230, 165, 140, 195),
    parent = self.ui.bg_skin,
    key = "skin_touch",
    clickHandler = function()
      self:changeFcaAction(nil, true)
    end,
    force = true
  })
  self:checkFashionState()
end

function SkinDetailWin:checkFashionState()
  local itemId = ed.getDataTable("Fashion")[self.param.fashionId]["Item ID"]
  local got = ed.player:getEquipAmount(itemId) > 0
  self.ui.btn_get:setVisible(not got)
  self.ui.tipbg:setVisible(got)
end

function SkinDetailWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:removeUpdateHandler("checkFcaHandler")
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_get", function()
    if self.param.clickCallBack then
      self:removeUpdateHandler("checkFcaHandler")
      base.destroy(self, {skipAnim = true})
      self.param.clickCallBack()
    end
  end, {pressScale = 0.95})
end

local lsr = ed.heroDetailManager.listener.create()

function SkinDetailWin:changeFcaAction(name, with_sound)
  if with_sound == nil then
    with_sound = true
  end
  local action, duration = self:changeAction(name)
  if with_sound then
    lsr:report("clickHeroFca", {
      hid = self.hid,
      action = action,
      fashionId = self.fashion
    })
  end
  self:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(action, duration))
end

function SkinDetailWin:checkFcaHandler(action, duration)
  local time = 0
  
  local function handler(dt)
    time = time + dt
    if action ~= "Move" and time > duration then
      self.puppet:setAction("Idle")
      self.puppet:setLoop(true)
      self:removeUpdateHandler("checkFcaHandler")
    end
  end
  
  return handler
end

function SkinDetailWin:changeAction(name)
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.hid]
  local can_show_action_tbl = {"Move"}
  for idx, skill_item in pairs(skill_items or {}) do
    for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
      if string.find(action, "special") == nil then
        can_show_action_tbl[#can_show_action_tbl + 1] = action
      end
    end
  end
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(actions, k)
        table.insert(dur, v.Duration)
      end
    elseif ed.isElementInTable(k, can_show_action_tbl) and k ~= self.action_pre then
      table.insert(actions, k)
      table.insert(dur, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #actions)
  end
  local action = actions[index]
  self.action_pre = action
  self.duration = dur[index]
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  return action, self.duration
end
