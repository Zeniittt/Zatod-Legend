local logPanel
local logLogic = {}
local logRes = {
  {
    layerName = "mainLayer",
    iPriority = 50,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -281,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/1080P/common/mail_bj9_1.png",
          capInsets = CCRectMake(10, 17, 10, 130)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2)
        },
        config = {
          scaleSize = CCSizeMake(550, 350)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "line1",
          parent = "bg",
          res = "UI/alpha/1080P/common/battle_prepare_lins_1.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(165, 325)
        },
        config = {
          scalexy = {x = -1, y = 1}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "line2",
          parent = "bg",
          res = "UI/alpha/1080P/common/battle_prepare_lins_1.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(385, 325)
        },
        config = {
          scalexy = {x = 1, y = 1}
        }
      },
      {
        t = "Label",
        base = {
          name = "name",
          parent = "bg",
          text = T("\229\133\172\228\188\154\230\151\165\229\191\151"),
          fontinfo = "title_yellow"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(275, 325)
        }
      },
      {
        t = "ListView",
        base = {
          name = "rankList",
          parent = "bg",
          cliprect = CCRectMake(15, 10, 500, 290),
          priority = -200,
          noShade = true,
          selfDealMessage = true,
          heightInner = 0,
          newClickFunc = true
        },
        itemConfig = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "",
              capInsets = CCRectMake(78.13, 0, 69.53, 11.72)
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(230, -15)
            },
            config = {
              scaleSize = CCSizeMake(460, 10)
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = T(""),
              fontinfo = "title_yellow"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(275, -12)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "item",
              text = " ",
              fontinfo = "small_internal"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -35)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/1080P/guild/log_date_bg.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(260, -10)
            },
            config = {
              scalexy = {x = 1, y = 1}
            }
          },
          {
            t = "Label",
            base = {
              name = "name",
              text = T(""),
              fontinfo = "op_act_white"
            },
            layout = {
              position = ccp(260, -10)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<text|small_internal| >"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -30)
            }
          }
        },
        itemConfig3 = {
          {
            t = "Label",
            base = {
              name = "time",
              text = T(""),
              fontinfo = "normalButton"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(10, 0)
            },
            listData = true
          },
          {
            t = "NewRichText",
            base = {
              name = "logContent",
              text = T("")
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(60, 0)
            },
            listData = true
          },
          {
            t = "RichText",
            base = {
              name = "item",
              text = "<text|small_internal| >"
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(40, -10)
            }
          }
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          parent = "bg",
          handleName = "close",
          clickPos = "outSide"
        },
        layout = {
          position = ccp(240, 150)
        },
        config = {
          messageRect = CCRectMake(0, 0, 480, 300)
        }
      }
    }
  }
}

function logLogic.close()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and logPanel then
    currentScene:removeChild(logPanel:getRootLayer(), true)
    logPanel = nil
  end
end

local t = {
  chairman = T("\228\188\154\233\149\191"),
  elder = T("\233\149\191\232\128\129"),
  verify = T("\233\156\128\233\170\140\232\175\129"),
  closed = T("\228\184\141\232\131\189\229\138\160\229\133\165"),
  no_verify = T("\230\137\128\230\156\137\228\186\186\229\143\175\229\138\160\229\133\165")
}

local function convertChairman(s)
  for k, v in pairs(t) do
    s = string.gsub(s, k, v .. " ")
  end
  return s
end

local raidPos = {
  [25] = 3,
  [26] = 1,
  [27] = 3
}

local function initPanel(data)
  if not data._guild_log then
    return
  end
  local lastDay = 0
  for _, glog in ipairs(data._guild_log) do
    local y, mon, d, h, m, s = ed.time2YMDHMS(ed.time2Server(glog._time))
    local timeDes = T("%d\230\156\136%d\230\151\165", mon, d) .. ed.getUTCLabel()
    local str = ed.lookupDataTable("GuildLog", "Content", glog._id)
    if raidPos[glog._id] then
      local ind = raidPos[glog._id]
      glog._params[ind] = T(glog._params[ind])
    end
    if d ~= lastDay then
      logPanel.rankList:changeItemConfig(2)
      logPanel.rankList:addItem({timeDes})
    end
    logPanel.rankList:changeItemConfig(3)
    local item = logPanel.rankList:addItem({
      T("%02d:%02d", h, m),
      ""
    })
    item.controllers.logContent:setString(convertChairman(T(str, unpack(glog._params))))
    if item.controllers.logContent:getContentSize().width > 440 then
      logPanel.rankList:addItem({" ", " "})
      item.controllers.logContent:setMaxWidth(440)
      item.controllers.logContent:setString(convertChairman(T(str, unpack(glog._params))))
    end
    lastDay = d
  end
end

function ed.showGuildLog(data)
  if logPanel == nil then
    logPanel = panelMeta:new2(logLogic, logRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(logPanel:getRootLayer(), 500)
    end
  end
  initPanel(data)
end
