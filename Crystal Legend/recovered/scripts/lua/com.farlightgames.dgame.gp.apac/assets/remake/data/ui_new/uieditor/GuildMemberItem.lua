ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMemberItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 75)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 543, 77),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 336, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/elder_bg.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.2, 0.5),
      position = ccp(143, 37.5)
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
      z = 1,
      parent = "bg_name",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20.2, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.999989, h = 76.999989},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 36.5)
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
      name = "online",
      z = 0,
      parent = "bg",
      text = T("\229\156\168\231\186\191"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(454.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 103, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg_name",
      text = T("\228\188\154\233\149\191"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.2, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "liveness",
      z = 1,
      parent = "bg",
      text = "99999999",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(381, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      fix_wh = {w = 83.25, h = 35.1},
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
      name = "btn_worship",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(542, 37.5)
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
      name = "gs",
      z = 0,
      parent = "bg",
      text = "0",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270, 37.5)
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
      name = "label_worship",
      z = 0,
      parent = "btn_worship",
      text = T("\232\134\156\230\139\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
    }
  }
}
