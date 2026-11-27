ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_ptr_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/ptr_gift/ptr_gift_bg.jpg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 583.5, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/ptr_gift/ptr_gift_task.png",
      name = "item2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(774.5, 276.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 583.5, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/ptr_gift/ptr_gift_task.png",
      name = "item1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(774.5, 378)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(42, 36, 30),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label2",
      z = 0,
      parent = "item2",
      text = T("\229\133\136\233\148\139\230\156\141\230\180\187\229\138\168\230\156\159\229\134\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(82.25, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item2",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307.75, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item2",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461.75, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(42, 36, 30),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label3",
      z = 0,
      parent = "item2",
      text = T("\229\133\133\229\128\188\231\166\143\229\136\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(82.25, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(42, 36, 30),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label1",
      z = 0,
      parent = "item1",
      text = T("\229\143\130\229\138\160\229\133\136\233\148\139\230\156\141\230\181\139\232\175\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(82.25, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item1",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307.75, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item1",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461.75, 50)
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
      name = "label_get2",
      z = 0,
      parent = "btn2",
      text = T("\233\162\134 \229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
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
      name = "label_get1",
      z = 0,
      parent = "btn1",
      text = T("\233\162\134 \229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(210, 161, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_47696",
      z = 0,
      parent = "bg",
      text = T("\230\132\159\232\176\162\230\130\168\231\154\132\229\143\130\228\184\142\229\146\140\233\153\170\228\188\180\229\147\166\239\188\129"),
      size = 30
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(565, 451.5)
    }
  }
}
