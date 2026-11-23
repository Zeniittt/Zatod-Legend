local layerShard = {}
ed.ui.heroShowPop.heroMode.layerShard = layerShard

function layerShard.create(popSelf, param)
  local base = ed.ui.heroDetailScene.newShard.create({
    controller = popSelf,
    pos = ccp(0, 0),
    hero = {data = param}
  })
  popSelf.ui.bg:addChild(base.mainLayer)
  base.ui.panel_consume:setVisible(false)
  base.ui.btn_qh:setVisible(false)
  return setmetatable({
    popSelf = popSelf,
    param = param,
    base = base
  }, {__index = layerShard}):init()
end

function layerShard:init()
  self.hero = self.param
  self.hid = self.hero._tid
  return self
end

function layerShard:show(vis, param)
  self.base.mainLayer:setVisible(vis)
end

function layerShard:refresh(param)
  if param then
    self.hero = param
    self.hid = self.hero._tid
  end
  self.base:refreshUI()
end

function layerShard:adaptUI(vis, param)
  local fixWidth = (ed.display.winSize.width - 960) * 0.66
  self.ui.img_right_bg:setContentSize(CCSizeMake(self.ui.img_right_bg:getContentSize().width + fixWidth, self.ui.img_right_bg:getContentSize().height))
  self.ui.img_right_bg:setPositionX(self.ui.img_right_bg:getPositionX() + fixWidth / 2)
  self.ui.img_lv_bg:setContentSize(CCSizeMake(self.ui.img_lv_bg:getContentSize().width + fixWidth, self.ui.img_lv_bg:getContentSize().height))
  self.ui.img_lv_bg:setPositionX(self.ui.img_lv_bg:getPositionX() + fixWidth / 2)
  self.ui.img_title:setPositionX(self.ui.img_title:getPositionX() + fixWidth / 2)
  self.ui.panel_attr_txt:setContentSize(CCSizeMake(self.ui.panel_attr_txt:getContentSize().width + fixWidth, self.ui.panel_attr_txt:getContentSize().height))
  self.ui.img_title_2:setPositionX(self.ui.img_title_2:getPositionX() + fixWidth / 2)
  self.ui.img_fa_bg:setContentSize(CCSizeMake(self.ui.img_fa_bg:getContentSize().width + fixWidth, self.ui.img_fa_bg:getContentSize().height))
  self.ui.img_fa_bg:setPositionX(self.ui.img_fa_bg:getPositionX() + fixWidth / 2)
  local size = self.ui.panel_fa:getContentSize()
  self.ui.panel_fa:setContentSize(CCSizeMake(size.width + fixWidth, size.height))
  self.ui.panel_fa:setClipRect(CCRectMake(0, 0, size.width + fixWidth, size.height))
  size = self.ui.panel_skil_txt:getContentSize()
  self.ui.panel_skil_txt:setContentSize(CCSizeMake(size.width + fixWidth, size.height))
  for i = 1, 25 + math.ceil(fixWidth / 20) do
    local fa = ed.createSprite("UI/alpha/1080P/shard/img_shard_fa.png")
    fa:setPosition(ccp(i * 20 - 8, 215))
    fa:setOpacity(80)
    self.ui.panel_fa:addChild(fa)
  end
  self.ui.panel_consume:setPositionX(self.ui.panel_consume:getPositionX() + fixWidth / 2)
  self.ui.btn_qh:setPositionX(self.ui.btn_qh:getPositionX() + fixWidth / 2)
  self.ui.img_lock_bg:setPositionX(self.ui.img_lock_bg:getPositionX() + fixWidth / 2)
  self.ui.img_lv_max:setPositionX(self.ui.img_lv_max:getPositionX() + fixWidth / 2)
  ed.setLabelStroke(self.ui.Label_23550, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.shard_label_level, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_23755, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_23743, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_23750, ccc3(39, 37, 36), 1)
  self.ui.Label_23755:limitWidthByScale(176)
end
