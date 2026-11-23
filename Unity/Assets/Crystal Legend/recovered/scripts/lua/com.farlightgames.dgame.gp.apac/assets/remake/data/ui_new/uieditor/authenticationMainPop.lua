ed.uieditor = ed.uieditor or {}
ed.uieditor.authenticationMainPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 280)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(143, 90.5, 1, 1),
      res = "UI/alpha/1080P/common/global/bg.png",
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
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(543.5, 277)
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
      name = "layer_main",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(275.5, 148)
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
      parent = "bg",
      name = "layer_server",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(275.5, 148)
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
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(275.5, 148)
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
      parent = "bg",
      name = "layer_code",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(275.5, 148)
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
      parent = "bg",
      name = "layer_select",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(275, 140)
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
      parent = "bg",
      name = "layer_auth_confirm",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(275, 140)
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
      parent = "layer_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-80.5, 108.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(510, 135)
    },
    t = "Layer",
    base = {
      parent = "layer_main",
      name = "layer_text",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-255.5, -52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 108.5)
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
      name = "title",
      z = 0,
      parent = "layer_title",
      text = T("\232\174\164\232\175\129\230\180\187\229\138\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 108.5)
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
      name = "ImageView_110",
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
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 42.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_soulhunter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-167.5, -90)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 42.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_legend",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-8, -90)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(155, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_Authentication",
      z = 0,
      parent = "layer_main",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, -89.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 542, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/global/authentication/title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 108.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(189.5, 51)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_GetAuthentication",
      z = 0,
      parent = "layer_server",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1, -93.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 24},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/global/authentication/back.png",
      name = "title_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-240, 108.5)
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
      name = "label_server",
      z = 0,
      parent = "layer_server",
      text = "server",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-104.5, 50)
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
      name = "label_userid",
      z = 0,
      parent = "layer_server",
      text = "userid",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-104.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 201.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_server",
      res = "UI/alpha/1080P/common/global/authentication/write2.png",
      name = "server_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 201.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_server",
      res = "UI/alpha/1080P/common/global/authentication/write1.png",
      name = "userid_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(189.5, 52)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_confirm",
      z = 0,
      parent = "layer_code",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, -93.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(290, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "code_bg",
      z = 0,
      parent = "layer_code",
      res = "UI/alpha/1080P/common/global/authentication/write1.png",
      capInsets = CCRectMake(20, 20, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, 23)
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
      parent = "layer_code",
      name = "layer_confirm",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148, h = 231.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_select",
      res = "UI/alpha/1080P/common/global/authentication/bg.png",
      name = "select_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-196, -18.5)
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
      name = "label_server_block",
      z = 0,
      parent = "layer_select",
      text = T("\230\156\141\229\138\161\229\153\168141--150\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-85, 74)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 170)
    },
    t = "Layer",
    base = {
      parent = "layer_select",
      name = "block_list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-95, -116)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(189.5, 51)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_timeLimit",
      z = 0,
      parent = "layer_server",
      res = "UI/alpha/1080P/common/button_big_grey.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1, -93.5)
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
      name = "text_auth_server",
      z = 0,
      parent = "layer_auth_confirm",
      text = "server:",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-223.5, 57)
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
      name = "text_auth_id",
      z = 0,
      parent = "layer_auth_confirm",
      text = "userid:",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-11, 57)
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
      name = "text_auth_name",
      z = 0,
      parent = "layer_auth_confirm",
      text = "name:",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147, 57)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_auth_server",
      z = 0,
      parent = "layer_auth_confirm",
      text = T("141\229\140\186 \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-195, 57)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_auth_id",
      z = 0,
      parent = "layer_auth_confirm",
      text = "xxxx",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.5, 57)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_auth_name",
      z = 0,
      parent = "layer_auth_confirm",
      text = "xxxx",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(175, 57)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(510, 75)
    },
    t = "Layer",
    base = {
      parent = "layer_auth_confirm",
      name = "layer_auth_confirm_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-255, -53.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(189.5, 51)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_auth_confirm",
      z = 0,
      parent = "layer_auth_confirm",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1.5, -85)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_soulhunter",
      z = 0,
      parent = "btn_soulhunter",
      text = T("Soulhunter\232\174\164\232\175\129"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_legend",
      z = 0,
      parent = "btn_legend",
      text = T("\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\232\174\164\232\175\129"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_Authentication",
      z = 0,
      parent = "btn_Authentication",
      text = "Authentication Code",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_GetAuthentication",
      z = 0,
      parent = "btn_GetAuthentication",
      text = "Get Authentication Code",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "server_bg",
      res = "UI/alpha/1080P/common/global/authentication/pull_down.png",
      name = "ImageView_18751",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.25, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(134, 132, 119),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name",
      z = 0,
      parent = "server_bg",
      text = T("\233\128\137\230\139\169\230\156\141\229\138\161\229\153\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(134, 132, 119),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "userid_text",
      z = 0,
      parent = "userid_bg",
      text = T("\229\161\171\229\134\153\228\189\160\231\154\132userid"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.75, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\231\161\174\232\174\164\233\162\134\229\143\150\229\136\176\229\189\147\229\137\141\232\167\146\232\137\178"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(134, 132, 119),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "code_text",
      z = 0,
      parent = "code_bg",
      text = T("\229\161\171\229\134\153\228\189\160\231\154\132Authentication Code"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 25)
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
      name = "server1",
      z = 0,
      parent = "layer_confirm",
      text = "server:",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-223, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server2",
      z = 0,
      parent = "layer_confirm",
      text = T("141\229\140\186 \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-190.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "userid2",
      z = 0,
      parent = "layer_confirm",
      text = "136549",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21.5, 50)
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
      name = "userid1",
      z = 0,
      parent = "layer_confirm",
      text = "userid:",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-11, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name2",
      z = 0,
      parent = "layer_confirm",
      text = "soulhunter",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(170, 50)
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
      name = "name1",
      z = 0,
      parent = "layer_confirm",
      text = "name:",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(510, 80)
    },
    t = "Layer",
    base = {
      parent = "layer_confirm",
      name = "layer_confirm_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-255, -60.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(201.5, 37)
    },
    t = "Layer",
    base = {
      parent = "userid_bg",
      name = "userid_input",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.25, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(290, 50)
    },
    t = "Layer",
    base = {
      parent = "code_bg",
      name = "code_input",
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
      scaleSize = CCSizeMake(189.5, 52)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_confirm_again",
      z = 0,
      parent = "layer_confirm",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, -93.5)
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
      name = "label_all_server",
      z = 0,
      parent = "select_bg",
      text = T("\230\137\128\230\156\137\230\156\141\229\138\161\229\153\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 206.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(148.5, 175)
    },
    t = "Layer",
    base = {
      parent = "select_bg",
      name = "side_list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 101.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.5, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.5, 101.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.5, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "block_list_layer",
      res = "UI/alpha/1080P/common/global/authentication/cut_off.png",
      name = "cutoff8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name1",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 150)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name3",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 117)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name5",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 84)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name7",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 51)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name9",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name2",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.5, 150)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name4",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.5, 117)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name6",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.5, 84)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name8",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.5, 51)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 170, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name10",
      z = 0,
      parent = "block_list_layer",
      text = T("141\229\140\186  \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_timeLimit",
      z = 0,
      parent = "btn_timeLimit",
      text = "Get Authentication Code",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 27)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_auth_confirm",
      z = 0,
      parent = "btn_auth_confirm",
      text = T("\231\161\174\232\174\164\230\151\160\232\175\175(5)"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 27)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_confirm_again",
      z = 0,
      parent = "btn_confirm_again",
      text = T("\231\161\174\232\174\164\233\162\134\229\143\150\229\136\176\229\189\147\229\137\141\232\167\146\232\137\178"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 27.5)
    }
  }
}
