ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashRankScene = {
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
      res = "UI/alpha/1080P/guild/guild_clash_rank/background.jpg",
      name = "ImageView_680",
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
      fix_wh = {w = 852.5, h = 526},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_rank/floor.png",
      name = "ImageView_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(437.5, 271.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 190.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rankingscene/title.png",
      name = "ImageView_700",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179, 510)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_secondbase.png",
      name = "ImageView_head_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 382)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_secondfloor.png",
      name = "ImageView_nameBj_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.25, 353)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_rankbasis.png",
      name = "ImageView_684",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.25, 321.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_firstbase.png",
      name = "ImageView_head_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(426.75, 395)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 240.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_firstfloor.png",
      name = "ImageView_nameBj_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.75, 353.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_rankbasis.png",
      name = "ImageView_684_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435.25, 321.5)
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
      parent = "ImageView_700",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "ImageView_702",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-20.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 113.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_thirdbase.png",
      name = "ImageView_head_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(651.75, 384.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_684",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_all_basisicon.png",
      name = "ImageView_685",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 13)
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
      name = "Label_2",
      z = 0,
      parent = "ImageView_684",
      text = T("\229\135\187\232\180\165\233\152\159\228\188\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 208.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_thirdfloor.png",
      name = "ImageView_nameBj_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(652.25, 353)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_rankbasis.png",
      name = "ImageView_684_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(668.25, 321)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(734, 290.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_bj",
      name = "Panel_697",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(61.25, 18)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(115, 340)
    },
    t = "Layer",
    base = {
      parent = "ImageView_bj",
      name = "Panel_699",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(806.25, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_702",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_703",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171.5, h = 153.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/guild/guild_clash_rank/top3_empty.png",
      name = "ImageView_nil",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(426.25, 178)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_684_Copy0",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_all_basisicon.png",
      name = "ImageView_685",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 13)
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
      name = "Label_1",
      z = 0,
      parent = "ImageView_684_Copy0",
      text = T("\229\135\187\232\180\165\233\152\159\228\188\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_684_Copy1",
      res = "UI/alpha/1080P/guild/guild_clash_rank/info_all_basisicon.png",
      name = "ImageView_685",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 13)
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
      name = "Label_3",
      z = 0,
      parent = "ImageView_684_Copy1",
      text = T("\229\135\187\232\180\165\233\152\159\228\188\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(127, 110, 99),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_936",
      z = 0,
      parent = "ImageView_nil",
      text = T("\230\142\146\232\161\140\230\166\156\232\153\154\228\189\141\228\187\165\229\190\133\229\147\166"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.75, 10.75)
    }
  }
}
