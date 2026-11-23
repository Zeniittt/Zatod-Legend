ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_3_kindoms_skin_page = {
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
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 534.5, h = 122},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_title_1.png",
      name = "title",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(607, 572)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 318.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_title_2.png",
      name = "bg_title_sub",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(625, 505)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_time_bg.png",
      name = "bg_time",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(905.5, 542)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 213),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time",
      z = 5,
      parent = "image_bg",
      text = T("\229\137\169\228\189\153"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(836, 537.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(804, 404)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(288, 166)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 393},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_item",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_list_shade.png",
      name = "right",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(789.5, 173)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 189.5, h = 393},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_item",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_list_shade.png",
      name = "left",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 198.5)
    }
  }
}
