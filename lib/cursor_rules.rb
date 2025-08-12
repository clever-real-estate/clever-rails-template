def setup_cursor_rules
  if File.exist?('.cursor/rules/rails')
    puts "Cursor rules already exist in the project"
  else
    empty_directory '.cursor/rules'
    puts "Created .cursor/rules directory - you can add cursor_rules_rails as a submodule here"
  end
end