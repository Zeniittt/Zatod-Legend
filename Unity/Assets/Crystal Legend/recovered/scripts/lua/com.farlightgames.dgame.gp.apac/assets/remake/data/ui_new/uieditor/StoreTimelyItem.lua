ed.uieditor = ed.uieditor or {}
ed.uieditor.StoreTimelyItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 168, h = 185},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newshop/gift1_bg.png",
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
      name = "price",
      z = 1,
      parent = "bg",
      text = T("\194\1656.00"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/newshop_recharge_diamond_01.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 114)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 168, h = 185},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_shade.png",
      name = "mask",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 92.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/newshop_rate.png",
      name = "bg_discount",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 180)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 151.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift1_text.png",
      name = "bg_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 65.5)
    }
  },
  {
    config = {
      rotation = -14,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/newshop/over.png",
      name = "ImageView_387",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 19},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/countdown_bg.png",
      name = "bg_time",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 152)
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
      name = "label_discount",
      z = 0,
      parent = "bg_discount",
      text = "1000%",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 94, 94),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_over",
      z = 0,
      parent = "ImageView_387",
      text = T("\229\148\174\231\189\132"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.5, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_discount",
      res = "UI/alpha/1080P/newshop/new_tag.png",
      name = "red_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.25, -12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(227, 97, 31),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_discount_tips",
      z = 0,
      parent = "bg_discount",
      text = T("\232\182\133\229\128\188"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "bg_name",
      text = T("\230\175\143\230\151\165\231\137\185\230\131\160\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.75, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time",
      z = 0,
      parent = "bg_name",
      text = T("\233\153\144\232\180\173\230\149\176\233\135\143\239\188\1540/1"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_time",
      res = "UI/alpha/1080P/newshop/countdown_icon.png",
      name = "ImageView_8445",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time1",
      z = 0,
      parent = "bg_time",
      text = T("20\229\176\143\230\151\182"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 9.5)
    }
  }
}
