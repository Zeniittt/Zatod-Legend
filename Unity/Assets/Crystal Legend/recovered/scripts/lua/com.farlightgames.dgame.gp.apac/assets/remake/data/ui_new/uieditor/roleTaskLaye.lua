ed.uieditor = ed.uieditor or {}
ed.uieditor.roleTaskLaye = {
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
      name = "ui_layer_task",
      z = 7
    },
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
      scaleSize = CCSizeMake(778, 421.5)
    },
    t = "Layer",
    base = {
      parent = "ui_layer_task",
      name = "task_list_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(72.5, 62)
    }
  }
}
