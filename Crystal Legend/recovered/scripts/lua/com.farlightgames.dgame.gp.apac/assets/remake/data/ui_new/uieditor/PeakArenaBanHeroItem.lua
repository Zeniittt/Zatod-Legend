ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaBanHeroItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(117.5, 135)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 118, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_ban_bg.png",
      name = "name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(107.5, 107.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 27.5)
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
      name = "label_hero_name",
      z = 0,
      parent = "name_bg",
      text = T("\232\139\177\233\155\132\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.76, x = 0.76},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.86, h = 36.48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero",
      res = "UI/alpha/1080P/toparena/toparena_ban_symbol_1.png",
      name = "image_ban_Tag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.5, 17.5)
    }
  }
}
