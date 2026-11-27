ed.uieditor = ed.uieditor or {}
ed.uieditor.petHouseMainScene = {
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
      res = "UI/alpha/1080P/pet/pet_room_bg.jpg",
      name = "bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_light1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(882, 660.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_light2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(985, 664)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(135, 220)
    },
    t = "Layer",
    base = {
      name = "layer_draglist",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(821, 246)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_light4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(172.5, 670.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_light3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(293.5, 668.5)
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
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "scene_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 504.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187, h = 298.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_draglist",
      res = "UI/alpha/1080P/pet/pet_room_not_selected.png",
      name = "ImageView_7731",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-25, -46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "scene_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/campaign_map_bg_1.png",
      name = "shop_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(873.5, 85.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "shop_btn",
      res = "UI/alpha/1080P/pet/pet_exchange_tag.png",
      name = "shop_image",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "shop_btn",
      res = "UI/alpha/1080P/campaign/campaign_map_bg.png",
      name = "shop_label_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 11)
    }
  }
}
