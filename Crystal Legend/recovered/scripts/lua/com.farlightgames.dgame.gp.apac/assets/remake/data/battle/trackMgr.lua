local trackMgr = {}
trackMgr.uFrames = 0
trackMgr.fAccumDt = 0
trackMgr.curTime = 0
trackMgr.framTable = {}
trackMgr.framIndex = 0
trackMgr.isShieldEffect = false
trackMgr.isShieldProjectile = false
trackMgr.isShieldFullEffect = false
trackMgr.isShieldPartText = false
trackMgr.isShieldFullText = false
trackMgr.isTip = false
local quality = {
  high = 1,
  mid = 2,
  low = 3
}
trackMgr.maxFrame = 35
trackMgr.checkTime = 10
trackMgr.FPS = 15

function trackMgr:initData()
  self.curTime = ed.getServerTime()
  self.uFrames = 0
  self.fAccumDt = 0
  self.framIndex = 0
  self.curQuality = quality.high
  for i = 1, trackMgr.maxFrame do
    self.framTable[i] = 0
  end
  self.isShieldEffect = false
  self.isShieldProjectile = false
  self.isShieldFullEffect = false
  self.isShieldPartText = false
  self.isShieldFullText = false
  self.isTip = false
end

function trackMgr:checkFrame(updateTime)
  self.uFrames = 1
  self.fAccumDt = updateTime
  local fFrameRate = self.uFrames / self.fAccumDt
  self.framIndex = self.framIndex + 1
  if self.framIndex > trackMgr.maxFrame then
    self.framIndex = 1
  end
  self.framTable[self.framIndex] = fFrameRate
  if ed.getServerTime() - self.curTime >= trackMgr.checkTime then
    local fps = self:getAverageFPS()
    self.curTime = ed.getServerTime()
    if fps < trackMgr.FPS and ed.engine.nightmareMode then
      self:ShieldLogin()
    end
  end
end

function trackMgr:getAverageFPS()
  local fps = 0
  for i = 1, trackMgr.maxFrame do
    fps = fps + self.framTable[i]
  end
  fps = fps / trackMgr.maxFrame
  return fps
end

function trackMgr:ShieldLogin()
  if not self.isTip then
    self.isTip = true
    ed.showToast(T("\230\184\184\230\136\143\230\175\148\232\190\131\229\141\161,\232\135\170\229\138\168\229\188\128\229\144\175\229\177\143\232\148\189\233\131\168\229\136\134\231\137\185\230\149\136,\230\143\144\229\141\135\230\136\152\230\150\151\230\181\129\231\149\133"))
  end
  if self.curQuality == quality.high then
    self.curQuality = quality.mid
    self:mediumEffect()
  elseif self.curQuality == quality.mid then
    self.curQuality = quality.low
    self:lowEffect()
  elseif self.curQuality == quality.low then
    return
  end
end

ed.trackMgr = trackMgr

function trackMgr:mediumEffect()
  self.isShieldEffect = true
  self.isShieldPartText = true
  ed.restPopup()
end

function trackMgr:lowEffect()
  self.isShieldFullText = true
end
