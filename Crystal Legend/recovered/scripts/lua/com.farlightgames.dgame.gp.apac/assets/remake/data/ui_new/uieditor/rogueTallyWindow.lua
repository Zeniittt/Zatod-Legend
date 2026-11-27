ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueTallyWindow = {
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
      res = "UI/alpha/1080P/rogue/bless/bless_choose_bg.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(861.5, 632)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_bg_1",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_tally_bg.png",
      capInsets = CCRectMake(0, 500, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(585, 719)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 596.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_51626",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(535, 425)
    },
    t = "Layer",
    base = {
      parent = "image_bg_1",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(164.75, 27)
    }
  }
}
