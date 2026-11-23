ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsSeasonHistoryItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 280, h = 512},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/season_record_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_season_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\181\155\229\173\163"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 464.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_season_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(139, 430.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.55, x = 0.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72.05, h = 80.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/rank/rank_1.png",
      name = "image_rank_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 322.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(138, 80, 23),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_name",
      z = 0,
      parent = "image_bg",
      text = T("\228\184\135\229\143\164\230\181\129\232\138\179"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 249.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "final_score_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 198.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "match_count_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 171)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "match_win_rate_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "final_ranking_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 116)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "final_score_tips",
      z = 0,
      parent = "final_score_bg",
      text = T("\230\156\128\231\187\136\231\167\175\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "match_count_tips",
      z = 0,
      parent = "match_count_bg",
      text = T("\230\175\148\232\181\155\229\156\186\230\172\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "match_win_rate_tips",
      z = 0,
      parent = "match_win_rate_bg",
      text = T("\230\175\148\232\181\155\232\131\156\231\142\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "match_count",
      z = 0,
      parent = "match_count_bg",
      text = "1234",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(93.5, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "match_win_rate",
      z = 0,
      parent = "match_win_rate_bg",
      text = "66.6%",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(93.5, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "final_ranking_tips",
      z = 0,
      parent = "final_ranking_bg",
      text = T("\230\156\128\231\187\136\230\142\146\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  }
}
