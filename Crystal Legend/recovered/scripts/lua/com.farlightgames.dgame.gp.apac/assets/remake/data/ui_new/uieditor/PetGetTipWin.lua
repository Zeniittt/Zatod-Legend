ed.uieditor = ed.uieditor or {}
ed.uieditor.PetGetTipWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 321.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_bg_bottom.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_blank.png",
      name = "ImageView_4639",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(701.5, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 56, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_blank.png",
      name = "ImageView_4639_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(468.5, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(211, 169, 120),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4641",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\229\135\187\231\169\186\231\153\189\229\164\132\229\143\150\230\182\136"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 150)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_actor",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(382.5, 80.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 291.5, h = 101.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_bg.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(580.5, 331.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 450, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_gold_bg.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(810, 245.25)
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
      name = "Label_4831",
      z = 0,
      parent = "bg",
      text = T("\229\164\169\232\181\139\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(614.5, 186.75)
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
      name = "Label_4831_Copy0",
      z = 0,
      parent = "bg",
      text = T("\228\189\147\229\158\139\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(614.5, 149.75)
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
      name = "Label_4831_Copy1",
      z = 0,
      parent = "bg",
      text = T("\232\186\171\233\149\191\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(726.5, 149.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_title.png",
      name = "ImageView_4825",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 45.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 40.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_title.png",
      name = "ImageView_4825_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.75, 44.75)
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
      name = "bodysize",
      z = 0,
      parent = "bg",
      text = "1.026",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(642, 149.75)
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
      name = "title",
      z = 0,
      parent = "bg_title",
      text = T("\232\142\183\229\190\151\230\150\176\228\191\161\228\189\191"),
      size = 46
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.25, 48.25)
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
      name = "bodyheight",
      z = 0,
      parent = "bg",
      text = T("2.5\231\177\179"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(755, 149.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/pet/pet_tag_gold.png",
      name = "icon_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145.5, 21.25)
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
      name = "name",
      z = 0,
      parent = "bg_name",
      text = T("\228\191\161\228\189\191\231\154\132\229\144\141\231\167\176"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_str_bg.png",
      name = "ImageView_4836",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(649.5, 102.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_frame_gold.png",
      name = "ImageView_4847",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 61.5, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_frame_gold.png",
      name = "ImageView_4847_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_int_bg.png",
      name = "ImageView_4836_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(800.5, 102.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 140.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_agi_bg.png",
      name = "ImageView_4836_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(951, 102.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.5, h = 56},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_top.png",
      name = "icon_best",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(813.5, 163.25)
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
      name = "label_noTalent",
      z = 0,
      parent = "bg",
      text = T("\230\151\160"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(651, 186.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 13},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4836",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_str.png",
      name = "ImageView_4839",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 17.25)
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
      name = "att_str",
      z = 0,
      parent = "ImageView_4836",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.5, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 13.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4836_Copy0",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_int.png",
      name = "ImageView_4839_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 17.25)
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
      name = "att_int",
      z = 0,
      parent = "ImageView_4836_Copy0",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.5, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12, h = 14},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4836_Copy1",
      res = "UI/alpha/1080P/pet/incubate/pet_house_get_agi.png",
      name = "ImageView_4839_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 17.25)
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
      name = "att_agi",
      z = 0,
      parent = "ImageView_4836_Copy1",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.25, 17.25)
    }
  }
}
