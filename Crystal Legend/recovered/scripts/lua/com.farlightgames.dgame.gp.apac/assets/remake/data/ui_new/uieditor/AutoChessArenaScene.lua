ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessArenaScene = {
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156, 156)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_leisure",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(63, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 222, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_leisure",
      res = "UI/alpha/1080P/chess/main/ribbon_2.png",
      name = "btn_leisure",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 228, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_12121",
      z = 0,
      parent = "btn_leisure",
      text = T("\228\188\145\233\151\178\230\168\161\229\188\143"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156, 174)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_pvp",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(402.5, 214)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(107, 136)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_pve",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(745, 277)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 285.5, h = 84.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pvp",
      res = "UI/alpha/1080P/chess/main/ribbon_1.png",
      name = "btn_pvp",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77, -31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 125.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/main/season_bg.png",
      name = "bg_season",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(480, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_12118",
      z = 0,
      parent = "btn_pvp",
      text = T("\229\164\169\230\162\175"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.75, 32.75)
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
      position = ccp(66, 509)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 222, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pve",
      res = "UI/alpha/1080P/chess/main/ribbon_2.png",
      name = "btn_pve",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, -23)
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
      name = "btn_book",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(910, 505)
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
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(986.5, 505)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(216, 197, 250),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rest",
      z = 0,
      parent = "bg_season",
      text = T("\228\188\145\232\181\155\228\184\173"),
      size = 50
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(336.5, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 228, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_12119",
      z = 0,
      parent = "btn_pve",
      text = T("\228\186\186\230\156\186\230\168\161\229\188\143"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 28.25)
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
      parent = "bg_season",
      name = "layer_inseason",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/chess/main/title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.25, 17.75)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.25, 15.25)
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
      name = "label_compendium",
      z = 1,
      parent = "btn_book",
      text = T("\229\155\190\233\137\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 201},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_inseason",
      res = "UI/alpha/1080P/chess/season/5.png",
      name = "iconGrade1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-451.5, 87.5)
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
      name = "labelSeasonReward0",
      z = 0,
      parent = "layer_inseason",
      text = T("\229\143\175\232\142\183\229\190\151"),
      size = 21
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(364, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_book",
      res = "UI/alpha/1080P/chess/main/wiki.png",
      name = "icon_compendium",
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
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "labelSeasonRewardGradeTarget",
      z = 0,
      parent = "layer_inseason",
      text = T("\232\190\190\229\136\176\233\187\132\233\135\145\230\174\181\228\189\141"),
      size = 21
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(365, 83.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "labelSeasonTimespan",
      z = 0,
      parent = "layer_inseason",
      text = "2019.6.1-2019.8.3",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-338, 33)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_inseason",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "iconSeasonReward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.5, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 222, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_season_id",
      z = 0,
      parent = "layer_inseason",
      text = "S3",
      size = 60
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(-263.5, 80)
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
      name = "label_season",
      z = 0,
      parent = "layer_inseason",
      text = T("\232\181\155\229\173\163"),
      size = 43
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-251, 80)
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
      parent = "layer_inseason",
      name = "layer_info",
      z = 1
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
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 1,
      parent = "btn_rank",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.3, h = 105.3},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_inseason",
      res = "UI/alpha/1080P/taskModel/player_award_list_item_eff.png",
      name = "reward_light",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.5, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_inseason",
      res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
      name = "reward_mask",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.5, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 44.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 42)
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
      name = "ImageView_1339",
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
      fix_wh = {w = 86, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "iconGrade1",
      res = "UI/alpha/1080P/chess/main/bg_score.png",
      name = "ImageView_12122",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-513.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-488.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-463.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-438.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-413.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-388.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_mask",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "ImageView_6641",
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
      fix_wh = {w = 281, h = 72.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_pvp",
      res = "UI/alpha/1080P/chess/main/rank_bg.png",
      name = "ImageView_2902",
      z = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.75, 119.75)
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
      name = "labelGradeName",
      z = 1,
      parent = "ImageView_2902",
      text = T("\232\141\163\232\128\128\229\155\189\231\142\139"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 204, 93),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score",
      z = 0,
      parent = "ImageView_2902",
      text = "10",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2902",
      res = "UI/alpha/1080P/chess/season/1_1.png",
      name = "iconGrade",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 25.25)
    }
  }
}
