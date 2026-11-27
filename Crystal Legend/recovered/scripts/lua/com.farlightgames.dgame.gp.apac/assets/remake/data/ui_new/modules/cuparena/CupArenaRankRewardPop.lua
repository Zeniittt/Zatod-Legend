local base = ed.ui.popwindow
local CupArenaRankRewardPop = newclass(base.mt)
ed.ui.CupArenaRankRewardPop = CupArenaRankRewardPop
ed.UITool.registViewOpenFunc("CupArenaRankRewardPop", function(param)
  if param.page and param.page == "rank" then
    local currentTime = ed.getServerTime()
    local season = ed.CupArenaManager:getCurrentSeason() or 1
    season = 0 < season and season or 1
    local openTimeStr = ed.getDataTable("CupArenaSeason")[season]["Open Time"]
    local openTime = ed.dateStringToTime(openTimeStr)
    if currentTime < openTime + 43200 then
      return ed.showToast(T("%s\229\144\142\229\188\128\230\148\190\230\159\165\231\156\139\230\142\146\232\161\140\230\166\156", ed.time2dhms(openTime + 43200 - currentTime)))
    end
  end
  ed.ui.CupArenaRankRewardPop.create(param or {}):popWindow()
end)

function CupArenaRankRewardPop.create(params)
  local self = base.create("CupArenaRankRewardPop", {notBlurBg = true})
  setmetatable(self, CupArenaRankRewardPop.mt)
  self.params = params
  self:initUieditor()
  self:registEvents()
  self:show()
  return self
end

function CupArenaRankRewardPop:initUieditor()
  self.pageInfo = self.pages[self.params.page or "rank"]
  self.btnInfo = self.btns[self.params.page or "rank"]
  self.index = self.params.index or 1
  self.season = ed.CupArenaManager:getCurrentSeason() or 1
  self.newData = {}
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg.png",
      pos = ccp(480, 310),
      parent = self.container
    })
  }
  ui.close = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/knockout/select_result_quit_button.png",
    pos = ccp(810, 450),
    parent = ui.bg
  })
  ui.title = ed.ui.gradientLabel.create({
    text = "",
    fontSize = 28,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16711611),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(14910002)
  })
  ui.title.node:setPosition(ccp(428.25, 463))
  ui.bg:addChild(ui.title.node)
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_rank_zone.png",
    pos = ccp(428.25, 425),
    parent = ui.bg
  })
  ed.createLabelTools({
    txt = T("\232\181\155\229\140\186\239\188\154\231\172\172%s\232\181\155\229\140\186", ed.CupArenaManager:getZoneId() or 0),
    size = 18,
    pos = ccp(82.5, 13),
    color = ed.toccc3(16711610),
    stroke = {
      ed.toccc3(5389618),
      1
    },
    parent = bg,
    anchor = ccp(0.5, 0.5)
  })
  ui.label = ed.createLabelTools({
    txt = self.pageInfo.txt,
    size = 17,
    pos = ccp(428.25, 383),
    color = ed.toccc3(16575857),
    parent = ui.bg,
    stroke = {
      ed.toccc3(5584393),
      1.3
    }
  })
  self.listLayer = ed.createCCLayer({
    pos = ccp(82.25, 23),
    sizeMake = CCSizeMake(692, 339),
    parent = ui.bg
  })
  self:createDragList(self.listLayer)
  self.buttonLayer = ed.createCCLayer({
    pos = ccp(866.5, 260),
    sizeMake = CCSizeMake(100, 300),
    parent = ui.bg
  })
  self.addLayer = ed.createCCLayer({
    parent = ui.bg
  })
  self.ui = ui
  local noClick
  for index, number in ipairs(self.pageInfo.btn) do
    ui["number_button_" .. index] = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_tab_1.png",
      pos = ccp(856.5, 445 - index * 58),
      parent = ui.bg,
      z = -1
    })
    ed.createLabelTools({
      txt = T(number),
      size = 20,
      pos = ccp(52.25, 23.75),
      color = ed.toccc3(16709098),
      parent = ui["number_button_" .. index],
      stroke = {
        ed.toccc3(5324350),
        1.3
      }
    })
    ui["number_button_selected_" .. index] = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_tab_2.png",
      pos = ccp(856.5, 445 - index * 58),
      parent = ui.bg,
      notShow = self.index ~= index,
      z = -1
    })
    ed.createLabelTools({
      txt = T(number),
      size = 20,
      pos = ccp(52.25, 23.75),
      color = ed.toccc3(5189672),
      parent = ui["number_button_selected_" .. index],
      stroke = {
        ed.toccc3(15854038),
        1.3
      }
    })
    self:btRegisterButtonClick({
      button = ui["number_button_" .. index],
      selected = ui["number_button_selected_" .. index],
      key = "number" .. index,
      radioGroupName = "number",
      extraCheckHandler = function(x, y)
        if noClick and ed.containsPoint(noClick, x, y) and (ed.CupArenaManager:getScheduleId() or 0) <= 4 then
          ed.showToast(T("\229\183\133\229\179\176\232\181\155\229\176\154\230\156\170\229\188\128\229\144\175"))
          return false
        end
        return true
      end,
      clickHandler = function()
        self.index = index
        self:refreshPage()
      end
    })
    if self.index == index then
      self:refreshPage()
    end
    if self.params.page == "rank" and number == T("\229\183\133\229\179\176\232\181\155") and not noClick then
      noClick = ui["number_button_" .. index]
    end
    if self.btnInfo[self.pageInfo.btn[index]].redFun then
      local red = ed.createSpriteTools({
        res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
        pos = ccp(898.5, 445 - index * 58 + 10),
        parent = ui.bg,
        z = 9
      })
      self.btnInfo[self.pageInfo.btn[index]].redImg = red
      red:setVisible(self.btnInfo[self.pageInfo.btn[index]].redFun())
    end
  end
end

function CupArenaRankRewardPop:refreshPage()
  self.selfRank = nil
  self.rankListBtnsDragList = nil
  self:btRemoveMainTouchHandler({key = "listBg"})
  self:btRemoveMainTouchHandler({key = "rank_btn"})
  local data = self.btnInfo[self.pageInfo.btn[self.index]]
  self.ui.title:setString(data.title)
  self.newData = data
  if data.txt then
    self.ui.label:setString(data.txt)
  else
    self.ui.label:setString(self.pageInfo.txt)
  end
  self.addLayer:removeAllChildrenWithCleanup(true)
  if data.addUieditor then
    data.addUieditor(self)
  end
  if data.network and #data.getListInfo(self) == 0 then
    self.oldIndex = self.index
    self.newData.item = nil
    data.network()
  else
    self:refreshDragList(data)
    if data.refreshUieditor then
      data.refreshUieditor(self, data)
    end
  end
end

function CupArenaRankRewardPop:createDragList(container)
  local thisCon = container:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = container,
    noshade = true,
    priority = -300,
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.dragList = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self.thisCon = thisCon
end

function CupArenaRankRewardPop:refreshDragList(data)
  self.items = {}
  self.dragList:clearList()
  local moveY
  local posy = self.thisCon.height - 5
  if data.asyncCreate then
    self.dragList.listLayer:setPositionY(0)
    local index = 1
    local info = data.getListInfo(self)
    self:registerUpdateHandler("CupArenaRankRewardPopListCreate", function()
      if not info[index] then
        self:removeUpdateHandler("CupArenaRankRewardPopListCreate")
        self.dragList:initListHeight(posy * -1 + self.thisCon.height + 5)
        if moveY and moveY < 0 then
          self.dragList.listLayer:setPositionY(moveY * -1)
        end
        return
      end
      local v = info[index]
      local item = data.module.new(self, v, nil, index)
      self.dragList:addItem(item.ui.bg, ccp(self.thisCon.width / 2, posy - item.height / 2))
      posy = posy - item.height
      table.insert(self.items, item)
      if item.highlight then
        moveY = posy
      end
      index = index + 1
    end)
  else
    for i, v in ipairs(data.getListInfo(self)) do
      local item = data.module.new(self, v, nil, i)
      self.dragList:addItem(item.ui.bg, ccp(self.thisCon.width / 2, posy - item.height / 2))
      posy = posy - item.height
      table.insert(self.items, item)
      if item.highlight then
        moveY = posy
      end
    end
    self.dragList:initListHeight(posy * -1 + self.thisCon.height + 5)
    if moveY and moveY < 0 then
      self.dragList.listLayer:setPositionY(moveY * -1)
    end
  end
end

function CupArenaRankRewardPop:registEvents()
  self:btRegisterOutClick({
    area = {
      self.ui.bg,
      self.buttonLayer
    },
    key = "out_click",
    clickHandler = function()
      self:removeUpdateHandler("CupArenaRankRewardPopListCreate")
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.close,
    key = "close",
    pressScale = 0.96,
    clickHandler = function()
      self:removeUpdateHandler("CupArenaRankRewardPopListCreate")
      self:destroy({skipAnim = false})
    end
  })
  self:listenEvent("req_home_page", function(data)
    ed.ui.PlayerInfoPanel.create(data, false):popWindow()
  end)
  
  local function func(data)
    if self.oldIndex == self.index then
      local info = self.btnInfo[self.pageInfo.btn[self.index]]
      if info.setListInfo then
        info.setListInfo(self, data)
      end
      self.rankListBtnsDragList = nil
      if info.refreshUieditor then
        info.refreshUieditor(self, data)
      end
      self:refreshDragList(info)
    end
  end
  
  self:listenEvent("EventCupArenaUserRankboard", function(data)
    func(data)
  end)
  self:listenEvent("EventCupArenaCampRankboard", function(data)
    func(data)
  end)
  self:listenEvent("EventCupArenaMatchRankboard", function(data)
    func(data)
  end)
  self:listenEvent("EventCupArenaOpenCampReward", function(data)
    func(data)
  end)
  self:listenEvent("EventHandleRewardData", function(data)
    func(data)
  end)
  self:listenEvent("EventCupArenaMedalReward", function(data)
    self:listenTimer(Timer:Once(0.1), function()
      func(data)
    end)
  end)
  self:listenEvent("EventCupArenaMedalRewardRed", function()
    for i, v in ipairs(self.pageInfo.btn) do
      if self.btnInfo[self.pageInfo.btn[i]].redFun then
        self.btnInfo[self.pageInfo.btn[i]].redImg:setVisible(self.btnInfo[self.pageInfo.btn[i]].redFun())
      end
    end
  end)
end

function CupArenaRankRewardPop:doPressInList()
  local function handler(x, y)
    if self.selfRank and self.selfRank.ui.bg then
      self.selfRank.ui.bg:setVisible(false)
    end
    for _, v in pairs(self.items or {}) do
      if v.ui.hand and ed.containsPoint(v.ui.hand, x, y) then
        v.ui.hand:setScale(0.75)
        return {
          icon = v.ui.hand,
          fun = function()
            local summary = v.param._user_summary
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end,
          normalScale = 0.8
        }
      elseif v.ui.giftBtn and v.ui.gift:isVisible() and ed.containsPoint(v.ui.giftBtn, x, y) then
        v.ui.giftBtn:setScale(1.05)
        return {
          icon = v.ui.giftBtn,
          fun = function()
            ed.CupArenaNetwork:sendMedalReward(v.param.id)
          end,
          normalScale = 1.1
        }
      elseif v.ui.notBtn and not v.ui.pass:isVisible() and ed.containsPoint(v.ui.notBtn, x, y) then
        v.ui.notBtn:setScale(1.05)
        return {
          icon = v.ui.notBtn,
          fun = function()
            ed.showToast(T("\230\156\170\229\174\140\230\136\144"))
          end,
          normalScale = 1.1
        }
      end
      if v.items and (nil == v.ui.itemLayer or ed.containsPoint(v.ui.itemLayer, x, y)) then
        for ii, vv in ipairs(v.items) do
          if ed.containsPoint(vv, x, y) then
            vv:setScale(0.75)
            return {
              icon = vv,
              fun = function()
                ed.UITool.openView("packageDetail", v.param.rewards[ii])
              end,
              normalScale = 0.7
            }
          end
        end
      end
    end
    return {}
  end
  
  return handler
end

function CupArenaRankRewardPop:cancelPressInList()
  local function handler(x, y, info)
    if self.selfRank and self.selfRank.ui.bg then
      self.selfRank.ui.bg:setVisible(true)
    end
    if info.icon then
      info.icon:setScale(info.normalScale or 1)
    end
  end
  
  return handler
end

function CupArenaRankRewardPop:cancelClickInList()
  local function handler(x, y, info)
    if info.icon then
      info.icon:setScale(info.normalScale or 1)
    end
  end
  
  return handler
end

function CupArenaRankRewardPop:doClickInList()
  local function handler(x, y, info)
    if self.waitReturn then
      return
    end
    if info.fun then
      self.waitReturn = true
      self:listenTimer(Timer:Once(0.7), function()
        self.waitReturn = false
      end)
      info.fun()
    end
  end
  
  return handler
end

local dItemMode = {}

function dItemMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = dItemMode}):create()
end

function dItemMode:create()
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg_4.png"
    })
  }
  if self.param.isGradeMax then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_history_frame.png",
      pos = ccp(346.25, 40),
      parent = ui.bg
    })
    ed.createLabelTools({
      txt = T("\229\142\134\229\143\178\230\156\128\233\171\152"),
      size = 21,
      pos = ccp(638.5, 40),
      color = ed.toccc3(16776131),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#EC793F")),
        1
      },
      font = ed.fontBold
    })
    self.highlight = true
  end
  ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_" .. self.param.id .. "_min.png",
    pos = ccp(62, 40),
    parent = ui.bg,
    scale = 0.52
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_" .. self.param.id .. "_name.png",
    pos = ccp(160, 40),
    parent = ui.bg,
    scale = 0.85
  })
  ed.createLabelTools({
    txt = T("\231\167\175\229\136\134\239\188\154"),
    size = 16,
    pos = ccp(232, 40),
    color = ed.toccc3(16776423),
    parent = ui.bg,
    stroke = {
      ccc3(ed.colorToStr("#67432B")),
      2
    }
  })
  local str = self.param.endScore and T("%s-%s", self.param.startScore, self.param.endScore) or T("%s+", self.param.startScore)
  ed.createLabelTools({
    txt = str,
    size = 23,
    pos = ccp(250, 40),
    color = ed.toccc3(16772731),
    parent = ui.bg,
    stroke = {
      ccc3(ed.colorToStr("#67432B")),
      2
    },
    font = ed.fontBold,
    anchor = ccp(0, 0.5)
  })
  local itemLayer = ed.createCCLayer({
    pos = ccp(398, 10),
    sizeMake = CCSizeMake(196, 60),
    parent = ui.bg
  })
  local thisCon = itemLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = itemLayer,
    noshade = true,
    priority = -300
  }
  self.itemDragList = ed.draglist.create(info)
  self.items = {}
  for i, v in ipairs(self.param.rewards or {}) do
    local icon = ed.createItemIcon(v)
    icon:setScale(0.7)
    table.insert(self.items, icon)
    self.itemDragList:addItem(icon, ccp(i * 61 - 30, 29))
  end
  self.itemDragList:initListWidth(#self.items * 61)
  self.height = 84
  self.ui = ui
  return self
end

CupArenaRankRewardPop.dItemMode = dItemMode
local eItemMode = {}

function eItemMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = eItemMode}):create()
end

function eItemMode:create()
  local index = self.param.rank <= 3 and self.param.rank or 4
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg_" .. index .. ".png"
    })
  }
  if index < 4 then
    local rankRes = {
      "rank_1st",
      "rank_2nd",
      "rank_3rd"
    }
    ed.createSpriteTools({
      res = "UI/alpha/1080P/toparena/rank/" .. rankRes[index] .. ".png",
      pos = ccp(60, 40),
      parent = ui.bg
    })
  else
    ed.createLabelTools({
      txt = self.param.rank,
      size = 40,
      pos = ccp(60, 40),
      color = ed.toccc3(16772731),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#67432B")),
        1.3
      },
      font = ed.fontBold
    })
  end
  ed.createSpriteTools({
    res = self.param.iconRes,
    pos = ccp(170, 40),
    parent = ui.bg,
    scale = 1
  })
  if ed.CupArenaManager:getCampId() == self.param._camp_id then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_history_frame.png",
      pos = ccp(346.25, 40),
      parent = ui.bg
    })
    ed.createLabelTools({
      txt = T("\230\136\145\231\154\132\233\152\181\232\144\165"),
      size = 21,
      pos = ccp(612.5, 40),
      color = ed.toccc3(16776131),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#EC793F")),
        1
      },
      font = ed.fontBold
    })
    self.highlight = true
  end
  for _, vv in pairs(ed.getDataTable("CupArenaCamp")) do
    if self.param._camp_id == vv["Camp ID"] then
      ed.createLabelTools({
        txt = T("%s\233\152\181\232\144\165", vv["Camp Name"]),
        size = 19,
        pos = ccp(280, 40),
        color = ed.toccc3(16776423),
        stroke = {
          ccc3(ed.colorToStr("#221505")),
          1.3
        },
        parent = ui.bg
      })
      break
    end
  end
  local itemLayer = ed.createCCLayer({
    pos = ccp(353, 10),
    sizeMake = CCSizeMake(217, 60),
    parent = ui.bg,
    anchor = ccp(0, 0)
  })
  ui.itemLayer = itemLayer
  local thisCon = itemLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = itemLayer,
    noshade = true,
    priority = -300
  }
  self.itemDragList = ed.draglist.create(info)
  self.items = {}
  for i, v in ipairs(self.param.rewards or {}) do
    local icon = ed.createItemIcon(v)
    icon:setScale(0.7)
    table.insert(self.items, icon)
    self.itemDragList:addItem(icon, ccp(i * 66 - 33, 29))
  end
  self.itemDragList:initListWidth(#self.items * 66)
  self.height = 84
  self.ui = ui
  return self
end

CupArenaRankRewardPop.eItemMode = eItemMode
local fItemMode = {}

function fItemMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = fItemMode}):create()
end

function fItemMode:create()
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_reward_bg_2.png"
    })
  }
  ui.notBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_mini_sys.png",
    pos = ccp(612.5, 40),
    parent = ui.bg,
    scale = 1.1
  })
  ed.createLabelTools({
    txt = T("\230\156\170\232\190\190\230\136\144"),
    size = 18,
    pos = ccp(50.75, 20.75),
    color = ed.toccc3(16776678),
    parent = ui.notBtn
  })
  ui.pass = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_reward_bg_3.png",
    pos = ccp(346.25, 40),
    parent = ui.bg
  })
  ui.gift = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_reward_bg_1.png",
    pos = ccp(346.25, 40),
    parent = ui.bg
  })
  local title = ed.ui.autoText.new()
  local content = T("<lable color=ccc3(255,255,233) fontSize=f23 strokeColor=ccc3(96,72,36) strokeSize=1 fontName=fontBold>\231\180\175\231\167\175%s</lable><sprite src=UI/alpha/1080P/icon/money_top_pvp_big.png scale=1>", self.param.count)
  title:initParam({context = content})
  ui.bg:addChild(title.node)
  title.node:setPosition(25, 40)
  ui.giftBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pos = ccp(612.5, 40),
    parent = ui.gift,
    scale = 1.1
  })
  ed.createLabelTools({
    txt = T("\233\162\134\229\143\150"),
    size = 18,
    pos = ccp(50.75, 20.75),
    color = ed.toccc3(16642727),
    parent = ui.giftBtn
  })
  ed.createLabelTools({
    txt = T("\229\183\178\233\162\134\229\143\150"),
    size = 21,
    pos = ccp(58.25, 29.5),
    color = ed.toccc3(14729634),
    parent = ed.createSpriteTools({
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_over_img.png",
      pos = ccp(612.5, 40),
      parent = ui.pass
    })
  })
  local infos = self.param.rewards or {}
  local addX = #infos * 33
  self.items = {}
  self.itemObj = {}
  for i, v in ipairs(infos or {}) do
    local item = ed.taskItemModule.new(self, v, nil, i, false, false, true)
    item.icon:setPosition(310 + i * 66 - addX, 40)
    ui.bg:addChild(item.icon)
    item.icon:setScale(0.7)
    table.insert(self.itemObj, item)
    table.insert(self.items, item.icon)
  end
  self.height = 84
  self.ui = ui
  self:refresh()
  return self
end

function fItemMode:refresh()
  if self.param.progress == 1 then
    self.ui.gift:setVisible(true)
    self.ui.pass:setVisible(false)
  elseif self.param.progress == 2 then
    self.ui.gift:setVisible(false)
    self.ui.pass:setVisible(true)
  else
    self.ui.gift:setVisible(false)
    self.ui.pass:setVisible(false)
  end
  for _, v in ipairs(self.itemObj) do
    v:refresh(self.param.progress > 2 and 0 or self.param.progress)
  end
end

function fItemMode:btRegisterButtonClickToListItems(param)
end

CupArenaRankRewardPop.fItemMode = fItemMode
local gItemMode = {}

function gItemMode.new(popSelf, param, _, index)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    index = index
  }, {__index = gItemMode}):create()
end

function gItemMode:create()
  local index = self.index <= 3 and self.index or 4
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg_" .. index .. ".png"
    })
  }
  if 4 >= self.param.endRank then
    local rankStr = {
      {
        str = T("\229\134\160\229\134\155"),
        startColor = ed.toccc3(16776535),
        endColor = ed.toccc3(16755465),
        strokeColor = ed.toccc3(5519125)
      },
      {
        str = T("\228\186\154\229\134\155"),
        startColor = ed.toccc3(13300991),
        endColor = ed.toccc3(4564979),
        strokeColor = ed.toccc3(2565181)
      },
      {},
      {
        str = T("4\229\188\186"),
        startColor = ed.toccc3(16771249),
        endColor = ed.toccc3(16022315),
        strokeColor = ed.toccc3(4007972)
      }
    }
    ui.title = ed.ui.gradientLabel.create({
      text = rankStr[self.param.endRank].str,
      fontSize = 30,
      fontName = ed.fontBold,
      startColor = rankStr[self.param.endRank].startColor,
      endColor = rankStr[self.param.endRank].endColor,
      strokeSize = 1.5,
      strokeColor = rankStr[self.param.endRank].strokeColor
    })
    ui.title.node:setPosition(ccp(60, 40))
    ui.bg:addChild(ui.title.node)
  else
    ed.createLabelTools({
      txt = T("%s\229\188\186", self.param.endRank),
      size = 30,
      pos = ccp(60, 40),
      color = ed.toccc3(16776423),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#3d2824")),
        1.3
      },
      font = ed.fontBold
    })
  end
  local infos = self.param.rewards or {}
  local addX = #infos * 33
  self.items = {}
  for i, v in ipairs(infos or {}) do
    local icon = ed.createItemIcon(v)
    icon:setScale(0.7)
    icon:setPosition(320 + i * 66 - addX, 40)
    ui.bg:addChild(icon)
    table.insert(self.items, icon)
  end
  self.height = 84
  self.ui = ui
  return self
end

CupArenaRankRewardPop.gItemMode = gItemMode
local aItemMode = {}

function aItemMode.new(popSelf, param, isSelf)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    isSelf = isSelf
  }, {__index = aItemMode}):create()
end

function aItemMode:create()
  local index = self.param._rank <= 3 and self.param._rank or 4
  index = self.isSelf and 5 or index
  local posy = self.isSelf and 210 or 160
  local addx = self.isSelf and 8 or 0
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg_" .. index .. ".png"
    })
  }
  if index < 4 then
    local rankRes = {
      "rank_1st",
      "rank_2nd",
      "rank_3rd"
    }
    ed.createSpriteTools({
      res = "UI/alpha/1080P/toparena/rank/" .. rankRes[index] .. ".png",
      pos = ccp(60, posy / 2 / 2),
      parent = ui.bg
    })
  elseif index == 5 then
    local text = ed.getNumberNode({
      text = self.param._rank,
      folder = "peakarena_rank"
    }).node
    text:setPosition(66, posy / 2 / 2)
    ui.bg:addChild(text)
    text:setScale(1)
  else
    ed.createLabelTools({
      txt = self.param._rank,
      size = 40,
      pos = ccp(60, posy / 2 / 2),
      color = ed.toccc3(16772731),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#67432B")),
        1.3
      },
      font = ed.fontBold
    })
  end
  local hand = ed.getTeamHead({
    id = self.param._user_summary._avatar,
    vip = 0 < (self.param._user_summary._vip or 0)
  })
  ui.bg:addChild(hand)
  hand:setPosition(155 + addx, posy / 2 / 2)
  hand:setScale(0.8)
  ui.hand = hand
  local name = ed.getPlayerName(self.param._user_summary._name, self.param._user_summary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  name:setPosition(197 + addx, posy / 2 / 2)
  ui.bg:addChild(name)
  ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_" .. self.param._camp_id .. ".png",
    pos = ccp(418 + addx, posy / 2 / 2),
    parent = ui.bg,
    scale = 0.9
  })
  local stageInfo = ed.CupArenaManager:getGradeInfoByScore(self.param._score)
  ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_" .. stageInfo.id .. "_name.png",
    pos = ccp(490 + addx, posy / 2 / 2),
    parent = ui.bg,
    scale = 0.7
  })
  local scoreBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_point_bg.png",
    pos = ccp(605 + addx, posy / 2 / 2),
    parent = ui.bg
  })
  ed.createLabelTools({
    txt = T("\231\167\175\229\136\134:"),
    size = 19,
    pos = ccp(35, 20),
    color = ed.toccc3(16773262),
    stroke = {
      ccc3(ed.colorToStr("#2F1E1E")),
      1.3
    },
    parent = scoreBg
  })
  local text = ed.getNumberNode({
    text = self.param._score,
    folder = "peak_score"
  }).node
  text:setPosition(96, 20)
  scoreBg:addChild(text)
  text:setScale(0.8)
  self.height = 84
  self.ui = ui
  return self
end

CupArenaRankRewardPop.aItemMode = aItemMode
local bItemMode = {}

function bItemMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = bItemMode}):create()
end

function bItemMode:create()
  local index = self.param._rank <= 3 and self.param._rank or 4
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg_" .. index .. ".png"
    })
  }
  if index < 4 then
    local rankRes = {
      "rank_1st",
      "rank_2nd",
      "rank_3rd"
    }
    ed.createSpriteTools({
      res = "UI/alpha/1080P/toparena/rank/" .. rankRes[index] .. ".png",
      pos = ccp(60, 40),
      parent = ui.bg
    })
  else
    ed.createLabelTools({
      txt = self.param._rank,
      size = 40,
      pos = ccp(60, 40),
      color = ed.toccc3(16772731),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#67432B")),
        1.3
      },
      font = ed.fontBold
    })
  end
  ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_" .. self.param._camp_id .. ".png",
    pos = ccp(160, 40),
    parent = ui.bg,
    scale = 0.9
  })
  for _, vv in pairs(ed.getDataTable("CupArenaCamp")) do
    if self.param._camp_id == vv["Camp ID"] then
      ed.createLabelTools({
        txt = T("%s\233\152\181\232\144\165", vv["Camp Name"]),
        size = 19,
        pos = ccp(296, 40),
        color = ed.toccc3(16776423),
        stroke = {
          ccc3(ed.colorToStr("#221505")),
          1.3
        },
        parent = ui.bg
      })
      break
    end
  end
  local scoreBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_point_bg.png",
    pos = ccp(490, 40),
    parent = ui.bg
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/icon/money_top_pvp_big.png",
    pos = ccp(36, 20),
    parent = scoreBg,
    scale = 1.25
  })
  ed.createLabelTools({
    txt = self.param._medal,
    size = 23,
    pos = ccp(53, 20),
    color = ed.toccc3(16776423),
    stroke = {
      ccc3(ed.colorToStr("#0A0903")),
      1
    },
    parent = scoreBg,
    anchor = ccp(0, 0.5)
  })
  if self.selfCampId and self.selfCampId == self.param._camp_id or ed.CupArenaManager:getCampId() == self.param._camp_id then
    ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_history_frame.png",
      pos = ccp(346.25, 40),
      parent = ui.bg
    })
    ed.createLabelTools({
      txt = T("\230\136\145\231\154\132\233\152\181\232\144\165"),
      size = 21,
      pos = ccp(622.5, 40),
      color = ed.toccc3(16776131),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#EC793F")),
        1
      },
      font = ed.fontBold
    })
    self.highlight = true
  end
  self.height = 84
  self.ui = ui
  return self
end

CupArenaRankRewardPop.bItemMode = bItemMode
local cItemMode = {}

function cItemMode.new(popSelf, param, _, index)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    index = index
  }, {__index = cItemMode}):create()
end

function cItemMode:create()
  local index = self.param._rank <= 3 and self.param._rank or 4
  index = self.param._rank == 4 and 3 or index
  local ui = {
    bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/cuparena/cuparena_rank_bg_" .. index .. ".png"
    })
  }
  if self.param._rank <= 4 then
    local rankStr = {
      {
        str = T("\229\134\160\229\134\155"),
        startColor = ed.toccc3(16776535),
        endColor = ed.toccc3(16755465),
        strokeColor = ed.toccc3(5519125)
      },
      {
        str = T("\228\186\154\229\134\155"),
        startColor = ed.toccc3(13300991),
        endColor = ed.toccc3(4564979),
        strokeColor = ed.toccc3(2565181)
      },
      {},
      {
        str = T("4\229\188\186"),
        startColor = ed.toccc3(16771249),
        endColor = ed.toccc3(16022315),
        strokeColor = ed.toccc3(4007972)
      }
    }
    ui.title = ed.ui.gradientLabel.create({
      text = rankStr[self.param._rank].str,
      fontSize = 30,
      fontName = ed.fontBold,
      startColor = rankStr[self.param._rank].startColor,
      endColor = rankStr[self.param._rank].endColor,
      strokeSize = 1.5,
      strokeColor = rankStr[self.param._rank].strokeColor
    })
    ui.title.node:setPosition(ccp(60, 40))
    ui.bg:addChild(ui.title.node)
  else
    ed.createLabelTools({
      txt = T("%s\229\188\186", self.param._rank),
      size = 30,
      pos = ccp(60, 40),
      color = ed.toccc3(16776423),
      parent = ui.bg,
      stroke = {
        ccc3(ed.colorToStr("#3d2824")),
        1.3
      },
      font = ed.fontBold
    })
  end
  local hand = ed.getTeamHead({
    id = self.param._user_summary._avatar,
    vip = 0 < (self.param._user_summary._vip or 0)
  })
  ui.bg:addChild(hand)
  hand:setPosition(150, 40)
  hand:setScale(0.8)
  ui.hand = hand
  local name = ed.getPlayerName(self.param._user_summary._name, self.param._user_summary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  name:setPosition(210, 40)
  ui.bg:addChild(name)
  ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_" .. self.param._camp_id .. ".png",
    pos = ccp(415, 40),
    parent = ui.bg,
    scale = 0.9
  })
  local guildBg = ed.createSpriteTools({
    res = "UI/alpha/1080P/cuparena/cuparena_rank_zone.png",
    pos = ccp(560, 40),
    parent = ui.bg
  })
  ed.createLabelTools({
    txt = T("\229\140\186\230\156\141:"),
    size = 18,
    pos = ccp(25, 13),
    color = ed.toccc3(16776827),
    stroke = {
      ccc3(ed.colorToStr("#2F1E1E")),
      1.3
    },
    parent = guildBg
  })
  ed.createLabelTools({
    txt = T(self.param._server_name),
    size = 18,
    pos = ccp(50, 13),
    color = ed.toccc3(16776423),
    stroke = {
      ccc3(ed.colorToStr("#2F1E1E")),
      1.3
    },
    parent = guildBg,
    anchor = ccp(0, 0.5)
  })
  self.height = 84
  self.ui = ui
  return self
end

CupArenaRankRewardPop.cItemMode = cItemMode

local function readRewards(v)
  local list = {}
  for i = 1, 6 do
    local type = v["Reward Type " .. i]
    local id = v["Reward ID " .. i]
    local amount = v["Reward Amount " .. i]
    if type then
      table.insert(list, {
        type = type,
        id = id,
        amount = amount
      })
    end
  end
  return list
end

CupArenaRankRewardPop.pages = {
  rank = {
    btn = {
      T("\228\184\170\228\186\186"),
      T("\233\152\181\232\144\165"),
      T("\229\183\133\229\179\176\232\181\155")
    },
    txt = ""
  },
  reward = {
    btn = {
      T("\230\174\181\228\189\141"),
      T("\233\152\181\232\144\165"),
      T("\229\139\139\231\171\160"),
      T("\229\183\133\229\179\176\232\181\155")
    },
    txt = T("\230\181\183\233\128\137\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\230\156\172\233\152\181\232\144\165\230\142\146\229\144\141\229\143\145\230\148\190\229\165\150\229\138\177")
  }
}
CupArenaRankRewardPop.btns = {
  rank = {
    [T("\228\184\170\228\186\186")] = {
      addUieditor = function(self)
        local item = self.newData.item or {}
        local btn = ed.createSpriteTools({
          res = "UI/alpha/1080P/cuparena/cuparena_rank_button.png",
          pos = ccp(180, 383),
          parent = self.addLayer,
          z = 9
        })
        local fullName = ed.createLabelTools({
          txt = T(item.fullName or "\230\128\187\230\142\146\229\144\141"),
          size = 17,
          pos = ccp(67.75, 18),
          color = ed.toccc3(16776423),
          stroke = {
            ed.toccc3(1118481),
            1
          },
          parent = btn
        })
        local arrow = ed.createSpriteTools({
          res = "UI/alpha/1080P/cuparena/cuparena_rank_list_arrow.png",
          pos = ccp(121.75, 18),
          parent = btn
        })
        local listBg = ed.createSpriteTools({
          res = "UI/alpha/1080P/cuparena/cuparena_rank_list_bg.png",
          parent = self.addLayer,
          pos = ccp(180, 279),
          notShow = true
        })
        local thisCon = listBg:getContentSize()
        local info = {
          cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
          container = listBg,
          priority = -310,
          noshade = true
        }
        self:btRemoveMainTouchHandler({key = "listBg"})
        self:btRegisterOutClick({
          area = {listBg, btn},
          key = "listBg",
          clickHandler = function()
            self.dragList:setTouchEnabled(true)
            listBg:setVisible(false)
            arrow:setScaleY(1)
          end
        })
        local dragList = ed.draglist.create(info)
        local items = ed.CupArenaManager:getCampInfoList() or {}
        table.insert(items, 1, {
          fullName = T("\230\128\187\230\142\146\229\144\141"),
          id = 999
        })
        local chooses = {}
        for i, v in ipairs(items) do
          local itemBg = ed.createSpriteTools({
            res = "UI/alpha/1080P/cuparena/cuparena_rank_list_choose.png",
            parent = dragList.listLayer,
            pos = ccp(77.5, thisCon.height - 38 * i)
          })
          chooses[v.id] = ed.createSpriteTools({
            res = "UI/alpha/1080P/cuparena/cuparena_rank_list_choose1.png",
            parent = itemBg,
            pos = ccp(74.5, 17.5),
            notShow = ed.CupArenaManager:getCampId() ~= v.id
          })
          ed.createLabelTools({
            txt = v.fullName,
            size = 17,
            pos = ccp(74.5, 17.5),
            color = ed.toccc3(16776423),
            stroke = {
              ed.toccc3(1118481),
              1
            },
            parent = itemBg
          })
          self:btRemoveMainTouchHandler({
            key = "rank_btn_item" .. i
          })
          self:btRegisterButtonClick({
            button = itemBg,
            key = "rank_btn_item" .. i,
            clickInterval = 0.1,
            clickHandler = function(param, x, y)
              if not ed.containsPoint(listBg, x, y + 15) then
                return
              end
              self.newData.item = v
              self.oldIndex = self.index
              self.newData.network(v.id)
              self.dragList:setTouchEnabled(true)
              listBg:setVisible(false)
              arrow:setScaleY(1)
            end,
            force = true,
            pressScale = 1.05
          })
        end
        dragList:initListHeight(#items * 38 + 22)
        self:btRemoveMainTouchHandler({key = "rank_btn"})
        self:btRegisterButtonClick({
          button = btn,
          key = "rank_btn",
          clickInterval = 0.1,
          clickHandler = function()
            listBg:setVisible(not listBg:isVisible())
            arrow:setScaleY(arrow:getScaleY() * -1)
            self.dragList:setTouchEnabled(not listBg:isVisible())
          end,
          force = true,
          pressScale = 1.05
        })
        self.dragList:setTouchEnabled(not listBg:isVisible())
        self.rankListBtnsDragList = dragList
        self.selfRank = nil
        self.fullName = fullName
        self.rankChooses = chooses
      end,
      refreshUieditor = function(self)
        if self.selfRank then
          self.selfRank.ui.bg:removeFromParentAndCleanup(true)
          self.selfRank = nil
        end
        local item = self.newData.item or {}
        self.fullName:setString(T(item.fullName or "\230\128\187\230\142\146\229\144\141"))
        if self.rankData and self.rankData._self_rank then
          local my = aItemMode.new(self, self.rankData._self_rank, true)
          my.ui.bg:setPosition(430, 80)
          self.addLayer:addChild(my.ui.bg)
          self.selfRank = my
        end
        for k, v in pairs(self.rankChooses or {}) do
          v:setVisible(self.selfCampId == k)
        end
      end,
      network = function(campId)
        local msg = ed.upmsg.cup_arena_req()
        msg._user_rankboard = ed.upmsg.cup_arena_user_rankboard()
        msg._user_rankboard._camp_id = campId or 999
        ed.send(msg, "cup_arena")
      end,
      setListInfo = function(self, data)
        self.rankData = ed.copyProto(data)
        if self.rankData._self_rank and self.rankData._self_rank._camp_id then
          self.selfCampId = self.rankData._self_rank._camp_id
        end
      end,
      getListInfo = function(self)
        local data = self.rankData and self.rankData._rank_list or {}
        return data
      end,
      module = CupArenaRankRewardPop.aItemMode,
      title = T("\228\184\170\228\186\186\230\142\146\232\161\140"),
      txt = T("\230\160\185\230\141\174\231\167\175\229\136\134\230\142\146\229\144\141\239\188\140\233\152\181\232\144\165\229\137\14116\229\144\141\229\143\175\232\191\155\229\133\165\229\183\133\229\179\176\232\181\155"),
      asyncCreate = true
    },
    [T("\233\152\181\232\144\165")] = {
      network = function()
        local msg = ed.upmsg.cup_arena_req()
        msg._camp_rankboard = ed.upmsg.cup_arena_camp_rankboard()
        ed.send(msg, "cup_arena")
      end,
      setListInfo = function(self, data)
        self.campData = ed.copyProto(data)
        self.selfCampId = self.campData._self_camp_id
      end,
      getListInfo = function(self)
        return self.campData and self.campData._rank_list or {}
      end,
      module = CupArenaRankRewardPop.bItemMode,
      title = T("\233\152\181\232\144\165\230\142\146\232\161\140"),
      txt = T("\230\160\185\230\141\174\233\152\181\232\144\165\230\136\144\229\145\152\230\128\187\229\139\139\231\171\160\230\149\176\230\142\146\229\144\141")
    },
    [T("\229\183\133\229\179\176\232\181\155")] = {
      network = function()
        local msg = ed.upmsg.cup_arena_req()
        msg._match_rankboard = ed.upmsg.cup_arena_match_rankboard()
        ed.pt(msg)
        ed.send(msg, "cup_arena")
      end,
      addUieditor = function(self)
        for k, v in pairs(ed.getDataTable("CupArenaFinalReward")[self.season]) do
          if type(v) == "table" and v["Camp Reward"] then
            local desLabel = ed.createLabelTools({
              txt = T("\231\172\172\228\184\128\229\144\141\230\137\128\229\156\168\233\152\181\232\144\165\229\139\139\231\171\160\232\190\1901000\231\154\132\233\152\159\233\149\191\233\162\157\229\164\150\232\142\183\229\190\151"),
              size = 17,
              pos = ccp(0, 383),
              color = ed.toccc3(16575857),
              parent = self.addLayer,
              stroke = {
                ed.toccc3(5584393),
                1.3
              }
            })
            local itemIcon = ed.createItemIcon({
              type = v["Camp Reward Type"],
              id = v["Camp Reward ID"],
              count = 1
            })
            itemIcon:setPosition(0, 383)
            itemIcon:setScale(0.35)
            self.addLayer:addChild(itemIcon)
            local countLabel = ed.createLabelTools({
              txt = string.format("x%d", v["Camp Reward Amount"]),
              size = 17,
              pos = ccp(0, 383),
              color = ed.toccc3(16575857),
              parent = self.addLayer,
              stroke = {
                ed.toccc3(5584393),
                1.3
              }
            })
            ed.layout.horizontalSortNode({
              desLabel,
              itemIcon,
              countLabel
            }, {
              5,
              5,
              0
            }, 428.25)
            self:btRemoveMainTouchHandler({
              key = "CupArenaFinalRewardItemIcon"
            })
            self:btRegisterButtonClick({
              button = itemIcon,
              key = "CupArenaFinalRewardItemIcon",
              clickInterval = 0.1,
              clickHandler = function()
                ed.UITool.openView("packageDetail", {
                  type = v["Camp Reward Type"],
                  id = v["Camp Reward ID"],
                  count = 1
                })
              end,
              force = true,
              pressScale = 0.3,
              normalScale = 0.35
            })
            break
          end
        end
      end,
      setListInfo = function(self, data)
        self.cupArenaData = ed.copyProto(data)
      end,
      getListInfo = function(self)
        return self.cupArenaData and self.cupArenaData._rank_list or {}
      end,
      module = CupArenaRankRewardPop.cItemMode,
      title = T("\229\183\133\229\179\176\232\181\155\230\142\146\232\161\140"),
      txt = " ",
      asyncCreate = true
    }
  },
  reward = {
    [T("\230\174\181\228\189\141")] = {
      network = function()
        ed.CupArenaNetwork:sendOpenReward()
      end,
      setListInfo = function(self)
        local gradeMaxInfo = ed.CupArenaManager:getGradeInfoByScore(ed.CupArenaManager:getScoreMax())
        local list = {}
        for _, v in pairs(ed.getDataTable("CupArenaGrade")[self.season]) do
          if type(v) == "table" then
            table.insert(list, {
              id = v.Grade,
              startScore = v["Start Score"],
              name = v["Grade Name"],
              rewards = readRewards(v)
            })
          end
        end
        table.sort(list, function(v1, v2)
          return v1.startScore > v2.startScore
        end)
        local nextLvStartScore
        for i = 1, #list do
          local v = list[i]
          v.endScore = nextLvStartScore and nextLvStartScore - 1 or nil
          nextLvStartScore = v.startScore
          v.isGradeMax = gradeMaxInfo.id == v.id
        end
        self.cupArenaGradeReward = list
      end,
      getListInfo = function(self)
        return self.cupArenaGradeReward or {}
      end,
      module = CupArenaRankRewardPop.dItemMode,
      title = T("\230\174\181\228\189\141\229\165\150\229\138\177"),
      txt = T("\230\181\183\233\128\137\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\229\142\134\229\143\178\230\156\128\233\171\152\230\174\181\228\189\141\229\143\145\229\165\150")
    },
    [T("\233\152\181\232\144\165")] = {
      network = function()
        local msg = ed.upmsg.cup_arena_req()
        msg._cup_arena_open_camp_reward = ed.upmsg.cup_arena_open_camp_reward()
        ed.pt(msg)
        ed.send(msg, "cup_arena")
      end,
      setListInfo = function(self, data)
        local list = {}
        for _, v in pairs(ed.getDataTable("CupArenaMedalCamp")[self.season]) do
          if type(v) == "table" then
            local item = {
              rank = v["Camp Medal Rank"],
              rewards = readRewards(v)
            }
            list[item.rank] = item
          end
        end
        self.cupArenaCampReward = ed.copyProto(data._rank_list)
        for i, v in ipairs(self.cupArenaCampReward) do
          v.rank = v._rank
          v.rewards = list[v._rank].rewards
          v.iconRes = list[v._rank].iconRes
          for kk, vv in pairs(ed.getDataTable("CupArenaCamp")) do
            if kk == v._camp_id then
              v.iconRes = vv["Camp Symbol Min"]
              break
            end
          end
        end
      end,
      getListInfo = function(self)
        return self.cupArenaCampReward or {}
      end,
      module = CupArenaRankRewardPop.eItemMode,
      title = T("\233\152\181\232\144\165\229\165\150\229\138\177"),
      txt = T("\231\180\175\231\167\175\232\180\161\231\140\174\229\139\139\231\171\160\232\190\1901000\231\154\132\233\152\159\233\149\191\229\143\175\232\142\183\229\190\151\233\152\181\232\144\165\229\165\150\229\138\177"),
      asyncCreate = true
    },
    [T("\229\139\139\231\171\160")] = {
      addUieditor = function(self)
        local bg = ed.createSpriteTools({
          res = "UI/alpha/1080P/cuparena/cuparena_reward_medal_bg.png",
          pos = ccp(180, 383),
          parent = self.addLayer
        })
        ed.createLabelTools({
          txt = T("\229\189\147\229\137\141    \239\188\154%d", ed.CupArenaManager:getMedal()),
          size = 16,
          pos = ccp(12.5, 18),
          color = ed.toccc3(16776423),
          stroke = {
            ed.toccc3(1118481),
            1
          },
          parent = bg,
          anchor = ccp(0, 0.5)
        })
        ed.createSpriteTools({
          res = "UI/alpha/1080P/icon/money_top_pvp_big.png",
          pos = ccp(60, 18),
          parent = bg
        })
      end,
      network = function()
        ed.CupArenaNetwork:sendOpenReward()
      end,
      setListInfo = function(self, data)
        local list = {}
        for k, v in pairs(ed.getDataTable("CupArenaMedalPersonal")[self.season]) do
          if type(v) == "table" then
            local item = {
              id = v.ID,
              count = v["Require Medal Count"],
              rewards = readRewards(v)
            }
            if ed.CupArenaManager:hasMedalRewardBeenTaken(item.id) then
              item.progress = 2
            elseif ed.CupArenaManager:getMedal() >= item.count then
              item.progress = 1
            else
              item.progress = 0
            end
            table.insert(list, item)
          end
        end
        table.sort(list, function(a, b)
          local sortType = {
            [0] = 2,
            [1] = 3,
            [2] = 1
          }
          if sortType[a.progress] == sortType[b.progress] then
            return a.id < b.id
          else
            return sortType[a.progress] > sortType[b.progress]
          end
        end)
        self.cupArenaMedalPersonalReward = list
      end,
      getListInfo = function(self)
        return self.cupArenaMedalPersonalReward or {}
      end,
      module = CupArenaRankRewardPop.fItemMode,
      title = T("\229\139\139\231\171\160\229\165\150\229\138\177"),
      txt = " ",
      redFun = function()
        return ed.CupArenaManager:getMedalRewardRedFlag()
      end,
      asyncCreate = true
    },
    [T("\229\183\133\229\179\176\232\181\155")] = {
      addUieditor = function(self)
        for k, v in pairs(ed.getDataTable("CupArenaFinalReward")[self.season]) do
          if type(v) == "table" and v["Camp Reward"] then
            local desLabel = ed.createLabelTools({
              txt = T("\231\172\172\228\184\128\229\144\141\230\137\128\229\156\168\233\152\181\232\144\165\229\139\139\231\171\160\232\190\1901000\231\154\132\233\152\159\233\149\191\233\162\157\229\164\150\232\142\183\229\190\151"),
              size = 17,
              pos = ccp(0, 383),
              color = ed.toccc3(16575857),
              parent = self.addLayer,
              stroke = {
                ed.toccc3(5584393),
                1.3
              }
            })
            local itemIcon = ed.createItemIcon({
              type = v["Camp Reward Type"],
              id = v["Camp Reward ID"],
              count = 1
            })
            itemIcon:setPosition(0, 383)
            itemIcon:setScale(0.35)
            self.addLayer:addChild(itemIcon)
            local countLabel = ed.createLabelTools({
              txt = string.format("x%d", v["Camp Reward Amount"]),
              size = 17,
              pos = ccp(0, 383),
              color = ed.toccc3(16575857),
              parent = self.addLayer,
              stroke = {
                ed.toccc3(5584393),
                1.3
              }
            })
            ed.layout.horizontalSortNode({
              desLabel,
              itemIcon,
              countLabel
            }, {
              5,
              5,
              0
            }, 428.25)
            self:btRemoveMainTouchHandler({
              key = "CupArenaFinalRewardItemIcon"
            })
            self:btRegisterButtonClick({
              button = itemIcon,
              key = "CupArenaFinalRewardItemIcon",
              clickInterval = 0.1,
              clickHandler = function()
                ed.UITool.openView("packageDetail", {
                  type = v["Camp Reward Type"],
                  id = v["Camp Reward ID"],
                  count = 1
                })
              end,
              force = true,
              pressScale = 0.3,
              normalScale = 0.35
            })
            break
          end
        end
      end,
      getListInfo = function(self)
        local list = {}
        local preEndRank = 1
        for k, v in pairs(ed.getDataTable("CupArenaFinalReward")[self.season]) do
          if type(v) == "table" then
            local requireRank = v["Require Rank"]
            local item = {
              id = v.ID,
              startRank = preEndRank,
              endRank = requireRank,
              rewards = readRewards(v)
            }
            preEndRank = requireRank + 1
            table.insert(list, item)
          end
        end
        table.sort(list, function(v1, v2)
          return v1.id < v2.id
        end)
        return list
      end,
      module = CupArenaRankRewardPop.gItemMode,
      title = T("\229\183\133\229\179\176\232\181\155\229\165\150\229\138\177"),
      txt = " ",
      asyncCreate = true
    }
  }
}
