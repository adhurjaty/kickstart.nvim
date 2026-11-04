local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s("pry", t("require 'pry'; binding.pry")),
  s("pryr", t("require 'pry-remote'; binding.remote_pry")),
}
