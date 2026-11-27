ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_gift4jump_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
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
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/gift4_jump/bg.jpg",
      name = "ImageView_27",
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
      fix_wh = {w = 130.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/gift4_jump/button.png",
      name = "goto_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(857, 126)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(572, 93.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "str_bg",
      z = 0,
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/gift4_jump/textbg.png",
      capInsets = CCRectMake(86, 0, 250, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505, 130)
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
      name = "Label_btn",
      z = 0,
      parent = "goto_btn",
      text = T("\229\137\141\229\190\128\232\180\173\228\185\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 60)
    },
    t = "Layer",
    base = {
      parent = "str_bg",
      name = "panel_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(37.5, 16.75)
    }
  }
}
