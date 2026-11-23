ed.uieditor = ed.uieditor or {}
ed.uieditor.collectionSummaryPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(259, 374.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 10, 10),
      res = "UI/alpha/1080P/common/com_new_3.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(245, 23.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_001",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(25, 5, 30.5, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 229.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(245, 23.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_002",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(25, 5, 30.5, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 180.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(245, 23.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_003",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(25, 5, 30.5, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 131.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(245, 23.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_004",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(25, 5, 30.5, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 81.75)
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
      name = "Label_2643",
      z = 0,
      parent = "bg",
      text = T("\230\157\165\232\135\170\229\133\172\228\188\154\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 229.25)
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
      name = "Label_2643_Copy0",
      z = 0,
      parent = "bg",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 204.75)
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
      name = "Label_2643_Copy1",
      z = 0,
      parent = "bg",
      text = T("\230\139\165\230\156\137\229\164\180\229\131\143\230\149\176\233\135\143\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 180.25)
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
      name = "Label_2643_Copy2",
      z = 0,
      parent = "bg",
      text = T("\230\139\165\230\156\137\229\164\180\229\131\143\230\161\134\230\149\176\233\135\143\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 155.75)
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
      name = "Label_2643_Copy3",
      z = 0,
      parent = "bg",
      text = T("\230\139\165\230\156\137\231\154\174\232\130\164\230\149\176\233\135\143\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 131.25)
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
      name = "Label_2643_Copy4",
      z = 0,
      parent = "bg",
      text = T("\230\139\165\230\156\137\232\161\168\230\131\133\229\140\133\230\149\176\233\135\143\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 106.25)
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
      name = "Label_2643_Copy5",
      z = 0,
      parent = "bg",
      text = T("\230\139\165\230\156\137\231\171\158\230\138\128\229\156\186\232\131\140\230\153\175\230\149\176\233\135\143\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 81.75)
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
      name = "Label_guild_name",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 229.25)
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
      name = "Label_rank",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 204.75)
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
      name = "Label_avata",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 180.25)
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
      name = "Label_avata_f",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 155.75)
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
      name = "Label_fashion",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 131.25)
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
      name = "Label_emg",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 106.25)
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
      name = "Label_pvp_bg",
      z = 0,
      parent = "bg",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(234, 81.75)
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
      name = "ImageView_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129.5, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 241, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2661",
      z = 0,
      parent = "ImageView_btn",
      text = T("\230\159\165\231\156\139\232\141\163\232\128\128"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  }
}
