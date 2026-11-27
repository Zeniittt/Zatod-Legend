local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.heroRecycleConfirmWindow = class
class.DESC = T("\228\187\133\230\156\137<lable color=heroRecycleColor1>1</lable>\230\172\161\233\135\141\231\148\159\230\156\186\228\188\154\239\188\140\231\161\174\229\174\154\229\176\134<lable color=heroRecycleColor1>%s</lable>\233\135\141\231\148\159\228\184\186\229\136\157\229\167\139\231\138\182\230\128\129\229\144\151\239\188\159\233\135\141\231\148\159\229\144\142\230\151\160\230\179\149\230\146\164\229\155\158\239\188\140\232\175\183\232\176\168\230\133\142\233\128\137\230\139\169\227\128\130<br/>") .. T("<lable color=heroRecycleColor2>\233\135\141\231\148\159\229\144\142\239\188\140\232\139\177\233\155\132\231\187\180\230\140\129\231\142\176\230\156\137\230\152\159\231\186\167\239\188\140\232\191\148\232\191\152\231\154\132\232\181\132\230\186\144\229\176\134\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\233\128\129\227\128\130</lable>")
ed.UITool.registViewOpenFunc("heroRecycleConfirmWindow", function(param)
  ed.heroRecycleConfirmWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("heroRecycleConfirmWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.selectHeroId = param.selectHeroId or 1
  self.confirmCallBack = param.confirmCallBack
  self:initView()
  self:addTouchEvent()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:show()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.hero_recycle_confirm_window)
  self.ui = ui
  self.container:addChild(container)
  self.ui.ImageView_10590:setScaleX(-1)
  self:initLabels()
  self:initDescDragList()
  self:refreshDesc()
  self.confirmCountDown = 10
  self:refreshBtnConfirm()
  self:listenTimer(Timer:Always(1, "confirmCountDown"), function()
    self.confirmCountDown = self.confirmCountDown - 1
    self:refreshBtnConfirm()
  end)
end

function class:initLabels()
  ed.setLabelShadow(self.ui.label_title, ed.toccc3(0), ccp(0, 1.5))
  ed.setLabelShadow(self.ui.label_cancel, ed.toccc3(0), ccp(0, 1.5))
  ed.setLabelShadow(self.ui.label_confirm, ed.toccc3(0), ccp(0, 1.5))
end

function class:initDescDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_desc)
end

function class:refreshBtnConfirm()
  if self.confirmCountDown > 0 then
    ed.setLabelString(self.ui.label_confirm, string.format(T("\231\161\174\229\174\154\239\188\136%ss\239\188\137"), self.confirmCountDown))
    ed.setTexture(self.ui.btn_confirm, "UI/alpha/1080P/common/button_mini_grey.png")
  else
    ed.setLabelString(self.ui.label_confirm, T("\231\161\174\229\174\154"))
    ed.setTexture(self.ui.btn_confirm, "UI/alpha/1080P/common/button_com_mini.png")
    CloseTimer("confirmCountDown")
  end
end

function class:refreshDesc()
  local panelSize = self.ui.panel_desc:getContentSize()
  self.dragList:clearList()
  local heroName = ed.getDataTable("Unit")[self.selectHeroId]["Display Name"]
  local desc = string.format(self.DESC, heroName)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ccc3(255, 252, 231),
    maxWidth = panelSize.width,
    fontSize = 18
  })
  local autoTextW, autoTextH = autoText:getCurContentSize()
  self.dragList:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, panelSize.height - 9))
  self.dragList:initListHeight(autoTextH)
end

function class:onClickBtnConfirm()
  if self.confirmCountDown > 0 then
    return
  end
  if self.confirmCallBack then
    self.confirmCallBack()
  end
  self:destroy({skipAnim = true})
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
end
