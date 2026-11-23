ed.uieditor = ed.uieditor or {}
ed.uieditor.PetLevelUpTip = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(775.5, 258.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(250, 50, 275.5, 158.5),
      res = "UI/alpha/1080P/pet/pet_room_levelup_bg_3.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 377)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 349.5, h = 204.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/pet_room_levelup_bg_4.png",
      name = "ImageView_7174",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488, 377.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 317.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/pet_room_levelup_bg_1.png",
      name = "ImageView_7175",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 321.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 575, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/pet_room_levelup_bg_2.png",
      name = "ImageView_7176",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 177)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.74999625, h = 15.9999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "ImageView_7177",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.75, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.74999625, h = 15.9999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "ImageView_7177_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.75, -16.5)
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
      size = 30,
      text = "Text Label",
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488, 374.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.74999625, h = 15.9999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "ImageView_7177_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.75, -44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.74999625, h = 15.9999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "ImageView_7177_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.75, -72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "ImageView_7181",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, -16.5)
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
      name = "Label_7184_Copy3",
      z = 0,
      parent = "ImageView_7176",
      text = T("\233\162\157\229\164\150\229\177\158\230\128\167\230\191\128\230\180\187\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(169.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "ImageView_7181_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, -44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7176",
      res = "UI/alpha/1080P/skill/skill_point.png",
      name = "ImageView_7201",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.5, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7175",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "ImageView_7181_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, -72)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ex_attr",
      z = 0,
      parent = "ImageView_7176",
      text = T("\229\145\189\228\184\173\231\173\137\231\186\167+20"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(285, 27.5)
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
      name = "label_pre_level",
      z = 0,
      parent = "ImageView_7175",
      text = T("\231\173\137\231\186\167"),
      size = 20
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(148.75, 18.5)
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
      name = "label_pre_str",
      z = 0,
      parent = "ImageView_7175",
      text = "80%",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(148.75, -16.5)
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
      name = "label_pre_int",
      z = 0,
      parent = "ImageView_7175",
      text = "80%",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(148.75, -44.5)
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
      name = "label_pre_agi",
      z = 0,
      parent = "ImageView_7175",
      text = "80%",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(148.75, -72)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level",
      z = 0,
      parent = "ImageView_7175",
      text = "13",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(196.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_str",
      z = 0,
      parent = "ImageView_7175",
      text = "90%",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(196.25, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_int",
      z = 0,
      parent = "ImageView_7175",
      text = "90%",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(196.25, -44.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_agi",
      z = 0,
      parent = "ImageView_7175",
      text = "90%",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(196.25, -71.5)
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
      name = "label_pre_str_Copy0",
      z = 0,
      parent = "ImageView_7175",
      text = T("\229\138\155\233\135\143\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(62.25, -16.5)
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
      name = "label_pre_int_Copy0",
      z = 0,
      parent = "ImageView_7175",
      text = T("\230\153\186\229\138\155\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(62.25, -44.5)
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
      name = "label_pre_agi_Copy0",
      z = 0,
      parent = "ImageView_7175",
      text = T("\230\149\143\230\141\183\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(62.25, -72)
    }
  }
}
