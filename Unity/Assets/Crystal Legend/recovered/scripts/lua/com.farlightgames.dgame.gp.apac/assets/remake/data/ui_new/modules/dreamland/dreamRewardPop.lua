local base = ed.ui.popwindow
local dreamRewardPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("dreamRewardPop", function(param)
  dreamRewardPop.create(param or {}):popWindow()
end)

function dreamRewardPop.create(param)
  return setmetatable(base.create("dreamRewardPop"), dreamRewardPop.mt):init(param or {})
end

function dreamRewardPop:init(param)
  self:uiCreate()
  self:uiRefresh(1)
  self:registerBtnEvents()
  self:show({skipAnim = false})
  return self
end

function dreamRewardPop:uiCreate()
  self.frame, self.ui = ed.editorui(ed.uieditor.dreamland_rewards_pop)
  self.container:addChild(self.frame)
  self.frame:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  ed.setLabelStroke(self.ui.label_daily_reward_title, ed.toccc3(3884850), 1.5)
  ed.setLabelStroke(self.ui.Label_6221, ed.toccc3(3884850), 1)
  self:createBtnPage()
  self:createItemList()
end

function dreamRewardPop:createBtnPage()
  local btns = {
    {
      str = T("\228\184\170\228\186\186\n\229\165\150\229\138\177")
    },
    {
      str = T("\229\133\172\228\188\154\n\229\165\150\229\138\177")
    }
  }
  for i, v in ipairs(btns) do
    local btnBg = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lift_but_1.png")
    btnBg:setAnchorPoint(ccp(1, 0.5))
    btnBg:setPosition(ccp(94, 360 - i * 85))
    self.ui.btn_page_list:addChild(btnBg)
    local Label = ed.createttf(v.str, 21)
    ed.setLabelColor(Label, ccc3(ed.colorToStr("#FFFCE7")))
    ed.setLabelStroke(Label, ccc3(ed.colorToStr("#343447")), 1)
    Label:setPosition(35, 35)
    Label:limitWidthByScale(50)
    btnBg:addChild(Label)
    v.normal = btnBg
    self.ui["btnBg" .. i] = btnBg
    ed.UITool.registerBtn(self, "btnBg" .. i, function()
      self:uiRefresh(i)
    end, {pressScale = 0.95})
    btnBg = ed.createSprite("UI/alpha/1080P/common/battle_prepare_lift_but_2.png")
    btnBg:setPosition(ccp(65, 360 - i * 85))
    self.ui.btn_page_list:addChild(btnBg)
    Label = ed.createttf(v.str, 21)
    ed.setLabelColor(Label, ccc3(ed.colorToStr("#343447")))
    ed.setLabelStroke(Label, ccc3(ed.colorToStr("#FFFCE7")), 2)
    Label:setPosition(37, 37)
    Label:limitWidthByScale(50)
    btnBg:addChild(Label)
    v.press = btnBg
    btnBg:setVisible(false)
  end
  self.pageBtns = btns
end

function dreamRewardPop:createItemList()
  self.thisCon = self.ui.item_list:getContentSize()
  self.draglist = ed.draglist.create({
    cliprect = CCRectMake(0, 0, self.thisCon.width, self.thisCon.height),
    container = self.ui.item_list,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end
  })
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  local rankData, gulidRankData = ed.dreamland.dreamland_object:GetRankRewardData()
  self.rankData = {rankData, gulidRankData}
end

local function baseCreate(self)
  local itemBg = ed.createSprite("UI/alpha/1080P/crusade/bg_replay_item.png")
  local autoText = ed.ui.autoText.new()
  local txt = T("\231\172\172<lable color=dreamRewardPopgreen>%d</lable>\229\144\141", self.param.rank)
  if self.param.rank ~= self.param.floorRank then
    txt = T("\231\172\172<lable color=dreamRewardPopgreen>%d</lable>\229\144\141 - \231\172\172<lable color=dreamRewardPopgreen>%d</lable>\229\144\141", self.param.rank, self.param.floorRank)
  end
  autoText:initParam({
    context = txt,
    fontSize = 18,
    lineSpacing = 4,
    maxWidth = 999,
    color = ccc3(ed.colorToStr("#FFFCE7")),
    strokeColor = ccc3(ed.colorToStr("#343447")),
    strokeSize = 1
  })
  itemBg:addChild(autoText.node)
  autoText.node:setPosition(ccp(20, 45))
  local Label = ed.createttf(T("\231\187\147\231\174\151\229\165\150\229\138\177:"), 18)
  ed.setLabelColor(Label, ccc3(ed.colorToStr("#F7A41C")))
  ed.setLabelStroke(Label, ccc3(ed.colorToStr("#343447")), 1.5)
  itemBg:addChild(Label)
  local posx = 250
  posx = 4 > #self.param.items and posx + (4 - #self.param.items) * 60 / 2 or posx
  for i, v in ipairs(self.param.items or {}) do
    local icon = ed.createItemIcon(v)
    icon:setPosition(60 * i + posx, 45)
    itemBg:addChild(icon, 1)
    self.mainSelf:btRegisterButtonClick({
      button = icon,
      key = "pass_item_tip_" .. self.showIdx .. self.param.rank .. i,
      clickHandler = function()
        if self.mainSelf.touch then
          ed.UITool.openView("packageDetail", v)
        end
      end,
      pressScale = 0.6,
      normalScale = 0.65,
      clickInterval = 0.1
    })
  end
  Label:setPosition(240 + (posx - 250) / 2, 45)
  return itemBg
end

local itemModule = {
  [1] = {
    create = function(self)
      local itemBg = baseCreate(self)
      self.itemBg = itemBg
      return self
    end
  },
  [2] = {
    create = function(self)
      local itemBg = baseCreate(self)
      self.itemBg = itemBg
      return self
    end
  }
}

function dreamRewardPop:uiRefresh(showIdx)
  for i, v in ipairs(self.pageBtns) do
    v.normal:setVisible(i ~= showIdx)
    v.press:setVisible(i == showIdx)
  end
  local size = 88
  
  local function newShowFun()
    for k, v in pairs(self.itemList) do
      v.layer:setVisible(k == showIdx)
    end
    self.itemList[self.newShowIdx or 1].movey = self.draglist:getList():getPositionY()
    self.draglist:initListHeight(self.itemList[showIdx].height)
    self.draglist:getList():setPositionY(self.itemList[showIdx].movey)
  end
  
  if self.itemList and self.itemList[showIdx] then
    newShowFun()
  else
    self.itemList = self.itemList or {}
    local layer = CCLayer:create()
    self.draglist.listLayer:addChild(layer)
    for i, v in ipairs(self.rankData[showIdx] or {}) do
      local item = setmetatable({
        mainSelf = self,
        param = v,
        showIdx = showIdx
      }, {
        __index = itemModule[showIdx]
      }):create()
      item.itemBg:setPosition(ccp(self.thisCon.width / 2, self.thisCon.height - i * size + size / 2 - 4))
      layer:addChild(item.itemBg)
    end
    self.itemList[showIdx] = {
      layer = layer,
      height = #self.rankData[showIdx] * size + 8,
      movey = 0
    }
    newShowFun()
  end
  self.newShowIdx = showIdx
end

function dreamRewardPop:registerBtnEvents()
  self:btRegisterOutClick({
    area = self.ui.ImageView_6217,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({skipAnim = false})
  end, {pressScale = 0.75, normalScale = 0.8})
end
