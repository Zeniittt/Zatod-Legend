ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_reset_reward_window = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(842, 387)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(280.5, 110, 280.5, 110),
      res = "UI/alpha/1080P/fireforge/get2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 339)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 113, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/legendequip/reset/art.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(419.5, 316)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(900, 180)
    },
    t = "Layer",
    base = {
      name = "panel_content",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(31.5, 210)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.88, x = 0.88},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137.72, h = 61.16},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      name = "btn_confirm",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 121)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 17.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(171, 273)
    }
  }
}
