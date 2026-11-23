local list = {
  "ui/mgr/dreamlandrankdetail"
}
for i, v in ipairs(list) do
  package.loaded[v] = nil
  require(v)
end
