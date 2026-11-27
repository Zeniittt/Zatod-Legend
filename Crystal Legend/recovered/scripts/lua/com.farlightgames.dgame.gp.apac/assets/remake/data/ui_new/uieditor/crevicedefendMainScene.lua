ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendMainScene = {
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
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 566)
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
      parent = "bg_title",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(194.75, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 400)
    },
    t = "Layer",
    base = {name = "panel_left", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-82, -93.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      name = "panel_right",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(808.5, 253)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_Effect",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 400)
    },
    t = "Layer",
    base = {
      name = "panel_button",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-82, -93.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      name = "panel_reward",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(808.5, 253)
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
      parent = "panel_button",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_record",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 147.5)
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
      parent = "panel_button",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 218)
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
      parent = "panel_button",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_ranklist",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 289.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 34)
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
      parent = "btn_record",
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
      position = ccp(34, 35.5)
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
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop",
      z = 0,
      parent = "icon_record",
      text = T("\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, -4.75)
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
      position = ccp(21, -6)
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
      position = ccp(27.5, -3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 627.5, h = 605},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/crevicedefend/stone.png",
      name = "image_boss_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255, 299.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 551.5, h = 247.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_right",
      res = "UI/alpha/1080P/crevicedefend/time_bg.png",
      name = "image_boss_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-150, 86)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_reward",
      res = "UI/alpha/1080P/crevicedefend/rewardbutton.png",
      name = "btn_getreward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.5, -198)
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
      name = "label_getreward_num",
      z = 1,
      parent = "panel_reward",
      text = T("3/10\230\172\161"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, -234.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 324.5, h = 5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/bossline.png",
      name = "image_boss_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319.25, 551)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83, h = 470},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_reward",
      res = "UI/alpha/1080P/crevicedefend/reward_line.png",
      name = "bg_reward_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, -16.5)
    }
  },
  {
    config = {
      rotation = 9.74549,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_reward",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_redpoint",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, -180)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -81, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/arrows.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 380)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/arrows.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(543.75, 380.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 286.5, h = 210},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/bossbg.png",
      name = "image_boss",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.75, 402.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/bosstag.png",
      name = "image_boss_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.25, 512.5)
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
      parent = "image_boss_des",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.75, 188.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(121, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "root_boss_activities_des",
      z = 0,
      parent = "image_boss_des",
      res = "UI/alpha/1080P/crevicedefend/skilltitle.png",
      capInsets = CCRectMake(15, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.75, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(121, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "root_activities_des",
      z = 0,
      parent = "image_boss_des",
      res = "UI/alpha/1080P/crevicedefend/skilltitle.png",
      capInsets = CCRectMake(50, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.75, 139.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 312, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_des",
      res = "UI/alpha/1080P/crevicedefend/recommend_line.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239.75, 65.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "image_boss_des",
      name = "skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(87.25, -41.25)
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
      name = "label_boss_des",
      z = 1,
      parent = "image_boss_des",
      text = T("Boss\230\138\128\232\131\189"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101.25, 43.25)
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
      name = "label_activities_des",
      z = 1,
      parent = "image_boss_des",
      text = T("Boss\228\187\139\231\187\141 "),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101.25, 139.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 150)
    },
    t = "Layer",
    base = {
      parent = "image_boss_bg",
      name = "layer_boss",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(121.25, 332)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/dps_bg.png",
      name = "image_total_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315.25, 289.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/dps_bg.png",
      name = "image_current_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(316.75, 235.5)
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
      name = "label_activities_des_content",
      z = 0,
      parent = "image_boss_des",
      text = T("\230\183\177\230\184\138\229\164\167\229\134\155\231\154\132\230\130\178\233\184\163\229\183\178\231\187\143\229\147\141\229\189\187\229\140\151\229\162\131--\229\164\167\230\137\185\229\176\184\233\172\188\230\182\140\229\144\145\228\184\180\229\134\172\229\159\142\239\188\129"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255.75, 98.75)
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
      name = "label_across_rank",
      z = 0,
      parent = "image_boss_bg",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(317.25, 130)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "image_boss_des",
      name = "skill3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(249.25, -41.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "image_boss_des",
      name = "skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(166.75, -41.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "image_boss_des",
      name = "skill4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(327.75, -41.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "image_boss_des",
      name = "layer_season_open",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(195.25, -175.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "image_boss_des",
      name = "layer_season_close",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(191.75, -146.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 663, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/main_shading.png",
      name = "image_current_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323.25, 172.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_line",
      res = "UI/alpha/1080P/crevicedefend/bossicon1.png",
      name = "stage1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10.25, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_line",
      res = "UI/alpha/1080P/crevicedefend/bossicon1.png",
      name = "stage3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.75, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_line",
      res = "UI/alpha/1080P/crevicedefend/bossicon1.png",
      name = "stage2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.25, 2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_line",
      res = "UI/alpha/1080P/crevicedefend/bossicon1.png",
      name = "stage5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.75, 2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_line",
      res = "UI/alpha/1080P/crevicedefend/bossicon1.png",
      name = "stage4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.75, 1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(267, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_dps",
      z = 0,
      parent = "image_boss_bg",
      res = "UI/alpha/1080P/crevicedefend/total_dps.png",
      capInsets = CCRectMake(150, 25, 50, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(317.25, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196.5, h = 25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_season_open",
      res = "UI/alpha/1080P/guildmount/award_timesbackground2.png",
      name = "bg_extra_time",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 70.5)
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
      name = "label_extra_num",
      z = 1,
      parent = "layer_season_open",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 350)
    },
    t = "Layer",
    base = {
      parent = "bg_reward_line",
      name = "layer_boss_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11, 88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(88.59, 82.5)
    },
    t = "Layer",
    base = {
      parent = "bg_reward_line",
      name = "btn_reward_line",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-3, 6)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(88.59, 82.5)
    },
    t = "Layer",
    base = {
      parent = "bg_reward_line",
      name = "btn_reward_line_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-3, 438)
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
      name = "label_total_damage",
      z = 0,
      parent = "image_total_damage",
      text = "111111111111111111",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.25, -13.25)
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
      name = "label_total_damage_des",
      z = 0,
      parent = "image_total_damage",
      text = T("\230\128\187\228\188\164\229\174\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 12.75)
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
      name = "label_current_damage_des",
      z = 0,
      parent = "image_current_damage",
      text = T("\229\189\147\229\137\141\228\188\164\229\174\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 13.25)
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
      name = "label_current_damage",
      z = 0,
      parent = "image_current_damage",
      text = "11111111111111111",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.25, -13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 217, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_season_open",
      res = "UI/alpha/1080P/crevicedefend/startbutton.png",
      name = "btn_attack",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 27)
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
      name = "label_arena_rank",
      z = 2,
      parent = "image_current_rank",
      text = T("\232\181\155\229\140\186\230\142\146\229\144\141: "),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(263.5, 47.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "stage1",
      res = "UI/alpha/1080P/crevicedefend/bossicon2.png",
      name = "stage1_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "stage2",
      res = "UI/alpha/1080P/crevicedefend/bossicon2.png",
      name = "stage2_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "stage3",
      res = "UI/alpha/1080P/crevicedefend/bossicon2.png",
      name = "stage3_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "stage5",
      res = "UI/alpha/1080P/crevicedefend/bossicon2.png",
      name = "stage5_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "stage4",
      res = "UI/alpha/1080P/crevicedefend/bossicon2.png",
      name = "stage4_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_season_open",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "chance_add_btn",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 67)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 231.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_season_open",
      res = "UI/alpha/1080P/crevicedefend/addtimes.png",
      name = "image_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 67)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 285, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_season_close",
      res = "UI/alpha/1080P/crevicedefend/ending_baseplate.png",
      name = "ImageView_33869",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 52.5)
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
      name = "label_arena_Rank2",
      z = 0,
      parent = "image_current_rank",
      text = "",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(346.5, 47.75)
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
      parent = "image_current_rank",
      name = "layer_arena_Rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(346.5, 47.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(203, 167, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_extra_num_rule",
      z = 1,
      parent = "layer_season_open",
      text = T("\230\175\143\230\151\1655\231\130\185\229\162\158\229\138\1605\230\172\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, -14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186, h = 79},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_season_open",
      res = "UI/alpha/1080P/crevicedefend/freetime_bg.png",
      name = "image_time_bg_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(77, 237, 69),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_attack",
      z = 1,
      parent = "btn_attack",
      text = "",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 34.5)
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
      parent = "btn_attack",
      name = "layer_attack",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(106.5, 34.5)
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
      name = "label_season",
      z = 0,
      parent = "ImageView_33869",
      text = T("\230\183\177\230\184\138\229\164\167\229\134\155\231\154\132\230\130\178\233\184\163\229\183\178\231\187\143\229\147\141\229\189\187\229\140\151\229\162\131--\229\164\167\230\137\185\229\176\184\233\172\188\230\182\140\229\144\145\228\184\180\229\134\172\229\159\142\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.5, 13.25)
    }
  }
}
