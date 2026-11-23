ed.uieditor = ed.uieditor or {}
ed.uieditor.newbieSummonRecommendWin = {
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
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_summon_bg.png",
      name = "ImageView_67",
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
      fix_wh = {w = 207, h = 373.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_frame_3rd.png",
      name = "bg_group_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(824, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207, h = 373.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_frame_2nd.png",
      name = "bg_group_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(606.5, 272)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207, h = 373.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_frame_1st.png",
      name = "bg_group_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388, 254)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(108, 127, 157),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("3\231\167\146\229\144\142\231\130\185\229\135\187\228\187\187\230\132\143\229\140\186\229\159\159\229\133\179\233\151\173"),
      name = "label_close_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 195, h = 352.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_frame_new.png",
      name = "bg_group_0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176, 297)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 350.5, h = 115.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_star.png",
      name = "bg_title_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 475)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_group_1",
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_bottom_1st.png",
      name = "bg_stage_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.5, 53.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_group_2",
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_bottom_2nd.png",
      name = "bg_stage_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.5, 56.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_group_3",
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_bottom_3rd.png",
      name = "bg_stage_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190, 54.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_group_0",
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_bottom_new.png",
      name = "bg_stage_0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187.5, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_group_0",
      res = "UI/alpha/1080P/summonbeginner/banner/recommend_new.png",
      name = "ImageView_40",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 314.25)
    }
  }
}
