local guideDialogue = newclass("g")
ed.guide.dialog = guideDialogue

function guideDialogue.create(parent)
  local self = {}
  setmetatable(self, guideDialogue.mt)
  self:init(parent)
  self:hide()
  return self
end

function guideDialogue:init(parent)
  self.container, self.ui = ed.editorui(ed.uieditor.guideDialogue)
  parent:addChild(self.container, 10)
  self.ui.dialog_bg:setAnchorPoint(ccp(0, 1))
  self.ui.dialog_text:setAnchorPoint(ccp(0, 1))
  ed.setLabelShadow(self.ui.dialog_text, ccc3(0, 0, 0), ccp(0, 2))
end

function guideDialogue:hide()
  self.container:setVisible(false)
end

function guideDialogue:show(dialogueId)
  if not dialogueId then
    self.container:setVisible(true)
    return
  end
  local data = ed.guide.data:getDialogData(dialogueId)
  if not data then
    return
  end
  self.data = data
  self.container:setVisible(true)
  ed.initSpriteWithFrame(self.ui.head, data.Head)
  local headSize = self.ui.head:getContentSize()
  local dialogSize = ed.DGSizeMake(unpack(data.DialogSize))
  self.ui.dialog_text:setDimensions(CCSizeMake(dialogSize.width - 58, 0))
  self.ui.dialog_text:setString(data.Content)
  local labelSize = self.ui.dialog_text:getContentSize()
  dialogSize.width = math.max(dialogSize.width, labelSize.width + 20, 420 / ed.display.scaleFactor)
  dialogSize.height = math.max(dialogSize.height, labelSize.height + 20, 120 / ed.display.scaleFactor)
  local pos = ccp(unpack(data.DialogPos))
  pos.x = pos.x / ed.display.resourceSize.width * ed.display.winSize.width
  pos.y = pos.y / ed.display.resourceSize.height * ed.display.winSize.height
  pos.y = ed.clamp(pos.y, dialogSize.height, ed.display.winSize.height - headSize.height + dialogSize.height)
  local flipX = pos.x > ed.display.winSize.width / 2
  if flipX then
    self.ui.dialog_bg:setScaleX(-1)
    self.ui.dialog_text:setScaleX(-1)
    self.ui.dialog_text:setAnchorPoint(ccp(1, 0.5))
    pos.x = ed.clamp(pos.x, headSize.width / 1.4, ed.display.winSize.width - headSize.width / 1.4)
  else
    self.ui.dialog_bg:setScaleX(1)
    self.ui.dialog_text:setScaleX(1)
    self.ui.dialog_text:setAnchorPoint(ccp(0, 0.5))
    pos.x = ed.clamp(pos.x, headSize.width / 1.4, ed.display.winSize.width - dialogSize.width - headSize.width + 40)
  end
  self.ui.dialog_bg:setContentSize(dialogSize)
  self.ui.dialog_text:setPositionY(dialogSize.height / 2)
  self:playAnim(pos, dialogSize.width + headSize.width)
end

function guideDialogue:playAnim(pos, len)
  local sp = ccp(pos.x, pos.y)
  if pos.x < ed.display.winSize.width / 2 then
    sp.x = sp.x - len
  else
    sp.x = ed.display.winSize.width
  end
  self.ui.dialog_bg:setPosition(sp)
  local ac = CCMoveTo:create(0.3, pos)
  ac = CCEaseBackOut:create(ac)
  if self.data.Delay then
    local delay = CCDelayTime:create(self.data.Delay)
    ac = CCSequence:createWithTwoActions(delay, ac)
  end
  self.ui.dialog_bg:runAction(ac)
end

function guideDialogue:setContent(content)
  if content then
    self.ui.dialog_text:setString(content)
    return
  end
  if not self.data then
    return
  end
  self.ui.dialog_text:setString(self.data.Content)
end
