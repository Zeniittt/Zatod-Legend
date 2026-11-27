ed.uieditor = ed.uieditor or {}
ed.uieditor.dreamland_rewards_pop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(583.5, 382)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.5, 20.5, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "ImageView_6217",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509.5, 265.5)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1.22, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.5, h = 567.91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/mail/mail_lin.png",
      name = "ImageView_6218",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(510, 391)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 561, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dreamland/dream_rewards_title_img.png",
      name = "ImageView_6219",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509.5, 422.5)
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
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(781.5, 438.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 350)
    },
    t = "Layer",
    base = {
      name = "btn_page_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(127.5, 94)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6221",
      z = 0,
      parent = "ImageView_6219",
      text = T("\230\160\185\230\141\174\230\175\143\229\164\169\230\142\146\229\144\141\231\187\147\231\174\151\230\151\182\231\154\132\230\142\146\229\144\141\229\143\145\230\148\190\229\165\150\229\138\177\233\130\174\228\187\182\239\188\140\232\175\166\231\187\134\229\165\150\229\138\177\232\167\132\229\136\153\229\166\130\228\184\139"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(9.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(552, 300)
    },
    t = "Layer",
    base = {name = "item_list", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(234, 88.5)
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
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_6223",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_daily_reward_title",
      z = 0,
      parent = "ImageView_6219",
      text = T("\230\175\143\230\151\165\230\142\146\229\144\141\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 40.5)
    }
  }
}
