ed.uieditor = ed.uieditor or {}
ed.uieditor.arenaEnemyItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(530, 83)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 543, 77),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bg",
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
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72.10000515, h = 76.30000545},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/main_head_frame_kings_s8.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "guildName",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(88.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "rank",
      z = 0,
      parent = "bg",
      text = T("\230\142\146\229\144\141:"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(85, 31)
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
      name = "rankNum",
      z = 0,
      parent = "bg",
      text = "648",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/ce_bg.png",
      name = "bg_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.5, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gs",
      z = 0,
      parent = "bg",
      text = T("\230\136\152\230\150\151\229\138\155:"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(385, 66.5)
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
      name = "gs_num",
      z = 0,
      parent = "bg",
      text = "100,200",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(387.5, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.3, h = 74.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "btn_start",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 40)
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
      name = "name",
      z = 1,
      parent = "bg_gs",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 9.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.5, h = 29.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/sweep.png",
      name = "btn_sweep1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(486, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.5, h = 29.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/sweep_5.png",
      name = "btn_sweep5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(486, 25)
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
      parent = "bg",
      name = "layer_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(196, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.2, h = 36.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_start",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "icon_start",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 225, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start",
      z = 0,
      parent = "btn_start",
      text = T("\230\140\145 \230\136\152"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 225, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_7493",
      z = 0,
      parent = "btn_sweep1",
      text = T("\230\137\171\232\141\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(197, 243, 251),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_7494",
      z = 0,
      parent = "btn_sweep5",
      text = T("\230\137\171\232\141\1615\230\172\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 42.6999939},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/pvp/splitline.png",
      name = "splitline",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(3, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171, 26)
    }
  }
}
