local class = newclass("g")
MultiTouches = class

local function setMultiTouchesScale(params)
  params = params or {}
  local node = params.node
  local minScale = params.minScale
  local maxScale = params.maxScale
  local layer = CCLayer:create()
  local ori_ds, ori_scale
  layer:setTouchEnabled(true)
  layer:registerScriptTouchHandler(function(event, touches)
    xpcall(function()
      if event == "began" then
        ori_ds = nil
        ori_scale = node:getScale()
      elseif event == "moved" then
        if not touches[4] then
          return
        end
        local x1, y1, x2, y2 = touches[1], touches[2], touches[3], touches[4]
        local ds = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
        if ori_ds then
          local scale = ori_scale * ds / ori_ds
          if minScale then
            scale = math.max(minScale, scale)
          end
          if maxScale then
            scale = math.min(maxScale, scale)
          end
          node:setScale(scale)
        else
          ori_ds = ds
        end
      elseif event == "ended" then
      end
    end, EDDebug)
    return true
  end, true, -3000, false)
  node:addChild(layer)
end

class.setMultiTouchesScale = setMultiTouchesScale
