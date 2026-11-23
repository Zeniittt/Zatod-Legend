ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_arena_competition_member_title = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 642.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_memberexecl1.png",
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
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_member_des",
      z = 0,
      parent = "bg",
      text = T("\229\133\172\228\188\154\230\136\144\229\145\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_change_score_des",
      z = 0,
      parent = "bg",
      text = T("\230\152\168\230\151\165\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_score_des",
      z = 0,
      parent = "bg",
      text = T("\230\128\187\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(544.75, 19)
    }
  }
}
