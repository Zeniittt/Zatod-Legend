ed.uieditor = ed.uieditor or {}
ed.uieditor.chat_ladder_fight = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 426, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/sharefight/title.png",
      name = "image_text_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 87)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(395.5, 60)
    },
    t = "Layer",
    base = {
      name = "panel_hero_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(8.5, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 25)
    },
    t = "Layer",
    base = {
      parent = "image_text_bg",
      name = "panel_content",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19.5, 7.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gs",
      z = 0,
      parent = "image_text_bg",
      text = T("\230\136\152\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(402, 19.75)
    }
  }
}
