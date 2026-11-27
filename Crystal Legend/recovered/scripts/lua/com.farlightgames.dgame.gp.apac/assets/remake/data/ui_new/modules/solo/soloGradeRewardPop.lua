local base = ed.ui.popwindow
local soloGradeRewardPop = newclass(base.mt)
ed.ui.soloGradeRewardPop = soloGradeRewardPop

function soloGradeRewardPop.create(data)
  local self = base.create("soloGradeRewardPop")
  setmetatable(self, soloGradeRewardPop.mt)
  self.data = data
  self:initUI()
  self:initData()
  self:createDragView()
  self:registerTouchEvents()
  self:popWindow()
  self:show({skipAnim = true})
  return self
end

function soloGradeRewardPop:initUI()
  local fs = ed.display.winSize
  self.ui = {}
  self.ui.closeBtn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt_bj.png",
    pos = ccp(56 - ed.display.halfFixedWidth, fs.height - 38 - ed.display.halfFixedHeight),
    parent = self.container,
    scale = 0.85,
    z = 99
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/break_butt.png",
    pos = ccp(27, 27.5),
    parent = self.ui.closeBtn
  })
  self.ui.itemLayer = ed.createCCLayer({
    pos = ccp(0 - ed.display.halfFixedWidth, 0),
    sizeMake = CCSizeMake(fs.width, fs.height),
    parent = self.container
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/rank_line.png",
    pos = ccp(fs.width / 2 + 10, 60),
    rectMake = CCRectMake(80, 1, 300, 1),
    sizeMake = CCSizeMake(fs.width - 20, 3),
    parent = self.ui.itemLayer
  })
  self:listenEvent("refreshGradeRewardFlags", function(grade)
    self.listItem[grade]:refresh(2)
  end)
end

function soloGradeRewardPop:initData()
  local score = ed.SoloManager:getScore()
  local data = ed.copyTable(ed.getDataTable("SoloSeasonGrade"))
  table.sort(data, function(a, b)
    return a["Current Grade Score"] < b["Current Grade Score"]
  end)
  local reward = ed.getDataTable("SoloSeasonReward")[1]
  local state = {}
  for k, v in pairs(ed.SoloManager.gradeRewardFlags or {}) do
    state[v] = true
  end
  for i, v in ipairs(data) do
    if reward[v.ID] then
      v.reward = {
        id = reward[v.ID]["Reward ID 1"],
        type = reward[v.ID]["Reward Type 1"]
      }
    end
    v.state = state[v.ID] and 2 or score >= v["Current Grade Score"] and 1 or 0
  end
  self.listData = data
end

function soloGradeRewardPop:registerTouchEvents()
  ed.UITool.registerBtn(self, "closeBtn", function()
    self:destroy({skipAnim = true})
  end, {
    pressScale = self.ui.closeBtn:getScale() - 0.05,
    normalScale = self.ui.closeBtn:getScale()
  })
end

function soloGradeRewardPop:createDragView()
  self.draglist = ed.UITool.createDraglist(self.ui.itemLayer, {
    doPressIn = function(x, y)
      for _, item in ipairs(self.listItem or {}) do
        if item.ui.item and ed.containsPoint(item.ui.item.icon, x, y) then
          item.ui.item.icon:setScale(0.75)
          return item
        end
      end
    end,
    doClickIn = function(x, y, item)
      item.ui.item.icon:setScale(0.8)
      ed.pt(item.param)
      if item.param.state == 1 then
        ed.SoloNetwork:sendSoloGradeRewards(item.param.ID)
      else
        ed.UITool.openView("packageDetail", item.param.reward)
      end
    end
  })
  self:refreshDragView()
end

function soloGradeRewardPop:refreshDragView()
  local score = ed.SoloManager:getScore()
  local reward = ed.getDataTable("SoloSeasonReward")[1]
  self.draglist:clearList()
  self.light = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/light.png",
    pos = ccp(100, 400),
    parent = self.draglist.listLayer
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/rank_bg1.png",
    pos = ccp(234, 89),
    parent = self.light
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/rank_bg.png",
    pos = ccp(234, 300),
    parent = self.light
  })
  ed.createLabelTools({
    txt = T("\229\189\147\229\137\141\230\174\181\228\189\141"),
    size = 21,
    pos = ccp(234, 300),
    color = ccc3(ed.colorToStr("#fff88a")),
    parent = self.light,
    anchor = ccp(0.5, 0.5)
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/rank_1.png",
    pos = ccp(234, -156.5),
    parent = self.light
  })
  local thisCon = self.ui.itemLayer:getContentSize()
  self.listItem = {}
  local posX
  for i, v in ipairs(self.listData) do
    if score >= v["Current Grade Score"] then
      posX = i * 240
    end
    v.Score = v["Current Grade Score"] == 0 and "" or i == #self.listData and T("%d\229\136\134\228\187\165\228\184\138", v["Current Grade Score"]) or T("%d\229\136\134", v["Current Grade Score"])
    local item = self.itemModule.create(self, v, i)
    self.draglist:addItem(item.ui.Layer, ccp(i * 240, 250))
    table.insert(self.listItem, item)
  end
  self.draglist:initListWidth(#self.listData * 240 + 240)
  self.light:setPositionX(posX)
  local moveX = -posX + thisCon.width / 2
  if 0 < moveX then
    self.draglist.listLayer:setPositionX(0)
  elseif moveX < (self.draglist.listWidth - thisCon.width) * -1 then
    self.draglist.listLayer:setPositionX((self.draglist.listWidth - thisCon.width) * -1)
  else
    self.draglist.listLayer:setPositionX(moveX)
  end
end

local itemModule = {}

function itemModule.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemModule})
  this:init(param)
  return this
end

function itemModule:init(param)
  local Layer = ed.createSpriteTools({
    res = "",
    pos = ccp(0, 0)
  })
  local bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/" .. self.index .. ".png",
    parent = Layer,
    pos = ccp(0, 50)
  })
  ed.createLabelTools({
    txt = param.Name,
    size = 17,
    pos = ccp(0, 58),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = Layer,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#2c1e06")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = param.Score,
    size = 16,
    pos = ccp(0, 19),
    color = ccc3(ed.colorToStr("#ffe970")),
    parent = Layer,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#2c1e06")),
      1.3
    }
  })
  local item
  if param.reward then
    item = ed.taskItemModule.new(self.mainSelf, param.reward, nil, self.param.index, false, false, true)
    item.icon:setPosition(ccp(0, -80))
    item.icon:setScale(0.8)
    Layer:addChild(item.icon)
    item:refresh(param.state)
  end
  local icon = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/rank/" .. self.index .. "_1.png",
    parent = Layer,
    pos = ccp(0, -190)
  })
  self.ui = {
    Layer = Layer,
    bg = bg,
    item = item
  }
end

function itemModule:refresh(state)
  self.ui.item:refresh(state)
  self.param.state = state
end

soloGradeRewardPop.itemModule = itemModule
