local base = ed.ui.popwindow
local communityWin = newclass(base.mt)
ed.ui.communityWin = communityWin
local communityItems = {
  cn = {
    {
      name = T("B\231\171\153"),
      bg = "UI/alpha/1080P/distribution/community/community_button_bili.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_bili.png",
      url = "https://space.bilibili.com/481427597?spm_id_from=333.337.0.0"
    },
    {
      name = T("\229\190\174\229\141\154"),
      bg = "UI/alpha/1080P/distribution/community/community_button_weibo.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_weibo.png",
      url = "https://weibo.com/daotachuanqi"
    },
    {
      name = T("\231\153\190\229\186\166\232\180\180\229\144\167"),
      bg = "UI/alpha/1080P/distribution/community/community_button_baidu.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_baidu.png",
      url = "https://tieba.baidu.com/wxf/4528066?kw=%E5%88%80%E5%A1%94%E4%BC%A0%E5%A5%87"
    },
    {
      name = T("\230\138\150\233\159\179"),
      bg = "UI/alpha/1080P/distribution/community/community_button_douyin.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_douyin.png",
      url = "https://www.douyin.com/user/MS4wLjABAAAAaFtZTFCptZfX5oOVyGjtf2iFogeyUQPPxXbLIAVPKv8"
    }
  },
  tw = {
    {
      name = T("Facebook"),
      bg = "UI/alpha/1080P/distribution/community/community_button_bili.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_fb.png",
      url = "https://www.facebook.com/Littleicelegend"
    },
    {
      name = T("Discord"),
      bg = "UI/alpha/1080P/distribution/community/community_button_discord.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_discord.png",
      url = "https://discord.gg/SpABxg6euE"
    },
    {
      name = T("Instagram"),
      bg = "UI/alpha/1080P/distribution/community/community_button_ins.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_ins.png",
      url = "https://www.instagram.com/littleicelegendzh"
    },
    {
      name = T("YouTube"),
      bg = "UI/alpha/1080P/distribution/community/community_button_douyin.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_YouTube.png",
      url = "https://www.youtube.com/@Littleicelegend"
    }
  },
  ja = {
    {
      name = T("X"),
      bg = "UI/alpha/1080P/distribution/community/community_button_x.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_x.png",
      url = "https://x.com/eikue_jp"
    }
  },
  ko = {
    {
      name = T("Naver Game Lounge"),
      bg = "UI/alpha/1080P/distribution/community/community_button_naver.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_naver.png",
      url = "https://game.naver.com/lounge/Heroic_Alliance/board"
    }
  },
  en = {
    {
      name = T("Facebook"),
      bg = "UI/alpha/1080P/distribution/community/community_button_bili.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_fb.png",
      url = "https://www.facebook.com/profile.php?id=61564046491585"
    },
    {
      name = T("Discord"),
      bg = "UI/alpha/1080P/distribution/community/community_button_discord.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_discord.png",
      url = "https://discord.gg/R3JXKJAyuZ"
    }
  },
  es = {
    {
      name = T("Facebook"),
      bg = "UI/alpha/1080P/distribution/community/community_button_bili.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_fb.png",
      url = "https://www.facebook.com/profile.php?id=61564046491585"
    },
    {
      name = T("Discord"),
      bg = "UI/alpha/1080P/distribution/community/community_button_discord.png",
      icon = "UI/alpha/1080P/distribution/community/community_icon_discord.png",
      url = "https://discord.gg/R3JXKJAyuZ"
    }
  }
}
communityWin.communityItems = communityItems

function communityWin.create(param)
  local self = base.create("communityWin")
  setmetatable(self, communityWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function communityWin:initData(param)
end

function communityWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v, x, y) then
        v:setScale(0.99)
        
        return v
      end
    end
    return nil
  end
  
  return handler
end

function communityWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    ed.openURL(v.data.url)
  end
  
  return handler
end

function communityWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v:setScale(1)
  end
  
  return handler
end

function communityWin:createItem(v)
  local bg = ed.createSprite(v.bg)
  local icon = ed.createSprite(v.icon)
  bg:addChild(icon)
  icon:setPosition(ccp(69.75, 27.25))
  local name = ed.createttf(v.name, 20)
  ed.setLabelColor(name, ed.toccc3(16776423))
  name:setPosition(ccp(169.75, 27.25))
  bg:addChild(name)
  return bg
end

function communityWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  self.data = communityWin.communityItems[EDCurLanguage]
  if self.data == nil then
    self.data = communityWin.communityItems.cn
  end
  local size = self.ui.layer_item:getContentSize()
  for k, v in ipairs(self.data) do
    local ui = self:createItem(v)
    ui.data = v
    ui:setPosition(ccp(size.width / 2, size.height - (k - 0.3) * 60))
    self.draglist:addItem(ui)
    table.insert(uiList, ui)
  end
  self.uiList = uiList
  self.draglist:initListHeight(60 * #self.data)
end

function communityWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.GuildHeadChangeWin)
  self.ui.btn_back:setVisible(false)
  ed.setString(ui.title, T("\229\138\160\229\133\165\231\164\190\229\140\186"))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function communityWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
