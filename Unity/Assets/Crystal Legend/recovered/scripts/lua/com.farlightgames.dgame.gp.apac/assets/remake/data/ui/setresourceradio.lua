local base = ed.ui.popwindow
local SetResRadioWin = {}
SetResRadioWin.__index = SetResRadioWin
setmetatable(SetResRadioWin, base.mt)
ed.ui.SetResRadioWin = SetResRadioWin

function SetResRadioWin.create()
  local self = base.create("MagicStone_Storage_ComparePanel")
  setmetatable(self, SetResRadioWin)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  return self
end

function SetResRadioWin:initData()
  self.radios = {
    {width = 1500, height = 600},
    {width = 1600, height = 720},
    {width = 1624, height = 750},
    {width = 1600, height = 900},
    {width = 1194, height = 834},
    {width = 1080, height = 810},
    {width = 900, height = 900},
    {width = 1600, height = 900}
  }
  self.currentIndex = 8
  local frameSize = ed.display.frameSize
  local canMatch = false
  for i = 1, #self.radios do
    if self.radios[i].width == frameSize.width and self.radios[i].height == frameSize.height then
      self.currentIndex = i
      canMatch = true
    end
  end
  if not canMatch then
    self.radios[self.currentIndex] = frameSize
  end
end

function SetResRadioWin:createSearchLayer()
  local posX, posY = 122, -122
  self.ui.edit_frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/activate_input.png",
      capInsets = CCRectMake(12, 10, 12, 22)
    },
    layout = {
      position = ccp(122, -122)
    },
    config = {
      scaleSize = CCSizeMake(60, 30)
    }
  }, self.ui.selectLayer)
  local info = {
    config = {
      editSize = self.ui.edit_frame:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(255, 255, 255),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setString(self.radios[8].width)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(95, -138))
  self.ui.selectLayer:addChild(edit_box.edit)
  self.edit_box = edit_box
  local info1 = {
    config = {
      editSize = self.ui.edit_frame:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(255, 255, 255),
      fontSize = 20
    }
  }
  local edit_box1 = editBox:new(info)
  edit_box1:setString(self.radios[8].height)
  edit_box1.edit:setAnchorPoint(ccp(0, 0))
  edit_box1.edit:setPosition(ccp(184, -138))
  self.ui.selectLayer:addChild(edit_box1.edit)
  self.edit_box1 = edit_box1
  self:btRegisterHandler({
    handler = function(event, x, y)
      print(x, y)
      self.edit_box:touch(event, x, y)
      self.edit_box1:touch(event, x, y)
    end,
    key = "edit_box"
  })
  self:registerUpdateHandler("setting_radio", function()
    local num = tonumber(self.edit_box:getString())
    if num and 0 < num then
      self.radios[8].width = tonumber(self.edit_box:getString())
      local radio = self.radios[8].width / self.radios[8].height
      ed.setString(self.ui.item_label8, string.format(T("\232\135\170\229\174\154\229\136\134\232\190\168\231\142\135     \229\174\158\230\151\182\230\175\148\231\142\135%0.2f:1"), radio))
    end
    num = tonumber(self.edit_box1:getString())
    if num and 0 < num then
      self.radios[8].height = tonumber(self.edit_box1:getString())
      local radio = self.radios[8].width / self.radios[8].height
      ed.setString(self.ui.item_label8, string.format(T("\232\135\170\229\174\154\229\136\134\232\190\168\231\142\135     \229\174\158\230\151\182\230\175\148\231\142\135%0.2f:1"), radio))
    end
  end)
end

function SetResRadioWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.SetResolutionRatioWin)
  self.ui = ui
  self.container:addChild(container)
  ui["item_selected" .. self.currentIndex]:setVisible(true)
  ui.width_label:setVisible(false)
  ui.height_label:setVisible(false)
  self:createSearchLayer()
  self.isFullScreen = CCUserDefault:sharedUserDefault():getBoolForKey("FullScreen")
  ui.item_selectedFull:setVisible(self.isFullScreen)
end

function SetResRadioWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "button_close", function()
    self:onClickClose()
  end)
  ed.UITool.registerBtn(self, "button_ok", function()
    print(self.currentIndex)
    ed.pt(self.radios[self.currentIndex])
    local width = self.radios[self.currentIndex].width
    local height = self.radios[self.currentIndex].height
    ed.storage.setValue("FrameWidth", width)
    ed.storage.setValue("FrameHeight", height)
    local director = CCDirector:sharedDirector()
    local glview = director:getOpenGLView()
    glview:setFrameSize(width, height)
    os.execute(".\\reset.bat")
    os.exit(0)
  end)
  for i = 1, #self.radios do
    ed.UITool.registerBtn(self, "item" .. i, function()
      self:changeRadio(i)
    end)
  end
  ed.UITool.registerBtn(self, "itemFull", function()
    self:setFullScreen()
  end)
end

function SetResRadioWin:changeRadio(i)
  self.ui["item_selected" .. self.currentIndex]:setVisible(false)
  self.currentIndex = i
  self.ui["item_selected" .. self.currentIndex]:setVisible(true)
end

function SetResRadioWin:setFullScreen()
  self.isFullScreen = not self.isFullScreen
  self.ui.item_selectedFull:setVisible(self.isFullScreen)
  CCUserDefault:sharedUserDefault():setBoolForKey("FullScreen", self.isFullScreen)
  os.exit(0)
end

function SetResRadioWin:destroy()
  base.destroy(self)
end

function SetResRadioWin:onClickClose()
  self:destroy()
end
