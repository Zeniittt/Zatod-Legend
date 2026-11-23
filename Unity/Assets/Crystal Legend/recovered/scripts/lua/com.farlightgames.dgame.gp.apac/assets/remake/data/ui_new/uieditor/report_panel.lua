ed.uieditor = ed.uieditor or {}
ed.uieditor.report_panel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 175)
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
      position = ccp(256, 153.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\175\183\233\128\137\230\139\169\228\184\190\230\138\165\229\134\133\229\174\185\239\188\154"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(24.5, 157.5)
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
      position = ccp(248.5, 165.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(75, 35),
      flip = "",
      labelConfig = {
        color = ccc3(252, 231, 200)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_cancel",
      z = 0,
      parent = "image_bg",
      text = T("\229\143\150\230\182\136"),
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(75, 35),
      flip = "",
      labelConfig = {
        color = ccc3(252, 231, 200)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_confirm",
      z = 0,
      parent = "image_bg",
      text = T("\231\161\174\229\174\154"),
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 32)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_item1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 117)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(115, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_item2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_item3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_item1",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "image_checkbox_bg1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_item2",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "image_checkbox_bg2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.5, 11)
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
      name = "label_tip1",
      z = 0,
      parent = "node_item1",
      text = T("\228\184\141\233\128\130\229\189\147\229\164\180\229\131\143"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34, 12.5)
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
      name = "label_tip2",
      z = 0,
      parent = "node_item2",
      text = T("\230\149\163\230\146\173\232\153\154\229\129\135\229\185\191\229\145\138"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_item3",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "image_checkbox_bg3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.5, 10.5)
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
      name = "label_tip3",
      z = 0,
      parent = "node_item3",
      text = T("\229\133\182\228\187\150"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox_bg1",
      res = "UI/alpha/1080P/common/account_sifting_2.png",
      name = "image_checkbox1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox_bg2",
      res = "UI/alpha/1080P/common/account_sifting_2.png",
      name = "image_checkbox2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox_bg3",
      res = "UI/alpha/1080P/common/account_sifting_2.png",
      name = "image_checkbox3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox1",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "ImageView_6444",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox2",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "ImageView_6444",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox3",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "ImageView_6444",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 10.75)
    }
  }
}
