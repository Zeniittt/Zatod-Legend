local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.packageres = class
local base = ed.ui.baseres
setmetatable(class, base.mt)
class.package = {
  list_key = {
    {
      key = "all",
      name = T("\229\133\168\233\131\168"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "consume",
      name = T("\230\182\136\232\128\151\229\147\129"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "equip",
      name = T("\232\163\133\229\164\135<key:noun>"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "scroll",
      name = T("\229\141\183\232\189\180"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "stone",
      name = T("\231\129\181\233\173\130\231\159\179"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "book",
      name = T("\228\185\166\230\156\172"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "rune",
      name = T("\231\172\166\231\159\179"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "eggs",
      name = T("\228\191\161\228\189\191\232\155\139"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "tarot",
      name = T("\229\141\161\229\140\133"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    }
  }
}
class.fragment = {
  list_key = {
    {
      key = "all",
      name = T("\229\133\168\233\131\168"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "equip",
      name = T("\232\163\133\229\164\135<key:noun>"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "scroll",
      name = T("\229\141\183\232\189\180"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "consume",
      name = T("\230\182\136\232\128\151\229\147\129"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "book",
      name = T("\228\185\166\233\161\181"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    },
    {
      key = "rune",
      name = T("\231\172\166\231\159\179"),
      btn_n_res = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      btn_s_res = "UI/alpha/HVGA/common/common_btn_hold_s.png"
    }
  }
}
