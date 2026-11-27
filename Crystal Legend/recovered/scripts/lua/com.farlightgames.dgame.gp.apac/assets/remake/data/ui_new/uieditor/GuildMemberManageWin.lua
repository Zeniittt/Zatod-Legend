ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMemberManageWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(585.5, 350)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
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
      fix_scale = {y = 0.9, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 28.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 323.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line2",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 322.5)
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
      name = "title",
      z = 1,
      parent = "bg",
      text = T("\230\136\144\229\145\152\231\174\161\231\144\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 324)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.75, 322.5)
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
      position = ccp(567.25, 334)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 255)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_item",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9.png",
      capInsets = CCRectMake(25, 104, 25, 104)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 146)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/manage_unselected.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127.75, 286.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/manage_unselected.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 286.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/manage_unselected.png",
      name = "btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(457.75, 286.5)
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
      name = "num",
      z = 0,
      parent = "bg_item",
      text = "10/50",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(305.5, 244)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "member",
      z = 0,
      parent = "bg_item",
      text = T("\229\133\172\228\188\154\230\136\144\229\145\152\230\149\176\233\135\143:"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(259.5, 244)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(554, 232)
    },
    t = "Layer",
    base = {
      parent = "bg_item",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn1",
      res = "UI/alpha/1080P/guild/manage_selected.png",
      name = "btn_select1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 18.75)
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
      name = "label1",
      z = 0,
      parent = "btn1",
      text = T("\230\156\128\229\144\142\228\184\138\231\186\191\230\151\182\233\151\180"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 23.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn2",
      res = "UI/alpha/1080P/guild/manage_selected.png",
      name = "btn_select2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 18.75)
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
      name = "label2",
      z = 0,
      parent = "btn2",
      text = T("\228\184\131\230\151\165\232\180\161\231\140\174\230\180\187\232\183\131"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 23.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn3",
      res = "UI/alpha/1080P/guild/manage_selected.png",
      name = "btn_select3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 18.75)
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
      name = "label3",
      z = 0,
      parent = "btn3",
      text = T("\229\155\162\230\156\172\230\140\145\230\136\152\230\172\161\230\149\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 23.75)
    }
  }
}
