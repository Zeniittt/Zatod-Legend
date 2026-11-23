ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_lottery_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1168, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/lottery/lottery_bg.jpg",
      name = "ImageView_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 481.5, h = 455.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bg",
      res = "UI/alpha/1080P/lottery/lottery_reward_bg.png",
      name = "ImageView_right",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(830, 371)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(322, 241)
    },
    t = "Layer",
    base = {
      parent = "ImageView_right",
      name = "panel_crad_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(80.25, 74.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 271.5, h = 105.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_right",
      res = "UI/alpha/1080P/lottery/lottery_title_bg.png",
      name = "ImageView_2969",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.25, 392.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(396.5, 444.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_bg",
      name = "ImageView_lift",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_right",
      res = "UI/alpha/1080P/lottery/lottery_level_bg.png",
      name = "ImageView_2970",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.25, 328.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 244.5, h = 95.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2969",
      res = "UI/alpha/1080P/lottery/lottery_title_char.png",
      name = "ImageView_3081",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.75, 67.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253, h = 92},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2969",
      res = "UI/alpha/1080P/lottery/lottery_title_light_1.png",
      name = "ImageView_3082",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.75, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 25)
    },
    t = "Layer",
    base = {
      parent = "ImageView_right",
      name = "Panel_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(88.25, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 271.5, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2969",
      res = "UI/alpha/1080P/lottery/lottery_title_light_2.png",
      name = "ImageView_3082_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.75, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.65, h = 50.4},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "Image_refresh_btn",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(730.5, 84)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_open",
      z = 0,
      parent = "ImageView_right",
      text = T("\231\130\185\229\135\187\228\188\160\233\128\129\233\151\168\229\143\175\232\191\155\229\133\165\228\184\139\228\184\128\229\177\130"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240.75, 57.75)
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
      name = "Label_time",
      z = 2,
      parent = "ImageView_lift",
      text = "",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 20.5)
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
      name = "Label_newlayer",
      z = 99,
      parent = "ImageView_2970",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(60, 52, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_newlayer_des1",
      z = 0,
      parent = "ImageView_2970",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 224),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_count_item",
      z = 99,
      parent = "ImageView_lift",
      text = "1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.5, 83)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 160, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_lift",
      res = "UI/alpha/1080P/lottery/lottery_viewreward_bg.png",
      name = "ImageView_2965",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.5, 193.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_consume_des1",
      z = 0,
      parent = "Panel_tag",
      text = T("\231\130\185\229\135\187\230\182\136\232\128\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_tag",
      res = "UI/alpha/1080P/lottery/lottery_meat_icon_s.png",
      name = "icon_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(59, 39, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_count_item_des1",
      z = 0,
      parent = "ImageView_lift",
      text = T("\231\191\187\231\137\140"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 83.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(79, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2982",
      z = 0,
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      capInsets = CCRectMake(20, 0, 8, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(731, 507)
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
      name = "Label_refresh_btn",
      z = 0,
      parent = "Image_refresh_btn",
      text = T("\229\188\128\229\167\139\230\180\151\231\137\140"),
      size = 33
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_lift",
      res = "UI/alpha/1080P/lottery/lottery_time.png",
      name = "ImageView_2968",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 21.5)
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
      parent = "ImageView_lift",
      name = "Panel_lift_talk",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26, 337.5)
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
      parent = "ImageView_lift",
      name = "Panel_right_talk",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(180.5, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.550001645, h = 31.850001715},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2965",
      res = "UI/alpha/1080P/common/GuildHero_property.png",
      name = "Image_what_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 12.75)
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
      name = "Label_2966",
      z = 0,
      parent = "ImageView_2965",
      text = T("\230\159\165\231\156\139\229\144\137\229\133\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(59, 39, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_count_item_des2",
      z = 0,
      parent = "ImageView_lift",
      text = T("\230\172\161\229\144\142\229\143\175\232\142\183\229\190\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206, 83)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(60, 52, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_newlayer_des2",
      z = 0,
      parent = "ImageView_2970",
      text = T("\229\177\130"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.75, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_consume_des2",
      z = 0,
      parent = "Panel_tag",
      text = T("\229\188\128\229\167\139\231\191\187\231\137\140"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(243, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2982",
      res = "UI/alpha/1080P/lottery/lottery_meat_icon_s.png",
      name = "ImageView_2983",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(143.5, 52.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Image_lift_talk",
      z = 0,
      parent = "Panel_lift_talk",
      res = "UI/alpha/1080P/lottery/lottery_bubble.png",
      capInsets = CCRectMake(25, 0, 35, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(73.5, 26.5)
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
      name = "Label_lift_talk",
      z = 3,
      parent = "Panel_lift_talk",
      text = T("\228\184\141\239\188\140\230\152\175\230\136\145\229\143\145\232\180\162\228\186\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80.5, 32.5)
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
      name = "Label_coins",
      z = 0,
      parent = "ImageView_2982",
      text = "0",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(109, 52.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Image_right_talk",
      z = 0,
      parent = "Panel_right_talk",
      res = "UI/alpha/1080P/lottery/lottery_bubble.png",
      capInsets = CCRectMake(25, 0, 35, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(57, 25.5)
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
      name = "Label_right_talk",
      z = 3,
      parent = "Panel_right_talk",
      text = T("\230\136\145\228\187\172\229\143\145\232\180\162\229\149\166\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(70, 32)
    }
  }
}
