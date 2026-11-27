ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueCharmBagScene = {
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
      res = "UI/alpha/1080P/rogue/charm/charm_bg.jpg",
      name = "image_bg",
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
      scaleSize = CCSizeMake(661, 320)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_charm_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(72, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "img_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159, 596.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 832, h = 273},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_pocket_list_bg.png",
      name = "img_light_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 433)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 424.5, h = 538},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_detail_bg.png",
      name = "img_charm_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(954.5, 382.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194.5, h = 193.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_light_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_normal_dec.png",
      name = "img_bag_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66, 199.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_des",
      z = 0,
      parent = "img_light_bg",
      text = T("\230\143\143\232\191\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(372.5, 199.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(607, 150)
    },
    t = "Layer",
    base = {
      parent = "img_light_bg",
      name = "panel_selected_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(136, 126.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.5, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_light_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_arrow.png",
      name = "img_empty_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(373, 152.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 236, 246),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_name",
      z = 0,
      parent = "img_charm_info",
      text = T("\231\186\160\233\148\153\231\173\155\229\173\144"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.75, 445.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 176.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bag_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_normal_pocket.png",
      name = "img_bag_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144.75, 90.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 103, h = 103.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bag_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_pocket_progress.png",
      name = "img_weight_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 95.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.25, h = 16.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_charm_info",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.25, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194.5, h = 193.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bag_bg",
      res = "UI/alpha/1080P/rogue/charm/charm_overweight_light.png",
      name = "img_overweight_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 96.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 205, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_weight",
      z = 0,
      parent = "img_charm_info",
      text = T("\233\135\141\233\135\143\239\188\1543"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.25, 244.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 100)
    },
    t = "Layer",
    base = {
      parent = "img_charm_info",
      name = "panel_charm_des",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(130.25, 109.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 30)
    },
    t = "Layer",
    base = {
      parent = "img_charm_info",
      name = "panel_charm_level_require",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105.25, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 237.5, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_selected_list",
      res = "UI/alpha/1080P/rogue/charm/overweight_tip_bg.png",
      name = "img_overweight_tip_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230, 140)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 195.5, h = 136},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_charm_info",
      res = "UI/alpha/1080P/rogue/charm/charm_max.png",
      name = "img_charm_max",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.25, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.25, h = 16.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_charm_info",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229.75, 279)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.25, h = 16.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_charm_info",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229.75, 279)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 141.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_charm_info",
      res = "UI/alpha/1080P/rogue/charm/icon/charm_ap_1.png",
      name = "img_charm_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.25, 354)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 101, 101),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_unlock",
      z = 0,
      parent = "img_charm_info",
      text = T("\230\156\172\228\185\166\228\184\173\230\182\136\232\128\151%s\231\143\141\231\143\160\229\144\142\232\167\163\233\148\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.25, 83)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(238, 194, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_max",
      z = 0,
      parent = "img_charm_max",
      text = T("\229\183\178\229\141\135\232\135\179\230\187\161\231\186\167"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.75, 63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 272.5, h = 48.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_charm_info",
      res = "UI/alpha/1080P/rogue/charm/charm_detail_button.png",
      name = "btn_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(204, 206, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_equip",
      z = 0,
      parent = "btn_equip",
      text = T("\229\161\171\232\163\133"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.25, 27.75)
    }
  }
}
