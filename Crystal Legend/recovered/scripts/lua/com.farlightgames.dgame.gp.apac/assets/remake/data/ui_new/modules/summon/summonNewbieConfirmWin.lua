local base = ed.ui.popwindow
local summonNewbieConfirmWin = newclass(base.mt)
ed.ui.summonNewbieConfirmWin = summonNewbieConfirmWin

function summonNewbieConfirmWin:init(param)
  param = param or {}
  self.destroyCallback = param.destroyCallback
  self.time = param.time or 10
  self.tid = param.tid
  self:initView()
  self:listenTimer(Timer:Always(1), function()
    self.time = self.time - 1
    if self.time > 0 then
      ed.setString(self.ui.label_ok, string.format(T("\231\161\174\232\174\164(%ds)"), self.time))
    else
      self.ui.btn_ok:setVisible(true)
      self.ui.btn_ok_Copy0:setVisible(false)
    end
  end)
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.time <= 0 then
      ed.summonNet:send("switch_wish", {
        _hero_id = self.tid
      })
    end
  end, {pressScale = 0.9})
end

function summonNewbieConfirmWin:initLabels()
  local tip_label = T("<lable color=ccc3(255,233,248) strokeColor=ccc3(111,45,112) strokeSize=1>\233\128\137\229\174\154\229\144\142\229\176\134</lable>\230\151\160\230\179\149\228\191\174\230\148\185")
  local atText = ed.ui.autoText.new()
  atText:initParam({
    context = tip_label,
    fontSize = 18,
    color = ccc3(255, 0, 4)
  })
  self.ui.ImageView_739:addChild(atText.node)
  ed.layout.centerInParent(atText.node)
  local wid, _ = atText:getCurContentSize()
  atText.node:setPositionX(atText.node:getPositionX() - wid * 0.5)
  ed.setLabelStroke(self.ui.label_cancel, ed.toccc3(4925829), 1)
  ed.setLabelStroke(self.ui.label_ok1, ed.toccc3(4925829), 1)
  ed.setLabelStroke(self.ui.label_ok, ed.toccc3(5720177), 1)
  ed.setLabelStroke(self.ui.label_hot, ed.toccc3(7353983), 1)
  self.ui.name:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.name, ed.toccc3(8344356), 1)
end

function summonNewbieConfirmWin:initView()
  ed.editorui(ed.uieditor.newbieSummonConfirmWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.puppet, self.cha = ed.readhero.getActor(self.tid, "Idle")
  self:addFca(self.puppet)
  ed.UITool.replaceUINew(self.ui, "hero", self.puppet)
  ed.setString(self.ui.name, ed.lookupDataTable("Unit", "Display Name", self.tid))
  self.ui.label_hot:setString(ed.hothero.manager:getHeroHot(self.tid))
  local fca = ed.createFcaNode("eff_UI_SummonBeginner_HeroChoose")
  self.ui.bg_hero:addChild(fca)
  fca:setPosition(ccp(115, 99))
  self:addFca(fca)
  if self.time > 0 then
    ed.setString(self.ui.label_ok, string.format(T("\231\161\174\232\174\164(%ds)"), self.time))
  else
    self.ui.btn_ok:setVisible(true)
    self.ui.btn_ok_Copy0:setVisible(false)
  end
end

function summonNewbieConfirmWin.create(param)
  local self = base.create("summonNewbieConfirmWin")
  setmetatable(self, summonNewbieConfirmWin.mt)
  self:init(param)
  self:listenEvent("SummonSwitchWish", function(success)
    if success then
      ed.summonMgr.newbieHeroId = self.tid
      FireEvent("SummonNewbieSelectSuccess", success)
      self:destroy({skipAnim = true})
    end
  end)
  self:popWindow()
  return self
end
