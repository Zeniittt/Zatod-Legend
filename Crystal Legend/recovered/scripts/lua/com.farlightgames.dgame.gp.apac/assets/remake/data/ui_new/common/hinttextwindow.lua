local uiRes = {
  {
    layerName = "mainLayer",
    iPriority = 0,
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "bg",
          res = "UI/alpha/1080P/common/main_vit_tips.png",
          capInsets = CCRectMake(15, 10, 15, 10)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(450, 340)
        }
      },
      {
        t = "RichText",
        base = {
          name = "content",
          text = "",
          parent = "bg"
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(10, 55)
        }
      }
    }
  }
}
local hintPanel
local xOffset = 30
local yBgOffset = 30

function ed.closeHintText()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and hintPanel then
    currentScene:removeChild(hintPanel:getRootLayer(), true)
    hintPanel = nil
  end
end

function ed.showHintText(text, pos)
  if hintPanel == nil then
    hintPanel = panelMeta:new2({}, uiRes)
    local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      currentScene:addChild(hintPanel:getRootLayer(), 500)
    end
  end
  hintPanel.bg:setPosition(pos)
  hintPanel.content:setString(text)
  local width, heigth = hintPanel.content:getSize()
  hintPanel.bg:setContentSize(CCSizeMake(width + xOffset, heigth + yBgOffset))
  hintPanel.content:setPosition(ccp(10, heigth + yBgOffset / 2))
end

function ed.showHintTextWithParent(param)
  local parent = param.parent
  local text = param.text
  local direction = param.direction
  local offset = param.offset
  local endTime = param.endTime
  offset = offset or ccp(0, 0)
  local tipsPanel = panelMeta:new2({}, uiRes)
  ed.getCurrentScene().scene:addChild(tipsPanel:getRootLayer(), 999)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({context = text, fontSize = 16})
  tipsPanel.bg:addChild(autoText.node)
  local width, height = autoText:getCurContentSize()
  local gapY = 8
  local size = CCSizeMake(0, 0)
  if endTime then
    local frame = ed.getSpriteFrame("UI/alpha/1080P/activity/activity_buff/buff_bg.png")
    size = frame:getRect().size
    local capInsets = CCRectMake(size.width / 3, size.height / 3, size.width / 3, size.height / 3)
    local endTimeBg = CCScale9Sprite:createWithSpriteFrame(frame, capInsets)
    tipsPanel.bg:addChild(endTimeBg)
    endTimeBg:setContentSize(CCSizeMake(width, size.height))
    endTimeBg:setPosition(ccp(10 + width / 2, size.height))
    local y, m, d, h, min, sec = ed.time2YMDHMS(endTime)
    local endTimeText = string.format(T("%s\230\156\136%s\230\151\165%s\230\151\182%s\229\136\134\231\187\147\230\157\159"), m, d, h, min)
    local endTimeLabel = CCLabelTTF:create(endTimeText, ed.font, 16)
    ed.setLabelColor(endTimeLabel, ed.toccc3(7405396))
    ed.setLabelStroke(endTimeLabel, ed.toccc3(1519903), 2)
    endTimeBg:addChild(endTimeLabel)
    ed.layout.centerInParent(endTimeLabel)
  end
  autoText.node:setPosition(ccp(10, height + size.height + gapY))
  tipsPanel.bg:setContentSize(CCSizeMake(width + 20, height + size.height + gapY + 20))
  local posY = tipsPanel.bg:getContentSize().height / 2
  if not direction then
    ed.layout.relateLayout(parent, tipsPanel.bg, {
      bottom = posY + 25
    })
    ed.layout.layoutWithMagin(tipsPanel.bg, {
      left = ed.display.getNotchHeight()
    })
  elseif direction == 1 then
    ed.layout.relateLayout(parent, tipsPanel.bg, {top = 25})
  elseif direction == 2 then
    ed.layout.relateLayout(parent, tipsPanel.bg, {
      bottom = posY + 25
    })
  elseif direction == 3 then
    ed.layout.relateLayout(parent, tipsPanel.bg, {left = 25})
  elseif direction == 4 then
    ed.layout.relateLayout(parent, tipsPanel.bg, {right = 25})
  end
  return tipsPanel
end
