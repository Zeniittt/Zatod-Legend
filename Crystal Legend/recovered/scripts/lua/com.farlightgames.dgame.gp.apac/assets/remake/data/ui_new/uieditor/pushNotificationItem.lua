ed.uieditor = ed.uieditor or {}
ed.uieditor.pushNotificationItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(340, 29)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(21, 5, 2, 15),
      res = "UI/alpha/1080P/playerinfo/push_bg2.png",
      name = "notification_setting",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(309.5, 305.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "notification_text",
      z = 0,
      parent = "notification_setting",
      text = T("\231\153\190\232\180\167\229\176\143\229\186\151\231\137\169\229\147\129\229\136\183\230\150\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(28.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "notification_setting",
      res = "UI/alpha/1080P/playerinfo/switch_bg1.png",
      name = "switch_setting_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_setting_bg",
      res = "UI/alpha/1080P/playerinfo/switch_bg2.png",
      name = "close_setting_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_setting_bg",
      res = "UI/alpha/1080P/playerinfo/switch_bg3.png",
      name = "btn_setting",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 11.25)
    }
  }
}
