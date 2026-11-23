local base = ed.ui.basescene
local logo = newclass(base.mt)
ed.ui.logo = logo
local auto_update_switch = not EDFLAGWIN32

local function setNetStatus(self, state, status)
  state = state or "null"
  status = status or 0
  self.netStatus:setString(state .. "-" .. status)
end

logo.setNetStatus = setNetStatus

local function loadShaders(self)
  local list = {
    "GrayScalingShader",
    "FrozenShader",
    "StoneShader",
    "PoisonShader",
    "BanishShader",
    "InvisibleShader",
    "Blur",
    "ScreenBlur",
    "IceShader",
    "MirrorShader",
    "VanishShader",
    "FireShader",
    "RubickShader",
    "MorSwitchShader_R",
    "MorSwitchShader_G",
    "MorNewSwitchShader_R",
    "MorNewSwitchShader_G",
    "MorFashionShader_R",
    "MorShader_E",
    "MorShader_G",
    "MorShader_R",
    "HSVtoRGBShader",
    "HueShader",
    "NanaShader",
    "DarkenShader",
    "ParasitismShader",
    "SandShader",
    "DissolveShader",
    "DissolveShader1",
    "DinaShader",
    "BKBShader",
    "HalfInvisibleShader",
    "SeasonTowerShader",
    "PuckShader",
    "KaelShader",
    "ShadowShader",
    "FcaHSVtoRGBShader",
    "FcaHSVBlue",
    "FcaHSVGreen",
    "FcaHSVOrange",
    "FcaHSVPink",
    "FcaHSVPurple",
    "ClipSpriteCircle",
    "HSVtoRGBShaderV2",
    "PetShader_1",
    "PetShader_2",
    "PetShader_3",
    "PetShader_4",
    "PetShader_5",
    "PetShader_6",
    "PetShader_7",
    "HorizontalBlur"
  }
  ed.reportHUE({
    action_type = "load_shaders"
  })
  for i, v in ipairs(list) do
    EDLoadShader(v)
  end
  ed.reportHUE({
    action_type = "load_shaders_finish"
  })
end

logo.loadShaders = loadShaders

local function loadTable(self)
  local list = {
    "Unit",
    "Skill",
    "Stage",
    "Battle",
    "hero_equip",
    "equip",
    "SkillGroup",
    "UnitRank"
  }
  for i, v in ipairs(list) do
    ed.getDataTable(v)
  end
end

logo.loadTable = loadTable

local function doLogin(self)
  local loginLanguage = {
    cn = "cn",
    tw = "tw",
    ja = "jp",
    ko = "kr",
    en = "us",
    es = "es"
  }
  self:setNetStatus("doLogin", 0)
  ed.reportHUE({action_type = "gs_login"})
  
  function ed.netreply.loginReply()
    self:setNetStatus("loginReply", 0)
    ed.reportHUE({
      action_type = "gs_login_success"
    })
    self:createLoading()
  end
  
  EDLog(ed.ui.serverlogin.getOldDeviceId())
  EDLog(tostring(loginLanguage[EDCurLanguage]))
  local login = ed.upmsg.login()
  login._active_code = 0
  login._old_deviceid = ed.ui.serverlogin.getOldDeviceId()
  local open_idfa = accSystem.BindAccountMgr.getInstance():getOpenIDFA()
  login._idfa = open_idfa
  login._android_id = ""
  login._google_aid = ""
  login._version = ed.ui.serverlogin.getClientVersion()
  login._os = EDGetParam("deviceOS") or ""
  login._os_version = EDGetParam("deviceVersionRelease") or ""
  login._device = EDGetParam("deviceModel") or ""
  login._lang = ed.deviceLanguage()
  if EDFLAGANDROID and EDGetCpuAtchitectureString then
    login._cpu = EDGetCpuAtchitectureString() or ""
  end
  if EDFLAGANDROID and EDGetDeviceUID then
    login._google_aid = EDGetParam("googleAdId")
    login._android_id = EDGetParam("androidId")
  end
  login._region = loginLanguage[EDCurLanguage]
  login._is_adult = ed.getIsAdult() and 1 or 0
  login._sdk_version = EDGetParam("sdkversion") or ""
  login._ip = EDGetParam("getSDKIp") or ""
  login._ip_region = EDGetParam("getIpRegion") or ""
  local platform_channel = EDGetParam("platformChannel") or ""
  login._sdk_plat_id = EDSDKType or 0
  if platform_channel == "douyin" then
    login._sdk_plat_id = 303
  end
  ed.send(login, "login")
  self:setNetStatus("doLogin", 1)
end

logo.doLogin = doLogin

local function createUpdating(self, step)
  local key
  self:setNetStatus("createUpdating", step)
  if step == 1 or step == 101 then
    key = nil
  elseif step == 2 or step == 102 then
    self:createConnecting()
    return
  elseif step == 3 then
    self:createConnecting()
    return
  end
  
  local function handler()
    self:setNetStatus("cU-handler", step)
    LoadResources:initAutoUpdateParam()
    self:setNetStatus("cU-StartUpdate", step)
    self:doUpdating(step)
  end
  
  LoadResources:initAutoUpdateParam()
  if EDFLAGANDROID then
    LoadResources:checkUpdate()
  end
  handler()
end

logo.createUpdating = createUpdating

local function doUpdating(self, step)
  self:setNetStatus("StartUpdate", step)
  self.barBg:setVisible(true)
  if step == 0 then
    self:setNetStatus("LR-startBin", 0)
    EDGetExternalStoragePath()
    LoadResources:updateBinary(binaryVersionInfo.apk_addr_list[EDSDKType])
    self.announcements = binaryVersionInfo.announcement
    self:ShowAnnouncements()
  elseif step == 101 then
    self:setNetStatus("LR-startUpdate", step)
    ed.reportHUE({
      action_type = "get_packs_size"
    })
    LoadResources:updatePacksSize()
  else
    self:setNetStatus("LR-startUpdate", step)
    ed.reportHUE({
      action_type = "download_packs"
    })
    LoadResources:update()
  end
  self:registerUpdateHandler("logo", self:updateLogo(step))
end

logo.doUpdating = doUpdating

local function createConnecting(self)
  self:setNetStatus("connecting", 0)
  self:refreshExplanation(T("\230\173\163\229\156\168\232\191\158\230\142\165\230\156\141\229\138\161\229\153\168\239\188\140\232\175\183\231\168\141\229\128\153\226\128\166\226\128\166"))
  self:doLogin()
end

logo.createConnecting = createConnecting

function logo:loadAllFiles()
  ed.reportHUE({
    action_type = "load_scripts"
  })
  for i, v in ipairs(ed.needLoadFiles) do
    require(v)
  end
  ed.reportHUE({
    action_type = "load_scripts_finish"
  })
end

local function createLoading(self)
  self:setNetStatus("loginReply", 1)
  self:refreshExplanation(T("\229\138\160\232\189\189\232\181\132\230\186\144\228\184\173\239\188\140\232\175\183\231\168\141\229\128\153\226\128\166\226\128\166"))
  self.mainLayer:runAction(ed.readaction.create({
    t = "seq",
    CCDelayTime:create(0),
    CCCallFunc:create(function()
      xpcall(function()
        self:loadShaders()
        self:loadAllFiles()
        if ed.fatal_error then
          return
        end
        if not ed.guide.data:isCompleted(6) and not ed.checkStoryEnded("OpeningMain") and ed.player:getLevel() < 2 then
          ed.reportHUE({
            action_type = "start_guide_battle"
          })
          ed.start5v5()
        else
          ed.replaceScene(ed.ui.mainScene.create())
        end
      end, EDDebug)
    end)
  }))
end

logo.createLoading = createLoading

local function createBar(self)
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

logo.createBar = createBar

local function refreshBar(self, percent)
  percent = math.min(percent, 1)
  local width, height = 763 * percent, 17
  ed.setString(self.labelPercent, string.format("%d%%", percent * 100))
  self.bar:setTextureRect(CCRectMake(0, 0, width, height))
  self.barLight:setPosition(ccp(math.min(width, 749.266), 0))
end

logo.refreshBar = refreshBar

local function reportWhenDownloading(self, percent)
  if not self.hasReportHalf and 0.35 < percent and percent < 0.65 then
    ed.reportHUE({
      action_type = "download_packs_half",
      percent = string.format("%d%%", percent * 100)
    })
    self.hasReportHalf = true
  end
end

logo.reportWhenDownloading = reportWhenDownloading

local function rotateFlower(self)
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

logo.rotateFlower = rotateFlower

local function createExplanation(self)
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

logo.createExplanation = createExplanation

local function createNetStatus(self)
  self.netStatus = ed.createNode({
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
      text = T("net status"),
      name = "netStatus",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120, 29)
    }
  }, self.mainLayer)
end

logo.createNetStatus = createNetStatus

local function refreshDescri(self)
  local x = ed.display.center.x - self.descri:getContentSize().width / 2 - 20
  self.loadIcon:setPosition(ccp(x, 105))
  local width = self.descri:getContentSize().width + self.loadIcon:getContentSize().width
  self.labelBg:setScaleY(0.5)
  self.labelBg:setScaleX(width * 1.5 / self.labelBg:getContentSize().width)
end

logo.refreshDescri = refreshDescri

local function refreshExplanation(self, text)
  ed.setString(self.descri, text)
  self:refreshDescri()
end

logo.refreshExplanation = refreshExplanation

local function create(sessionId, updateBinary)
  ed.reportHUE({
    action_type = "create_loading_scene"
  })
  local self = base.create("logo")
  setmetatable(self, logo.mt)
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
  self:createBar()
  self:createExplanation()
  self:createNetStatus()
  self.barBg:setVisible(false)
  if auto_update_switch then
    if ed.isOpenDownloadTips() then
      self:createUpdating(101)
    else
      self:createUpdating(1)
    end
  else
    self:createConnecting()
  end
  if ed.isMultiLanguage() then
    ed.RechargeManager:querySkuItemDetails()
  end
  return self
end

logo.create = create

local function checkLatestVersion(self)
  local latestVersion, currentVersion
  LoadResources:initAutoUpdateParam()
  LoadResources:checkUpdate()
  latestVersion = ed.storage.getString("latest-version")
  currentVersion = ed.storage.getString("current-version")
  logcut("CheckLatestVersion : ", "latestVersion : " .. (latestVersion or "Unknown"), "currentVersion : " .. (currentVersion or "Unknown"))
  if latestVersion ~= currentVersion then
    ed.fatal_error = true
    local text = T("\232\135\170\229\138\168\230\155\180\230\150\176\229\164\177\232\180\165\239\188\140\232\175\183\233\135\141\230\150\176\229\144\175\229\138\168\230\184\184\230\136\143\227\128\130\n\233\148\153\232\175\175\230\182\136\230\129\175:")
    if EDGetErrorMsg then
      text = T("%s", EDGetErrorMsg())
    end
    ed.showAlertDialog({
      text = text,
      fixedText = true,
      buttonText = T("\233\128\128\229\135\186"),
      handler = function()
        os.exit()
      end
    })
    return false
  end
  return true
end

logo.checkLatestVersion = checkLatestVersion

local function getBinaryVersionNumber(self, versionNumber)
  local ret = 0
  local a, b = string.match(versionNumber, "(%d+)%.(%d+)")
  ret = tonumber(a .. b)
  return ret
end

logo.getBinaryVersionNumber = getBinaryVersionNumber

local function ShowAnnouncements(self)
  if self.announcements == nil then
    return
  end
  local container = CCSprite:create()
  local board = {}
  local updateUI_info = {
    {
      t = "Sprite",
      base = {
        name = "lt",
        res = "UI/alpha/HVGA/update_bg.png"
      },
      layout = {
        anchor = ccp(1, 0),
        position = ccp(0, 0)
      },
      config = {
        scalexy = {x = 1, y = 1}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ld",
        res = "UI/alpha/HVGA/update_bg.png"
      },
      layout = {
        anchor = ccp(1, 1),
        position = ccp(0, -109.5)
      },
      config = {
        scalexy = {x = 1, y = -1}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "rt",
        res = "UI/alpha/HVGA/update_bg.png"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(359, 0)
      },
      config = {
        scalexy = {x = -1, y = 1}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "rd",
        res = "UI/alpha/HVGA/update_bg.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(359, -109.5)
      },
      config = {
        scalexy = {x = -1, y = -1}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title",
        res = "UI/alpha/HVGA/update_title.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 80)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "announce",
        text = T(""),
        size = 18
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(-300, 60)
      },
      config = {
        horizontalAlignment = kCCTextAlignmentLeft,
        dimension = CCSizeMake(600, 150),
        color = ccc3(255, 255, 255)
      }
    }
  }
  local readNode = ed.readnode.create(container, board)
  readNode:addNode(updateUI_info)
  container:setPosition(ccp(400, 240))
  self.announcementbg = container
  self.announceIndex = 1
  ed.setString(board.announce, self.announcements[self.announceIndex])
  ListenTimer(Timer:Always(10), function()
    if self.announceIndex then
      if self.announceIndex < #self.announcements then
        self.announceIndex = self.announceIndex + 1
      else
        self.announceIndex = 1
      end
      local fade = CCFadeOut:create(0.3)
      local func = CCCallFunc:create(function()
        ed.setString(board.announce, self.announcements[self.announceIndex])
        local fadein = CCFadeIn:create(0.3)
        board.announce:runAction(fadein)
      end)
      local s = CCSequence:createWithTwoActions(fade, func)
      board.announce:runAction(s)
    end
  end)
  self.mainLayer:addChild(container, 22)
end

logo.ShowAnnouncements = ShowAnnouncements

local function updateLogo(self, index)
  local count = 0
  local hasShowFailed, eof, hasShowConfirm
  
  local function handler(dt)
    count = count + dt
    if not auto_update_switch then
      return
    end
    local progress = LoadResources:getProgress()
    if not eof then
      local code = LoadResources:getCode()
      if code == 4 and not hasShowFailed then
        self:setNetStatus("LR-update-latestVersion.txt", 4)
        ed.reportHUE({
          action_type = "download_packs_failed"
        })
        self:refreshExplanation(T("\232\191\158\230\142\165\230\156\141\229\138\161\229\153\168\229\164\177\232\180\165\226\128\166\226\128\166"))
        ed.showAlertDialog({
          text = T("\232\191\158\230\142\165\230\155\180\230\150\176\230\156\141\229\138\161\229\153\168\229\164\177\232\180\165\227\128\130\n\230\152\175\229\144\166\233\135\141\232\175\149\239\188\159"),
          handler = function()
            xpcall(function()
              hasShowFailed = nil
              LoadResources:initAutoUpdateParam()
              self:doUpdating(index)
            end, EDDebug)
          end,
          buttonText = T("\231\161\174\229\174\154")
        })
        hasShowFailed = true
      elseif code == 3 then
        self:setNetStatus("LR-update", 3)
        ed.reportHUE({
          action_type = "download_packs_latest"
        })
        self:refreshExplanation(T("\229\189\147\229\137\141\229\183\178\230\152\175\230\156\128\230\150\176\231\137\136\230\156\172"))
        self:refreshBar(1)
        self:createUpdating(index + 1)
        eof = true
      elseif code == 1 then
        local step = LoadResources:getStep()
        local des = LoadResources:getDes()
        self:refreshExplanation(des or T("\230\155\180\230\150\176\228\184\173..."))
        self:refreshBar(progress)
        self:reportWhenDownloading(progress)
        self:setNetStatus("LR-update", 1)
        if LoadResources:isEnd() then
          self:setNetStatus("LR-uLend", 0)
          ed.reportHUE({
            action_type = "download_packs_finish"
          })
          local isLastVersion = self:checkLatestVersion()
          self:refreshExplanation(T("\230\155\180\230\150\176\229\174\140\230\136\144"))
          self:refreshBar(1)
          if isLastVersion then
            self:setNetStatus("LR-updateEnd", 1)
            self:createUpdating(index + 1)
          end
          eof = true
        end
      elseif code == 101 then
        EDLog("get packages size ...")
      elseif code == 110 and not hasShowConfirm then
        EDLog("finish get packages size")
        local packsSize = LoadResources:getPackagesTotalSizeDes()
        EDLog("packages size:" .. packsSize)
        ed.reportHUE({
          action_type = "get_packs_size_success",
          size = packsSize
        })
        ed.showConfirmDialog({
          text = string.format(T("\233\162\132\232\174\161\228\184\139\232\189\189\232\161\165\228\184\129\229\140\133%s,\232\175\183\231\161\174\232\174\164\227\128\130"), packsSize),
          leftHandler = function()
            EDExit()
          end,
          rightHandler = function()
            hasShowConfirm = nil
            LoadResources:initAutoUpdateParam()
            self:doUpdating(1)
          end
        })
        eof = true
        hasShowConfirm = true
      end
    end
  end
  
  return handler
end

logo.updateLogo = updateLogo
