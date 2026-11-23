local server_ping = {}
ed.ui.server_ping = server_ping
local server_ping_Scope = {}

function server_ping:showPing(stats)
  if stats then
    if not self.pingLabel then
      local container = ed.getCurrentScene():getTopNode()
      local size = ed.display.winSize.height * 24 / 320
      local font = "Marker Felt"
      self.pingLabel = ed.createttf("000.00", size, font)
      container:addChild(self.pingLabel)
      local contentSize = self.pingLabel:getContentSize()
      self.pingLabel:setPosition(ccp(0, contentSize.height * 7 * 0.5))
      self.pingLabel:setAnchorPoint(ccp(0, 0.5))
    end
    CloseScope(server_ping_Scope)
    ListenTimer(Timer:Always(1), function(...)
      if self.pingLabel then
        self.lag = self.lag or 0
        self.pingLabel:setString(string.format("%.2f", self.lag))
      end
    end, server_ping_Scope)
  else
    if self.pingLabel then
      self.pingLabel:removeFromParentAndCleanup(true)
      self.pingLabel = nil
    end
    CloseScope(server_ping_Scope)
  end
end

function server_ping:SetLag(lag)
  self.lag = lag or self.lag
end

function server_ping:showBattleFPS(stats)
  if stats then
    if not self.fpsLabel then
      local container = ed.getCurrentScene():getTopNode()
      local size = ed.display.winSize.height * 24 / 320
      local font = "Marker Felt"
      self.fpsLabel = ed.createttf("000.0", size, font)
      self.fpsLabel:setColor(ccc3(0, 255, 0))
      container:addChild(self.fpsLabel)
      local contentSize = self.fpsLabel:getContentSize()
      self.fpsLabel:setPosition(ccp(0, contentSize.height * 9 * 0.5))
      self.fpsLabel:setAnchorPoint(ccp(0, 0.5))
    end
  elseif self.fpsLabel then
    self.fpsLabel:removeFromParentAndCleanup(true)
    self.fpsLabel = nil
  end
end

function server_ping:refreshBattleFPS(fps)
  if self.fpsLabel then
    self.fpsLabel:setString(string.format("%.1f", fps))
  end
end
