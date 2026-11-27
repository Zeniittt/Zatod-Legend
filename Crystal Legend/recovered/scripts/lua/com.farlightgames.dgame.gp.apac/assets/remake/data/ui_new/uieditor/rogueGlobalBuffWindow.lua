ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueGlobalBuffWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 776.5, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_global_buff_frame.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 298)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\131\140\230\153\175\232\174\190\229\174\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388.25, 182.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 130.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(133.25, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(147, 99, 180),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_close_tips",
      z = 0,
      parent = "image_bg",
      text = T("\231\130\185\229\135\187\231\169\186\231\153\189\229\164\132\229\133\179\233\151\173"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388.25, 16.5)
    }
  }
}
