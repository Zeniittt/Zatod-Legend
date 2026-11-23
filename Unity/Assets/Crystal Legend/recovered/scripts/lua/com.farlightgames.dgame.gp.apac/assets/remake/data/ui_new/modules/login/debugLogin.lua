local base = ed.ui.basescene
local debuglogin = newclass(base.mt)
ed.ui.debuglogin = debuglogin
local uieditor_mode
local isWin32 = EDFLAGWIN32
ed.ui.debuglogin.isWin32 = isWin32

function debuglogin:registerTouchHandler()
  local ui = self.ui
  if self.isPCDebugMode == "false" then
    self:btRegisterButtonClick({
      button = ui.btn_login,
      press = ui.btn_login_press,
      key = "btn_login",
      pressScale = 0.98,
      clickHandler = function()
        local account = ed.trim(self.account_editbox:getString())
        local password = ed.trim(self.password_editbox:getString())
        if #account == 0 or #password == 0 then
          ed.showToast(T("\232\180\166\229\143\183\230\136\150\229\175\134\231\160\129\228\184\141\232\131\189\228\184\186\231\169\186\239\188\129"))
          return
        end
        local temp = string.gsub(account, "@", "html|at|")
        ed.storage.setValue("Account", temp)
        temp = string.gsub(password, "@", "html|at|")
        ed.storage.setValue("Password", temp)
        EDSDKType = 1
        local serverLogin = ed.ui.serverlogin.create()
        serverLogin.openAutoSDKLogin = true
        ed.replaceScene(serverLogin)
        ListenTimer(Timer:Once(0.5), function()
          function EDSDKLogin()
            ed.replaceScene(ed.ui.debuglogin.create())
            
            function EDSDKLogin()
            end
          end
          
          FireEvent("SDKLogin", true, password, account)
        end)
      end
    })
    self:btRegisterHandler({
      handler = function(event, x, y)
        self.account_editbox:touch(event, x, y)
        self.password_editbox:touch(event, x, y)
      end,
      key = "edit_box"
    })
    self:btRegisterButtonClick({
      button = ui.opendebug,
      press = ui.opendebug_press,
      key = "opendebug",
      clickHandler = function()
        CCUserDefault:sharedUserDefault():setStringForKey("pcdebugmode", "true")
        ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159\239\188\140\232\175\183\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\239\188\129"))
        ListenTimer(Timer:Once(0.5), function()
          os.exit(0)
        end)
      end
    })
  else
    self:btRegisterButtonClick({
      button = ui.entergame,
      press = ui.entergame_press,
      key = "enter_game",
      clickHandler = function()
        local did = self.edit_box:getString() or ""
        did = string.gsub(did, " ", "")
        if did == "" then
          ed.showToast(T("\233\157\158\230\179\149\232\180\166\229\143\183\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
        else
          ed.setDeviceId(did)
          EDSDKType = 0
          ed.storage.setValue("dn_dvd", did)
          ed.config.device_id = did
          ed.replaceScene(ed.ui.serverlogin.create())
        end
      end
    })
    self:btRegisterButtonClick({
      button = ui.setradio,
      press = ui.setradio_press,
      key = "set_radio",
      clickHandler = function()
        local win = ed.ui.SetResRadioWin.create()
        win:popWindow(5)
      end
    })
    self:btRegisterButtonClick({
      button = ui.closedebug,
      press = ui.closedebug_press,
      key = "closedebug",
      clickHandler = function()
        CCUserDefault:sharedUserDefault():setStringForKey("pcdebugmode", "false")
        ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159\239\188\140\232\175\183\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\239\188\129"))
        ListenTimer(Timer:Once(0.5), function()
          os.exit(0)
        end)
      end
    })
    self:btRegisterButtonClick({
      button = ui.setup,
      press = ui.setup_press,
      key = "setup_button",
      clickHandler = function()
        self.setupwindow.pop()
      end
    })
    self:btRegisterButtonClick({
      button = ui.edit_frame,
      pressScale = 0.98,
      key = "input_button",
      clickHandler = function()
      end
    })
    self:btRegisterHandler({
      handler = function(event, x, y)
        self.edit_box:touch(event, x, y)
      end,
      key = "edit_box"
    })
    self:btRegisterButtonClick({
      button = ui.uieditor,
      press = ui.uieditor_press,
      key = "ui_editor",
      clickHandler = function()
        toolkit.open("ui")
      end
    })
    self:btRegisterButtonClick({
      button = ui.btn_language,
      press = ui.btn_language_press,
      key = "btn_language",
      clickHandler = function()
        debuglogin.setupLanguage.create():popWindow()
      end
    })
  end
end

function debuglogin.create()
  local self = base.create("debuglogin")
  setmetatable(self, debuglogin.mt)
  local isPCDebugMode = CCUserDefault:sharedUserDefault():getStringForKey("pcdebugmode")
  if isPCDebugMode == "" then
    isPCDebugMode = "true"
  end
  print("isPCDebugMode", isPCDebugMode)
  self.isPCDebugMode = isPCDebugMode
  ed.isPCCloneMode = isPCDebugMode == "false"
  local mainLayer = self.mainLayer
  local ui = self.ui
  local readNode = ed.readnode.create(mainLayer, ui)
  readNode:addNode(ed.uieditor.debugLogin)
  local center = ed.display.center
  if resource_config.splash_fca then
    local effect_fca = ed.createFcaActor(resource_config.splash_fca)
    effect_fca:setLoop(true)
    effect_fca:setPosition(center)
    effect_fca:setAction("Loop")
    mainLayer:addChild(effect_fca)
    self:addFca(effect_fca)
    effect_fca:setVisible(true)
    ui.bg:removeFromParentAndCleanup(true)
    ui.bg = effect_fca
  else
    self:setBackground(ed.getSplash())
  end
  if uieditor_mode then
    require("toolkit/kit")
  else
    ui.uieditor:setVisible(false)
  end
  if self.isPCDebugMode == "false" then
    ui.panel_debug:setVisible(false)
    ui.panel_release:setVisible(true)
    local info = {
      config = {
        editSize = ui.panel_box_account:getContentSize(),
        maxLength = 20,
        fontColor = ccc3(255, 252, 231),
        fontSize = 20
      }
    }
    local edit_box = editBox:new(info)
    edit_box:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165\232\180\166\229\143\183"))
    local temp = string.gsub(ed.storage.getString("Account"), "html|at|", "@")
    edit_box:setString(temp)
    edit_box.edit:setAnchorPoint(ccp(0, 0))
    ui.panel_box_account:addChild(edit_box.edit)
    ui.panel_box_account:setClipRect(CCRectMake(0, 0, info.config.editSize.width, info.config.editSize.height))
    self.account_editbox = edit_box
    local info = {
      config = {
        editSize = ui.panel_box_password:getContentSize(),
        maxLength = 15,
        fontColor = ccc3(255, 252, 231),
        fontSize = 20,
        inputFlag = kEditBoxInputFlagPassword
      }
    }
    edit_box = editBox:new(info)
    edit_box:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165\229\175\134\231\160\129"))
    temp = string.gsub(ed.storage.getString("Password"), "html|at|", "@")
    edit_box:setString(temp)
    edit_box.edit:setAnchorPoint(ccp(0, 0))
    ui.panel_box_password:addChild(edit_box.edit)
    ui.panel_box_password:setClipRect(CCRectMake(0, 0, info.config.editSize.width, info.config.editSize.height))
    self.password_editbox = edit_box
  else
    ui.panel_debug:setVisible(true)
    ui.panel_release:setVisible(false)
    ui.edit_frame = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = "installer/login/input_bg.png",
        capInsets = CCRectMake(12, 10, 12, 10)
      },
      config = {
        scaleSize = CCSizeMake(200, 50)
      }
    }, mainLayer)
    ed.layout.relateLayout(ui.entergame, ui.edit_frame, {
      top = ed.layout.getScaleSize(ui.edit_frame).height + 10
    })
    local info = {
      config = {
        editSize = ui.edit_frame:getContentSize(),
        maxLength = 60,
        fontColor = ccc3(255, 252, 231),
        fontSize = 20
      }
    }
    local edit_box = editBox:new(info)
    edit_box:setString(ed.storage.getString("dn_dvd") or "visitor")
    edit_box.edit:setAnchorPoint(ccp(0, 0))
    ui.edit_frame:addChild(edit_box.edit)
    self.edit_box = edit_box
    self:refreshLanguage()
  end
  self:registerTouchHandler()
  return self
end

function debuglogin:refreshLanguage()
  print("sound path:", EDFilePath:getInstance():getCurSound())
  print("lan path:", EDFilePath:getInstance():getCurLan())
  ed.setLabelString(self.ui.label_lan, T("\229\189\147\229\137\141\232\175\173\232\168\128:%s", EDCurLanguage))
end

local debuglogin = ed.ui.debuglogin
local base = ed.ui.popwindow
local setupwindow = newclass(base.mt)
debuglogin.setupwindow = setupwindow

function setupwindow:getFontList()
  local list = {}
  for line in io.lines("fontlist.txt") do
    table.insert(list, line)
  end
  return list
end

function setupwindow:createFontList()
  local ui = self.ui
  if not tolua.isnull(ui.font_list) then
    ui.font_list:removeFromParentAndCleanup(true)
    return
  end
  local frame = ui.frame
  local list = self:getFontList()
  local nodes = {}
  local vui = {}
  for i = 1, #list do
    table.insert(vui, {
      t = "Label",
      base = {
        name = i,
        text = list[i],
        size = 24
      }
    })
  end
  local node = ed.createNode({
    t = "VerticalNode",
    base = {nodeArray = nodes},
    layout = {
      anchor = ccp(0, 1),
      position = ed.DGccp(240, 380)
    },
    ui = vui
  }, frame)
  ui.font_list = node
  for i = 1, #nodes do
    self:btRegisterButtonClick({
      button = nodes[i],
      pressScale = 0.95,
      key = "font_list_" .. i,
      clickHandler = function()
        ed.setString(ui.font_name, list[i])
        ed.font = list[i]
        ed.fontBold = list[i]
        ui.font_list:removeFromParentAndCleanup(true)
      end,
      force = true
    })
  end
end

function setupwindow:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = ui.font_name,
    pressScale = 0.95,
    key = "font_name",
    clickHandler = function()
      self:createFontList()
    end
  })
end

function setupwindow.create()
  local self = base.create("debugloginsetup", {priority = -130})
  setmetatable(self, setupwindow.mt)
  local container = self.container
  local ui = self.ui
  local frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      capInsets = ed.DGRectMake(22, 22, 60, 20)
    },
    layout = {
      position = ccp(400, 240)
    },
    config = {
      scaleSize = ed.DGSizeMake(555, 455)
    }
  }, container)
  ui.frame = frame
  local readNode = ed.readnode.create(ui.frame, ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "font_name_title",
        text = T("\232\174\190\231\189\174\229\173\151\228\189\147\239\188\154"),
        size = 24
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(50, 400)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "font_name",
        text = ed.font,
        size = 24
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(240, 400)
      }
    }
  }
  readNode:addNode(ui_info)
  self:registerTouchHandler()
  self.isSkipTransAnim = true
  return self
end

function setupwindow:pop()
  local window = setupwindow.create()
  window:popWindow(300)
end

local setupLanguage = newclass(base.mt)
debuglogin.setupLanguage = setupLanguage

function setupLanguage.create()
  local self = base.create("debugSetupLanguage", {priority = -130})
  setmetatable(self, setupLanguage.mt)
  local container = self.container
  local ui = self.ui
  local frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      capInsets = ed.DGRectMake(22, 22, 60, 20)
    },
    layout = {
      position = ccp(400, 240)
    },
    config = {
      scaleSize = ed.DGSizeMake(555, 455)
    }
  }, container)
  ed.layout.centerInParent(frame)
  ui.frame = frame
  local readNode = ed.readnode.create(ui.frame, ui)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "lan_name_title",
        text = T("\232\175\173\232\168\128\239\188\154"),
        font = ed.fontBold,
        size = 24
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(50, 400)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "lan_name",
        text = T("\229\189\147\229\137\141\232\175\173\232\168\128\239\188\154%s", EDCurLanguage),
        font = ed.fontBold,
        size = 24
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(240, 400)
      }
    }
  }
  readNode:addNode(ui_info)
  self:registerTouchHandler()
  return self
end

function setupLanguage:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = ui.lan_name,
    pressScale = 0.95,
    key = "lan_name",
    clickHandler = function()
      self:createLanList()
    end
  })
end

function setupLanguage:createLanList()
  local ui = self.ui
  if not tolua.isnull(ui.lan_list) then
    ui.lan_list:removeFromParentAndCleanup(true)
    return
  end
  local frame = ui.frame
  local nodes = {}
  local vui = {}
  for key, v in pairs(ed.lilith_language_name) do
    table.insert(vui, {
      t = "Label",
      base = {
        name = key,
        text = v,
        font = ed.fontBold,
        size = 24
      }
    })
  end
  local node = ed.createNode({
    t = "VerticalNode",
    base = {nodeArray = nodes, offset = 10},
    layout = {
      anchor = ccp(0, 1),
      position = ed.DGccp(240, 360)
    },
    ui = vui
  }, frame)
  ui.lan_list = node
  for key, btn in pairs(nodes) do
    self:btRegisterButtonClick({
      button = btn,
      pressScale = 0.95,
      key = "lan_list_" .. key,
      clickHandler = function()
        ed.showToast("\232\174\190\231\189\174\232\175\173\232\168\128\239\188\154" .. key)
        ed.setCurLan(key)
        ed.setCurSoundLan(key)
        os.exit(0)
      end,
      force = true
    })
  end
end
