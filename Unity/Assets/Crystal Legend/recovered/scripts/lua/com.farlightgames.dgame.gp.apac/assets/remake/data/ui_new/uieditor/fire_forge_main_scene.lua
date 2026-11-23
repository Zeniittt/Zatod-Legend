ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_main_scene = {
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
      res = "UI/alpha/1080P/fireforge/background.jpg",
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
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/button_background.png",
      name = "btn_shop",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9, 435)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop",
      res = "UI/alpha/1080P/summon/hero_new_tag.png",
      name = "btn_shop_new",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/button_background.png",
      name = "btn_backbag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9, 355)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/button_background.png",
      name = "btn_book",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9, 275)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 455, h = 180},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/wishlist_board.png",
      name = "wishlist_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378, 386)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1112, 720)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(480, 240, 180, 240),
      res = "UI/alpha/1080P/fireforge/forge_board.png",
      name = "image_forge_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(471.5, -90)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/bless_board.png",
      name = "image_buff_icon_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1003, 440)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 493.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/forge_left.png",
      name = "image_forge_chain_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 451)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 493.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/forge_right.png",
      name = "image_forge_chain_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(901.5, 451)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 193.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/wishlist_left.png",
      name = "image_wishlist_chain_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(224.5, 533)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 200.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/wishlist_right.png",
      name = "image_wishlist_chain_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(551.5, 529)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 501.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.7, h = 62.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop",
      res = "UI/alpha/1080P/fireforge/shop.png",
      name = "ImageView_682",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop",
      z = 0,
      parent = "btn_shop",
      text = T("\229\149\134\229\186\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.7, h = 62.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_backbag",
      res = "UI/alpha/1080P/fireforge/backpag.png",
      name = "ImageView_682",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_backbag",
      z = 0,
      parent = "btn_backbag",
      text = T("\232\131\140\229\140\133"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.7, h = 62.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_book",
      res = "UI/alpha/1080P/fireforge/book_icon.png",
      name = "ImageView_682",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_book",
      z = 0,
      parent = "btn_book",
      text = T("\229\155\190\233\137\180"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 156),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_wishlist_title",
      z = 0,
      parent = "wishlist_bg",
      text = T("\233\148\187\233\128\160\229\191\131\230\132\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 163)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(204, 162, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_wishlist_normal_title",
      z = 0,
      parent = "wishlist_bg",
      text = T("\230\153\174\233\128\154\232\163\133\229\164\135"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255, 122)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wishlist_bg",
      res = "UI/alpha/1080P/fireforge/wishlist_change.png",
      name = "btn_wishlist_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(415.5, 71.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(198.5, 69.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_get_all",
      z = 0,
      parent = "image_forge_bg",
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      capInsets = CCRectMake(45, 23, 50, 23)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 161)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(198.5, 69.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_forge_all",
      z = 0,
      parent = "image_forge_bg",
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      capInsets = CCRectMake(45, 23, 50, 23)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(764, 161)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 540, h = 121.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_forge_bg",
      res = "UI/alpha/1080P/fireforge/forge_board_title.png",
      name = "image_forge_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(329.5, 660)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(795, 420)
    },
    t = "Layer",
    base = {
      parent = "image_forge_bg",
      name = "panel_forge_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(168.5, 190)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wishlist_bg",
      res = "UI/alpha/1080P/legendequip/item_legendequip_board.png",
      name = "image_wish_only_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wishlist_bg",
      res = "UI/alpha/1080P/legendequip/item_legendequip_board.png",
      name = "image_wish_normal_equip_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wishlist_bg",
      res = "UI/alpha/1080P/legendequip/item_legendequip_board.png",
      name = "image_wish_normal_equip_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.5, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wishlist_bg",
      res = "UI/alpha/1080P/legendequip/item_legendequip_board.png",
      name = "image_wish_normal_equip_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334, 70)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(795, 465)
    },
    t = "Layer",
    base = {
      parent = "image_forge_bg",
      name = "panel_touch_area",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(168.5, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.5, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_forge_title_bg",
      res = "UI/alpha/1080P/fireforge/open_arrow.png",
      name = "image_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 33.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_forge_title_bg",
      res = "UI/alpha/1080P/fireforge/redpoint_board.png",
      name = "forge_success_amount_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(366.5, 53.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140, 38)
    },
    t = "Layer",
    base = {
      parent = "image_forge_title_bg",
      name = "panel_forge_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(215, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_2017",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_forge_success_amount",
      z = 0,
      parent = "forge_success_amount_bg",
      text = "25",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_only_equip",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "ImageView_1786",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_only_equip",
      res = "UI/alpha/1080P/fireforge/wishlist_grid2.png",
      name = "ImageView_1787",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_normal_equip_1",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "ImageView_1786",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_normal_equip_1",
      res = "UI/alpha/1080P/fireforge/wishlist_grid2.png",
      name = "ImageView_1787",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_normal_equip_2",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "ImageView_1786",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_normal_equip_2",
      res = "UI/alpha/1080P/fireforge/wishlist_grid2.png",
      name = "ImageView_1787",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_normal_equip_3",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "ImageView_1786",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_wish_normal_equip_3",
      res = "UI/alpha/1080P/fireforge/wishlist_grid2.png",
      name = "ImageView_1787",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_backbag",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_backbag_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/bless_board.png",
      name = "btn_record",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1002, 368.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 57.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wishlist_bg",
      res = "UI/alpha/1080P/fireforge/only_board.png",
      name = "ImageView_18319",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.5, 125.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 390, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_forge_bg",
      res = "UI/alpha/1080P/fireforge/mustget_board.png",
      name = "image_mustget_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(769.5, 638)
    }
  },
  {
    config = {
      rotation = -18,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_backbag",
      res = "UI/alpha/1080P/summon/hero_new_tag.png",
      name = "image_backbag_new_equip_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 53)
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
      name = "btn_rule",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 132.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_buff_icon_bg",
      res = "UI/alpha/1080P/fireforge/bless_board2.png",
      name = "ImageView_20914",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_buff_icon_bg",
      res = "UI/alpha/1080P/fireforge/bless_icon.png",
      name = "image_buff_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_buff_icon_bg",
      res = "UI/alpha/1080P/fireforge/wishlist_finished.png",
      name = "image_buff_finish",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_forge_all",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_forge_all_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179.25, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_forge_title_bg",
      res = "UI/alpha/1080P/fireforge/redpoint_canforge.png",
      name = "image_empty_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(366.5, 61.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_wishlist_only_title",
      z = 0,
      parent = "ImageView_18319",
      text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 23.25)
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
      name = "ImageView_931",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/fireforge/log/icon.png",
      name = "btn_record_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "ImageView_20914",
      text = T("\233\148\187\233\128\160\231\165\157\231\166\143"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.25, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 255, 80),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff_finish",
      z = 0,
      parent = "image_buff_finish",
      text = T("\229\183\178\232\190\190\230\136\144"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 238, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_red",
      z = 0,
      parent = "image_empty_red",
      text = T("\229\143\175\233\148\187\233\128\160"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "btn_record_icon",
      text = T("\232\174\176\229\189\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 3.5)
    }
  }
}
