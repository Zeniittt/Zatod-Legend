local base = ed.ui.popwindow
local dreamRecordPop = newclass(base.mt)
ed.ui.dreamRecordPop = dreamRecordPop
ed.UITool.registViewOpenFunc("dreamRecordPop", function(param)
  ed.ui.dreamRecordPop.create(param):popWindow()
end)

function dreamRecordPop.create(param)
  return setmetatable(base.create("dreamRecordPop"), dreamRecordPop.mt):init(param)
end

function dreamRecordPop:init(param)
  self:uiCreate()
  self:uiRefresh(param)
  self:createShareTip()
  self:registerBtnEvents()
  self:show({skipAnim = false})
  return self
end

function dreamRecordPop:uiCreate()
  self.frame, self.ui = ed.editorui(ed.uieditor.dreamland_record_pop)
  self.container:addChild(self.frame)
  self.frame:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  self:createItemList()
  self:listenEvent("ChatRsp", function(data)
    if data._say and data._say._result == "success" then
      ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
    end
  end)
end

function dreamRecordPop:createItemList()
  self.thisCon = self.ui.item_list:getContentSize()
  self.draglist = ed.draglist.create({
    cliprect = CCRectMake(0, 0, self.thisCon.width, self.thisCon.height),
    container = self.ui.item_list,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      if self.shareTip:isVisible() and not ed.containsPoint(self.shareTip, x, y) then
        self.shareTip:setVisible(false)
      end
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end
  })
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
end

function dreamRecordPop:itemButtonFun(type, data, index)
  if type == "btn_share" then
    self.shareTip:setVisible(true)
    self.shareTip:setPositionY(index * -99 + self.thisCon.height - 65.5)
    if #self.recordData >= 4 and index + 2 > #self.recordData then
      self.shareTip:setPositionY(self.shareTip:getPositionY() + 176)
      self.shareTip.bg:setScaleY(-1)
      self.shareTip.bg:setPositionY(-6)
    else
      self.shareTip.bg:setScaleY(1)
      self.shareTip.bg:setPositionY(0)
    end
    self.records = data
  elseif type == "btn_statics" then
    ed.dreamland.network_mgr:sendQuerySummary(data._replay_id)
  elseif type == "btn_replay" then
    ed.dreamland.network_mgr.ReplayStageId = data._stage_id
    ed.dreamland.network_mgr:sendQueryReplay(data._replay_id)
  end
end

function dreamRecordPop:itemModuleCreate(index, data)
  local frame, ui = ed.editorui(ed.uieditor.dreamland_record_item)
  ui.name:setString(ed.getDataTable("Stage")[data._stage_id]["Stage Name"])
  ui.num:setString(data._damage)
  ui.time:setString(T("%s\229\137\141", ed.time2dhm(ed.getServerTime() - data._bt_time)))
  
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0) or 0
    end
    
    table.sort(list, function(a, b)
      return attackRange(a._tid) < attackRange(b._tid)
    end)
    local newlist = {}
    for i, v in ipairs(list) do
      table.insert(newlist, 1, v)
    end
    return newlist
  end
  
  for i, v in ipairs(sortHeroes(ed.copyProto(data._heroes) or {})) do
    local icon = ed.readhero.createIconByServer(v).icon
    icon:setPosition(i * 65 - 15, 37)
    ui.bg:addChild(icon)
    icon:setScale(0.75)
  end
  local buttonInfo = {
    "btn_share",
    "btn_statics",
    "btn_replay"
  }
  for _, v in ipairs(buttonInfo) do
    self:btRegisterButtonClick({
      button = ui[v],
      key = v .. index,
      force = true,
      mcpMode = true,
      pressScale = 0.75,
      normalScale = 0.8,
      clickHandler = function(event, x, y)
        if not self.shareTip:isVisible() or not ed.containsPoint(self.shareTip, x, y) then
          self:itemButtonFun(v, data, index)
        end
      end
    })
  end
  return frame
end

function dreamRecordPop:uiRefresh(param)
  local size = 101
  self.itemList = self.itemList or {}
  self.recordData = param._records or {}
  for i, v in ipairs(self.recordData) do
    self.draglist:addItem(self:itemModuleCreate(i, v), ccp(self.thisCon.width / 2, self.thisCon.height - i * size + size / 2 - 4))
  end
  self.draglist:initListHeight(#self.recordData * size + 8)
end

function dreamRecordPop:registerBtnEvents()
  self:btRegisterOutClick({
    area = self.ui.ImageView_6217,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({skipAnim = false})
  end, {pressScale = 0.75, normalScale = 0.8})
end

function dreamRecordPop:createShareTip()
  local bg = CCLayer:create()
  bg:setPosition(ccp(537, 0))
  bg:setContentSize(CCSizeMake(177.5, 131))
  self.draglist.listLayer:addChild(bg)
  bg:setVisible(false)
  local bg2 = ed.createSpriteTools({
    res = "UI/alpha/1080P/dreamland/share_btn_bg.png",
    pos = ccp(0, 0),
    parent = bg
  })
  local shareBtns = {
    ed.createSpriteTools({
      res = "UI/alpha/1080P/common/button_a_butt.png",
      pos = ccp(0, 21),
      rectMake = CCRectMake(10, 10, 95, 30),
      sizeMake = CCSizeMake(162, 44),
      parent = bg
    }),
    ed.createSpriteTools({
      res = "UI/alpha/1080P/common/button_a_butt.png",
      pos = ccp(0, -28),
      rectMake = CCRectMake(10, 10, 95, 30),
      sizeMake = CCSizeMake(162, 44),
      parent = bg
    })
  }
  local shareBtnsStr = {
    "\229\136\134\228\186\171\229\136\176\228\184\150\231\149\140\233\162\145\233\129\147",
    "\229\136\134\228\186\171\229\136\176\229\133\172\228\188\154\233\162\145\233\129\147"
  }
  for i, v in ipairs(shareBtns) do
    ed.createSpriteTools({
      res = string.format("UI/alpha/1080P/dreamland/share_btn_%d.png", i),
      pos = ccp(19, 21),
      parent = v
    })
    local label = ed.createLabelTools({
      txt = T(shareBtnsStr[i]),
      size = 18,
      color = ccc3(ed.colorToStr("#fffce7")),
      stroke = {
        ccc3(ed.colorToStr("#614017")),
        1
      },
      parent = v,
      pos = ccp(31, 21),
      anchor = ccp(0, 0.5)
    })
    ed.adaptLabel(label, {maxWidth = 120, minScale = 0.7})
    label:setHorizontalAlignment(kCCTextAlignmentCenter)
    self:btRegisterButtonClick({
      button = v,
      key = "shareBtns" .. i,
      pressScale = 0.95,
      clickHandler = function()
        if i == 1 then
          if ed.player:getLevel() < 24 then
            ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17624\231\186\167\230\137\141\232\131\189\229\156\168\228\184\150\231\149\140\233\162\145\233\129\147\229\136\134\228\186\171\230\136\152\230\150\151\229\189\149\229\131\143"))
            return
          end
          ed.chatManager.currentChannel = "world_channel"
          local content = string.format("<link|pvp|%s>", "\230\176\184\231\148\159\230\162\166\229\162\131")
          local recordid = self.records._replay_id
          local param = {
            channel = "world_channel",
            type = 2,
            content = content,
            recordid = recordid,
            accessory = {
              _type = "dreamland_replay",
              _record_id = recordid,
              _role_id = ed.getRoleId()
            }
          }
          ed.chatManager:setNeedSendMsg(param)
          ed.chatManager:sendChatMsg()
        elseif i == 2 then
          ed.showToast("\229\133\172\228\188\154" .. i)
          if ed.player:getGuildId() == 0 then
            ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
            return
          end
          ed.chatManager.currentChannel = "guild_channel"
          local content = string.format("<link|pvp|%s>", "\230\176\184\231\148\159\230\162\166\229\162\131")
          local recordid = self.records._replay_id
          local param = {
            channel = "guild_channel",
            type = 2,
            content = content,
            recordid = recordid,
            accessory = {
              _type = "dreamland_replay",
              _record_id = recordid,
              _role_id = ed.getRoleId()
            }
          }
          ed.chatManager:setNeedSendMsg(param)
          ed.chatManager:sendChatMsg()
        else
          ed.showToast("\229\165\189\229\143\139" .. i)
          ed.UITool.openView("dreamShareWin", {
            type = "friend",
            records = self.records
          })
        end
      end
    })
  end
  bg.bg = bg2
  self.shareTip = bg
end
