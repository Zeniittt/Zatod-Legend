ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaRankListWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 924, h = 498},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_reward_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 280)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 735.5, h = 95},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/rank/rank_bg_myrank.png",
      name = "bg_self",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(462, 50.5)
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
      parent = "bg_self",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(225.25, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_name",
      z = 0,
      parent = "bg_self",
      text = T("\229\140\186\230\156\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(225.25, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_1",
      z = 0,
      parent = "bg_self",
      text = T("\231\167\175\229\136\134:"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(592.25, 47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(94, 94)
    },
    t = "Layer",
    base = {
      parent = "bg_self",
      name = "layer_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(133.75, 1.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 188, 116),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_info",
      z = 0,
      parent = "bg",
      text = T("\230\156\172\232\181\155\229\140\186\230\142\146\229\144\141\229\156\168\229\137\1413000\230\151\182\228\184\138\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(463.5, 422.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.99999352, h = 49.999997},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_self",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_1.png",
      name = "image_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473.75, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(116.5, 50)
    },
    t = "Layer",
    base = {
      parent = "bg_self",
      name = "panel_myrank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.25, 23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(728.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(97, 46)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 42.5)
    },
    t = "Layer",
    base = {
      parent = "bg_self",
      name = "panel_myscore",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(615.25, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 300)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(871, 94)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 188, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_nobody",
      z = 0,
      parent = "bg",
      text = T("\232\191\152\230\178\161\230\156\137\233\152\159\233\149\191\228\184\138\230\166\156"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(454.5, 249)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/peakarena_close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(851.5, 415.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 569.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/reward/reward_extra_bg.png",
      name = "bg_extra_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(462, 369)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab1.png",
      name = "btn_all_server_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 204.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab2.png",
      name = "btn_all_server",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 205)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 55)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_title_light",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/lottery/title_light_tf.png",
      capInsets = CCRectMake(25, 20, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461.5, 448)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 255, 204),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461.5, 448)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab2.png",
      name = "btn_area",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab1.png",
      name = "btn_area_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 265.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab2.png",
      name = "btn_cur_server",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab1.png",
      name = "btn_cur_server_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 142.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab2.png",
      name = "btn_end_all_server",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab1.png",
      name = "btn_end_all_server_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 83)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab2.png",
      name = "btn_end_area",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_all_server_selected",
      z = 0,
      parent = "btn_all_server_selected",
      text = T("\229\133\168\230\156\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 57},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/toparena/toparena_reward_tab1.png",
      name = "btn_end_area_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(168, 151, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_all_server",
      z = 0,
      parent = "btn_all_server",
      text = T("\229\133\168\230\156\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4606",
      z = 0,
      parent = "bg_extra_reward",
      text = T("\231\187\147\231\174\151\230\151\182\229\133\168\230\156\141\229\137\1411000\229\144\141\233\162\157\229\164\150\232\142\183\229\190\151\229\164\180\229\131\143\230\161\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(168, 151, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_area",
      z = 0,
      parent = "btn_area",
      text = T("\232\181\155\229\140\186"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.5, h = 73},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_extra_reward",
      res = "UI/alpha/1080P/toparena/reward/reward_extra_frame.png",
      name = "bg_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_area_selected",
      z = 0,
      parent = "btn_area_selected",
      text = T("\232\181\155\229\140\186"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(168, 151, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur_server",
      z = 0,
      parent = "btn_cur_server",
      text = T("\230\156\172\230\156\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur_server_selected",
      z = 0,
      parent = "btn_cur_server_selected",
      text = T("\230\156\172\230\156\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(168, 151, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end_all_server",
      z = 0,
      parent = "btn_end_all_server",
      text = T("\229\133\168\230\156\141\230\156\128\231\187\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end_all_server_selected",
      z = 0,
      parent = "btn_end_all_server_selected",
      text = T("\229\133\168\230\156\141\230\156\128\231\187\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(168, 151, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end_area",
      z = 0,
      parent = "btn_end_area",
      text = T("\232\181\155\229\140\186\230\156\128\231\187\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end_area_selected",
      z = 0,
      parent = "btn_end_area_selected",
      text = T("\232\181\155\229\140\186\230\156\128\231\187\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 30)
    }
  }
}
