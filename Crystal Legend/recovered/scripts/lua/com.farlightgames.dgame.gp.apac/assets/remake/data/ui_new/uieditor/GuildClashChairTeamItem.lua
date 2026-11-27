ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashChairTeamItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 280, h = 79.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_teaminfo.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.32, x = 0.32},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.92, h = 30.08},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 61.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.99999904, h = 17.599998944},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/icon_power.png",
      name = "gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204, 64.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_11.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_11.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_11.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_11.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_11.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(224, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 289, h = 86},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_breathing.png",
      name = "breath",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.2, h = 36.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_back_floor.png",
      name = "btn_return",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(279.5, 76.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "mask",
      z = 5,
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/guildteam_cover.png",
      capInsets = CCRectMake(10, 10, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 224, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gs_label",
      z = 0,
      parent = "gs",
      text = "1234567",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.35, h = 26.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_return",
      res = "UI/alpha/1080P/guild/guild_clash_headmodify/modify_back_icon.png",
      name = "ImageView_1477",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.5, 23.25)
    }
  }
}
