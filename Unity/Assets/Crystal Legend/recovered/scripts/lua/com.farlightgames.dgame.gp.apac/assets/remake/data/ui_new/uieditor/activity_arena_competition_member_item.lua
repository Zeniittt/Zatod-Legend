ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_arena_competition_member_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 642.5, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_memberexecl2.png",
      name = "bg",
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
      color = ccc3(255, 215, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_job",
      z = 0,
      parent = "bg",
      text = T("\228\188\154\233\149\191"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(88.75, 33.5)
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
      name = "label_change_score_val",
      z = 0,
      parent = "bg",
      text = "999",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.25, 26)
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
      name = "label_total_score_val",
      z = 0,
      parent = "bg",
      text = "9999",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(544.75, 26)
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
      name = "label_player_name",
      z = 0,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\231\167\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(88.75, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.45, x = 0.45},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_10year.png",
      name = "head_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 25)
    }
  }
}
