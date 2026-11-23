ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_bind_hero_window = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(870, 483)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 130, 30, 130),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 263.5)
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
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\175\183\233\128\137\230\139\169\232\166\129\231\187\145\229\174\154\231\154\132\232\139\177\233\155\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435, 460.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.5, 461.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626, 460.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(832, 365)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_282",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/pet/pet_room_select_hero_bottom_2.png",
      capInsets = CCRectMake(13, 9.5, 13, 9.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(810, 305)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(30, 131.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121.8, h = 50.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_confirm",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(441, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(769.5, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_filter_bg",
      z = 1,
      parent = "image_bg",
      res = "UI/alpha/1080P/pet/pet_room_tag_not_chosen_2.png",
      capInsets = CCRectMake(36.5, 11, 36.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435, 104.5)
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
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\233\128\137\230\139\169"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
    }
  }
}
