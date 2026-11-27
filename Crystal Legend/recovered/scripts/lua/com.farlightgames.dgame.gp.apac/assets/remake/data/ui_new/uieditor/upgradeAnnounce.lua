ed.uieditor = ed.uieditor or {}
ed.uieditor.upgradeAnnounce = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer_main", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(559, 262.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "layer_main",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 25, 10, 25)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 414)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 261.75002094, h = 78.00000624},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/hero/hero_rankup_word.png",
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 419.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 348, h = 347.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/hero/hero_rankup_light.png",
      name = "light",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470.5, 411)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 563, h = 124},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/hero/hero_rankup_hero_bg.png",
      name = "bg_heroicon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 355)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(517, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "hp",
      z = 1,
      parent = "layer_main",
      res = "UI/alpha/1080P/hero/hero_upgrade_bg_3.png",
      capInsets = CCRectMake(25, 0, 5, 35)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 258)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(517, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "gs",
      z = 1,
      parent = "layer_main",
      res = "UI/alpha/1080P/hero/hero_upgrade_bg_4.png",
      capInsets = CCRectMake(25, 0, 5, 35)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 223)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(559, 377)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg1",
      z = 0,
      parent = "layer_main",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 25, 10, 25)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 414.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.5, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(281.5, 42)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrname1",
      z = 0,
      parent = "hp",
      text = T("\231\148\159\229\145\189\229\128\188\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "to1",
      z = 0,
      parent = "hp",
      text = "874",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "from1",
      z = 0,
      parent = "hp",
      text = "611",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 19.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "hp",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrname2",
      z = 0,
      parent = "gs",
      text = T("\230\136\152\230\150\151\229\138\155\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "to2",
      z = 0,
      parent = "gs",
      text = "297",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "from2",
      z = 0,
      parent = "gs",
      text = "94",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 19.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "gs",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(511.5, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "bg1",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(20, 0, 200, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.5, 152)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "icon_skill",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.5, 87)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 234.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg1",
      res = "UI/alpha/1080P/hero/hero_rankup_skill_bg.png",
      name = "left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 83)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 234.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg1",
      res = "UI/alpha/1080P/hero/hero_rankup_skill_bg.png",
      name = "right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(454, 83)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_skill",
      z = 0,
      parent = "bg1",
      text = T("\232\167\163\233\148\129\230\150\176\230\138\128\232\131\189  \228\186\161\231\129\181\229\143\172\229\148\164!"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.5, 29)
    }
  }
}
