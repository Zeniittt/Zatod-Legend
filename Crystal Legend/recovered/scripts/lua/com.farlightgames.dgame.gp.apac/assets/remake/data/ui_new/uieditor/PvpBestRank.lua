ed.uieditor = ed.uieditor or {}
ed.uieditor.PvpBestRank = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(388, 291.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 439)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/newrecord.png",
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 292.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 348, h = 347.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_rankup_light.png",
      name = "light",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 295)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(20, 0, 200, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 69.5)
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
      name = "Label_15668",
      z = 2,
      parent = "bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\230\142\146\229\144\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40.5, 206.5)
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
      name = "Label_15668_Copy0",
      z = 2,
      parent = "bg",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40.5, 171.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "curRank",
      z = 2,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(154, 171.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "bestRank",
      z = 2,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(154, 206.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 380, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/diamond_bg.png",
      name = "ImageView_15674",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 135.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_15677",
      z = 2,
      parent = "bg",
      text = T("\229\165\150\229\138\177\229\176\134\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 93.5)
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
      name = "btn_back_Copy0",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(194, 37.5)
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
      name = "Label_15668_Copy1",
      z = 2,
      parent = "ImageView_15674",
      text = T("\232\142\183\229\190\151\229\165\150\229\138\177\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_15674",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "ImageView_15675",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num_diamond",
      z = 2,
      parent = "ImageView_15674",
      text = "875",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(174.5, 19)
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
      name = "label_back",
      z = 0,
      parent = "btn_back_Copy0",
      text = T("\233\128\128\229\135\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 20)
    }
  }
}
