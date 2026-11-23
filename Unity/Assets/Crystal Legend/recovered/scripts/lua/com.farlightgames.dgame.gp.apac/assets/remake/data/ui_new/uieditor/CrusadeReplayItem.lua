ed.uieditor = ed.uieditor or {}
ed.uieditor.CrusadeReplayItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 553, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "img_bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/crusade/icon_win.png",
      name = "img_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 90, 85),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_round",
      z = 0,
      parent = "img_bg",
      text = "1/15",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 250.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/crusade/bg_name_reply_item.png",
      name = "bg_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(110, 96, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_time",
      z = 0,
      parent = "img_bg",
      text = T("29\229\136\13459\231\167\146\229\137\141"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(534, 69.5)
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
      parent = "img_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_replay",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(514, 30.5)
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
      parent = "img_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_data",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(456.5, 30.5)
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
      parent = "img_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_share",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 177.5, h = 96.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/crusade/bg_share.png",
      name = "bg_share",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_replay",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_data",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_share",
      res = "UI/alpha/1080P/crusade/btn_share.png",
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
      scaleSize = CCSizeMake(166.5, 38.5),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5),
      name = "btn_guild",
      z = 0,
      parent = "bg_share",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 35.25)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(166.5, 40),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5),
      name = "btn_world",
      z = 0,
      parent = "bg_share",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 72.75)
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
      name = "label_guild",
      z = 0,
      parent = "btn_guild",
      text = T("\229\136\134\228\186\171\229\136\176\229\133\172\228\188\154\233\162\145\233\129\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_guild",
      res = "UI/alpha/1080P/crusade/btn_guild.png",
      name = "icon_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.25, 19.25)
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
      name = "label_world",
      z = 0,
      parent = "btn_world",
      text = T("\229\136\134\228\186\171\229\136\176\228\184\150\231\149\140\233\162\145\233\129\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_world",
      res = "UI/alpha/1080P/crusade/btn_world.png",
      name = "icon_world",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_win",
      z = 0,
      parent = "img_win",
      text = T("\232\131\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 20.25)
    }
  }
}
