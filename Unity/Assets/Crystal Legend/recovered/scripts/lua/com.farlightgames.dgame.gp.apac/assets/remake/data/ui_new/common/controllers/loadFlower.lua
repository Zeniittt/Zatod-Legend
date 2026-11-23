local LoadFlower = {}
LoadFlower.__index = LoadFlower
ed.ui.LoadFlower = LoadFlower
local loadLayer = {}

local function doTouchLoad()
  return true
end

function LoadFlower:load(noflower)
  local struct = loadLayer
  local count = 0
  local countRotate = 0
  local count_gap = 0.1
  local isLoading
  
  local function createFlower()
    local scene = CCDirector:sharedDirector():getRunningScene()
    if struct.layer then
      if 0.5 < count then
        struct.flowerbg:setVisible(true)
        isLoading = true
      end
      return
    end
    local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(doTouchLoad, false, -900, true)
    scene:addChild(layer, 600)
    struct.layer = layer
    if struct.flower then
      return true
    end
    local bg = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = "UI/alpha/1080P/common/mail_bj9_1.png",
        capInsets = CCRectMake(15, 15, 15, 191.5)
      },
      layout = {
        position = ccp(ed.display.center.x, ed.display.center.y)
      },
      config = {visible = false}
    }, layer, 9)
    struct.flowerbg = bg
    struct.flower = ed.createNode({
      t = "Sprite",
      base = {
        res = "installer/load_flower.png"
      },
      layout = {
        position = ccp(25, 30)
      }
    }, bg)
    local text = ed.createNode({
      t = "Label",
      base = {
        text = T("\232\191\158\230\142\165\228\184\173..."),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.getRightSidePos(struct.flower, 5)
      }
    }, bg)
    bg:setContentSize(CCSizeMake(struct.flower:getContentSize().width + text:getContentSize().width + 35, 60))
  end
  
  local function handler(dt)
    if noflower then
      return
    end
    count = count + dt
    countRotate = countRotate + dt
    createFlower()
    if struct.layer then
      if countRotate > count_gap then
        local flower = struct.flower
        if flower then
          flower:setRotation((flower:getRotation() + 30) % 360)
        end
        countRotate = countRotate - count_gap
      end
      return
    end
  end
  
  return handler
end

function LoadFlower:loadBegin(noflower)
  self:loadEnd()
  local struct = loadLayer
  local loading = self:load(noflower)
  local scene = CCDirector:sharedDirector():getRunningScene()
  if not tolua.isnull(scene) then
    struct.scheduler = scene:getScheduler()
    struct.id = struct.scheduler:scheduleScriptFunc(loading, 0, false)
  end
end

function LoadFlower:loadEnd()
  local layer = loadLayer
  if layer.id then
    layer.scheduler:unscheduleScriptEntry(layer.id)
    layer.id = nil
  end
  if layer.layer then
    layer.layer:removeFromParentAndCleanup(true)
  end
  loadLayer = {}
end
