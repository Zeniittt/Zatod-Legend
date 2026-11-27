ed.uieditor = ed.uieditor or {}
ed.uieditor.PetAddSpeedItem1 = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 557, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_timer_item_bg.png",
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
      fix_scale = {y = 0.59, x = 0.59},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.3, h = 41.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/highsoul_big.jpg",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\231\155\180\230\142\165\229\173\181\229\140\150\229\174\140\230\136\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(109, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_timer_border_line.png",
      name = "ImageView_4609",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.5, 29)
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
      z = 0,
      parent = "bg",
      text = T("\233\146\187\231\159\179"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(109, 40.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.399998656, h = 22.399998656},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ok",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "ImageView_4613",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 22)
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
      name = "Label_4614",
      z = 0,
      parent = "btn_ok",
      text = "500",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.25, 22)
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
      name = "Label_4615",
      z = 0,
      parent = "btn_ok",
      text = T("\229\138\160\233\128\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.25, 22.5)
    }
  }
}
