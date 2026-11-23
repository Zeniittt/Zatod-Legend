ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailShard = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_shard",
      z = 0
    },
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
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      parent = "layer_shard",
      name = "panel_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 418, h = 456},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/shard/shard_bg.png",
      name = "ImageView_23548",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248.5, 255.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(373, 48)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_23549",
      z = 0,
      parent = "panel_left",
      res = "UI/alpha/1080P/shard/shard_name.png",
      capInsets = CCRectMake(100, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(249, 456.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      parent = "layer_shard",
      name = "panel_right",
      z = 0
    },
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
      scaleSize = CCSizeMake(250, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_23551",
      z = 0,
      parent = "panel_left",
      res = "UI/alpha/1080P/shard/preview.png",
      capInsets = CCRectMake(100, 5, 79.5, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.5, 61.5)
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
      name = "Label_23550",
      z = 0,
      parent = "ImageView_23549",
      text = T("\229\137\145\229\156\163\229\143\140\229\136\128"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(433.5, 460)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_right_bg",
      z = 0,
      parent = "panel_right",
      res = "UI/alpha/1080P/hero/hero_info_bg_0.png",
      capInsets = CCRectMake(12.5, 0, 29.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673.5, 256.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23552",
      z = 0,
      parent = "ImageView_23551",
      text = T("\229\188\186\229\140\150\229\177\158\230\128\167\233\162\132\232\167\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.199998488, h = 25.199998488},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_23551",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_right",
      res = "UI/alpha/1080P/hero/hero_bg_frame_1.png",
      name = "img_right_bg_2",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(457, 466.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(379, 39.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_title",
      z = 2,
      parent = "panel_right",
      res = "UI/alpha/1080P/shard/shard_lv.png",
      capInsets = CCRectMake(125, 0, 20, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 457.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(218, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_title_2",
      z = 2,
      parent = "panel_right",
      res = "UI/alpha/1080P/shard/title.png",
      capInsets = CCRectMake(50, 0, 9.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 315)
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
      name = "ImageView_23555",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 50,
      visible = true,
      scaleSize = CCSizeMake(429, 290)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_fa_bg",
      z = 0,
      parent = "panel_right",
      res = "UI/alpha/1080P/shard/img_shard_bg.png",
      capInsets = CCRectMake(5, 5, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673.5, 172.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(429, 288)
    },
    t = "Layer",
    base = {
      parent = "panel_right",
      name = "panel_fa",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(459, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(422, 150)
    },
    t = "Layer",
    base = {
      parent = "panel_right",
      name = "panel_skil_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(461, 159)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 223, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "shard_label_level",
      z = 0,
      parent = "img_title",
      text = "",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(189.5, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title",
      res = "UI/alpha/1080P/shard/view_bg.png",
      name = "btn_show_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.5, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(154, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_qh",
      z = 0,
      parent = "panel_right",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(40, 20, 21.5, 1)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_right",
      name = "panel_consume",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(548, 88)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23743",
      z = 0,
      parent = "img_title_2",
      text = T("\229\138\160\230\136\144\230\149\136\230\158\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430.5, 58)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_lv_bg",
      z = 0,
      parent = "panel_right",
      res = "UI/alpha/1080P/shard/shard_lv_bg.png",
      capInsets = CCRectMake(50, 0, 52, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 456)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(431, 109)
    },
    t = "Layer",
    base = {
      parent = "panel_right",
      name = "panel_attr_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(457.5, 318)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 32.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_right",
      res = "UI/alpha/1080P/skill/new/skill_lock_bg.png",
      name = "img_lock_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 378.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_show_attr",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_23561",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253.5, h = 31},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_right",
      res = "UI/alpha/1080P/skill/new/skill_max.png",
      name = "img_lv_max",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 248, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23748",
      z = 0,
      parent = "btn_qh",
      text = T("\229\188\186\229\140\150"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23750",
      z = 0,
      parent = "panel_consume",
      text = T("\230\182\136\232\128\151\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_consume",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "ImageView_23753",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "panel_consume",
      name = "panel_consume_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 236, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23755",
      z = 0,
      parent = "img_lock_bg",
      text = T("\232\167\137\233\134\146\228\185\139\229\144\142\232\142\183\229\190\151\229\138\160\230\136\144\229\177\158\230\128\167"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.5, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 52, h = 53},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/hero/bg_btn1.png",
      name = "btn_add_material1",
      z = 0,
      parent = "panel_right",
      text = "",
      press = "UI/alpha/1080P/hero/bg_btn1.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(838, 117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_add_material1",
      res = "UI/alpha/1080P/skill/skill_icon_fastsupply.png",
      name = "icon_add_material1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 29.5)
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
      name = "label_add_material1",
      z = 0,
      parent = "btn_add_material1",
      text = T("\232\161\165\229\133\133\230\157\144\230\150\153"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 7)
    }
  }
}
