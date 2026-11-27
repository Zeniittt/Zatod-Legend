ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_choose_wukong_page = {
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
      res = "UI/alpha/1080P/activity/wukong/bg.jpg",
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
      name = "Label_time",
      z = 0,
      parent = "page_lay",
      text = T("\229\137\169\228\189\153 "),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(716.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(510, 345)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(454, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_mod",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(335, 79)
    }
  }
}
