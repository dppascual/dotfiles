local create_cmd = function(cmd, func, opt)
  opt = vim.tbl_extend('force', { desc = cmd }, opt or {})
  vim.api.nvim_create_user_command(cmd, func, opt)
end

create_cmd('GoAddTest', function(opts)
  require('user.lang.go.gotests').fun_test(unpack(opts.fargs))
end)

create_cmd('GoAddExpTest', function(opts)
  require('user.lang.go.gotests').exported_test(unpack(opts.fargs))
end, { nargs = '*' })

create_cmd('GoAddAllTest', function(opts)
  require('user.lang.go.gotests').all_test(unpack(opts.fargs))
end, { nargs = '*' })
