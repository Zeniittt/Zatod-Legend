local base = ed.ui.popwindow
local NetAlertDialog = {}
NetAlertDialog.__index = NetAlertDialog
setmetatable(NetAlertDialog, base.mt)
local lable_idx = 1
local labels = {
  T("\229\136\134\230\158\144\228\184\173."),
  T("\229\136\134\230\158\144\228\184\173.."),
  T("\229\136\134\230\158\144\228\184\173...")
}

function NetAlertDialog.create(param)
  local self = base.create("Dialog")
  setmetatable(self, NetAlertDialog)
  self:initUI()
  self:setStatus("before_nettest")
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

ed.showNetAlertDialog = NetAlertDialog.create

function NetAlertDialog:setStatus(status)
  self.status = status
  local ui = self.ui
  if self.status == "before_nettest" then
    ui.label_btn_ok:setString(T("\229\188\128\229\167\139\230\163\128\230\181\139"))
  elseif self.status == "nettest_ing" then
    ui.label_btn_ok:setString(T("\230\163\128\230\181\139\228\184\173"))
  elseif self.status == "finish_nettest" then
    ui.label_btn_ok:setString(T("\229\164\141\229\136\182\231\187\147\230\158\156"))
  end
end

function NetAlertDialog:initUI()
  local container, ui = ed.editorui(ed.uieditor.NetAlertDialog, {
    container = self.container,
    ui = self.ui
  })
  ed.layout.centerInScreen(self.ui.bg, true)
  ed.left2(self.ui.left_deco, self.ui.label_title, 5)
  ed.right2(self.ui.right_deco, self.ui.label_title, 5)
  self:refreshUI()
end

function NetAlertDialog:registerTouchHandlers()
  local ui = self.ui
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.8, normalScale = 0.9})
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.status == "before_nettest" then
      if ed.network_diagnosis:isSupportTag() then
        self:startNetTest_tag()
      else
        self:startNetTest()
      end
    elseif self.status == "nettest_ing" then
    elseif self.status == "finish_nettest" then
      ed.copyString(self.testResult or "")
      self:destroy({skipAnim = true})
    end
  end, {pressScale = 0.8, normalScale = 0.9})
  self:listenEvent("OnNetDiagnosis", function(type, result)
    self:onTestResult(type, result)
  end)
  self:listenEvent("OnNetDiagnosis_Tag", function(result)
    self:onTagTestResult(result)
  end)
end

function NetAlertDialog:refreshUI()
  local ui = self.ui
  for i = 1, 9 do
    ui["Label_" .. i]:setVisible(false)
  end
  self:setDeviceId(ed.network_diagnosis:getUtdid() or "")
  if ed.network_diagnosis:isSupportTag() then
    self.ui.Label_title_1:setString(T("DNS\232\167\163\230\158\144\230\181\139\232\175\149"))
    self.ui.Label_title_2:setString(T("HTTP\232\174\191\233\151\174\230\181\139\232\175\149"))
  end
end

function NetAlertDialog:startNetTest_tag()
  self:setStatus("nettest_ing")
  ed.network_diagnosis:tag()
  self:initLabels()
  self:listenTimer(Timer:Always(1), function()
    self:refreshNetTestStatus_Tag()
  end)
end

function NetAlertDialog:initLabels()
  lable_idx = 1
  self.dnsFinish = nil
  self.ui.Label_1:setVisible(true)
  self.ui.Label_1:setString(labels[lable_idx])
  self.httpFinish = nil
  self.ui.Label_3:setVisible(true)
  self.ui.Label_3:setString(labels[lable_idx])
  self.tcppingFinish = nil
  self.ui.Label_5:setVisible(true)
  self.ui.Label_5:setString(labels[lable_idx])
  self.mtrFinish = nil
  self.ui.Label_7:setVisible(true)
  self.ui.Label_7:setString(labels[lable_idx])
end

function NetAlertDialog:refreshNetTestStatus_Tag()
  if not self.dnsFinish then
    self.ui.Label_1:setString(labels[lable_idx])
  end
  if not self.httpFinish then
    self.ui.Label_3:setString(labels[lable_idx])
  end
  if not self.tcppingFinish then
    self.ui.Label_5:setString(labels[lable_idx])
  end
  if not self.mtrFinish then
    self.ui.Label_7:setString(labels[lable_idx])
  end
  lable_idx = lable_idx + 1
  if 3 < lable_idx then
    lable_idx = 1
  end
end

function NetAlertDialog:onTagTestResult(data)
  if not data.method then
    return
  end
  if self.status ~= "nettest_ing" then
    return
  end
  
  local function setResult(title, content)
    if data then
      self:setDeviceId(data.deviceId)
      content:setVisible(true)
      data.trace_id = data.trace_id or ""
      content:setString("TraceId:" .. (data.trace_id or ""))
      data.errCode = data.errCode or ""
      if data.errCode == "" then
        title:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\230\173\163\229\184\184"))
      else
        title:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\233\148\153\232\175\175") .. data.errCode)
        ed.setLabelColor(title, ccc3(205, 51, 51))
      end
    else
      title:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144"))
    end
  end
  
  if data.method == "dns" then
    self.dnsFinish = true
    setResult(self.ui.Label_1, self.ui.Label_2)
  elseif data.method == "http" then
    self.httpFinish = true
    setResult(self.ui.Label_3, self.ui.Label_4)
  elseif data.method == "tcpping" then
    self.tcppingFinish = true
    setResult(self.ui.Label_5, self.ui.Label_6)
  elseif data.method == "mtr" then
    self.mtrFinish = true
    setResult(self.ui.Label_7, self.ui.Label_8)
  end
  if self.dnsFinish and self.httpFinish and self.tcppingFinish and self.mtrFinish then
    self:setStatus("finish_nettest")
  end
  if data then
    self:addToResult("TraceId:" .. data.trace_id)
    self:addToResult("method:" .. data.method)
    self:addToResult("errCode:" .. data.errCode)
    self:addToResult("errMsg:" .. (data.errMsg or ""))
  end
end

function NetAlertDialog:startNetTest()
  self:setStatus("nettest_ing")
  self.curTest = "http"
  self.goNextNetTest = true
  self:listenTimer(Timer:Always(1), function()
    self:refreshNetTestStatus()
  end)
end

function NetAlertDialog:refreshNetTestStatus()
  if self.goNextNetTest then
    self.goNextNetTest = nil
    self:goNetTest()
  end
  self.testTimer = self.testTimer + 1
  if self.curTest == "http" then
    self.ui.Label_1:setString(labels[lable_idx])
  elseif self.curTest == "cdn" then
    self.ui.Label_3:setString(labels[lable_idx])
  elseif self.curTest == "tcpping" then
    self.ui.Label_5:setString(labels[lable_idx])
  elseif self.curTest == "mtr" then
    self.ui.Label_7:setString(labels[lable_idx])
  end
  lable_idx = lable_idx + 1
  if 3 < lable_idx then
    lable_idx = 1
  end
end

function NetAlertDialog:goNetTest()
  self.testTimer = 0
  if self.curTest == "http" then
    self.ui.Label_1:setVisible(true)
    self.ui.Label_1:setString(T("\229\136\134\230\158\144\228\184\173"))
    local url = dir_servers[1] .. "dir.txt"
    EDLog(url)
    ed.network_diagnosis:http(url)
  elseif self.curTest == "cdn" then
    self.ui.Label_3:setVisible(true)
    self.ui.Label_3:setString(T("\229\136\134\230\158\144\228\184\173"))
    local cdn = LoadResources:getValidCdn()
    local backdoor = cdn .. "backdoor.txt"
    EDLog(backdoor)
    ed.network_diagnosis:http(backdoor)
  elseif self.curTest == "tcpping" then
    self.ui.Label_5:setVisible(true)
    self.ui.Label_5:setString(T("\229\136\134\230\158\144\228\184\173"))
    if game_server_ip == nil then
      self.ui.Label_5:setString(T("\233\148\153\232\175\175"))
      self:setStatus("finish_nettest")
      return
    end
    EDLog(game_server_ip)
    ed.network_diagnosis:tcpPing(game_server_ip, game_server_port)
  elseif self.curTest == "mtr" then
    self.ui.Label_7:setVisible(true)
    self.ui.Label_7:setString(T("\229\136\134\230\158\144\228\184\173"))
    if game_server_ip == nil then
      self.ui.Label_7:setString(T("\233\148\153\232\175\175"))
      self:setStatus("finish_nettest")
      return
    end
    ed.network_diagnosis:mtr(game_server_ip)
  end
end

function NetAlertDialog:setDeviceId(deviceId)
  if deviceId == nil then
    return
  end
  self.ui.Label_9:setVisible(true)
  self.ui.Label_9:setString(deviceId)
  self:addToResult("deviceId:" .. deviceId)
end

function NetAlertDialog:addToResult(str)
  self.testResult = self.testResult or ""
  str = str or ""
  self.testResult = self.testResult .. str .. "\n"
end

function NetAlertDialog:onTestResult(data)
  EDLog(self.curTest)
  self:addToResult(self.curTest)
  if self.curTest == "http" then
    if data then
      self:setDeviceId(data.deviceId)
      self.ui.Label_2:setVisible(true)
      data.trace_id = data.trace_id or ""
      self.ui.Label_2:setString("TraceId:" .. (data.trace_id or ""))
      data.errCode = data.errCode or ""
      if data.errCode == "" then
        self.ui.Label_1:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\230\173\163\229\184\184"))
      else
        self.ui.Label_1:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\233\148\153\232\175\175") .. data.errCode)
        ed.setLabelColor(self.ui.Label_1, ccc3(205, 51, 51))
      end
    else
      self.ui.Label_1:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144"))
    end
    self.curTest = "cdn"
    self.goNextNetTest = true
  elseif self.curTest == "cdn" then
    if data then
      self:setDeviceId(data.deviceId)
      self.ui.Label_4:setVisible(true)
      data.trace_id = data.trace_id or ""
      self.ui.Label_4:setString("TraceId:" .. (data.trace_id or ""))
      data.errCode = data.errCode or ""
      if data.errCode == "" then
        self.ui.Label_3:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\230\173\163\229\184\184"))
      else
        self.ui.Label_3:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\233\148\153\232\175\175") .. data.errCode)
        ed.setLabelColor(self.ui.Label_3, ccc3(205, 51, 51))
      end
    else
      self.ui.Label_3:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144"))
    end
    self.curTest = "tcpping"
    self.goNextNetTest = true
  elseif self.curTest == "tcpping" then
    if data then
      self:setDeviceId(data.deviceId)
      self.ui.Label_6:setVisible(true)
      data.trace_id = data.trace_id or ""
      self.ui.Label_6:setString("TraceId:" .. (data.trace_id or ""))
      data.errCode = data.errCode or ""
      if data.errCode == "" then
        self.ui.Label_5:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\230\173\163\229\184\184"))
      else
        self.ui.Label_5:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\233\148\153\232\175\175") .. data.errCode)
        ed.setLabelColor(self.ui.Label_5, ccc3(205, 51, 51))
      end
    else
      self.ui.Label_5:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144"))
    end
    self.curTest = "mtr"
    self.goNextNetTest = true
  elseif self.curTest == "mtr" then
    if data then
      self:setDeviceId(data.deviceId)
      self.ui.Label_8:setVisible(true)
      data.trace_id = data.trace_id or ""
      self.ui.Label_8:setString("TraceId:" .. (data.trace_id or ""))
      data.errCode = data.errCode or ""
      if data.errCode == "" then
        self.ui.Label_7:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\230\173\163\229\184\184"))
      else
        self.ui.Label_7:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144:\233\148\153\232\175\175") .. data.errCode)
        ed.setLabelColor(self.ui.Label_7, ccc3(205, 51, 51))
      end
    else
      self.ui.Label_7:setString(T("\229\136\134\230\158\144\229\174\140\230\136\144"))
    end
    self.curTest = nil
    self:setStatus("finish_nettest")
  end
  if data then
    self:addToResult("TraceId:" .. data.trace_id)
    self:addToResult("errCode:" .. data.errCode)
    self:addToResult("errMsg:" .. (data.errMsg or ""))
  end
end
