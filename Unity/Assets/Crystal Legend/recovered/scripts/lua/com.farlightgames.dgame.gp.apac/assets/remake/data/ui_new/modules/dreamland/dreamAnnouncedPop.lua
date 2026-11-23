local base = ed.ui.popwindow
local dreamAnnouncedPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("dreamAnnouncedPop", function(param)
  ed.dreamland.network_mgr:RequestCalendar()
  ListenEventOnce("DreamAnnouncedCalendar", function(replyinfo)
    local param = {calendar_info = replyinfo}
    dreamAnnouncedPop.create(param or {}):popWindow()
  end)
end)

function dreamAnnouncedPop.create(param)
  local self = base.create("dreamAnnouncedPop")
  setmetatable(self, dreamAnnouncedPop.mt)
  self:init(param or {})
  return self
end

function dreamAnnouncedPop:init(param)
  self.bossIds = {}
  self.bossTimes = {}
  for i, k in ipairs(param.calendar_info._summary) do
    local stage = k._stage_id
    local tabBattle = ed.getDataTable("Battle")
    local tBattle = tabBattle[stage]
    for _, obj in pairs(tBattle or {}) do
      table.insert(self.bossIds, obj["Monster 1 ID"])
    end
    local time = k._start_time
    local year, month, day = ed.time2YMD(time)
    table.insert(self.bossTimes, T("%s %d\230\156\136%d\230\151\165", ed.getWeekdayCnName(time), month, day))
  end
  self:createUI()
  self:refreshUI()
  self:registerEvents()
  return self
end

function dreamAnnouncedPop:createUI()
  local container, ui = ed.editorui(ed.uieditor.dream_announced_pop)
  self.ui = ui
  self.container:addChild(container)
  local title_label = ed.ui.gradientLabel.create({
    text = T("\230\156\170\230\157\165\233\162\132\232\168\128") .. ed.getUTCLabel(),
    fontSize = 23,
    fontName = ed.font,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16773523),
    strokeSize = 1,
    strokeColor = ed.toccc3(990737)
  })
  self.ui.layer_title:addChild(title_label.node)
  for i, k in ipairs(self.bossTimes) do
    local label = ed.createLabelTTF(k, 16)
    ed.setLabelStroke(label, ed.toccc3(990737), 1)
    if i < 2 then
      ed.setLabelColor(label, ed.toccc3(7405396))
    else
      ed.setLabelColor(label, ed.toccc3(16771782))
    end
    self.ui["boss" .. i .. "_label"]:addChild(label)
    ed.layout.centerInParent(label)
  end
  self:show()
end

function dreamAnnouncedPop:refreshUI()
  self:asyncLoadHero()
end

function dreamAnnouncedPop:asyncLoadHero()
  for i, k in ipairs(self.bossIds) do
    ed.asyncload.preloadFcaByUnitID(k)
  end
  ed.asyncload.registLoadingListener(function()
    for i, k in ipairs(self.bossIds) do
      local puppet, cha = ed.readhero.getActor(k, "Idle", true, false)
      puppet:setScale(0.8)
      puppet:setPosition(ccp(0, 0))
      self.ui["boss" .. i .. "_fca_layer"]:addChild(puppet)
      self:addFca(puppet)
      puppet:update(0)
    end
  end)
end

function dreamAnnouncedPop:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      ed.asyncload.unregistLoadingListener()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    pressScale = 0.78,
    normalScale = 0.8,
    key = "btn_close",
    clickHandler = function()
      ed.asyncload.unregistLoadingListener()
      self:destroy()
    end
  })
end
