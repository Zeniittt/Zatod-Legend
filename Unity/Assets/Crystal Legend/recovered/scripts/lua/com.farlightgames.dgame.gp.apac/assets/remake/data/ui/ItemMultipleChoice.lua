local base = ed.ui.popwindow
local class = newclass(base.mt)
class.__index = class
ed.ui.ItemMultipleChoice = class
local initDraglistWidth = 1020

local function createWindow(self, param)
  local mainLayer = self.mainLayer
  local ui = self.ui
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0.5, 0.5))
  mainLayer:addChild(container, 10)
  container:setContentSize(CCSizeMake(740, 380))
  container:setPosition(ccp(370, 190))
  self.container = container
  local itemName = string.format(T("\230\137\147\229\188\128 %s \229\143\175\228\187\165\232\142\183\229\190\151\228\187\165\228\184\139\233\129\147\229\133\183\228\185\139\228\184\128"), ed.readequip.value(self.selectid, "Name"))
  local ui_info = {
    {
      t = "Sprite",
      base = {name = "bg"},
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 265)
      },
      config = {
        scaleSize = CCSizeMake(740, 480)
      }
    }
  }
  local readNode = ed.readnode.create(self.container, ui)
  readNode:addNode(ui_info)
  ui_info = {
    {
      t = "Label",
      base = {
        name = "equip_lable",
        text = itemName,
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(370, 400)
      },
      config = {
        color = ccc3(251, 206, 16),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        },
        visible = true
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "bg_s",
        res = "UI/alpha/HVGA/choosebox_bg_2.png",
        capInsets = CCRectMake(55, 55, 55, 55)
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(10, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(720, 370)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/backbtn.png"
      },
      layout = {
        position = ccp(39, 409)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/1080P/common/backbtn-disabled.png",
        parent = "close"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readNode = ed.readnode.create(ui.bg, ui)
  readNode:addNode(ui_info)
  self:initDraglist()
  self:registerTouchHandler()
  readNode = ed.readnode.create(self.container, ui)
  if #self.ItemIDArray > 3 then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "left_arrow",
          res = "UI/alpha/1080P/common/herodetail_arrow_left.png",
          z = 16
        },
        layout = {
          position = ccp(16, 200)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "right_arrow",
          res = "UI/alpha/1080P/common/herodetail_arrow_right.png",
          z = 16
        },
        layout = {
          position = ccp(782, 200)
        },
        config = {}
      }
    }
    readNode:addNode(ui_info)
    for k, v in ipairs({
      ui.left_arrow,
      ui.right_arrow
    }) do
      v:setScale(0.7)
      local fo = CCFadeOut:create(1)
      local fi = CCFadeIn:create(1)
      local s = ed.readaction.create({
        t = "seq",
        fo,
        fi
      })
      v:runAction(CCRepeatForever:create(s))
    end
  end
end

class.createWindow = createWindow

local function createItemUI(self, index, data)
  local layer = self.draglist:getList()
  local em = {}
  local oh = initDraglistWidth
  if not self.listWidth then
    self.listWidth = 0
  end
  local lw = self.listWidth
  lw = lw + 5
  local ui_info = {
    {
      t = "Sprite",
      base = {name = "bg"},
      layout = {
        anchor = ccp(0, 0),
        position = ccp(15 + (index - 1) * 245, 15)
      },
      config = {
        scaleSize = CCSizeMake(245, 350)
      }
    }
  }
  readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  ui_info = {
    {
      t = "Scale9Sprite",
      base = {name = "bar_line_1"},
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-3, 1)
      },
      config = {
        scaleSize = CCSizeMake(4, 354)
      }
    },
    {
      t = "Scale9Sprite",
      base = {name = "bar_line"},
      layout = {
        anchor = ccp(0, 0),
        position = ccp(240, 1)
      },
      config = {
        scaleSize = CCSizeMake(317, 495)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "bar_bg",
        res = "UI/alpha/HVGA/choosebox_bg_2.png"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-15, -25)
      },
      config = {
        scaleSize = CCSizeMake(295, 460)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/choosebox_title.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(2, 340)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "sp",
        res = "UI/alpha/HVGA/herodetail-title-mark.png"
      },
      layout = {
        anchor = ccp(0.5, 1),
        position = ccp(109, 265)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "equip_lable",
        text = T("\232\163\133\229\164\135\229\144\141\229\173\151X9"),
        size = 20,
        parent = "title_bg"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(110, 17)
      },
      config = {
        color = ccc3(253, 253, 253),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        },
        visible = true
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "preset",
        res = "UI/alpha/HVGA/stageselect_difficulty_button_normal.png",
        capInsets = CCRectMake(14, 14, 53, 24)
      },
      layout = {
        position = ccp(108, 25)
      },
      config = {
        scaleSize = CCSizeMake(190, 52)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "preset_press",
        res = "UI/alpha/HVGA/stageselect_difficulty_button_normal_pressed.png",
        capInsets = CCRectMake(14, 14, 53, 24),
        parent = "preset"
      },
      layout = {
        position = ccp(0, 0),
        anchor = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(190, 52),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "preset_label",
        text = T("\232\142\183\229\190\151"),
        size = 24,
        parent = "preset"
      },
      layout = {
        position = ccp(97, 28)
      },
      config = {
        color = ccc3(251, 251, 251),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "tip_lable",
        text = T("\233\156\128\230\139\165\230\156\137\229\175\185\229\186\148\232\139\177\233\155\132"),
        size = 22
      },
      layout = {
        position = ccp(112, 28)
      },
      config = {
        color = ccc3(182, 65, 21),
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = T("\230\140\129\230\156\137\230\149\176\239\188\1541234"),
        size = 18,
        parent = "preset"
      },
      layout = {
        position = ccp(97, 68)
      },
      config = {
        color = ccc3(141, 74, 20)
      }
    }
  }
  readNode = ed.readnode.create(em.bg, em)
  readNode:addNode(ui_info)
  local itemId = self.ItemIDArray[index]
  local itemCount = self.ItemCountArray[index] * self.count
  local trigger = self.ItemTriggerID[index]
  local nameStr, name, amount
  em.data = {id = itemId, cout = itemCount}
  if index ~= 1 then
    em.bar_line_1:setVisible(false)
  end
  local id = itemId
  local it = ed.itemType(id)
  if self.isMagicStone then
    local meta
    em.icon, meta = self:createMagicStoneIcon(id)
    name = meta.Name
    self:initMagicStoneAttributes(id, em)
    em.amount_label:setVisible(false)
    amount = 0
  elseif it == "hero" then
    em.icon = ed.readhero.createIcon({id = id}).icon
    name = ed.getDataTable("Unit")[id]["Display Name"]
    self:createHeroHotLableNode(id, em)
    self:initheroDescription(id, em)
    em.icon:setScale(0.9)
    em.amount_label:setVisible(false)
    amount = 0
  elseif it == "equip" then
    em.icon = ed.readequip.createIcon(id)
    name = ed.readequip.value(id, "Name")
    self:initAtt(id, em)
    amount = ed.player.equip_qunty[id] or 0
  end
  em.icon:setPosition(ccp(110, 262))
  em.bg:addChild(em.icon)
  if 1 < itemCount then
    nameStr = string.format("%sX%d", name, itemCount)
  else
    nameStr = string.format("%s", name)
  end
  em.equip_lable:setString(nameStr)
  em.amount_label:setString(T("\230\140\129\230\156\137\230\149\176\239\188\154") .. amount)
  if trigger ~= nil and trigger ~= 0 then
    local trigger_info = ed.getDataTable("TodoTriggers")[trigger]
    local hid = trigger_info["Trigger Condition"]
    if ed.player:isPlayerHasCurHero(hid) then
      em.tip_lable:setVisible(false)
      em.preset:setVisible(true)
      self.buttonData[index] = em
    else
      em.tip_lable:setVisible(true)
      em.preset:setVisible(false)
    end
  else
    em.tip_lable:setVisible(false)
    em.preset:setVisible(true)
    self.buttonData[index] = em
  end
  self.listWidth = self.listWidth + 248
  self.draglist:initListWidth(self.listWidth)
end

class.createItemUI = createItemUI

function class:createMagicStoneIcon(id)
  return ed.MagicStoneUITool.createClippingStoneIconById(id)
end

function class:createHeroHotLableNode(id, ui)
  local heroHot = ed.hothero.manager:getHeroHot(id)
  local heroHotLabelNode = ed.herorecommend.manager:createHotLabelNode(heroHot)
  heroHotLabelNode:setPosition(ccp(50, 205))
  ui.bg:addChild(heroHotLabelNode)
end

local function initheroDescription(self, id, em)
  local ui = em
  local container = ui.bg
  ui.att_bg = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/choosebox_bg.png",
      capInsets = CCRectMake(30, 30, 150, 50)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(108, 190)
    },
    config = {isCascadeOpacity = true}
  }, container)
  local id = id
  local description = ed.getDataTable("Unit")[id].Description
  ui.detail = ed.createNode({
    t = "Label",
    base = {text = description, size = 17},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(15, 186)
    },
    config = {
      dimensions = CCSizeMake(190, 0),
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCVerticalTextAlignmentTop,
      color = ccc3(138, 56, 1)
    }
  }, container)
  local detailHeight = ui.detail:getContentSize().height
  ui.att_bg:setContentSize(CCSizeMake(200, detailHeight + 20))
end

class.initheroDescription = initheroDescription

function class:initMagicStoneAttributes(id, em)
  local ui = em
  local container = ui.bg
  ui.att_bg = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/choosebox_bg.png",
      capInsets = CCRectMake(98, 36, 98, 36)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(108, 220)
    },
    config = {isCascadeOpacity = true}
  }, container)
  local ox, oy = 7, 80
  local attribs = ed.MagicStoneUITool.getCNStyleAttribBonusById(id)
  for _, attr in ipairs(attribs) do
    local s = string.format("%s+%s%s", attr.name, attr.value, attr.suffix)
    local label = ed.createLabelTTF(s, 17)
    label:setAnchorPoint(ccp(0, 1))
    label:setPosition(ccp(ox, oy))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    ed.setLabelColor(label, ccc3(138, 56, 1))
    ed.setLabelDimensions(label, CCSizeMake(190, 0))
    ui.att_bg:addChild(label)
    oy = oy - label:getContentSize().height
  end
  ox, oy = 8, 130
  local effectInfo = ed.MagicStoneUITool.getFormattedEffectInfoById(id)
  for _, effectData in ipairs(effectInfo) do
    local s = effectData.formattedDesc
    local label = ed.createLabelTTF(s, 15)
    label:setAnchorPoint(ccp(0, 1))
    label:setPosition(ccp(ox, oy))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    ed.setLabelColor(label, ccc3(52, 42, 34))
    ed.setLabelDimensions(label, CCSizeMake(205, 0))
    container:addChild(label)
    oy = oy - label:getContentSize().height
  end
end

local function initAtt(self, id, em)
  local ui = em
  local container = ui.bg
  ui.att_bg = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/choosebox_bg.png",
      capInsets = CCRectMake(98, 36, 98, 36)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(108, 220)
    },
    config = {isCascadeOpacity = true}
  }, container)
  local id = id
  local amount = ed.player.equip_qunty[id] or 0
  local desc, add, suffix = ed.readequip.getDescription(id, 0)
  local uinfo = {}
  local isEquipDesc
  local equipDesc = ed.readequip.value(id, "Description")
  local Category = ed.readequip.value(id, "Category")
  if equipDesc then
    isEquipDesc = true
    desc = {equipDesc}
    uinfo = ed.readequip.getFragmentAmount(id)
    self.uinfo = uinfo
  end
  local lineCount = #desc
  local ui_info = {}
  for i = 1, #desc do
    local list = {}
    table.insert(list, {
      t = "Label",
      base = {
        name = "att_" .. i,
        text = desc[i],
        size = 17
      },
      config = {
        color = ccc3(138, 56, 1),
        horizontalAlignment = kCCTextAlignmentLeft,
        verticalAlignment = kCCVerticalTextAlignmentTop,
        dimensions = CCSizeMake(190, 0)
      }
    })
    if add[i] then
      table.insert(list, {
        t = "Label",
        base = {
          name = "add_att_" .. i,
          text = add[i],
          size = 17,
          offset = 5
        },
        config = {
          color = ccc3(0, 255, 0),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentTop,
          dimensions = CCSizeMake(190, 0)
        }
      })
    end
    if suffix[i] then
      table.insert(list, {
        t = "Label",
        base = {
          name = "suffix_att" .. i,
          text = suffix[i],
          size = 17
        },
        config = {
          color = ccc3(138, 56, 1),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentTop,
          dimensions = CCSizeMake(190, 0)
        }
      })
    end
    table.insert(ui_info, list)
  end
  if Category == T("\231\172\166\230\150\135\231\159\179") and 1600 < id then
    local runeList = {}
    local levelDes = string.format("%d\231\186\167\231\172\166\231\159\179", ed.rune.getNewRuneLevel(id))
    local attrDesc = ed.rune.getNewRuneAttrDesc(id)
    table.insert(runeList, {
      t = "Label",
      base = {
        name = "rune_name",
        text = levelDes,
        size = 18,
        offset = 5
      },
      config = {
        color = ccc3(42, 177, 255),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    })
    table.insert(ui_info, runeList)
    local attrRuneList = {}
    table.insert(attrRuneList, {
      t = "Label",
      base = {
        name = "rune_attr",
        text = attrDesc,
        size = 18,
        offset = 5
      },
      config = {
        color = ccc3(255, 217, 153),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    })
    table.insert(ui_info, attrRuneList)
    local words_ID = ed.rune.getRuneWordsID(id)
    if words_ID and 0 < words_ID then
      local runeWordsTbl = ed.getDataTable("RuneWords")
      if runeWordsTbl and runeWordsTbl[words_ID] then
        local row = runeWordsTbl[words_ID]
        local needAmount = row["Rune Amount"]
        local words_name = row["Chinese Name"]
        local attrStr = string.gsub(row["Chinese Attr Name"], "#", row["Attr Value"])
        local wordsList = {}
        table.insert(wordsList, {
          t = "Label",
          base = {
            name = "words_name",
            text = string.format("%s\229\165\151\232\163\133(%d\228\187\182)", words_name, needAmount),
            size = 18,
            offset = 5
          },
          config = {
            color = ccc3(42, 177, 255),
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
          }
        })
        table.insert(ui_info, wordsList)
        local wordsAttrList = {}
        local otherRuneTbl = ed.rune.getRelatedToOtherRunes(id)
        for k, v in pairs(otherRuneTbl) do
          local nameStr = ed.rune.getRuneName(v)
          local otherRune = {}
          table.insert(otherRune, {
            t = "Label",
            base = {
              name = "other_words_" .. k,
              text = nameStr,
              size = 18,
              offset = 5
            },
            config = {
              color = ccc3(255, 255, 255),
              shadow = {
                color = ccc3(0, 0, 0),
                offset = ccp(0, 2)
              }
            }
          })
          table.insert(ui_info, otherRune)
        end
        table.insert(wordsAttrList, {
          t = "Label",
          base = {
            name = "words_attr",
            text = attrStr,
            size = 18,
            offset = 5
          },
          config = {
            color = ccc3(255, 217, 153),
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
          }
        })
        table.insert(ui_info, wordsAttrList)
      end
    end
  end
  local additionHeroEquipDespHeight = 0
  local lableroot
  if uinfo.isFragment then
    table.insert(ui_info, {
      {
        t = "Label",
        base = {text = " ", size = 17},
        config = {}
      }
    })
    lineCount = lineCount + 1
    if not addition.ignoreComposeDesc then
      table.insert(ui_info, {
        {
          t = "Label",
          base = {
            name = "fragment_title",
            text = T("\230\139\165\230\156\137\231\162\142\231\137\135\239\188\154"),
            size = 17
          },
          config = {
            color = ccc3(138, 56, 1)
          }
        },
        {
          t = "Label",
          base = {
            name = "fragment_amount",
            text = string.format("%d/%d", amount, uinfo.need),
            size = 18
          },
          config = {
            color = ccc3(138, 56, 1)
          }
        }
      })
      lineCount = lineCount + 1
    end
  elseif lineCount < 5 then
    table.insert(ui_info, {
      {
        t = "Label",
        base = {text = " ", size = 17},
        config = {}
      }
    })
  end
  local ui_param = {
    t = "ChaosNode",
    base = {nodeArray = ui, offset = 2},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(15, 216 + additionHeroEquipDespHeight)
    },
    ui = ui_info
  }
  local att_bgcontainer = ui.bg
  ui.att_list = ed.createNode(ui_param, att_bgcontainer)
  if lableroot ~= nil then
    att_bgcontainer:addChild(lableroot, 1)
  end
  local detailText = ed.readequip.value(id, "Comment")
  detailText = detailText or " "
  local expire_time_hash = ed.player:getExpireTimeHash()
  if expire_time_hash and expire_time_hash[id] then
    local expire_time = expire_time_hash[id]
    detailText = string.gsub(detailText, "#v_time#", ed.getYMDHMSTime(expire_time, "mail"))
  else
    detailText = string.gsub(detailText, "#v_time#", "--")
  end
  ui.detail = ed.createNode({
    t = "Label",
    base = {text = detailText, size = 16},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(15, 0)
    },
    config = {
      dimensions = CCSizeMake(200, 0),
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCVerticalTextAlignmentTop,
      color = ccc3(67, 59, 56)
    }
  }, container)
  local detailHeight = ui.detail:getContentSize().height
  if detailText == " " then
    detailHeight = 0
  end
  local posX, posY = ui.att_bg:getPosition()
  local attListHeight = ui.att_list:getContentSize().height
  ui.att_bg:setContentSize(CCSizeMake(200, math.max(attListHeight + 5, 60)))
  attListHeight = posY - ui.att_bg:getContentSize().height - 3
  ui.detail:setPosition(ccp(15, attListHeight))
end

class.initAtt = initAtt

local function createItem(self)
  for i, v in ipairs(self.ItemIDArray) do
    self.createItemUI(self, i, nil)
  end
end

class.createItem = createItem

local function initDraglist(self)
  local draglistInfo = {
    cliprect = CCRectMake(0, 0, 750, 375),
    rect = CCRectMake(2, 10, 750, 350),
    childSize = {250, 350},
    leftShade = "UI/alpha/HVGA/stagedone_left_shade.png",
    rightShade = "UI/alpha/HVGA/stagedone_left_shade.png",
    container = self.ui.bg,
    zorder = 0,
    priority = -800,
    noshade = false,
    swallow = false,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(draglistInfo)
end

class.initDraglist = initDraglist

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      self:doClickClose()
    end,
    clickInterval = 0.5,
    force = true
  })
end

class.registerTouchHandler = registerTouchHandler

local function doPressInList(self)
  local function handler(x, y)
    for k, v in pairs(self.buttonData) do
      local sp_button = v.preset
      
      if ed.containsPoint(sp_button, x, y) then
        v.preset_press:setVisible(true)
        return v
      end
    end
    return nil
  end
  
  return handler
end

class.doPressInList = doPressInList

local function doClickInList(self)
  local obj = self
  
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.preset
    v.preset_press:setVisible(false)
    if ed.containsPoint(sp_button, x, y) then
      obj:doSeleteCurItemId(v.data)
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

local function cancelPressInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.preset
    v.preset_press:setVisible(false)
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function cancelClickInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.preset
    v.preset_press:setVisible(false)
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

local function doSeleteCurItemId(self, itemData)
  if ed.getServerTime() - self.isClickTime < 500 then
    return
  end
  local id = itemData.id
  local cout = itemData.cout
  self.isClickTime = ed.getServerTime()
  ed.record:useItemCount(self.selectid, self.count)
  local item_info = ed.packItem(self.selectid, self.count)
  local msg = ed.upmsg.consume_item()
  msg._consume_item_extra_info = ed.upmsg.consume_item_extra_info()
  msg._consume_item_extra_info._type = 2
  msg._consume_item_extra_info._id = id
  msg._item = item_info
  ed.send(msg, "consume_item")
end

class.doSeleteCurItemId = doSeleteCurItemId

local function doClickClose(self)
  self:destroy()
end

class.doClickClose = doClickClose

local function create(param, selectid, count, parentLogic)
  addition = addition or {}
  local self = base.create("ItemMultipleChoice")
  setmetatable(self, class.mt)
  self.isClickTime = 0
  self.param = param
  self.ItemIDArray = param["Item Set"]
  self.ItemCountArray = param["Item Set Count"]
  self.ItemTriggerID = param["Get Trigger ID"]
  self.selectid = selectid
  self.count = count
  self.parentLogic = parentLogic
  self.buttonData = {}
  self.otherPlayerInfo = otherPlayerInfo or nil
  self.baseScene = ed.getCurrentScene()
  self.isMagicStone = param["Is Magicstone"]
  local param = {from = "create", allowLight = true}
  param.allowLight = addition.allowLight == nil and true or addition.allowLight
  self:createWindow(param)
  self:createItem()
  self:show()
  return self
end

class.create = create
