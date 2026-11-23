ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_handbook_scene = {
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
      position = ccp(129.5, 503)
    }
  },
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
      res = "UI/alpha/1080P/fireforge/bag/background.jpg",
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
      fix_wh = {w = 626.5, h = 579},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/book/detail_board1.png",
      name = "image_detail_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 265)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(309, 355)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_20813",
      z = 0,
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/fireforge/book/detail_board2.png",
      capInsets = CCRectMake(25, 25, 25, 25)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.25, 202)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(545, 525)
    },
    t = "Layer",
    base = {name = "panel_list", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(400, 10)
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
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
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
      opacity = 0,
      fix_wh = {w = 1170, h = 347},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/bag/background_effect.png",
      name = "ImageView_20804",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 172.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 187.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/to_jpg_x_alpha/le1.png",
      name = "image_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310.25, 443)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 35)
    },
    t = "Layer",
    base = {
      parent = "image_detail_bg",
      name = "panel_star",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(232.75, 389.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 337, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/fireforge/book/title_only1.png",
      name = "image_name_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.25, 376)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 363, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/fireforge/book/title_only2.png",
      name = "image_attr_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.25, 349)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 75)
    },
    t = "Layer",
    base = {
      parent = "image_detail_bg",
      name = "panel_attr_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(163.25, 259.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 363, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/fireforge/book/title_only2.png",
      name = "image_skill_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.25, 244)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.14999355, h = 45.14999355},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/skill_board.png",
      name = "skill_icon_board",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(189.25, 200)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_name",
      z = 1,
      parent = "image_detail_bg",
      text = T("\229\175\146\233\156\156\229\134\178\229\135\187"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(224.25, 215)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/skill_line.png",
      name = "line",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.75, 200)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(235, 80)
    },
    t = "Layer",
    base = {
      parent = "image_detail_bg",
      name = "panel_skill_desc",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(220.75, 115.5)
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
      name = "label_skill_lock",
      z = 1,
      parent = "image_detail_bg",
      text = T("3\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(453.25, 215)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 204,
      fix_wh = {w = 302, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/fireforge/book/rune_board.png",
      name = "image_rune_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.25, 93.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 204,
      fix_wh = {w = 302, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/fireforge/book/rune_board.png",
      name = "image_rune_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.25, 55.5)
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
      name = "ImageView_27775",
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
      name = "label_name",
      z = 0,
      parent = "image_name_bg",
      text = T("\228\188\160\229\165\135\194\183\229\134\176\231\148\178"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(230, 172, 140),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_title",
      z = 0,
      parent = "image_attr_title",
      text = T("\232\163\133\229\164\135\229\177\158\230\128\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(230, 172, 140),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_title",
      z = 0,
      parent = "image_skill_title",
      text = T("\232\163\133\229\164\135\230\138\128\232\131\189"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_icon_board",
      res = "UI/alpha/1080P/legendequip/skill_frame.png",
      name = "image_skill_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 32.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_icon_board",
      res = "UI/alpha/1080P/legendequip/equip_unlock.png",
      name = "image_skill_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 32.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rune_1",
      res = "UI/alpha/1080P/legendequip/testicon1.png",
      name = "rune_icon_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_name_1",
      z = 0,
      parent = "image_rune_1",
      text = T("\231\172\166\230\150\135-\229\134\176\229\135\140"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48, 18)
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
      name = "label_rune_lock_1",
      z = 0,
      parent = "image_rune_1",
      text = T("4\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(294, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rune_2",
      res = "UI/alpha/1080P/legendequip/testicon1.png",
      name = "rune_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_name_2",
      z = 0,
      parent = "image_rune_2",
      text = T("\231\172\166\230\150\135-\229\134\176\229\135\140"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48, 18)
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
      name = "label_rune_lock_2",
      z = 0,
      parent = "image_rune_2",
      text = T("5\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(294, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 98, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_not_have",
      z = 0,
      parent = "image_name_bg",
      text = T("(\230\156\170\230\139\165\230\156\137)"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(206, 22.25)
    }
  }
}
