ed.uieditor = ed.uieditor or {}
ed.uieditor.headSetting = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(602, 337.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 435)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(119, 153.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "tab_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(838.5, 436)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {name = "head_panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(260.5, 353.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 107.5, h = 44},
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
      normal = "UI/alpha/1080P/common/tab_unselected.png",
      name = "btn_head",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/common/tab_unselected.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61, 116.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 107.5, h = 44},
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
      normal = "UI/alpha/1080P/common/tab_unselected.png",
      name = "btn_head_frame",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/common/tab_unselected.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61, 69)
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
      size = 15,
      text = T("\232\142\183\229\143\150\228\191\161\230\129\175\232\175\180\229\144\141"),
      name = "desc_text",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(203, 271.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_head",
      res = "UI/alpha/1080P/common/tab_selected.png",
      name = "btn_head_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 22)
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
      name = "label_head",
      z = 0,
      parent = "btn_head",
      text = T("\229\164\180\229\131\143"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 172, 40),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\229\164\180\229\131\143\229\144\141\231\167\176"),
      name = "name_text",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260, 287.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_head_frame",
      res = "UI/alpha/1080P/common/tab_selected.png",
      name = "btn_head_frame_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 22)
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
      name = "label_head_frame",
      z = 0,
      parent = "btn_head_frame",
      text = T("\229\164\180\229\131\143\230\161\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(253, 240, 158)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_change",
      z = 0,
      text = T("\231\161\174\232\174\164\230\155\180\230\141\162"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261, 157.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(424.5, 302.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/playerinfo/window_bg2.png",
      name = "content_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(551.5, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 107.5, h = 44},
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
      normal = "UI/alpha/1080P/common/tab_unselected.png",
      name = "btn_medal",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/common/tab_unselected.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(412.5, 233.5)
    },
    t = "Layer",
    base = {
      parent = "content_bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.75, 62.25)
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
      parent = "content_bg",
      name = "head_btn_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(212.25, 151.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_medal",
      res = "UI/alpha/1080P/common/tab_selected.png",
      name = "btn_medal_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 22)
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
      name = "label_medal",
      z = 0,
      parent = "btn_medal",
      text = T("\229\190\189\231\171\160"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 26)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 68},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_btn_layer",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_rank_line.png",
      name = "ImageView_8486",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-150, -118)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 68},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_btn_layer",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_rank_line.png",
      name = "ImageView_8487",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, -118)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_btn_layer",
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_All",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-82.5, -118)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_btn_layer",
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_Normal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-27.5, -118)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_btn_layer",
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_Special",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, -118)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_btn_layer",
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_Skin",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, -118)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_All",
      res = "UI/alpha/1080P/herolist/tab_selected.png",
      name = "btn_All_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 23.5)
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
      name = "label_All",
      z = 0,
      parent = "btn_All",
      text = T("\229\133\168\233\131\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61, h = 62.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_Normal",
      res = "UI/alpha/1080P/herolist/tab_selected.png",
      name = "btn_Normal_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 23.5)
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
      name = "label_Normal",
      z = 0,
      parent = "btn_Normal",
      text = T("\229\184\184\232\167\132"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61, h = 62.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_Special",
      res = "UI/alpha/1080P/herolist/tab_selected.png",
      name = "btn_Special_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 23.5)
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
      name = "label_Special",
      z = 0,
      parent = "btn_Special",
      text = T("\231\137\185\230\174\138"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61, h = 62.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_Skin",
      res = "UI/alpha/1080P/herolist/tab_selected.png",
      name = "btn_Skin_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 23.5)
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
      name = "label_Skin",
      z = 0,
      parent = "btn_Skin",
      text = T("\231\154\174\232\130\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
    }
  }
}
