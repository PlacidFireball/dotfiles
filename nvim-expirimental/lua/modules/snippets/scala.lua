require("luasnip.session.snippet_collection").clear_snippets "scala"

local luasnip = require "luasnip"
local s = luasnip.snippet
local i = luasnip.insert_node
local fmt = require "luasnip.extras.fmt".fmt

luasnip.add_snippets("scala", {
  s("fe", fmt("foreach {{ {} =>\n\t{}\n}}", { i(1, "iter_var"), i(2, "body") })),
  s("m", fmt("map {{ {} =>\n\t{}\n}}", { i(1, "iterVar"), i(2, "body") })),
  s("main", fmt("def main(args: Array[String]): Unit = {{\n{}\n}}", { i(1) })),
  s("cc", fmt("case class {}(\n\t{}\n)", { i(1, "MyCaseClass"), i(2) })),
  s("cls", fmt("class {}() {{\n}}", { i(1, "MyClass") })),
  s("obj", fmt("object {} {{\n}}", { i(1, "MyObject") })),
  s("at", fmt("{}: {},", { i(1, "name"), i(2, "Type") })),
})

print("loaded scala snippets")
