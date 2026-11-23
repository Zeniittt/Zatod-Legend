ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_allstar_rank_page = {
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
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_gb.jpg",
      name = "ImageView_27",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(630, 388.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_item",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(243.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 355, h = 118.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_title.png",
      name = "ImageView_title",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(593, 487)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(645.5, 272.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_3372",
      z = 0,
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_rankbg.png",
      capInsets = CCRectMake(50, 60, 50, 250)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(558.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(905.5, 388.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "rule_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(922.5, 499)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 30)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_count",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(799, 485.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 621.5, h = 249.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_ranknull.png",
      name = "ImageView_nil",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(560, 183.5)
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
      name = "Label_time",
      z = 0,
      parent = "ImageView_title",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "ImageView_3374",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 231, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3375",
      z = 0,
      parent = "btn_record",
      text = T("\232\181\160\233\128\129\232\174\176\229\189\149"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(99, 28)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_count",
      z = 0,
      parent = "Panel_count",
      res = "UI/alpha/1080P/main/main_status_number_bg.png",
      capInsets = CCRectMake(5, 5, 2.5, 7.5)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(98.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.199998608, h = 31.99999808},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_count",
      res = "UI/alpha/1080P/allstar/allstar_rank/feather.png",
      name = "ImageView_3377",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 15)
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
      name = "Label_3378",
      z = 1,
      parent = "Panel_count",
      text = "9999",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(70.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rule_btn",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_176",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 224, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3491",
      z = 0,
      parent = "ImageView_nil",
      text = T("\229\189\147\229\137\141\230\154\130\230\151\160\233\152\159\233\149\191\228\184\138\230\166\156"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310.75, 96.25)
    }
  }
}
