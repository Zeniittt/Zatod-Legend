ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountMainScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 504.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 26.5, h = 26.5},
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
      normal = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_tips",
      z = 2,
      parent = "bg_title",
      text = "",
      press = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.75, 18.25)
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
      parent = "btn_tips",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_207",
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
      fix_wh = {w = 218.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/endtime.png",
      name = "bg_endtime",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 451.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_future_title",
      z = 6,
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/futureshow_1.png",
      capInsets = CCRectMake(50, 10, 3, 6.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 404)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_endtime",
      z = 0,
      parent = "bg_endtime",
      text = T("\229\176\134\229\156\1685\230\156\13627\230\151\16523\230\151\182\229\133\179\233\151\173\230\140\145\230\136\152"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(10.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/changecloth.png",
      name = "btn_changecloth",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(661.5, 83)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_reward",
      z = 10,
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/award_background.png",
      capInsets = CCRectMake(100, 25, 17, 33)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(119.5, 54)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_future_title",
      res = "UI/alpha/1080P/guildmount/futureshow_icon.png",
      name = "ImageView_1089",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-13, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_boss_title",
      z = 0,
      parent = "bg_future_title",
      text = T("Boss\229\137\141\231\158\187"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(14, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 165.5, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/guildrank.png",
      name = "bg_guild_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(975, 487)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_future_title",
      res = "UI/alpha/1080P/guildmount/futureshow_button.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(161.5, 13.25)
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
      name = "layer_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      name = "Label_1100",
      z = 0,
      parent = "btn_changecloth",
      text = T("\230\141\162\232\163\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 5)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_shop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(985, 237.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_reward",
      res = "UI/alpha/1080P/guildmount/award_bigicon.png",
      name = "icon_chanllenge_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 43)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/guildmount/futureshow_3.png",
      name = "icon_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 259, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/bossname_board.png",
      name = "boss_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(729, 405)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(522, 10)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_reward_bar",
      z = 0,
      parent = "bg_reward",
      res = "UI/alpha/1080P/guildmount/award_line2.png",
      capInsets = CCRectMake(45, 2.5, 12, 5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(96, 43.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(985, 313)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_ranklist",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(985, 389)
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
      name = "Label_1123",
      z = 0,
      parent = "bg_guild_rank",
      text = T("\229\133\172\228\188\154\230\142\146\229\144\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1124",
      z = 0,
      parent = "bg_guild_rank",
      text = T("\230\156\170\228\184\138\230\166\156"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 210)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_1540",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(620.5, 178.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_guild_rank",
      res = "UI/alpha/1080P/guildmount/corner_background.png",
      name = "ImageView_2301",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 6.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213.5, h = 65.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/bg_season_end.png",
      name = "bg_season_end",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 488)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(324.5, 208)
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
      name = "Label_1103",
      z = 0,
      parent = "icon_chanllenge_time",
      text = T("\230\140\145\230\136\152\230\172\161\230\149\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward_point",
      z = 0,
      parent = "icon_chanllenge_time",
      text = "10",
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431.5, 200)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 623.5, h = 29},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/notice_bg.png",
      name = "notice_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 471.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(394.5, 253)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10.5, 10)
    },
    t = "Scale9Sprite",
    base = {
      name = "reward_bar",
      z = 0,
      parent = "bg_reward_bar",
      res = "UI/alpha/1080P/guildmount/award_line1.png",
      capInsets = CCRectMake(5, 2.5, 90.5, 5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(439.5, 343.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(116, 116)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "btn_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(898, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(373, 117.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(211, 200)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 102)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_3472",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-54.5, 297.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 127)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.5, 266)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "pos9",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(331, 328)
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
      position = ccp(33, 39)
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
      name = "name_boss",
      z = 0,
      parent = "boss_name_bg",
      text = T("\231\172\172\228\186\140\232\189\174 \229\134\165\231\129\171\233\170\168\229\188\147(Lv.55)"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(24, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_area",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "boss_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(723.5, 199.5)
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
      parent = "btn_shop",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "recordTag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
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
      name = "Label_2302",
      z = 0,
      parent = "ImageView_2301",
      text = T("1\232\181\155\229\140\186"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "icon_reward",
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
      fix_wh = {w = 55, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ranklist",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_ranklist",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 38.5)
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
      name = "Label_2640",
      z = 0,
      parent = "bg_season_end",
      text = T("\230\175\148\232\181\155\231\187\147\230\157\159"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.75, 43.25)
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
      position = ccp(24, -7)
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
      name = "Label_2641",
      z = 0,
      parent = "bg_season_end",
      text = "Text Label",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.75, 13.25)
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
      name = "label_reward",
      z = 0,
      parent = "icon_reward",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, -5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169, h = 169},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_challenge",
      res = "UI/alpha/1080P/guildmount/challenge.png",
      name = "fca_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(157, 158, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1121",
      z = 1,
      parent = "btn_challenge",
      text = T("\230\175\143\230\151\1655\231\130\185\230\129\162\229\164\1413\230\172\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59, -13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_challenge",
      res = "UI/alpha/1080P/guildmount/award_timesbackground2.png",
      name = "bg_extra_time",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 137)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_challenge",
      res = "UI/alpha/1080P/guildmount/challenge_background.png",
      name = "ImageView_1754",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(197.5, 100)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_future",
      z = 4,
      parent = "Panel_3472",
      res = "UI/alpha/1080P/guildmount/futureshow_2.png",
      capInsets = CCRectMake(10, 9, 7.5, 9)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(100, 101.5)
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
      name = "label_ranklist",
      z = 0,
      parent = "icon_ranklist",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, -6.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_extra_time",
      z = 0,
      parent = "bg_extra_time",
      text = T("\230\136\152\230\150\151\232\161\165\230\151\182:25\231\167\146"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.25, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1119",
      z = 0,
      parent = "ImageView_1754",
      text = T("\230\140\145\230\136\152"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 15)
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
      parent = "bg_future",
      res = "UI/alpha/1080P/guildmount/futureshow_selected.png",
      name = "future1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 59)
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
      name = "label_challenge_time",
      z = 0,
      parent = "ImageView_1754",
      text = "(3/9)",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101, 15)
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
      parent = "bg_future",
      res = "UI/alpha/1080P/guildmount/futureshow_unselected.png",
      name = "future2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, 59)
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
      parent = "bg_future",
      res = "UI/alpha/1080P/guildmount/futureshow_unselected.png",
      name = "future3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.25, 59)
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
      name = "round1",
      z = 0,
      parent = "bg_future",
      text = T("\231\172\1721\232\189\174"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 22.5)
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
      name = "round3",
      z = 0,
      parent = "bg_future",
      text = T("\231\172\1723\232\189\174"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.25, 22.5)
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
      name = "round2",
      z = 0,
      parent = "bg_future",
      text = T("\231\172\1722\232\189\174"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 284, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/challenge/time_board.png",
      name = "bg_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 500)
    }
  }
}
