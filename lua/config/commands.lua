-- config.commands
-- User defined commands. These commands are loaded before the plugins.

local create_command = vim.api.nvim_create_user_command

-- Toggle format-on-save.

create_command("FormatDisable", function(args)
  if args.bang then
    vim.b.autoformat = false
  else
    vim.g.autoformat = false
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

create_command("FormatEnable", function(args)
  vim.b.autoformat = true
  vim.g.autoformat = true
end, {
  desc = "Re-enable autoformat-on-save",
})
