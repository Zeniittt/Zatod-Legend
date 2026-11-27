ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMainScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(246.5, 514.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 270, 0.5, 0.5),
      res = "UI/alpha/1080P/guild/information_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.2, 0),
      position = ccp(117.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(611, 395)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_main",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/com_new_2.png",
      capInsets = CCRectMake(20, 20, 44.5, 351)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(238.8, -4)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "info",
      z = 1,
      parent = "bg_main",
      text = T("\229\133\172\228\188\154\228\191\161\230\129\175"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.5, 372.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gs",
      z = 1,
      parent = "bg_main",
      text = T("\230\136\152\230\150\151\229\138\155"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282, 373)
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
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-45.7, -17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(594, 29.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_text",
      z = 0,
      parent = "bg_main",
      res = "UI/alpha/1080P/guild/text_bg.png",
      capInsets = CCRectMake(15, 10, 573, 10)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8, 374)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590.5, 338)
    },
    t = "Layer",
    base = {
      parent = "bg_main",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10, 19.5)
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
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(209.5, 498)
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
      name = "layer_top",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(49.3, 2)
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
      parent = "bg_main",
      name = "Panel_5520",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(352.5, 362.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_worship",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(630, 444.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_raid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(705, 444.5)
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
      name = "layer_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(49.3, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_mercenary",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(780, 444.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_worship",
      res = "UI/alpha/1080P/guild/worship.png",
      name = "icon_worship",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_shop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(855, 444.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/guild/title_gulid.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_guildwar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(555, 444.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_top",
      res = "UI/alpha/1080P/guild/sign.png",
      name = "deco1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-27.5, 264)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vitality1",
      z = 1,
      parent = "Panel_5520",
      text = T("7\230\151\165\230\180\187\232\183\131\229\186\166"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_raid",
      res = "UI/alpha/1080P/guild/raid.png",
      name = "icon_raid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      name = "label_worship",
      z = 0,
      parent = "icon_worship",
      text = T("\229\133\172\228\188\154\232\134\156\230\139\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.75, -14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.199998968, h = 19.199998848},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_5520",
      res = "UI/alpha/1080P/icon/active.png",
      name = "vitality",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_weeklyjob",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 444)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_top",
      res = "UI/alpha/1080P/guild/sign.png",
      name = "deco2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-26.5, 238.5)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_top",
      res = "UI/alpha/1080P/guild/sign.png",
      name = "deco3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-27.5, 213.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_mercenary",
      res = "UI/alpha/1080P/guild/mercenary.png",
      name = "icon_mercenary",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      name = "label_find",
      z = 0,
      parent = "layer_top",
      text = T("\230\159\165\231\156\139"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-20.5, 295.5)
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
      name = "label_raid",
      z = 0,
      parent = "icon_raid",
      text = T("\229\155\162\233\152\159\229\137\175\230\156\172"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.25, -5.25)
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
      name = "guildname",
      z = 0,
      parent = "layer_top",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_manage",
      z = 0,
      parent = "layer_bottom",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop",
      res = "UI/alpha/1080P/guild/shop.png",
      name = "icon_shop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(111, 102, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guildid",
      z = 0,
      parent = "deco1",
      text = T("\229\133\172\228\188\154ID"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.25, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildid",
      z = 0,
      parent = "deco1",
      text = "1025581",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(219.25, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_top",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 358.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_log",
      z = 0,
      parent = "layer_bottom",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 32)
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
      name = "title_slogan",
      z = 0,
      parent = "layer_bottom",
      text = T("\229\133\172\228\188\154\229\174\163\232\168\128"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 176)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_guildwar",
      res = "UI/alpha/1080P/guild/clash.png",
      name = "icon_guildwar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(111, 102, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_member",
      z = 0,
      parent = "deco2",
      text = T("\229\133\172\228\188\154\228\186\186\230\149\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.25, 7.5)
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
      name = "label_mercenary",
      z = 0,
      parent = "icon_mercenary",
      text = T("\228\189\163\229\133\181\232\144\165\229\156\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 0.5)
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
      parent = "btn_guildwar",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_guildwar_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "member_num",
      z = 0,
      parent = "deco2",
      text = "32/50",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(218.75, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(102, 94, 85),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_slogan",
      z = 0,
      parent = "layer_bottom",
      text = "Text Label",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(71, 156.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bottom",
      res = "UI/alpha/1080P/guild/edit.png",
      name = "btn_setSlogan",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(161, 84.5)
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
      fix_wh = {w = 52.5, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_weeklyjob",
      res = "UI/alpha/1080P/guild/guild_weektask/icon.png",
      name = "icon_weeklyjob",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(111, 102, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_liveness",
      z = 0,
      parent = "deco3",
      text = T("\229\133\172\228\188\154\230\180\187\232\183\131"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.25, 7.5)
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
      parent = "btn_weeklyjob",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_weeklyjob_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.89999735, h = 15.89999735},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "deco3",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule_liveness",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84.75, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "liveness",
      z = 0,
      parent = "deco3",
      text = "99999999",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(219.75, 7.5)
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
      parent = "icon_shop",
      text = T("\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -3.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(348, 115)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_liveness_info",
      z = 0,
      parent = "deco3",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 25, 10, 175)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(183.25, -3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_find",
      res = "UI/alpha/1080P/guild/search.png",
      name = "btn_find",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, 36.5)
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
      name = "label_manage",
      z = 0,
      parent = "btn_manage",
      text = T("\229\133\172\228\188\154\232\174\190\231\189\174"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
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
      name = "label_log",
      z = 0,
      parent = "btn_log",
      text = T("\229\133\172\228\188\154\230\151\165\229\191\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
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
      name = "label_guildwar",
      z = 0,
      parent = "icon_guildwar",
      text = T("\229\133\172\228\188\154\230\136\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, -5.25)
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
      name = "label_weeklyjob",
      z = 0,
      parent = "icon_weeklyjob",
      text = T("\229\133\172\228\188\154\228\187\187\229\138\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, -2.25)
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
      parent = "btn_rule_liveness",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule_liveness",
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
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_mount",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402, 444)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_mount",
      res = "UI/alpha/1080P/guildmount/icon_guild.png",
      name = "icon_mount",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "btn_mount",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_mount_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 50)
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
      name = "label_mount",
      z = 0,
      parent = "icon_mount",
      text = T("\233\173\148\231\149\140\232\174\168\228\188\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, -4.25)
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
      parent = "btn_manage",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "btn_manage_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 36)
    }
  }
}
