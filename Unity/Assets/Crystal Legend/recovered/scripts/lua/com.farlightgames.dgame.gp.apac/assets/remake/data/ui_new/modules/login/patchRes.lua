local base = ed.ui.basescene
local patchRes = newclass(base.mt)
ed.ui.patchRes = patchRes

local function needPatchRes()
  if need_patch_res then
    local patchResName = ed.storage.getString("patch_res_version") or ""
    EDLog("patch_res_version:" .. patchResName)
    if patchResName == ed.getCurPatchResName() then
      return false
    end
    return true
  end
  return false
end

ed.needPatchRes = needPatchRes

function ed.getMultLanRootPath()
  local lanRootPath = EDFilePath:getInstance():getMultLanRootPath()
  lanRootPath = lanRootPath:gsub("/patch/$", "/")
  return lanRootPath
end

function ed.getCurPatchResName()
  local version = EDGetVersionName() or "0"
  local zipName = "aab_" .. version .. ".zip"
  return zipName
end

function patchRes:createSessionId(sessionId)
  ed.createNode({
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 10,
      text = sessionId,
      name = "sId",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120, 29)
    }
  }, self.mainLayer)
end

function patchRes:createVersion()
  local version = EDGetVersionName() or "0"
  ed.createNode({
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 10,
      text = "version:" .. version,
      name = "ver",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(763, 29)
    }
  }, self.mainLayer)
end

local function create(sessionId)
  ed.reportHUE({
    action_type = "create_patchRes_scene"
  })
  local self = base.create("patchRes")
  setmetatable(self, patchRes.mt)
  self.sessionId = sessionId
  local scene = self.scene
  local mainLayer = self.mainLayer
  if resource_config.splash_fca then
    local effect_fca = ed.createFcaActor(resource_config.splash_fca)
    effect_fca:setLoop(true)
    effect_fca:setPosition(ccp(400, 240))
    effect_fca:setAction("Loop")
    mainLayer:addChild(effect_fca)
    self:addFca(effect_fca)
    effect_fca:setVisible(true)
  else
    self:setBackground(ed.getSplash())
  end
  self:createSessionId(sessionId or "sid")
  self:createVersion()
  self:createBar()
  self:createExplanation()
  self:refreshExplanation(T("\230\173\163\229\156\168\232\191\158\230\142\165\230\156\141\229\138\161\229\153\168\239\188\140\232\175\183\231\168\141\229\128\153\226\128\166\226\128\166"))
  self:registerOnEnterHandler("onPatchEnterScene", function()
    self:onPatchEnterScene()
  end)
  self:registerOnExitHandler("onPatchExitScene", function()
    self:onPatchExitScene()
  end)
  return self
end

patchRes.create = create

function patchRes:onPatchEnterScene()
  print("onPatchEnterScene")
  ed.reportHUE({
    action_type = "enter_patchRes_scene"
  })
  local titleStr = T("\229\136\157\230\172\161\232\191\155\229\133\165\230\184\184\230\136\143\239\188\140\233\156\128\232\166\129\228\184\139\232\189\189\229\191\133\232\166\129\232\181\132\230\186\144\229\140\133%s\239\188\140\232\175\183\231\161\174\232\174\164\227\128\130")
  local patchResName = ed.storage.getString("patch_res_version") or ""
  if string.len(patchResName) > 0 then
    titleStr = T("\230\163\128\230\181\139\229\136\176\230\184\184\230\136\143\229\140\133\228\189\147\229\143\145\231\148\159\229\143\152\229\140\150\239\188\140\233\156\128\233\135\141\230\150\176\228\184\139\232\189\189\229\175\185\229\186\148\232\181\132\230\186\144\229\140\133%s\239\188\140\232\175\183\231\161\174\232\174\164\227\128\130")
  end
  ed.showConfirmDialog({
    text = string.format(titleStr, patch_res_size or ""),
    leftHandler = function()
      if EDFLAGWIN32 then
        os.exit(0)
      else
        EDExit()
      end
    end,
    rightHandler = function()
      self:downloadPatchRes()
    end
  })
end

function patchRes:onPatchExitScene()
  print("onPatchExitScene")
  local downloader = EDDownloader:getInstance()
  downloader:unregisterScriptHandler()
end

function patchRes:retryPatchRes(str)
  ed.showConfirmDialog({
    text = str,
    leftHandler = function()
      if EDFLAGWIN32 then
        os.exit(0)
      else
        EDExit()
      end
    end,
    rightHandler = function()
      EnqueueDelayProcess(function()
        self:downloadPatchRes()
      end)
    end
  })
end

function patchRes:patchResSuccess(zipFilePath)
  ed.reportHUE({
    action_type = "patchRes_success"
  })
  EDLog("patchResSuccess")
  EnqueueDelayProcess(function()
    os.remove(zipFilePath)
    ed.storage.setValue("patch_res_version", ed.getCurPatchResName())
    ed.replaceScene(ed.ui.logo.create(self.sessionId))
  end)
end

function patchRes:downloadPatchRes()
  ed.reportHUE({
    action_type = "download_patchRes_zip"
  })
  print("downloadPatchRes")
  self:refreshBar(0)
  self:refreshExplanation(T("\230\173\163\229\156\168\232\191\158\230\142\165\230\156\141\229\138\161\229\153\168\239\188\140\232\175\183\231\168\141\229\128\153\226\128\166\226\128\166"))
  local cdnUrl = LoadResources:getValidCdn()
  EDLog(cdnUrl)
  local url
  local zipName = ed.getCurPatchResName()
  if string.sub(cdnUrl, -1) == "/" then
    url = cdnUrl .. "mult/" .. zipName
  else
    url = cdnUrl .. "/mult/" .. zipName
  end
  local zipFilePath = ed.getMultLanRootPath() .. zipName
  os.remove(zipFilePath)
  EDLog(zipFilePath)
  EDLog(url)
  local downloader = EDDownloader:getInstance()
  downloader:registerScriptHandler(function(pEventName, customId, url, str, num)
    print(pEventName, customId, url, str, num)
    if pEventName == "onProgress" then
      local des = T("\230\155\180\230\150\176\228\184\173...") .. str
      self:refreshBar(num * 0.01)
      self:refreshExplanation(des or T("\230\155\180\230\150\176\228\184\173..."))
    elseif pEventName == "onSuccess" then
      self:refreshBar(1)
      self:refreshExplanation(T("\230\155\180\230\150\176\229\174\140\230\136\144"))
      self:unzipPatchRes(zipFilePath)
    elseif pEventName == "onError" then
      self:retryPatchRes(T("\230\155\180\230\150\176\229\164\177\232\180\165\239\188\140\232\175\183\230\163\128\230\159\165\231\189\145\231\187\156\231\142\175\229\162\131"))
    elseif pEventName == "onUncompressing" then
      self:refreshBar(num * 0.01)
    elseif pEventName == "onUncompressSuc" then
      EDLog("onUncompressSuc")
      self:refreshBar(1)
      self:patchResSuccess(zipFilePath)
    elseif pEventName == "onUncompressErr" then
      EDLog("onUncompressErr")
      self:retryPatchRes(T("\232\167\163\229\142\139\232\181\132\230\186\144\229\140\133\229\164\177\232\180\165\239\188\140\232\175\183\233\135\141\232\175\149"))
    end
  end)
  local customId = "download-01"
  if EDFLAGWIN32 then
    url = "http://dgame-remake-prod-cn-cdn-02.lilithgame.com/1.0/official.iPhone/patches/dtcq_iphone_v1.0.038.250573-v1.0.040.252932.zip"
  end
  downloader:DownloadFile(url, zipFilePath, customId)
end

function patchRes:unzipPatchRes(zipFilePath)
  ed.reportHUE({
    action_type = "unzip_patchRes_zip"
  })
  print("unzipPatchRes")
  self:refreshBar(0)
  self:refreshExplanation(T("\232\167\163\229\142\139\232\181\132\230\186\144\229\140\133\239\188\140\232\175\183\231\168\141\229\128\153\226\128\166\226\128\166"))
  local downloader = EDDownloader:getInstance()
  downloader:uncompress(zipFilePath)
end

function patchRes:createBar()
  self.barBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/progress_bar_2.png"
    },
    layout = {
      position = ccp(ed.display.center.x - ed.display.halfFixedWidth, 60)
    }
  }, self.mainLayer)
  self.bar = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/progress_bar_1.png"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  }, self.barBg)
  self.bar:setTextureRect(CCRectMake(0, 0, 0, 25))
  self.lightLayer = CCLayer:create()
  self.lightLayer:setClipRect(CCRectMake(-15, -240, 810, 480))
  self.barBg:addChild(self.lightLayer)
  self.barLight = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_bar_light.png"
    },
    layout = {
      anchor = ccp(0.9, 0)
    }
  }, self.lightLayer)
  self.barFca = ed.createFcaNode("eff_UI_loading_dragon")
  self.barFca:setPosition(69, 14)
  self:addFca(self.barFca)
  self.barLight:addChild(self.barFca, 1)
  self.labelPercent = ed.createLabelTTF("0%", 19)
  ed.setLabelStroke(self.labelPercent, ed.toccc3(1966594), 1.5)
  self.labelPercent:setPosition(ccp(780, 10))
  self.bar:addChild(self.labelPercent)
end

function patchRes:refreshBar(percent)
  percent = math.min(percent, 1)
  local width, height = 763 * percent, 17
  ed.setString(self.labelPercent, string.format("%d%%", percent * 100))
  self.bar:setTextureRect(CCRectMake(0, 0, width, height))
  self.barLight:setPosition(ccp(math.min(width, 749.266), 0))
end

function patchRes:rotateFlower()
  local gap = 0.1
  local count = 0
  
  local function handler(dt)
    count = count + dt
    if count > gap then
      count = count - gap
      self.loadIcon:setRotation((self.loadIcon:getRotation() + 30) % 360)
    end
  end
  
  return handler
end

function patchRes:refreshDescri()
  local x = ed.display.center.x - self.descri:getContentSize().width / 2 - 20
  self.loadIcon:setPosition(ccp(x, 105))
  local width = self.descri:getContentSize().width + self.loadIcon:getContentSize().width
  self.labelBg:setScaleY(0.5)
  self.labelBg:setScaleX(width * 1.5 / self.labelBg:getContentSize().width)
end

function patchRes:refreshExplanation(text)
  ed.setString(self.descri, text)
  self:refreshDescri()
end

function patchRes:createExplanation()
  self.descriContainer = ed.createNode({
    t = "Sprite",
    layout = {
      position = ccp(-ed.display.halfFixedWidth, -70)
    }
  }, self.mainLayer)
  self.labelBg = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_label_bg.png"
    },
    layout = {
      position = ccp(ed.display.center.x, 105)
    },
    config = {visible = false}
  }, self.descriContainer)
  self.descri = ed.createNode({
    t = "Label",
    base = {
      text = T("\230\155\180\230\150\176\228\184\173..."),
      size = 20
    },
    layout = {
      position = ccp(ed.display.center.x, 105)
    }
  }, self.descriContainer)
  self.loadIcon = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/load_flower.png"
    }
  }, self.descriContainer)
  ed.setLabelStroke(self.descri, ed.toccc3(1513239), 1)
  self:refreshDescri()
  self:registerUpdateHandler("flower_rotate", self:rotateFlower())
end
