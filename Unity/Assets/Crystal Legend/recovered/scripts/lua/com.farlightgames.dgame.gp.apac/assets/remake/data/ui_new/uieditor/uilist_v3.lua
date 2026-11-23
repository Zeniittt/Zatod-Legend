local list = {
  "ui_new/uieditor/headline",
  "ui_new/uieditor/herodetailSkDemo"
}
for i, v in ipairs(list) do
  package.loaded[v] = nil
  require(v)
end
