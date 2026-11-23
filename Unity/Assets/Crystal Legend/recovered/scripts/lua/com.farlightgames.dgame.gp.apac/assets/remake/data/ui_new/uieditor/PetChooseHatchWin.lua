ed.uieditor = ed.uieditor or {}
ed.uieditor.PetChooseHatchWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 740, h = 433.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/incubate/pet_house_select_egg_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 258.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(725.5, 419.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_902",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_314",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(370, 216.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 397.5, h = 91},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/pet_list_empty_bg.png",
      name = "no_egg_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(524.5, 216.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.26, x = 1.26},
      flip = "",
      opacity = 255,
      fix_wh = {w = 113.4, h = 113.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_314",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-231.5, 130.5)
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
      parent = "Panel_314",
      text = T("\232\190\185\229\162\131\231\137\167\231\190\138\231\138\172"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-231.5, 63)
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
      name = "amount1",
      z = 0,
      parent = "Panel_314",
      text = T("\230\140\129\230\156\137\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-246, 39)
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
      name = "amount2",
      z = 0,
      parent = "Panel_314",
      text = "9999",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-224, 39)
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
      name = "may",
      z = 0,
      parent = "Panel_314",
      text = T("\229\143\175\232\131\189\229\173\181\229\140\150\229\135\186\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-294, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.199993928, h = 154.399990736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "no_egg_bg",
      res = "UI/alpha/1080P/pet/pet_list_empty.png",
      name = "no_egg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.75, 52)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(232, 114)
    },
    t = "Layer",
    base = {
      parent = "Panel_314",
      name = "layer_pet",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-348, -123.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(107, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "no_egg_label",
      z = 0,
      parent = "no_egg_bg",
      text = T("\228\189\160\232\191\152\230\178\161\230\156\137\228\191\161\228\189\191\232\155\139\229\147\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 374.5, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_314",
      res = "UI/alpha/1080P/pet/incubate/pet_house_select_egg_title_bg.png",
      name = "bg_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 176.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 340)
    },
    t = "Layer",
    base = {
      parent = "Panel_314",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-66.5, -186)
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
      parent = "Panel_314",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-232.5, -170)
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
      name = "tip",
      z = 0,
      parent = "bg_tip",
      text = T("\232\175\183\233\128\137\230\139\169\228\184\128\228\184\170\228\191\161\228\189\191\232\155\139\229\173\181\229\140\150\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.75, 17)
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
      name = "Label_5052",
      z = 0,
      parent = "btn_ok",
      text = T("\229\173\181\229\140\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_prob.png",
      name = "prob_info_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244.5, 393.25)
    }
  }
}
