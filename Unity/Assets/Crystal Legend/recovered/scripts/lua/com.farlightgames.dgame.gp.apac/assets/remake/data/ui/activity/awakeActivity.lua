local class = {}
class.__index = class
local ed = ed
local pairs = pairs
local scope = {}
local maxLeftTime = 20
ed.ui.awakeActivity = class
local aContentClass = ed.ui.activityContent
local aFrame = ed.ui.activityBase
local rnum = 1

local function outOfTime(b_time, e_time)
  if b_time > ed.getServerTime() or e_time < ed.getServerTime() then
    return true
  end
end

function class:isEnd()
  return ed.getServerTime() > self.e_time
end

function class:getPrizeReply()
  local function handler(replys)
    CloseScope(scope)
    
    aContentClass.doClickPrizeReply(replys)
    local k = ed.netdata.reward_index
    local data = self.boardList[k].data
    data._dailyjob._last_rewards_time = ed.getServerTime()
    self:createContent()
    ed.netdata.reward_index = nil
  end
  
  return handler
end

function class:createFlyLayer(config)
  self:destroyFlyLayer()
  local showPanel = aFrame.createFlyLayer(config)
  showPanel:setAnchorPoint(ccp(0.3, 0))
  if config.index > 3 then
    showPanel:setAnchorPoint(ccp(0.5, 0))
  end
  showPanel:setPosition(ccp(0, 30))
  self.flyLayer = showPanel
end

function class:destroyFlyLayer()
  if not tolua.isnull(self.flyLayer) then
    self.flyLayer:removeFromParentAndCleanup(true)
    self.flyLayer = nil
  end
end

function class:doPressInList()
  local function handler(x, y)
    for k, board in pairs(self.boardList) do
      if k > rnum then
        local button = board.ui.ticket_button
        
        if ed.containsPoint(button, x, y) and button:isVisible() then
          return k
        end
      else
        local bg = board.ui.board_bg
        local button = board.ui.reward_button
        local button_press = board.ui.reward_button_press
        local ts = self.rewardlist
        for i, reward in pairs(ts) do
          if ed.containsPoint(reward.item, x, y) then
            local config = {
              parent = reward.item,
              index = i,
              id = reward.id
            }
            self:createFlyLayer(config)
            return k
          end
        end
        if button:isVisible() and ed.containsPoint(button, x, y) then
          self.clickRewardButton = true
          button_press:setVisible(true)
          return k
        end
        if ed.containsPoint(bg, x, y) then
          bg:setScale(0.95)
          return k
        end
      end
    end
  end
  
  return handler
end

function class:setAvatarReply()
  local function handler()
    CloseScope(scope)
    
    if not ed.netdata.index then
      return
    end
    for k = rnum + 1, #self.boardList do
      self:resetTicketListUI(k)
    end
    ed.netdata.index = nil
  end
  
  return handler
end

local function setAvatar(self, id, k)
  ed.ui.selectwindow.ofavatar:doSendSet(id, true)
  ed.netdata.index = k
  ListenEvent("setAvatarReply", self:setAvatarReply(), scope)
end

function class:doClickInTicketList(x, y, k)
  if outOfTime(self.b_time, self.e_time) then
    ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\144\175"))
    return
  end
  local data = self.boardList[k].data
  local id = data._id or 1
  local info = {
    text = T("\230\152\175\229\144\166\231\161\174\229\174\154\230\138\138\229\164\180\229\131\143\230\141\162\230\136\144\232\175\165\232\139\177\233\155\132\231\154\132\229\164\180\229\131\143"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      xpcall(function()
        setAvatar(self, id, k)
      end, EDDebug)
    end
  }
  ed.showConfirmDialog(info)
end

function class:doClickInList()
  local function handler(x, y, k)
    if k > rnum then
      self:doClickInTicketList(x, y, k)
    else
      self:doClickInRewarList(x, y, k)
    end
  end
  
  return handler
end

function class:cancelPress(x, y, k)
  local ui = self.boardList[k].ui
  self:destroyFlyLayer()
  if k > rnum then
  else
    local bg = ui.board_bg
    bg:setScale(1)
    if self.clickRewardButton then
      local button = ui.reward_button
      local press = ui.reward_button_press
      button:setVisible(true)
      press:setVisible(false)
    end
  end
end

function class:cancelPressInList()
  local function handler(x, y, k)
    self:cancelPress(x, y, k)
  end
  
  return handler
end

function class:cancelClickInList()
  local function handler(x, y, k)
    self:cancelPress(x, y, k)
  end
  
  return handler
end

function class:leftTimes(data)
  local amount = data._amount
  local target = data._dailyjob._task_target
  local trans = data._extra_reward_info._trans._trans
  local dt = data._extra_reward_info._trans._amount
  local leftTime = math.floor((target - amount) / (trans * dt)) + 1
  local gap = math.ceil((amount - target) / trans)
  local minLeftTime = maxLeftTime - amount / (trans * dt) + 1
  return math.min(leftTime, minLeftTime), gap
end

function class:resetRewardListUI(index)
  local ui = self.boardList[index].ui
  local data = self.boardList[index].data
  local leftTime, gap = self:leftTimes(data)
  self:createHeroDes(ui.title_1, T("\229\143\175\232\142\183\229\190\151\228\187\165\228\184\139\233\129\147\229\133\183\228\185\139\228\184\128:"))
  if 0 < leftTime then
    ui.reward_button:setVisible(true)
    self:createHeroDes(ui.left_label, T("\229\137\169\228\189\153\233\162\134\229\165\150:"))
    local px = ui.left_label:getPositionX()
    ui.left_label:setPositionX(px + 20)
    self:createHeroDes(ui.left_time, leftTime, 2, ui.left_label)
    ui.left_time_des:setVisible(false)
  else
    ui.reward_button:setVisible(false)
    self:createHeroDes(ui.left_label, T("\229\134\141\232\180\161\231\140\174\228\186\186\230\176\148"))
    local px = ui.left_label:getPositionX()
    local py = ui.left_label:getPositionY()
    ui.left_label:setPosition(ccp(px + 25, py - 15))
    self:createHeroDes(ui.left_time, gap)
    ed.below2(ui.left_time, ui.left_label, 5)
    px = ui.left_time:getPositionX()
    ui.left_time:setPositionX(px - 65)
    self:createHeroDes(ui.left_time_des, T("\229\143\175\233\162\134\229\165\150"), 2, ui.left_time)
  end
  if self:isEnd() and leftTime == 0 then
    ui.reward_button:setVisible(false)
    ui.left_label:setVisible(false)
    ui.left_time_des:setVisible(false)
    ed.setString(ui.left_time, T("\230\180\187\229\138\168\231\187\147\230\157\159"))
    ui.left_time:setPosition(ccp(320, 50))
  end
end

function class:createItemList(parent, data)
  local x, y, dt = 73, 22, 35
  self.rewardlist = self.rewardlist or {}
  local ts = self.rewardlist
  for k, reward in pairs(data or {}) do
    local node = CCSprite:create()
    node:setContentSize(CCSizeMake(30, 30))
    local item = ed.readequip.createIcon(reward, 30)
    item:setAnchorPoint(ccp(0, 0))
    node:setPosition(ccp(x + k * dt, y))
    node:addChild(item)
    parent:addChild(node)
    local temp = {item = node, id = reward}
    table.insert(ts, temp)
  end
end

function class:rewardsAddItem(k)
  local ui = self.boardList[k].ui
  local data = self.boardList[k].data
  if data._rewards then
    local id = data._rewards[1]._id
    self:createItemIcon(ui.icon, id)
    local uTypeValue
    local row = ed.getEquipRow(id)
    local name = row.Name
    self:createHeroDes(ui.title, name, nil, nil, true)
    if row["Use Type"] == "Open Chest Combination ID" then
      uTypeValue = row["Use Type Variable"]
    end
    local cComb = ed.getChestColumn(uTypeValue, "Item Set")
    self:createItemList(ui.board_bg, cComb)
  end
  self:resetRewardListUI(k)
end

function class:createNormalList(config, data, k)
  local dt = 98
  local fix = self.listbegainheight - 50
  local container, ui = ed.editorui(config)
  ui.board_bg:setPositionY(fix - (k - 1) * dt)
  local temp = {ui = ui, data = data}
  table.insert(self.boardList, temp)
  return container, ui
end

function class:createRewardList()
  local layer = self.mainLayer
  local index = 0
  for k, data in ipairs(self.reward_list) do
    if data._dailyjob._last_rewards_time == 0 then
      index = k
      break
    end
  end
  if index == 0 then
    rnum = 0
    return
  end
  local data = self.reward_list[index]
  local config = ed.uieditor.awakeActivityRewardList
  local container, ui = self:createNormalList(config, data, rnum)
  self:rewardsAddItem(rnum)
  layer:addChild(container)
end

function class:createTicketList(layer)
  local layer = self.mainLayer
  local tnum = #self.option_list
  for k = rnum + 1, rnum + tnum do
    local data = self.option_list[k - rnum] or {}
    local config = ed.uieditor.awakeActivityTicketList
    local container, ui = self:createNormalList(config, data, k)
    self:resetTicketListUI(k)
    layer:addChild(container)
  end
  local height = 108 * (rnum + tnum) + 350 - self.listbegainheight
  self.ticket_list_height = height
  self.draglist:initListHeight(height)
end

local function formatTickets(ticket)
  if ticket < 10000 then
    return ticket
  else
    return string.format("%s\228\184\135", math.floor(ticket / 10000))
  end
end

function class:getAwakeSkillName(id)
  local name = ""
  local skills = ed.getAllSkills(id)
  for k, skill in pairs(skills) do
    local hname = skill["Caster Name"]
    local sname = skill["Skill Name"]
    if sname == T("%s_awake", hname) then
      return skill["Display Name"]
    end
  end
end

function class:getAwakeItenName(id)
  local name = ""
  local eids = ed.getHeroTaskCsvEquipid(id)
  if eids ~= 0 then
    name = ed.getEquipColumn(eids, "Name")
  end
  return name
end

function class:createRanking(ui, index)
  local rank = index - rnum
  if not self:isEnd() then
    return
  end
  if 3 < rank then
    return
  end
  local res = {
    "UI/alpha/1080P/common/pvp_rank_1st.png",
    "UI/alpha/1080P/common/pvp_rank_2nd.png",
    "UI/alpha/1080P/common/pvp_rank_3rd.png"
  }
  local rnode = ed.createSprite(res[rank])
  rnode:setPosition(ccp(340, 35))
  ui.board_bg:addChild(rnode)
end

function class:createItemIcon(parent, id, quality, addition)
  local icon = ed.readequip.createIcon(id, 80)
  icon:setPosition(ccp(22, 18))
  parent:removeAllChildrenWithCleanup(true)
  parent:addChild(icon)
end

function class:createHeroDes(label, text, offset, refer, shadow)
  ed.setString(label, text)
  if shadow then
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
  end
  if offset then
    ed.right2(label, refer, offset)
  end
end

function class:getAvatarKey(key)
  local at = ed.getDataTable("Avatar")
  for k, v in pairs(at) do
    if v["Requirement ID"] == key and v["Requirement Type"] == "HeroRank" then
      return k
    end
  end
  return key
end

function class:resetTicketListUI(k)
  if not k then
    return
  end
  local data = self.boardList[k].data
  local id = data._id
  local ui = self.boardList[k].ui
  local icon = ed.readhero.getIcon({
    id = id,
    length = 75,
    rank = 12,
    awake = ed.canAwake(id)
  })
  icon:setPosition(ccp(20, 20))
  ui.icon:removeAllChildrenWithCleanup(true)
  ui.icon:addChild(icon)
  local hname = ed.getDisplyName(id)
  self:createHeroDes(ui.hero_name, hname)
  local sname = self:getAwakeSkillName(id)
  self:createHeroDes(ui.skill_name, sname, 2, ui.awake_skill)
  local iname = self:getAwakeItenName(id)
  self:createHeroDes(ui.item_name, iname, 2, ui.awake_item)
  if ed.canAwake(id) then
    ui.is_awake:setVisible(true)
    ui.not_awake:setVisible(false)
  else
    ui.is_awake:setVisible(false)
    ui.not_awake:setVisible(false)
  end
  self:createHeroDes(ui.awake_skill, T("\232\167\137\233\134\146\230\138\128\232\131\189:"))
  self:createHeroDes(ui.awake_item, T("\232\167\137\233\134\146\228\184\147\229\177\158\232\163\133\229\164\135:"))
  self:createRanking(ui, k)
  if outOfTime(self.b_time, self.e_time) then
    local popu = formatTickets(data._tickets or 0)
    self:createHeroDes(ui.popu_title, T("\230\128\187\228\186\186\230\176\148:"))
    self:createHeroDes(ui.popu_num, popu, 2, ui.popu_title)
    ui.popu_num:setColor(ccc3(68, 170, 54))
    ui.ticket_button_support:setVisible(false)
    ui.ticket_button:setVisible(false)
  else
    self:createHeroDes(ui.popu_num, formatTickets(data._supports or 0))
    local avatar_id = ed.player:getAvatarId()
    if avatar_id == self:getAvatarKey(id) then
      ui.ticket_button_support:setVisible(true)
      ui.ticket_button:setVisible(false)
    else
      ui.ticket_button_support:setVisible(false)
      ui.ticket_button:setVisible(true)
    end
  end
end

function class:getPrize(index)
  local data = self.boardList[index].data
  local times = self:leftTimes(data)
  if times == 0 then
    if self:isEnd() then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
      return
    end
    if outOfTime(self.b_time, self.e_time) then
      ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\144\175"))
      return
    end
  end
  local msg = ed.upmsg.job_rewards()
  msg._job = data._dailyjob._id
  ed.netreply.awakeActivity = true
  ed.netdata.reward_index = index
  ListenEvent("awakeActivity", self:getPrizeReply(), scope)
  ed.send(msg, "job_rewards")
end

function class:openItemDes(index)
  local data = self.boardList[index].data
  local id = data._rewards[1]._id
  local config = {
    context = "handbook",
    drop = "activity",
    eid = id
  }
  local craftLayer = ed.ui.equipcraft.create(config)
  aContentClass.getRunScene():addChild(craftLayer.mainLayer, 600)
end

function class:doClickInRewarList(x, y, k)
  self:destroyFlyLayer()
  local ui = self.boardList[k].ui
  local data = self.boardList[k].data
  local bg = ui.board_bg
  local button = ui.reward_button
  local button_press = ui.reward_button_press
  bg:setScale(1)
  if self.clickRewardButton then
    button:setVisible(true)
  end
  button_press:setVisible(false)
  local ts = self.rewardlist
  for i, reward in pairs(ts) do
    if ed.containsPoint(reward.item, x, y) then
      return
    end
  end
  if self.clickRewardButton then
    self.clickRewardButton = nil
    self:getPrize(k)
  else
    self:openItemDes(k)
  end
end

function class:createDList()
  local draglistInfo = {
    cliprect = CCRectMake(17, 65, 417, 295),
    rect = CCRectMake(20, 65, 410, 295),
    container = self.frameUi.a_frame,
    priority = -140,
    noshade = true,
    swallow = false,
    bar = {
      bglen = 280,
      bgpos = ccp(15, 216)
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  local dlist = ed.draglist.create(draglistInfo)
  local layer = CCLayer:create()
  self.mainLayer = layer
  dlist:addItem(layer)
  self.draglist = dlist
end

function class:createActivityContent()
  local layer = self.mainLayer
  self.ui = self.ui or {}
  local ui_info = self.ui_info
  local readNode = ed.readnode.create(layer, self.ui)
  readNode:addNode(ui_info)
  local ui = self.ui
  local dt = 20
  local top = 350
  ui.ui_title:setPosition(ccp(35, top))
  ui.ui_time:setPosition(ccp(35, top - dt))
  ui.ui_des:setPosition(ccp(35, top - 2 * dt))
  ui.ui_content:setPosition(ccp(35, top - 3 * dt))
  ui.ui_time:setString(string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(self.b_time), ed.formatTime(self.e_time)))
  ui.ui_content:setString(self.content)
  local cheight = ui.ui_content:getContentSize().height
  self.listbegainheight = ui.ui_content:getPositionY() - cheight
end

function class:createList()
  self:createRewardList()
  self:createTicketList()
end

function class:createContent()
  self.mainLayer:removeAllChildrenWithCleanup(true)
  self.boardList = {}
  self:createActivityContent()
  self:createList()
end

function class:initWindow()
  local ui = {}
  self.container, ui = ed.editorui(ed.uieditor.awakeActivityFrame)
  self.frameUi = ui
  self:createHeroDes(ui.a_title, self.info._title, nil, nil, true)
  self:createHeroDes(ui.total_pop, T("\232\180\161\231\140\174\228\186\186\230\176\148\230\128\187\229\128\188\239\188\154"), nil, nil, true)
  self:createHeroDes(ui.total_num, formatTickets(self.total_pop or 0), nil, nil, true)
  self:createDList()
  self:createContent()
end

local function totoalTickets(option_list)
  local total_tickets = 0
  for k, hero_pop in pairs(option_list) do
    total_tickets = total_tickets + (hero_pop._supports or 0)
  end
  return total_tickets
end

local function formatBarTags(info)
  local temp = {}
  for k, v in pairs(info) do
    local text = string.format("%s\228\184\135", v / 10000)
    table.insert(temp, text)
  end
  return temp
end

function class:initData(info)
  local info = info or {}
  self.info = info
  self.b_time = info._start_time
  self.e_time = info._end_time
  local extra_info = info._extra_info or {}
  self.option_list = extra_info._hero_pop or {}
  self.total_pop = totoalTickets(self.option_list)
  if self:isEnd() then
    table.sort(self.option_list, function(a, b)
      return a._tickets > b._tickets
    end)
  end
  self.reward_list = info._rewards or {}
  self.content = info._desc or ""
end

function class:create(info)
  local object = {}
  setmetatable(object, self)
  object:initData(info)
  object:initWindow()
  return object
end

class.ui_info = {
  {
    t = "Label",
    base = {
      name = "ui_title",
      text = T("\230\180\187\229\138\168\230\151\182\233\151\180:"),
      fontinfo = "dark_yellow1"
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, -170)
    },
    config = {}
  },
  {
    t = "Label",
    base = {
      name = "ui_time",
      text = T("2015\229\185\1807\230\156\1362\230\151\1655\230\151\182-2015\229\185\1807\230\156\1362\230\151\1655\230\151\182"),
      fontinfo = "dark_white4"
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, -25)
    },
    config = {}
  },
  {
    t = "Label",
    base = {
      name = "ui_des",
      text = T("\230\180\187\229\138\168\229\134\133\229\174\185:"),
      fontinfo = "dark_yellow1"
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, -50)
    },
    config = {}
  },
  {
    t = "Label",
    base = {
      name = "ui_content",
      text = T(""),
      fontinfo = "dark_white4"
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(20, -70)
    },
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(390, 0)
    }
  }
}
