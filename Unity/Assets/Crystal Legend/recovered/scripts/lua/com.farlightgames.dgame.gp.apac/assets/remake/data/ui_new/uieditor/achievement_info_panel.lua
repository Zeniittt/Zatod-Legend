ed.uieditor = ed.uieditor or {}
ed.uieditor.achievement_info_panel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(335, 90)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 15, 0.5, 0.5),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299.5, 160)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 31.5, h = 33.5},
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
      normal = "UI/alpha/1080P/common/common_tips_button_close_1.png",
      name = "btn_close",
      z = 0,
      parent = "image_bg",
      text = "",
      press = "UI/alpha/1080P/common/common_tips_button_close_2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333.5, 80.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\136\144\229\176\177\232\175\166\230\131\133"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 76)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 3.099999, x = 3.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 323.95, h = 49.599984},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/HVGA/pvp/pvp_replay_name_bg.png",
      name = "image_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.5, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_achievement",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(33, 31.5)
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
      name = "label_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\137\141\233\157\162\229\184\136\229\190\146"),
      size = 11
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(62.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\232\191\158\231\187\1737\229\164\169\227\128\130\227\128\130\227\128\130\232\191\158\231\187\1737\229\164\169\227\128\130\227\128\130\227\128\130\232\191\158\231\187\1737\229\164\169\227\128\130\227\128\130\227\128\130"),
      size = 10
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(63, 30.5)
    }
  }
}
