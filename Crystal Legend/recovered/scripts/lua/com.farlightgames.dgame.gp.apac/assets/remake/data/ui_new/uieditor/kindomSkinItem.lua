ed.uieditor = ed.uieditor or {}
ed.uieditor.kindomSkinItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 267.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_frame_shade.png",
      name = "mask",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 283},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_frame1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, 120.25)
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
      name = "rank",
      z = 0,
      parent = "bg",
      text = T("\231\165\158\232\175\157"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, 233)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\228\187\153\229\165\179\233\190\153\239\188\154\232\178\130\232\157\137"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(26.5, 198)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186.5, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_button.png",
      name = "btn_get",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_have.png",
      name = "btn_got",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, 8.5)
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
      name = "label_get",
      z = 0,
      parent = "btn_get",
      text = T("\229\142\187\232\142\183\229\143\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_get",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_arrow.png",
      name = "ImageView_709",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.75, 24.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(102, 60, 27),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_got",
      z = 0,
      parent = "btn_got",
      text = T("\229\183\178\230\139\165\230\156\137"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 29.5)
    }
  }
}
