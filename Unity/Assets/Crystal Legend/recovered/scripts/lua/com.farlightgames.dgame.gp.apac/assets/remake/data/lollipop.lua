SHOW_MEMORY_STATE = false
ENABLE_RELOAD_BUTTON = false
local warcollege_list = {
  "ui/herodetail/window",
  "ui/herodetail/book",
  "ui/herodetail/attributes",
  "ui/warworkshop/warcollege",
  "ui/warworkshop/collegenet",
  "ui/warworkshop/collegeconnect",
  "ui/warworkshop/booklist",
  "ui/warworkshop/screening",
  "ui/warworkshop/warworkshop",
  "ui/stonedetail",
  "ui/popwindow/popwindow",
  "ui/basescene",
  "ui/readequip",
  "ui/popwindow/configure",
  "ui/draglist",
  "ui/readnode",
  "ui/equipcraft",
  "ui/readequip",
  "ui/stagedetail",
  "ui/uieditor/equipdisassemble",
  "ui/buildingupgradebar",
  "ui/fragmentcompose",
  "ui/fragmentGuide",
  "ui/readequip",
  "ui/warworkshop/warterritorymain",
  "ui/parameter/collegeres",
  "ui/warworkshop/readinghouse",
  "ui/warworkshop/readinghousenet",
  "ui/popwindow/warbuildingupgrade",
  "ui/warworkshop/readexpexplain",
  "ui/popwindow/warbuildingfinish",
  "ui/warworkshop/warworkshop",
  "ui/popwindow/finishupgrade",
  "ui/readhero",
  "ui/popwindow/finishbook"
}
local rewardoffer_list = {
  "ui/warworkshop/rewardoffer/rewardoffer"
}

function doReload()
  package.loaded.lollipop = nil
  require("lollipop")
  local list = rewardoffer_list
  for i, v in ipairs(list) do
    package.loaded[v] = nil
    require(v)
  end
end

if SHOW_MEMORY_STATE then
  local usePercent, totalPhys, availPhys, totalPage, availPage, totalVirtual, availVirtual = EDGetMemoryState()
  ori_avail_phys = ori_avail_phys or availPhys
  
  function getUsedMemory()
    local usePercent, totalPhys, availPhys, totalPage, availPage, totalVirtual, availVirtual = EDGetMemoryState()
    return ori_avail_phys - availPhys
  end
end
if ENABLE_RELOAD_BUTTON then
  function addReloadButton(scene)
    local l, r, t, b = ed.getDisplayVertex()
    
    local layer = CCLayer:create()
    local button = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/observe_hire_1.png"
      },
      layout = {
        anchor = ccp(1, 0),
        position = ccp(r, b)
      }
    }, layer)
    local press = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/observe_hire_2.png"
      },
      layout = {
        position = ed.getCenterPos(button)
      },
      config = {visible = false}
    }, button)
    local isPress
    layer:registerScriptTouchHandler(function(event, x, y)
      if tolua.isnull(button) then
        return false
      end
      if event == "began" then
        isPress = nil
        if ed.containsPoint(button, x, y) then
          press:setVisible(true)
          isPress = true
        else
          return false
        end
      elseif event == "ended" and isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          doReload()
          doReload()
          print("<log>reload done.")
        end
      end
      return true
    end, false, -5000, true)
    layer:setTouchEnabled(true)
    scene:addChild(layer, 5000)
  end
end
