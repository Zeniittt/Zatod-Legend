local items = {}

function items.new(pgSelf, param, level, index, isAdvanced, isbox, notLock)
  return setmetatable({
    sceneSelf = pgSelf,
    param = param,
    level = level,
    index = index,
    isAdvanced = isAdvanced,
    isbox = isbox,
    lockVis = not notLock
  }, {__index = items}):create()
end

function items:create()
  local function func(res, pos, scale, parent)
    local sprite = ed.createSprite(res)
    
    sprite:setPosition(pos)
    sprite:setScale(scale or 1)
    parent:addChild(sprite, 99)
    return sprite
  end
  
  self.icon = ed.createItemIcon(self.param)
  self.lock = func("UI/alpha/1080P/common/pvp_battle_lock.png", ccp(75, 75), 1.3, self.icon)
  self.effs = func("UI/alpha/1080P/taskModel/player_award_list_item_eff.png", ccp(45, 45), 1, self.icon)
  self.effs:setRotation(math.random(1, 360))
  local category = ed.readequip.value(self.param.id, "Category")
  local isStone = category == T("\231\129\181\233\173\130\231\159\179") or category == T("\231\162\142\231\137\135")
  local frameMask = string.format("UI/alpha/1080P/common/frame/%s.png", isStone and "fragment_stencil" or "equip_frame_mask")
  self.pass = func(self.param.passRes or "UI/alpha/1080P/package/selected.png", ccp(45, 45), 0.9, func(frameMask, ccp(45, 45), 1, self.icon)):getParent()
  self.icon:setScale(0.8)
  if self.sceneSelf.btRegisterButtonClickToListItems then
    self.sceneSelf:btRegisterButtonClickToListItems({
      button = self.icon,
      data = self.param,
      level = self.level,
      index = self.index,
      isAdvanced = self.isAdvanced,
      isbox = self.isbox
    })
  end
  return self
end

function items:refresh(type)
  type = type or 0
  self.param.state = type
  self.lock:setVisible(self.lockVis and type == 0)
  self.effs:setVisible(type == 1)
  self.pass:setVisible(type == 2)
  if self.effs:isVisible() then
    self.effs:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  else
    self.effs:stopAllActions()
  end
  return type == 1
end

ed.taskItemModule = items
local progress = {}

function progress.new(node, minwid, bardeco, speed, min)
  return setmetatable({
    progress = node,
    minwid = minwid,
    bardeco = bardeco,
    speed = speed,
    min = min
  }, {__index = progress}):create()
end

function progress:create()
  self.widthMax = self.progress:getContentSize().width
  self.height = self.progress:getContentSize().height
  self.progress:setContentSize(CCSizeMake(self.minwid or 1, self.height))
  self.pro = 0
  self.proTabs = {}
  self.upPs = self.widthMax / (self.speed or 170)
  return self
end

function progress:addPro(pro, notClamp)
  if not notClamp then
    pro = ed.clamp(pro, self.min or 0.03, 1)
  end
  table.insert(self.proTabs, pro)
  if not self.toWidth then
    self:refresh(table.remove(self.proTabs, 1))
  end
end

function progress:setPro(pro)
  self.progress:setVisible(pro and 0 < pro)
  pro = ed.clamp(pro, self.min or 0.03, 1)
  self.progress:setContentSize(CCSizeMake(self.widthMax * pro, self.height))
  if self.bardeco then
    self.bardeco:setPositionX(self.widthMax * pro)
  end
  self.pro = pro
end

function progress:refresh(pro)
  if not self.progress or tolua.isnull(self.progress) then
    print("progress : invalid node")
    return
  end
  self.progress:setVisible(pro and 0 < pro)
  pro = pro or 0
  if pro < self.pro then
    self.toWidth = self.widthMax
  else
    self.toWidth = self.widthMax * pro
  end
  self.two = pro < self.pro
  self.pro = pro
  local initWid = self.progress:getContentSize().width
  initWid = math.floor(initWid / self.upPs) * self.upPs
  self.progress:setContentSize(CCSizeMake(initWid, self.height))
  self.progress:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCDelayTime:create(0.01), CCCallFunc:create(function()
    local width = self.progress:getContentSize().width + self.upPs
    if width >= self.toWidth then
      if self.two then
        self.progress:setVisible(false)
        self.progress:setContentSize(CCSizeMake(self.minwid or self.upPs, self.height))
        if self.bardeco then
          self.bardeco:setPositionX(self.minwid or self.upPs)
        end
        self.toWidth = self.widthMax * self.pro
        self.two = false
      elseif self.proTabs[1] then
        self:refresh(table.remove(self.proTabs, 1))
      else
        self.toWidth = nil
        self.progress:stopAllActions()
        if self.actionsFinishFun then
          self:actionsFinishFun()
        end
      end
    else
      self.progress:setVisible(true)
      self.progress:setContentSize(CCSizeMake(width, self.height))
      if self.bardeco then
        self.bardeco:setPositionX(width)
      end
    end
    self.width = width
    if self.updateFun then
      self:updateFun()
    end
  end)))))
end

ed.taskProModule = progress
local task_ui_info = {
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_item_bj_2.png",
        capInsets = CCRectMake(250, 10, 276.5, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(776.5, 70.5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "progressBg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_1.png"
      },
      layout = {
        position = ccp(-260, -23)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_line_a_img.png"
      },
      layout = {
        position = ccp(-290, 5)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "progressImg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_2.png",
        capInsets = CCRectMake(5, 1, 180, 1)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(-355.75, -23)
      },
      config = {
        scaleSize = CCSizeMake(191.5, 9.5),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        text = "9/9",
        size = 13
      },
      layout = {
        position = ccp(-260, -23)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ccc3(0, 0, 0),
          size = 0.7
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "buttonImg",
        res = "UI/alpha/1080P/common/button_com_sys.png",
        capInsets = CCRectMake(35, 15, 7.5, 5.5)
      },
      layout = {
        position = ccp(290, 0)
      },
      config = {
        scaleSize = CCSizeMake(100, 40)
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\229\137\141\229\190\128"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 21)
      },
      config = {
        color = ccc3(33, 33, 38),
        opacity = 255,
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\229\137\141\229\190\128"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 22)
      },
      config = {
        color = ccc3(254, 252, 219),
        opacity = 255,
        visible = true
      }
    }
  },
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_item_bj_3.png",
        capInsets = CCRectMake(250, 10, 276.5, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(776.5, 70.5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "progressBg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_1.png"
      },
      layout = {
        position = ccp(-260, -23)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_line_a_img.png"
      },
      layout = {
        position = ccp(-290, 5)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "progressImg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_2.png",
        capInsets = CCRectMake(5, 1, 180, 1)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(-355.75, -23)
      },
      config = {
        scaleSize = CCSizeMake(191.5, 9.5),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        text = "9/9",
        size = 13
      },
      layout = {
        position = ccp(-260, -23)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ccc3(0, 0, 0),
          size = 0.7
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buttonImg",
        res = "UI/alpha/1080P/taskModel/day_task/daily_task_pass.png"
      },
      layout = {
        position = ccp(290, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\229\183\178\229\174\140\230\136\144"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 30)
      },
      config = {
        color = ccc3(111, 94, 71),
        opacity = 255,
        visible = true
      }
    }
  },
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_item_bj_1.png",
        capInsets = CCRectMake(250, 10, 276.5, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(776.5, 70.5)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "progressBg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_3.png"
      },
      layout = {
        position = ccp(-260, -23)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_line_a_img.png"
      },
      layout = {
        position = ccp(-290, 5)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "progressImg",
        res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_4.png",
        capInsets = CCRectMake(5, 1, 180, 1)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(-355.75, -23)
      },
      config = {
        scaleSize = CCSizeMake(191.5, 9.5),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        text = "9/9",
        size = 13
      },
      layout = {
        position = ccp(-260, -23)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ccc3(0, 0, 0),
          size = 0.7
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buttonImg",
        res = "UI/alpha/1080P/common/button_com_mini.png"
      },
      layout = {
        position = ccp(290, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\233\162\134\229\143\150"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 21)
      },
      config = {
        color = ccc3(33, 33, 38),
        opacity = 255,
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\233\162\134\229\143\150"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 22)
      },
      config = {
        color = ccc3(254, 252, 219),
        opacity = 255,
        visible = true
      }
    }
  }
}
local cupTypeToAchView = {
  ["Diamond Cup"] = {
    completedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_diamond.png",
    uncompletedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_diamond.png",
    sealBg = "UI/alpha/1080P/taskModel/ach_task/ach_seal_diamond.png",
    sealTextColor = ed.toccc3(16709370),
    sealTimeColor = ed.toccc3(15979503),
    titleColor = ed.toccc3(16776423),
    titleStroke = ed.toccc3(8530036),
    achBannerEffect = "eff_UI_achievement_banner_zi"
  },
  ["Gold Cup"] = {
    completedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_gold.png",
    uncompletedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_undo_gold.png",
    sealBg = "UI/alpha/1080P/taskModel/ach_task/ach_seal_gold.png",
    sealTextColor = ed.toccc3(16776637),
    sealTimeColor = ed.toccc3(16177027),
    titleColor = ed.toccc3(16776423),
    titleStroke = ed.toccc3(6372363),
    achBannerEffect = "eff_UI_achievement_banner"
  },
  ["Silver Cup"] = {
    completedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_silver.png",
    uncompletedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_undo_silver.png",
    sealBg = "UI/alpha/1080P/taskModel/ach_task/ach_seal_silver.png",
    sealTextColor = ed.toccc3(15331327),
    sealTimeColor = ed.toccc3(12112874),
    titleColor = ed.toccc3(16776423),
    titleStroke = ed.toccc3(2109788),
    achBannerEffect = "eff_UI_achievement_banner_lan"
  },
  ["Copper Cup"] = {
    completedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_copper.png",
    uncompletedBg = "UI/alpha/1080P/taskModel/ach_task/ach_task_undo_copper.png",
    sealBg = "UI/alpha/1080P/taskModel/ach_task/ach_seal_copper.png",
    sealTextColor = ed.toccc3(16769989),
    sealTimeColor = ed.toccc3(15515544),
    titleColor = ed.toccc3(16776423),
    titleStroke = ed.toccc3(6633238),
    achBannerEffect = "eff_UI_achievement_banner_tu"
  }
}
ed.cupTypeToAchView = cupTypeToAchView
local listItemLay = {}

function listItemLay.new(sceneSelf, param, size)
  return setmetatable({
    sceneSelf = sceneSelf,
    layer = CCLayer:create(),
    param = param,
    size = size
  }, {__index = listItemLay}):create()
end

function listItemLay:create()
  local param = self.param or {}
  self.layer:setContentSize(CCSizeMake(1, 1))
  self.layerBj = CCLayer:create()
  self.layer:addChild(self.layerBj)
  self.layerItem = CCLayer:create()
  self.layer:addChild(self.layerItem, 9)
  local halfFixedWidth = self.size.halfFixedWidth or 0
  local label = ed.createttf(param.name or "nil", 16)
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(ccp(-355 - halfFixedWidth / 2, 18))
  label:setColor(ccc3(253, 239, 214))
  label:setStroke(ccc3(0, 0, 0), 1)
  self.layerItem:addChild(label)
  label = ed.createttf(param.detail or "nil", 14)
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(ccp(-355 - halfFixedWidth / 2, -6))
  label:setColor(ccc3(72, 56, 43))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  self.layerItem:addChild(label)
  self.detailLabel = label
  self.items = {}
  if param.reward and 0 < #param.reward then
    for i, v in ipairs(param.reward) do
      local item = items.new(self.sceneSelf, v, 1, i, false, false, true)
      if item.icon then
        item.icon:setPosition(ccp(i * 70 - 170, 0))
        self.layerItem:addChild(item.icon)
      end
      table.insert(self.items, item)
    end
  end
  self:refresh()
  return self
end

function listItemLay:getDetailLabelScale(adaptScale)
  local contentWidth = -140 - self.detailLabel:getPositionX()
  if contentWidth < self.detailLabel:getContentSize().width then
    return 0.75
  else
    return 1
  end
end

function listItemLay:adaptDetailLabelScale(adaptScale)
  local contentWidth = -140 - self.detailLabel:getPositionX()
  self.detailLabel:setScale(adaptScale)
  ed.setLabelDimensions(self.detailLabel, CCSizeMake(contentWidth / adaptScale, 0))
end

function listItemLay:refresh(param)
  if param and self.param then
    self.typeupdate = (param.refreshType or 0) == (self.param.refreshType or 1)
    if self.typeupdate and (param.progress or 0) == (self.param.progress or 1) then
      return
    end
  end
  self.param = param or self.param
  param = self.param or {}
  if param.isPass then
    param.progress = param.target
    param.refreshType = 2
  else
    param.refreshType = param.isCompleted and 3 or 1
  end
  self.layerBj:removeAllChildrenWithCleanup(true)
  local container, ui = ed.editorui(task_ui_info[param.refreshType])
  self.layerBj:addChild(container)
  self.ui = ui
  if self.size then
    self.ui.itemBg:setContentSize(CCSizeMake(self.size.width, self.size.height))
  end
  if self.size.halfFixedWidth then
    self:initWinsize(self.ui)
  end
  self.ui.proStr:setString(T("%d/%d", param.progress, param.target))
  local per = param.progress / param.target
  if not self.expProgressBox or not self.typeupdate then
    self.expProgressBox = progress.new(self.ui.progressImg)
    self.expProgressBox:setPro(per)
  else
    self.expProgressBox:addPro(per)
  end
  self.ui.progressImg:setVisible(0 < per)
  local typeToKey = {
    0,
    2,
    1
  }
  for i, v in ipairs(self.items or {}) do
    v:refresh(param.refreshType and typeToKey[param.refreshType] or 0)
  end
  local key = "day_list_btn_" .. (param.id or 1)
  if param.indexNum then
    key = "role_task_list_btn_" .. param.indexNum
  end
  param.sceneSelf = self.sceneSelf.sceneSelf
  if param.refreshType ~= 2 and self.ui.buttonImg then
    self.sceneSelf.sceneSelf:btRegisterButtonClick({
      button = self.ui.buttonImg,
      key = key,
      param = param,
      clickHandler = function(param, x, y)
        if self.sceneSelf.ui.panel_list_pos and not ed.containsPoint(self.sceneSelf.ui.panel_list_pos, x, y) then
          print("not list pos")
          return
        end
        if self.sceneSelf.ui.task_list_pos and not ed.containsPoint(self.sceneSelf.ui.task_list_pos, x, y) then
          print("not list pos")
          return
        end
        if not self.sceneSelf.touch then
          return
        end
        if param.refreshType == 1 then
          if param.fastEntry then
            param.fastEntry(param.sceneSelf)
          else
            print("error\226\128\157: jump not fastEntry ")
          end
        elseif param.refreshType == 3 then
          local overfull = {}
          for k, v in ipairs(param.reward) do
            if ed.player:isItemOverfull({
              id = v.id,
              type = v.type,
              amount = v.amount
            }) and v._type ~= "simple_chest" then
              table.insert(overfull, {
                id = v.id,
                amount = v.amount,
                kind = v.type,
                type = v.type
              })
            end
          end
          if 0 < #overfull then
            local panel = ed.ui.maillocalbox.create({
              type = "deleItem",
              tag = 2,
              btnStr = T("\229\143\150\230\182\136"),
              str = T("\229\165\150\229\138\177\228\184\173\229\144\171\230\156\137\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\228\184\138\233\153\144\231\154\132\231\137\169\229\147\129,\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=mailRed>\230\184\133\233\153\164</lable>\227\128\130<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
              item = overfull,
              clickGeft = function()
                self.sceneSelf:pushDailyjobReward(param)
              end,
              clickBack = function()
              end
            }):popWindow()
          else
            self.sceneSelf:pushDailyjobReward(param)
          end
        end
      end,
      force = true,
      pressScale = 0.9,
      normalScale = 1,
      clickInterval = 1
    })
  end
end

function listItemLay:initWinsize(ui)
  local newWid = self.size.halfFixedWidth or 0
  local newHei = 0
  
  local function posfunc(ui, isLeft, isDown)
    local newx, newy = isLeft and newWid / 2 * -1 or newWid / 2, isDown and newHei / 2 * -1 or newHei / 2
    local x, y = ui:getPosition()
    ui:setPosition(x + newx, y + newy)
  end
  
  posfunc(ui.progressBg, true)
  posfunc(ui.line, true)
  posfunc(ui.progressImg, true)
  posfunc(ui.proStr, true)
  posfunc(ui.buttonImg)
end

ed.taskListItemLayModule = listItemLay
local dayTaskBox = {
  res = {
    [0] = "day_task_box_img",
    [1] = "day_task_box_img",
    [2] = "day_task_box_open_img"
  },
  name_str = T("\230\175\143\230\151\165\228\187\187\229\138\161\229\174\157\231\174\177"),
  detail_str = T("\229\174\140\230\136\1446\228\184\170\230\175\143\230\151\165\228\187\187\229\138\161\229\141\179\229\143\175\233\162\134\229\143\150\227\128\130")
}

function dayTaskBox.new(sceneSelf, param, ui, size)
  return setmetatable({
    sceneSelf = sceneSelf,
    ui = ui,
    param = param,
    size = size
  }, {__index = dayTaskBox}):create()
end

function dayTaskBox:create()
  local param = self.param or {}
  self.ui.task_str1:setString(self.name_str or "nil")
  self.ui.image_tips:setPositionX(self.ui.task_str1:getPositionX() + self.ui.task_str1:getContentSize().width + 15)
  self.ui.task_str2:setString(self.detail_str or "nil")
  self.ui.task_str2:setColor(ccc3(72, 56, 43))
  self.ui.task_str2:limitWidthByScale(self.ui.item_pos:getPositionX() - self.ui.task_str2:getPositionX() - 40)
  ed.setLabelStroke(self.ui.task_str1, ccc3(ed.colorToStr("#272524")), 0.8)
  ed.setLabelStroke(self.ui.task_str3, ccc3(ed.colorToStr("#272524")), 0.7)
  self:refreshReward(param)
  self.sceneSelf.sceneSelf:btRegisterButtonClick({
    button = self.ui.image_tips,
    key = "day_task_image_tips",
    clickHandler = function(_, x, y)
      local tip, board = ed.showToast(T("\229\136\176\231\142\169\229\174\182\230\138\181\232\190\19060\231\186\167\239\188\140\230\175\143\230\151\165\229\174\157\231\174\177\229\176\134\233\162\157\229\164\150\228\186\167\229\135\186\230\136\152\233\152\159\231\187\143\233\170\140\229\165\150\229\138\177\227\128\130"), {
        maxWidth = 240,
        isAutoText = true,
        constant = 2
      })
      ed.layout.relateLayout(self.ui.image_tips, tip, {
        top = board:getContentSize().height / 2 + 15
      }, true)
    end,
    force = true,
    pressScale = 0.55,
    normalScale = 0.6
  })
  return self
end

function dayTaskBox:refresh(param, reward)
  self.param.day_job_num = param.finish_daily_job_num or 0
  self.param.day_job_num_max = param.finish_daily_job_num_max or 99
  self.param.toDayTaskPass = param.toDayTaskPass
  self.param.day_job_num = self.param.day_job_num > self.param.day_job_num_max and self.param.day_job_num_max or self.param.day_job_num
  self.ui.task_str3:setString(T("%d/%d", self.param.toDayTaskPass and self.param.day_job_num_max or self.param.day_job_num, self.param.day_job_num_max))
  local type = self.param.toDayTaskPass and 2 or self.param.day_job_num >= self.param.day_job_num_max and 1 or 0
  if self.oldType and self.oldType == type then
    return
  end
  self.oldType = type
  self:refreshReward({reward = reward})
  for k, v in pairs(self.items) do
    v:refresh(type)
  end
  ed.setTexture(self.ui.item_box_img, "UI/alpha/1080P/taskModel/day_task/" .. self.res[type] .. ".png")
  self.ui.item_box_img:stopAllActions()
  if type == 1 then
    self.ui.item_box_img:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCDelayTime:create(3), CCCallFunc:create(function()
      local posx, posy = self.ui.item_box_img:getPosition()
      self.ui.item_box_img:runAction(CCSequence:create(ccArrayMake(unpack({
        CCMoveTo:create(0.8, ccp(posx, posy + 7)),
        CCEaseElasticOut:create(CCMoveTo:create(0.9, ccp(posx, posy)))
      }))))
      self.ui.item_box_img:runAction(CCSequence:create(ccArrayMake(unpack({
        CCEaseBackIn:create(CCRotateBy:create(0.2, -10)),
        CCRotateBy:create(0.14, 20),
        CCRotateBy:create(0.13, -20),
        CCRotateBy:create(0.12, 15),
        CCRotateBy:create(0.11, -10),
        CCEaseBackOut:create(CCRotateBy:create(0.17, 5))
      }))))
    end)))))
  end
end

function dayTaskBox:refreshReward(param)
  self.ui.item_pos:removeAllChildrenWithCleanup(true)
  self.items = {}
  if param.reward and #param.reward > 0 then
    for i, v in ipairs(param.reward) do
      v.box = true
      local item = items.new(self.sceneSelf, v, 1, i, false, false, true)
      if item.icon then
        item.icon:setPosition(ccp(i * 70 - 76, self.size.height / 2 - 10))
        self.ui.item_pos:addChild(item.icon)
      end
      table.insert(self.items, item)
    end
  end
  self.sceneSelf.sceneSelf:btRegisterButtonClick({
    button = self.ui.item_box_img,
    key = "day_task_job_box_img",
    param = param,
    clickHandler = function(param, x, y)
      if not self.oldType or self.oldType ~= 1 then
        ed.showToast(T(self.oldType == 0 and T("\230\154\130\230\151\182\232\191\152\230\178\161\230\156\137\229\174\157\231\174\177\229\143\175\228\187\165\230\137\147\229\188\128") or T("\228\187\138\229\164\169\231\154\132\229\174\157\231\174\177\229\183\178\231\187\143\229\188\128\229\144\175\232\191\135\228\186\134")))
      elseif self.oldType == 1 then
        local overfull = {}
        for k, v in ipairs(param.reward) do
          if ed.player:isItemOverfull({
            id = v.id,
            type = v.type,
            amount = v.amount
          }) and v._type ~= "simple_chest" then
            table.insert(overfull, {
              id = v.id,
              amount = v.amount,
              kind = v.type,
              type = v.type
            })
          end
        end
        if 0 < #overfull then
          local panel = ed.ui.maillocalbox.create({
            type = "deleItem",
            tag = 2,
            btnStr = T("\229\143\150\230\182\136"),
            str = T("\229\165\150\229\138\177\228\184\173\229\144\171\230\156\137\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\228\184\138\233\153\144\231\154\132\231\137\169\229\147\129,\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=mailRed>\230\184\133\233\153\164</lable>\227\128\130<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
            item = overfull,
            clickGeft = function()
              self.sceneSelf:pushSendOpenChest()
            end,
            clickBack = function()
            end
          }):popWindow()
        else
          self.sceneSelf:pushSendOpenChest()
        end
      end
    end,
    force = true,
    pressScale = 0.9,
    normalScale = 1,
    clickInterval = 1
  })
end

ed.dayTaskBoxModule = dayTaskBox
local ach_ui_info = {
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_undo_copper.png",
        capInsets = CCRectMake(250, 10, 283, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(783, 97)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_line_2.png"
      },
      layout = {
        position = ccp(-290, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buttonImg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pro_img.png"
      },
      layout = {
        position = ccp(290, 0)
      },
      config = {opacity = 150}
    },
    {
      t = "Label",
      base = {
        name = "proStr",
        parent = "buttonImg",
        text = "9/9",
        size = 20
      },
      layout = {
        position = ccp(58, 15)
      },
      config = {
        color = ed.toccc3(16776423),
        stroke = {
          color = ccc3(0, 0, 0),
          size = 0.7
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "iconBg",
        res = "UI/alpha/1080P/common/frame/equip_frame_white.png"
      },
      layout = {
        position = ccp(-150, 0)
      }
    }
  },
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_copper.png",
        capInsets = CCRectMake(250, 10, 283, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(783, 97)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_line_1.png"
      },
      layout = {
        position = ccp(-290, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "iconBg",
        res = "UI/alpha/1080P/common/frame/equip_frame_white.png"
      },
      layout = {
        position = ccp(-150, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buttonImg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_seal_copper.png"
      },
      layout = {
        position = ccp(287, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\229\183\178\232\190\190\230\136\144"),
        size = 15
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(68, 39)
      },
      config = {
        color = ccc3(253, 253, 186),
        opacity = 255,
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "time",
        parent = "buttonImg",
        text = T("2022/22/22"),
        size = 13
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(68, 24)
      },
      config = {
        color = ccc3(250, 209, 137),
        opacity = 255,
        visible = true
      }
    }
  },
  {
    {
      t = "Scale9Sprite",
      base = {
        name = "itemBg",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_done_copper.png",
        capInsets = CCRectMake(250, 10, 283, 50)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(783, 97)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/1080P/taskModel/ach_task/ach_task_line_1.png"
      },
      layout = {
        position = ccp(-290, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "iconBg",
        res = "UI/alpha/1080P/common/frame/equip_frame_white.png"
      },
      layout = {
        position = ccp(-150, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "buttonImg",
        res = "UI/alpha/1080P/common/button_com_mini.png"
      },
      layout = {
        position = ccp(290, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\233\162\134\229\143\150"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 21)
      },
      config = {
        color = ccc3(33, 33, 38),
        opacity = 255,
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "Label_120",
        parent = "buttonImg",
        text = T("\233\162\134\229\143\150"),
        size = 16
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(50.75, 22)
      },
      config = {
        color = ccc3(254, 252, 219),
        opacity = 255,
        visible = true
      }
    }
  }
}
local achListItemLay = {}

function achListItemLay.new(sceneSelf, param, size)
  return setmetatable({
    sceneSelf = sceneSelf,
    layer = CCLayer:create(),
    param = param,
    size = size
  }, {__index = achListItemLay}):create()
end

function achListItemLay:create()
  local param = self.param or {}
  self.cupType = param.cupType
  self.achViewCfg = ed.cupTypeToAchView[self.cupType]
  self.layerBj = CCLayer:create()
  self.layer:addChild(self.layerBj)
  self.layerItem = CCLayer:create()
  self.layer:addChild(self.layerItem, 9)
  local width = self.size.width
  local height = self.size.height
  local label = ed.createttf(param.name or "nil", 16)
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(ccp(115 - width / 2, 15))
  local titleColor = self.achViewCfg.titleColor
  local strokeColor = self.achViewCfg.titleStroke
  label:setColor(titleColor)
  label:setStroke(strokeColor, 1)
  self.layerItem:addChild(label)
  label = ed.createttf(param.description or "nil", 14)
  label:setAnchorPoint(ccp(0, 0.5))
  label:setColor(ccc3(72, 56, 43))
  label:setPosition(ccp(115 - width / 2, -15))
  label:setDimensions(CCSizeMake(75 - label:getPositionX(), 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setPosition(ccp(115 - width / 2, -8 - label:getContentSize().height * 0.5))
  self.layerItem:addChild(label)
  param.reward = {
    param.reward,
    {
      id = 0,
      count = param.point,
      type = "Achievement"
    }
  }
  self.items = {}
  if param.reward and 0 < #param.reward then
    for i, v in ipairs(param.reward) do
      local item = items.new(self.sceneSelf, v, 1, i, false, false, true)
      if item.icon then
        item.icon:setPosition(ccp(i * 70 + 40, 0))
        self.layerItem:addChild(item.icon)
      end
      table.insert(self.items, item)
    end
  end
  self:refresh()
  return self
end

function achListItemLay:refresh(param)
  local oldRefreshType = self.param.refreshType or 0
  self.param = param or self.param
  param = self.param or {}
  if param.isRewarded then
    param.progress = param.target
    param.refreshType = 2
  else
    param.refreshType = param.isComplete and 3 or 1
  end
  if oldRefreshType == param.refreshType then
    return
  end
  self.param.refreshType = param.refreshType
  self.layerBj:removeAllChildrenWithCleanup(true)
  local container, ui = ed.editorui(ach_ui_info[param.refreshType])
  local bgPath
  if param.refreshType == 1 then
    bgPath = self.achViewCfg.uncompletedBg
  else
    bgPath = self.achViewCfg.completedBg
  end
  if param.refreshType == 2 then
    local sealTextColor = self.achViewCfg.sealTextColor
    local sealBg = self.achViewCfg.sealBg
    ed.setTexture(ui.buttonImg, sealBg, true)
    ed.setLabelColor(ui.Label_120, sealTextColor)
    ui.Label_120:setFontName(ed.fontBold)
  end
  ui.itemBg:setSpriteFrame(ed.getSpriteFrame(bgPath))
  self.layerBj:addChild(container)
  self.ui = ui
  if self.size.halfFixedWidth then
    self:initWinsize(ui)
  end
  local width = self.size.width
  local height = self.size.height
  self.ui.line:setPositionX(220 - width / 2)
  if self.size then
    self.ui.itemBg:setContentSize(CCSizeMake(width, self.ui.itemBg:getContentSize().height))
  end
  if self.ui.proStr then
    self.ui.proStr:setString(T("%d/%d", param.progress, param.target))
  end
  if param.icon then
    local icon = ed.createSprite(param.icon)
    icon:setPosition(45, 45)
    self.ui.iconBg:addChild(icon, -1)
    self.ui.iconBg:setScale(0.7)
    self.ui.iconBg:setPositionX(50 - width / 2)
  end
  local sealTimeColor = self.achViewCfg.sealTimeColor
  if self.ui.time and param.done_time then
    local y, m, d = ed.time2YMD(param.done_time)
    ed.setString(self.ui.time, string.format("%02d/%02d/%d", y, m, d))
    ed.setLabelColor(self.ui.time, sealTimeColor)
  elseif self.ui.time and param.reward_time then
    local y, m, d = ed.time2YMD(param.reward_time)
    ed.setString(self.ui.time, string.format("%02d/%02d/%d", y, m, d))
    ed.setLabelColor(self.ui.time, sealTimeColor)
  end
  local typeToKey = {
    0,
    2,
    1
  }
  for i, v in ipairs(self.items or {}) do
    v:refresh(param.refreshType and typeToKey[param.refreshType] or 0)
  end
  if param.refreshType == 3 and self.ui.buttonImg then
    self.sceneSelf.sceneSelf:btRegisterButtonClick({
      button = self.ui.buttonImg,
      key = "ach_list_btn_" .. param.type .. param.line_id .. param.id,
      param = param,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.sceneSelf.ui.ach_list_pos, x, y) then
          print("not list pos")
          return
        end
        if param.refreshType == 3 then
          self.sceneSelf:pusAchReward(param)
        end
      end,
      force = true,
      pressScale = 0.9,
      normalScale = 1,
      clickInterval = 1
    })
  end
end

function achListItemLay:initWinsize(ui)
  local newWid = self.size.halfFixedWidth or 0
  local newHei = 0
  
  local function posfunc(ui, isLeft, isDown)
    local newx, newy = isLeft and newWid / 2 * -1 or newWid / 2, isDown and newHei / 2 * -1 or newHei / 2
    local x, y = ui:getPosition()
    ui:setPosition(x + newx, y + newy)
  end
  
  posfunc(ui.buttonImg)
end

ed.achListItemLayModule = achListItemLay
