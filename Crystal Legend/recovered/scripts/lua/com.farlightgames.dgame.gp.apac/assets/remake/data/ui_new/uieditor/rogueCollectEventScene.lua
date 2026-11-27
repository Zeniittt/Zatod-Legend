ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueCollectEventScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/bless/bless_shop_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 596.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(925, 435)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(122.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 217, 222),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_progress_tips",
      z = 0,
      parent = "image_title_bg",
      text = T("\230\128\187\232\191\155\229\186\166"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 190, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_progress",
      z = 0,
      parent = "image_title_bg",
      text = "0/0",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(160.25, 17.75)
    }
  }
}
