local Statusbar = newclass()
ed.ui.statusbar = Statusbar
local res = ed.ui.uires
local STATUSBAR_TOUCH_PRIORITY = -16
local unFixedButtons = {}
local RuneBarScrop = {}
local ActivityScope = {}

local function addUnFixedButtons(node, name)
  table.insert(unFixedButtons, {node = node, name = name})
end

Statusbar.addUnFixedButtons = addUnFixedButtons
local unfixed_button_name_list = {enjoy_gift = 1, activities = 2}

local function refreshUnFixedButtonsPosition()
  local pos = res.recharge_pos
  local d_pos = ccp(62, 0)
  table.sort(unFixedButtons, function(a, b)
    local valueA = (a.node:isVisible() and 100 or 0) - unfixed_button_name_list[a.name]
    local valueB = (b.node:isVisible() and 100 or 0) - unfixed_button_name_list[b.name]
    return valueA > valueB
  end)
  for index, buttonData in ipairs(unFixedButtons) do
    local node = buttonData.node
    if node:isVisible() then
      node:setPosition(ccpSub(pos, ccpMult(d_pos, index)))
    end
  end
end

Statusbar.refreshUnFixedButtonsPosition = refreshUnFixedButtonsPosition

local function getInfoBarType(self)
  return self.identity
end

local function getuiList(self)
  self.sb_ui = self.sb_ui or {}
  return self.sb_ui
end

local function getContainer(self)
  if tolua.isnull(self.frameworkLayer) then
    self.frameworkLayer = CCLayer:create()
    self.mainLayer:addChild(self.frameworkLayer, 100)
  end
  return self.frameworkLayer
end

local function getInfoContainer(self)
  local container = getContainer(self)
  if tolua.isnull(self.infoLayer) then
    local infoLayer = CCSprite:create()
    infoLayer:setCascadeOpacityEnabled(true)
    container:addChild(infoLayer, 100)
    self.infoLayer = infoLayer
  end
  return self.infoLayer
end

local function registerTitleTouchHandler(self)
  local ui = getuiList(self)
  self:btRegisterButtonClick({
    button = ui.money_add_icon,
    pressScale = 0.9,
    key = "add_money",
    clickHandler = function()
      self:doClickMidas()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  self:btRegisterButtonClick({
    button = ui.rmb_add_icon,
    pressScale = 0.9,
    key = "add_rmb",
    clickHandler = function()
      self:doClickrmb("Diamonds")
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  self:btRegisterButtonClick({
    button = ui.vitality_add_icon,
    radius = 30,
    pressScale = 0.9,
    clickHandler = function()
      ed.showHandyDialog("buyVitalityWithDiamond", {active = true})
    end,
    key = "add_vitality",
    priority = STATUSBAR_TOUCH_PRIORITY - 1
  })
  self:btRegisterButtonClick({
    button = ui.vit_bg,
    key = "vit_board",
    pressHandler = function()
      self:createVitalityPrompt()
    end,
    liftHandler = function()
      self:destroyPromptCard(self)
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  self:btRegisterButtonClick({
    button = ui.wood_bg,
    key = "wood_bg",
    pressHandler = function()
      self:createWarschoolPrompt()
    end,
    liftHandler = function()
      self:destroyPromptCard()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  self:btRegisterButtonClick({
    button = ui.crystal_bg,
    key = "crystal_bg",
    pressHandler = function()
      self:createWarschoolPrompt()
    end,
    liftHandler = function()
      self:destroyPromptCard()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  self:btRegisterButtonClick({
    button = ui.iron_bg,
    key = "iron_bg",
    pressHandler = function()
      self:createWarschoolPrompt()
    end,
    liftHandler = function()
      self:destroyPromptCard()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function registerTitleBreadTouchHandler(self)
  local ui = getuiList(self)
  self:btRegisterButtonClick({
    button = ui.bread_bg,
    key = "bread_bg",
    pressHandler = function()
      self:createBreadPrompt()
    end,
    liftHandler = function()
      self:destroyPromptCard()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function refreshChatPos()
  local dt = 40
  local instance = ed.ui.chatTipBtnView.getInstance()
  local ui = instance.ui
  local x, _ = ui.chatTip:getPosition()
  ui.chatTip:setPositionX(x + dt)
  local x, _ = ui.chatMsg_bg:getPosition()
  ui.chatMsg_bg:setPositionX(x + dt)
end

local function createSDKIcon(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local container = getContainer(self)
  local ui = getuiList(self)
  local sid = EDSDKType or 0
  local list = {
    [9] = {
      iconres = "UI/alpha/HVGA/main_itools_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(1)
      end
    },
    [10] = {
      iconres = "UI/alpha/HVGA/main_lttw_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(1)
      end
    },
    [12] = {
      iconres = "UI/alpha/HVGA/main_funplus_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(ed.getUserid() .. ":" .. game_server_id .. ":" .. ed.player:getLevel())
      end
    },
    [13] = {
      iconres = "UI/alpha/HVGA/main_vng_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(13)
      end
    },
    [103] = {
      iconres = "UI/alpha/HVGA/main_lt_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(103)
      end
    },
    [125] = {
      iconres = "UI/alpha/HVGA/main_lttw_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(125)
      end
    },
    [128] = {
      iconres = "UI/alpha/HVGA/main_funplus_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(128)
      end
    },
    [131] = {
      iconres = "UI/alpha/HVGA/main_momo_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(131)
      end
    },
    [149] = {
      iconres = "UI/alpha/HVGA/main_youyi_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(149)
      end
    },
    [302] = {
      iconres = "UI/alpha/HVGA/main_lt_icon.png",
      clickSDKIconHandler = function()
        EDEnableSDKUI(302)
      end
    }
  }
  if 15 == EDSDKType then
    EDEnableSDKUI(ed.getUserid() .. ":" .. game_server_id .. ":" .. ed.player:getLevel())
  end
  if 114 == sid then
    EDEnableSDKUI(114)
  end
  local v = list[sid]
  if v then
    local iconres = v.iconres
    local icon = ed.createSprite(iconres)
    icon:setAnchorPoint(ccp(0, 0))
    local l, r, t, b = ed.getDisplayVertex()
    icon:setPosition(ccp(l, b))
    container:addChild(icon, 10)
    ui.sdkIcon = icon
    self:btRegisterButtonClick({
      button = ui.sdkIcon,
      pressScale = 0.95,
      key = "sdk_icon",
      clickHandler = function()
        v.clickSDKIconHandler()
      end,
      priority = STATUSBAR_TOUCH_PRIORITY
    })
    refreshChatPos()
  end
end

local function createBack(self)
  if ed.isElementInTable(self.identity, {
    "main",
    "RechargeScene"
  }) then
    return
  end
  local container = getContainer(self)
  local ui = getuiList(self)
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_arrow",
        res = "UI/alpha/1080P/common/break_butt.png",
        parent = "back"
      },
      config = {visible = true}
    }
  }
  readnode:addNode(ui_info)
  ed.layout.centerInParent(ui.back_arrow)
  ed.layout.layoutWithMagin(ui.back, {left = 0, top = 0})
  self:btRegisterButtonClick({
    button = ui.back,
    pressScale = 0.9,
    key = "back_button",
    clickHandler = function()
      self:doClickBack()
      if self.what == "StageSelectPanel" then
        ed.stopMusic()
      end
    end,
    force = true,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function refreshHead(self)
  local head_bg = {
    "UI/alpha/HVGA/main_head_bg_silver.png",
    "UI/alpha/HVGA/main_head_bg_gold.png"
  }
  local name_bg = {
    "UI/alpha/HVGA/main_head_name_bg_silver.png",
    "UI/alpha/HVGA/main_head_name_bg_gold.png"
  }
  local ui = getuiList(self)
  if tolua.isnull(ui.headContainer) then
    return
  end
  local head = ui.head
  local keys = {
    "head",
    "head_frame",
    "head_bg",
    "name_bg"
  }
  for k, v in pairs(keys) do
    if not tolua.isnull(ui[v]) then
      ui[v]:removeFromParentAndCleanup(true)
      ui[v] = nil
    end
  end
  local head, headicon = ed.getHeadIcon()
  head:setPosition(ui.playHead:getPosition())
  ui.Panel_head:addChild(head, 2)
  headicon:setScale(1.05)
  ui.head = head
  ui.headIcon = headicon
  ui.playHead:setVisible(false)
  ed.setTexture(ui.playHeadTop, ed.player:getHeadIconFres())
  if ui.headContainer:getChildByTag(5) then
    ui.headContainer:removeChild(ui.headContainer:getChildByTag(5), true)
  end
  ui.playHeadTop:setTag(5)
  ui.headframe = ui.playHeadTop
  self:btRegisterButtonClick({
    button = ui.headIcon,
    pressScale = 0.99,
    normalScale = 1.05,
    key = "head_button",
    force = true,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self.mainLayer:addChild(ed.ui.configure.create().mainLayer, 200)
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function refreshDailyloginTag(self)
end

local function refreshRechargeGiftTag(self)
  local ui = getuiList(self)
  local bv = ed.player:hasRechargeGiftActivity()
  if not tolua.isnull(ui.recharge) then
    ui.recharge:setVisible(not bv)
  end
  if not tolua.isnull(ui.rechargegift) then
    ui.rechargegift:setVisible(bv)
  end
end

local function refreshRechargeTag(self)
  local ui = getuiList(self)
  local b = ed.RechargeNewMgr.getInstance():canShowMainSceneRedTag()
  if tolua.isnull(ui.recharge_red_tag) then
    return
  end
  ui.recharge_red_tag:setVisible(b)
end

local function refreshActivityIconTexture(self)
  local ui = getuiList(self)
  local normal_res = "UI/alpha/1080P/main/main_icon_bg.png"
  local normal_res_press = "UI/alpha/1080P/main/main_icon_op_act.png"
  local hot_res = "UI/alpha/HVGA/main_icon_op_hot_2.png"
  local anniversaryStart = ed.parameter.anniversary_start or 0
  local anniversaryEnd = ed.parameter.anniversary_end or 0
  local res = normal_res_press
  local now = ed.getServerTime()
  if anniversaryStart <= now and anniversaryEnd > now then
    return
  end
  if ed.ActivityNewManager:hasHotActivity() then
    res = hot_res
  end
  ed.setTexture(ui.activities_press, res)
end

local function refreshActivity(self)
  local ui = getuiList(self)
  if ui.activities then
    if ed.activity.Activity.isShow() then
      ui.activities:setVisible(true)
      if ed.activity.Activity.isShowTag() then
        ui.activitiestag:setVisible(true)
      else
        ui.activitiestag:setVisible(false)
      end
    else
      ui.activities:setVisible(false)
    end
  end
  refreshActivityIconTexture(self)
  Statusbar.refreshUnFixedButtonsPosition()
end

local function refreshUserBackTag(self)
  local ui = getuiList(self)
  if ui.userBack and ed.player.data._uback_status == 1 then
    ui.userBack:setVisible(true)
    ui.userBackTag:setVisible(false)
  elseif ui.userBack then
    ui.userBack:setVisible(false)
  end
  Statusbar.refreshUnFixedButtonsPosition()
end

local function refreshMagicBoxTag(self)
  local ui = getuiList(self)
  local bv = ed.player:hasMagicBoxActivity()
  if ui.magicbox then
    ui.magicbox:setVisible(bv)
    ui.magicboxTag:setVisible(false)
  end
  Statusbar.refreshUnFixedButtonsPosition()
end

local function refreshBatmanTag(self)
  local ui = getuiList(self)
  if ui.sellhero then
    ui.sellhero:setVisible(true)
    ui.sellheroTag:setVisible(false)
  end
  Statusbar.refreshUnFixedButtonsPosition()
end

local function refreshInviteTag(self)
  local ui = getuiList(self)
  if tolua.isnull(ui.invite) then
    return
  end
  local is_open = ed.ui.assigntask.is_open == 1
  ui.invite:setVisible(is_open)
  Statusbar.refreshUnFixedButtonsPosition()
end

local function refreshImpulseGift(self)
  local ui = getuiList(self)
  if tolua.isnull(ui.btn_impulseGift) then
    return
  end
  local isActive = ed.RechargeNewMgr.getInstance():isImpulseGiftActive()
  ui.btn_impulseGift:setVisible(isActive)
  if isActive then
    local impulseData = ed.RechargeNewMgr.getInstance():getImpulseGiftData()
    local deadline = impulseData and ed.RechargeNewMgr.getInstance():getFirstActiveDeadline() or 0
    local leftTime = deadline - ed.getServerTime()
    ed.setString(ui.label_impulse_deadline, ed.gethmsNString(leftTime))
    local redDotBg = ui.img_impulseRedDotBg
    redDotBg:removeAllChildrenWithCleanup(true)
    local bunchCount = ed.RechargeNewMgr.getInstance():getGiftBunchGroupCount()
    redDotBg:setVisible(0 < bunchCount)
    local redDotLabel = ed.createLabelTTF(tostring(bunchCount), 16)
    redDotLabel:setPosition(ccp(11.33, 11.72))
    redDotBg:addChild(redDotLabel)
  end
end

local function refreshButtonPos(self)
  local headPos = res.head_bg_pos
  local ui = getuiList(self)
  local btnList = {
    {
      btn = ui.btn_age18,
      check = not ed.getIsAdult(),
      offsetY = 45
    },
    {
      btn = ui.btn_impulseGift,
      check = ed.RechargeNewMgr.getInstance():isImpulseGiftActive(),
      offsetY = 70
    },
    {
      btn = ui.newbieHelper,
      check = ed.NewbieHelperManager:isActivityOpen(),
      offsetX = -5,
      offsetY = 45
    },
    {
      btn = ui.SeniorPlayer,
      check = ed.SeniorPlayerManager:isActivityOpen(),
      offsetX = -5,
      offsetY = 45
    }
  }
  local startPos = ccp(-15, -100)
  for _, btnItem in ipairs(btnList) do
    if btnItem.check and not tolua.isnull(btnItem.btn) then
      local offsetX = btnItem.offsetX or 0
      btnItem.btn:setPosition(ccp(headPos.x + startPos.x + offsetX, headPos.y + startPos.y))
      startPos.y = startPos.y - btnItem.offsetY
    end
  end
end

local function createTitleButton(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local readNode = ed.readnode.create(self.infoLayer, ui)
  if tolua.isnull(ui.recharge) then
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "recharge",
          res = "UI/alpha/1080P/main/main_icon_bg.png",
          z = 10
        },
        layout = {
          position = res.dailylogin_pos
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "recharge_press",
          res = "UI/alpha/1080P/main/newshop_main_menu.png",
          parent = "recharge"
        },
        layout = {
          position = ccp(24, 28)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "recharge_red_tag",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "recharge"
        },
        layout = {
          position = ccp(43, 40)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "main_icon_nameBg",
          res = "UI/alpha/1080P/main/main_icon_name_bg.png",
          parent = "recharge"
        },
        layout = {
          position = ccp(24, -2)
        }
      },
      {
        t = "Label",
        base = {
          name = "nameTitSS",
          text = T("\229\133\133\229\128\188"),
          fontinfo = "main_icon_name",
          parent = "recharge"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(24, 4)
        }
      }
    }
    readNode:addNode(ui_info)
    self:btRegisterButtonClick({
      button = ui.recharge,
      pressScale = 1.2,
      clickHandler = function()
        self:doClickrmb()
      end,
      priority = STATUSBAR_TOUCH_PRIORITY
    })
  end
  if tolua.isnull(ui.dailylogin) then
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "dailylogin",
          res = "UI/alpha/1080P/main/main_icon_bg.png",
          z = 10
        },
        layout = {
          position = res.recharge_pos
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "dailylogin_press",
          res = "UI/alpha/1080P/main/main_dailyreward.png",
          parent = "dailylogin"
        },
        layout = {
          position = ccp(24, 28)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "main_icon_nameBg",
          res = "UI/alpha/1080P/main/main_icon_name_bg.png",
          parent = "dailylogin"
        },
        layout = {
          position = ccp(24, -2)
        }
      },
      {
        t = "Label",
        base = {
          name = "nameTitSS",
          text = T("\231\173\190\229\136\176"),
          fontinfo = "main_icon_name",
          parent = "dailylogin"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(24, 4)
        }
      }
    }
    readNode:addNode(ui_info)
  end
  self:btRegisterButtonClick({
    button = ui.dailylogin,
    pressScale = 1.2,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:showDailyLogin()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  refreshDailyloginTag(self)
  if tolua.isnull(ui.activities) then
    CloseScope(ActivityScope)
    local normal_res = "UI/alpha/1080P/main/main_icon_bg.png"
    local normal_res_press = "UI/alpha/1080P/main/main_icon_op_act.png"
    local anniversary_res = "UI/alpha/HVGA/main_icon_op_special_2.png"
    local res = normal_res
    local pressRes = normal_res_press
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "activities",
          res = res,
          z = 10
        },
        layout = {
          position = res.fourth_pos
        }
      },
      {
        t = "Sprite",
        base = {
          name = "activities_press",
          res = pressRes,
          parent = "activities"
        },
        layout = {
          position = ccp(24, 28)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "activitiestag",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "activities"
        },
        layout = {
          position = ccp(43, 40)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "main_icon_nameBg",
          res = "UI/alpha/1080P/main/main_icon_name_bg.png",
          parent = "activities"
        },
        layout = {
          position = ccp(24, -2)
        }
      },
      {
        t = "Label",
        base = {
          name = "nameTitSS",
          text = T("\230\180\187\229\138\168"),
          fontinfo = "main_icon_name",
          parent = "activities"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(24, 4)
        }
      }
    }
    readNode:addNode(ui_info)
    Statusbar.addUnFixedButtons(ui.activities, "activities")
    Statusbar.refreshUnFixedButtonsPosition()
    local now = ed.getServerTime()
    local anniversaryStart = ed.parameter.anniversary_start or 0
    local anniversaryEnd = ed.parameter.anniversary_end or 0
    if now >= anniversaryStart and now < anniversaryEnd then
      res = anniversary_res
      ed.setTexture(ui.activities_press, res)
      ListenTimer(Timer:Once(anniversaryEnd - now), function()
        ed.setTexture(ui.activities_press, normal_res)
      end, ActivityScope)
    elseif now < anniversaryStart then
      ListenTimer(Timer:Once(anniversaryStart - now), function()
        ed.setTexture(ui.activities_press, anniversary_res)
        if anniversaryStart < anniversaryEnd then
          ListenTimer(Timer:Once(anniversaryEnd - anniversaryStart), function()
            ed.setTexture(ui.activities_press, normal_res)
          end, ActivityScope)
        end
      end, ActivityScope)
    end
  end
  self:btRegisterButtonClick({
    button = ui.activities,
    pressScale = 1.2,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.ActivityNewNetWork:sendOpenPanel()
    end,
    clickInterval = 1,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
  Statusbar.createEnjoyGift(self)
end

local function createEnjoyGift(self)
  local ui = getuiList(self)
  local readNode = ed.readnode.create(self.infoLayer, ui)
  local pos = res.recharge_pos
  if tolua.isnull(ui.enjoy_gift) then
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "enjoy_gift",
          res = "UI/alpha/1080P/main/main_icon_bg.png",
          z = 10
        },
        layout = {position = pos},
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "enjoy_gifts",
          res = "UI/alpha/1080P/main/enjoy_gift_main_scene_icon_active.png",
          parent = "enjoy_gift"
        },
        layout = {
          position = ccp(24, 28)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "enjoy_gift_tag",
          res = "UI/alpha/HVGA/main_deal_tag.png",
          parent = "enjoy_gift"
        },
        layout = {
          position = ccp(43, 40)
        },
        config = {visible = false}
      },
      {
        t = "Sprite",
        base = {
          name = "main_icon_nameBg",
          res = "UI/alpha/1080P/main/main_icon_name_bg.png",
          parent = "enjoy_gift"
        },
        layout = {
          position = ccp(24, -2)
        }
      },
      {
        t = "Label",
        base = {
          name = "nameTitSS",
          text = T("\231\164\188\229\140\133"),
          fontinfo = "main_icon_name",
          parent = "enjoy_gift"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(24, 4)
        }
      }
    }
    readNode:addNode(ui_info)
    Statusbar.addUnFixedButtons(ui.enjoy_gift, "enjoy_gift")
    Statusbar.refreshUnFixedButtonsPosition()
    self:btRegisterButtonClick({
      button = ui.enjoy_gift,
      pressScale = 1.2,
      clickHandler = function()
        ed.playEffect(ed.sound.deo.common_click_feedback)
        if ReloadModule then
          ReloadModule("ui/EnjoyGift/EnjoyGiftModuleList")
        end
        ed.EnjoyGiftManager:handleMainSceneIconClick()
      end,
      clickInterval = 1,
      priority = STATUSBAR_TOUCH_PRIORITY
    })
  end
end

Statusbar.createEnjoyGift = createEnjoyGift

local function refreshEnjoyGift(self)
  local ui = getuiList(self)
  if tolua.isnull(ui.enjoy_gift) then
    return
  end
  local isOpen = ed.EnjoyGiftManager:isOpen()
  ui.enjoy_gift:setVisible(isOpen)
  local showRed = ed.EnjoyGiftManager:getRedFlag()
  ui.enjoy_gift_tag:setVisible(showRed)
end

Statusbar.refreshEnjoyGift = refreshEnjoyGift

local function createNewbieHelper(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  local readNode = ed.readnode.create(container, ui)
  local pos = res.recharge_pos
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "newbieHelper",
        res = "UI/alpha/HVGA/NewbieHelper/newbie_helper_mainscene_icon.png",
        z = 10
      },
      layout = {position = pos},
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "newbieHelper_press",
        res = "UI/alpha/HVGA/NewbieHelper/newbie_helper_mainscene_icon_press.png",
        parent = "newbieHelper"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "newbieHelperTag",
        res = "UI/alpha/HVGA/main_deal_tag.png",
        parent = "newbieHelper"
      },
      layout = {
        position = ccp(43, 40)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  self:btRegisterButtonClick({
    button = ui.newbieHelper,
    press = ui.newbieHelper_press,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.NewbieHelperManager:setNotifyTag(false)
      ed.NewbieHelperManager:handleMainSceneIconClick()
    end,
    clickInterval = 1,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function createSeniorPlayer(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  local readNode = ed.readnode.create(container, ui)
  local pos = res.recharge_pos
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "SeniorPlayer",
        res = "UI/alpha/HVGA/SeniorPlayer/mainscene_icon.png",
        z = 10
      },
      layout = {position = pos},
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "SeniorPlayer_press",
        res = "UI/alpha/HVGA/SeniorPlayer/mainscene_icon_press.png",
        parent = "SeniorPlayer"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "SeniorPlayerTag",
        res = "UI/alpha/HVGA/main_deal_tag.png",
        parent = "SeniorPlayer"
      },
      layout = {
        position = ccp(43, 40)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  self:btRegisterButtonClick({
    button = ui.SeniorPlayer,
    press = ui.SeniorPlayer_press,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.SeniorPlayerManager:handleMainSceneIconClick()
    end,
    clickInterval = 1,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function refreshNewbie(self)
  local ui = getuiList(self)
  if tolua.isnull(ui.newbieHelper) then
    return
  end
  local isOpen = ed.NewbieHelperManager:isActivityOpen()
  ui.newbieHelper:setVisible(isOpen)
  local showRed = ed.NewbieHelperManager:getNotifyTag()
  ui.newbieHelperTag:setVisible(showRed)
end

Statusbar.refreshNewbie = refreshNewbie

local function refreshSeniorPlayer(self)
  local ui = getuiList(self)
  if tolua.isnull(ui.SeniorPlayer) then
    return
  end
  local isOpen = ed.SeniorPlayerManager:isActivityOpen()
  ui.SeniorPlayer:setVisible(isOpen)
  local showRed = ed.SeniorPlayerManager:getNotifyTag()
  ui.SeniorPlayerTag:setVisible(showRed)
end

Statusbar.refreshSeniorPlayer = refreshSeniorPlayer

local function createHead(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  local isBabel, levelPy = false, 25
  self.playerName = ed.player:getName()
  self.avatarid = ed.player:getAvatar()
  self.vip = ed.player:getvip()
  self.playerLevel, isBabel = ed.player:getNewLevel()
  local playExp = ed.player:getExp()
  local playExpMax = ed.player:getMaxExp()
  self.playExp, self.playExpMax = playExp, playExpMax
  local lvColor = ccc3(241, 235, 206)
  if isBabel then
    lvColor = ccc3(251, 206, 16)
    levelPy = 28
  end
  local headContainer = CCSprite:create()
  headContainer:setContentSize(CCSizeMake(500, 200))
  headContainer:setPosition(res.head_bg_pos)
  container:addChild(headContainer, 10)
  ui.headContainer = headContainer
  local readnode = ed.readnode.create(ui.headContainer, ui)
  local ui_info = ed.uieditor.mianUiLay
  readnode:addNode(ui_info)
  ui.playerName:setString(self.playerName or "")
  ui.playLv:setString((self.playerLevel or "0") .. "\231\186\167")
  ui.playLv_blak:setString((self.playerLevel or "0") .. "\231\186\167")
  ui.vipNum:setString(self.vip or "0")
  ui.vipNum_bank:setString(self.vip or "0")
  ui.playerName:setAnchorPoint(ccp(0, 0.5))
  ui.vipNum:setAnchorPoint(ccp(0, 0.5))
  ui.vipNum_bank:setAnchorPoint(ccp(0, 0.5))
  ui.playLv:setAnchorPoint(ccp(0, 0.5))
  ui.playLv_blak:setAnchorPoint(ccp(0, 0.5))
  ui.playerName:setStroke(ccc3(43, 28, 11), 1)
  ui.playLv:setStroke(ccc3(249, 225, 109), 0.5)
  ui.playLv_blak:setStroke(ccc3(43, 28, 11), 0.7)
  local lang = playExp / playExpMax
  lang = 1 < lang and 1 or lang
  lang = lang < 0 and 0 or lang
  ui.exp_progress_bar:setTextureRect(CCRectMake(0, 0, lang * 100, 4.5))
end

local function createHeadUpData(self)
end

local function createAge18Icon(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local isAdult = ed.getIsAdult()
  if isAdult then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  local readNode = ed.readnode.create(container, ui)
  local pos = res.head_bg_pos
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_age18",
        res = "UI/alpha/HVGA/preventaddiction_entrance_btn_usual.png",
        z = 10
      },
      layout = {
        position = ccp(pos.x - 15, pos.y - 100)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "btn_age18_press",
        res = "UI/alpha/HVGA/preventaddiction_entrance_btn_pressed.png",
        parent = "btn_age18"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  self:btRegisterButtonClick({
    button = ui.btn_age18,
    press = ui.btn_age18_press,
    clickHandler = function()
      if ReloadModule then
        ReloadModule("ui_new/dreamland/dreamlandscene")
      end
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function getTitlePos(idx)
  local widths = ed.display.winSize.width - ed.display.halfFixedWidth
  return ccp(widths - 185 * (idx - 1) - 133, ed.display.winSize.height - ed.display.halfFixedHeight - 23)
end

local function createBar(self, readNode, name)
  local config = ed.ui.configs.resBar.getResBarConfig(name)
  local doAccess = config.doAccess
  local parent = name .. "_bg"
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = parent,
        res = "UI/alpha/1080P/main/main_status_number_bg.png",
        capInsets = CCRectMake(5, 5, 2.5, 7.5)
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(170, 28)
      }
    },
    {
      t = "Sprite",
      base = {
        name = name .. "_icon",
        res = config.smallIcon or config.icon,
        parent = parent
      },
      layout = {
        position = ccp(155, 14)
      },
      config = {
        scale = config.scale or 1
      }
    },
    {
      t = "Sprite",
      base = {
        name = name .. "_add_icon",
        res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
        parent = parent,
        visible = doAccess ~= nil
      },
      layout = {
        position = ccp(14, 14)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = name .. "_text_value",
        z = 0,
        parent = parent,
        text = ed.formatNumWithComma(config.initValue(name)),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(35, 14)
      },
      config = {}
    }
  }
  readNode:addNode(ui_info)
  local value = readNode.array[name .. "_text_value"]
  value:setStroke(ccc3(0, 0, 0), 1.5)
  value:setColor(ccc3(255, 252, 231))
  if name == "vitality" then
    self:btRegisterButtonClick({
      button = readNode.array[name .. "_bg"],
      pressHandler = function()
        print("csdsd")
        self:createVitalityPrompt()
      end,
      liftHandler = function()
        self:destroyPromptCard(self)
      end,
      pressScale = 0.9,
      priority = STATUSBAR_TOUCH_PRIORITY
    })
  end
  if type(doAccess) == "function" then
    self:btRegisterButtonClick({
      button = readNode.array[name .. "_add_icon"],
      clickHandler = function()
        print(name)
        doAccess()
      end,
      pressScale = 0.9,
      priority = STATUSBAR_TOUCH_PRIORITY - 1
    })
  end
end

local function createTitle(self)
  local ui = getuiList(self)
  local infoLayer = getInfoContainer(self)
  local configs = ed.ui.configs.resBar.getSceneBarsConfig(self.identity)
  if not configs then
    return
  end
  local titleLayer = CCSprite:create()
  titleLayer:setCascadeOpacityEnabled(true)
  self.titleLayer = titleLayer
  infoLayer:addChild(titleLayer)
  local readNode = ed.readnode.create(titleLayer, ui)
  for i, v in ipairs(configs) do
    createBar(self, readNode, v)
  end
  local size = CCSizeMake(#configs * 175, 28)
  self.titleLayer:setContentSize(size)
  ed.layout.layoutWithMagin(self.titleLayer, {right = 0, top = 0})
  ed.layout.layoutChildrenWithSize(self.titleLayer, size, ed.layoutType.Grid, {
    gridSize = CCSizeMake(175, 28)
  })
end

local function createAssistant(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getInfoContainer(self)
  local readNode = ed.readnode.create(container, ui)
  local pos = res.recharge_pos
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_assistant",
        res = "UI/alpha/HVGA/assistant/assistant_entryicon_normal.png",
        z = 10
      },
      layout = {position = pos},
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "btn_assistant_press",
        res = "UI/alpha/HVGA/assistant/assistant_entryicon_pressed.png",
        parent = "btn_assistant"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  Statusbar.addUnFixedButtons(ui.btn_assistant, "assistant")
  Statusbar.refreshUnFixedButtonsPosition()
  self:btRegisterButtonClick({
    button = ui.btn_assistant,
    press = ui.btn_assistant_press,
    clickHandler = function()
      local panel = ed.ui.AssistantMainWin.create()
      panel:popWindow()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function createAssistant1(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  local readNode = ed.readnode.create(container, ui)
  local pos = res.recharge_pos
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_assistant1",
        res = "UI/alpha/HVGA/assistant/assistant_entryicon_normal.png",
        z = 10
      },
      layout = {position = pos},
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "btn_assistant1_press",
        res = "UI/alpha/HVGA/assistant/assistant_entryicon_pressed.png",
        parent = "btn_assistant1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  self:btRegisterButtonClick({
    button = ui.btn_assistant1,
    press = ui.btn_assistant1_press,
    clickHandler = function()
      local panel = ed.ui.AssistantMainWin.create()
      panel:popWindow()
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function createImpulseGift(self)
  if not ed.isElementInTable(self.identity, {"main"}) then
    return
  end
  local ui = getuiList(self)
  local container = getContainer(self)
  local readNode = ed.readnode.create(container, ui)
  local pos = res.head_bg_pos
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_impulseGift",
        z = 10
      },
      layout = {
        position = ccp(pos.x - 15, pos.y - 190)
      },
      config = {
        scaleSize = CCSizeMake(114, 74)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "btn_impulseGift_press",
        parent = "btn_impulseGift"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(114, 74)
      }
    },
    {
      t = "Label",
      base = {
        name = "label_impulse_deadline",
        text = "00:00",
        fontinfo = "dark_white_stroke",
        parent = "btn_impulseGift"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(18, 10)
      }
    }
  }
  readNode:addNode(ui_info)
  local effect = ed.createFcaNode("eff_UI_impulse")
  effect:setPosition(ccp(35, 36))
  self:addFca(effect)
  ui.btn_impulseGift:addChild(effect)
  local redDotBg = ed.createSprite("UI/alpha/HVGA/ActivityNew/digit_red_tag_bg.png")
  redDotBg:setPosition(ccp(20, 40))
  ui.btn_impulseGift:addChild(redDotBg, 99)
  ui.img_impulseRedDotBg = redDotBg
  self:btRegisterButtonClick({
    button = ui.btn_impulseGift,
    press = ui.btn_impulseGift_press,
    clickHandler = function()
      ed.showToastZ(T("\229\138\159\232\131\189\230\156\170\229\188\128\230\148\190"))
    end,
    priority = STATUSBAR_TOUCH_PRIORITY
  })
end

local function getBarConfig(self, key)
  local ui = getuiList(self)
  local warrespos
  if getInfoBarType(self) == "warcollege" then
    warrespos = ccp(115, 25)
  elseif getInfoBarType(self) == "warresource" then
    warrespos = ccp(95, 25)
  end
  self.bar_config = self.bar_config or {
    money = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player._money
      end,
      bgNode = "money_bg",
      textNode = "moneyText",
      text = function(value)
        return ed.formatNumWithComma(value or ed.player._money)
      end,
      padding = 0,
      rightPoint = getInfoBarType(self) == "warresource" and ccp(130, 25) or ccp(137, 14),
      rightNode = nil,
      scale = 1.2
    },
    rmb = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player._rmb
      end,
      bgNode = "rmb_bg",
      textNode = "rmbText",
      text = function()
        return ed.formatNumWithComma(ed.player._rmb)
      end,
      padding = 0,
      rightPoint = getInfoBarType(self) == "RechargeScene" and ccp(130, 25) or ccp(137, 14),
      rightNode = nil,
      scale = 1.2
    },
    crusadeMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getCrusadeMoney()
      end,
      bgNode = "crusade_money_bg",
      textNode = "crusadeMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getCrusadeMoney())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil,
      scale = 1.2
    },
    pvpMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getPvpMoney()
      end,
      bgNode = "pvp_money_bg",
      textNode = "pvpMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getPvpMoney())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil,
      scale = 1.2
    },
    topPvpMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getTopPvpMoney()
      end,
      bgNode = "top_pvp_money_bg",
      textNode = "topPvpMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getTopPvpMoney())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    legendMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getLegendPoint()
      end,
      bgNode = "legend_money_bg",
      textNode = "legendMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getLegendPoint())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    starGateMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getStarPoint()
      end,
      bgNode = "stargate_money_bg",
      textNode = "starGateMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getStarPoint())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    guildMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getGuildMoney()
      end,
      bgNode = "guild_money_bg",
      textNode = "guildMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getGuildMoney())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    gvgMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getPoint("gvgpoint")
      end,
      bgNode = "gvg_money_bg",
      textNode = "gvgMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getPoint("gvgpoint"))
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    dreamlandMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getDreamlandMoney()
      end,
      bgNode = "dreamland_money_bg",
      textNode = "dreamlandMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getDreamlandMoney())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    gcwMoney = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getGCWMoney()
      end,
      bgNode = "gcw_money_bg",
      textNode = "gcwMoneyText",
      text = function()
        return ed.formatNumWithComma(ed.player:getGCWMoney())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    vitality = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getVitality()
      end,
      bgNode = "vit_bg",
      textNode = "vitText",
      text = function()
        return ed.formatNumWithComma(ed.player:getVitality())
      end,
      padding = 0,
      folder = function()
        if ed.player:getVitality() > ed.playerlimit.maxVitality() then
          return "main_blue"
        end
      end,
      scale = 1.2,
      rightNode = "maxVitText"
    },
    maxVit = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.playerlimit.maxVitality()
      end,
      bgNode = "vit_bg",
      textNode = "maxVitText",
      text = function()
        return "/" .. ed.formatNumWithComma(ed.playerlimit.maxVitality())
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil,
      scale = 1.2,
      refreshKeys = {"vitality"}
    },
    wood = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getWood()
      end,
      bgNode = "wood_bg",
      textNode = "woodText",
      text = function()
        return ed.formatNumWithComma(ed.player:getWood())
      end,
      padding = 0,
      rightPoint = warrespos,
      rightNode = nil
    },
    crystal = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getCrystal()
      end,
      bgNode = "crystal_bg",
      textNode = "crystalText",
      text = function()
        return ed.formatNumWithComma(ed.player:getCrystal())
      end,
      padding = 0,
      rightPoint = warrespos,
      rightNode = nil
    },
    iron = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getIron()
      end,
      bgNode = "iron_bg",
      textNode = "ironText",
      text = function()
        return ed.formatNumWithComma(ed.player:getIron())
      end,
      padding = 0,
      rightPoint = warrespos,
      rightNode = nil
    },
    sun = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getPoint("sun")
      end,
      bgNode = "sun_bg",
      textNode = "sunText",
      text = function(value)
        return ed.formatNumWithComma(value or ed.player:getPoint("sun"))
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    moon = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getPoint("moon")
      end,
      bgNode = "moon_bg",
      textNode = "moonText",
      text = function()
        return ed.formatNumWithComma(ed.player:getPoint("moon"))
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    star = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getPoint("star")
      end,
      bgNode = "star_bg",
      textNode = "starText",
      text = function()
        return ed.formatNumWithComma(ed.player:getPoint("star"))
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    },
    bread = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getBread()
      end,
      bgNode = "bread_bg",
      textNode = "breadText",
      text = function()
        return ed.formatNumWithComma(ed.player:getBread())
      end,
      padding = 0,
      folder = function()
        if ed.player:getBread() > ed.playerlimit.maxBreads() then
          return "main_blue"
        end
      end,
      rightPoint = ccp(-10, 25),
      rightNode = "maxBreadText"
    },
    maxBread = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.playerlimit.maxBreads()
      end,
      bgNode = "bread_bg",
      textNode = "maxBreadText",
      text = function()
        return "/" .. ed.formatNumWithComma(ed.playerlimit.maxBreads())
      end,
      padding = 0,
      rightPoint = ccp(100, 25),
      rightNode = nil
    },
    summonPoint = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return ed.player:getTarotPoint()
      end,
      bgNode = "summon_bg",
      textNode = "summonPointText",
      text = function()
        local id = ed.summonMgr:getNormalCfgConstant("Use Ticket")
        return ed.formatNumWithComma(ed.player:getEquipAmount(id))
      end,
      padding = 0,
      rightPoint = ccp(137, 14),
      rightNode = nil
    }
  }
  if not key then
    return self.bar_config
  else
    return self.bar_config[key]
  end
end

local function setWarTitleVisible(self, visible)
  local ui = getuiList(self)
  if self.left_type then
    ui[self.left_type .. "_bg"]:setVisible(visible)
    ui[self.right_type .. "_bg"]:setVisible(visible)
    return
  end
  local visibltTbl = {
    [1] = "wood",
    [2] = "crystal",
    [3] = "iron"
  }
  local invisibltTbl = {
    [1] = "money",
    [2] = "rmb",
    [3] = "vit"
  }
  for i, v in ipairs(visibltTbl) do
    if ui[v .. "_bg"] then
      ui[v .. "_bg"]:setVisible(visible)
    end
  end
  for i, v in ipairs(invisibltTbl) do
    if ui[v .. "_bg"] then
      ui[v .. "_bg"]:setVisible(not visible)
    end
  end
end

Statusbar.setWarTitleVisible = setWarTitleVisible

local function initBarConfig(self, key)
  local bc = getBarConfig(self, key)
  if key then
    bc.hasInit = nil
  else
    for k, v in pairs(bc) do
      v.hasInit = nil
    end
  end
end

local resTbl = {
  wood = {
    res = "UI/alpha/HVGA/warschool/resource_wood.png"
  },
  iron = {
    res = "UI/alpha/HVGA/warschool/resource_iron.png"
  },
  gold = {
    res = "UI/alpha/1080P/common/goldicon_small.png"
  },
  diamond = {
    res = "UI/alpha/1080P/common/rmbicon.png"
  },
  crystal = {
    res = "UI/alpha/HVGA/warschool/resource_crystal.png"
  }
}

local function getPointByType(type)
  if type == "gold" then
    return ed.player._money
  elseif type == "diamond" then
    return ed.player._rmb
  else
    return ed.player:getPoint(type)
  end
end

local function refreshWarresourceTitle(self, left_type, right_type)
  local ui = getuiList(self)
  if not self.left_type then
    ui.wood_bg:removeFromParentAndCleanup(true)
    ui.wood_bg = nil
    ui.iron_bg:removeFromParentAndCleanup(true)
    ui.iron_bg = nil
    ui.crystal_bg:removeFromParentAndCleanup(true)
    ui.crystal_bg = nil
  end
  local readNode = ed.readnode.create(self.titleLayer, ui)
  if self.left_type ~= left_type then
    if self.left_type then
      ui[self.left_type .. "_bg"]:removeFromParentAndCleanup(true)
      ui[self.left_type .. "_bg"] = nil
    end
    self.left_type = left_type
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = left_type .. "_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(5, 5, 2.5, 7.5)
        },
        layout = {
          position = ccp(271, 440)
        },
        config = {
          scaleSize = CCSizeMake(155, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = left_type .. "icon",
          res = resTbl[left_type].res,
          array = self.frameworkicon,
          parent = left_type .. "_bg"
        },
        layout = {
          position = ccp(130, 25)
        },
        config = {}
      }
    }
    readNode:addNode(ui_info)
    self.bar_config[left_type] = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return getPointByType(left_type)
      end,
      bgNode = left_type .. "_bg",
      textNode = left_type .. "Text",
      text = function()
        return ed.formatNumWithComma(getPointByType(left_type))
      end,
      padding = 0,
      rightPoint = ccp(115, 25),
      rightNode = nil
    }
  end
  if self.right_type ~= right_type then
    if self.right_type then
      ui[self.right_type .. "_bg"]:removeFromParentAndCleanup(true)
      ui[self.right_type .. "_bg"] = nil
    end
    self.right_type = right_type
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = right_type .. "_bg",
          res = "UI/alpha/HVGA/main_status_number_bg.png",
          capInsets = CCRectMake(5, 5, 2.5, 7.5)
        },
        layout = {
          position = ccp(551, 440)
        },
        config = {
          scaleSize = CCSizeMake(155, 48)
        }
      },
      {
        t = "Sprite",
        base = {
          name = right_type .. "icon",
          res = resTbl[right_type].res,
          array = self.frameworkicon,
          parent = right_type .. "_bg"
        },
        layout = {
          position = ccp(130, 25)
        },
        config = {}
      }
    }
    readNode:addNode(ui_info)
    self.bar_config[right_type] = {
      hasInit = nil,
      preValue = nil,
      value = function()
        return getPointByType(right_type)
      end,
      bgNode = right_type .. "_bg",
      textNode = right_type .. "Text",
      text = function()
        return ed.formatNumWithComma(getPointByType(right_type))
      end,
      padding = 0,
      rightPoint = ccp(115, 25),
      rightNode = nil
    }
  end
end

Statusbar.interface = {
  sbGetuiList = getuiList,
  sbGetInfoBarType = getInfoBarType,
  sbGetContainer = getContainer,
  sbGetInfoContainer = getInfoContainer,
  sbCreateBack = createBack,
  sbCreateSDKIcon = createSDKIcon,
  sbCreateHead = createHead,
  sbRefreshHead = refreshHead,
  sbRefreshRechargeGiftTag = refreshRechargeGiftTag,
  sbRefreshActivity = refreshActivity,
  sbRefreshInviteTag = refreshInviteTag,
  sbCreateTitle = createTitle,
  sbCreateTitleButton = createTitleButton,
  sbRefreshDailyloginTag = refreshDailyloginTag,
  sbRefreshUserBackTag = refreshUserBackTag,
  sbRefreshMagicBoxTag = refreshMagicBoxTag,
  sbRefreshBatmanTag = refreshBatmanTag,
  sbGetBarConfig = getBarConfig,
  sbInitBarConfig = initBarConfig,
  sbWarTitleVisible = setWarTitleVisible,
  sbRefreshWarresourceTitle = refreshWarresourceTitle,
  sbCreateAssistant = createAssistant,
  sbCreateAssistant1 = createAssistant1,
  sbCreateImpulseGift = createImpulseGift,
  sbRefreshImpulseGift = refreshImpulseGift,
  sbRefreshButtonPos = refreshButtonPos,
  sbRefreshRechargeTag = refreshRechargeTag,
  sbRefreshNewbie = refreshNewbie,
  sbRefreshSeniorPlayer = refreshSeniorPlayer,
  sbRefreshEnjoyGift = refreshEnjoyGift
}
