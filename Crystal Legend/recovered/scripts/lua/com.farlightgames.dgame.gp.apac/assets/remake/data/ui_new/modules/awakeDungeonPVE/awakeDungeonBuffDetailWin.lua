local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonBuffDetailWin = class

function class.create(param)
  local self = base.create("awakeDungeonBuffDetailWin", {notBlurBg = true, noShade = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.chapterId = param.chapterId
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonBuffDetailWin)
  self.container:addChild(container)
  self.ui = ui
  self:refreshBuff()
end

function class:refreshBuff()
  local buffInfo, nextBuffInfo = self.dungeonMgr:getBuffInfoByChapterId(self.chapterId)
  if not buffInfo then
    return
  end
  local buffEndTime = buffInfo.buffEndTime
  local duration = buffInfo.duration
  local day = duration / 24
  local hour = duration - day * 24
  local buffVal = buffInfo.shortDesc
  if 0 < buffVal then
    ed.setLabelString(self.ui.label_buff_title, T("\229\133\136\229\143\145\230\140\145\230\136\152"))
    ed.setLabelString(self.ui.label_buff_desc2, T("\229\156\168\229\156\176\229\186\149\229\142\134\233\153\169\228\184\173\239\188\140\232\182\138\233\157\160\229\144\142\231\154\132\231\171\160\232\138\130\230\149\140\228\186\186\229\188\186\229\186\166\229\176\134\229\190\151\229\136\176\232\182\138\233\171\152\229\138\160\230\136\144\239\188\140\232\191\153\231\167\141\229\138\160\230\136\144\229\176\134\233\154\143\230\151\182\233\151\180\232\161\176\229\135\143"))
  elseif buffVal < 0 then
    ed.setLabelString(self.ui.label_buff_title, T("\230\155\153\229\133\137\233\153\141\228\184\180"))
    ed.setLabelString(self.ui.label_buff_desc2, T("\229\156\168\229\156\176\229\186\149\229\142\134\233\153\169\230\180\187\229\138\168\231\187\147\230\157\159\229\137\141,\230\149\140\228\186\186\229\188\186\229\186\166\229\176\134\229\143\151\229\136\176\228\184\128\229\174\154\231\154\132\229\137\138\229\188\177"))
  else
    ed.setLabelString(self.ui.label_buff_title, T("\230\154\130\230\151\160\229\188\186\229\140\150"))
    ed.setLabelString(self.ui.label_buff_desc2, T("\232\175\165\231\171\160\232\138\130\231\155\174\229\137\141\229\164\132\228\186\142\230\175\148\232\190\131\229\185\179\233\157\153\231\154\132\231\138\182\230\128\129\239\188\140\230\128\170\231\137\169\228\184\141\228\188\154\229\190\151\229\136\176\229\138\160\230\136\144\228\185\159\228\184\141\228\188\154\229\143\151\229\136\176\229\137\138\229\188\177"))
  end
  ed.setLabelString(self.ui.label_buff_desc1, buffInfo.desc)
  ed.left2(self.ui.ImageView_24652, self.ui.label_buff_title, 3.5)
  ed.right2(self.ui.ImageView_24653, self.ui.label_buff_title, 3.5)
  ed.adaptLabel(self.ui.label_buff_desc1, {maxWidth = 390, minScale = 0.7})
  ed.setLabelDimensions(self.ui.label_buff_desc2, CCSizeMake(390, 0))
  local deltaHei = (self.ui.label_buff_desc2:getContentSize().height + self.ui.label_buff_desc1:getContentSize().height) * 0.5
  self.ui.label_buff_desc2:setPositionY(self.ui.label_buff_desc1:getPositionY() - deltaHei - 3)
  local leftTime = buffEndTime - ed.getServerTime()
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local nextBuffVal = nextBuffInfo and nextBuffInfo.shortDesc or 0
  if 0 < nextBuffVal then
    ed.setLabelString(self.ui.label_next_buff_time, T("\229\176\134\229\156\168{1}\229\164\169{2}\230\151\182{3}\229\136\134\229\144\142\232\161\176\229\135\143\228\184\186{4}%%\229\188\186\229\140\150", day, hour, min, nextBuffVal))
  elseif nextBuffVal < 0 then
    ed.setLabelString(self.ui.label_next_buff_time, T("\229\176\134\229\156\168{1}\229\164\169{2}\230\151\182{3}\229\136\134\229\144\142\232\189\172\229\143\152\228\184\186{4}%%\229\137\138\229\188\177", day, hour, min, -nextBuffVal))
  else
    ed.setLabelString(self.ui.label_next_buff_time, T("\229\176\134\229\156\168{1}\229\164\169{2}\230\151\182{3}\229\136\134\229\144\142\229\164\177\229\142\187\229\188\186\229\140\150\230\149\136\230\158\156", day, hour, min, nextBuffVal))
  end
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
