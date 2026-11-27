local base = ed.ui.activityBase
local BindActivity = {}
ed.ui.bindActivityRules = BindActivity

function BindActivity:closeRules()
  if self.ruleLayer then
    self.ruleLayer:getRoot():removeFromParentAndCleanup(true)
    self.ruleLayer = nil
    self.ruleList = nil
    self.ruleListData = {}
  end
end

function BindActivity:closeRuleLayer()
  BindActivity:closeRules()
end

local function createReward(data)
  local node = CCNode:create()
  node:setAnchorPoint(ccp(0, 0.5))
  local type = data.type
  local itemAmount = data.itemCount
  local id = type == "Item" and data.id or type
  local equip = ed.readequip.createIconWithAmount(id, 35, itemAmount)
  local text = T(T("\228\184\173\229\165\150\231\142\135%s%%"), data.percent)
  local label = ed.createLabelWithFontInfo(text, "small_normal_button")
  ed.right2(label, equip, 2)
  node:addChild(equip)
  node:addChild(label)
  return node
end

local function createRewards(index, datas)
  local node = CCNode:create()
  local px, colum = 10, 3
  for k = 1, colum do
    local data = datas[k + (index - 1) * colum]
    if data then
      local equip = createReward(data)
      equip:setPositionX(px)
      px = px + 170
      node:addChild(equip)
    end
  end
  return node
end

function BindActivity:initContent()
  local layer = self.ruleLayer
  local list = layer.listview
  list:clear()
  list:addItem({
    "<text|normalButton| >"
  })
  list:addItem({
    T("<text|chat_content|\229\143\170\232\166\129\229\143\130\228\184\142\230\180\187\229\138\168\239\188\140100%\232\142\183\233\146\187\231\159\179\229\165\150\229\138\177\239\188\140\230\155\180\230\156\137\230\156\186\228\188\154\230\138\189\228\184\173\233\153\144\233\135\143\231\137\136T\230\129\164\229\147\166\239\188\129|540>")
  })
  list:addItem({
    T("<text|task_reward|(\229\143\130\229\138\160\231\154\132\228\186\186\230\149\176\232\182\138\229\164\154\239\188\140\229\165\150\229\147\129\232\182\138\228\184\176\229\142\154\239\188\129\228\184\173\229\165\150\230\166\130\231\142\135\228\185\159\228\188\154\229\164\167\229\164\167\230\143\144\233\171\152\239\188\129)|540>")
  })
  list:changeItemConfig(1)
  list:addItem({}, {})
  local data = ed.getDataTable("BindingReward")[self.chain]
  for k, row in ipairs(data) do
    list:changeItemConfig(2)
    local pAmount = row[""]
    local percent = row["Reward Percent 1"]
    if k == 1 then
      local itemData = list:addItem({
        T("\229\143\130\228\184\142\230\180\187\229\138\168\228\186\186\230\149\176\228\184\141\232\182\179"),
        row["Range 2"],
        T("\228\184\173\229\165\150\231\142\135%s%%", percent * 100)
      }, {})
      ed.right2(itemData.controllers.binds, itemData.controllers.target, 5)
    else
      local itemData = list:addItem({
        T("\229\143\130\228\184\142\230\180\187\229\138\168\228\186\186\230\149\176\230\187\161"),
        row["Range 1"] - 1,
        T("\228\184\173\229\165\150\231\142\135%s%%", percent * 100)
      }, {})
      ed.right2(itemData.controllers.binds, itemData.controllers.target, 5)
    end
    local rewards = {}
    local type = row["Default Type"]
    if type then
      local Percent = row["Default Percent"]
      local temp = {
        type = row["Default Type"],
        id = row["Default Id"],
        percent = Percent * 100,
        itemCount = row["Default Amount"]
      }
      local max = row["Default Max"]
      if max then
        temp.itemCount = math.max(temp.itemCount, max)
      end
      table.insert(rewards, temp)
    end
    for i = 5, 2, -1 do
      local type = row[T("Reward Type %s", i)]
      if type then
        local Percent = row[T("Reward Percent %s", i)]
        local type = row[T("Reward Type %s", i)]
        if type == "Diamond" then
          type = "ManayDiamonds"
        end
        local temp = {
          type = type,
          id = row[T("Reward Id %s", i)],
          percent = Percent * 100,
          itemCount = row[T("Reward Amount %s", i)]
        }
        local max = row[T("Reward Max %s", i)]
        if max then
          temp.itemCount = math.max(temp.itemCount, max)
        end
        table.insert(rewards, temp)
      end
    end
    list:changeItemConfig(3)
    for k = 1, math.ceil(#rewards / 3) do
      list:addItem({
        createRewards(k, rewards)
      }, {})
    end
    list:changeItemConfig(4)
    list:addItem({}, {})
  end
end

function BindActivity:createRules(index)
  local layer = panelMeta:new2(BindActivity, BindActivity.ruleUI)
  if ed.ui.activitiesPanel then
    ed.ui.activitiesPanel:getRootLayer():addChild(layer:getRootLayer(), 300)
    self.ruleLayer = layer
    self.chain = index or 1
    self:initContent()
  end
end

function BindActivity:confirm()
  self:confirmClose()
  local cw = ed.ui.cdkeywindow.create()
  if ed.ui.activitiesPanel then
    ed.ui.activitiesPanel:getRootLayer():addChild(cw.mainLayer, 300)
  end
end

function BindActivity:bindConfirm()
  BindActivity:confirm()
end

function BindActivity:confirmClose()
  if self.notesLayer then
    self.notesLayer:getRoot():removeFromParentAndCleanup(true)
    self.notesLayer = nil
  end
end

function BindActivity:closeCofirm()
  BindActivity:confirmClose()
end

function BindActivity:createNotes()
  local layer = panelMeta:new2(BindActivity, BindActivity.NotesUIRes)
  if ed.ui.activitiesPanel then
    ed.ui.activitiesPanel:getRootLayer():addChild(layer:getRootLayer(), 300)
    self.notesLayer = layer
  end
end

BindActivity.ruleUI = {
  {
    layerName = "ruleLayer",
    iPriority = 100,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -300,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "ruleInfo",
          res = "UI/alpha/1080P/common/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 250)
        },
        config = {
          scaleSize = CCSizeMake(560, 360)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T("\229\165\150\229\147\129\232\175\166\230\131\133"),
          size = 22,
          parent = "ruleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(280, 335)
        },
        config = {
          color = ccc3(251, 206, 16)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "heroInfo",
          parent = "ruleInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(280, 335)
        },
        config = {
          scalexy = {x = 1.5, y = 1.1}
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeRuleInfo",
          sound = "sound_menu/common_close_popup_window.mp3",
          res = {
            normal = "UI/alpha/1080P/common/common_tips_button_close_1.png"
          },
          parent = "ruleInfo",
          handleName = "closeRuleLayer"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(544, 340)
        }
      },
      {
        t = "ListView",
        base = {
          name = "listview",
          heightInner = 5,
          cliprect = CCRectMake(120, 90, 550, 290),
          priority = -500
        },
        itemConfig = {
          {
            t = "RichText",
            base = {name = "name", text = ""},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(30, 20)
            },
            listData = true
          }
        },
        itemConfig1 = {
          {
            t = "Sprite",
            base = {
              name = "titlebg",
              res = "UI/alpha/HVGA/stagedetail/stagedetail_raid_subtitle_bg.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(275, -2)
            },
            config = {
              scalexy = {x = 1.5, y = 1}
            }
          },
          {
            t = "Label",
            base = {
              name = "title",
              text = T("\233\152\182\230\174\181\229\165\150\229\138\177"),
              size = 18
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(275, -2)
            },
            config = {
              color = ccc3(251, 206, 16)
            }
          }
        },
        itemConfig2 = {
          {
            t = "Label",
            base = {
              name = "target",
              text = T("\229\143\130\228\184\142\230\180\187\229\138\168\228\186\186\230\149\176\230\187\161"),
              size = 16
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(30, -5)
            },
            config = {
              color = ccc3(255, 255, 255)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "binds",
              text = T("9999"),
              size = 16
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(140, -5)
            },
            config = {
              color = ccc3(255, 234, 198)
            },
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "label",
              text = T("\229\165\150\229\147\129\230\177\160"),
              size = 16
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(240, -5)
            },
            config = {
              color = ccc3(255, 255, 255)
            }
          },
          {
            t = "Sprite",
            base = {
              name = "ui",
              res = "UI/alpha/HVGA/activity/tshirt_bar_2.png"
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(25, -40)
            },
            config = {}
          },
          {
            t = "Label",
            base = {
              name = "label_1",
              text = T("\229\133\177100\228\187\189(1%)"),
              size = 16
            },
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(180, -40)
            },
            config = {
              color = ccc3(255, 255, 255)
            },
            listData = true
          }
        },
        itemConfig3 = {
          {
            t = "Sprite",
            base = {name = "rewards"},
            addIcon = "true",
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(40, 3)
            },
            config = {
              scaleSize = CCSizeMake(100, 45)
            },
            listData = true
          }
        },
        itemConfig4 = {
          {
            t = "Sprite",
            base = {
              name = "line",
              res = "UI/alpha/HVGA/common/common_getitem_line.png"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(275, 5)
            },
            config = {
              scalexy = {x = 1.5, y = 1}
            }
          }
        }
      }
    }
  }
}
BindActivity.NotesUIRes = {
  {
    layerName = "errornetLayer",
    iPriority = 100,
    layerColor = ccc4(0, 0, 0, 180),
    touchInfo = {
      iPriority = -300,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "errorBg",
          res = "UI/alpha/1080P/common/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 260)
        },
        config = {
          scaleSize = CCSizeMake(310, 160)
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "close",
          clickPos = "outSide",
          parent = "errorBg",
          handleName = "closeCofirm"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(155, 80)
        },
        config = {
          messageRect = CCRectMake(0, 0, 310, 160)
        }
      },
      {
        t = "Label",
        base = {
          name = "ui",
          text = T("\228\189\160\229\176\134\232\183\179\232\189\172\232\135\179\226\128\156\231\179\187\231\187\159\232\174\190\231\189\174-\229\133\145\230\141\162\231\160\129\226\128\157\231\149\140\233\157\162"),
          fontinfo = "skill_white",
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
          name = "ui",
          text = T("\232\190\147\229\133\165\228\189\160\231\154\132\230\137\139\230\156\186\229\143\183\229\141\179\229\143\175\232\142\183\229\190\151\233\170\140\232\175\129\231\160\129\231\159\173\228\191\161"),
          fontinfo = "skill_white",
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
          res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png",
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
          name = "back",
          parent = "errorBg",
          buttonName = {
            text = T("\231\171\139\229\141\179\232\183\179\232\189\172"),
            fontInfo = "dark_white"
          },
          res = {
            normal = "UI/alpha/1080P/common/tavern_button_normal_1.png",
            press = "UI/alpha/1080P/common/tavern_button_normal_2.png"
          },
          capInsets = CCRectMake(14, 20, 60, 23),
          handleName = "bindConfirm"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(155, 45)
        },
        config = {
          scaleSize = CCSizeMake(100, 48)
        }
      }
    }
  }
}
