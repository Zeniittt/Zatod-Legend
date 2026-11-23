ed.uieditor = ed.uieditor or {}
ed.uieditor.dragonBoatGiveRecordPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(697, 360)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(35, 25, 10, 11),
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_bottom.png",
      name = "bj",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_unchecked.png",
      name = "page_button_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(885, 343.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_unchecked.png",
      name = "page_button_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(885, 282)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_checked.png",
      name = "page_button_selected_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(888.5, 346)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 58},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_checked.png",
      name = "page_button_selected_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(888.5, 283.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.5, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bj",
      res = "UI/alpha/1080P/dragonboat/db_race/db_quit2.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(695.5, 360.5)
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
      parent = "bj",
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_gift_topbox.jpg",
      name = "page_title_1",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 316.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(644, 267)
    },
    t = "Layer",
    base = {
      parent = "bj",
      name = "Panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(29, 32.5)
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
      parent = "bj",
      res = "UI/alpha/1080P/dragonboat/db_record/db_record_receive_topbox.jpg",
      name = "page_title_2",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 316.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page1",
      z = 0,
      parent = "page_button_1",
      text = T("\232\181\160\233\128\129\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page3",
      z = 0,
      parent = "page_button_2",
      text = T("\232\142\183\232\181\160\230\142\146\232\161\140\230\166\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(233, 126, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page2",
      z = 0,
      parent = "page_button_selected_1",
      text = T("\232\181\160\233\128\129\232\174\176\229\189\149"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(233, 126, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page4",
      z = 0,
      parent = "page_button_selected_2",
      text = T("\232\142\183\232\181\160\230\142\146\232\161\140\230\166\156"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 29.5)
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
      name = "Label_title_1",
      z = 0,
      parent = "page_title_1",
      text = T("\232\167\146\232\137\178\228\191\161\230\129\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.75, 19)
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
      name = "Label_title_2",
      z = 0,
      parent = "page_title_1",
      text = T("\231\177\187\229\158\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.75, 19)
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
      name = "Label_title_3",
      z = 0,
      parent = "page_title_1",
      text = T("\230\149\176\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375.75, 19)
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
      name = "Label_title_4",
      z = 0,
      parent = "page_title_1",
      text = T("\230\151\182\233\151\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(536.25, 19)
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
      name = "Label_title_5",
      z = 0,
      parent = "page_title_2",
      text = T("\230\142\146\229\144\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 19)
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
      name = "Label_title_6",
      z = 0,
      parent = "page_title_2",
      text = T("\232\167\146\232\137\178\228\191\161\230\129\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.75, 19)
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
      name = "Label_title_7",
      z = 0,
      parent = "page_title_2",
      text = T("\232\181\160\233\128\129\230\128\187\230\149\176\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172, h = 143.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bj",
      res = "UI/alpha/1080P/dragonboat/db_record/db_norecord.png",
      name = "image_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.5, 180)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(105, 133, 118),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty",
      z = 0,
      parent = "image_empty",
      text = T("\230\154\130\230\151\160\232\174\176\229\189\149"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 11.75)
    }
  }
}
