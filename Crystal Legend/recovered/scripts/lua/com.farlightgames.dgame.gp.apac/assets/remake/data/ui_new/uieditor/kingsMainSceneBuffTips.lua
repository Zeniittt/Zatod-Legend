ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsMainSceneBuffTips = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 229.5, h = 106.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/legendactivity/main_buffboard.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 205),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff_title",
      z = 0,
      parent = "image_bg",
      text = T("\228\188\160\229\165\135\232\175\184\231\142\139\228\185\139\229\156\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.25, 87.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/legendactivity/buff_board2.png",
      name = "ImageView_24009",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.25, 87.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(210, 52.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_buff_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.75, 11.25)
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
      name = "Label_24010",
      z = 0,
      parent = "ImageView_24009",
      text = T("\231\148\159\230\149\136\228\184\173"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 10)
    }
  }
}
