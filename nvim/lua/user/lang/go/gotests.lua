-- Files taken from https://github.com/ray-x/go.nvim/tree/master/lua/go
-- Table driven tests based on its target source files' function and method signatures.
-- https://github.com/cweill/gotests
local ut = {}
local gotests = "gotests"
local gotests_template = ""
local gotests_template_dir = ""
local utils = require("user.lang.go.utils")
local empty = utils.empty
local run = function(setup)
  print(vim.inspect(setup))
  vim.fn.jobstart(setup, {
      stdout_buffered = true,
      on_stdout = function(_, data, _)
        print("unit tests generate " .. vim.inspect(data))
      end,
  })
end

local add_test = function(args)
  local gofile = vim.fn.expand("%")
  table.insert(args, "-w")
  table.insert(args, gofile)
  run(args)
end

local new_gotests_args = function(parallel)
  local args = { gotests }
  if parallel then
    table.insert(args, "-parallel")
  end
  if string.len(gotests_template) > 0 then
    table.insert(args, "-template")
    table.insert(args, gotests_template)
  end
  if string.len(gotests_template_dir) > 0 then
    table.insert(args, "-template_dir")
    table.insert(args, gotests_template_dir)
  end
  return args
end

ut.fun_test = function(parallel)
  local ns = require("user.lang.go.ts.go").get_func_method_node_at_pos()
  if empty(ns) then
    return
  end
  if ns == nil or ns.name == nil then
    return
  end
  -- utils.log("parnode" .. vim.inspect(ns))
  local funame = ns.name
  -- local rs, re = ns.dim.s.r, ns.dim.e.r
  local args = new_gotests_args(parallel)
  table.insert(args, "-only")
  table.insert(args, funame)
  add_test(args)
end

ut.all_test = function(parallel)
  local args = new_gotests_args(parallel)
  table.insert(args, "-all")
  add_test(args)
end

ut.exported_test = function(parallel)
  local args = new_gotests_args(parallel)
  table.insert(args, "-exported")
  add_test(args)
end

return ut
