ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetail = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(867.5, 479.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 36.5, 310),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(485, 252)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(850.25, 463.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2427",
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
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_tab",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(436.75, 241.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 86.25, h = 74.25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_right",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(934.5, 282.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_tab",
      res = "UI/alpha/1080P/hero/hero_tab_unchoose.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-349.5, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_tab",
      res = "UI/alpha/1080P/hero/hero_tab_unchoose.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-213, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_tab",
      res = "UI/alpha/1080P/hero/hero_tab_unchoose.png",
      name = "btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140.5, 51.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_select1",
      z = 1,
      parent = "btn1",
      res = "UI/alpha/1080P/hero/hero_tab_choose.png",
      capInsets = CCRectMake(0, 20, 0.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(64.5, -5.75)
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
      name = "label_btn1",
      z = 0,
      parent = "btn1",
      text = T("\229\159\186\231\161\128"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59.5, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_tab",
      res = "UI/alpha/1080P/hero/hero_tab_unchoose.png",
      name = "btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.5, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.199998008, h = 37.99999772},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn1",
      res = "UI/alpha/1080P/hero/icon_hero_unavailable.png",
      name = "icon_hero_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(59, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 86.25, h = 74.25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_left",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 282.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_tab",
      res = "UI/alpha/1080P/hero/hero_tab_unchoose.png",
      name = "btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-78, 257.5)
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
      name = "label_btn2",
      z = 0,
      parent = "btn2",
      text = T("\230\138\128\232\131\189"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(52, 54, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_select1",
      z = 0,
      parent = "btn_select1",
      text = T("\229\159\186\231\161\128"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(63.75, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.35, h = 42.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_select1",
      res = "UI/alpha/1080P/hero/icon_hero.png",
      name = "icon_hero_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(140.5, 51.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_select2",
      z = 1,
      parent = "btn2",
      res = "UI/alpha/1080P/hero/hero_tab_choose.png",
      capInsets = CCRectMake(0, 20, 0.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(64.5, -5.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.199997768, h = 37.199997768},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn2",
      res = "UI/alpha/1080P/hero/icon_skill_unavailable.png",
      name = "icon_skill_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(59, 14.75)
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
      name = "label_btn3",
      z = 0,
      parent = "btn3",
      text = T("\231\154\174\232\130\164"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(140.5, 51.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_select3",
      z = 1,
      parent = "btn3",
      res = "UI/alpha/1080P/hero/hero_tab_choose.png",
      capInsets = CCRectMake(0, 20, 0.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(64.5, -5.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.199997888, h = 35.599997864},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn3",
      res = "UI/alpha/1080P/hero/icon_skinnew_unavailable.png",
      name = "icon_skin_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(59, 14.25)
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
      name = "label_btn4",
      z = 0,
      parent = "btn4",
      text = T("\232\167\137\233\134\146"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(52, 54, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_select2",
      z = 0,
      parent = "btn_select2",
      text = T("\230\138\128\232\131\189"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(64.75, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.85, h = 41.85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_select2",
      res = "UI/alpha/1080P/hero/icon_skill.png",
      name = "icon_skill_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.599997744, h = 37.599997744},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn4",
      res = "UI/alpha/1080P/shard/icon_shard_unavailable.png",
      name = "icon_shard_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(59, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(140.5, 51.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_select4",
      z = 1,
      parent = "btn4",
      res = "UI/alpha/1080P/hero/hero_tab_choose.png",
      capInsets = CCRectMake(0, 20, 0.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(64.5, -5.75)
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
      name = "label_btn5",
      z = 0,
      parent = "btn5",
      text = T("\230\152\159\231\155\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.99999784, h = 35.99999784},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn5",
      res = "UI/alpha/1080P/astrolabe/astrolabe_icon.png",
      name = "icon_pet_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(59, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(140.5, 51.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_select5",
      z = 1,
      parent = "btn5",
      res = "UI/alpha/1080P/hero/hero_tab_choose.png",
      capInsets = CCRectMake(0, 20, 0.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(64.5, -5.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(52, 54, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_select3",
      z = 0,
      parent = "btn_select3",
      text = T("\231\154\174\232\130\164"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(64.25, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.6, h = 40.05},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_select3",
      res = "UI/alpha/1080P/hero/icon_skinnew.png",
      name = "icon_skin_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(52, 54, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_select4",
      z = 0,
      parent = "btn_select4",
      text = T("\232\167\137\233\134\146"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(64.25, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.3, h = 42.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_select4",
      res = "UI/alpha/1080P/shard/icon_shard.png",
      name = "icon_shard_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(52, 54, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_select5",
      z = 0,
      parent = "btn_select5",
      text = T("\230\152\159\231\155\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(64.25, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_select5",
      res = "UI/alpha/1080P/astrolabe/astrolabe_icon_selected.png",
      name = "icon_pet_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(63.75, 22.5)
    }
  }
}
