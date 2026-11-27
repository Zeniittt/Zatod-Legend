ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildSettingWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430, 410)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 241)
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
      name = "deco_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303, 385)
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
      parent = "bg",
      text = T("\229\133\172\228\188\154\232\174\190\231\189\174"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 385)
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
      name = "deco_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127, 385)
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
      name = "label_name",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\229\144\141\231\167\176\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 247)
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
      name = "label_avatar",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\229\155\190\230\160\135\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 336)
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
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(130, 246.5)
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
      name = "label_type",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\231\177\187\229\158\139\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 198)
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
      name = "label_level",
      z = 0,
      parent = "bg",
      text = T("\230\156\128\229\176\143\230\136\152\233\152\159\231\173\137\231\186\167\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 146)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_change_avatar",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 335.5)
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
      position = ccp(414, 394)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_change_frame",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 291)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_change_name",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 247)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.5, 314)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_ok",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 53.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 95)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2.49999952, x = 13.9999962},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209.999943, h = 37.4999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chat/chat_replay_input_bg.png",
      name = "bg_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(278, 197)
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
      name = "btn_type_left",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178, 196)
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
      name = "label_change_avatar",
      z = 0,
      parent = "btn_change_avatar",
      text = T("\228\191\174\230\148\185\229\155\190\230\160\135"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 21)
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
      name = "btn_type_right",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378, 195)
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
      name = "type",
      z = 1,
      parent = "bg",
      text = T("\233\156\128\232\166\129\233\170\140\232\175\129\230\137\141\229\143\175\229\138\160\229\133\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277, 197.5)
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
      fix_scale = {y = 2.49999952, x = 13.9999962},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209.999943, h = 37.4999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chat/chat_replay_input_bg.png",
      name = "bg_level",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.5, 147)
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
      name = "btn_level_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178.5, 146)
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
      name = "btn_right_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379, 146)
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
      name = "level",
      z = 0,
      parent = "bg",
      text = "100",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.5, 148)
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
      name = "label_change_name",
      z = 0,
      parent = "btn_change_name",
      text = T("\228\191\174\230\148\185\229\144\141\231\167\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 21)
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
      name = "label_ok",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174\232\174\164\228\191\174\230\148\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.199998368, h = 35.69999405},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_type_left",
      res = "UI/alpha/1080P/chat/left_arrow.png",
      name = "ImageView_12667",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.799999952},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 27.199998368, h = 35.69999405},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_type_right",
      res = "UI/alpha/1080P/chat/left_arrow.png",
      name = "ImageView_12668",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.199998368, h = 35.69999405},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_level_left",
      res = "UI/alpha/1080P/chat/left_arrow.png",
      name = "ImageView_12667",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.799999952},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 27.199998368, h = 35.69999405},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_right_left",
      res = "UI/alpha/1080P/chat/left_arrow.png",
      name = "ImageView_12668",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 27.5)
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
      name = "label_change_frame",
      z = 0,
      parent = "btn_change_frame",
      text = T("\228\191\174\230\148\185\229\164\180\229\131\143\230\161\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 20)
    }
  }
}
