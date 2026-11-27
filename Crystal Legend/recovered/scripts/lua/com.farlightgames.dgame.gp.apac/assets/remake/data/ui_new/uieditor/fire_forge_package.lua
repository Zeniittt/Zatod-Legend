ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_package = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(814, 145.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(307, 0, 200, 0.5),
      res = "UI/alpha/1080P/fireforge/bag/list_1.png",
      name = "image_tag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(597.5, 557.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(1060, 460)
    },
    t = "Layer",
    base = {
      name = "panel_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-50, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1060, 460)
    },
    t = "Layer",
    base = {
      name = "panel_fragment",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-50, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301.5, h = 238},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/bag/empty_state.png",
      name = "panel_fragment_none",
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
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136, 504)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 143, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_tag",
      res = "UI/alpha/1080P/fireforge/bag/list_2.png",
      name = "equip_selected_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 143, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_tag",
      res = "UI/alpha/1080P/fireforge/bag/list_2.png",
      name = "fragment_selected_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(467, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 140, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "equip_unselect",
      z = 0,
      parent = "image_tag",
      text = T("\232\163\133\229\164\135"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 140, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fragment_unselect",
      z = 0,
      parent = "image_tag",
      text = T("\231\162\142\231\137\135"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(467, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "equip_tag_bar",
      z = 0,
      parent = "panel_equip",
      res = "UI/alpha/1080P/fireforge/bag/choose_board.png",
      capInsets = CCRectMake(25, 0, 27, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(541, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1020, 400)
    },
    t = "Layer",
    base = {
      parent = "panel_equip",
      name = "draglist_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(20, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 40)
    },
    t = "Layer",
    base = {
      parent = "image_tag",
      name = "btn_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(287, 0.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 40)
    },
    t = "Layer",
    base = {
      parent = "image_tag",
      name = "btn_fragment",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(407, 0.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(239, 538)
    },
    t = "Scale9Sprite",
    base = {
      name = "fragment_detail_bg",
      z = 0,
      parent = "panel_fragment",
      res = "UI/alpha/1080P/fireforge/bag/fragmentinfo_board.png",
      capInsets = CCRectMake(100, 280, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(760, 436.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "fragment_list_bg",
      z = 0,
      parent = "panel_fragment",
      res = "UI/alpha/1080P/fireforge/bag/list_3.png",
      capInsets = CCRectMake(35, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647.5, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725, 385)
    },
    t = "Layer",
    base = {
      parent = "panel_fragment",
      name = "draglist_fragment",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(285, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_fragment",
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      name = "btn_fusion_all",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(637, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(181, 151, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "no_fragment_tip",
      z = 0,
      parent = "panel_fragment_none",
      text = T("\229\176\154\230\156\170\232\142\183\229\190\151\231\162\142\231\137\135"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.75, 109.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 176, 62),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "equip_selected_label",
      z = 0,
      parent = "equip_selected_bg",
      text = T("\232\163\133\229\164\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 176, 62),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fragment_selected_label",
      z = 0,
      parent = "fragment_selected_bg",
      text = T("\231\162\142\231\137\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip_tag_bar",
      res = "UI/alpha/1080P/fireforge/bag/choose_select.png",
      name = "btn_1_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip_tag_bar",
      res = "UI/alpha/1080P/fireforge/bag/choose_select.png",
      name = "btn_2_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip_tag_bar",
      res = "UI/alpha/1080P/fireforge/bag/choose_select.png",
      name = "btn_3_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 140, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_1_unselect",
      z = 0,
      parent = "equip_tag_bar",
      text = T("\229\133\168\233\131\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 140, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_2_unselect",
      z = 0,
      parent = "equip_tag_bar",
      text = T("\229\183\178\231\187\145\229\174\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 140, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_3_unselect",
      z = 0,
      parent = "equip_tag_bar",
      text = T("\230\156\170\231\187\145\229\174\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "fragment_detail_bg",
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      name = "btn_fusion",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 63.5)
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
      parent = "fragment_detail_bg",
      name = "fragment_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(119.5, 382)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 218.5, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "fragment_detail_bg",
      res = "UI/alpha/1080P/fireforge/bag/fragmentinfo_only_title.png",
      name = "fragment_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 319)
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
      name = "fragment_own_num",
      z = 0,
      parent = "fragment_detail_bg",
      text = "180",
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(124.5, 286)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 120)
    },
    t = "Layer",
    base = {
      parent = "fragment_detail_bg",
      name = "panel_fragment_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(24.5, 134)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 175),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_fusion_all_label",
      z = 0,
      parent = "btn_fusion_all",
      text = T("\228\184\128\233\148\174\229\144\136\230\136\144"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(211, 168, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fragment_own_label_Copy0",
      z = 0,
      parent = "fragment_detail_bg",
      text = T("\230\140\129\230\156\137:"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(119.5, 286)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title_bg",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "button_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.25, 16.75)
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
      name = "btn_1_selected_label",
      z = 0,
      parent = "btn_1_selected",
      text = T("\229\133\168\233\131\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 17.5)
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
      name = "btn_2_selected_label",
      z = 0,
      parent = "btn_2_selected",
      text = T("\229\183\178\231\187\145\229\174\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 17.5)
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
      name = "btn_3_selected_label",
      z = 0,
      parent = "btn_3_selected",
      text = T("\230\156\170\231\187\145\229\174\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 175),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_fusion_label",
      z = 0,
      parent = "btn_fusion",
      text = T("\229\144\136\230\136\144"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fragment_name_label",
      z = 0,
      parent = "fragment_name_bg",
      text = T("\228\188\160\229\165\135 \194\183 \229\144\141\229\173\151\239\188\136\231\162\142\231\137\135\239\188\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.25, 22.25)
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
      parent = "button_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_931",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  }
}
