local base = ed.ui.popwindow
local SkillMultiPlayerWarn = newclass(base.mt)
ed.ui.SkillMultiPlayerWarn = SkillMultiPlayerWarn

function SkillMultiPlayerWarn.create(params)
  local obj = base.create("SkillMultiPlayerWarn", {notBlurBg = true})
  setmetatable(obj, SkillMultiPlayerWarn.mt)
  obj:initWindow(params)
  return obj
end

function SkillMultiPlayerWarn:initUI()
  ed.editorui(ed.uieditor.SoloMultiplayerwarn, {
    container = self.container,
    ui = self.ui
  })
  self.ui.img_bg_joinroom:setVisible(self.params.joinroom or false)
  self.ui.img_bg_matchroom:setVisible(self.params.matchroom or false)
  self.ui.img_bg_createroom:setVisible(self.params.createroom or false)
  ed.setString(self.ui.lab_title_ctr, T("\230\173\163\229\156\168\228\184\186\230\130\168\229\136\155\229\187\186\233\152\159\228\188\141..."))
  ed.setString(self.ui.lab_title_jnr, T("\230\173\163\229\156\168\228\184\186\230\130\168\230\144\156\231\180\162\233\152\159\228\188\141..."))
  ed.setString(self.ui.lab_title_tag_jnr, T("\232\175\183\232\190\147\229\133\165\233\152\159\228\188\141ID\239\188\154"))
  self.ui.lab_title_tag_jnr:limitWidthByScale(200)
end

function SkillMultiPlayerWarn:initWindow(params)
  self.params = params
  self:initUI()
  self:registerTouchHandler()
  self.editbox:setVisible(false)
end

function SkillMultiPlayerWarn:show(params)
  self.showCallback = params.clickCall
  if self.params.createroom then
    self.ui.img_bg_createroom:setVisible(true)
    self.warnType = "createroom"
  elseif self.params.matchroom then
    self.ui.img_bg_matchroom:setVisible(true)
    self.warnType = "matchroom"
  elseif self.params.joinroom then
    self.ui.img_bg_joinroom:setVisible(true)
    self.warnType = "joinroom"
    self.editbox:setVisible(true)
  end
  if params.endCall then
    params.endCall()
  end
end

function SkillMultiPlayerWarn:registerEditBox(name, params)
  local item = self.ui[name]
  local x, y = item:getPosition()
  params = params or {}
  params.editSize = params.editSize or item:getContentSize()
  params.maxLength = params.maxLength or 24
  params.fontColor = params.fontColor or ccc3(255, 255, 255)
  params.fontSize = params.fontSize or 20
  local edit = editBox:new({config = params})
  local zOlder = params.zOlder or 10
  edit.edit:setAnchorPoint(ccp(0, 0))
  item:addChild(edit.edit, zOlder)
  local holder = params.holder or ""
  edit:setPlaceHolder(holder)
  self.editbox = edit
  self.editbox_info = params
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.editbox:touch(event, x, y)
    end,
    key = "editbox_" .. name
  })
end

function SkillMultiPlayerWarn:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_enter_jnr", function()
    self:onClickBtnEnterRoom()
  end)
  ed.UITool.registerBtn(self, "btn_cancel_mhr", function()
    self:onClickBtnCancel()
  end)
  ed.UITool.registerBtn(self, "btn_close_jnr", function()
    self:destroy()
  end)
  self:registerEditBox("layer_input_jnr", {
    holder = T("\232\175\183\232\190\147\229\133\165\233\152\159\228\188\141\229\143\183"),
    fontSize = 15
  })
end

function SkillMultiPlayerWarn:onClickBtnEnterRoom()
  if self.editbox and self.showCallback then
    local roomid = self.editbox:getString()
    if roomid == nil or roomid == "" then
      ed.showToast(T("\232\175\183\232\190\147\229\133\165\233\152\159\228\188\141\231\188\150\229\143\183"))
      return
    end
    if tonumber(roomid) == nil then
      ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\233\152\159\228\188\141\231\188\150\229\143\183"))
      return
    end
    self.showCallback(tonumber(roomid))
  end
end

function SkillMultiPlayerWarn:onClickBtnCancel()
  if self.showCallback then
    self.showCallback()
  end
  self:destroy()
end

function SkillMultiPlayerWarn:showJoinWarn(bShow)
  self.ui.btn_enter_jnr:setVisible(not bShow)
  self.ui.img_flower_jnr:setVisible(bShow)
end
