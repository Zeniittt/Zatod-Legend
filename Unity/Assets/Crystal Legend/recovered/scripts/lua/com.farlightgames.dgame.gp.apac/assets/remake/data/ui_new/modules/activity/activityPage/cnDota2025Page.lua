local class = newclass("g")
ed.ui.cnDota2025Page = class

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  local container, ui = ed.editorui(ed.uieditor.cn_dota_2025)
  self.ui = ui
  self.param = param
  self.pageKey = pageKey or ""
  self.container = container
  self.cfgId = param._cfg_id
  self:initView(param)
  self:setButtonClick()
  return self
end

function class:initView(param)
  self:adaptUI()
  self:initLabels()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_go, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_desc, ed.toccc3(10116101), 1.5)
  local desc = ed.getDataTable("Activity")[self.cfgId]["Extra Str"][1]
  self.ui.label_desc:setString(desc)
  self.ui.label_desc:setHorizontalAlignment(kCCTextAlignmentLeft)
  self.ui.label_desc:setDimensions(CCSizeMake(self.ui.image_desc_bg:getContentSize().width - 75, 0))
end

function class:getIsShowBtnRule()
  return false
end

function class:adaptUI()
  local winSize = ed.display.winSize
  local diffWidth = winSize.width - 960
  self.ui.image_desc_bg:setPositionX(self.ui.image_desc_bg:getPositionX() - diffWidth / 2)
  local oldDescBgSize = self.ui.image_desc_bg:getContentSize()
  self.ui.image_desc_bg:setContentSize(CCSizeMake(oldDescBgSize.width + diffWidth / 2, oldDescBgSize.height))
  self.ui.image_tatoo_right:setPositionX(self.ui.image_tatoo_right:getPositionX() + diffWidth)
  self.ui.image_avatar:setScale(math.min(1, winSize.width / 960 * 0.9))
  local logoOffsetX = self.ui.image_avatar:getContentSize().width * (self.ui.image_avatar:getScale() - 0.9) / 2
  self.ui.image_logo:setPositionX(self.ui.image_logo:getPositionX() + logoOffsetX)
end

function class:pageUpDate(param)
end

function class:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.btn_go,
    key = "btn_go",
    force = true,
    mcpMode = true,
    pressScale = 0.94,
    clickHandler = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "ActiveGift"}))
      end
    end
  })
end
