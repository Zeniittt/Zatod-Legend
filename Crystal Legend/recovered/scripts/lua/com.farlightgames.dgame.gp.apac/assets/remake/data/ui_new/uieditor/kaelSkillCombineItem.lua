ed.uieditor = ed.uieditor or {}
ed.uieditor.kaelSkillCombineItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 38)
    },
    t = "Layer",
    base = {name = "panel_bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-100, -19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.45, x = 0.45},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "img_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 18.5)
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
      name = "label_skill",
      z = 0,
      parent = "panel_bg",
      text = T("\229\175\146\229\134\176\230\156\175"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(41.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.68, x = 0.68},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.16, h = 26.18},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_bg",
      res = "UI/alpha/1080P/tag/Kael_ice.png",
      name = "img_element_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.68, x = 0.68},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.16, h = 26.18},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_bg",
      res = "UI/alpha/1080P/tag/Kael_ice.png",
      name = "img_element_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.68, x = 0.68},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.16, h = 26.18},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_bg",
      res = "UI/alpha/1080P/tag/Kael_ice.png",
      name = "img_element_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 18)
    }
  }
}
