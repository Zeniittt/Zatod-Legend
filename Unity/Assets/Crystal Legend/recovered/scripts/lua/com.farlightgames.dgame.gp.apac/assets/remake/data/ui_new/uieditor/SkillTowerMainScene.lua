ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerMainScene = {
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
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.5, 510)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/bg_btn_reward.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(742.5, 509.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_title",
      name = "layer_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-84.75, -486.75)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(89.5, 20)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(14.5, 10.5, 15, 30.5),
      res = "UI/alpha/1080P/package/bg_soldout.png",
      name = "bg_btn_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(884, 511)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_4586",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/milestone_loot_raise.png",
      name = "buff1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352.5, 503.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_energe.png",
      name = "buff2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390, 503.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4587",
      z = 0,
      parent = "btn_reward",
      text = T("\233\155\134\230\152\159\229\165\150\229\138\177"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 32.4},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_double.png",
      name = "buff3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(427.5, 504)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_energe.png",
      name = "buff4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(465, 504)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 430)
    },
    t = "Layer",
    base = {
      name = "layer_tower",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-1, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109, h = 34},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/bg_btn_reward.png",
      name = "btn_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(619.5, 509.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn_power",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "icon_add_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn_power",
      res = "UI/alpha/1080P/icon/fancytower_candle.png",
      name = "icon_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_power",
      z = 0,
      parent = "bg_btn_power",
      text = "56/80",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buff",
      res = "UI/alpha/1080P/skilltower/icon_star.png",
      name = "icon_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "btn_buff",
      text = T("\229\185\187\229\162\131\232\181\144\231\166\143"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 19)
    }
  }
}
