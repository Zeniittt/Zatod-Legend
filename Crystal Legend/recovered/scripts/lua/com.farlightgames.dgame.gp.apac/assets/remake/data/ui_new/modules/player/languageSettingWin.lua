local base = ed.ui.popwindow
local languageSettingWin = newclass(base.mt)
ed.ui.languageSettingWin = languageSettingWin
local Multi_Language = {
  {
    key = "cn",
    des = "\231\174\128\228\189\147\228\184\173\230\150\135",
    isAudio = true,
    isVisible = true
  },
  {
    key = "tw",
    des = "\231\185\129\233\171\148\228\184\173\230\150\135",
    isAudio = true,
    isVisible = true
  },
  {
    key = "en",
    des = "English",
    isAudio = true,
    isVisible = true
  },
  {
    key = "ja",
    des = "\230\151\165\230\156\172\232\170\158",
    isAudio = false,
    isVisible = true
  },
  {
    key = "ko",
    des = "\237\149\156\234\181\173\236\150\180",
    isAudio = false,
    isVisible = true
  },
  {
    key = "es",
    des = "espa\195\177ol",
    isAudio = false,
    isVisible = function()
      if EDFLAGIOS then
        return EDGetVersionCode() >= 100087
      elseif EDFLAGANDROID then
        return EDGetVersionCode() >= 100293
      elseif EDFLAGWIN32 then
        return true
      end
      return false
    end
  }
}
ed.Multi_Language = Multi_Language

function languageSettingWin.create()
  local self = base.create("languageSettingWin")
  setmetatable(self, languageSettingWin.mt)
  self:init()
  self:show()
  return self
end

function languageSettingWin:init()
  self.curChooseLan = EDCurLanguage
  self.curChooseSoundLan = EDCurSoundLan
  self:initView()
  self:addEventListener()
  self:registerTouchHandlers()
end

function languageSettingWin:initView()
  local container, ui = ed.editorui(ed.uieditor.languageSettingWin)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelShadow(self.ui.label_sure, ccc3(0, 0, 0), ccp(0, 2))
  self:createDraglist()
end

function languageSettingWin:createTitleItem(des)
  local container, ui = ed.editorui(ed.uieditor.languageSettingTitleItem)
  ed.setLabelString(ui.label_des, des)
  ed.right2(ui.label_des, ui.icon, 3)
  ed.right2(ui.line, ui.label_des, 3)
  return container, ui
end

function languageSettingWin:createSelectionItem(key, des, isSelected)
  local container, ui = ed.editorui(ed.uieditor.languageSettingSelectionItem)
  ed.setLabelString(ui.label_language, des)
  ed.setLabelStroke(ui.label_language, ed.toccc3(5586983), 1)
  ui.label_language:setFontName(ed.fontSystem)
  ui.img_selected:setVisible(isSelected)
  ed.setTexture(ui.bg, isSelected and "UI/alpha/1080P/common/global/language_bg1.png" or "UI/alpha/1080P/common/global/language_bg2.png")
  return container, ui
end

function languageSettingWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function languageSettingWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.bg, x, y) then
      if v.data.type == 1 then
        self.curChooseLan = v.data.key
      else
        self.curChooseSoundLan = v.data.key
      end
      for _, tmp in ipairs(self.uiList) do
        if tmp.data.type == v.data.type then
          tmp.img_selected:setVisible(tmp.data.key == v.data.key)
        end
      end
    end
  end
  
  return handler
end

function languageSettingWin:createDraglist()
  self.uiList = {}
  if nil ~= self.draglist then
    self.draglist:clearList()
  else
    self.draglist = ed.UITool.createDraglist(self.ui.btns_panel, {
      doPressIn = self:doPressInList(),
      doClickIn = self:doClickInList()
    })
  end
  local contentSize = self.ui.btns_panel:getContentSize()
  local posY = contentSize.height
  local lineSpaceY = 5
  local itemSpaceY = 5
  local spaceY = 0
  local languageTitleContainer, languageTitleUI = self:createTitleItem(T("\232\175\173\232\168\128"))
  local itemSize = languageTitleUI.panel_content:getContentSize()
  posY = posY - itemSize.height
  languageTitleContainer:setPosition(ccp(contentSize.width * 0.5, posY + itemSize.height * 0.5))
  self.draglist:addItem(languageTitleContainer)
  spaceY = lineSpaceY
  local index = 0
  for _, v in ipairs(Multi_Language) do
    local show
    if type(v.isVisible) == "function" then
      show = v.isVisible()
    else
      show = v.isVisible
    end
    if show then
      local selectionContainer, selectionUI = self:createSelectionItem(v.key, v.des, v.key == self.curChooseLan)
      selectionUI.data = {
        type = 1,
        key = v.key
      }
      table.insert(self.uiList, selectionUI)
      self.draglist:addItem(selectionContainer)
      itemSize = selectionUI.bg:getContentSize()
      index = index + 1
      if index == 1 then
        posY = posY - itemSize.height - spaceY
      end
      selectionContainer:setPosition(ccp(contentSize.width / 2 * (index - 0.5), posY + itemSize.height * 0.5))
      if index == 2 then
        index = 0
        spaceY = itemSpaceY
      end
    end
  end
  if 0 < index then
    spaceY = lineSpaceY
  end
  local soundTitleContainer, soundTitleUI = self:createTitleItem(T("\232\175\173\233\159\179"))
  itemSize = soundTitleUI.panel_content:getContentSize()
  posY = posY - itemSize.height - spaceY
  soundTitleContainer:setPosition(ccp(contentSize.width * 0.5, posY + itemSize.height * 0.5))
  self.draglist:addItem(soundTitleContainer)
  spaceY = lineSpaceY
  local index = 0
  for _, v in pairs(Multi_Language) do
    local show
    if type(v.isVisible) == "function" then
      show = v.isVisible()
    else
      show = v.isVisible
    end
    if v.isAudio and show then
      local selectionContainer, selectionUI = self:createSelectionItem(v.key, v.des, v.key == self.curChooseSoundLan)
      selectionUI.data = {
        type = 2,
        key = v.key
      }
      table.insert(self.uiList, selectionUI)
      self.draglist:addItem(selectionContainer)
      itemSize = selectionUI.bg:getContentSize()
      index = index + 1
      if index == 1 then
        posY = posY - itemSize.height - spaceY
      end
      selectionContainer:setPosition(ccp(contentSize.width / 2 * (index - 0.5), posY + itemSize.height * 0.5))
      if index == 2 then
        index = 0
        spaceY = itemSpaceY
      end
    end
  end
  self.draglist:initListHeight(contentSize.height - posY)
end

function languageSettingWin:addEventListener()
end

function languageSettingWin:onSureEvent()
  if self.curChooseLan == EDCurLanguage and self.curChooseSoundLan == EDCurSoundLan then
    self:destroy()
    return
  end
  ed.showConfirmDialog({
    text = T("\233\156\128\232\166\129\233\135\141\229\144\175\230\184\184\230\136\143\230\137\141\232\131\189\231\148\159\230\149\136\227\128\130"),
    leftHandler = function()
    end,
    rightHandler = function()
      if self.curChooseLan ~= EDCurLanguage then
        ed.setCurLan(self.curChooseLan)
      end
      if self.curChooseSoundLan ~= EDCurSoundLan then
        ed.setCurSoundLan(self.curChooseSoundLan)
      end
      EDRestartGame()
    end
  })
end

function languageSettingWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_sure", function()
    self:onSureEvent()
  end, {normalScale = 1, pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
end
