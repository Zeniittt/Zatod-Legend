module("errorNet", package.seeall)
local factor = ed.display.scaleFactor
local UIRes = {
  {
    layerName = "errornetLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 0),
    touchInfo = {
      iPriority = -6001,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "errorBg",
          res = "UI/alpha/1080P/common/mail_bj9_1.png",
          capInsets = CCRectMake(15, 15, 15, 191.5)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ed.display.center
        },
        config = {
          scaleSize = CCSizeMake(310, 160)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T("\231\189\145\231\187\156\229\188\130\229\184\184"),
          fontinfo = "normalButton",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 140)
        },
        listData = true
      },
      {
        t = "Label",
        base = {
          name = "errorDes",
          text = T("\229\187\186\232\174\174\231\161\174\232\174\164\231\189\145\231\187\156\233\128\154\231\149\133\229\144\142\233\135\141\232\175\149"),
          fontinfo = "normalButton",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 115)
        },
        listData = true
      },
      {
        t = "Sprite",
        base = {
          name = "uiline",
          res = "UI/alpha/1080P/common/pvp_tip_delimiter.png",
          parent = "errorBg"
        },
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(155, 85)
        },
        config = {scale = 0.8}
      },
      {
        t = "Scale9Button",
        base = {
          name = "tryAgain",
          parent = "errorBg",
          buttonName = {
            text = T("\233\135\141\232\175\149"),
            fontInfo = "title_yellow"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 57.5, 15.5),
          handleName = "reLoad"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(205, 45)
        },
        config = {
          scaleSize = CCSizeMake(80, 40)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "back",
          parent = "errorBg",
          buttonName = {
            text = T("\233\128\128\229\135\186"),
            fontInfo = "title_yellow"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 57.5, 15.5),
          handleName = "reback"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(155, 45)
        },
        config = {
          scaleSize = CCSizeMake(80, 40)
        }
      }
    }
  }
}
local errorLogic = {}
local errorPanel, currentFunc, backFunc, isCreate

function showError(currentFun, backFun)
  if errorPanel then
    return
  end
  currentFunc = currentFun
  backFunc = backFun
  errorPanel = panelMeta:new2(errorLogic, UIRes)
  local ui = errorPanel.panelLayers.errornetLayer.uiControllers.tryAgain
  local lw = ui.label:getContentSize().width
  local bw = ui.sprite:getContentSize().width
  if bw < lw + 20 then
    ui.sprite:setContentSize(CCSizeMake(lw + 20, 48))
    ui.dataInfo.config.scaleSize = CCSizeMake(lw + 20, 48)
  end
  ui.label:setPosition(ed.getCenterPos(ui.sprite))
  local panel = errorPanel.panelLayers.errornetLayer.uiControllers
  print(panel.errorDes:getContentSize())
  panel.errorDes:limitSizeByScale(270, 30)
  if currentFunc and backFunc then
    panel.tryAgain:setPosition(ccp(105, 45))
    panel.tryAgain:setVisible(true)
    panel.back:setPosition(ccp(205, 45))
    panel.back:setVisible(true)
  elseif currentFunc then
    panel.tryAgain:setPosition(ccp(155, 45))
    panel.tryAgain:setVisible(true)
    panel.back:setVisible(false)
  elseif backFunc then
    panel.back:setPosition(ccp(155, 45))
    panel.back:setVisible(true)
    panel.tryAgain:setVisible(false)
  end
  if not isCreate then
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(errorPanel:getRootLayer(), 5000)
      if resource_config.hideErrorLine then
        errorPanel.uiline:setVisible(false)
      end
    end
    isCreate = true
  end
end

function errorLogic.reLoad()
  if nil == currentFunc then
    return
  end
  xpcall(function()
    currentFunc()
  end, EDDebug)
  if errorPanel == nil then
    return
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:removeChild(errorPanel:getRootLayer(), true)
    errorPanel = nil
  end
  isCreate = nil
end

function errorLogic.reback()
  if nil == backFunc then
    return
  end
  xpcall(function()
    backFunc()
  end, EDDebug)
  if errorPanel == nil then
    return
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:removeChild(errorPanel:getRootLayer(), true)
    errorPanel = nil
  end
  isCreate = nil
end
