ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_allstar_rank_pop = {
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
      fix_wh = {w = 698, h = 455},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_record.png",
      name = "ImageView_27",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 260)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 639.5, h = 89.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/allstar_playerbg.png",
      name = "ImageView_3459",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 419.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 321, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/tab1.png",
      name = "button_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 321, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/tab1.png",
      name = "button_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(641, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 321, h = 46},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/tab2.png",
      name = "button_selected_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(641, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 321, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/tab2.png",
      name = "button_selected_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 642.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/record1.png",
      name = "ImageView_888",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 289.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 642.5, h = 37},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_rank/giveaway_rank1.png",
      name = "ImageView_999",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 289.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(647, 213.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(158, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(134, 126, 114),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_button_1",
      z = 0,
      parent = "button_1",
      text = T("\232\181\160\233\128\129\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(134, 126, 114),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_2",
      z = 0,
      parent = "button_2",
      text = T("\232\142\183\232\181\160\230\142\146\232\161\140\230\166\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 55),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_selected_2",
      z = 0,
      parent = "button_selected_2",
      text = T("\232\142\183\232\181\160\230\142\146\232\161\140\230\166\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 55),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_selected_1",
      z = 0,
      parent = "button_selected_1",
      text = T("\232\181\160\233\128\129\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4040",
      z = 0,
      parent = "ImageView_888",
      text = T("\232\167\146\232\137\178\228\191\161\230\129\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(173, 255, 107),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_name",
      z = 0,
      parent = "ImageView_3459",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(145.25, 57.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4041",
      z = 0,
      parent = "ImageView_888",
      text = T("\231\177\187\229\158\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 136),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_sys",
      z = 0,
      parent = "ImageView_3459",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(146.25, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4042",
      z = 0,
      parent = "ImageView_888",
      text = T("\230\149\176\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(369.25, 19.5)
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
      name = "Label_3484",
      z = 0,
      parent = "ImageView_3459",
      text = T("\232\142\183\232\181\160\230\128\187\230\149\176\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(397.75, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4043",
      z = 0,
      parent = "ImageView_888",
      text = T("\230\151\182\233\151\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(537.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4044",
      z = 0,
      parent = "ImageView_999",
      text = T("\230\142\146\229\144\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4045",
      z = 0,
      parent = "ImageView_999",
      text = T("\232\167\146\232\137\178\228\191\161\230\129\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4046",
      z = 0,
      parent = "ImageView_999",
      text = T("\232\181\160\233\128\129\230\128\187\230\149\176\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.75, 18.5)
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
      name = "Label_34844",
      z = 0,
      parent = "ImageView_3459",
      text = T("\232\181\160\233\128\129\230\128\187\230\149\176\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(397.75, 30.75)
    }
  }
}
