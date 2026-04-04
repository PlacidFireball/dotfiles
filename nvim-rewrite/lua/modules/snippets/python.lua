require("luasnip.session.snippet_collection").clear_snippets "python"

local luasnip = require "luasnip"
local s = luasnip.snippet
local i = luasnip.insert_node
local fmt = require "luasnip.extras.fmt".fmt

-- standard quiq script prelude
local init_source = [[
import quiq
import json
import argparse
from argparse import Namespace


def main(args: Namespace) -> None:
  client = quiq.client(args.cluster)
  tenant = args.tenant
  {}


if __name__ == '__main__':
  parser = argparse.ArgumentParser("{}")
  parser.add_argument('-c', '--cluster', required=True, help='The Quiq cluster to operate on', type=str, choices=quiq.CLUSTERS)
  parser.add_argument('-t', '--tenant', required=False, help='The Quiq tenant to operate on', type=str)
  args = parser.parse_args()
  main(args)
]]

luasnip.add_snippets("python", {
  s("init", fmt(init_source, { i(1, "application"), i(2) })),
  s("for", fmt([[
for {} in {}:
  {}
]], { i(1, "thing"), i(2, "things"), i(3, "pass")}))
})
