local base = ed.ui.popwindow
local achPagePointPop = newclass(base.mt)
ed.ui.achPagePointPop = achPagePointPop
local listItems = {}
achPagePointPop.listItems = listItems
ed.UITool.registViewOpenFunc("achPagePointPop", function(param)
  ed.ui.achPagePointPop.create(param or {}):popWindow()
end)

function achPagePointPop.create(param)
  return setmetatable(base.create("achPagePointPop"), achPagePointPop.mt):init(param or {})
end

function achPagePointPop:init()
  self:uiCreate()
  self:listCreate()
  self:registerEvents()
  self:registerBtnEvents()
  self:show({skipAnim = false})
  self.achData = ed.taskData:getPageDataObj("ach")
  return self.achData.achTitle and self:refreshpage("open_panel") or ed.taskNetwork:achievementPush(self)
end

function achPagePointPop:registerEvents()
  self:listenEvent("achTaskReply", function(refreshType)
    self:refreshpage(refreshType)
  end)
end

function achPagePointPop:refreshpage(refreshType)
  if refreshType == "open_panel" then
    local achTitle = self.achData.achTitle or {}
    local point = achTitle.point or 0
    self.ui.label_num:setString(point)
    self:refreshList(self.achData:getPointListItems())
  end
  return self
end

function achPagePointPop:uiCreate()
  self.frame, self.ui = ed.editorui(ed.uieditor.achTaskLayePop)
  self.container:addChild(self.frame)
  self.ui.label_num:setStroke(ccc3(ed.colorToStr("#272524")), 1)
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(5780269), 1)
  self.ui.label_tips:limitWidthByScale(self.ui.Label_506:getPositionX() - self.ui.Label_506:getContentSize().width - self.ui.label_tips:getPositionX() - 10)
  self.index = 1
end

function achPagePointPop:listCreate()
  local thisCon = self.ui.ph_list_pos:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.ph_list_pos,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end
  }
  self.draglist = ed.draglist.create(info)
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
end

function achPagePointPop:refreshList(listData)
  if self.allItems then
    for i, v in ipairs(listData) do
      if self.allItems[v.id] then
        self.allItems[v.id]:refresh(v)
      end
    end
  else
    self.allItems = {}
    for i, v in ipairs(listData) do
      local item = listItems.new(self, v)
      self.draglist:addItem(item.layer, ccp(self.draglist.cliprect.size.width / 2, self.draglist.cliprect.size.height - i * 84 + 41))
      self.allItems[v.id] = item
    end
    self.draglist:initListHeight(#self.draglist.listItems * 84)
  end
end

function achPagePointPop:registerBtnEvents()
  local index = 1
  
  local function func(node, click, press, normal)
    self:btRemoveMainTouchHandler({
      key = "achPagePointPop_" .. index
    })
    self:btRegisterButtonClick({
      button = node,
      key = "achPagePointPop_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_close, function()
    self:destroy({skipAnim = false})
  end, 0.85, 0.9)
  self:btRegisterOutClick({
    area = self.ui.ImageView_504,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end

local function btRegisterButtonClickToListItems()
  return function(self, param)
    self:btRemoveMainTouchHandler({
      key = "ach_page_point_items" .. self.index
    })
    self:btRegisterButtonClick({
      button = param.button,
      key = "ach_page_point_items" .. self.index,
      radioGroupName = "items",
      param = param,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.ph_list_pos, x, y) then
          print("not list pos")
          return
        end
        if self.touch then
          local data = param.data or {}
          ed.ui.packageDetailWin.create(data):popWindow()
        end
      end,
      force = true,
      pressScale = 0.75,
      normalScale = 0.8
    })
    self.index = self.index + 1
  end
end

achPagePointPop.btRegisterButtonClickToListItems = btRegisterButtonClickToListItems()
listItems.size = {width = false, height = false}
listItems.uiInfo = {
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_item_bg2.png",
        capInsets = CCRectMake(14, 16, 50, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(551, 82)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "numBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_numbg_img2.png"
      },
      layout = {
        position = ccp(-200, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "icon",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_icon_img.png"
      },
      layout = {
        position = ccp(-235, -2)
      }
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        text = T("\232\190\190\230\136\144"),
        size = 18
      },
      layout = {
        position = ccp(-222, 0),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ed.toccc3(2565412),
          size = 0.7
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "proStrNum",
        text = "210",
        size = 20
      },
      layout = {
        position = ccp(-184, 0),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ed.toccc3(2565412),
          size = 0.7
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "progressBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_progress_2.png"
      },
      layout = {
        position = ccp(185, 0)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "progressImg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_progress_1.png",
        capInsets = CCRectMake(10, 1, 133, 1)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(108.5, 0)
      },
      config = {
        scaleSize = CCSizeMake(153, 21),
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "proTopStr",
        text = "110/220",
        size = 18
      },
      layout = {
        position = ccp(185, 0),
        anchor = ccp(0.5, 0.5)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ed.toccc3(3419947),
          size = 0.8
        }
      }
    }
  },
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_item_bg1.png",
        capInsets = CCRectMake(14, 16, 50, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(551, 82)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "numBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_numbg_img1.png"
      },
      layout = {
        position = ccp(-200, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "icon",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_icon_img.png"
      },
      layout = {
        position = ccp(-235, -2)
      }
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        text = T("\232\190\190\230\136\144"),
        size = 18
      },
      layout = {
        position = ccp(-222, 0),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16772964),
        stroke = {
          color = ed.toccc3(1052688),
          size = 0.7
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "proStrNum",
        text = "210",
        size = 20
      },
      layout = {
        position = ccp(-184, 0),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16772964),
        stroke = {
          color = ed.toccc3(1052688),
          size = 0.7
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "btn",
        res = "UI/alpha/1080P/common/button_com_big.png"
      },
      layout = {
        position = ccp(185, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "btnStr",
        text = T("\233\162\134\229\143\150"),
        parent = "btn",
        size = 22
      },
      layout = {
        position = ccp(62.5, 26),
        anchor = ccp(0.5, 0.5)
      },
      config = {
        color = ed.toccc3(16510882),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }
  },
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_item_bg3.png",
        capInsets = CCRectMake(14, 16, 50, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(551, 82)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "numBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_numbg_img3.png"
      },
      layout = {
        position = ccp(-200, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "icon",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_icon_img.png"
      },
      layout = {
        position = ccp(-235, -2)
      }
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        text = T("\232\190\190\230\136\144"),
        size = 18
      },
      layout = {
        position = ccp(-222, 0),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ed.toccc3(1052688),
          size = 0.7
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "proStrNum",
        text = "210",
        size = 20
      },
      layout = {
        position = ccp(-184, 0),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ed.toccc3(1052688),
          size = 0.7
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "btnGrey",
        res = "UI/alpha/1080P/common/button_com_big.png"
      },
      layout = {
        position = ccp(185, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "btnStr",
        text = T("\229\183\178\233\162\134\229\143\150"),
        parent = "btnGrey",
        size = 22
      },
      layout = {
        position = ccp(62.5, 26),
        anchor = ccp(0.5, 0.5)
      },
      config = {
        color = ed.toccc3(16645351),
        stroke = {
          color = ed.toccc3(3946811),
          size = 0.7
        }
      }
    }
  }
}

function listItems.new(sceneSelf, param)
  return setmetatable({
    sceneSelf = sceneSelf,
    layer = CCLayer:create(),
    param = param
  }, {__index = listItems}):create()
end

function listItems:create()
  local param = self.param or {}
  self.layerBj = CCLayer:create()
  self.layer:addChild(self.layerBj)
  self.layerItem = CCLayer:create()
  self.layer:addChild(self.layerItem, 9)
  self.items = {}
  self.itemInfo = param.item or {}
  if param.item and #param.item > 0 then
    for i, v in ipairs(param.item) do
      local item = ed.taskItemModule.new(self.sceneSelf, v, 1, i, false, false, true)
      if item.icon then
        item.icon:setPosition(ccp(i * 55 - 70, 0))
        self.layerItem:addChild(item.icon)
      end
      table.insert(self.items, item)
    end
  end
  self:refresh(param)
  return self
end

function listItems.getShowType(param)
  if param.isPass then
    return 3
  else
    return (param.newPoint or 0) >= (param.point or -1) and 2 or 1
  end
end

function listItems:refresh(param)
  local refreshType = self.getShowType(param)
  if refreshType == (self.refreshType or 0) then
    if refreshType == 2 and param.progress ~= self.param.progress then
      local per = param.newPoint / param.point
      self.progressMode:addPro(per)
      self.param = param
    end
    return
  end
  self.refreshType = refreshType
  self.param = param
  for i, v in ipairs(self.items or {}) do
    v:refresh(self.refreshType - 1)
  end
  self.layerBj:removeAllChildrenWithCleanup(true)
  local container, ui = ed.editorui(self.uiInfo[self.refreshType])
  self.layerBj:addChild(container)
  self.ui = ui
  if ui.progressImg then
    local per = self.param.newPoint / self.param.point
    if not self.progressMode then
      self.progressMode = ed.taskProModule.new(ui.progressImg, 25)
      self.progressMode:addPro(per)
    else
      self.progressMode:addPro(per)
    end
  else
    self.progressMode = nil
  end
  ui.proStrNum:setString(self.param.point or 0)
  local totalWidth = ui.proStr:getContentSize().width + ui.proStrNum:getContentSize().width + 2
  local limitWidth = ui.numBg:getPositionX() + ui.numBg:getContentSize().width * 0.5 - ui.proStr:getPositionX()
  local scale = 1
  if totalWidth > limitWidth then
    scale = limitWidth / totalWidth
  end
  ui.proStr:setScale(scale)
  ui.proStrNum:setScale(scale)
  ui.proStrNum:setPositionX(ui.proStr:getPositionX() + ui.proStr:getContentSize().width * scale + 2 * scale)
  if ui.proTopStr then
    local newPro = self.param.newPoint >= self.param.point and self.param.point or self.param.newPoint
    ui.proTopStr:setString(newPro .. "/" .. self.param.point)
  end
  if ui.btnGrey then
    EDLoadShader("GrayScalingShader_2")
    ed.setSpriteShader(ui.btnGrey, "GrayScalingShader_2")
  end
  if ui.btn then
    self.sceneSelf:btRemoveMainTouchHandler({
      key = "btn_" .. self.param.id
    })
    self.sceneSelf:btRegisterButtonClick({
      button = ui.btn,
      key = "btn_" .. self.param.id,
      param = self.param,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.sceneSelf.ui.ph_list_pos, x, y) then
          return
        end
        
        local function func(param)
          return function()
            ed.taskNetwork:requirePointRewards(param.id)
          end
        end
        
        local push = func(param)
        local geftItem, exceedItem, giveItemAll = ed.itemExceeds(self.itemInfo or {})
        self.sceneSelf.achData.giveItemAll = ed.copyProto(giveItemAll)
        if 0 < #exceedItem then
          ed.ui.maillocalbox.create({
            type = "deleItem",
            tag = 2,
            item = exceedItem,
            clickGeft = function()
              push()
            end,
            clickBack = function()
            end,
            str = T("\233\131\168\229\136\134\229\165\150\229\138\177\231\137\169\229\147\129\233\162\134\229\143\150\229\144\142\229\176\134\232\182\133\229\135\186\228\184\138\233\153\144\239\188\140\229\187\186\232\174\174\230\184\133\231\144\134\232\131\140\229\140\133\229\144\142\229\134\141\230\157\165\233\162\134\229\143\150\227\128\130(\229\188\186\232\161\140\233\162\134\229\143\150\229\176\134<lable color=mailRed>\230\184\133\233\153\164</lable>\232\182\133\228\184\138\233\153\144\233\131\168\229\136\134)<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
            btnStr = T("\229\143\150\230\182\136")
          }):popWindow()
        else
          push()
        end
      end,
      force = true,
      pressScale = 0.9,
      normalScale = 1,
      clickInterval = 1
    })
  end
end
