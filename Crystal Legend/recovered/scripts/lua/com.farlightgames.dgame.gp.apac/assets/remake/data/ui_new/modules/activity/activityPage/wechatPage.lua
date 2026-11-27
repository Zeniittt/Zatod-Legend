local wechatPage = newclass("g")
ed.ui.activityWechatPage = wechatPage

function wechatPage.create(base, param, pageKey)
  local this = {}
  setmetatable(wechatPage, {__index = base})
  setmetatable(this, {__index = wechatPage})
  local container, ui = ed.editorui(ed.uieditor.activity_wechat_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:initView(param)
  this:setButtonClick()
  this:listenEvent("manual_trigger_reply", function(info)
    this:manualTriggerReply(info)
  end)
  return this
end

function wechatPage:manualTriggerReply(info)
  if info._type == "activity_webchat_official" then
    self.objWork:activityPull(self.param._id)
  end
end

function wechatPage:initView(param)
  local task = param._tasks
  task = task[1] or {}
  local reward = task._rewards[1]
  
  function self:btRegisterButtonClickToListItems(param)
    self:btRegisterButtonClick({
      button = param.button,
      key = "wechatPage_" .. param.index,
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if self.isCompleted == 1 then
          local taskzzz = self.param._tasks
          taskzzz = taskzzz[1] or {}
          self.objWork:activitySubmit(self.param._id, taskzzz._id)
        else
          local data = param.data or {}
          ed.UITool.openView("packageDetail", data)
        end
      end,
      force = true,
      pressScale = 0.8,
      normalScale = 0.82
    })
  end
  
  local item = ed.taskItemModule.new(self, {
    id = reward._id,
    type = reward._type,
    amount = reward._amount
  }, nil, -1, false, false, true)
  self.ui.Panel_item:addChild(item.icon)
  item.icon:setScale(0.82)
  self.item = item
  self:pageUpDate(param)
  local cfgId = param._cfg_id
  local activityConfig = ed.getDataTable("Activity")[cfgId]
  local extraStr = activityConfig["Extra Str"] or {}
  self.extraStr = extraStr[1] or ""
  self.ui.Label_type:setFontName(ed.fontBold)
  local tip2 = T("<lable color=ccc3(246,211,141)>\229\133\179\230\179\168</lable><lable color=ccc3(172,214,230)>\226\128\156\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\230\137\139\230\184\184\226\128\157</lable><lable color=ccc3(246,211,141)>\229\133\172\228\188\151\229\143\183\233\162\134\229\143\150</lable>")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = tip2,
    fontSize = 14,
    maxWidth = 999
  })
  autoText.node:setPosition(ccp(72, 20))
  self.ui.ImageView_3217:addChild(autoText.node)
end

function wechatPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  task = task[1] or {}
  local isCompleted = task._progress >= task._cond_target
  local isFinished = task._cur_reward_times and task._cur_reward_times >= task._max_reward_times
  self.isCompleted = 0
  if isFinished then
    self.isCompleted = 2
    self.ui.Label_type:setString(T("\229\183\178\233\162\134\229\143\150"))
  elseif isCompleted then
    self.isCompleted = 1
    self.ui.Label_type:setString(T("\229\143\175\233\162\134\229\143\150"))
  else
    self.ui.Label_type:setString(T("\230\156\170\232\190\190\230\136\144"))
  end
  self.ui.Label_btn:setString(T("\229\137\141\229\190\128\229\133\179\230\179\168"))
  self.ui.ImageView_3219:setVisible(false)
  self.item:refresh(self.isCompleted)
end

function wechatPage:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.goto_btn,
    key = "goto",
    force = true,
    mcpMode = true,
    pressScale = 0.94,
    clickHandler = function()
      if not self.isCompleted then
        return
      end
      if self.isCompleted == 0 then
        self.ui.goto_btn:runAction(CCSequence:create(ccArrayMake(unpack({
          CCDelayTime:create(1),
          CCCallFunc:create(function()
            self.objWork:manualTriggerRed("activity_webchat_official")
          end)
        }))))
        ed.openURL(self.extraStr)
      elseif self.isCompleted == 1 then
        ed.openURL(self.extraStr)
      elseif self.isCompleted == 2 then
        ed.openURL(self.extraStr)
      end
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.copy_btn,
    key = "copy",
    force = true,
    mcpMode = true,
    pressScale = 0.45,
    normalScale = 0.5,
    clickHandler = function()
      ed.copyString(self.ui.Label_number:getString())
    end
  })
end
