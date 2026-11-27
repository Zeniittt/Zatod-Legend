module("ed.herorecommend", package.seeall)
tag = {}
tag.__index = tag

function tag.create(data)
  local object = {}
  setmetatable(object, tag)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function tag:initData(data)
  self.tagTable = ed.getDataTable("RecommendTag")
  self.tagid = data.tagid
  self.window = data.window
end

function tag:initAppearence()
  local container = ed.createSprite("UI/alpha/HVGA/hero_recommend/hero_recommend_bg_tag.png")
  local tagData = self.tagTable[self.tagid]
  local trophyRes = tagData["Tag Trophy"]
  local Iconres = tagData["Tag Icon"]
  local titleres = tagData["Tag title"]
  local trophySprite = ed.createSprite(trophyRes)
  local tagSprite = ed.createSprite(Iconres)
  local tagTitle = ed.createSprite(titleres)
  trophySprite:setPosition(ccp(40, 45))
  tagSprite:setPosition(ccp(40, 50))
  tagTitle:setPosition(ccp(40, 95))
  container:addChild(trophySprite)
  container:addChild(tagSprite)
  container:addChild(tagTitle)
  self.container = container
  self.tagSprite = tagSprite
end

function tag:registerTouchHandler()
  local isPress = false
  self.window.touch_node:btRegisterMainTouchHandler({
    key = "clicktag" .. self.tagid,
    handler = function(event, x, y)
      if tolua.isnull(self.tagSprite) then
        return false
      end
      if event == "began" then
        isPress = nil
        if ed.checkVisible(self.tagSprite) and ed.containsPoint(self.tagSprite, x, y) then
          isPress = true
          self:createPrompt(x, y)
          return true
        else
          return false
        end
      elseif event == "ended" and isPress then
        self:destroyPrompt()
        return true
      end
      return false
    end
  })
end

function tag:createPrompt(x, y)
  self:destroyPrompt()
  local bgWidth = 240
  local bgHeight = 120
  local popNode = self:createPromptNode(bgWidth, bgHeight)
  local px = x - 120
  local py = y + 100
  if 460 < py then
    py = 460
  end
  popNode:setPosition(ccp(px, py))
  self.window.mainLayer:addChild(popNode, 5000)
  self.popContainer = popNode
end

function tag:createPromptNode(bgWidth, bgHeight)
  local tagData = self.tagTable[self.tagid]
  local text = tagData["Tag Des Detail"]
  local textLen = string.len(text)
  local bgNode = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      capInsets = CCRectMake(15, 20, 45, 15)
    },
    layout = {
      anchor = ccp(0, 1)
    },
    config = {
      scaleSize = CCSizeMake(bgWidth, bgHeight)
    }
  })
  local TrophySprite = ed.createNode({
    t = "Sprite",
    base = {
      res = tagData["Tag Trophy"]
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, bgHeight - 30)
    },
    config = {scale = 0.5}
  }, bgNode)
  TrophySprite:setScale(0.7)
  local titleSprite = ed.createNode({
    t = "Sprite",
    base = {
      res = tagData["Tag Icon"]
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, bgHeight - 25)
    },
    config = {scale = 0.5}
  }, bgNode)
  titleSprite:setScale(0.7)
  ed.createNode({
    t = "Label",
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80, bgHeight - 20)
    },
    base = {
      text = tagData["Tag Des"],
      size = 18
    },
    config = {
      color = ccc3(255, 255, 255)
    }
  }, bgNode)
  ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/act/act_comment_bg.png",
      capInsets = CCRectMake(18, 10, 45, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(bgWidth / 2, bgHeight / 4 + 5)
    },
    config = {
      scaleSize = CCSizeMake(bgWidth - 5, bgHeight / 2 - 10)
    }
  }, bgNode)
  local py = 28
  if 39 < textLen then
    py = 20
  end
  ed.createNode({
    t = "Label",
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17, py)
    },
    base = {text = text, size = 16},
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      dimensions = CCSizeMake(bgWidth - 30, 0),
      color = ccc3(243, 191, 113)
    }
  }, bgNode)
  return bgNode
end

function tag:destroyPrompt()
  if self.popContainer then
    self.popContainer:removeFromParentAndCleanup(true)
    self.popContainer = nil
  end
end
