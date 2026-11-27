ed.uieditor = ed.uieditor or {}
ed.uieditor.chatSettingWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(440, 261)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 50),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(260.5, 161.5)
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
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\232\129\138\229\164\169\232\174\190\231\189\174"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220, 226.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "left_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141, 225.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "right_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299, 225)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip",
      z = 0,
      parent = "bg",
      text = T("\230\143\144\233\134\146\239\188\154\231\166\129\230\173\162\229\144\142\229\176\134\230\151\160\230\179\149\230\148\182\229\136\176\229\165\189\229\143\139\233\130\128\232\175\183"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 80,
      visible = true,
      scaleSize = CCSizeMake(395, 46)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_640",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/equip_stencil.png",
      capInsets = CCRectMake(10, 10, 19, 19)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.5, 168.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 80,
      visible = true,
      scaleSize = CCSizeMake(395, 46)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_640_Copy0",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/equip_stencil.png",
      capInsets = CCRectMake(10, 10, 19, 19)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.5, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_640",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "ImageView_641",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 23)
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
      name = "Label_642",
      z = 0,
      parent = "ImageView_640",
      text = T("\229\133\129\232\174\184\233\153\140\231\148\159\228\186\186\231\167\129\232\129\138"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(41.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.8000047, h = 31.50000225},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_640",
      res = "UI/alpha/1080P/setting/setting_button_on.png",
      name = "btn_other",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_640_Copy0",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "ImageView_6411",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 23)
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
      name = "Label_6421",
      z = 0,
      parent = "ImageView_640_Copy0",
      text = T("\229\133\129\232\174\184\230\142\165\230\148\182\229\165\189\229\143\139\233\130\128\232\175\183"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(41.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.8000047, h = 31.50000225},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_640_Copy0",
      res = "UI/alpha/1080P/setting/setting_button_on.png",
      name = "btn_friend",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_other",
      res = "UI/alpha/1080P/setting/setting_button.png",
      name = "icon_other",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_friend",
      res = "UI/alpha/1080P/setting/setting_button.png",
      name = "icon_friend",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 11.25)
    }
  }
}
