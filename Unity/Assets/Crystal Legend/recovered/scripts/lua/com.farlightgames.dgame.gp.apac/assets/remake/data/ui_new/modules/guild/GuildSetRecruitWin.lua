local base = ed.ui.popwindow
local GuildSetRecruitWin = newclass(base.mt)
ed.ui.GuildSetRecruitWin = GuildSetRecruitWin

function GuildSetRecruitWin.create()
  local self = base.create("GuildSetRecruitWin")
  setmetatable(self, GuildSetRecruitWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildSetRecruitWin:initData()
  self.recruitDetail = ed.GuildManager.recruitDetail
end

function GuildSetRecruitWin:initEditBox()
  local info = {
    config = {
      editSize = self.ui.bg_input:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    }
  }
  local edit_box = editBox:new(info)
  if EDFLAGIOS then
    edit_box:setVisible(true)
    self.ui.Label_124434:setVisible(false)
  else
    edit_box:setVisible(false)
  end
  edit_box:setEnabled(true)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.ui.bg_input:addChild(edit_box.edit)
  self.ui.edit_box = edit_box
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.ui.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
end

function GuildSetRecruitWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.GuildSetRecruitWin, {
    container = self.container,
    ui = self.ui
  })
  ed.left2(ui.line1, ui.title, 8)
  ed.right2(ui.line2, ui.title, 8)
  self:initEditBox()
  local size = self.ui.bg_input:getContentSize()
  ed.setLabelShadow(self.ui.label_cancle, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_ok, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelDimensions(self.ui.Label_124434, CCSizeMake(size.width - 30, 0))
  if self.recruitDetail then
    self.ui.edit_box:setString(self.recruitDetail)
    ed.setString(self.ui.Label_124434, self.recruitDetail)
    ed.setLabelColor(self.ui.Label_124434, ed.toccc3(16776423))
  end
end

function GuildSetRecruitWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  self:registerUpdateHandler("setRecruitDetail", function()
    local recruitDetail = self.ui.edit_box:getString()
    if self.recruitDetail ~= recruitDetail then
      self.recruitDetail = recruitDetail
      ed.setLabelColor(self.ui.Label_124434, ed.toccc3(16776423))
      ed.setString(self.ui.Label_124434, self.recruitDetail)
    end
  end)
  ed.UITool.registerBtn(self, "btn_cancle", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.recruitDetail ~= ed.GuildManager.recruitDetail then
      local name = string.gsub(self.recruitDetail, "[\r\n]", "")
      local _, count = string.gsub(name, "[^\128-\193]", "")
      if 20 < count then
        ed.showToast(T("\230\139\155\229\139\159\229\174\163\232\168\128\228\184\141\232\131\189\232\182\133\232\191\13520\228\184\170\229\173\151!!!"))
        return
      end
      ed.GuildNetwork:sendSetRecruit(self.recruitDetail)
    end
    self:destroy()
  end, {pressScale = 0.95})
end

function GuildSetRecruitWin:destroy()
  self:removeUpdateHandler("setRecruitDetail")
  base.destroy(self)
end
