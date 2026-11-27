local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.eula = class
local ed = ed
local eulaPanel
local pages = 0
local currentPage = 1
local textArray = {}
local msg
local currentIndex = 0
local currentEULAVersion = "vs.1"

function class.getEULAversion()
  return currentEULAVersion
end

local function release()
  eulaPanel = nil
end

local function getContentStr(data)
  local str = data
  return str
end

local function createText(i, res)
  local node = CCLayer:create()
  local title = ed.createLabelWithFontInfo(res.title or "", "op_act_title")
  local content = ed.createLabelWithFontInfo(getContentStr(res.content or ""), "normal_button")
  local title1 = ed.createLabelWithFontInfo(res.title1 or "", "op_act_title")
  local title2 = ed.createLabelWithFontInfo(res.title2 or "", "op_act_title")
  local content1 = ed.createLabelWithFontInfo(getContentStr(res.content1 or ""), "normal_button")
  local content2 = ed.createLabelWithFontInfo(getContentStr(res.content2 or ""), "normal_button")
  content:setDimensions(CCSizeMake(570, 0))
  content:setHorizontalAlignment(kCCTextAlignmentLeft)
  content:setAnchorPoint(ccp(0, 0))
  title:setAnchorPoint(ccp(0, 0))
  title1:setAnchorPoint(ccp(0, 0))
  content:setPosition(ccp(0, 0))
  content1:setDimensions(CCSizeMake(570, 0))
  content1:setHorizontalAlignment(kCCTextAlignmentLeft)
  content1:setAnchorPoint(ccp(0, 0))
  content2:setAnchorPoint(ccp(0, 0))
  content2:setDimensions(CCSizeMake(570, 0))
  content2:setHorizontalAlignment(kCCTextAlignmentLeft)
  title2:setAnchorPoint(ccp(0, 0))
  local area = content:getContentSize()
  title:setPosition(ccp(0, area.height + 15))
  if 8 == i or 17 == i then
    content1:setPosition(ccp(0, 0))
    local con1 = content1:getContentSize()
    title:setPosition(ccp(0, con1.height + 17))
    local tit = title:getContentSize()
    content:setPosition(ccp(0, con1.height + 17 + tit.height + 17))
    node:addChild(content1)
    node:addChild(title)
    node:addChild(content)
  elseif 10 == i or 14 == i then
    title:setPosition(ccp(0, 0))
    local tit = title:getContentSize()
    content:setPosition(ccp(0, tit.height + 14))
    node:addChild(title)
    node:addChild(content)
  elseif 13 == i then
    content1:setPosition(ccp(0, 0))
    local area = content1:getContentSize()
    title:setPosition(ccp(0, area.height + 17))
    local area1 = title:getContentSize()
    content:setPosition(ccp(0, area.height + 17 + area1.height + 17))
    node:addChild(content1)
    node:addChild(title)
    node:addChild(content)
  elseif 19 == i then
    content2:setPosition(ccp(0, 0))
    local con2 = content2:getContentSize()
    title1:setPosition(ccp(0, con2.height + 17))
    local tit1 = title1:getContentSize()
    content1:setPosition(ccp(0, con2.height + 17 + tit1.height + 17))
    local con1 = content1:getContentSize()
    title:setPosition(ccp(0, con2.height + 17 + tit1.height + 17 + con1.height))
    local tit = title:getContentSize()
    content:setPosition(ccp(0, con2.height + 17 + tit1.height + 17 + con1.height + tit.height + 17))
    node:addChild(title)
    node:addChild(content)
    node:addChild(content2)
    node:addChild(title1)
    node:addChild(content1)
  elseif 20 == i then
    title2:setPosition(ccp(300, 30))
    title2:setHorizontalAlignment(kCCTextAlignmentRight)
    local tit2 = title2:getContentSize()
    content1:setPosition(ccp(0, tit2.height + 47))
    local cont1 = content1:getContentSize()
    title1:setPosition(ccp(0, tit2.height + 43 + cont1.height + 17))
    local tit1 = title1:getContentSize()
    content:setPosition(ccp(0, tit1.height + 47 + tit2.height + 17 + cont1.height))
    local cont = content:getContentSize()
    title:setPosition(ccp(0, cont.height + 47 + tit1.height + 17 + cont1.height + tit2.height + 17))
    node:addChild(title)
    node:addChild(content)
    node:addChild(title1)
    node:addChild(content1)
    node:addChild(title2)
  else
    node:addChild(title)
    node:addChild(content)
  end
  if class.isSpecailEULA() and i == 2 then
    content:setPosition(ccp(0, 120))
  end
  node:setPosition(ccp(123, 120))
  return node
end

local function createTexts()
  local res = EDTables.eulaConfig.ContentRes
  pages = #res
  textArray[1] = createText(1, res[1])
end

local function setCurrentPage()
  ed.setString(eulaPanel.pages, string.format("\194\183 %d/%d \194\183", currentPage, pages))
end

function class.nextClick()
  if currentPage < pages then
    eulaPanel:getRootLayer():removeChildByTag(1, true)
    currentPage = currentPage + 1
    setCurrentPage()
    eulaPanel:getRootLayer():addChild(createText(currentPage, EDTables.eulaConfig.ContentRes[currentPage]), 0, 1)
  end
end

function class.frontClick()
  if 1 < currentPage then
    eulaPanel:getRootLayer():removeChildByTag(1, false)
    currentPage = currentPage - 1
    setCurrentPage()
    eulaPanel:getRootLayer():addChild(createText(currentPage, EDTables.eulaConfig.ContentRes[currentPage]), 0, 1)
  end
end

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function createIndex()
  if not eulaPanel then
    return
  end
  eulaPanel.ListView:changeItemConfig(1)
  local res = EDTables.overSeaConfig.ContentRes
  for k = 1, 2 do
    currentIndex = currentIndex + 1
    if currentIndex > #res then
      return
    end
    eulaPanel.ListView:addItem({
      res[currentIndex].title,
      res[currentIndex].content
    })
  end
end

local function createListText()
  local res = EDTables.overSeaConfig.TitleRes
  for k, v in pairs(res) do
    eulaPanel.ListView:addItem({
      v.title
    })
  end
  createIndex()
  ListenTimer(Timer:Times(0.1, 20), createIndex)
end

function class.initSpecialUI()
  if class.isSpecailEULA() and eulaPanel then
    eulaPanel.goto1:setPosition(ccp(290, 38))
    eulaPanel.select_frame:setVisible(true)
    eulaPanel.notshow:setVisible(true)
    eulaPanel.exit:setVisible(true)
    eulaPanel.title:setString(T("\230\184\169\233\166\168\230\143\144\231\164\186"))
    EDTables.eulaConfig.ContentRes = EDTables.eulaConfig.ContentResSpecial
  end
end

function class.isSpecailEULA()
  return false
end

function class.create(data)
  msg = data
  local currentScene = getRunScene()
  if nil == eulaPanel then
    if resource_config.overseaEULA then
      eulaPanel = panelMeta:new2(class, EDTables.overSeaConfig.UIRes)
      createListText()
      if currentScene then
        currentScene:addChild(eulaPanel:getRootLayer(), 500)
      end
    else
      eulaPanel = panelMeta:new2(class, EDTables.eulaConfig.UIRes)
      eulaPanel.exit:setVisible(false)
      class.initSpecialUI()
      createTexts()
      if currentScene then
        eulaPanel:getRootLayer():addChild(textArray[currentPage], 0, 1)
        currentScene:addChild(eulaPanel:getRootLayer(), 500)
        setCurrentPage()
      end
    end
  end
end

function class.notshowFun()
  if not class.isSpecailEULA() then
    return
  end
  if not class.notshow then
    eulaPanel.select_frame1:setVisible(true)
    class.notshow = true
  else
    eulaPanel.select_frame1:setVisible(false)
    class.notshow = false
  end
end

function class.exitGame()
  print("--------------->exitGame")
  EDExit()
end

function class.joinGame()
  if nil == eulaPanel then
    return
  end
  local currentuser = "EULA" .. ed.getDeviceId()
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(eulaPanel:getRootLayer(), true)
    release()
  end
  if ed.netreply.loginReply then
    ed.netreply.loginReply()
    ed.netreply.loginReply = nil
  end
  FireEvent("LoginSuc", msg._login_reply._rt_lobby_addr)
end
