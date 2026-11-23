local base = ed.ui.popwindow
local menu = newclass(base.mt)
ed.ui.KingsRoomMenuWin = menu
menu.MENU_LIST = {
  btn_to_ob = {
    res = "UI/alpha/1080P/common/button_mini_sys.png",
    icon = "UI/alpha/1080P/newkingspvp/ob/ob_tag4.png",
    label = T("\230\141\162\230\136\144\232\167\130\230\136\152"),
    labelColor = ed.toccc3(16182231),
    strokeColor = ed.toccc3(5321499),
    visible = function(memberData)
      return memberData._room_status ~= "audience"
    end,
    priority = 1
  },
  btn_to_blue = {
    res = "UI/alpha/1080P/common/button_mini_sys.png",
    icon = "UI/alpha/1080P/newkingspvp/ob/03.png",
    label = "\230\141\162\230\136\144<lable color=ccc3(103,185,249)>\232\147\157\230\150\185</lable>",
    labelColor = ed.toccc3(16182231),
    strokeColor = ed.toccc3(5321499),
    visible = function(memberData)
      return memberData._room_status ~= "host"
    end,
    priority = 2
  },
  btn_to_red = {
    res = "UI/alpha/1080P/common/button_mini_sys.png",
    icon = "UI/alpha/1080P/newkingspvp/ob/03.png",
    label = "\230\141\162\230\136\144<lable color=ccc3(255,0,0)>\231\186\162\230\150\185</lable>",
    labelColor = ed.toccc3(16182231),
    strokeColor = ed.toccc3(5321499),
    visible = function(memberData)
      return memberData._room_status ~= "guest"
    end,
    priority = 3
  },
  btn_kick = {
    res = "UI/alpha/1080P/common/button_mini_red.png",
    icon = "UI/alpha/1080P/newkingspvp/ob/quit.png",
    label = T("\232\184\162\229\135\186\233\152\159\228\188\141"),
    labelColor = ed.toccc3(16182231),
    strokeColor = ed.toccc3(7743525),
    visible = function(memberData)
      local team = ed.TeamMgr.getInstance():getTeam()
      if team then
        return not team:checkMemberIsLeader(memberData)
      end
      return false
    end,
    priority = 4
  }
}

function menu.create(memberData)
  local self = base.create("KingsRoomMenu", {noShade = true})
  setmetatable(self, menu.mt)
  self:init(memberData)
  return self
end

function menu:init(memberData)
  self.team = ed.TeamMgr.getInstance():getTeam()
  self.memberData = memberData
  self:initMenu()
  self:createUI()
  self:registerTouch()
end

function menu:initMenu()
  self.btnMenuList = {}
  for btnKey, btnCfg in pairs(self.MENU_LIST) do
    local isVisible
    if type(btnCfg.visible) == "function" then
      isVisible = btnCfg.visible(self.memberData)
    else
      isVisible = btnCfg.visible
    end
    btnCfg.btnKey = btnKey
    if isVisible then
      table.insert(self.btnMenuList, btnCfg)
    end
  end
  table.sort(self.btnMenuList, function(a, b)
    return a.priority < b.priority
  end)
end

function menu:createUI()
  self.btnList = {}
  local imageBg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  imageBg:setAnchorPoint(ccp(0.5, 1))
  self.container:addChild(imageBg)
  local bgSize = CCSizeMake(127, #self.btnMenuList * 33 + 5)
  imageBg:setContentSize(bgSize)
  for index, btnCfg in ipairs(self.btnMenuList) do
    local btn = self:createBtn(btnCfg)
    btn:setPosition(ccp(bgSize.width / 2, bgSize.height - index * 33 + 13))
    imageBg:addChild(btn)
    self.btnList[btnCfg.btnKey] = btn
  end
  self.imageBg = imageBg
end

function menu:createBtn(btnCfg)
  local btn = ed.createScale9Sprite(btnCfg.res)
  btn:setContentSize(CCSizeMake(113, 33))
  local icon = ed.createSprite(btnCfg.icon)
  btn:addChild(icon)
  icon:setPosition(ccp(20, 17))
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = btnCfg.label,
    color = btnCfg.labelColor,
    strokeColor = btnCfg.strokeColor,
    strokeSize = 1,
    fontSize = 15
  })
  btn:addChild(autoText.node)
  autoText.node:setPosition(ccp(37, 17))
  return btn
end

function menu:onClickMenuBtn(btnKey)
  local key = self.team:getMyTeamMemberKey()
  local targetKey = self.memberData._user_key
  if btnKey == "btn_to_ob" then
    ed.TeamNetwork.sendTeamRoomStatus(key, targetKey, "audience")
  elseif btnKey == "btn_to_blue" then
    ed.TeamNetwork.sendTeamRoomStatus(key, targetKey, "host")
  elseif btnKey == "btn_to_red" then
    ed.TeamNetwork.sendTeamRoomStatus(key, targetKey, "guest")
  elseif btnKey == "btn_kick" then
    ed.TeamNetwork.sendTeamKick(key, targetKey)
  end
  self:destroy({skipAnim = true})
end

function menu:showOpenAction(callBack)
  local scaleAction = CCScaleTo:create(0.1, 1)
  local callFunc = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
  end)
  local action = CCSequence:create(ccArrayMake(scaleAction, callFunc))
  self.imageBg:setScaleY(0)
  self.imageBg:runAction(action)
end

function menu:showCloseAction(callBack)
  local scaleAction = CCScaleTo:create(0.1, 1, 0)
  local callFunc = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
  end)
  local action = CCSequence:create(ccArrayMake(scaleAction, callFunc))
  self.imageBg:runAction(action)
end

function menu:registerTouch()
  self:btRegisterOutClick({
    area = self.imageBg,
    key = "out_click",
    clickHandler = function()
      self:showCloseAction(function()
        self:destroy({skipAnim = true})
      end)
    end,
    force = true
  })
  for btnKey, btn in pairs(self.btnList) do
    self:btRegisterButtonClick({
      button = btn,
      key = btnKey,
      force = true,
      clickHandler = function()
        self:onClickMenuBtn(btnKey)
      end,
      pressScale = 0.95,
      clickInterval = 0.5
    })
  end
end
