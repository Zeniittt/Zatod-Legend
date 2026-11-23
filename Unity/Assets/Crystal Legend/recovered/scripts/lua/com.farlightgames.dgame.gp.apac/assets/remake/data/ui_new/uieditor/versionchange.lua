ed.uieditor = ed.uieditor or {}
ed.uieditor.versionchange = {
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(46, 46),
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
      normal = "installer/switch_close_button.png",
      name = "closeBtn",
      z = 0,
      capInsets = CCRectMake(15, 15, 15, 10),
      text = "",
      press = "installer/switch_close_button.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(832.5, 485)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 307.5, h = 401.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "installer/switch_remake_bg.png",
      name = "image_left_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 306.5, h = 401.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "installer/switch_titan_bg.png",
      name = "image_right_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(645, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2.49999952, x = 2.49999976},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.74999628, h = 37.4999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_left_bg",
      res = "installer/account_sifting_mark.png",
      name = "selected_flag_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "text_tips_left",
      z = 0,
      parent = "image_left_bg",
      text = T("\229\189\147\229\137\141\233\128\137\230\139\169"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.75, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "text_tips_right",
      z = 0,
      parent = "image_right_bg",
      text = T("\229\189\147\229\137\141\233\128\137\230\139\169"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 132, h = 97},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_left_bg",
      res = "installer/switch_remake.png",
      name = "img_left_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.75, 130.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2.5, x = 2.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.75, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_right_bg",
      res = "installer/account_sifting_mark.png",
      name = "selected_flag_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 35.75)
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
      name = "tips_left",
      z = 0,
      parent = "image_left_bg",
      text = T("\229\133\168\230\150\176\228\184\138\231\186\191\231\154\132\230\128\128\230\151\167\230\156\141\239\188\140\229\155\158\229\189\1462014\231\154\132\231\174\128\229\141\149\229\191\171\228\185\144\239\188\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.75, 80.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130, h = 89},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_right_bg",
      res = "installer/switch_titan.png",
      name = "img_right_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 130.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(120, 45),
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/task_button.png",
      capInsets = CCRectMake(13.5, 11.5, 13.5, 11.5),
      name = "btn_switch_left",
      z = 0,
      parent = "image_left_bg",
      text = T("\231\137\136\230\156\172\229\136\135\230\141\162"),
      press = "installer/task_button_press.png",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.75, 30.75)
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
      name = "tips_right",
      z = 0,
      parent = "image_right_bg",
      text = T("nine years"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 80.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 419.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_left_bg",
      res = "installer/switch_select.png",
      name = "img_selected_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.75, 200.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(120, 45),
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/task_button.png",
      capInsets = CCRectMake(13.5, 11.5, 13.5, 11.5),
      name = "btn_switch_right",
      z = 0,
      parent = "image_right_bg",
      text = T("\231\137\136\230\156\172\229\136\135\230\141\162"),
      press = "installer/task_button_press.png",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 419.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_right_bg",
      res = "installer/switch_select.png",
      name = "img_selected_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 200.75)
    }
  }
}
